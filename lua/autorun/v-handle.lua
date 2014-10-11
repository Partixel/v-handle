vh = vh or {}

if (SERVER) then
	include("v-handle/_v-libs/v-filelib.lua")
	AddCSLuaFile("v-handle/_v-libs/v-filelib.lua")
	include("v-handle/sh_main.lua")
	AddCSLuaFile("v-handle/sh_main.lua")
else
	include("v-handle/_v-libs/v-filelib.lua")
	include("v-handle/sh_main.lua")
end
