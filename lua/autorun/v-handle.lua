vh = vh or {}

if (SERVER) then
	include("v-handle/sv_vh.lua")
	include("v-handle/sh_vh.lua")
	AddCSLuaFile("v-handle/sh_framework.lua")
	AddCSLuaFile("v-handle/cl_vh.lua")
else
	include("v-handle/sh_vh.lua")
	include("v-handle/cl_vh.lua")
end
