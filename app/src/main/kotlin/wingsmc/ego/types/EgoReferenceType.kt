package wingsmc.ego.types

class EgoReferenceType(
    val referencedType: EgoType,
    val isMutable: Boolean,
): EgoType(
    "@$referencedType",
    referencedType.llvmType + "*",
    4u,
) {
    override val typeClass get() = EgoTypeClass.REFERENCE
    override fun toString() = referencedType.toString() + "_ptr"
}
