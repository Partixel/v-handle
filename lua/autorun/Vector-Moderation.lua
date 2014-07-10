vm = vm or {}

if (SERVER) then
	include("vector-moderation/sv_framework.lua")
	include("vector-moderation/vm_framework.lua")
	AddCSLuaFile("vector-moderation/vm_util.lua")
	AddCSLuaFile("vector-moderation/vm_framework.lua")
else
	include("vector-moderation/vm_framework.lua")
end
