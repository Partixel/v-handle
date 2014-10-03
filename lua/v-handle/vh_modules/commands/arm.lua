local Command = _V.CommandLib.Command:new("Arm", _V.CommandLib.UserTypes.Admin, "Arms the player with the default loadout.", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, false)
Command:addAlias("!arm", "!loadout")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	
	for _, ply in ipairs(Targets) do
		GAMEMODE:PlayerLoadout(ply)
	end

	local Nick = "Console"
	if Sender:IsValid() then
		Nick = Sender:Nick()
	end
	
	--vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has armed _reset_ " .. vh.ArgsUtil.PlayersToString(Targets) .. " _white_ to _reset_ ".. Amount)
	return ""
end