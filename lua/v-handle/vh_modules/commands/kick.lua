local Command = _V.CommandLib.Command:new("Kick", _V.CommandLib.UserTypes.Admin, "Kick the player off the server for designated reason.", "")
Command:addArg(_V.CommandLib.ArgTypes.Player, true)
Command:addArg(_V.CommandLib.ArgTypes.String, true)
Command:addAlias("!kick")

Command.Callback = function(Sender, Alias, Target, Reason)
	Target:Kick(Reason)
	
	return ""
end