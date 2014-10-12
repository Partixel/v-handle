_V = _V or {}

_V.PlayerLib = {}

local Registry = debug.getregistry()

--[[ Makes HasGodMode work client side -- 

local PlrGodEnable = Player.GodEnable
local PlrGodDisable = Player.GodDisable

if SERVER then
	util.AddNetworkString("PLPlayerGod")
else
	net.Receive("PLPlayerGod", function(Plr, Length)
		local State = net.ReadBit()
		local Entity = net.ReadEntity()
		Entity.isGod = State
	end)
end

function Registry.Player:GodEnable()
	PlrGodEnable(self)
	self.isGod = true
	net.Start("PLPlayerGod")
		net.WriteBit(true)
		net.WriteEntity(self)
	net.Broadcast()
end

function Registry.Player:GodDisable()
	PlrGodDisable(self)
	self.isGod = false
	net.Start("PLPlayerGod")
		net.WriteBit(false)
		net.WriteEntity(self)
	net.Broadcast()
end

function Registry.Player:HasGodMode()
	return self.isGod
end

function Registry.Player:PLGod(State)
	if State then
		self:GodEnable()
	else
		self:GodDisable()
	end
end

function Registry.Player:PLPreventSuicide(State)
	self.PLPreventSuicide = State
end]]

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

hook.Add("PlayerBindPress", "PLLock_BindPress", function(Player, Bind, Pressed)
	if Player.PLLocked then
		return true
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

function Registry.Player:ForceMoveable()
	self:ExitVehicle()
	if not self:Alive() then
		self:Spawn()
	end
	self:PLLock(false)
	self:Freeze(false)
end

local PlrSetPos = Registry.Entity.SetPos

function Registry.Player:SetPos(Pos)
	self.PLLastPos = self:GetPos()
	PlrSetPos(self, Pos)
end

function Registry.Player:PLForceTeleport(Pos)
	self:ForceMoveable()
	self:SetPos(Pos)
end

function Registry.Player:PLSafeTeleport(Pos)
	self:ForceMoveable()
	local SafePos = Pos
	-- Do checks here
	self:SetPos(SafePos)
end

function Registry.Player:Teleport(Player)
	--Todo, check for closest available spot
	self:SetPos(Player:GetPos() + Player:GetForward() * 45)
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
	if Player:PLGetChatMuted() then
		return ""
	end
end)

hook.Add("PlayerStartVoice", "PLMicMuted", function(Player)
	if Player:PLGetMicMuted() then
		Player:SendLua("LocalPlayer():ConCommand(\"-voicerecord\")")
	end
end)

hook.Add("PlayerInitialSpawn", "PlayerNick", function(Player)
	Player:setPlayerData("SavedNick", Player:Nick())
end)

hook.Add("PlayerDisconnected", "PlayerNick", function(Player)
	Player:setPlayerData("SavedNick", Player:Nick())
end)

function _V.PlayerLib.PLBan(SID, Length, Banner, Reason)
	_V.DataLib.setData(SID, "PLBan", {Start = os.time(), BanLength = Length, Banner = Banner, Reason = Reason})
	for a, b in ipairs(player.GetAll()) do
		if b:SteamID() == SID then
			b:Kick("\nYou have been banned by " .. Banner .. " for " .. Length .. " second(s):\n" .. Reason)
		end
	end
end

function _V.PlayerLib.PLUpdateBan(SID)
	local Data = _V.DataLib.getData(SID, "PLBan")
	if Data then
		if Data.Start and Data.BanLength and Data.Reason then
			if Data.Start + Data.BanLength <= os.time() then
				_V.PlayerLib.PLUnBan(SID)
				return false
			else
				return true, Data
			end
		else
			_V.PlayerLib.PLUnBan(SID)
			return false
		end
	end
	return false
end

function _V.PlayerLib.PLEditBan(SID, Length, Banner, Reason)
	local Data = _V.DataLib.getData(SID, "PLBan")
	if Data then
		local Start = Data.Start
		if Start + Length <= os.time() then
			_V.PLUnBan(SID)
			return true
		else
			local Edits = Data.Edits or {}
			table.insert(Edits, Banner)
			_V.DataLib.setData(SID, "PLBan", {Start = Start, Banner = Data.Banner, Edits = Edits, BanLength = Length, Reason = Reason})
			return false
		end
	end
end

function _V.PlayerLib.PLUnBan(SID)
	_V.DataLib.setData(SID, "PLBan", nil)
end

function Registry.Player:PLBan(Length, Banner, Reason)
	_V.PlayerLib.PLBan(self:SteamID(), Length, Banner, Reason)
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
	
	hook.Run("PLBan_Joining", Data)
	
	return false, "You have been banned by " .. Data.BannerN .. " for " .. TimeLeft .. " second(s):\n" .. Data.Reason
end)