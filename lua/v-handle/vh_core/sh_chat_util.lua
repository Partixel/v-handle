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
	_reset_ = Color(150, 200, 255)
}

function vh.ChatUtil.ParseColors( Message )
	local Msg = string.Explode(" ", Message)
	local Final = {}
	for a, b in pairs(Msg) do
		if vh.ChatUtil.Colors[string.lower(b)] then
			table.insert(Final, vh.ChatUtil.Colors[string.lower(b)])
		elseif string.lower(b) == "_random_" then
			table.insert(Final, table.random(vh.ChatUtil.Colors))
		elseif type(Final[#Final]) == "string" then
			Final[#Final] = Final[#Final] .. " " .. b
		else
			if type(Final[#Final]) == "table" and #Final != 1 then
				table.insert(Final, " " .. b)
			else
				table.insert(Final, b)
			end
		end
	end
	if #Final < 20 then
		repeat
			table.insert(Final, "")
		until #Final == 20
	end
	return Final
end

function vh.ConsoleMessage( Message, Log )
	if !Log then
		Message = "_RESET_ V-Handle _WHITE_ -- " .. Message 
	end
	local Msg = vh.ChatUtil.ParseColors(Message)
	MsgC(Msg[1], Msg[2], Msg[3], Msg[4], Msg[5], Msg[6], Msg[7], Msg[8], Msg[9], Msg[10], Msg[11], Msg[12], Msg[13], Msg[14], Msg[15], Msg[16], Msg[17], Msg[18], Msg[19], Msg[20], "\n")
end

if SERVER then
	function vh.ChatUtil.SendMessage(String, Player)
		if type(Player) == "table" then
			for a, b in pairs(Player) do
				umsg.Start("vh_message", b)
					umsg.String(String)
				umsg.End()
			end
		elseif Player == true then
			vh.ConsoleMessage(String, true)
		elseif Player:IsValid() then
			umsg.Start("vh_message", Player)
				umsg.String(String)
			umsg.End()
		else
			umsg.Start("vh_message")
				umsg.String(String)
			umsg.End()
		end
	end
else
	usermessage.Hook("vh_message", function(Message)
		local Msg = vh.ChatUtil.ParseColors(Message:ReadString())
		chat.AddText(Msg[1], Msg[2], Msg[3], Msg[4], Msg[5], Msg[6], Msg[7], Msg[8], Msg[9], Msg[10], Msg[11], Msg[12], Msg[13], Msg[14], Msg[15], Msg[16], Msg[17], Msg[18], Msg[19], Msg[20])
	end)
end
