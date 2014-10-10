-- Add resources --
_V.FileLib.AddResourceDir("materials/vhandle/")

-- Loading external files --
_V.FileLib.IncludeDir("_V-External")

-- Load libs --
_V.FileLib.IncludeDir("_V-Libs")

-- Load modules --
_V.FileLib.IncludeDir("_V-Modules")

hook.Run("_V-PostModule")