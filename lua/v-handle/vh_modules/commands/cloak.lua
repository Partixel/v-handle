local Command = _V.CommandLib.Command:new("Cloak", nil, "", "Cloak or uncloak the player(s).")
Command:addArg(_V.CommandLib.ArgTypes.MultiTargetPlayer, false)
Command:addAlias("!cloak", "!uncloak", "!tcloak")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = _V.CommandLib.PlayersFromSID(Targets) or {Sender}
	local Success = false
	local Toggle = false
	
	if (string.lower(Alias) == "!cloak") then
		Success = true
		for _, ply in ipairs(Targets) do
			ply:SetNoDraw(true)
		end
	end
	if (string.lower(Alias) == "!uncloak") then
		Success = false
		for _, ply in ipairs(Targets) do
			ply:SetNoDraw(false)
		end
	end
	if (string.lower(Alias) == "!tcloak") then
		Toggle = true
		for _, ply in ipairs(Targets) do
			ply:SetNoDraw(!ply:GetNoDraw())
		end
	end

	local Nick = "Console"
	if Sender:IsValid() then
		Nick = Sender:Nick()
	end
	
	if Toggle then
		vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has toggled cloak on _reset_ " .. vh.ArgsUtil.PlayersToString(Targets))
	else
		vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has " .. (!Success and "un" or "") .. "cloaked _reset_ " .. vh.ArgsUtil.PlayersToString(Targets))
	end
end