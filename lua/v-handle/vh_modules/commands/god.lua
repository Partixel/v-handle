local Command = _V.CommandLib.Command:new("God", _V.CommandLib.UserTypes.Admin, "Gods or ungods the player(s).", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, false)
Command:addAlias("!god", "!ungod", "!immortal", "!mortal", "!tgod")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	local Success = false
	local Toggle = false
	
	if string.lower(Alias) == "!god" or string.lower(Alias) == "!immortal" then
		Success = true
		for _, ply in ipairs(Targets) do
			ply:GodEnable()
		end
	end
	if string.lower(Alias) == "!ungod" or string.lower(Alias) == "!mortal" then
		Success = false
		for _, ply in ipairs(Targets) do
			ply:GodDisable()
		end
	end
	if (string.lower(Alias) == "!tgod") then
		Toggle = true
		for _, ply in ipairs(Targets) do
			if ply:HasGodMode() then
				ply:GodDisable()
			else
				ply:GodEnable()
			end
		end
	end

	local Nick = "Console"
	if Sender:IsValid() then
		Nick = Sender:Nick()
	end
	
	if Toggle then
		--vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has toggled god mode on _reset_ " .. vh.ArgsUtil.PlayersToString(Targets))
		return ""
	else
		--vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has " .. (!Success and "" or "un") .. " godded _reset_ " .. vh.ArgsUtil.PlayersToString(Targets))
		return ""
	end
	return ""
end