local Command = VH_CommandLib.Command:new("Bring", VH_CommandLib.UserTypes.Admin, "Teleport the player(s) to you.", "")
Command:addArg(VH_CommandLib.ArgTypes.Plrs, {required = true, notSelf = true})
Command:addAlias({Prefix = "!", Alias = {"bring", "bringfreeze"}})

Command.Callback = function(Sender, Alias, Targets)
	for _, ply in ipairs(Targets) do
		ply:PLForceTeleport(Sender)
		if Alias == "bringfreeze" then
			ply:PLLock(true)
		end
	end
	
	VH_CommandLib.SendCommandMessage(Sender, "brought", Targets, "to them")
	
	return ""
end