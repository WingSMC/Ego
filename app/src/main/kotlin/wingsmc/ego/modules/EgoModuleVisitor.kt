package wingsmc.ego.modules

import wingsmc.ego.EgoSymbol
import wingsmc.ego.grammar.EgoV2Parser
import wingsmc.ego.grammar.EgoV2ParserBaseVisitor
import wingsmc.ego.types.*

class EgoModuleVisitor(
    private val name: String,
    private var scope: EgoNamespaceScope = EgoModuleCache.rootScope
) : EgoV2ParserBaseVisitor<Any?>() {
    override fun visitModuleDef(ctx: EgoV2Parser.ModuleDefContext): Any? {
        val visibility = getAccessFromContext(ctx.accessModifer())
        scope = EgoNamespaceScope(name, visibility, EgoNamespaceType.MODULE, scope)
        scope.parentNamespace!!.addScope(name, scope)
        return null
    }

    override fun visitClassDeclaration(ctx: EgoV2Parser.ClassDeclarationContext): Any? {
        val visibility = getAccessFromContext(ctx.accessModifer())
        val classID = ctx.ID().text

        val classScope = EgoNamespaceScope(classID, visibility, EgoNamespaceType.CLASS, scope)
        val type = EgoClassType(classScope, visibility)

        scope.addScope(classID, classScope)
        scope = classScope

        super.visitClassDeclaration(ctx)

        scope = scope.parentNamespace!!
        return null
    }

    override fun visitInterfaceDeclaration(ctx: EgoV2Parser.InterfaceDeclarationContext): Any? {
        val visibility = getAccessFromContext(ctx.accessModifer())
        val interfaceID = ctx.ID().text

        val interfaceScope = EgoNamespaceScope(interfaceID, visibility, EgoNamespaceType.INTERFACE, scope)
        scope.addType(EgoInterfaceType(interfaceScope, visibility))
        scope.addScope(interfaceID, interfaceScope)
        scope = interfaceScope

        val children = super.visitInterfaceDeclaration(ctx)

        scope = scope.parentNamespace!!
        return null
    }

//    override fun visitImplementDeclaration(ctx: EgoV2Parser.ImplementDeclarationContext): Any? {
//        val visibility = getAccessFromContext(ctx.accessModifer())
//        val classID = ctx.scopedIdentifier()[0].text
//        val interfaceID = ctx.scopedIdentifier()[1].text
//
//        val classScope = scope.getScope(classID) as EgoNamespaceScope
//        val interfaceScope = scope.getScope(interfaceID) as EgoNamespaceScope
//
//        val children = super.visitImplementDeclaration(ctx);
//
//        return null;
//    }

    override fun visitFunctionDeclaration(ctx: EgoV2Parser.FunctionDeclarationContext): Any? {
        val functionID = ctx.ID().text

        val visibility = if (scope.type == EgoNamespaceType.INTERFACE) {
            if (ctx.accessModifer() == null || ctx.accessModifer().PUB() != null) {
                EgoVisibility.PUBLIC
            } else {
                System.err.println("Interface functions can only be public @ ${scope.scopeName}::$functionID")
                return null
            }
        } else {
            getAccessFromContext(ctx.accessModifer())
        }

        val returnType = validateReturnType(ctx.typeName(), functionID)
        val paramTypes = getParamTypes(ctx.lambdaExpr().functionParameters().parameter())
        val fnType = EgoFunctionType(returnType, paramTypes)

        scope.addSymbol(
            functionID,
            EgoSymbol(
                functionID,
                fnType,
                visibility,
            )
        )

        return null
    }

    override fun visitFunctionHeader(ctx: EgoV2Parser.FunctionHeaderContext): Any? {
        val visibility = getAccessFromContext(ctx.accessModifer())
        val functionID = ctx.ID().text

        if (scope.type == EgoNamespaceType.INTERFACE && visibility == EgoVisibility.PROTECTED) {
            println("Interface functions can only be public @ ${scope.scopeName}::$functionID")
            return null
        }

        val typeNameCtx = ctx.typeName()
        val returnType = validateReturnType(typeNameCtx, functionID)

        return super.visitFunctionHeader(ctx)
    }

    private fun validateReturnType (returnTypeNameCtx: EgoV2Parser.TypeNameContext?, tokenID: String): EgoType {
        return if (returnTypeNameCtx == null) {
            EgoTypes.VOID
        } else {
            val returnTypeName = (returnTypeNameCtx.scopedTypeIdentifier() ?: returnTypeNameCtx.tupleTypeDef()).text
            val type = scope.getType(returnTypeName)
            if (type == null) {
                System.err.println("Return type $returnTypeName does not exist @ ${scope.scopeName}::$tokenID")
                return EgoTypes.ERROR_TYPE
            }
            type
        }
    }

    private fun getParamTypes (paramCtxs: List<EgoV2Parser.ParameterContext>): List<EgoType> {
        val paramTypes = mutableListOf<EgoType>()
        for (paramCtx in paramCtxs) {
            val typeNameCtx = paramCtx.typeName()
            val typeName = (typeNameCtx.scopedTypeIdentifier() ?: typeNameCtx.tupleTypeDef()).text
            val type = scope.getType(typeName)
            if (type == null) {
                System.err.println("Parameter type $typeName does not exist @ ${scope.scopeName}::${paramCtx.ID().text}")
                paramTypes.add(EgoTypes.ERROR_TYPE)
            } else {
                paramTypes.add(type)
            }
        }
        return paramTypes
    }


    private fun getAccessFromContext(ctx: EgoV2Parser.AccessModiferContext?): EgoVisibility {
        return if (scope.type == EgoNamespaceType.INTERFACE) {
            if (ctx?.PUB() != null) {
                System.err.println("Interface functions can only be public @ ${scope.scopeName}")
            }
            EgoVisibility.PUBLIC
        } else if (ctx == null) {
            EgoVisibility.PRIVATE
        } else when (ctx.text) {
            "pub" -> EgoVisibility.PUBLIC
            "pro" -> EgoVisibility.PROTECTED
            else -> EgoVisibility.PRIVATE
        }
    }
}
