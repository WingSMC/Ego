package wingsmc.ego

import wingsmc.ego.types.EgoType

open class EgoSymbol(
        private val name: String,
        private val type: EgoType,
) {
    override fun toString(): String {
        return "$name: $type"
    }
}
