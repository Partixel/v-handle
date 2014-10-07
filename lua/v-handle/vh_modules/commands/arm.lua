local Command = _V.CommandLib.Command:new("Arm", _V.CommandLib.UserTypes.Admin, "Gives the player(s) the default loadout.", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = false})
Command:addAlias("!arm")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	
	for _, ply in ipairs(Targets) do
		GAMEMODE:PlayerLoadout(ply)
	end
	
	_V.CommandLib.SendCommandMessage(Sender, "armed", Targets, "")
	
	return ""
end