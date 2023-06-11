package wingsmc.ego.types

class EgoAliasType(
    name: String,
    val of: EgoType,
): EgoType(
    name,
    of.llvmType,
    of.size
) {
    override val typeClass: EgoTypeClass
        get() = EgoTypeClass.ALIAS

    override fun makeCompatible(other: EgoType, cast: String) {
        of.makeCompatible(other, cast)
    }

    override fun isCompatible(other: EgoType): Boolean {
        return of.isCompatible(other)
    }

    override fun cast(register: String, to: EgoType): String? {
        return of.cast(register, to)
    }
}
