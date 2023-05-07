package wingsmc.ego.modules

import wingsmc.ego.EgoSymbol
import wingsmc.ego.types.EgoType

class EgoMemberSymbol(name: String, type: EgoType) : EgoSymbol(name, type) {
    private val visibility = EgoVisibility.PUBLIC

    override fun toString(): String {
        return "$visibility ${super.toString()}"
    }
}
