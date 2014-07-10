include("vm_framework.lua")
AddCSLuaFile("vm_framework.lua")

hook.Add("PlayerSay", "vm_HandleCommands", function(Player, Message, TeamChat)
  if (TeamChat) then return end
  local Args = string.Explode(" ", Message)
  return vm:HandleCommands(Player, Args)
end)
