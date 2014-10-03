local Command = _V.CommandLib.Command:new("Strip", _V.CommandLib.UserTypes.Admin, "Strips the weapons from the player(s).", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, false)
Command:addAlias("!mute", "!unmute", "!tmute")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	local Success = false
	local Toggle = false
	
	if string.lower(Alias) == "!mute" then
		Success = true
		for _, ply in ipairs(Targets) do
			ply:SetNWBool("Muted", true)
			ply:SendLua("LocalPlayer():ConCommand(\"-voicerecord\")")
		end
	end
	if string.lower(Alias) == "!unmute" then
		Success = false
		for _, ply in ipairs(Targets) do
			ply:SetNWBool("Muted", false)
		end
	end
	if (string.lower(Alias) == "!tmute") then
		Toggle = true
		for _, ply in ipairs(Targets) do
			ply:SetNWBool("Muted", ply:GetNWBool("Muted"))
			ply:SendLua("LocalPlayer():ConCommand(\"-voicerecord\")")
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

hook.Add("PlayerStartVoice", "PlayerStartVoice", function(Player)
	if (Player:GetNWBool("Muted")) then
		Player:SendLua("LocalPlayer():ConCommand(\"-voicerecord\")")
	end
end