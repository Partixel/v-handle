local Command = _V.CommandLib.Command:new("Noclip", _V.CommandLib.UserTypes.Admin, "Noclip or clip the player(s).", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, false)
Command:addAlias("!noclip", "!unnoclip", "!clip", "!tnoclip")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	local Success, Toggle = _V.CommandLib.DoToggleableCommand(Alias, {"!noclip"}, {"!unnoclip", "!clip"}, {"!tnoclip"})
	
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
	
	return ""
end