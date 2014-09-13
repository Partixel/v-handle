_V.MenuLib = {}

local RegisteredTabs = {}
local OpenTabs = {}
local ActiveTab = 3
local TabsVisible = false

local Settings = {}
Settings.Sizes = {}
Settings.Sizes.Main = {x = 0.45, y = 0.6}
Settings.Colors = {}
Settings.Colors.Active = Color(245, 245, 245, 255)
Settings.Colors.Inactive = Color(215, 215, 215, 255)
Settings.Colors.Main = Color(245, 245, 245, 255)
Settings.Colors.MainButton = Color(225, 225, 225, 255)
Settings.Colors.Secondary = Color(30, 140, 160, 255)
Settings.Colors.SecondaryButton = Color(60, 170, 190, 255)
Settings.Colors.Text = Color(255, 255, 255, 255)
Settings.Textures = {}
Settings.Textures.Normal = Material("vgui/white")
Settings.Textures.GradientDown = Material("gui/gradient_down.png")
Settings.Textures.GradientUp = Material("gui/gradient_up.png")

surface.CreateFont("VHUIFontLarge", {
	font = "MV Boli",
	size = 40,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont("VHUIFont", {
	font = "MV Boli",
	size = 30,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont("VHUIFontSmall", {
	font = "MV Boli",
	size = 20,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

_V.MenuLib.VTab = {
	Name = nil, -- Name of the Tab
	RenderCall = nil -- Function to call on render
}

function _V.MenuLib.OpenTab(VTab)
	if not table.HasValue(OpenTabs, VTab) then
		table.insert(OpenTabs, VTab)
	end
end

function _V.MenuLib.RegisterTab(VTab)
	if not table.HasValue(RegisteredTabs, VTab) then
		table.insert(RegisteredTabs, VTab)
	end
end

function _V.MenuLib.VTab:new(Name, RenderCall)
	local Object = {Name = Name, RenderCall = RenderCall}
	setmetatable(Object, self)
	self.__index = self
	_V.MenuLib.RegisterTab(Object)
	return Object
end


local GUI = GUI or {}

function giveAlpha(InitialColor, Mult)
	return Color(InitialColor.r, InitialColor.g, InitialColor.b, 120 / (Mult or 1))
end

function DrawTrapezoid( x, y, w, h, col, a)
	local t = {
	{x = x + a, y = y, u = 0, v = 0},
	{x = x + w, y = y, u = 1, v = 0},
	{x = x + w - a, y = y + h, u = 0, v = 1},
	{x = x, y = y + h, u = 1, v = 1}
	}
	surface.SetDrawColor(col)
	surface.DrawPoly(t)
end

function ShowMenu()
	if (not GUI.MasterFrame) then CreateGui() end
	if (not GUI.MasterFrame) then return end
	GUI.MasterFrame:SetVisible(true)
	DrawTabs()
end

function HideMenu()
	if (not GUI.MasterFrame) then CreateGui() end
	if (not GUI.MasterFrame) then return end
	GUI.MasterFrame:SetVisible(false)
end

function CreateGui()
	GUI.MasterFrame = GUI.MasterFrame or vgui.Create("DFrame")
	GUI.MasterFrame:SetPos(0, 0)
	GUI.MasterFrame:SetSize(ScrW(), ScrH())
	GUI.MasterFrame:SetTitle("")
	GUI.MasterFrame:SetDraggable(false)
	GUI.MasterFrame:SetVisible(false)
	GUI.MasterFrame:ShowCloseButton(false)
	GUI.MasterFrame:MakePopup()
	GUI.MasterFrame.Paint = function()
		draw.RoundedBox(0, 0, 0, GUI.MasterFrame:GetWide(), GUI.MasterFrame:GetTall(), Color(0, 0, 0, 0))
	end
	DrawTabs()
end

function DrawTabs()
	if GUI.Tabs then
		for _, v in pairs(GUI.Tabs) do
			if v.Label then
				v.Label:Remove()
			end
			v:Remove()
		end
	end
	GUI.Tabs = {}
	local ShownX = ScrW() * (1 - Settings.Sizes.Main.x)/2
	local ShownY = ScrH() * (1 - Settings.Sizes.Main.y)/2
	for i, v in pairs(OpenTabs) do
		local Active = i == ActiveTab
		if not Active then
			local Offset = i - ActiveTab
			GUI.Tabs[i] = vgui.Create("DPanel", GUI.MasterFrame)
			GUI.Tabs[i]:SetPos(ShownX + Offset * 40, ShownY - Offset * 40)
			GUI.Tabs[i]:SetSize(ScrW() * Settings.Sizes.Main.x, ScrH() * Settings.Sizes.Main.y)
			GUI.Tabs[i].Paint = function()
				surface.SetMaterial(Settings.Textures.Normal)
				DrawTrapezoid(5, 5, GUI.Tabs[i]:GetWide() - 10, GUI.Tabs[i]:GetTall() - 10, giveAlpha(Settings.Colors.Inactive), 40)
				DrawTrapezoid(0, 0, GUI.Tabs[i]:GetWide(), GUI.Tabs[i]:GetTall(), giveAlpha(Settings.Colors.Inactive, 2), 40)
			end
		end
	end
	GUI.Tabs[ActiveTab] = vgui.Create("DPanel", GUI.MasterFrame)
	GUI.Tabs[ActiveTab]:SetPos(ShownX, ShownY)
	GUI.Tabs[ActiveTab]:SetSize(ScrW() * Settings.Sizes.Main.x, ScrH() * Settings.Sizes.Main.y)
	GUI.Tabs[ActiveTab].Paint = function()
		surface.SetMaterial(Settings.Textures.Normal)
		DrawTrapezoid(5, 5, GUI.Tabs[ActiveTab]:GetWide() - 10, GUI.Tabs[ActiveTab]:GetTall() - 10, Settings.Colors.Active, 40)
		DrawTrapezoid(0, 0, GUI.Tabs[ActiveTab]:GetWide(), GUI.Tabs[ActiveTab]:GetTall(), giveAlpha(Settings.Colors.Active), 40)
	end
	GUI.Tabs[ActiveTab].Label = vgui.Create("DLabel", GUI.Tabs[ActiveTab])
	GUI.Tabs[ActiveTab].Label:SetPos(0, 0)
	GUI.Tabs[ActiveTab].Label:SetSize(GUI.Tabs[ActiveTab]:GetWide(), 40)
	GUI.Tabs[ActiveTab].Label:SetText("")
	GUI.Tabs[ActiveTab].Label.Paint = function()
		draw.SimpleText(OpenTabs[ActiveTab].Name, "VHUIFont", GUI.Tabs[ActiveTab]:GetWide()/2, 20, Color(50, 50, 50, 255), 1, 1)
	end
	for i, v in pairs(OpenTabs) do
		local Active = i == ActiveTab
		if not Active then
			local Offset = i - ActiveTab
			GUI.Tabs[i].Label = vgui.Create("DButton", GUI.MasterFrame)
			GUI.Tabs[i].Label:SetSize(GUI.Tabs[ActiveTab]:GetWide(), 40)
			GUI.Tabs[i].Label:SetText("")
			if i < ActiveTab then
				GUI.Tabs[i].Label:SetPos(ShownX + Offset * 40, ShownY - Offset * 40 + GUI.Tabs[ActiveTab]:GetTall() - 40)
				GUI.Tabs[i].Label.Paint = function()
					draw.SimpleText(v.Name, "VHUIFontSmall", GUI.Tabs[ActiveTab]:GetWide()/2, 20, Color(50, 50, 50, 255), 1, 1)
				end
			else
				GUI.Tabs[i].Label:SetPos(ShownX + Offset * 40, ShownY - Offset * 40)
				GUI.Tabs[i].Label.Paint = function()
					draw.SimpleText(v.Name, "VHUIFontSmall", GUI.Tabs[ActiveTab]:GetWide()/2, 20, Color(50, 50, 50, 255), 1, 1)
				end
			end
			GUI.Tabs[i].Label.DoClick = function()
				ActiveTab = i
				DrawTabs()
			end
		end
	end
end

concommand.Add("vh_menu", function() ShowMenu() end)
concommand.Add("+vh_menu", function() ShowMenu() end)
concommand.Add("-vh_menu", function() HideMenu() end)


local TestTab = _V.MenuLib.VTab:new("TestTab", nil)
local TestTabB = _V.MenuLib.VTab:new("TestTabB", nil)
local TestTabC = _V.MenuLib.VTab:new("TestTabC", nil)
local TestTabD = _V.MenuLib.VTab:new("TestTabD", nil)
_V.MenuLib.OpenTab(TestTab)
_V.MenuLib.OpenTab(TestTabB)
_V.MenuLib.OpenTab(TestTabC)
_V.MenuLib.OpenTab(TestTabD)