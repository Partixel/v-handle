--- Add resources --
VH_FileLib.AddResourceDir("materials/v-handle/")

-- Load configs --
VH_FileLib.IncludeDir("vh-config")

-- Load libs --
VH_FileLib.IncludeDir("vh-libs")

-- Load modules --
VH_FileLib.IncludeDir("vh-modules")

hook.Run("VH-PostModule")