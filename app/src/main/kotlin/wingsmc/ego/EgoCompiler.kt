package wingsmc.ego

import org.antlr.v4.runtime.CharStreams
import org.antlr.v4.runtime.CommonTokenStream
import wingsmc.ego.grammar.EgoV2Lexer
import wingsmc.ego.grammar.EgoV2Parser
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

fun main(args: Array<String>) {
    val visitor = EgoModuleVisitor("Test")
    val ast = readAST("ModuleTest.ego")

    if (ast == null) {
        System.err.println("Couldn't parse file")
        return
    }

    visitor.visit(ast)
    println(visitor)
}
