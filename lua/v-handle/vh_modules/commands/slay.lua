local Command = _V.CommandLib.Command:new("Slay", _V.CommandLib.UserTypes.Admin, "Slays the player(s).", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, false)
Command:addAlias("!kill", "!slay")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	
	for _, ply in ipairs(Targets) do
		ply:Kill()
	end
	
	local Nick = "Console"
	if Sender:IsValid() then
		Nick = Sender:Nick()
	end
	
	vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has slain _reset_ " .. vh.ArgsUtil.PlayersToString(Targets))
end