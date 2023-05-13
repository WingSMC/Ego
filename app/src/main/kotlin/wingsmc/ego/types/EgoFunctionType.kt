package wingsmc.ego.types

class EgoFunctionType(
    private val returnType: EgoType,
    private val params: List<EgoType>
): EgoType("$returnType(${params.joinToString(",")})", 1u) {
    override val typeClass: EgoTypeClasses
        get() = EgoTypeClasses.FUNCTION
}
