package wingsmc.ego.modules

import wingsmc.ego.grammar.EgoV2Parser

enum class EgoVisibility {
    PUBLIC {
        override fun toString(): String = "pub"
    },
    PRIVATE {
        override fun toString(): String = "prv"
    },
    PROTECTED {
        override fun toString(): String = "pro"
    },
    LOCAL {
        override fun toString(): String = "loc"
    };

    companion object {
        fun getAccessFromContext(ctx: EgoV2Parser.AccessModiferContext?): EgoVisibility {
            if (ctx == null) {
                return PRIVATE
            }

            return when (ctx.text) {
                "pub" -> PUBLIC
                "pro" -> PROTECTED
                else -> PRIVATE
            }
        }
    }
}
