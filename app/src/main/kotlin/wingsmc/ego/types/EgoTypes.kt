package wingsmc.ego.types

// TODO: Remove this class and merge it with NamespaceScope
open class EgoTypes(val parentTypeScope: EgoTypes? = instance) {
    companion object {
        val instance: EgoTypes = EgoTypes(null)

        private val signedTypes = mutableListOf<EgoType>()
        private val unsignedTypes = mutableListOf<EgoType>()
        private val floatTypes = mutableListOf<EgoType>()

        val ERROR_TYPE = EgoType("error", "", 0u)
        val NULL = EgoType("null", "", 1u)
        val VOID = EgoType("void", "void", 0u)

        init {
            instance.types["error"] = ERROR_TYPE
            instance.addType(VOID)
            instance.addType(NULL)

            val bool = EgoType("bool", "i1", 1u)
            val u8 = EgoType("u8", "i8", 1u)
            val u16 = EgoType("u16", "i16", 2u)
            val u32 = EgoType("u32", "i32", 4u)
            val u64 = EgoType("u64", "i64", 8u)
            val i8 = EgoType("i8", "i8", 1u)
            val i16 = EgoType("i16", "i16", 2u)
            val i32 = EgoType("i32", "i32", 4u)
            val i64 = EgoType("i64", "i64", 8u)
            val f32 = EgoType("f32", "float", 1u)
            val f64 = EgoType("f64", "double", 8u)

            bool zeroExtend u8
            bool zeroExtend u32
            bool zeroExtend u64
            bool zeroExtend i8
            bool zeroExtend u16
            bool zeroExtend i16
            bool zeroExtend i32
            bool zeroExtend i64

            u8 truncate bool
            u8 zeroExtend u16
            u8 zeroExtend u32
            u8 zeroExtend u64
            u8 noopCast i8
            u8 zeroExtend i16
            u8 zeroExtend i32
            u8 zeroExtend i64

            i8 truncate bool
            i8 noopCast u8
            i8 zeroExtend u16
            i8 zeroExtend u32
            i8 zeroExtend u64
            i8 signExtend i16
            i8 signExtend i32
            i8 signExtend i64

            u16 truncate bool
            u16 truncate u8
            u16 zeroExtend u32
            u16 zeroExtend u64
            u16 truncate i8
            u16 noopCast i16
            u16 zeroExtend i32
            u16 zeroExtend i64

            i16 truncate bool
            i16 truncate u8
            i16 noopCast  u16
            i16 zeroExtend u32
            i16 zeroExtend u64
            i16 truncate  i8
            i16 signExtend i32
            i16 signExtend i64

            u32 truncate bool
            u32 truncate u8
            u32 truncate u16
            u32 zeroExtend u64
            u32 truncate i8
            u32 truncate i16
            u32 noopCast i32
            u32 zeroExtend i64

            i32 truncate bool
            i32 truncate u8
            i32 truncate u16
            i32 noopCast u32
            i32 zeroExtend u64
            i32 truncate i8
            i32 truncate i16
            i32 signExtend i64

            u64 truncate bool
            u64 truncate u8
            u64 truncate u16
            u64 truncate u32
            u64 truncate i8
            u64 truncate i16
            u64 truncate i32
            u64 noopCast i64

            i64 truncate bool
            i64 truncate u8
            i64 truncate u16
            i64 truncate u32
            i64 noopCast u64
            i64 truncate i8
            i64 truncate i16
            i64 truncate i32

            f32.makeCompatible(bool, "fcmp une float %0, 0.0")
            f32.makeCompatible(f64, "fpext float %0 to double")
            f64.makeCompatible(bool, "fcmp une double %0, 0.0")
            f64.makeCompatible(f32, "fptrunc double %0 to float")

            signedTypes.add(i8)
            signedTypes.add(i16)
            signedTypes.add(i32)
            signedTypes.add(i64)
            unsignedTypes.add(u8)
            unsignedTypes.add(u16)
            unsignedTypes.add(u32)
            unsignedTypes.add(u64)
            floatTypes.add(f32)
            floatTypes.add(f64)

            instance.addType(bool)
            instance.addType(EgoAliasType("char", u8))
            instance.addType(f32)
            instance.addType(f64)
            instance.addType(i8)
            instance.addType(i16)
            instance.addType(i32)
            instance.addType(i64)
            instance.addType(u8)
            instance.addType(u16)
            instance.addType(u32)
            instance.addType(u64)

            instance.addType(EgoType("str", "i8*", 1u))
        }
    }

    val types = HashMap<String, EgoType>()
    fun getType(name: String): EgoType? = types[name] ?: parentTypeScope?.getType(name)

    fun addType(type: EgoType): Boolean {
        if (types.containsKey(type.name)) {
            throw Error("Type ${type.name} already exists")
        }

        ERROR_TYPE.makeCompatible(type, "")
        types[type.name] = type
        return true
    }

    override fun toString(): String {
        val builder = StringBuilder()
        types.forEach() { (_, type) ->
            builder.append("| $type\n")
        }
        builder.append("+--------------------+\n")
        return builder.toString()
    }
}