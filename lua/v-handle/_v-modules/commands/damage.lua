local Command = _V.CommandLib.Command:new("Damage", _V.CommandLib.UserTypes.Admin, "Damages the player(s) by amount specified.", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = true})
Command:addArg(_V.CommandLib.ArgTypes.Number, {required = true})
Command:addAlias({Prefix = "!", Alias = {"damage", "slap"}})

Command.Callback = function(Sender, Alias, Targets, Amount)
	for _, ply in ipairs(Targets) do
		ply:TakeDamage(Amount, Sender, Sender)
	end
	
	_V.CommandLib.SendCommandMessage(Sender, "damaged", Targets, "with _reset_ "..Amount.. " _white_ damage")
	
	return ""
end