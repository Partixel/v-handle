local Module = {}
Module.Name = "CommandsTab"
Module.Description = "Tab containing all commands"

function RenderCall(Frame, Table)
	local CurrentCommands = 0
	for _, a in pairs(vh.Modules) do
		if (!a["Commands"]) then continue end
		for i, v in pairs(a.Commands) do
			Table[i] = vgui.Create("DButton", Frame)
			Table[i]:SetPos(Frame:GetWide() * 0.2 - (3 * CurrentCommands), 10 + (35 * CurrentCommands))
			Table[i]:SetSize(Frame:GetWide() * 0.6, 30)
			Table[i]:SetText("")
			Table[i].Paint = function()
				_V.MenuLib.DrawTrapezoidFancy(0, 0, Table[i]:GetWide(), Table[i]:GetTall(), _V.MenuLib.GetSettings().Colors.MainButton, 2, 2)
				draw.SimpleText(i, "VHUIFontSmall", Table[i]:GetWide()/2, Table[i]:GetTall()/2 - 4, Color(50, 50, 50, 255), 1, 1)
			end
			CurrentCommands = CurrentCommands + 1
		end
	end
end

local CommandTab = _V.MenuLib.VTab:new("Commands", RenderCall, 1)

vh.RegisterModule(Module)