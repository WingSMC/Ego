package wingsmc.ego

import org.antlr.v4.runtime.CharStreams
import org.antlr.v4.runtime.CommonTokenStream
import wingsmc.ego.grammar.EgoLexer
import wingsmc.ego.grammar.EgoParser
import java.io.File
import java.io.FileInputStream
import java.io.FileNotFoundException
import java.io.IOException
import java.nio.file.Paths

fun readAST(file: String): EgoParser.ProgContext? {
    try {
        val input = CharStreams.fromStream(FileInputStream(file))

        val lexer = EgoLexer(input)
        val tokens = CommonTokenStream(lexer)
        val parser = EgoParser(tokens)

        return parser.prog()
    } catch (e: FileNotFoundException) {
        System.err.println("Invalid file path")
    } catch (e: IOException) {
        System.err.println("Couldn't process file")
    }
    return null
}

fun main(args: Array<String>) {
    val visitor = EgoVisitor()
    val ast = readAST("ModuleTest.ego")

    if (ast == null) {
        System.err.println("Couldn't parse file")
        return
    }

    val llvmIR = visitor.visit(ast)

    println(llvmIR.instructions)
    File("ModuleTest.ll").writeText(llvmIR.instructions)
}

