local Command = _V.CommandLib.Command:new("Teleport", _V.CommandLib.UserTypes.Admin, "Teleport the player(s) to another player.", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = true})
Command:addArg(_V.CommandLib.ArgTypes.Player, {required = true})
Command:addAlias({Prefix = "!", Alias = {"teleport", "tp"})

Command.Callback = function(Sender, Alias, Targets, Target)
	for _, ply in ipairs(Targets) do
		ply:PLSafeTeleport(Target)
	end
	
	_V.CommandLib.SendCommandMessage(Sender, "sent", Targets, "to", {Target})
	
	return ""
end