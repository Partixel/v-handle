vh = vh or {}

if (SERVER) then
	include("v-handle/sv_framework.lua")
	include("v-handle/sh_framework.lua")
	AddCSLuaFile("v-handle/sh_framework.lua")
else
	include("v-handle/sh_framework.lua")
end
