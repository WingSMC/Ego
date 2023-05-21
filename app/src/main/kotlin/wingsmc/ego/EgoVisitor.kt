package wingsmc.ego

import wingsmc.ego.grammar.EgoBaseVisitor
import wingsmc.ego.grammar.EgoParser.*

data class Result(val type: String, val register: String, val instructions: String) {
    override fun toString(): String {
        return "$type $register"
    }
}
data class FuncType(val returnType: String, val params: List<String>)

class EgoVisitor: EgoBaseVisitor<Result>() {
    private var instructionCounter = 1
    private val functionTypeMap = mutableMapOf<String, FuncType>()
    private val symbols = mutableMapOf<String, String>()

    override fun visitProg(ctx: ProgContext): Result {
        val functionDefinitions = ctx.functionDefinition().map { visit(it) }

        return Result(
            "",
            "",
            """
            source_filename = "ModuleTest.ego"
            target triple = "x86_64-pc-linux-gnu"
            target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
            ${functionDefinitions.joinToString("\n") { it.instructions }}
            """.trimIndent()
        )
    }

    override fun visitFunctionDefinition(ctx: FunctionDefinitionContext): Result {
        instructionCounter = 1
        val returnType = visit(ctx.type()).type
        val functionName = ctx.identifier().text
        val paramResults = ctx.parameter().map { visit(it) }
        functionTypeMap[functionName] = FuncType(returnType, paramResults.map { it.instructions })
        val blockContent = visit(ctx.block())
        val params = paramResults.joinToString(", ")
        val body =
        """
        define $returnType @$functionName($params) nounwind {
        ${blockContent.instructions}
        }
        """.trimIndent()

        return Result(
            returnType,
            "@$functionName",
            body,
        )
    }

    override fun visitParameter(ctx: ParameterContext): Result {
        val paramType = visit(ctx.type()).type
        val paramName = ctx.identifier().text
        symbols[paramName] = paramType
        return Result(paramType, "%$paramName", "")
    }

    override fun visitType(ctx: TypeContext): Result {
        return Result(when (ctx.text) {
            "u8" -> "i8"
            "u16" -> "i16"
            "u32" -> "i32"
            "u62" -> "i64"
            "i8" -> "i8"
            "i16" -> "i16"
            "i32" -> "i32"
            "i64" -> "i64"
            "char" -> "i8"
            "bool" -> "i1"
            "void" -> "void"
            "f32" -> "float"
            "f64" -> "double"
            else -> throw Exception("Unknown type ${ctx.text}")
        }, "", "")
    }

    override fun visitReturnStatement(ctx: ReturnStatementContext): Result {
        val expr = ctx.expression()

        val v =
            if (expr == null)
                Result("void", "", "")
            else visit(expr)

        return Result(
            v.type,
            v.register,
            """
            ${v.instructions}
            ret ${v.type} ${v.register}
            """.trimIndent()
        )
    }

    override fun visitBlock(ctx: BlockContext): Result {
        val results = ctx.statement().map { visit(it) }
        if (results.isEmpty()) {
            throw Exception("Empty block @ line ${ctx.start.line}")
        }
        return Result(
            results.last().type,
            results.last().register,
            results.joinToString("\n") { it.instructions }
        )
    }

    override fun visitIfExpression(ctx: IfExpressionContext): Result {
        val condition = visit(ctx.condition())
        if (condition.type != "i1") {
            throw Error("Condition must be of type bool @ line ${ctx.start.line}")
        }
        val trueLabel = instructionCounter++
        val trueBranch = visit(ctx.statement(0))
        val falseLabel = instructionCounter++
        val falseBranch = visit(ctx.statement(1))
        val endLabel = instructionCounter++
        val type = trueBranch.type;

        return Result(
            type,
            "%$instructionCounter",
            """
            ${condition.instructions}
            br i1 ${condition.register}, label %$trueLabel, label %$falseLabel
            ; <label>:$trueLabel
            ${trueBranch.instructions}
            br label %$endLabel
            ; <label>:$falseLabel
            ${falseBranch.instructions}
            br label %$endLabel
            ; <label>:$endLabel
            phi $type [${trueBranch.register}, %$trueLabel], [${falseBranch.register}, %$falseLabel]
            """.trimIndent()
        )
    }

