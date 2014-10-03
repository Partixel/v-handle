local Command = _V.CommandLib.Command:new("Goto", _V.CommandLib.UserTypes.Admin, "Teleport to the player.", "")
Command:addArg(_V.CommandLib.ArgTypes.Player, true)
Command:addAlias("!goto")

local Positions = {}
for i = 0, 360, 45 do
	table.insert(Positions, Vector(math.cos(i), math.sin(i), 0))
end

function FindPosition(Player)
	local Size = Vector(32, 32, 72)
	local StartPos = Player:GetPos() + Vector(0, 0, Size.z/2)
	
	for _,v in ipairs(Positions) do
		local Pos = StartPos + v * Size * 1.5
		
		local tr = {}
		tr.start = Pos
		tr.endpos = Pos
		tr.mins = Size / 2 * -1
		tr.maxs = Size / 2
		local trace = util.TraceHull(tr)
		
		if (!trace.Hit) then
			return Pos - Vector(0, 0, Size.z/2)
		end
	end
	
	return false
end

Command.Callback = function(Sender, Alias, Target)
	if Sender:InVehicle() then
		Sender:ExitVehicle()
	end
	Sender:SetNWVector("TeleportReturnPos", Sender:GetPos())
	if Sender:GetMoveType() == MOVETYPE_NOCLIP then
		Sender:SetPos(Target:GetPos() + Target:GetForward() * 45)
	else
		local Pos = self:FindPosition(Target)
		if Pos then
			ply:SetPos(Pos)
		else
			ply:SetPos(Target:GetPos() + Vector(0, 0, 72))
		end
	end

	local Nick = "Console"
	if Sender:IsValid() then
		Nick = Sender:Nick()
	end
	
	--vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has armed _reset_ " .. vh.ArgsUtil.PlayersToString(Targets) .. " _white_ to _reset_ ".. Amount)
	return ""
end