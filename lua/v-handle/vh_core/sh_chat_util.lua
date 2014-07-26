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
	local Final = {vh.ChatUtil.Colors["_white_"]}
	for a, b in pairs(Msg) do
		if vh.ChatUtil.Colors[string.lower(b)] then
			table.insert(Final, vh.ChatUtil.Colors[string.lower(b)])
		elseif string.lower(b) == "_random_" then
			local RandomColor = table.Random(vh.ChatUtil.Colors)
			table.insert(Final, RandomColor)
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

vh.ChatUtil.Precached = {
	nplr = vh.ChatUtil.ParseColors("_red_ No valid players found"),
	malias = vh.ChatUtil.ParseColors("_red_ Multiple commands found using that alias"),
	nperm = vh.ChatUtil.ParseColors("_red_ You do not have permission to use this"),
	lcore = vh.ChatUtil.ParseColors("_RESET_ V-Handle _WHITE_ -- Loaded _lime_ Core _white_ files")
}

function vh.ConsoleMessage( Message, Log )
	local Msg = {}
	if vh.ChatUtil.Precached[string.lower(Message)] then
		Msg = vh.ChatUtil.Precached[string.lower(Message)]
	else
		if Log then
			Message = "_RESET_ V-Handle _WHITE_ -- " .. Message 
		end
		Msg = vh.ChatUtil.ParseColors(Message)
	end
	Msg = table.Copy(Msg)
	table.insert(Msg, "\n")
	MsgC(unpack(Msg))
end

if SERVER then
	function vh.ChatUtil.SendMessage(Message, Player)
		if type(Player) == "table" then
			for a, b in pairs(Player) do
				umsg.Start("vh_message", b)
					umsg.String(Message)
				umsg.End()
			end
		elseif Player == true then
			vh.ConsoleMessage(Message, true)
		elseif Player:IsValid() then
			umsg.Start("vh_message", Player)
				umsg.String(Message)
			umsg.End()
		elseif !Player:IsValid() then
			vh.ConsoleMessage(Message)
		else
			umsg.Start("vh_message")
				umsg.String(Message)
			umsg.End()
		end
	end
else
	usermessage.Hook("vh_message", function(Message)
		local Msg = Message:ReadString()
		if vh.ChatUtil.Precached[string.lower(Msg)] then
			Msg = vh.ChatUtil.Precached[string.lower(Msg)]
		else
			Msg = vh.ChatUtil.ParseColors(Msg)
		end
		chat.AddText(unpack(Msg))
	end)
end
