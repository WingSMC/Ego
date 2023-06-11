package wingsmc.ego

import wingsmc.ego.grammar.EgoV2Parser
import wingsmc.ego.grammar.EgoV2ParserBaseVisitor
import wingsmc.ego.modules.EgoModuleCache
import wingsmc.ego.types.EgoFunctionType
import wingsmc.ego.types.EgoType
import wingsmc.ego.types.EgoTypes

data class Result(val type: EgoType = EgoTypes.VOID, val register: String = "", val instructions: String) {
    override fun toString() = "${type.llvmType} $register"
}

class EgoVisitor(val moduleName: String) : EgoV2ParserBaseVisitor<Result>() {
    val output = StringBuilder()
    val scope = EgoModuleCache.rootScope.getScope(moduleName)!!
    private var instructionCounter = 1

    override fun visitModuleFile(ctx: EgoV2Parser.ModuleFileContext): Result {
        output.append("; ModuleID = '$moduleName'\n")
        output.append("source_filename = \"$moduleName.ego\"\n")
        output.append("module.data_layout = 'e-m:e-i64:64-f80:128-n8:16:32:64-S128'\n")
        output.append("declare i32 @printf(i8*, ...)\n\n")

        ctx.moduleMemberDefinition().forEach { output.append(visit(it).instructions) }

        return Result(instructions = output.toString())
    }

    override fun visitFunctionDeclaration(ctx: EgoV2Parser.FunctionDeclarationContext): Result {
        this.instructionCounter = 1
        val thisFunction = scope.getSymbol(ctx.ID().text) ?: run {
            System.err.println("Function ${ctx.ID().text} not found in ${scope.scopeName} @ line${getErrorTagline(ctx)}")
            return Result(EgoTypes.ERROR_TYPE, instructions = "")
        }
        val thisFunctionType = thisFunction.type as EgoFunctionType
        val body = visit(ctx.lambdaExpr().blockStmt())
        if (body.type != thisFunctionType.returnType) {
            System.err.println("Function ${ctx.ID().text} returns ${body.type} but should return ${thisFunctionType.returnType} @ line${getErrorTagline(ctx)}")
        }
        val ir = StringBuilder()
        ir.append(thisFunctionType.getLLVMDefinition(thisFunction.name, thisFunction.visibility, body.instructions))
        return Result(
            thisFunctionType.returnType,
            thisFunction.llvmRegister,

        )
    }

    override fun visitBlockStmt(ctx: EgoV2Parser.BlockStmtContext): Result {
        val results = ctx.stmt().map { visit(it) }
        if (results.isEmpty()) {
            System.err.println("Empty block ${scope.scopeName} @ line${getErrorTagline(ctx)}")
        }

        return Result(
            results.last().type,
            results.last().register,
            instructions = results.joinToString("\n") { it.instructions },
        )
    }

    override fun toString() = output.toString()
}
