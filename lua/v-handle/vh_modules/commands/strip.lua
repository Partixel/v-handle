local Command = _V.CommandLib.Command:new("Strip", _V.CommandLib.UserTypes.Admin, "Strips the player(s) weapons.", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = false})
Command:addAlias("!strip")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	
	for _, ply in ipairs(Targets) do
		ply:StripWeapons()
	end
	
	return ""
end