package wingsmc.ego.modules

enum class EgoVisibility {
    PUBLIC {
        override fun toString() = "pub"
    },
    PROTECTED {
        override fun toString() = "pro"
    },
    PRIVATE {
        override fun toString() = "prv"
        override val llvmVisibility get() = " internal "
    },
    LOCAL {
        override fun toString() = "loc"
    };

    open val llvmVisibility = " "
}
