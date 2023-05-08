package wingsmc.ego.types

class EgoTypes(private val parentTypeScope: EgoTypes? = instance) {
    companion object {
        private lateinit var instance: EgoTypes;
        private val ERROR_TYPE = EgoType("error")
        private val NULL = EgoType("null")

        val globalTypes: EgoTypes
            get() {
                if (::instance.isInitialized) {
                    return instance
                }

                instance = EgoTypes(null)

                instance.types["error"] = ERROR_TYPE

                val BOOL = EgoType("bool")
                val CHAR = EgoType("char")
                val FLOAT = EgoType("float")
                val DOUBLE = EgoType("double")
                val I8 = EgoType("i8")
                val I16 = EgoType("i16")
                val I32 = EgoType("i32")
                val I64 = EgoType("i64")
                val U8 = EgoType("u8")
                val U16 = EgoType("u16")
                val U32 = EgoType("u32")
                val U64 = EgoType("u64")

                BOOL.addParent(U8)
                CHAR.addParent(U8)
                I8.addParent(I16)
                I16.addParent(I32)
                I32.addParent(I64)
                U8.addParent(U16)
                U16.addParent(U32)
                U32.addParent(U64)
                FLOAT.addParent(DOUBLE)

                instance.addPrimitiveType(EgoType("void"))
                instance.addPrimitiveType(EgoType("null"))
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

                instance.addComplexType(EgoType("string"))
                instance.addComplexType(EgoType("list"))

                return instance
            }
    }

    private val types = HashMap<String, EgoType>()

    fun getType(name: String): EgoType? {
        return types[name] ?: parentTypeScope?.getType(name)
    }

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