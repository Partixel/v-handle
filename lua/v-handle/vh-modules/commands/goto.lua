local Command = VH_CommandLib.Command:new("Goto", VH_CommandLib.UserTypes.Admin, "Teleport yourself to the player.", "")
Command:addArg(VH_CommandLib.ArgTypes.Player, {required = true, notSelf = true})
Command:addAlias({Prefix = "!", Alias = {"goto", "gotofreeze"}})

Command.Callback = function(Sender, Alias, Target)
	Sender:PLForceTeleport(Target)
	if Alias == "gotofreeze" then
		Target:PLLock(true)
	end
	
	VH_CommandLib.SendCommandMessage(Sender, "teleported to", {Target}, "")
	
	return ""
end