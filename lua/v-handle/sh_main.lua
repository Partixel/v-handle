-- Add resources --
_V.FileLib.AddResourceDir("materials/vhandle/")

-- Loading external files --
_V.FileLib.IncludeDir("_v-external")

-- Load libs --
_V.FileLib.IncludeDir("_v-libs")

-- Load modules --
_V.FileLib.IncludeDir("_v-modules")

hook.Run("_V-PostModule")