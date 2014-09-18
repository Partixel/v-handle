function CreateHollowCircle(x, y, innerRadius, outerRadius, oldStartAngle, oldRotation)
	local startAngle = math.rad(oldStartAngle)
	local rotation = math.rad(oldRotation)
	local quality = math.min(256, 4 * math.sqrt(outerRadius) + 8)
	local verts = {}
	local angA, angB
	local mul = math.pi * 2 / quality
	local count = quality * rotation / (math.pi * 2)
	for i = 0, count do
		angA = startAngle + i * mul
		angB = angA + mul
		if angB - startAngle > rotation then angB = startAngle + rotation end
		sinA, cosA = math.sin(angA), math.cos(angA)
		sinB, cosB = math.sin(angB), math.cos(angB)
		verts[i + 1] = {
			{ x = x + cosA * innerRadius, y = y + sinA * innerRadius },
			{ x = x + cosA * outerRadius, y = y + sinA * outerRadius },
			{ x = x + cosB * outerRadius, y = y + sinB * outerRadius },
			{ x = x + cosB * innerRadius, y = y + sinB * innerRadius }
		}
	end
	return verts
end

PANEL = {}

AccessorFunc(PANEL, "menu_innerRad", "InnerRadius")
AccessorFunc(PANEL, "menu_outerRad", "OuterRadius")
AccessorFunc(PANEL, "menu_startAng", "StartAngle")
AccessorFunc(PANEL, "menu_rotation", "Rotation")
AccessorFunc(PANEL, "menu_color", "Color")
AccessorFunc(PANEL, "menu_direction", "Direction")
AccessorFunc(PANEL, "menu_name", "Name")

function PANEL:Init()
	self.Vertices = nil
	self.VerticeVars = nil
	self.newInnerRadius = nil
	self.newOuterRadius = nil
	self.newStartAngle = nil
	self.newRotation = nil
	self.newColor = nil
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(self.newColor or self:GetColor())
	surface.SetMaterial(Material("vgui/white"))
	if not self.Vertices then return end
	for _, v in ipairs(self.Vertices) do
		surface.DrawPoly(v)
	end
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

function PANEL:Think()
	self.newInnerRadius = TweenVariable(self.newInnerRadius, self:GetInnerRadius(), 70)
	self.newOuterRadius = TweenVariable(self.newOuterRadius, self:GetOuterRadius(), 15)
	self.newStartAngle = TweenAngle(math.NormalizeAngle(self.newStartAngle or 0), math.NormalizeAngle(self:GetStartAngle() or 0), 0, self:GetDirection() or 1)
	self.newRotation = TweenVariable(self.newRotation, self:GetRotation(), 90)
	self.newColor = TweenColor(self.newColor, self:GetColor(), Color(50, 50, 50))
	if not self.Vertices then
		self.VerticeVars = {self.newInnerRadius, self.newOuterRadius, self.newStartAngle, self.newRotation}
		self.Vertices = CreateHollowCircle(self:GetWide()/2, self:GetTall()/2, self.VerticeVars[1], self.VerticeVars[2], self.VerticeVars[3], self.VerticeVars[4])
	else
		local newVars = {self.newInnerRadius, self.newOuterRadius, self.newStartAngle, self.newRotation}
		if self.VerticeVars ~= newVars then
			self.VerticeVars = newVars
			self.Vertices = CreateHollowCircle(self:GetWide()/2, self:GetTall()/2, self.VerticeVars[1], self.VerticeVars[2], self.VerticeVars[3], self.VerticeVars[4])
		end
	end
end

vgui.Register("VH_HollowCircle", PANEL)