package wingsmc.ego

import wingsmc.ego.types.EgoType
import wingsmc.ego.types.EgoTypes

open class EgoScope(val parent: EgoScope? = null) {
    private val symbols = HashMap<String, EgoSymbol>()
    private var types: EgoTypes = EgoTypes(parent?.types ?: EgoTypes.globalTypes)

    open fun getSymbol(name: String): EgoSymbol? = symbols[name] ?: parent?.getSymbol(name)

    fun addSymbol(name: String, symbol: EgoSymbol): Boolean {
        if (symbols.containsKey(name)) {
            println("Symbol $name already exists in this scope")
            return false
        }

        symbols[name] = symbol
        return true
    }

    fun getType(name: String): EgoType? = types.getType(name)

    override fun toString(): String {
        val builder = StringBuilder()
        symbols.forEach { (_, symbol) ->
            builder.append("\t$symbol\n")
        }
        builder.append("----------------------\n")
        builder.append(parent)
        return builder.toString()
    }
}
