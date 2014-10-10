local Command = _V.CommandLib.Command:new("Slay", _V.CommandLib.UserTypes.Admin, "Kills the player(s).", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = false})
Command:addAlias("!kill", "!slay")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	
	for _, ply in ipairs(Targets) do
		ply:Kill()
	end
	
	_V.CommandLib.SendCommandMessage(Sender, "killed", Targets, "")
	
	return ""
end