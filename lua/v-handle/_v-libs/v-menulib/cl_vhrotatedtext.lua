function DrawRotatedText(text, font, color, posx, posy, scalex, scaley, centeredx, centeredy, offsetx, offsety, rotation)
	local matrix = Matrix()
	local matrixAngle = Angle(0, 0, 0)
	local matrixScale = Vector(0, 0, 0)
	local matrixTranslation = Vector(0, 0, 0)
	
	matrixAngle.y = math.floor(rotation)
	matrix:SetAngles(matrixAngle)
	
	surface.SetFont(font)
	
	matrixTranslation.x = math.floor(posx)
	matrixTranslation.y = math.floor(posy)
	
	local sizeX, sizeY = surface.GetTextSize(text)
	sizeX = (sizeX * scalex * centeredx) + (-offsetx * scalex * 2)
	sizeY = (sizeY * scaley * centeredy) + (-offsety * scaley * 2)
	
	matrixTranslation.x = math.floor(matrixTranslation.x - math.sin(math.rad(-rotation + 90)) * sizeX/2 - math.sin(math.rad(-rotation)) * sizeY/2)
	matrixTranslation.y = math.floor(matrixTranslation.y - math.cos(math.rad(-rotation + 90)) * sizeX/2 - math.cos(math.rad(-rotation)) * sizeY/2)
	
	matrix:SetTranslation(matrixTranslation)
	
	matrixScale.x = scalex
	matrixScale.y = scaley
	matrix:Scale(matrixScale)
	
	surface.SetTextColor(color)
	surface.SetTextPos(0, 0)
	
	cam.PushModelMatrix(matrix)
		surface.DrawText(text)
	cam.PopModelMatrix()
end

PANEL = {}

AccessorFunc(PANEL, "menu_text", "Text")
AccessorFunc(PANEL, "menu_font", "Font")
AccessorFunc(PANEL, "menu_color", "Color")
AccessorFunc(PANEL, "menu_posx", "PosX")
AccessorFunc(PANEL, "menu_posy", "PosY")
AccessorFunc(PANEL, "menu_scalex", "ScaleX")
AccessorFunc(PANEL, "menu_scaley", "ScaleY")
AccessorFunc(PANEL, "menu_centx", "CenteredX")
AccessorFunc(PANEL, "menu_centy", "CenteredY")
AccessorFunc(PANEL, "menu_offsetx", "OffsetX")
AccessorFunc(PANEL, "menu_offsety", "OffsetY")
AccessorFunc(PANEL, "menu_rotation", "Rotation")
AccessorFunc(PANEL, "menu_direction", "Direction")

function PANEL:Init()
	self.newColor = nil
	self.newPosX = nil
	self.newPosY = nil
	self.newRotation = nil
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
	DrawRotatedText(self:GetText(), self:GetFont(), self.newColor, self.newPosX, self.newPosY, self:GetScaleX(), self:GetScaleY(), self:GetCenteredX(), self:GetCenteredY(), self:GetOffsetX(), self:GetOffsetY(), self.newRotation)
end

function PANEL:Think()
	self.newColor = TweenColor(self.newColor, self:GetColor(), Color(50, 50, 50))
	self.newPosX = TweenVariable(self.newPosX, self:GetPosX(), 0)
	self.newPosY = TweenVariable(self.newPosY, self:GetPosY(), 0)
	self.newRotation = TweenAngle(math.NormalizeAngle(self.newRotation or 0), math.NormalizeAngle(self:GetRotation() or 0), 0, self:GetDirection() or 1)
end

vgui.Register("VH_Text", PANEL)