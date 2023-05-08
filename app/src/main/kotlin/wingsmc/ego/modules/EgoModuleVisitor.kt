package wingsmc.ego.modules

import wingsmc.ego.EgoSymbol
import wingsmc.ego.grammar.EgoV2Parser
import wingsmc.ego.grammar.EgoV2ParserBaseVisitor
import wingsmc.ego.types.EgoFunctionType
import wingsmc.ego.types.EgoType

class EgoModuleVisitor(private val name: String) : EgoV2ParserBaseVisitor<Any?>() {
    private lateinit var scope: EgoNamespaceScope

    override fun visitModuleDef(ctx: EgoV2Parser.ModuleDefContext): Any? {
        val visibility = EgoVisibility.getAccessFromContext(ctx.accessModifer())
        this.scope = EgoNamespaceScope(name, visibility, EgoNamespaceType.MODULE)

        return null
    }

    override fun visitImportDefinition(ctx: EgoV2Parser.ImportDefinitionContext): Any? {
        return super.visitImportDefinition(ctx)
    }

    override fun visitExportDefinition(ctx: EgoV2Parser.ExportDefinitionContext): Any? {
        return super.visitExportDefinition(ctx)
    }

    override fun visitClassDeclaration(ctx: EgoV2Parser.ClassDeclarationContext): Any? {
        val visibility = EgoVisibility.getAccessFromContext(ctx.accessModifer())
        val classID = ctx.ID().text

        val classScope = EgoNamespaceScope(classID, visibility, EgoNamespaceType.CLASS, scope)
        scope.addScope(classID, classScope)
        scope = classScope

        super.visitClassDeclaration(ctx)

        scope = scope.parentNamespace!!
        return null
    }

    override fun visitInterfaceDeclaration(ctx: EgoV2Parser.InterfaceDeclarationContext): Any? {
        val visibility = EgoVisibility.getAccessFromContext(ctx.accessModifer())
        val interfaceID = ctx.ID().text

        val interfaceScope = EgoNamespaceScope(interfaceID, visibility, EgoNamespaceType.INTERFACE, scope)
        scope.addScope(interfaceID, interfaceScope)
        scope = interfaceScope

        super.visitInterfaceDeclaration(ctx)

        scope = scope.parentNamespace!!
        return null
    }

    override fun visitImplementDeclaration(ctx: EgoV2Parser.ImplementDeclarationContext): Any? {
        val visibility = EgoVisibility.getAccessFromContext(ctx.accessModifer())
        val classID = ctx.scopedIdentifier()[0].text
        val interfaceID = ctx.scopedIdentifier()[1].text

        val classScope = scope.getScope(classID) as EgoNamespaceScope
        val interfaceScope = scope.getScope(interfaceID) as EgoNamespaceScope


        return super.visitImplementDeclaration(ctx)

    }

    override fun visitFunctionDeclaration(ctx: EgoV2Parser.FunctionDeclarationContext): Any? {
        val visibility = EgoVisibility.getAccessFromContext(ctx.accessModifer())
        val functionID = ctx.ID().text

        if (scope.type == EgoNamespaceType.INTERFACE && visibility == EgoVisibility.PROTECTED) {
            println("Interface functions can only be public @ ${scope.scopeName}::$functionID")
            return null
        }

        scope.addSymbol(
            functionID,
            EgoSymbol(functionID, EgoFunctionType(
                functionID,
                ArrayList<EgoType>()
            ), visibility)
        )

        return super.visitFunctionDeclaration(ctx)
    }

    /*
     * Visit leaves
     */
}