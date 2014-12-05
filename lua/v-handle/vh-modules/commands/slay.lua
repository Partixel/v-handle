local Command = VH_CommandLib.Command:new("Slay", VH_CommandLib.UserTypes.Admin, "Kills the player(s).", "")
Command:addArg(VH_CommandLib.ArgTypes.Plrs, {required = true})
Command:addAlias({Prefix = "!", Alias = {"kill", "slay"}})

Command.Callback = function(Sender, Alias, Targets)
	for _, ply in ipairs(Targets) do
		ply:Kill()
	end
	
	VH_CommandLib.SendCommandMessage(Sender, "killed", Targets, "")
	
	return ""
end