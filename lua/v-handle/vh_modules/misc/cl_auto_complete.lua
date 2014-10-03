local Module = {}
Module.Name = "Autocomplete"
Module.Description = "Shows a UI with viable auto-completions below chat box"

local chatOpen = false
local Suggestions = {}

function ChatPaint()
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
end

function TextChanged(Text)
	Suggestions = {}
	if #Text == 0 then return end
	for _, Command in pairs(_V.CommandLib.Commands) do
		for _, Alias in pairs(Command.Alias) do
			if string.StartWith(string.lower(Text), string.lower(string.sub(Alias, 1, #Text))) then
				table.insert(Suggestions, {
					name = Alias,
					usage = Command:getUsage(Alias)
				})
			end
		end
	end
	table.SortByMember(Suggestions, "name", function( a, b ) return a < b end)
end

function ChatTab(Text)
	if ( string.match(Text, "^[/!][^ ]*$" ) and #Suggestions > 0 ) then
		return Suggestions[1].name .. " "
	end
end

function ChatBegin()
	chatOpen = true
end

function ChatEnd()
	chatOpen = false
end

Module.Hooks = {
	{Type = "HUDPaint", Run = ChatPaint},
	{Type = "ChatTextChanged", Run = TextChanged},
	{Type = "OnChatTab", Run = ChatTab},
	{Type = "StartChat", Run = ChatBegin},
	{Type = "FinishChat", Run = ChatEnd}
}

vh.RegisterModule(Module)