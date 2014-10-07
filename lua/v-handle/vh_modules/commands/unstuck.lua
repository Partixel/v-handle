local Command = _V.CommandLib.Command:new("Unstuck", _V.CommandLib.UserTypes.Admin, "Sends you to the nearest unoccupied position.", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = false})
Command:addAlias("!unstuck")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	
	for _, ply in ipairs(Targets) do
		ply:Teleport(ply)
	end
	
	_V.CommandLib.SendCommandMessage(Sender, "unstucked", Targets, "")
	
	return ""
end