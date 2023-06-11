package wingsmc.ego.types

import wingsmc.ego.modules.EgoVisibility

class EgoFunctionType(
    val returnType: EgoType,
    val params: List<EgoType>,

    val isExtern: Boolean = false,
): EgoType(
    "$returnType(${params.joinToString(",")})",
    funcLLVMType(returnType, params),
    0u,
) {
    companion object {
        fun funcLLVMType(returnType: EgoType, params: List<EgoType>) =
            "${returnType.llvmType}(${params.joinToString(",") { it.llvmType }})"
    }

    fun getLLVMHeader(name: String): String {
        return "${returnType.llvmType} @$name(${
            params.joinToString(",") { it.llvmType }
        }) ${if(isExtern) "" else "nounwind "})}"
    }

    fun getLLVMDeclaration(name: String): String {
        return "declare ${getLLVMHeader(name)}\n"
    }

    fun getLLVMDefinition(name: String, visibility: EgoVisibility, body: String): String {
        return "define${visibility.llvmVisibility}${getLLVMHeader(name)} {\nentry:\n$body}\n"
    }

    override val typeClass get() = EgoTypeClass.FUNCTION
}
