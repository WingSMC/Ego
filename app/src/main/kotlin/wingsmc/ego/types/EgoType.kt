package wingsmc.ego.types

open class EgoType(val name: String, val size: UInt) {
    private val parents = HashSet<EgoType>()

    fun isCompatible(other: EgoType): Boolean {
        return (
            other == this
            || this.parents.stream().anyMatch { it.isCompatible(other) }
        )
    }

    fun addParent(parent: EgoType) {
        this.parents.add(parent)
    }

    open val typeClass: EgoTypeClass
        get() = EgoTypeClass.BASIC

    override fun toString(): String = name
}
