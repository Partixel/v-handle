local Command = _V.CommandLib.Command:new("Return", _V.CommandLib.UserTypes.Admin, "Return the player to last teleport position.", "")
Command:addArg(_V.CommandLib.ArgTypes.Player, {required = false})
Command:addAlias("!return")

Command.Callback = function(Sender, Alias, Target)
	local Target = Target or Sender
	
	Target:SetPos(Target:PLGetLastPos())
	
	_V.CommandLib.SendCommandMessage(Sender, "returned", {Target}, "to their last position")
	
	return ""
end