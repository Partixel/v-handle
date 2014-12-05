local Command = VH_CommandLib.Command:new("Spectate", VH_CommandLib.UserTypes.Admin, "Spectates the player.", "")
Command:addArg(VH_CommandLib.ArgTypes.Plr, {required = true, notSelf = true})
Command:addAlias({Prefix = "!", Alias = "spectate"})

Command.Callback = function(Sender, Alias, Target)
	-- Todo, right click toggle between spectating player and freeroam, jump to leave spectate
	Sender:SetObserverMode(OBS_MODE_CHASE)
	Sender:SpectateEntity(Target)
	
	return ""
end