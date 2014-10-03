local Command = _V.CommandLib.Command:new("Return", _V.CommandLib.UserTypes.Admin, "Return the player to last teleport position.", "")
Command:addAlias("!return")

Command.Callback = function(Sender, Alias)
	local CurrentPos = Sender:GetPos()
	Sender:SetPos(Sender:GetNWVector("TeleportReturnPos"))
	Sender:SetNWVector("TeleportReturnPos", CurrentPos)
	
	--vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has armed _reset_ " .. vh.ArgsUtil.PlayersToString(Targets) .. " _white_ to _reset_ ".. Amount)
	return ""
end