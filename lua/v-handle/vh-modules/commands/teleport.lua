local Command = VH_CommandLib.Command:new("Teleport", VH_CommandLib.UserTypes.Admin, "Teleport the player(s) to another player.", "")
Command:addArg(VH_CommandLib.ArgTypes.Players, {required = true})
Command:addArg(VH_CommandLib.ArgTypes.Player, {required = true})
Command:addAlias({Prefix = "!", Alias = {"teleport", "tp"}})

Command.Callback = function(Sender, Alias, Targets, Target)
	for _, ply in ipairs(Targets) do
		ply:PLSafeTeleport(Target)
	end
	
	VH_CommandLib.SendCommandMessage(Sender, "sent", Targets, "to", {Target})
	
	return ""
end