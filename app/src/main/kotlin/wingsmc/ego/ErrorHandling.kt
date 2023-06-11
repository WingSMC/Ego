package wingsmc.ego

import org.antlr.v4.runtime.ParserRuleContext

fun getErrorTagline(ctx: ParserRuleContext) =
    "\t${ctx.start.line}:${ctx.start.charPositionInLine} ${ctx.text}"