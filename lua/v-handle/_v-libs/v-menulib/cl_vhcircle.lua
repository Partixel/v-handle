function CreateCircle(x, y, radius)
    local quality = math.min(256, 4 * math.sqrt(radius) + 8)
    local verts = {}
    local ang = 0
    for i = 1, quality do
        ang = i * math.pi * 2 / quality
        verts[i] = { x = x + math.cos(ang) * radius, y = y + math.sin(ang) * radius }
    end
    return verts
end

PANEL = {}

AccessorFunc(PANEL, "menu_rad", "Radius")
AccessorFunc(PANEL, "menu_color", "Color")

function PANEL:Init()
	self.Vertices = nil
	self.newColor = nil
	self.Vars = nil
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(self.newColor or self:GetColor())
	surface.SetMaterial(Material("vgui/white"))
	if not self.Vertices then return end
	surface.DrawPoly(self.Vertices)
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

function PANEL:Think()
	self.newColor = TweenColor(self.newColor, self:GetColor(), Color(50, 50, 50))
	if not self.Vertices then
		self.VerticeVars = {self:GetRadius() or 70}
		self.Vertices = CreateCircle(self:GetWide()/2, self:GetTall()/2, self.VerticeVars[1])
	else
		local newVars = {self:GetRadius() or 70}
		if self.VerticeVars ~= newVars then
			self.VerticeVars = newVars
			self.Vertices = CreateCircle(self:GetWide()/2, self:GetTall()/2, self.VerticeVars[1])
		end
	end
end

vgui.Register("VH_Circle", PANEL)