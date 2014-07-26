vh.ChatUtil = {}
vh.ChatUtil.Colors = {
	_white_ = Color(0xFF,0xFF,0xFF),
	_silver_ = Color(0xC0,0xC0,0xC0),
	_gray_ = Color(0x80,0x80,0x80),
	_black_ = Color(0x00,0x00,0x00),
	_red_ = Color(0xFF,0x00,0x00),
	_maroon_ = Color(0x80,0x00,0x00),
	_yellow_ = Color(0xFF,0xFF,0x00),
	_olive_ = Color(0x80,0x80,0x00),
	_lime_ = Color(0x00,0xFF,0x00),
	_green_ = Color(0x00,0x80,0x00),
	_aqua_ = Color(0x00,0xFF,0xFF),
	_teal_ = Color(0x00,0x80,0x80),
	_blue_ = Color(0x00,0x00,0xFF),
	_navy_ = Color(0x00,0x00,0x80),
	_fuchsia_ = Color(0xFF,0x00,0xFF),
	_purple_ = Color(0x80,0x00,0x80),
	_orange_ = Color(0xFF,0xA5,0x00),
	_reset_ = = Color(150, 200, 255)
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
