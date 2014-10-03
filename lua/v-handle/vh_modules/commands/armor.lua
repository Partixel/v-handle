local Command = _V.CommandLib.Command:new("Armor", _V.CommandLib.UserTypes.Admin, "Sets the player(s) armor.", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, false)
Command:addArg(_V.CommandLib.ArgTypes.Number, true)
Command:addAlias("!armor", "!shield")

Command.Callback = function(Sender, Alias, Targets, Amount)
	local Targets = Targets or {Sender}
	
	for _, ply in ipairs(Targets) do
		ply:SetArmor(Amount)
	end

	local Nick = "Console"
	if Sender:IsValid() then
		Nick = Sender:Nick()
	end
	
	--vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has set the armor of _reset_ " .. vh.ArgsUtil.PlayersToString(Targets) .. " _white_ to _reset_ ".. Amount)
	return ""
end