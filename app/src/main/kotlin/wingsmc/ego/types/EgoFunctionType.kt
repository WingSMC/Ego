package wingsmc.ego.types

class EgoFunctionType(
    private val returnType: EgoType,
    private val params: List<EgoType>,
    typeContext: EgoTypes,
): EgoType("$returnType(${params.joinToString(",")})", funcLLVMType(returnType, params), 1u) {
    companion object {
        fun funcLLVMType(returnType: EgoType, params: List<EgoType>): String {
           return "${returnType.llvmType} (${params.joinToString(", ") { it.llvmType }})*"
        }
    }

    override val typeClass: EgoTypeClass
        get() = EgoTypeClass.FUNCTION
}
