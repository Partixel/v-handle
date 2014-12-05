local Command = VH_CommandLib.Command:new("Send", VH_CommandLib.UserTypes.Admin, "Send the player(s) to another player.", "")
Command:addArg(VH_CommandLib.ArgTypes.Plrs, {required = true})
Command:addArg(VH_CommandLib.ArgTypes.Plr, {required = true})
Command:addAlias({Prefix = "!", Alias = {"send"}})

Command.Callback = function(Sender, Alias, Targets, Target)
	for _, ply in ipairs(Targets) do
		ply:PLSafeTeleport(Target)
	end
	
	VH_CommandLib.SendCommandMessage(Sender, "sent", Targets, "to", {Target})
	
	return ""
end