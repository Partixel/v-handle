local Command = _V.CommandLib.Command:new("Slap", _V.CommandLib.UserTypes.Admin, "Damages the player(s) by amount specified.", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, false)
Command:addArg(_V.CommandLib.ArgTypes.Number, true)
Command:addAlias("!slap", "!damage")

Command.Callback = function(Sender, Alias, Targets, Amount)
	local Targets = Targets or {Sender}
	
	for _, ply in ipairs(Targets) do
		ply:TakeDamage(Amount, Sender, Sender)
	end
	
	return ""
end