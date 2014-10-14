local Command = _V.CommandLib.Command:new("Unstuck", _V.CommandLib.UserTypes.Admin, "Sends you to the nearest unoccupied position.", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = true})
Command:addAlias({Prefix = "!", Alias = "unstuck"})

Command.Callback = function(Sender, Alias, Targets)
	for _, ply in ipairs(Targets) do
		ply:PLSafeTeleport(ply)
	end
	
	_V.CommandLib.SendCommandMessage(Sender, "unstuck", Targets, "")
	
	return ""
end