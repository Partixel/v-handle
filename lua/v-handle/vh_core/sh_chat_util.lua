vh.ChatUtil = {}
vh.ChatUtil.Colors = {
	_red_ = Color(255, 0, 0),
	_green_ = Color(0, 255, 0),
	_blue_ = Color(0, 0, 255),
	_white_ = Color(255, 255, 255),
	_black_ = Color(0, 0, 0),
	_reset_ = Color(150, 200, 255)
}

function vh.ChatUtil.ParseColors( Message )
	local Msg = string.Explode(" ", Message)
	local Final = {}
	for a, b in pairs(Msg) do
		if vh.ChatUtil.Colors[string.lower(b)] then
			table.insert(Final, vh.ChatUtil.Colors[string.lower(b)])
		elseif type(Final[#Final]) == "string" then
			Final[#Final] = Final[#Final] .. " " .. b
		else
			table.insert(Final, b)
		end
	end
	if #Final < 7 then
		repeat
			table.insert(Final, "")
		until #Final == 7
	end
	return Final
end

if SERVER then
	function vh.ChatUtil.SendMessage(String, Player)
		umsg.Start("vh_message", Player)
			umsg.String(String)
		umsg.End()
	end
else
	usermessage.Hook("vh_message", function(Message)
		local Msg = vh.ChatUtil.ParseColors(Message:ReadString())
		chat.AddText(Msg[1], Msg[2], Msg[3], Msg[4], Msg[5], Msg[6], Msg[7])
	end)
end