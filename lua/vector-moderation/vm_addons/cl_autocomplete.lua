local addon = {}
addon.Name = "Autocomplete"
addon.Description = "Description"
vm.RegisterAddon(addon)

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
		
		for b in vm.Addons do
			if (!b["Commands"]) then continue end
				for c, d in pairs(b.Commands) do
					if ( string.sub(c:lower(), 0, #com) == string.lower(com)) then
						table.insert( suggestions, {
							name = string.sub(str, 1, 1) .. c:lower(),
							usage = d.Usage or ""
						})
					end
					if (d["Aliases"]) then
						for e in d["Aliases"] do
							if ( string.sub(e:lower(), 0, #com) == string.lower(com)) then
								table.insert( suggestions, {
									name = string.sub(str, 1, 1) .. e:lower(),
									usage = e.Usage or ""
								})
							end
						end
					end
				end
			end
		end
		for _, v in pairs( azure.Commands ) do
			for x, y in pairs( v.Aliases ) do
				if ( string.sub( y, 0, #com ) == string.lower( com )) then
					table.insert( suggestions, {
						name = string.sub( str, 1, 1 ) .. y,
						usage = v.Usage or ""
					} )
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

hook.Add("HUDPaint", "ChatPaint", ChatPaint);
hook.Add("ChatTextChanged", "TextChanged", TextChanged);
hook.Add("OnChatTab", "ChatTab", ChatTab);
hook.Add("StartChat", "StartChat", ChatBegin);
hook.Add("FinishChat", "FinishChat", ChatEnd);