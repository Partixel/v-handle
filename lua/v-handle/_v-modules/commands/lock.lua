local Command = _V.CommandLib.Command:new("Freeze", _V.CommandLib.UserTypes.Admin, "Freeze or thaw the player(s).", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = false})
Command:addAlias("!freeze", "!unfreeze", "!thaw", "!tfreeze")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	local Success, Toggle = _V.CommandLib.DoToggleableCommand(Alias, {"!freeze"}, {"!unfreeze", "!thaw"}, {"!tfreeze"})
	
	for _, ply in ipairs(Targets) do
		if Toggle then
			ply:PLLock(!ply:PLGetLocked())
		else
			ply:PLLock(Success)
		end
	end
	
	if Toggle then
		_V.CommandLib.SendCommandMessage(Sender, "toggled freeze on", Targets, "")
	else
		_V.CommandLib.SendCommandMessage(Sender, (Success and "froze" or "thawed"), Targets, "")
	end
	
	return ""
end