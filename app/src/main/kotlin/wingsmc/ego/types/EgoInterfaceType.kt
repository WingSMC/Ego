package wingsmc.ego.types

import wingsmc.ego.modules.EgoNamespaceScope
import wingsmc.ego.modules.EgoVisibility

class EgoInterfaceType(
    val namespace: EgoNamespaceScope,
    val visibility: EgoVisibility,
): EgoType(
    namespace.scopeName,
    "",
    0u,
) {
    override val typeClass get() = EgoTypeClass.INTERFACE
    val vtableDeclaration get() =
        "%${namespace.scopeName}_vtable = type { ${namespace.symbols.values.joinToString("*,") { it.type.llvmType }}* }\n"
    val dynamicStructDeclaration get() = "%${namespace.scopeName}_dynamic = type { %${namespace.scopeName}_vtable*, opaque* }\n"
}
