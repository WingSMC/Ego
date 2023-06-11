package wingsmc.ego.types

import wingsmc.ego.EgoScope
import wingsmc.ego.getErrorTagline
import wingsmc.ego.grammar.EgoV2Parser

class EgoTupleType(
    val fields: List<EgoType>,
): EgoType(
    "{${fields.joinToString(",")}}",
    "{${fields.joinToString(",") { it.llvmType }}}",
    0u,
) {
    companion object {
        fun fromCtx(ctx: EgoV2Parser.TupleTypeDefContext, scope: EgoScope): EgoTupleType {
            val fields = ctx.scopedTypeIdentifierList()
                .scopedTypeIdentifier()
                .map { scope.getType(it.text) ?: run {
                    System.err.println("Type ${it.text} does not exist @ ${scope.scopeName}\n${getErrorTagline(it)}")
                    EgoTypes.ERROR_TYPE
                }}
            return EgoTupleType(fields)
        }
    }
    override val typeClass get() = EgoTypeClass.TUPLE
}
