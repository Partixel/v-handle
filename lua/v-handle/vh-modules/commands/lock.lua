local Command = VH_CommandLib.Command:new("Lock", VH_CommandLib.UserTypes.Admin, "Lock or unlock the player(s).", "")
Command:addArg(VH_CommandLib.ArgTypes.Players, {required = true})
Command:addAlias({Prefix = "!", Alias = {"lock", "unlock", "tlock"}})

Command.Callback = function(Sender, Alias, Targets)
	local Success, Toggle = VH_CommandLib.DoToggleableCommand(Alias, {"lock"}, {"unlock"}, {"tlock"})
	
	for _, ply in ipairs(Targets) do
		if Toggle then
			ply:PLLock(!ply:PLGetLocked())
		else
			ply:PLLock(Success)
		end
	end
	
	if Toggle then
		VH_CommandLib.SendCommandMessage(Sender, "toggled lock on", Targets, "")
	else
		VH_CommandLib.SendCommandMessage(Sender, (Success and "locked" or "unlocked"), Targets, "")
	end
	
	return ""
end