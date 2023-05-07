package wingsmc.ego.modules

import wingsmc.ego.grammar.EgoV2Parser
import wingsmc.ego.grammar.EgoV2ParserBaseVisitor

class EgoModuleVisitor(private val name: String) : EgoV2ParserBaseVisitor<EgoNamespaceScope?>() {
    private var scope = EgoNamespaceScope(name)

    override fun visitModuleFile(ctx: EgoV2Parser.ModuleFileContext?): EgoNamespaceScope? {
        if (ctx == null) {
            return null
        }
        ctx.moduleMemberDefinition()
        return super.visitModuleFile(ctx)
    }

    override fun visitImportDefinition(ctx: EgoV2Parser.ImportDefinitionContext?): EgoNamespaceScope? {
        TODO()
    }

    override fun visitExportDefinition(ctx: EgoV2Parser.ExportDefinitionContext?): EgoNamespaceScope? {
        TODO()
    }

    override fun visitClassDeclaration(ctx: EgoV2Parser.ClassDeclarationContext?): EgoNamespaceScope? {
        if (ctx == null) {
            return null
        }
        val visibility = EgoVisibility.getAccessFromContext(ctx.accessModifer())
        val classID = ctx.ID().text
        return super.visitClassDeclaration(ctx)
    }

    override fun visitInterfaceDeclaration(ctx: EgoV2Parser.InterfaceDeclarationContext?): EgoNamespaceScope? {
        if (ctx == null) {
            return null
        }
        return super.visitInterfaceDeclaration(ctx)
    }

    override fun visitImplementDeclaration(ctx: EgoV2Parser.ImplementDeclarationContext?): EgoNamespaceScope? {
        if (ctx == null) {
            return null
        }
        return super.visitImplementDeclaration(ctx)
    }

    override fun visitFunctionDeclaration(ctx: EgoV2Parser.FunctionDeclarationContext?): EgoNamespaceScope? {
        if (ctx == null) {
            return null
        }
        return super.visitFunctionDeclaration(ctx)
    }

    /*
     * Visit leaves
     */
}