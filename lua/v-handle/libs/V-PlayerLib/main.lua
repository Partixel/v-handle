if CLIENT then return end

_V = _V or {}

_V.PlayerLib = {}

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

function Registry.Player:PLGetPreventSuicide()
	return self.PL.PreventSuicide or false
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

local PlrLock = Registry.Player.Lock
local PlrUnLock = Registry.Player.UnLock

function Registry.Player:Lock()
	PlrLock(self)
	self.PLLocked = true
end

function Registry.Player:UnLock()
	PlrUnLock(self)
	self.PLLocked = false
end

function Registry.Player:PLGetLocked()
	return self.PLLocked or false
end

function Registry.Player:PLLock(State)
	if State then
		self:Lock()
		self:PLGod(State)
		self:PLPreventSuicide(State)
	else
		self:UnLock()
		self:PLGod(State)
		self:PLPreventSuicide(State)
	end
end

local PlrSetPos = Registry.Player.SetPos

function Registry.Player:SetPos(pos)
	self.PLLastPos = self:GetPos()
	self:ExitVehicle()
	PlrSetPos(self, pos)
end

function Registry.Player:PLGetLastPos()
	return self.PLLastPos
end

function Registry.Player:PLMuteChat(State)
	self.PLChatMuted = State
end

function Registry.Player:PLGetChatMuted()
	return self.PLChatMuted or false
end

function Registry.Player:PLMuteMic(State)
	self.PLMicMuted = State
end

function Registry.Player:PLGetMicMuted()
	return self.PLMicMuted or false
end

hook.Add("PlayerSay", "PLChatMuted", function(Player, Message, TeamChat)
	if Player:GetChatMuted() then
		return true
	end
end)

hook.Add("PlayerStartVoice", "PLMicMuted", function(Player)
	if Player:GetMicMuted() then
		Player:SendLua("LocalPlayer():ConCommand(\"-voicerecord\")")
	end
end)

function _V.PlayerLib.PLBan(SID, Length, Reason)
	_V.PlayerDataLib.setPlayerData(SID, "PLBan", {Start = os.time(), BanLength = Length, Reason = Reason})
	for a, b in ipairs(player.GetAll()) do
		if b:SteamID() == SID then
			b:Kick("\nYou have been banned for " .. Length .. " second(s):\n" .. Reason)
		end
	end
end

function _V.PlayerLib.PLUpdateBan(SID)
	local Data = _V.PlayerDataLib.getPlayerData(SID, "PLBan")
	if Data then
		if Data.Start and Data.BanLength and Data.Reason then
			if Data.Start + Data.BanLength <= os.time() then
				_V.PlayerLib.PLUnBan(SID)
				return true
			else
				return false, Data
			end
		else
			_V.PlayerLib.PLUnBan(SID)
			return true
		end
	end
	return true
end

function _V.PlayerLib.PLEditBan(SID, Length, Reason)
	local Data = _V.PlayerDataLib.getPlayerData(SID, "PLBan")
	if Data then
		local Start = Data.Start
		if Start + Length <= os.time() then
			_V.PLUnBan(SID)
			return true
		else
			_V.PlayerDataLib.setPlayerData(SID, "PLBan", {Start = Start, BanLength = Length, Reason = Reason})
			return false
		end
	end
end

function _V.PlayerLib.PLUnBan(SID)
	_V.PlayerDataLib.setPlayerData(SID, "PLBan", nil)
end

function Registry.Player:PLBan(Length, Reason)
	_V.PlayerLib.PLBan(self:SteamID(), Length, Reason)
end

hook.Add("CheckPassword", "PLBan", function(SID, IP, svPass, clPass, Name)
	SID = util.SteamIDFrom64(SID)
	local Banned, Data = _V.PlayerLib.PLUpdateBan(SID)
	
	if not Banned then
		Banned, Data = _V.PlayerLib.PLUpdateBan(IP)
		if not Banned then
			return
		end
	end
	
	local TimeLeft = (Data.Start + Data.BanLength) - os.time()
	return false, "You are banned for " .. TimeLeft .. " second(s):\n" .. Data.Reason
end)