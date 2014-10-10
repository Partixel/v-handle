local Command = _V.CommandLib.Command:new("Kick", _V.CommandLib.UserTypes.Admin, "Kick the player off the server for designated reason.", "")
Command:addArg(_V.CommandLib.ArgTypes.Player, {required = true})
Command:addArg(_V.CommandLib.ArgTypes.String, {required = true})
Command:addAlias("!kick")

Command.Callback = function(Sender, Alias, Target, Reason)
	Target:Kick(Reason)
	
	_V.CommandLib.SendCommandMessage(Sender, "kicked", Targets, "for the reason _reset_ "..Reason)
	return ""
end