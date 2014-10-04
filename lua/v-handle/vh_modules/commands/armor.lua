local Command = _V.CommandLib.Command:new("Armor", _V.CommandLib.UserTypes.Admin, "Sets the player(s) armor to specified amount or 100.", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, false)
Command:addArg(_V.CommandLib.ArgTypes.Number, false)
Command:addAlias("!armor", "!shield")

Command.Callback = function(Sender, Alias, Targets, Amount)
	local Targets = Targets or {Sender}
	
	for _, ply in ipairs(Targets) do
		ply:SetArmor(Amount or 100)
	end
	
	return ""
end