package wingsmc.ego.types

class EgoPointerType(val pointedType: EgoType): EgoType("#$pointedType", pointedType.llvmType + "*", 4u) {
    override val typeClass: EgoTypeClass
        get() = EgoTypeClass.POINTER
}
