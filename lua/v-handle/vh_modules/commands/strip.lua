local Command = _V.CommandLib.Command:new("Strip", _V.CommandLib.UserTypes.Admin, "Strips the weapons from the player(s).", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, false)
Command:addAlias("!strip")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	
	for _, ply in ipairs(Targets) do
		ply:StripWeapons()
	end

	local Nick = "Console"
	if Sender:IsValid() then
		Nick = Sender:Nick()
	end
	
	--vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has armed _reset_ " .. vh.ArgsUtil.PlayersToString(Targets) .. " _white_ to _reset_ ".. Amount)
	return ""
end