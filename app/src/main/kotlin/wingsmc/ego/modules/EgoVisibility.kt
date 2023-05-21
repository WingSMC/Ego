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
}
