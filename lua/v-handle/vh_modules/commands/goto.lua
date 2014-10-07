local Command = _V.CommandLib.Command:new("Goto", _V.CommandLib.UserTypes.Admin, "Teleport yourself to the player.", "")
Command:addArg(_V.CommandLib.ArgTypes.Player, {required = true})
Command:addAlias("!goto")

Command.Callback = function(Sender, Alias, Target)
	Sender:Teleport(Target)
	
	_V.CommandLib.SendCommandMessage(Sender, "teleported to", {Target}, "")
	
	return ""
end