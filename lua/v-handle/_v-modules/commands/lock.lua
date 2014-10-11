local Command = _V.CommandLib.Command:new("Lock", _V.CommandLib.UserTypes.Admin, "Lock or unlock the player(s).", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = false})
Command:addAlias("!lock", "!unlock", "!tlock")
Command:addConAlias("lock", "unlock", "tlock")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	local Success, Toggle = _V.CommandLib.DoToggleableCommand(Alias, {"!lock", "lock"}, {"!unlock", "unlock"}, {"!tlock", "tlock"})
	
	for _, ply in ipairs(Targets) do
		if Toggle then
			ply:PLLock(!ply:PLGetLocked())
		else
			ply:PLLock(Success)
		end
	end
	
	if Toggle then
		_V.CommandLib.SendCommandMessage(Sender, "toggled lock on", Targets, "")
	else
		_V.CommandLib.SendCommandMessage(Sender, (Success and "locked" or "unlocked"), Targets, "")
	end
	
	return ""
end