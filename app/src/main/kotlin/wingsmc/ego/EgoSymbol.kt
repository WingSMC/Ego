package wingsmc.ego

import wingsmc.ego.modules.EgoVisibility
import wingsmc.ego.types.EgoType

open class EgoSymbol(
    val name: String,
    val type: EgoType,
    val visibility: EgoVisibility = EgoVisibility.LOCAL,
    val isMutable: Boolean = false,
) {
    override fun toString() = "$visibility $name:${if (isMutable) " mut" else ""} $type"
    val llvmRegister get() = "${if (visibility == EgoVisibility.LOCAL) "%" else "@"}$name"
    val llvmType get() = type.llvmType
    val llvmTypeAndRegister get() = "$llvmType $llvmRegister"
}
