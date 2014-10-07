local Command = _V.CommandLib.Command:new("Unstuck", _V.CommandLib.UserTypes.Admin, "Sends you to the nearest unoccupied position.", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = false})
Command:addAlias("!unstuck")

local function CheckOutsideMap(Position, LowerBounds, UpperBounds)
	if not util.IsInWorld(Vector(Position.x + LowerBounds.x, Position.y + LowerBounds.y, Position.z + LowerBounds.z)) then return true end
	if not util.IsInWorld(Vector(Position.x - LowerBounds.x, Position.y + LowerBounds.y, Position.z + LowerBounds.z)) then return true end
	if not util.IsInWorld(Vector(Position.x - LowerBounds.x, Position.y - LowerBounds.y, Position.z + LowerBounds.z)) then return true end
	if not util.IsInWorld(Vector(Position.x + LowerBounds.x, Position.y - LowerBounds.y, Position.z + LowerBounds.z)) then return true end
	
	if not util.IsInWorld(Vector(Position.x + UpperBounds.x, Position.y + UpperBounds.y, Position.z + UpperBounds.z)) then return true end
	if not util.IsInWorld(Vector(Position.x - UpperBounds.x, Position.y + UpperBounds.y, Position.z + UpperBounds.z)) then return true end
	if not util.IsInWorld(Vector(Position.x - UpperBounds.x, Position.y - UpperBounds.y, Position.z + UpperBounds.z)) then return true end
	if not util.IsInWorld(Vector(Position.x + UpperBounds.x, Position.y - UpperBounds.y, Position.z + UpperBounds.z)) then return true end
	
	for i = 0.2, 0.8, 0.2 do
		if not util.IsInWorld(Vector(Position.x, Position.y, Position.z + (UpperBounds.z + LowerBounds.z) * i)) then return true end
	end
	return false
end


local function CheckProps(Position, LowerBounds, UpperBounds)
	LowerBox = Position
	LowerBox:Add(LowerBounds)
	UpperBox = Position
	UpperBox:Add(UpperBounds)
	
	Entities = ents.FindInBox(LowerBox, UpperBox)
	for _, v in pairs(Entities) do
		if v:GetSolid() == SOLID_VPHYSICS then
			return true
		end
	end
	return false
end


local function FindNewPosition(Player, Attempt)
	local LowerBounds, UpperBounds = Player:GetCollisionBounds()
	local UpVelocity = Player:GetVelocity().z
	Player:SetVelocity(Vector(0, 0, 250))
	
	timer.Simple(0.1, function()
		local UpDelta = math.abs((Player:GetVelocity().z - UpVelocity))
		if UpDelta > 30 then return end
		
		local Position = Player:GetPos()
		if Attempt > 0 then
			Position:Add(Vector(0, 0, 30))
			Player:SetPos(Position)
		end
		local TestingPosition
		for i = 15, 10550, 0.1 do
			TestingPosition = Vector(math.random(-i, i) + Position.x, math.random(-i, i) + Position.y, math.random(-i, i) + Position.z)
			if not CheckOutsideMap(TestingPosition, LowerBounds, UpperBounds) then
				if not CheckProps(TestingPosition, LowerBounds, UpperBounds) then
					Player:SetPos(TestingPosition)
					if Attempt < 5 then
						Attempt = Attempt + 1
						FindNewPosition(Player, Attempt)
					end
					return
				end
			end
		end
	end)
end

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	
	for _, ply in ipairs(Targets) do
		FindNewPosition(ply, 0)
	end
	
	_V.CommandLib.SendCommandMessage(Sender, "unstucked", Targets, "")
	
	return ""
end