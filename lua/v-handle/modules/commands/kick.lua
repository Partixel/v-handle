local Command = VH_CommandLib.Command:new("Kick", VH_CommandLib.UserTypes.Admin, "Kick the player off the server for designated reason.", "")
Command:addArg(VH_CommandLib.ArgTypes.Plr, {required = true, notself = true})
Command:addArg(VH_CommandLib.ArgTypes.String, {required = true})
Command:addAlias({Prefix = "!", Alias = "kick"})

Command.Callback = function(Sender, Alias, Target, Reason)
	Target:Kick(Reason)
	
	VH_CommandLib.SendCommandMessage(Sender, "kicked", Targets, "for the reason _reset_ "..Reason)
	return ""
end