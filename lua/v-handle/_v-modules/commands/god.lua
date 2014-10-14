local Command = _V.CommandLib.Command:new("God", _V.CommandLib.UserTypes.Admin, "Set the godmode of the player(s).", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = true})
Command:addAlias({Prefix = "!", Alias = {"god", "ungod", "tgod"}})

Command.Callback = function(Sender, Alias, Targets)
	local Success, Toggle = _V.CommandLib.DoToggleableCommand(Alias, {"god"}, {"ungod"}, {"tgod"})
	
	for _, ply in ipairs(Targets) do
		if Toggle then
			ply:PLGod(!ply:HasGodMode())
		else
			ply:PLGod(Success)
		end
	end
	
	if Toggle then
		_V.CommandLib.SendCommandMessage(Sender, "toggled god mode on", Targets, "")
	else
		_V.CommandLib.SendCommandMessage(Sender, (Success and "" or "un").."godded", Targets, "")
	end
	
	return ""
end