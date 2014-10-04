local Command = _V.CommandLib.Command:new("Heal", _V.CommandLib.UserTypes.Admin, "Heal the player(s) or sets player(s) health to amount specified.", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, false)
Command:addArg(_V.CommandLib.ArgTypes.Number, false)
Command:addAlias("!heal")

Command.Callback = function(Sender, Alias, Targets, Amount)
	local Targets = Targets or {Sender}
	
	for _, ply in ipairs(Targets) do
		ply:SetHealth(Amount or ply:GetMaxHealth())
	end
	
	return ""
end