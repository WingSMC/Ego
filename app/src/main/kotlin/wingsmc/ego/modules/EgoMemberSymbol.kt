package wingsmc.ego.modules

import wingsmc.ego.EgoSymbol
import wingsmc.ego.types.EgoType

class EgoMemberSymbol(name: String, type: EgoType, visibility: EgoVisibility) : EgoSymbol(name, type, visibility) {
    override fun toString(): String {
        return "$visibility ${super.toString()}"
    }
}
