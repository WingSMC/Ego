package wingsmc.ego.types

object EgoTypes {
    private val types = HashMap<String, EgoType>()

    private val ERROR_TYPE = EgoType("error")
    private val NULL = EgoType("null")

    init {
        types["error"] = ERROR_TYPE

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

        addPrimitiveType(EgoType("namespace"))
        addPrimitiveType(EgoType("void"))
        addPrimitiveType(EgoType("null"))
        addPrimitiveType(BOOL)
        addPrimitiveType(CHAR)
        addPrimitiveType(FLOAT)
        addPrimitiveType(DOUBLE)
        addPrimitiveType(I8)
        addPrimitiveType(I16)
        addPrimitiveType(I32)
        addPrimitiveType(I64)
        addPrimitiveType(U8)
        addPrimitiveType(U16)
        addPrimitiveType(U32)
        addPrimitiveType(U64)

        addComplexType(EgoType("string"))
        addComplexType(EgoType("list"))
    }

    fun getType(name: String): EgoType? {
        return types[name]
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