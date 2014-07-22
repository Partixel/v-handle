hook.Add("PlayerSay", "vh_HandleCommands", function(Player, Message, TeamChat)
  if (TeamChat) then return end
  local Args = string.Explode(" ", Message)
  return vh.HandleCommands(Player, Args)
end)
