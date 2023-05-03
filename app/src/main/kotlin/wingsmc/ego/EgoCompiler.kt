package wingsmc.ego;

import org.antlr.v4.runtime.*
import org.antlr.v4.runtime.tree.*

fun main(args: Array<String>) {
    // Create an input stream from the input file
    val input = CharStreams.fromFileName("input.txt")

    // Create a lexer that reads from the input stream
    val lexer = EgoLexer(input)

    // Create a token stream from the lexer
    val tokens = CommonTokenStream(lexer)

    // Create a parser that reads from the token stream
    val parser = MyGrammarParser(tokens)

    // Parse the input file and get the root of the parse tree
    val tree = parser.myRule()

    // Create a visitor and visit the parse tree
    val visitor = MyVisitor()
    val result = visitor.visit(tree)

    // Do something with the visitor's result
    println(result)
}
