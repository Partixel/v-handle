local Command = _V.CommandLib.Command:new("Admin Chat", _V.CommandLib.UserTypes.Admin, "Send a message to all online admins.", "")
Command:addArg(_V.CommandLib.ArgTypes.String, {required = true})
Command:addAlias("@")

Command.Callback = function(Sender, Alias, Message)
	return ""
end