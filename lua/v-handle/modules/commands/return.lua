local Command = VH_CommandLib.Command:new("Return", VH_CommandLib.UserTypes.Admin, "Return the player to last teleport position.", "")
Command:addArg(VH_CommandLib.ArgTypes.Plr, {required = true})
Command:addAlias({Prefix = "!", Alias = "return"})

Command.Callback = function(Sender, Alias, Target)
	Target:PLForceTeleport(Target:PLGetLastPos())
	
	VH_CommandLib.SendCommandMessage(Sender, "returned", {Target}, "to their last position")
	
	return ""
end