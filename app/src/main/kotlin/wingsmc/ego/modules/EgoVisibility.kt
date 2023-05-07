package wingsmc.ego.modules

import wingsmc.ego.grammar.EgoV2Parser

enum class EgoVisibility {
    PUBLIC {
        override fun toString(): String = "public"
    },
    PRIVATE {
        override fun toString(): String = "private"
    },
    PROTECTED {
        override fun toString(): String = "protected"
    };

    companion object {
        fun getAccessFromContext(ctx: EgoV2Parser.AccessModiferContext) {
            when (ctx.text) {
                "public" -> PUBLIC
                "protected" -> PROTECTED
                else -> PRIVATE
            }
        }
    }
}
