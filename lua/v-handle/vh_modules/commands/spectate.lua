local Command = _V.CommandLib.Command:new("Spectate", _V.CommandLib.UserTypes.Admin, "Spectates the player.", "")
Command:addArg(_V.CommandLib.ArgTypes.Player, true)
Command:addAlias("!spectate")

Command.Callback = function(Sender, Alias, Target)
	-- Todo, right click toggle between spectating player and freeroam, jump to leave spectate
	Sender:SetObserverMode(OBS_MODE_CHASE)
	Sender:SpectateEntity(Target)
	
	return ""
end