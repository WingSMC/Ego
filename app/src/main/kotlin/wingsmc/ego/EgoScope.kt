package wingsmc.ego

import wingsmc.ego.types.EgoTypes

open class EgoScope(
    parent: EgoScope? = null,
): EgoTypes(
    parent ?: EgoTypes.instance,
) {
    val symbols = HashMap<String, EgoSymbol>()

    open fun getSymbol(name: String): EgoSymbol? = symbols[name] ?: parent?.getSymbol(name)

    fun addSymbol(name: String, symbol: EgoSymbol): Boolean {
        if (symbols.containsKey(name)) {
            println("Symbol $name already exists in this scope")
            return false
        }

        symbols[name] = symbol
        return true
    }

    open val scopeName: String get() = parent?.scopeName ?: "global"

    override fun toString(): String {
        val builder = StringBuilder()
        symbols.forEach { (_, symbol) ->
            builder.append("| $symbol\n")
        }
        types.forEach() { (_, type) ->
            builder.append("| $type\n")
        }
        builder.append("+--------------------+\n")
        val parent = this.parent?.toString()
        if (parent != null) builder.append(parent)
        return builder.toString()
    }

    val parent: EgoScope? get() = super.parentTypeScope as? EgoScope?
}
