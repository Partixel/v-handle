local Command = VH_CommandLib.Command:new("Unstuck", VH_CommandLib.UserTypes.Admin, "Sends you to the nearest unoccupied position.", "")
Command:addArg(VH_CommandLib.ArgTypes.Players, {required = true})
Command:addAlias({Prefix = "!", Alias = "unstuck"})

Command.Callback = function(Sender, Alias, Targets)
	for _, ply in ipairs(Targets) do
		ply:PLSafeTeleport(ply)
	end
	
	VH_CommandLib.SendCommandMessage(Sender, "unstuck", Targets, "")
	
	return ""
end