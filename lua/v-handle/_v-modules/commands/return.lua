local Command = _V.CommandLib.Command:new("Return", _V.CommandLib.UserTypes.Admin, "Return the player to last teleport position.", "")
Command:addArg(_V.CommandLib.ArgTypes.Player, {required = true})
Command:addAlias({Prefix = "!", Alias = "return"})

Command.Callback = function(Sender, Alias, Target)
	Target:PLForceTeleport(Target:PLGetLastPos())
	
	_V.CommandLib.SendCommandMessage(Sender, "returned", {Target}, "to their last position")
	
	return ""
end