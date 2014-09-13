_V = _V or {}

_V.MenuLib = {}

local RegisteredTabs = {}
local ActiveTab = 1
local TabsVisible = false

Settings = {}
Settings.Sizes = {}
Settings.Sizes.Main = {x = 0.45, y = 0.6}
Settings.Colors = {}
Settings.Colors.Active = Color(245, 245, 245, 255)
Settings.Colors.Inactive = Color(215, 215, 215, 255)
Settings.Colors.Main = Color(245, 245, 245, 255)
Settings.Colors.MainButton = Color(225, 225, 225, 255)
Settings.Colors.Secondary = Color(30, 140, 160, 255)
Settings.Colors.SecondaryButton = Color(60, 170, 190, 255)
Settings.Colors.Tertiary = Color(160, 30, 30, 255)
Settings.Colors.TertiaryButton = Color(190, 60, 60, 255)
Settings.Colors.Text = Color(50, 50, 50, 255)
Settings.Textures = {}
Settings.Textures.Normal = Material("vgui/white")
Settings.Textures.GradientDown = Material("gui/gradient_down.png")
Settings.Textures.GradientUp = Material("gui/gradient_up.png")

if CLIENT then
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
end

_V.MenuLib.VTab = {
	Name = nil, 		-- Name of the Tab
	RenderCall = nil, 	-- Function to call on render
	Position = nil		-- Forced position of the tab
}

function _V.MenuLib.VTab:new(Name, RenderCall, Position)
	local Object = {Name = Name, RenderCall = RenderCall, Position = Position}
	setmetatable(Object, self)
	self.__index = self
	_V.MenuLib.RegisterTab(Object)
	return Object
end

function _V.MenuLib.GetRegisteredTabs()
	return RegisteredTabs
end

function _V.MenuLib.RedrawTabs(OldActiveTab)
	DrawTabs(OldActiveTab)
end

function _V.MenuLib.SetActiveTab(NewActiveTab)
	ActiveTab = NewActiveTab
end

function _V.MenuLib.GetActiveTab()
	return ActiveTab
end

function _V.MenuLib.GetSettings()
	return Settings
end

function _V.MenuLib.OpenTab(VTab)
	local Old = ActiveTab
	ActiveTab = VTab.Position or #RegisteredTabs
	for i, v in ipairs(RegisteredTabs) do
		if v == VTab then
			ActiveTab = i
		end
	end
	DrawTabs(Old)
	ShowMenu()
end

function _V.MenuLib.RegisterTab(VTab)
	if not table.HasValue(RegisteredTabs, VTab) then
		if VTab.Position then
			table.insert(RegisteredTabs, VTab.Position, VTab)
		else
			table.insert(RegisteredTabs, VTab)
		end
	end
end

local GUI = GUI or {}

function giveAlpha(InitialColor, Mult)
	return Color(InitialColor.r, InitialColor.g, InitialColor.b, math.max(120 - 40 * (Mult or 0), 0))
end

function giveAlphaAlt(InitialColor)
	return Color(InitialColor.r, InitialColor.g, InitialColor.b, math.max(InitialColor.a - 120, 0))
end

function _V.MenuLib.DrawTrapezoid( x, y, w, h, col, a)
	local t = {
	{x = x + a, y = y, u = 0, v = 0},
	{x = x + w, y = y, u = 1, v = 0},
	{x = x + w - a, y = y + h, u = 0, v = 1},
	{x = x, y = y + h, u = 1, v = 1}
	}
	surface.SetDrawColor(col)
	surface.DrawPoly(t)
end

function _V.MenuLib.DrawTrapezoidFancy( x, y, w, h, col, a, b)
	surface.SetMaterial(Settings.Textures.Normal)
	_V.MenuLib.DrawTrapezoid(b, b, w - b * 2, h - b * 2, col, a)
	_V.MenuLib.DrawTrapezoid(0, 0, w, h, giveAlphaAlt(col), a)
	surface.SetMaterial(Settings.Textures.GradientUp)
	_V.MenuLib.DrawTrapezoid(b, b, w - b * 2, h - b * 2, Color(60, 60, 60, 100 * (col.a/255)), a)
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

