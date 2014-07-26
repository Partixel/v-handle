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
	for a, b in ipairs(Message) do
		if vh.ChatUtil.Colors[string.lower(b)] then
			Message[a] = vh.ChatUtil.Colors[string.lower(b)]
		elseif string.lower(b) == "_random_" then
			local RandomColor = table.Random(vh.ChatUtil.Colors)
			Message[a] = RandomColor
		end
	end
	if type(Message[1]) == "string" then
		table.insert(Message, 1, vh.ChatUtil.Colors["_white_"])
	end
	return Message
end

function vh.ChatUtil.ParsePrecached( Message )
	local Msg = {}
	for a, b in ipairs(Message) do
		if type(b) == "string" and vh.ChatUtil.Precached[string.lower(b)] then
			Msg = vh.ChatUtil.MergeMessages(Msg, vh.ChatUtil.Precached[string.lower(b)])
		else
			table.insert(Msg, b)
		end
	end
	return Msg
end

vh.ChatUtil.Precached = {
	_vh_ = vh.ChatUtil.ParseColors(string.Explode(" ", "_RESET_ V-Handle _WHITE_ -- ")),
	_nplr_ = vh.ChatUtil.ParseColors(string.Explode(" ", "_red_ No valid players found")),
	_malias_ = vh.ChatUtil.ParseColors(string.Explode(" ", "_red_ Multiple commands found using that alias")),
	_nperm_ = vh.ChatUtil.ParseColors(string.Explode(" ", "_red_ You do not have permission to use this")),
	_lcore_ = vh.ChatUtil.ParseColors(string.Explode(" ", "Loaded _lime_ Core _white_ files"))
}

function vh.ChatUtil.MergeMessages( Prefix, Message )
	local Msg = table.Copy(Prefix) or {}
	for a, b in ipairs( Message ) do
		table.insert(Msg, b)
	end
	return Msg
end

function vh.ChatUtil.FormatMessage( Message, Console, Log )
	local Msg = string.Explode(" ", Message)
	Msg = vh.ChatUtil.ParseColors(Msg)
	Msg = vh.ChatUtil.ParsePrecached(Msg)
	
	for a, b in ipairs(Msg) do
		if type(b) == "string" then
			Msg[a] = b .. " "
		end
	end
	
	if Console then
		if !Log then
			Msg = vh.ChatUtil.MergeMessages(vh.ChatUtil.Precached.vh, Msg)
		end
		table.insert(Msg, "\n")
	end

	return Msg
end

function vh.ConsoleMessage( Message, Log )
	local Msg = vh.ChatUtil.FormatMessage(Message, true, Log)
	MsgC(unpack(Msg))
end

if SERVER then
	function vh.ChatUtil.SendMessage(Message, Player, Log)
		if Log then
			vh.ConsoleMessage(Message, true)
		end

		if Player == nil then
			umsg.Start("vh_message")
				umsg.String(Message)
			umsg.End()
			return
		end
		
		if Player.IsValid and Player:IsValid() then
			Player = {Player}
		end
		
		if type(Player) == "table" then
			for a, b in ipairs(Player) do
				umsg.Start("vh_message", b)
					umsg.String(Message)
				umsg.End()
			end
			return
		end
		
		vh.ConsoleMessage(Message, true)
	end
else
	usermessage.Hook("vh_message", function(Message)
		local Msg = vh.ChatUtil.FormatMessage(Message:ReadString())
		chat.AddText(unpack(Msg))
	end)
end
