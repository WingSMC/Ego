package wingsmc.ego.modules

object EgoModuleCache: java.io.Serializable {
    val rootScope: EgoNamespaceScope
    val dependencies: EgoNamespaceScope

    init {
        // TODO invalidate cache entries if certain modules are updated
        var lRootScope: EgoNamespaceScope? = null
        var lDependencies: EgoNamespaceScope? = null
        try {
            java.io.ObjectInputStream(java.io.FileInputStream(".egocache")).use {
                val cache = it.readObject() as EgoModuleCache
                lRootScope = cache.rootScope
                lDependencies = cache.dependencies
            }
        } catch (_: java.io.FileNotFoundException) {
        } catch (_: Exception) {
            lRootScope = null
            lDependencies = null
            System.err.println("Possible cache corruption, ignoring cache...")
        } finally {
            rootScope = lRootScope ?: EgoNamespaceScope("p-root", EgoVisibility.PUBLIC, EgoNamespaceType.MODULE)
            dependencies = lDependencies ?: EgoNamespaceScope("d-root", EgoVisibility.PUBLIC, EgoNamespaceType.MODULE)
        }
    }

    fun save() {
        /*
        java.io.ObjectOutputStream(java.io.FileOutputStream(".egocache")).use {
            it.writeObject(this)
        }
        */
    }
}
