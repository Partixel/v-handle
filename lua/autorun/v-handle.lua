vh = vh or {}
_V = _V or {}

if (SERVER) then
	include("v-handle/libs/V-FileLib/main.lua")
	include("v-handle/sv_main.lua")
	include("v-handle/sh_main.lua")
	AddCSLuaFile("v-handle/libs/V-FileLib/main.lua")
	AddCSLuaFile("v-handle/sh_main.lua")
	AddCSLuaFile("v-handle/cl_main.lua")
else
	include("v-handle/libs/V-FileLib/main.lua")
	include("v-handle/sh_main.lua")
	include("v-handle/cl_main.lua")
end
