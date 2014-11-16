local Command = VH_CommandLib.Command:new("Cloak", VH_CommandLib.UserTypes.Admin, "Set the invisibility of the player(s).", "")
Command:addArg(VH_CommandLib.ArgTypes.Players, {required = true})
Command:addAlias({Prefix = "!", Alias = {"cloak", "uncloak", "tcloak"}})

Command.Callback = function(Sender, Alias, Targets)
	local Success, Toggle = VH_CommandLib.DoToggleableCommand(Alias, {"cloak"}, {"uncloak"}, {"tcloak"})
	
	for _, ply in ipairs(Targets) do
		if Toggle then
			ply:SetNoDraw(!ply:GetNoDraw())
		else
			ply:SetNoDraw(Success)
		end
	end
	
	if Toggle then
		VH_CommandLib.SendCommandMessage(Sender, "toggled cloak on", Targets, "")
	else
		VH_CommandLib.SendCommandMessage(Sender, (Success and "" or "un").."cloaked", Targets, "")
	end
	
	return ""
end