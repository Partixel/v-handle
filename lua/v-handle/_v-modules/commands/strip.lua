local Command = _V.CommandLib.Command:new("Strip", _V.CommandLib.UserTypes.Admin, "Strips the player(s) weapons.", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = true})
Command:addAlias({Prefix = "!", Alias = "strip"})

Command.Callback = function(Sender, Alias, Targets)
	for _, ply in ipairs(Targets) do
		ply:StripWeapons()
	end
	
	_V.CommandLib.SendCommandMessage(Sender, "stripped the weapons from", Targets, "")
	
	return ""
end