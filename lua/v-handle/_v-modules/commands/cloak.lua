local Command = _V.CommandLib.Command:new("Cloak", _V.CommandLib.UserTypes.Admin, "Set the invisibility of the player(s).", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = false})
Command:addAlias("!cloak", "!uncloak", "!tcloak")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	local Success, Toggle = _V.CommandLib.DoToggleableCommand(Alias, {"!cloak"}, {"!uncloak"}, {"!tcloak"})
	
	for _, ply in ipairs(Targets) do
		if Toggle then
			ply:SetNoDraw(!ply:GetNoDraw())
		else
			ply:SetNoDraw(Success)
		end
	end
	
	if Toggle then
		_V.CommandLib.SendCommandMessage(Sender, "toggled cloak on", Targets, "")
	else
		_V.CommandLib.SendCommandMessage(Sender, (Success and "" or "un").."cloaked", Targets, "")
	end
	
	return ""
end