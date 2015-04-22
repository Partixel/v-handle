local Command = VH_CommandLib.Command:new("Noclip", VH_CommandLib.UserTypes.Admin, "Noclip or clip the player(s).", "")
Command:addArg(VH_CommandLib.ArgTypes.Plrs, {required = true})
Command:addAlias({Prefix = "!", Alias = {"noclip", "clip", "tnoclip"}})

Command.Callback = function(Sender, Alias, Targets)
	local Success, Toggle = VH_CommandLib.DoToggleableCommand(Alias, {"noclip"}, {"clip"}, {"tnoclip"})
	
	for _, ply in ipairs(Targets) do
		if Toggle then
			if ply:GetMoveType() == MOVETYPE_NOCLIP then
				ply:SetMoveType(MOVETYPE_WALK)
			else
				ply:SetMoveType(MOVETYPE_NOCLIP)
			end
		else
			if Success then
				ply:SetMoveType(MOVETYPE_NOCLIP)
			else
				ply:SetMoveType(MOVETYPE_WALK)
			end
		end
	end
	
	if Toggle then
		VH_CommandLib.SendCommandMessage(Sender, "toggled noclip on", Targets, "")
	else
		VH_CommandLib.SendCommandMessage(Sender, (Success and "noclipped" or "clipped"), Targets, "")
	end
	
	return ""
end