local Command = _V.CommandLib.Command:new("MuteMic", _V.CommandLib.UserTypes.Admin, "Mute or unmute the player(s) microphone.", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = false})
Command:addAlias("!mutemic", "!unmutemic", "!tmutemic")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	local Success, Toggle = _V.CommandLib.DoToggleableCommand(Alias, {"!mutemic"}, {"!unmutemic"}, {"!tmutemic"})
	
	for _, ply in ipairs(Targets) do
		if Toggle then
			ply:PLMuteMic(!ply:PLGetMicMuted())
		else
			ply:PLMuteMic(Success)
		end
	end
	
	if Toggle then
		_V.CommandLib.SendCommandMessage(Sender, "toggled microphone mute on", Targets, "")
	else
		_V.CommandLib.SendCommandMessage(Sender, (Success and "" or "un-").."microphone muted", Targets, "")
	end
	
	return ""
end

local Command = _V.CommandLib.Command:new("MuteChat", _V.CommandLib.UserTypes.Admin, "Mute or unmute the player(s) chat.", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = false})
Command:addAlias("!mutechat", "!unmutechat", "!tmutechat")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	local Success, Toggle = _V.CommandLib.DoToggleableCommand(Alias, {"!mutechat"}, {"!unmutechat"}, {"!tmutechat"})
	
	for _, ply in ipairs(Targets) do
		if Toggle then
			ply:PLMuteChat(!ply:PLGetChatMuted())
		else
			ply:PLMuteChat(Success)
		end
	end
	
	if Toggle then
		_V.CommandLib.SendCommandMessage(Sender, "toggled chat mute on", Targets, "")
	else
		_V.CommandLib.SendCommandMessage(Sender, (Success and "" or "un-").."chat muted", Targets, "")
	end
	
	return ""
end

local Command = _V.CommandLib.Command:new("Mute", _V.CommandLib.UserTypes.Admin, "Mute or unmute the player(s) chat and and microphone.", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = false})
Command:addAlias("!mute", "!unmute", "!tmute")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	local Success, Toggle = _V.CommandLib.DoToggleableCommand(Alias, {"!mute"}, {"!unmute"}, {"!tmute"})
	
	for _, ply in ipairs(Targets) do
		if Toggle then
			ply:PLMuteChat(!ply:PLGetChatMuted())
			ply:PLMuteMic(!ply:PLGetMicMuted())
		else
			ply:PLMuteChat(Success)
			ply:PLMuteMic(Success)
		end
	end
	
	if Toggle then
		_V.CommandLib.SendCommandMessage(Sender, "toggled mute on", Targets, "")
	else
		_V.CommandLib.SendCommandMessage(Sender, (Success and "" or "un").."muted", Targets, "")
	end
	
	return ""
end