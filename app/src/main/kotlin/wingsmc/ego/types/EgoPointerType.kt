package wingsmc.ego.types

class EgoPointerType(
    val pointedType: EgoType,
    val isMutable: Boolean,
): EgoType(
    "#$pointedType",
    pointedType.llvmType + "*",
    4u,
) {
    override val typeClass get() = EgoTypeClass.POINTER
    override fun toString() = pointedType.toString() + "_ptr"
}
