local Command = _V.CommandLib.Command:new("Bring", _V.CommandLib.UserTypes.Admin, "Teleport the player(s) to you.", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = true})
Command:addAlias("!bring", "!bringfreeze")

Command.Callback = function(Sender, Alias, Targets)
	for _, ply in ipairs(Targets) do
		ply:Teleport(Sender)
		if Alias == "!bringfreeze" then
			ply:PLLock(true)
		end
	end
	
	_V.CommandLib.SendCommandMessage(Sender, "brought", Targets, "to them")
	
	return ""
end