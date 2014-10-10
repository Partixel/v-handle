vh = vh or {}

if (SERVER) then
	include("v-handle/libs/V-FileLib/main.lua")
	AddCSLuaFile("v-handle/libs/V-FileLib/main.lua")
	include("v-handle/sh_main.lua")
	AddCSLuaFile("v-handle/sh_main.lua")
else
	include("v-handle/libs/V-FileLib/main.lua")
	include("v-handle/sh_main.lua")
end
