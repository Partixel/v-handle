local Command = _V.CommandLib.Command:new("Cloak", _V.CommandLib.UserTypes.Admin, "Set the invisibility of the player(s).", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, false)
Command:addAlias("!cloak", "!uncloak", "!tcloak")

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	local Success = false
	local Toggle = false
	
	if string.lower(Alias) == "!cloak" then
		Success = true
	elseif string.lower(Alias) == "!uncloak" then
		Success = false
	elseif string.lower(Alias) == "!tcloak" then
		Toggle = true
	end
	for _, ply in ipairs(Targets) do
		if Toggle then
			ply:SetNoDraw(!ply:GetNoDraw())
		else
			ply:SetNoDraw(Success)
		end
	end
	
	return ""
end