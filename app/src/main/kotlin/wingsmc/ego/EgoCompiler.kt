package wingsmc.ego

import org.antlr.v4.runtime.CharStreams
import org.antlr.v4.runtime.CommonTokenStream
import wingsmc.ego.grammar.EgoV2Lexer
import wingsmc.ego.grammar.EgoV2Parser
import wingsmc.ego.modules.EgoModuleCache
import wingsmc.ego.modules.EgoModuleVisitor
import java.io.FileInputStream
import java.io.FileNotFoundException
import java.io.IOException
import java.nio.file.Paths

fun readAST(file: String): EgoV2Parser.ModuleFileContext? {
    try {
        val input = CharStreams.fromStream(FileInputStream(file))

        val lexer = EgoV2Lexer(input)
        val tokens = CommonTokenStream(lexer)
        val parser = EgoV2Parser(tokens)

        return parser.moduleFile()
    } catch (e: FileNotFoundException) {
        System.err.println("Invalid file path")
    } catch (e: IOException) {
        System.err.println("Couldn't process file")
    }

    return null
}

fun processRootFolder(folder: String): Boolean {
    val root = Paths.get(folder)
    val files = root.toFile().listFiles()
    if (files == null) {
        System.err.println("Invalid folder path")
        return false
    }

    val entry = files.find { it.name == "main.ego" }
    if (entry == null) {
        System.err.println("Couldn't find main.ego")
        return false
    }

    val moduleVisitor = EgoModuleVisitor("main")
    val ast = readAST(entry.absolutePath)
    if (ast == null) {
        System.err.println("Couldn't parse file")
        return false
    }

    if (moduleVisitor.visit(ast) == null) return false
    val visitor = EgoVisitor(moduleVisitor.name)

    println(visitor)
    return true
}

fun main(args: Array<String>) {
    if (processRootFolder("./app/src/test/example/src"))
        EgoModuleCache.save()
}
