local Command = VH_CommandLib.Command:new("Banish", VH_CommandLib.UserTypes.Admin, "Banish the player(s) to spawn.", "")
Command:addArg(VH_CommandLib.ArgTypes.Plrs, {required = true})
Command:addAlias({Prefix = "!", Alias = "banish"})

Command.Callback = function(Sender, Alias, Targets)
	for _, ply in ipairs(Targets) do
		GM:PlayerSelectSpawn(ply)
	end
	
	VH_CommandLib.SendCommandMessage(Sender, "sent", Targets, "to spawn")
	
	return ""
end