function DrawTabs(OldActiveTab)
	if GUI.Tabs then
		for _, v in pairs(GUI.Tabs) do
			if v.Label then
				v.Label:Remove()
			end
			if v.Panel then
				v.Panel:Remove()
			end
			if v.Remove then
				v:Remove()
			end
		end
	end
	GUI.Tabs = {}
	GUI.Tabs.Active = {}
	local ShownX = ScrW() * (1 - Settings.Sizes.Main.x)/2
	local ShownY = ScrH() * (1 - Settings.Sizes.Main.y)/2
	if #RegisteredTabs == 0 then return end
	if SERVER then return end
	for i, v in pairs(RegisteredTabs) do
		local Active = i == ActiveTab
		if not Active then
			local Offset = math.abs(i - ActiveTab) - 1
			if Offset < 3 then
				local OffsetOld = (i - (OldActiveTab or ActiveTab)) * 40
				local OffsetNew = (i - ActiveTab) * 40
				GUI.Tabs[i] = vgui.Create("DPanel", GUI.MasterFrame)
				GUI.Tabs[i]:SetPos(ShownX + OffsetOld, ShownY - OffsetOld)
				GUI.Tabs[i]:MoveTo(ShownX + OffsetNew, ShownY - OffsetNew, 0.5, 0, 1)
				GUI.Tabs[i]:SetSize(ScrW() * Settings.Sizes.Main.x, ScrH() * Settings.Sizes.Main.y)
				GUI.Tabs[i].Paint = function()
					_V.MenuLib.DrawTrapezoidFancy(0, 0, GUI.Tabs[i]:GetWide(), GUI.Tabs[i]:GetTall(), giveAlpha(Settings.Colors.Inactive, Offset), 40, 5)
				end
			end
		end
	end
	local Offset = ((ActiveTab - 1) - (#RegisteredTabs/2)) * 40
	local OffsetOld = (ActiveTab - (OldActiveTab or ActiveTab)) * 40
	GUI.Tabs[ActiveTab] = vgui.Create("DPanel", GUI.MasterFrame)
	GUI.Tabs[ActiveTab]:SetPos(ShownX + OffsetOld, ShownY - OffsetOld)
	GUI.Tabs[ActiveTab]:MoveTo(ShownX, ShownY, 0.5, 0, 1)
	GUI.Tabs[ActiveTab]:SetSize(ScrW() * Settings.Sizes.Main.x, ScrH() * Settings.Sizes.Main.y)
	GUI.Tabs[ActiveTab].Paint = function()
		_V.MenuLib.DrawTrapezoidFancy(0, GUI.Tabs[ActiveTab]:GetTall() * 0.2 + 5, GUI.Tabs[ActiveTab]:GetWide(), GUI.Tabs[ActiveTab]:GetTall() * 0.2, Settings.Colors.Secondary, 40, 5)
		_V.MenuLib.DrawTrapezoidFancy(0, 0, GUI.Tabs[ActiveTab]:GetWide(), GUI.Tabs[ActiveTab]:GetTall() * 0.8 - 5, Settings.Colors.Main, 40, 5)
	end
	GUI.Tabs[ActiveTab].Label = vgui.Create("DLabel", GUI.Tabs[ActiveTab])
	GUI.Tabs[ActiveTab].Label:SetPos(0, 0)
	GUI.Tabs[ActiveTab].Label:SetSize(GUI.Tabs[ActiveTab]:GetWide(), 40)
	GUI.Tabs[ActiveTab].Label:SetText("")
	GUI.Tabs[ActiveTab].Label.Paint = function()
		draw.SimpleText(RegisteredTabs[ActiveTab].Name, "VHUIFont", GUI.Tabs[ActiveTab]:GetWide()/2, 20, Color(50, 50, 50, 255), 1, 1)
	end
	GUI.Tabs[ActiveTab].CloseButton = vgui.Create("DButton", GUI.Tabs[ActiveTab])
	GUI.Tabs[ActiveTab].CloseButton:SetPos(GUI.Tabs[ActiveTab]:GetWide() - 90, 10)
	GUI.Tabs[ActiveTab].CloseButton:SetSize(80, 30)
	GUI.Tabs[ActiveTab].CloseButton:SetText("")
	GUI.Tabs[ActiveTab].CloseButton.Paint = function()
		_V.MenuLib.DrawTrapezoidFancy(0, 0, GUI.Tabs[ActiveTab].CloseButton:GetWide(), GUI.Tabs[ActiveTab].CloseButton:GetTall(), Settings.Colors.TertiaryButton, 2, 2)
		draw.SimpleText("x", "VHUIFont", GUI.Tabs[ActiveTab].CloseButton:GetWide()/2, GUI.Tabs[ActiveTab].CloseButton:GetTall()/2 - 4, Color(50, 50, 50, 255), 1, 1)
	end
	GUI.Tabs[ActiveTab].CloseButton.DoClick = function()
		HideMenu()
	end
	GUI.Tabs[ActiveTab].Panel = vgui.Create("DPanel", GUI.Tabs[ActiveTab])
	GUI.Tabs[ActiveTab].Panel:SetPos(50, 50)
	GUI.Tabs[ActiveTab].Panel:SetSize(GUI.Tabs[ActiveTab]:GetWide() - 100, GUI.Tabs[ActiveTab]:GetTall() - 100)
	GUI.Tabs[ActiveTab].Panel.Paint = function() end
	if RegisteredTabs[ActiveTab].RenderCall then
		RegisteredTabs[ActiveTab].RenderCall(GUI.Tabs[ActiveTab].Panel, GUI.Tabs.Active)
	end
	for i, v in pairs(RegisteredTabs) do
		local Active = i == ActiveTab
		if not Active then
			local Offset = math.abs(i - ActiveTab) - 1
			if Offset < 3 then
				local OffsetOld = (i - (OldActiveTab or ActiveTab)) * 40
				local OffsetNew = (i - ActiveTab) * 40
				GUI.Tabs[i].Label = vgui.Create("DButton", GUI.MasterFrame)
				GUI.Tabs[i].Label:SetSize(GUI.Tabs[ActiveTab]:GetWide(), 40)
				GUI.Tabs[i].Label:SetText("")
				if i < ActiveTab then
					GUI.Tabs[i].Label:SetPos(ShownX + OffsetOld, ShownY - OffsetOld + GUI.Tabs[ActiveTab]:GetTall() - 40)
					GUI.Tabs[i].Label:MoveTo(ShownX + OffsetNew, ShownY - OffsetNew + GUI.Tabs[ActiveTab]:GetTall() - 40, 0.5, 0, 1)
					GUI.Tabs[i].Label.Paint = function()
						draw.SimpleText(v.Name, "VHUIFontSmall", GUI.Tabs[ActiveTab]:GetWide()/2, 20, Settings.Colors.Text, 1, 1)
					end
				else
					GUI.Tabs[i].Label:SetPos(ShownX + OffsetOld, ShownY - OffsetOld)
					GUI.Tabs[i].Label:MoveTo(ShownX + OffsetNew, ShownY - OffsetNew, 0.5, 0, 1)
					GUI.Tabs[i].Label.Paint = function()
						draw.SimpleText(v.Name, "VHUIFontSmall", GUI.Tabs[ActiveTab]:GetWide()/2, 20, Settings.Colors.Text, 1, 1)
					end
				end
				GUI.Tabs[i].Label.DoClick = function()
					local Old = ActiveTab
					ActiveTab = i
					DrawTabs(Old)
				end
			end
		end
	end
end
