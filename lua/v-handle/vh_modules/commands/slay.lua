local Command = _V.CommandLib.Command:new("Slay", nil, "", "Slays the player(s).")
Command:addArg(_V.CommandLib.ArgTypes.MultiTargetPlayer, false)
Command:addAlias("!kill", "!slay")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = _V.CommandLib.PlayersFromSID(Targets) or {Sender}
	
	for _, ply in ipairs(Targets) do
		ply:Kill()
	end
	
	local Nick = "Console"
	if Sender:IsValid() then
		Nick = Sender:Nick()
	end
	
	vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has slain _reset_ " .. vh.ArgsUtil.PlayersToString(Targets))
end