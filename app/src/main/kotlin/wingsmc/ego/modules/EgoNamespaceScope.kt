package wingsmc.ego.modules

import wingsmc.ego.EgoScope
import wingsmc.ego.EgoSymbol

class EgoNamespaceScope(val name: String, parent: EgoScope? = null)
    : EgoScope(parent)
    , java.io.Serializable
{
    private val children = HashMap<String, EgoScope>()

    fun getScope(name: String): EgoScope? = children[name]
    fun addScope(name: String, scope: EgoScope): Boolean {
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
}