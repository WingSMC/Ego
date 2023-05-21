package wingsmc.ego.types

open class EgoTypes(private val parentTypeScope: EgoTypes? = instance) {
    companion object {
        val instance: EgoTypes = EgoTypes(null)
        val ERROR_TYPE = EgoType("error", 0u)
        val NULL = EgoType("null", 1u)
        val VOID = EgoType("void", 0u)

        init {
            instance.types["error"] = ERROR_TYPE
            instance.addPrimitiveType(VOID)
            instance.addPrimitiveType(NULL)

            val BOOL = EgoType("bool", 1u)
            val CHAR = EgoType("char", 1u)
            val FLOAT = EgoType("float", 1u)
            val DOUBLE = EgoType("double", 8u)
            val I8 = EgoType("i8", 1u)
            val I16 = EgoType("i16", 2u)
            val I32 = EgoType("i32", 4u)
            val I64 = EgoType("i64", 8u)
            val U8 = EgoType("u8", 1u)
            val U16 = EgoType("u16", 2u)
            val U32 = EgoType("u32", 4u)
            val U64 = EgoType("u64", 8u)

            BOOL.addParent(U8)
            CHAR.addParent(U8)
            I8.addParent(I16)
            I16.addParent(I32)
            I32.addParent(I64)
            U8.addParent(U16)
            U16.addParent(U32)
            U32.addParent(U64)
            FLOAT.addParent(DOUBLE)

            instance.addPrimitiveType(BOOL)
            instance.addPrimitiveType(CHAR)
            instance.addPrimitiveType(FLOAT)
            instance.addPrimitiveType(DOUBLE)
            instance.addPrimitiveType(I8)
            instance.addPrimitiveType(I16)
            instance.addPrimitiveType(I32)
            instance.addPrimitiveType(I64)
            instance.addPrimitiveType(U8)
            instance.addPrimitiveType(U16)
            instance.addPrimitiveType(U32)
            instance.addPrimitiveType(U64)

            instance.addComplexType(EgoType("str", 1u))
        }

        val globalTypes: EgoTypes
            get() {
                return instance
            }
    }

    val types = HashMap<String, EgoType>()
    fun getType(name: String): EgoType? = types[name] ?: parentTypeScope?.getType(name)

    fun addPrimitiveType(type: EgoType): Boolean {
        if (types.containsKey(type.name)) {
            println("Type ${type.name} already exists")
            return false
        }

        ERROR_TYPE.addParent(type)
        types[type.name] = type
        return true
    }
    fun addComplexType(type: EgoType): Boolean {
        if (addPrimitiveType(type)) {
            NULL.addParent(type)
            return true
        }
        return false
    }
}