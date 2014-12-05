local Command = VH_CommandLib.Command:new("Arm", VH_CommandLib.UserTypes.Admin, "Gives the player(s) the default loadout.", "")
Command:addArg(VH_CommandLib.ArgTypes.Plrs, {required = false})
Command:addAlias({Prefix = "!", Alias = "arm"})

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	
	for _, ply in ipairs(Targets) do
		GAMEMODE:PlayerLoadout(ply)
	end
	
	VH_CommandLib.SendCommandMessage(Sender, "armed", Targets, "")
	
	return ""
end