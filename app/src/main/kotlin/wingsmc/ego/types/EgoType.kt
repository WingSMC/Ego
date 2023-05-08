package wingsmc.ego.types

open class EgoType(val name: String) {
    private val parents = HashSet<EgoType>()

    fun isCompatible(other: EgoType): Boolean {
        return other == this || this.parents.stream().anyMatch { it.isCompatible(other) }
    }

    fun addParent(parent: EgoType) {
        this.parents.add(parent)
    }

    val namespaceAsList: List<String>
        get() = name.split("::")

    open val typeClass: EgoTypeClasses
        get() = EgoTypeClasses.BASIC

    override fun toString(): String = name
}
