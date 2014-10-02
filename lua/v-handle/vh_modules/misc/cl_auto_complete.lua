local Module = {}
Module.Name = "Autocomplete"
Module.Description = "Shows a UI with viable auto-completions below chat box"

local chatOpen = false
local suggestions = {}

function ChatPaint()
	if chatOpen then
		local x, y = chat.GetChatBoxPos()
		x = x + ScrW() * 0.03875
		y = y + ScrH() / 4 + 5
		
		surface.SetFont( "ChatFont" )
		
		for i, v in ipairs( suggestions ) do
			local sx, sy = surface.GetTextSize( v.name )
			
			draw.SimpleText( v.name, "ChatFont", x, y, Color( 0, 0, 0, 255 ) )
			draw.SimpleText( " " .. v.usage or "", "ChatFont", x + sx, y, Color( 0, 0, 0, 255 ) )
			draw.SimpleText( v.name, "ChatFont", x, y, Color( 255, 255, 100, 255 ) )
			draw.SimpleText( " " .. v.usage or "", "ChatFont", x + sx, y, Color( 255, 255, 255, 255 ) )
			
			y = y + sy
			if i == 4 then
				break
			end
		end
	end
end

function TextChanged( str )
	suggestions = {}
	if ( string.Left( str, 1 ) == "!" ) then
		local com = string.sub( str, 2, ( string.find( str, " " ) or ( #str + 1 ) ) - 1 )
		
		for _, a in pairs(vh.Modules) do
			if (!a["Commands"]) then continue end
			for b, c in pairs(a.Commands) do
				if ( string.sub(b:lower(), 0, #com) == string.lower(com)) then
					table.insert( suggestions, {
						name = string.sub(str, 1, 1) .. b:lower(),
						usage = c.Usage or ""
					})
				end
				if (c["Aliases"]) then
					for _, d in pairs(c["Aliases"]) do
						if ( string.sub(d:lower(), 0, #com) == string.lower(com)) then
							table.insert( suggestions, {
								name = string.sub(str, 1, 1) .. d:lower(),
								usage = c.Usage or ""
							})
						end
					end
				end
			end
		end
		table.SortByMember( suggestions, "name", function( a, b ) return a < b end )
	else
		suggestions = {}
	end
end

function ChatTab( str )
	if ( string.match( str, "^[/!][^ ]*$" ) and #suggestions > 0 ) then
		return suggestions[1].name .. " "
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