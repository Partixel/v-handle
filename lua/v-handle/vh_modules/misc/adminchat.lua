local Command = _V.CommandLib.Command:new("Admin Chat", _V.CommandLib.UserTypes.Admin, "Send a message to all online admins.", "")
Command:addArg(_V.CommandLib.ArgTypes.String, {required = true})
Command:addAlias("@")

Command.Callback = function(Sender, Alias, Message)
	for _, v in ipairs(player.GetAll()) do
		--Permission check to view admin chat here
		vh.ChatUtil.SendMessage("_green_ "..Sender:Nick().." _reset_ to admins: _lime_ "..Message, v)
	end
	return ""
end