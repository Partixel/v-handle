local Command = VH_CommandLib.Command:new("Damage", VH_CommandLib.UserTypes.Admin, "Damages the player(s) by amount specified.", "")
Command:addArg(VH_CommandLib.ArgTypes.Players, {required = true})
Command:addArg(VH_CommandLib.ArgTypes.Number, {required = true})
Command:addAlias({Prefix = "!", Alias = {"damage", "slap"}})

Command.Callback = function(Sender, Alias, Targets, Amount)
	for _, ply in ipairs(Targets) do
		ply:TakeDamage(Amount, Sender, Sender)
	end
	
	VH_CommandLib.SendCommandMessage(Sender, "damaged", Targets, "with _reset_ "..Amount.. " _white_ damage")
	
	return ""
end