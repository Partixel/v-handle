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

local GUI = GUI or {}

local Tabs = {"Commands", "Bans", "Ranks", "Reports", "Adverts", "Warns", "Statistics", "Settings"}

surface.CreateFont( "vm_UIFontLarge", {
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
	shadow = true,
	additive = false,
	outline = false,
})

surface.CreateFont( "vm_UIFont", {
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
	shadow = true,
	additive = false,
	outline = false,
})

function vm:ShowMenu()
	if (not GUI.MenuFrame) then CreateGui() end
	if (not GUI.MenuFrame) then return end
	GUI.MenuFrame:SetVisible(true) -- Todo animation of some sorts
end

function vm:HideMenu()
	if (not GUI.MenuFrame) then CreateGui() end
	if (not GUI.MenuFrame) then return end
	GUI.MenuFrame:SetVisible(false)
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
	GUI.TabPanel:SetSize(GUI.MenuFrame:GetWide() * Settings.Sizes.TabPanel - 5, GUI.MenuFrame:GetTall() * 0.1)
	GUI.TabPanel.Paint = function()
		draw.RoundedBox(0, 0, 0, GUI.TabPanel:GetWide(), GUI.TabPanel:GetTall(), Settings.Colors.TabPanel)
	end

	GUI.TabTitle = GUI.TabTitle or vgui.Create("DLabel", GUI.TabPanel)
	GUI.TabTitle:SetText("Vector Moderation")
	GUI.TabTitle:SetFont("vm_UIFontLarge")
	GUI.TabTitle:SetTextColor(Settings.Colors.Text)
	GUI.TabTitle:SizeToContents()
	GUI.TabTitle:SetPos(GUI.TabPanel:GetWide()/2 - GUI.TabTitle:GetWide()/2, 5)

	GUI.TabButtons = GUI.TabButtons or {}
	for k, v in ipairs(Tabs) do
		local Width = math.random(85, 95)/100
		GUI.TabButtons[v] = GUI.TabButtons[v] or vgui.Create("DButton", GUI.MenuFrame)
		GUI.TabButtons[v]:SetText(v)
		GUI.TabButtons[v]:SetFont("vm_UIFont")
		GUI.TabButtons[v]:SetTextColor(Settings.Colors.Text)
		GUI.TabButtons[v]:SetPos((1 - Width) * GUI.TabPanel:GetWide()/2, GUI.TabPanel:GetTall() + 10 + (k - 1) * (GUI.MenuFrame:GetTall() * 0.1 + 5))
		GUI.TabButtons[v]:SetSize(GUI.TabPanel:GetWide() * Width, GUI.MenuFrame:GetTall() * 0.1)
		GUI.TabButtons[v].DoClick = function()
		end
		GUI.TabButtons[v].Paint = function()
			draw.RoundedBox(0, 0, 0, GUI.TabButtons[v]:GetWide(), GUI.TabButtons[v]:GetTall(), Settings.Colors.TabButton)
		end
	end

	GUI.CommandPanel = GUI.CommandPanel or vgui.Create("DPanel", GUI.MenuFrame)
	GUI.CommandPanel:SetPos(GUI.MenuFrame:GetWide() * Settings.Sizes.TabPanel + 5, 10)
	GUI.CommandPanel:SetSize(GUI.MenuFrame:GetWide() * (1 - Settings.Sizes.TabPanel) - 5, GUI.MenuFrame:GetTall() - 20)
	GUI.CommandPanel.Paint = function()
		draw.RoundedBox(0, 0, 0, GUI.CommandPanel:GetWide(), GUI.CommandPanel:GetTall(), Settings.Colors.CommandPanel)
	end
end

concommand.Add("+vm_menu", function() vm:ShowMenu() end)
concommand.Add("-vm_menu", function() vm:HideMenu() end)