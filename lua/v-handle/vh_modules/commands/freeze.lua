local Command = _V.CommandLib.Command:new("Freeze", _V.CommandLib.UserTypes.Admin, "Freeze or thaw the player(s).", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, false)
Command:addAlias("!freeze", "!unfreeze", "!thaw", "!tfreeze")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	local Success = false
	local Toggle = false
	
	if string.lower(Alias) == "!freeze" then
		Success = true
	elseif string.lower(Alias) == "!unfreeze" or string.lower(Alias) == "!thaw" then
		Success = false
	elseif string.lower(Alias) == "!tfreeze" then
		Toggle = true
	end
	for _, ply in ipairs(Targets) do
		if Toggle then
			ply:Freeze(!ply:IsFrozen())
		else
			ply:Freeze(Success)
		end
	end
	
	return ""
end