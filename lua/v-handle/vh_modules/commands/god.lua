local Command = _V.CommandLib.Command:new("God", _V.CommandLib.UserTypes.Admin, "Set the godmode of the player(s).", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = false})
Command:addAlias("!god", "!ungod", "!tgod")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	local Success, Toggle = _V.CommandLib.DoToggleableCommand(Alias, {"!god"}, {"!ungod"}, {"!tgod"})
	
	for _, ply in ipairs(Targets) do
		if Toggle then
			if ply:HasGodMode() then
				ply:GodDisable()
			else
				ply:GodEnable()
			end
		else
			if Success then
				ply:GodEnable()
			else
				ply:GodDisable()
			end
		end
	end
	
	return ""
end