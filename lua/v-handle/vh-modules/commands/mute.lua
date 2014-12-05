local Command = VH_CommandLib.Command:new("MuteMic", VH_CommandLib.UserTypes.Admin, "Mute or unmute the player(s) microphone.", "")
Command:addArg(VH_CommandLib.ArgTypes.Plrs, {required = true})
Command:addAlias({Prefix = "!", Alias = {"mutemic", "unmutemic", "tmutemic"}})

Command.Callback = function(Sender, Alias, Targets)
	local Success, Toggle = VH_CommandLib.DoToggleableCommand(Alias, {"mutemic"}, {"unmutemic"}, {"tmutemic"})
	
	for _, ply in ipairs(Targets) do
		if Toggle then
			ply:PLMuteMic(!ply:PLGetMicMuted())
		else
			ply:PLMuteMic(Success)
		end
	end
	
	if Toggle then
		VH_CommandLib.SendCommandMessage(Sender, "toggled microphone mute on", Targets, "")
	else
		VH_CommandLib.SendCommandMessage(Sender, (Success and "" or "un-").."microphone muted", Targets, "")
	end
	
	return ""
end

local Command = VH_CommandLib.Command:new("MuteChat", VH_CommandLib.UserTypes.Admin, "Mute or unmute the player(s) chat.", "")
Command:addArg(VH_CommandLib.ArgTypes.Plrs, {required = true})
Command:addAlias({Prefix = "!", Alias = {"mutechat", "unmutechat", "tmutechat"}})

Command.Callback = function(Sender, Alias, Targets)
	local Success, Toggle = VH_CommandLib.DoToggleableCommand(Alias, {"mutechat"}, {"unmutechat"}, {"tmutechat"})
	
	for _, ply in ipairs(Targets) do
		if Toggle then
			ply:PLMuteChat(!ply:PLGetChatMuted())
		else
			ply:PLMuteChat(Success)
		end
	end
	
	if Toggle then
		VH_CommandLib.SendCommandMessage(Sender, "toggled chat mute on", Targets, "")
	else
		VH_CommandLib.SendCommandMessage(Sender, (Success and "" or "un-").."chat muted", Targets, "")
	end
	
	return ""
end

local Command = VH_CommandLib.Command:new("Mute", VH_CommandLib.UserTypes.Admin, "Mute or unmute the player(s) chat and and microphone.", "")
Command:addArg(VH_CommandLib.ArgTypes.Plrs, {required = true})
Command:addAlias({Prefix = "!", Alias = {"mute", "unmute", "tmute"}})

Command.Callback = function(Sender, Alias, Targets)
	local Success, Toggle = VH_CommandLib.DoToggleableCommand(Alias, {"mute"}, {"unmute"}, {"tmute"})
	
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
		VH_CommandLib.SendCommandMessage(Sender, "toggled mute on", Targets, "")
	else
		VH_CommandLib.SendCommandMessage(Sender, (Success and "" or "un").."muted", Targets, "")
	end
	
	return ""
end