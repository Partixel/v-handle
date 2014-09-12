local Settings = {}
Settings.Sizes = {}
Settings.Sizes.Main = {x = 0.45, y = 0.6}
Settings.Sizes.TabPanel = 0.4
Settings.Colors = {}
Settings.Colors.Main = Color(60, 60, 60, 0)
Settings.Colors.TabPanel = Color(30, 140, 160, 255)
Settings.Colors.TabButton = Color(60, 170, 190, 255)
Settings.Colors.CommandPanel = Color(245, 245, 245, 255)
Settings.Colors.Text = Color(255, 255, 255, 255)
Settings.Textures = {}
Settings.Textures.Normal = Material("vgui/white")
Settings.Textures.GradientDown = Material("gui/gradient_down.png")
Settings.Textures.GradientUp = Material("gui/gradient_up.png")

local GUI = GUI or {}

local Tabs = {"Commands", "Bans", "Ranks", "Reports", "Adverts", "Warns", "Statistics", "Settings"}

function giveAlpha(Colour)
	return Color(Colour.r, Colour.g, Colour.b, 120)
end

function vh:ShowMenu()
	if (not GUI.MenuFrame) then CreateGui() end
	if (not GUI.MenuFrame) then return end
	GUI.MenuFrame:SetVisible(true)
end

function vh:HideMenu()
	if (not GUI.MenuFrame) then CreateGui() end
	if (not GUI.MenuFrame) then return end
	GUI.MenuFrame:SetVisible(false)
end

function surface.DrawTrapezoid( x, y, w, h, col, a)
	local t = {
	{x = x + a, y = y, u = 0, v = 0},
	{x = x + w, y = y, u = 1, v = 0},
	{x = x + w - a, y = y + h, u = 0, v = 1},
	{x = x, y = y + h, u = 1, v = 1}
	}
	surface.SetDrawColor(col)
	surface.DrawPoly(t)
end

function CreateGui()
	local ShownX = ScrW() * (1 - Settings.Sizes.Main.x)/2
	local ShownY = ScrH() * (1 - Settings.Sizes.Main.y)/2
	GUI.MenuFrame = GUI.MenuFrame or vgui.Create("DFrame")
	GUI.MenuFrame:SetPos(ShownX, ShownY)
	GUI.MenuFrame:SetSize(ScrW() * Settings.Sizes.Main.x, ScrH() * Settings.Sizes.Main.y)
	GUI.MenuFrame:SetTitle("")
	GUI.MenuFrame:SetDraggable(false)
	GUI.MenuFrame:SetVisible(false)
	GUI.MenuFrame:ShowCloseButton(false)
	GUI.MenuFrame:MakePopup()
	GUI.MenuFrame.Paint = function()
		draw.RoundedBox(0, 0, 0, GUI.MenuFrame:GetWide(), GUI.MenuFrame:GetTall(), Settings.Colors.Main)
	end

	GUI.TabPanel = GUI.TabPanel or vgui.Create("DPanel", GUI.MenuFrame)
	GUI.TabPanel:SetPos(0, 0)
	GUI.TabPanel:SetSize(GUI.MenuFrame:GetWide() * Settings.Sizes.TabPanel - 5, GUI.MenuFrame:GetTall())
	GUI.TabPanel.Paint = function()
		surface.SetMaterial(Settings.Textures.Normal)
		surface.DrawTrapezoid(5, 5, GUI.TabPanel:GetWide() - 10, GUI.TabPanel:GetTall() - 10, Settings.Colors.TabPanel, 40)
		surface.DrawTrapezoid(0, 0, GUI.TabPanel:GetWide(), GUI.TabPanel:GetTall(), giveAlpha(Settings.Colors.TabPanel), 40)
	end

	GUI.CommandPanel = GUI.CommandPanel or vgui.Create("DPanel", GUI.MenuFrame)
	GUI.CommandPanel:SetPos(GUI.MenuFrame:GetWide() * Settings.Sizes.TabPanel + 5, 10)
	GUI.CommandPanel:SetSize(GUI.MenuFrame:GetWide() * (1 - Settings.Sizes.TabPanel) - 5, GUI.MenuFrame:GetTall() - 20)
	GUI.CommandPanel.Paint = function()
		surface.SetMaterial(Settings.Textures.Normal)
		surface.DrawTrapezoid(5, 5, GUI.CommandPanel:GetWide() - 10, GUI.CommandPanel:GetTall() - 10, Settings.Colors.CommandPanel, 40)
		surface.DrawTrapezoid(0, 0, GUI.CommandPanel:GetWide(), GUI.CommandPanel:GetTall(), giveAlpha(Settings.Colors.CommandPanel), 40)
	end
end

concommand.Add("+vh_menu", function() vh:ShowMenu() end)
concommand.Add("-vh_menu", function() vh:HideMenu() end)