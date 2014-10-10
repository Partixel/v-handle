local Command = _V.CommandLib.Command:new("Banish", _V.CommandLib.UserTypes.Admin, "Banish the player(s) to spawn.", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = false})
Command:addAlias("!banish")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	
	for _, ply in ipairs(Targets) do
		GM:PlayerSelectSpawn(ply)
	end
	
	_V.CommandLib.SendCommandMessage(Sender, "sent", Targets, "to spawn")
	
	return ""
end