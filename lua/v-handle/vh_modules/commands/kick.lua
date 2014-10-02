local Command = _V.CommandLib.Command:new("Kick", nil, "", "Kick a player off the server.")
Command:addArg(_V.CommandLib.ArgTypes.Player, true)
Command:addArg(_V.CommandLib.ArgTypes.String, true)
Command:addAlias("!kick")

Command.Callback = function(Sender, Alias, Target, Reason)
	local Nick = "Console"
	if Player:IsValid() then
		Nick = Player:Nick()
	end
	
	Target:Kick(Reason)
	
	vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has kicked _reset_ " .. Target:Nick() .. " _white_ for the reason: _red_ " .. Reason)
end