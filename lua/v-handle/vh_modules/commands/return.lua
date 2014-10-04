local Command = _V.CommandLib.Command:new("Return", _V.CommandLib.UserTypes.Admin, "Return the player to last teleport position.", "")
Command:addArg(_V.CommandLib.ArgTypes.Player, {required = false})
Command:addAlias("!return")

Command.Callback = function(Sender, Alias, Target)
	local Target = Target or Sender
	
	if not Sender:GetNWVector("VH_ReturnPosition") then return end
	
	local CurrentPosition = Target:GetPos()
	Target:SetPos(Sender:GetNWVector("VH_ReturnPosition"))
	Target:SetNWVector("VH_ReturnPosition", CurrentPosition)
	
	return ""
end