local Command = _V.CommandLib.Command:new("Kick", _V.CommandLib.UserTypes.Admin, "Kick a player off the server.", "")
Command:addArg(_V.CommandLib.ArgTypes.Player)
Command:addArg(_V.CommandLib.ArgTypes.String)
Command:addAlias("!kick")

Command.Callback = function(Sender, Alias, Target, Reason)
	local Nick = "Console"
	if Player:IsValid() then
		Nick = Player:Nick()
	end
	
	Target:Kick(Reason)
	
	vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has kicked _reset_ " .. Target:Nick() .. " _white_ for the reason: _red_ " .. Reason)
end