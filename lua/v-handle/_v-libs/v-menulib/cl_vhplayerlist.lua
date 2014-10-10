PANEL = {}

AccessorFunc(PANEL, "menu_selected", "Selected")

function PANEL:Init()
	self.main = self:Add("DPanel")
	self.main:SetWide(self:GetWide() * 0.6)
	self.main:Dock(LEFT)
	self.extra = self:Add("DPanel")
	self.extra:Dock(FILL)
	for _, v in pairs(player.GetAll()) do
	end
end

vgui.Register("VH_PlayerList", PANEL)