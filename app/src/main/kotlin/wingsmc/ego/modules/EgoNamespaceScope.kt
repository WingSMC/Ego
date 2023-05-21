package wingsmc.ego.modules

import wingsmc.ego.EgoScope
import wingsmc.ego.EgoSymbol

class EgoNamespaceScope(
    private val name: String,
    val visibility: EgoVisibility,
    val type: EgoNamespaceType,
    parent: EgoNamespaceScope? = null
)
    : EgoScope(parent)
    , java.io.Serializable
{
    private val children = HashMap<String, EgoNamespaceScope>()

    fun getScope(name: String): EgoScope? = children[name]
    fun addScope(name: String, scope: EgoNamespaceScope): Boolean {
        if (children.containsKey(name)) {
            println("Scope $name already exists in this namespace")
            return false
        }

        children[name] = scope
        return true
    }

    override fun getSymbol(name: String): EgoSymbol? {
        return super.getSymbol(name)
                ?: children.values.firstNotNullOfOrNull { it.getSymbol(name) }
    }

    val parentNamespace: EgoNamespaceScope?
        get() = parent as EgoNamespaceScope?

    val scopeName: String
        get() {
            val parentNs = parentNamespace
            return if (parentNs == null) name else "${parentNs.scopeName}::$name"
        }
}