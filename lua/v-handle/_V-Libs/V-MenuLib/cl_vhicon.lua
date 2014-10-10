function DrawIcon(icon, color, posx, posy, sizex, sizey, rotation)
	local x = math.floor(posx - math.sin(math.rad(-rotation - 90)) * 90)
	local y = math.floor(posy - math.cos(math.rad(-rotation - 90)) * 90)
	surface.SetDrawColor(color)
	surface.SetMaterial(icon)
	surface.DrawTexturedRect(x - sizex/2, y - sizey/2, sizex, sizey)
end

PANEL = {}

AccessorFunc(PANEL, "menu_icon", "Icon")
AccessorFunc(PANEL, "menu_color", "Color")
AccessorFunc(PANEL, "menu_posx", "PosX")
AccessorFunc(PANEL, "menu_posy", "PosY")
AccessorFunc(PANEL, "menu_rotation", "Rotation")
AccessorFunc(PANEL, "menu_size", "IconSize")
AccessorFunc(PANEL, "menu_direction", "Direction")

function PANEL:Init()
	self.newColor = nil
	self.newPosX = nil
	self.newPosY = nil
	self.newMaterial = nil
	self.newRotation = nil
	self.newSize = nil
end

function TweenColor(Variable, TargetVariable, BackupVariable)
	local TargetVariable = TargetVariable or BackupVariable
	local Variable = Variable or TargetVariable
	local r = TweenVariable(Variable.r, TargetVariable.r, BackupVariable.r)
	local g = TweenVariable(Variable.g, TargetVariable.g, BackupVariable.g)
	local b = TweenVariable(Variable.b, TargetVariable.b, BackupVariable.b)
	local a = TweenVariable(Variable.a, TargetVariable.a, BackupVariable.a)
	return Color(r, g, b, a)
end

function TweenVariable(Variable, TargetVariable, BackupVariable)
	if not TargetVariable then
		return BackupVariable
	elseif not Variable then
		return TargetVariable
	elseif Variable == TargetVariable then
		return TargetVariable
	elseif math.abs(TargetVariable - Variable) < 5 then
		return TargetVariable
	elseif TargetVariable > Variable then
		return Variable + 4
	else
		return Variable - 4
	end
end

function TweenAngle(Variable, TargetVariable, BackupVariable, Direction)
	if not TargetVariable then
		return BackupVariable
	elseif not Variable then
		return TargetVariable
	elseif Variable == TargetVariable then
		return TargetVariable
	elseif math.abs(TargetVariable - Variable) < 5 then
		return TargetVariable
	else
		return Variable + (Direction * 4)
	end
end

function PANEL:Paint(w, h)
	DrawIcon(self.newMaterial, self.newColor, self.newPosX, self.newPosY, self.newSize, self.newSize, self.newRotation)
end

function PANEL:Think()
	if not self.newMaterial and self:GetIcon() then
		self.newMaterial = Material(self:GetIcon())
	end
	self.newColor = TweenColor(self.newColor, self:GetColor(), Color(50, 50, 50))
	self.newPosX = TweenVariable(self.newPosX, self:GetPosX(), 0)
	self.newPosY = TweenVariable(self.newPosY, self:GetPosY(), 0)
	self.newRotation = TweenAngle(math.NormalizeAngle(self.newRotation or 0), math.NormalizeAngle(self:GetRotation() or 0), 0, self:GetDirection() or 1)
	self.newSize = TweenVariable(self.newSize, self:GetIconSize(), 0)
end

vgui.Register("VH_Icon", PANEL)