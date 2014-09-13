local Module = {}
Module.Name = "IndexTab"
Module.Description = "Menu tab directory"

function RenderCall(Frame, Table)
	Table.Button = vgui.Create("DButton", Frame)
	Table.Button:SetPos(Frame:GetWide() - 90, 10)
	Table.Button:SetSize(80, 30)
	Table.Button:SetText("")
	Table.Button.Paint = function()
		_V.MenuLib.DrawTrapezoidFancy(0, 0, Table.Button:GetWide(), Table.Button:GetTall(), _V.MenuLib.Settings.Colors.TertiaryButton, 2, 2)
		draw.SimpleText("x", "VHUIFont", Table.Button:GetWide()/2, Table.Button:GetTall()/2 - 4, Color(50, 50, 50, 255), 1, 1)
	end
end

local IndexTab = _V.MenuLib.VTab:new("Main", RenderCall, false, 1)

_V.MenuLib.OpenTab(IndexTab)

vh.RegisterModule(Module)