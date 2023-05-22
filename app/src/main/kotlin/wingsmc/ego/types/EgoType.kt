package wingsmc.ego.types

open class EgoType(val name: String, val llvmType: String, val size: UInt) {
    private val compatibles = HashSet<EgoType>()
    private val casts = HashMap<EgoType, String>()

    open fun isCompatible(other: EgoType): Boolean {
        return (
            other == this
            || compatibles.stream().anyMatch { it == other }
        )
    }

    open fun cast(register: String, to: EgoType): String? {
        if (to == this) {
            return null
        }
        val op = casts[to] ?: throw Error("No direct cast available from $name to ${to.name}")
        if (op == "") {
            return null
        }
        return op.replace("%0", register)
    }

    open fun makeCompatible(other: EgoType, cast: String) {
        casts[other] = cast
        this.compatibles.add(other)
    }

    open infix fun noopCast(other: EgoType) {
        makeCompatible(other, "")
    }
    open infix fun signExtend(other: EgoType) {
        makeCompatible(other, "sext $llvmType %0 to ${other.llvmType}")
    }
    open infix fun zeroExtend(other: EgoType) {
        makeCompatible(other, "zext $llvmType %0 to ${other.llvmType}")
    }
    open infix fun truncate(other: EgoType) {
        makeCompatible(other, "trunc $llvmType %0 to ${other.llvmType}")
    }

    open val typeClass: EgoTypeClass
        get() = EgoTypeClass.BASIC

    override fun toString(): String = name
}
