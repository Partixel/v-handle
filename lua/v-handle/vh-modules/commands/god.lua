local Command = VH_CommandLib.Command:new("God", VH_CommandLib.UserTypes.Admin, "Set the godmode of the player(s).", "")
Command:addArg(VH_CommandLib.ArgTypes.Players, {required = true})
Command:addAlias({Prefix = "!", Alias = {"god", "ungod", "tgod"}})

Command.Callback = function(Sender, Alias, Targets)
	local Success, Toggle = VH_CommandLib.DoToggleableCommand(Alias, {"god"}, {"ungod"}, {"tgod"})
	
	for _, ply in ipairs(Targets) do
		if Toggle then
			ply:PLGod(!ply:HasGodMode())
		else
			ply:PLGod(Success)
		end
	end
	
	if Toggle then
		VH_CommandLib.SendCommandMessage(Sender, "toggled god mode on", Targets, "")
	else
		VH_CommandLib.SendCommandMessage(Sender, (Success and "" or "un").."godded", Targets, "")
	end
	
	return ""
end