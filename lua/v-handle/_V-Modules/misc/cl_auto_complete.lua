local chatOpen = false
local Suggestions = {}

hook.Add("HUDPaint", "HUDPaint", function()
	if chatOpen then
		local x, y = chat.GetChatBoxPos()
		x = x + ScrW() * 0.03875
		y = y + ScrH() / 4 + 5
		
		surface.SetFont("ChatFont")
		
		for i, v in ipairs( Suggestions ) do
			local sx, sy = surface.GetTextSize(v.name)
			
			draw.SimpleText(v.usage, "ChatFont", x, y, Color( 255, 255, 255, 255 ))
			
			y = y + sy
			if i == 4 then
				break
			end
		end
	end
end)

hook.Add("ChatTextChanged", "DoAutoComplete", function(Text)
	Suggestions = {}
	if #Text == 0 then return end
	local AliasLength = #string.Explode(" ", Text)[1]
	for _, Command in pairs(_V.CommandLib.Commands) do
		for _, Alias in pairs(Command.Alias) do
			if string.StartWith(string.lower(Text), string.lower(string.sub(Alias, 1, #Text))) then
				if #Alias >= AliasLength then
					table.insert(Suggestions, {
						name = Alias,
						usage = Command:getUsage(Alias)
					})
				end
			end
		end
	end
	table.SortByMember(Suggestions, "name", function( a, b ) return a < b end)
end)

hook.Add("OnChatTab", "ChatTab", function(Text)
	if ( string.match(Text, "^[/!][^ ]*$" ) and #Suggestions > 0 ) then
		return Suggestions[1].name .. " "
	end
end)

hook.Add("StartChat", "ChatOpen", function()
	chatOpen = true
end)

hook.Add("FinishChat", "ChatClose", function()
	chatOpen = false
end)