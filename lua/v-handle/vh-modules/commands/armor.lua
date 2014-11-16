local Command = VH_CommandLib.Command:new("Armor", VH_CommandLib.UserTypes.Admin, "Sets the player(s) armor to specified amount or 100.", "")
Command:addArg(VH_CommandLib.ArgTypes.Players, {required = true})
Command:addArg(VH_CommandLib.ArgTypes.Number, {required = false})
Command:addAlias({Prefix = "!", Alias = "armor"})

Command.Callback = function(Sender, Alias, Targets, Amount)
	for _, ply in ipairs(Targets) do
		ply:SetArmor(Amount or 100)
	end
	
	VH_CommandLib.SendCommandMessage(Sender, "set the armor of", Targets, "to _reset_ "..(Amount or 100))
	return ""
end