local Command = _V.CommandLib.Command:new("Freeze", _V.CommandLib.UserTypes.Admin, "Freeze or thaw the player(s).", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, false)
Command:addAlias("!freeze", "!unfreeze", "!thaw", "!tfreeze")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	local Success = false
	local Toggle = false
	
	if string.lower(Alias) == "!freeze" then
		Success = true
		for _, ply in ipairs(Targets) do
			ply:Freeze(true)
		end
	end
	if string.lower(Alias) == "!unfreeze" or string.lower(Alias) == "!thaw" then
		Success = false
		for _, ply in ipairs(Targets) do
			ply:Freeze(true)
		end
	end
	if (string.lower(Alias) == "!tfreeze") then
		Toggle = true
		for _, ply in ipairs(Targets) do
			ply:Freeze(!ply:IsFrozen())
		end
	end

	local Nick = "Console"
	if Sender:IsValid() then
		Nick = Sender:Nick()
	end
	
	if Toggle then
		--vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has toggled freeze on _reset_ " .. vh.ArgsUtil.PlayersToString(Targets))
		return ""
	else
		--vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has " .. (!Success and "thawed" or "frozen") .. " _reset_ " .. vh.ArgsUtil.PlayersToString(Targets))
		return ""
	end
	return ""
end