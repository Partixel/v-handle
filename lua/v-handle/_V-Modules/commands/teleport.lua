local Command = _V.CommandLib.Command:new("Teleport", _V.CommandLib.UserTypes.Admin, "Teleport the player(s) another player.", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = true})
Command:addArg(_V.CommandLib.ArgTypes.Player, {required = true})
Command:addAlias("!teleport")

Command.Callback = function(Sender, Alias, Targets, Target)
	local Targets = Targets or {Sender}
	
	for _, ply in ipairs(Targets) do
		ply:Teleport(Target)
	end
	
	_V.CommandLib.SendCommandMessage(Sender, "sent", Targets, "to", {Target})
	
	return ""
end