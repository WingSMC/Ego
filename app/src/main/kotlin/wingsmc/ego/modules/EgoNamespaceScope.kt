package wingsmc.ego.modules

import wingsmc.ego.EgoScope
import wingsmc.ego.EgoSymbol

class EgoNamespaceScope(
    val name: String,
    val visibility: EgoVisibility,
    val type: EgoNamespaceType,
    parent: EgoNamespaceScope? = null
): EgoScope(
    parent,
), java.io.Serializable
{
    val children = HashMap<String, EgoNamespaceScope>()

    fun getScope(name: String): EgoNamespaceScope? {
        return if (name == this.name) this else children.values.run {
            var scope: EgoNamespaceScope? = null
            for (child in this) {
                scope = child.getScope(name)
                if (scope != null) break
            }
            scope
        }
    }

    fun addScope(name: String, scope: EgoNamespaceScope): Boolean {
        if (children.containsKey(name)) {
            println("Scope $name already exists in this namespace")
            return false
        }

        children[name] = scope
        return true
    }
    val parentNamespace get() = parent as EgoNamespaceScope?

    override val scopeName: String get() {
        val parentNs = parentNamespace
        return if (parentNs == null) name else "${parentNs.scopeName}::$name"
    }

    val llvmScopeName: String get() {
        val parentNs = parentNamespace
        return if (parentNs == null) name else "${parentNs.llvmScopeName}__$name"
    }

    override fun toString() =
        "+====================+\n" +
        "| $name\n" +
        "+....................+\n" +
        super.toString()
}
