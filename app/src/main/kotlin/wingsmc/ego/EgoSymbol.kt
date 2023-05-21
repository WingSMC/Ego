package wingsmc.ego

import wingsmc.ego.modules.EgoVisibility
import wingsmc.ego.types.EgoType

open class EgoSymbol(
        private val name: String,
        private val type: EgoType,
        val visibility: EgoVisibility = EgoVisibility.LOCAL
) {
    override fun toString(): String {
        return "$visibility $name: $type"
    }
}
