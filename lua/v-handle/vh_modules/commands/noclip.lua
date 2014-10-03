local Command = _V.CommandLib.Command:new("Noclip", _V.CommandLib.UserTypes.Admin, "Noclip or clip the player(s).", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, false)
Command:addAlias("!noclip", "!unnoclip", "!clip", "!tnoclip")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	local Success = false
	local Toggle = false
	
	if string.lower(Alias) == "!noclip" then
		Success = true
		for _, ply in ipairs(Targets) do
			ply:SetMoveType(MOVETYPE_NOCLIP)
		end
	end
	if string.lower(Alias) == "!unnoclip" or string.lower(Alias) == "!clip" then
		Success = false
		for _, ply in ipairs(Targets) do
			ply:SetMoveType(MOVETYPE_WALK)
		end
	end
	if (string.lower(Alias) == "!tnoclip") then
		Toggle = true
		for _, ply in ipairs(Targets) do
			if ply:GetMoveType() == MOVETYPE_NOCLIP then
				ply:SetMoveType(MOVETYPE_WALK)
			else
				ply:SetMoveType(MOVETYPE_NOCLIP)
			end
		end
	end

	local Nick = "Console"
	if Sender:IsValid() then
		Nick = Sender:Nick()
	end
	
	if Toggle then
		--vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has toggled freeze on _reset_ " .. vh.ArgsUtil.PlayersToString(Targets))
	else
		--vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has " .. (!Success and "thawed" or "frozen") .. " _reset_ " .. vh.ArgsUtil.PlayersToString(Targets))
	end
	return ""
end