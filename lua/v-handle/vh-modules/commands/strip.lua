local Command = VH_CommandLib.Command:new("Strip", VH_CommandLib.UserTypes.Admin, "Strips the player(s) weapons.", "")
Command:addArg(VH_CommandLib.ArgTypes.Players, {required = true})
Command:addAlias({Prefix = "!", Alias = "strip"})

Command.Callback = function(Sender, Alias, Targets)
	for _, ply in ipairs(Targets) do
		ply:StripWeapons()
	end
	
	VH_CommandLib.SendCommandMessage(Sender, "stripped the weapons from", Targets, "")
	
	return ""
end