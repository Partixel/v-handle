local Command = VH_CommandLib.Command:new("Admin Chat", VH_CommandLib.UserTypes.Admin, "Send a message to all online admins.", "")
Command:addArg(VH_CommandLib.ArgTypes.String, {required = true})
Command:addAlias("@")

Command.Callback = function(Sender, Alias, Message)
	for _, v in ipairs(player.GetAll()) do
		--Permission check to view admin chat here
		vh.ChatUtil.SendMessage("_green_ "..Sender:Nick().." _reset_ to admins: _lime_ "..Message, v)
	end
	return ""
end