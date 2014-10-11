vh = vh or {}

if (SERVER) then
	include("v-handle/libs/v-filelib.lua")
	AddCSLuaFile("v-handle/libs/v-filelib.lua")
	include("v-handle/sh_main.lua")
	AddCSLuaFile("v-handle/sh_main.lua")
else
	include("v-handle/libs/V-filelib.lua")
	include("v-handle/sh_main.lua")
end
