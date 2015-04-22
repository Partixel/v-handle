if (SERVER) then
	include("v-handle/vh-libs/vh-filelib/vh-filelib.lua")
	AddCSLuaFile("v-handle/vh-libs/vh-filelib/vh-filelib.lua")
	include("v-handle/sh_main.lua")
	AddCSLuaFile("v-handle/sh_main.lua")
else
	include("v-handle/vh-libs/vh-filelib/vh-filelib.lua")
	include("v-handle/sh_main.lua")
end
