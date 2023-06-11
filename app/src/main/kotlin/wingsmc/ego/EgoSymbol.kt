package wingsmc.ego

import wingsmc.ego.modules.EgoVisibility
import wingsmc.ego.types.EgoType

open class EgoSymbol(
    val name: String,
    val type: EgoType,
    val visibility: EgoVisibility = EgoVisibility.LOCAL
) {
    override fun toString() = "$visibility $name: $type"
}
