--- Add resources --
VH_FileLib.AddResourceDir("materials/v-handle/")

-- Loading external files --
VH_FileLib.IncludeDir("vh-external")

-- Load configs --
VH_FileLib.IncludeDir("vh-config")

-- Load libs --
VH_FileLib.IncludeDir("vh-libs")

-- Load modules --
VH_FileLib.IncludeDir("vh-modules")

hook.Run("VH-PostModule")