package wingsmc.ego.modules

import wingsmc.ego.EgoSymbol
import wingsmc.ego.getErrorTagline
import wingsmc.ego.grammar.EgoV2Parser
import wingsmc.ego.grammar.EgoV2ParserBaseVisitor
import wingsmc.ego.types.*

class EgoModuleVisitor(
    val name: String,
    var scope: EgoNamespaceScope = EgoModuleCache.rootScope
): EgoV2ParserBaseVisitor<Any?>() {
    override fun visitModuleDef(ctx: EgoV2Parser.ModuleDefContext): Any? {
        val visibility = getAccessFromContext(ctx.accessModifer())
        scope = EgoNamespaceScope(name, visibility, EgoNamespaceType.MODULE, scope)
        scope.parentNamespace!!.addScope(name, scope)
        return null
    }

/*//    override fun visitClassDeclaration(ctx: EgoV2Parser.ClassDeclarationContext): Any? {
//        val visibility = getAccessFromContext(ctx.accessModifer())
//        val classID = ctx.ID().text
//
//        val classScope = EgoNamespaceScope(classID, visibility, EgoNamespaceType.CLASS, scope)
//        val type = EgoClassType(classScope, visibility)
//
//        scope.addScope(classID, classScope)
//        scope = classScope
//
//        super.visitClassDeclaration(ctx)
//
//        scope = scope.parentNamespace!!
//        return null
//    }
//    override fun visitInterfaceDeclaration(ctx: EgoV2Parser.InterfaceDeclarationContext): Any? {
//        val visibility = getAccessFromContext(ctx.accessModifer())
//        val interfaceID = ctx.ID().text
//
//        val interfaceScope = EgoNamespaceScope(interfaceID, visibility, EgoNamespaceType.INTERFACE, scope)
//        scope.addType(EgoInterfaceType(interfaceScope, visibility))
//        scope.addScope(interfaceID, interfaceScope)
//        scope = interfaceScope
//
//        val children = super.visitInterfaceDeclaration(ctx)
//
//        scope = scope.parentNamespace!!
//        return null
//    }
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
//    override fun visitFunctionHeader(ctx: EgoV2Parser.FunctionHeaderContext): Any? {
//        val visibility = getAccessFromContext(ctx.accessModifer())
//        val functionID = ctx.ID().text
//
//        if (scope.type == EgoNamespaceType.INTERFACE && visibility == EgoVisibility.PROTECTED) {
//            println("Interface functions can only be public @ ${scope.scopeName}::$functionID")
//            return null
//        }
//
//        val typeNameCtx = ctx.typeName()
//        val returnType = validateReturnType(typeNameCtx, functionID)
//
//        return super.visitFunctionHeader(ctx)
//    }*/

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
        val fnType = EgoFunctionType(returnType, paramTypes, isExtern = false)

        scope.addSymbol(
            functionID,
            EgoSymbol(
                functionID,
                fnType,
                visibility,
                isMutable = ctx.typeName().MUT() != null,
            )
        )

        return null
    }


    private fun validateReturnType (returnTypeNameCtx: EgoV2Parser.TypeNameContext?, tokenID: String): EgoType {
        return if (returnTypeNameCtx == null) {
            EgoTypes.VOID
        } else {
            processTypeName(returnTypeNameCtx)
        }
    }

    private fun getParamTypes (params: List<EgoV2Parser.ParameterContext>): List<EgoType> {
        return params.map { processTypeName(it.typeName()) }
    }

    private fun processTypeName(typeNameCtx: EgoV2Parser.TypeNameContext): EgoType {
        // TODO: typeNameCtx.MUT
        val type = typeNameCtx.run {
            scopedTypeIdentifier()?.run {
                scope.getType(text)
            } ?: tupleTypeDef()?.run {
                EgoTupleType.fromCtx(this, scope)
            } ?: run {
                System.err.println("Type $text does not exist @ ${scope.scopeName}\n${getErrorTagline(this)}")
                EgoTypes.ERROR_TYPE
            }
        }

        return typeNameCtx.mutAndTypeModifier().fold(type) { acc, ctx ->
            if (acc.typeClass == EgoTypeClass.REFERENCE) {
                System.err.println("You can't have reference pointers/references @ ${scope.scopeName}\n${getErrorTagline(ctx)}")
                return EgoTypes.ERROR_TYPE
            }
            val mod = ctx.typeModifier()
            val mut = ctx.MUT() != null
            if (mod.AT() != null) {
                EgoReferenceType(acc, mut)
            } else {
                EgoPointerType(acc, mut)
            }
        }
    }

    private fun getAccessFromContext(ctx: EgoV2Parser.AccessModiferContext?): EgoVisibility {
        return if (scope.type == EgoNamespaceType.INTERFACE) {
            if (ctx?.PRO() != null) {
                System.err.println("Interface functions can only be public @ ${scope.scopeName}\n${getErrorTagline(ctx)}")
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
