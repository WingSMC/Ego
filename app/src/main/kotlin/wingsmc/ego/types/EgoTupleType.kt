package wingsmc.ego.types

class EgoTupleType(
    val fields: List<EgoType>,
): EgoType(
    "{${fields.joinToString(",")}}",
    "{${fields.joinToString(",") { it.llvmType }}}",
    0u,
) {
    override val typeClass get() = EgoTypeClass.TUPLE
}
