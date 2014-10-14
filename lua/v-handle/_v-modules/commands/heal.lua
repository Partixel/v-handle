local Command = _V.CommandLib.Command:new("Heal", _V.CommandLib.UserTypes.Admin, "Heal the player(s) or sets player(s) health to amount specified.", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = true})
Command:addArg(_V.CommandLib.ArgTypes.Number, {required = false})
Command:addAlias({Prefix = "!", Alias = "heal"})

Command.Callback = function(Sender, Alias, Targets, Amount)
	for _, ply in ipairs(Targets) do
		ply:SetHealth(Amount or ply:GetMaxHealth())
	end
	
	if not Amount or Amount == 100 then
		_V.CommandLib.SendCommandMessage(Sender, "healed", Targets, "")
	else
		_V.CommandLib.SendCommandMessage(Sender, "set the health of", Targets, "to _reset_ "..(Amount or 100))
	end
	
	return ""
end