    override fun visitMul(ctx: MulContext): Result {
        val leftExpr = visit(ctx.expression(0))
        val rightExpr = visit(ctx.expression(1))
        return binaryExpression("mul", leftExpr, rightExpr, leftExpr.type)
    }

    override fun visitSub(ctx: SubContext): Result {
        val leftExpr = visit(ctx.expression(0))
        val rightExpr = visit(ctx.expression(1))
        return binaryExpression("sub", leftExpr, rightExpr, leftExpr.type)
    }

    override fun visitAdd(ctx: AddContext): Result {
        val leftExpr = visit(ctx.expression(0))
        val rightExpr = visit(ctx.expression(1))
        return binaryExpression("add", leftExpr, rightExpr, leftExpr.type)
    }

    override fun visitDiv(ctx: DivContext): Result {
        val leftExpr = visit(ctx.expression(0))
        val rightExpr = visit(ctx.expression(1))
        return binaryExpression("sdiv", leftExpr, rightExpr, leftExpr.type)
    }

    override fun visitLe(ctx: LeContext): Result {
        val leftExpr = visit(ctx.expression(0))
        val rightExpr = visit(ctx.expression(1))
        return binaryExpression("icmp sle", leftExpr, rightExpr, "i1")
    }

    override fun visitLt(ctx: LtContext): Result {
        val leftExpr = visit(ctx.expression(0))
        val rightExpr = visit(ctx.expression(1))
        return binaryExpression("icmp slt", leftExpr, rightExpr, "i1")
    }

    override fun visitGe(ctx: GeContext): Result {
        val leftExpr = visit(ctx.expression(0))
        val rightExpr = visit(ctx.expression(1))
        return binaryExpression("icmp sge", leftExpr, rightExpr, "i1")
    }

    override fun visitGt(ctx: GtContext): Result {
        val leftExpr = visit(ctx.expression(0))
        val rightExpr = visit(ctx.expression(1))
        return binaryExpression("icmp sgt", leftExpr, rightExpr, "i1")
    }

    override fun visitEq(ctx: EqContext): Result {
        val leftExpr = visit(ctx.expression(0))
        val rightExpr = visit(ctx.expression(1))
        return binaryExpression("icmp eq", leftExpr, rightExpr, "i1")
    }

    override fun visitNe(ctx: NeContext): Result {
        val leftExpr = visit(ctx.expression(0))
        val rightExpr = visit(ctx.expression(1))
        return binaryExpression("icmp ne", leftExpr, rightExpr, "i1")
    }

    override fun visitFuncCall(ctx: FuncCallContext): Result {
        val functionName = ctx.identifier().text
        val functionType = functionTypeMap[functionName] ?: throw Error("Function $functionName not found")
        val argList = ctx.expression().map { visit(it) }
        val register = "%${instructionCounter++}"

        return Result(
            functionType.returnType,
            register,
            """
            ${argList.joinToString("\n") { it.instructions }}
            $register = call ${functionType.returnType} @$functionName(${argList.joinToString(", ")})
            """.trimIndent())
    }

    override fun visitId(ctx: IdContext): Result {
        // TODO variable scope %/@
        val id = ctx.text!!
        if (!symbols.containsKey(id)) {
            throw Error("Variable $id not found @ line ${ctx.start.line}")
        }
        return Result(symbols[id]!!, "%${ctx.text}", "")
    }
    override fun visitNum(ctx: NumContext): Result {
        return Result("i32", ctx.text, "")
    }

    private fun binaryExpression(op: String, left: Result, right: Result, type: String): Result {
        val register = "%${instructionCounter++}"
        return Result(
            type,
            register,
            """
            ${left.instructions}
            ${right.instructions}
            $register = $op ${left.type} ${left.register}, ${right.register}
            """.trimIndent())
    }
}
