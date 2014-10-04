
local Registry = debug.getregistry()

function Registry.Player:PLGod(State)
	if State then
		self:GodEnable()
	else
		self:GodDisable()
	end
end

function Registry.Player:PLPreventSuicide(State)
	self.PLPreventSuicide = State
end

hook.Add("CanPlayerSuicide", "PLPreventSuicide", function(Player)
	if Player.PLPreventSuicide then
		return false
	end
end)

hook.Add("PlayerSpawnEffect", "PLLock_EffectSpawn", function(Player, Object)
	if Player.PLLocked then
		return false
	end
end)

hook.Add("PlayerSpawnNPC", "PLLock_NPCSpawn", function(Player, Object)
	if Player.PLLocked then
		return false
	end
end)

hook.Add("PlayerSpawnObject", "PLLock_ObjectSpawn", function(Player, Object)
	if Player.PLLocked then
		return false
	end
end)

hook.Add("PlayerSpawnProp", "PLLock_PropSpawn", function(Player, Object)
	if Player.PLLocked then
		return false
	end
end)

hook.Add("PlayerSpawnRagdoll", "PLLock_RagdollSpawn", function(Player, Object)
	if Player.PLLocked then
		return false
	end
end)

hook.Add("PlayerSpawnSENT", "PLLock_SENTSpawn", function(Player, Object)
	if Player.PLLocked then
		return false
	end
end)

hook.Add("PlayerSpawnVehicle", "PLLock_VehicleSpawn", function(Player, Object)
	if Player.PLLocked then
		return false
	end
end)

hook.Add("PlayerGiveSWEP", "PLLock_SWEPSpawn", function(Player, Weapon, SWEP)
	if Player.PLLocked then
		return false
	end
end)

hook.Add("CanProperty", "PLLock_CanProperty", function(Player, Trace, Tool)
	if Player.PLLocked then
		return false
	end
end)

hook.Add("CanDrive", "PLLock_CanDrive", function(Player, Trace, Tool)
	if Player.PLLocked then
		return false
	end
end)

hook.Add("PlayerDisconnected", "PL_HandleLeave", function(Player)
	table.RemoveByValue(PreventSuicide, Player:SteamID())
end)

function Registry.Player:PLLock(State)
	if State then
		self:Lock()
		self:PLGod(State)
		self:PLPreventSuicide(State)
		self.PLLocked = true
	else
		self:UnLock()
		self:PLGod(State)
		self:PLPreventSuicide(State)
		self.PLLocked = false
	end
end