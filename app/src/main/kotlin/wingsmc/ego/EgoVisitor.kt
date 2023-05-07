package wingsmc.ego

import wingsmc.ego.grammar.EgoV2Parser
import wingsmc.ego.grammar.EgoV2ParserBaseVisitor

class EgoVisitor(private val moduleName: String) : EgoV2ParserBaseVisitor<Any>() {
    private val output = StringBuilder()

    override fun visitModuleFile(ctx: EgoV2Parser.ModuleFileContext?): Any {
        output.append("; ModuleID = '$moduleName'\n")
        output.append("source_filename = \"$moduleName.ego\"\n\n")
        output.append("declare i32 @printf(i8*, ...)\n\n")

        return super.visitModuleFile(ctx)
    }

    fun getLLVM(): String {
        return this.output.toString()
    }
}