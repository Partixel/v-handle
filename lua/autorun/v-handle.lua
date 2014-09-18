vh = vh or {}

if (SERVER) then
	include("v-handle/libs/V-FileLib/main.lua")
	include("v-handle/sv_main.lua")
	include("v-handle/sh_main.lua")
	AddCSLuaFile("v-handle/libs/V-FileLib/main.lua")
	AddCSLuaFile("v-handle/sh_main.lua")
	AddCSLuaFile("v-handle/cl_main.lua")
	resource.AddFile("materials/vhandle/adverts.png")
	resource.AddFile("materials/vhandle/bans.png")
	resource.AddFile("materials/vhandle/commands.png")
	resource.AddFile("materials/vhandle/logs.png")
	resource.AddFile("materials/vhandle/ranks.png")
	resource.AddFile("materials/vhandle/reports.png")
	resource.AddFile("materials/vhandle/settings.png")
	resource.AddFile("materials/vhandle/warnings.png")
else
	include("v-handle/libs/V-FileLib/main.lua")
	include("v-handle/sh_main.lua")
	include("v-handle/cl_main.lua")
end
