package wingsmc.ego.types

import wingsmc.ego.modules.EgoNamespaceScope
import wingsmc.ego.modules.EgoVisibility

class EgoClassType(
    val namespace: EgoNamespaceScope,
    val visibility: EgoVisibility,
): EgoType(
    namespace.name,
    "%${namespace.name}",
    namespace.symbols.values.sumOf { it.type.size },
) {
    override val typeClass get() = EgoTypeClass.CLASS
    override val getLLVMDefinition: String
        get() = "${llvmType} = type {\n${namespace.symbols.values
            .filter { it.type.size > 0u }
            .joinToString(",\n") { it.type.llvmType }
        }\n}"
}
