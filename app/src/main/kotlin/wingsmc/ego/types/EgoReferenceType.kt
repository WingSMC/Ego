package wingsmc.ego.types

class EgoReferenceType(val referencedType: EgoType): EgoType("@$pointedType", 4u) {
    override val typeClass: EgoTypeClass
        get() = EgoTypeClass.REFERENCE
}
