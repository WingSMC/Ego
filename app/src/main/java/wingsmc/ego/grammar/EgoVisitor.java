// Generated from F:/Projects/Code/Ego - Copy/app/src/main/java/wingsmc/ego/grammar\Ego.g4 by ANTLR 4.12.0
package wingsmc.ego.grammar;
import org.antlr.v4.runtime.tree.ParseTreeVisitor;

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link EgoParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
public interface EgoVisitor<T> extends ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link EgoParser#prog}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProg(EgoParser.ProgContext ctx);
	/**
	 * Visit a parse tree produced by {@link EgoParser#functionDefinition}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFunctionDefinition(EgoParser.FunctionDefinitionContext ctx);
	/**
	 * Visit a parse tree produced by {@link EgoParser#parameter}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParameter(EgoParser.ParameterContext ctx);
	/**
	 * Visit a parse tree produced by {@link EgoParser#type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType(EgoParser.TypeContext ctx);
	/**
	 * Visit a parse tree produced by {@link EgoParser#identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIdentifier(EgoParser.IdentifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link EgoParser#block}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBlock(EgoParser.BlockContext ctx);
	/**
	 * Visit a parse tree produced by the {@code returnStatement}
	 * labeled alternative in {@link EgoParser#statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitReturnStatement(EgoParser.ReturnStatementContext ctx);
	/**
	 * Visit a parse tree produced by the {@code blockStatement}
	 * labeled alternative in {@link EgoParser#statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBlockStatement(EgoParser.BlockStatementContext ctx);
	/**
	 * Visit a parse tree produced by the {@code ifStatement}
	 * labeled alternative in {@link EgoParser#statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIfStatement(EgoParser.IfStatementContext ctx);
	/**
	 * Visit a parse tree produced by the {@code expressionStatement}
	 * labeled alternative in {@link EgoParser#statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpressionStatement(EgoParser.ExpressionStatementContext ctx);
	/**
	 * Visit a parse tree produced by {@link EgoParser#condition}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCondition(EgoParser.ConditionContext ctx);
	/**
	 * Visit a parse tree produced by the {@code add}
	 * labeled alternative in {@link EgoParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAdd(EgoParser.AddContext ctx);
	/**
	 * Visit a parse tree produced by the {@code sub}
	 * labeled alternative in {@link EgoParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSub(EgoParser.SubContext ctx);
	/**
	 * Visit a parse tree produced by the {@code parens}
	 * labeled alternative in {@link EgoParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParens(EgoParser.ParensContext ctx);
	/**
	 * Visit a parse tree produced by the {@code mod}
	 * labeled alternative in {@link EgoParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMod(EgoParser.ModContext ctx);
	/**
	 * Visit a parse tree produced by the {@code mul}
	 * labeled alternative in {@link EgoParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMul(EgoParser.MulContext ctx);
	/**
	 * Visit a parse tree produced by the {@code num}
	 * labeled alternative in {@link EgoParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNum(EgoParser.NumContext ctx);
	/**
	 * Visit a parse tree produced by the {@code lt}
	 * labeled alternative in {@link EgoParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLt(EgoParser.LtContext ctx);
	/**
	 * Visit a parse tree produced by the {@code eq}
	 * labeled alternative in {@link EgoParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEq(EgoParser.EqContext ctx);
	/**
	 * Visit a parse tree produced by the {@code gt}
	 * labeled alternative in {@link EgoParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGt(EgoParser.GtContext ctx);
	/**
	 * Visit a parse tree produced by the {@code div}
	 * labeled alternative in {@link EgoParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDiv(EgoParser.DivContext ctx);
	/**
	 * Visit a parse tree produced by the {@code ne}
	 * labeled alternative in {@link EgoParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNe(EgoParser.NeContext ctx);
	/**
	 * Visit a parse tree produced by the {@code le}
	 * labeled alternative in {@link EgoParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLe(EgoParser.LeContext ctx);
	/**
	 * Visit a parse tree produced by the {@code funcCall}
	 * labeled alternative in {@link EgoParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFuncCall(EgoParser.FuncCallContext ctx);
	/**
	 * Visit a parse tree produced by the {@code id}
	 * labeled alternative in {@link EgoParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitId(EgoParser.IdContext ctx);
	/**
	 * Visit a parse tree produced by the {@code ifExpression}
	 * labeled alternative in {@link EgoParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIfExpression(EgoParser.IfExpressionContext ctx);
	/**
	 * Visit a parse tree produced by the {@code ge}
	 * labeled alternative in {@link EgoParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGe(EgoParser.GeContext ctx);
}