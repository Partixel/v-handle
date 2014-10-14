local Command = _V.CommandLib.Command:new("Banish", _V.CommandLib.UserTypes.Admin, "Banish the player(s) to spawn.", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = true})
Command:addAlias({Prefix = "!", Alias = "banish"})

Command.Callback = function(Sender, Alias, Targets)
	for _, ply in ipairs(Targets) do
		GM:PlayerSelectSpawn(ply)
	end
	
	_V.CommandLib.SendCommandMessage(Sender, "sent", Targets, "to spawn")
	
	return ""
end