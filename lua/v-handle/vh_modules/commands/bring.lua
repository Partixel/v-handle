local Command = _V.CommandLib.Command:new("Bring", _V.CommandLib.UserTypes.Admin, "Teleport the player(s) to you.", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = true})
Command:addAlias("!bring")

Command.Callback = function(Sender, Alias, Targets)
	for _, ply in ipairs(Targets) do
		ply:Teleport(Sender)
	end
	
	_V.CommandLib.SendCommandMessage(Sender, "brought", Targets, "to them")
	
	return ""
end