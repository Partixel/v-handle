local Command = _V.CommandLib.Command:new("Arm", _V.CommandLib.UserTypes.Admin, "Gives the player(s) the default loadout.", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, false)
Command:addAlias("!arm", "!loadout")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	
	for _, ply in ipairs(Targets) do
		GAMEMODE:PlayerLoadout(ply)
	end
	
	return ""
end