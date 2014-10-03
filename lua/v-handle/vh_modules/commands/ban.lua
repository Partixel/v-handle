local Command = _V.CommandLib.Command:new("Ban", _V.CommandLib.UserTypes.Admin, "Bans the player.", "")
Command:addArg(_V.CommandLib.ArgTypes.Player, true)
Command:addArg(_V.CommandLib.ArgTypes.Number, true)
Command:addArg(_V.CommandLib.ArgTypes.String, true)
Command:addAlias("!ban")

Command.Callback = function(Sender, Alias, Target, Time, Reason)
	local Nick = "Console"
	if Sender:IsValid() then
		Nick = Sender:Nick()
	end
	
	--vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has banned _reset_ " .. Target:Nick() .. " _white_ for _reset_ ".. string.NiceTime(Time) .. " _white for the reason: _red_ " .. Reason)

	Target:Ban(Time)
	Target:Kick(Reason)
	return ""
end