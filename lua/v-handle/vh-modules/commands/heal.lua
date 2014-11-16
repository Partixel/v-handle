local Command = VH_CommandLib.Command:new("Heal", VH_CommandLib.UserTypes.Admin, "Heal the player(s) or sets player(s) health to amount specified.", "")
Command:addArg(VH_CommandLib.ArgTypes.Players, {required = true})
Command:addArg(VH_CommandLib.ArgTypes.Number, {required = false})
Command:addAlias({Prefix = "!", Alias = "heal"})

Command.Callback = function(Sender, Alias, Targets, Amount)
	for _, ply in ipairs(Targets) do
		ply:SetHealth(Amount or ply:GetMaxHealth())
	end
	
	if not Amount or Amount == 100 then
		VH_CommandLib.SendCommandMessage(Sender, "healed", Targets, "")
	else
		VH_CommandLib.SendCommandMessage(Sender, "set the health of", Targets, "to _reset_ "..(Amount or 100))
	end
	
	return ""
end