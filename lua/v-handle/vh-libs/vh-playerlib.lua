VH_PlayerLib = {}

local Registry = debug.getregistry()

if SERVER then

	util.AddNetworkString("VH-PlayerLib-UpdateBool")
	
	// PlayerLib god functions
	local PlrGodEnable = Registry.Player.GodEnable
	local PlrGodDisable = Registry.Player.GodDisable
	
	function Registry.Player:GodEnable()
		PlrGodEnable(self)
		self.PLGod = true
		net.Start("VH-PlayerLib-UpdateBool")
			net.WriteString("PLGod")
			net.WriteBit(true)
			net.WriteEntity(self)
		net.Send(self)
	end
	
	function Registry.Player:GodDisable()
		PlrGodDisable(self)
		self.PLGod = false
		net.Start("VH-PlayerLib-UpdateBool")
			net.WriteString("PLGod")
			net.WriteBit(false)
			net.WriteEntity(self)
		net.Send(self)
	end
	
	function Registry.Player:PLGod(State)
		if State then
			self:GodEnable()
		else
			self:GodDisable()
		end
	end
	
	// PlayerLib prevent suicide functions
	function Registry.Player:PLPreventSuicide(State)
		self.PLPreventSuicide = State
		net.Start("VH-PlayerLib-UpdateBool")
			net.WriteString("PLPreventSuicide")
			net.WriteBit(State)
			net.WriteEntity(self)
		net.Send(self)
	end
	
	// PlayerLib kill functions
	local PlrKill = Registry.Player.Kill
	local PlrKillSilent = Registry.Player.KillSilent

	function Registry.Player:Kill()
		if not self:PLisLocked() then
			PlrKill(self)
		end
	end

	function Registry.Player:KillSilent()
		if not self:PLisLocked() then
			PlrKillSilent(self)
		end
	end

	// PlayerLib lock functions
	local PlrLock = Registry.Player.Lock
	local PlrUnLock = Registry.Player.UnLock

	function Registry.Player:Lock()
		PlrLock(self)
		self.PLLocked = true
		net.Start("VH-PlayerLib-UpdateBool")
			net.WriteString("PLLocked")
			net.WriteBit(true)
			net.WriteEntity(self)
		net.Send(self)
	end

	function Registry.Player:UnLock()
		PlrUnLock(self)
		self.PLLocked = false
		net.Start("VH-PlayerLib-UpdateBool")
			net.WriteString("PLLocked")
			net.WriteBit(false)
			net.WriteEntity(self)
		net.Send(self)
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

	// PlayerLib teleport functions
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

	function Registry.Player:Teleport(Plr)
		--Todo, check for closest available spot
		self:SetPos(Plr:GetPos() + Plr:GetForward() * 45)
	end
	
	// PlayerLib force moveable functions
	function Registry.Player:ForceMoveable()
		self:ExitVehicle()
		if not self:Alive() then
			self:Spawn()
		end
		self:PLLock(false)
		self:Freeze(false)
	end
	
	// PlayerLib mute functions
	function Registry.Player:PLMuteChat(State)
		self.PLChatMuted = State
		net.Start("VH-PlayerLib-UpdateBool")
			net.WriteString("PLChatMuted")
			net.WriteBit(State)
			net.WriteEntity(self)
		net.Send(self)
	end
	
	function Registry.Player:PLMuteMic(State)
		self.PLMicMuted = State
		net.Start("VH-PlayerLib-UpdateBool")
			net.WriteString("PLMicMuted")
			net.WriteBit(State)
			net.WriteEntity(self)
		net.Send(self)
	end
	
	// PlayerLib PLBan functions
	function VH_PlayerLib.PLBan(SID, Length, Banner, Reason)
		VH_DataLib.setData(SID, "PLBan", {Start = os.time(), BanLength = Length, Banner = Banner, Reason = Reason})
		for a, b in ipairs(player.GetAll()) do
			if b:SteamID() == SID then
				b:Kick("\nYou have been banned by " .. Banner .. " for " .. Length .. " second(s):\n" .. Reason)
			end
		end
	end

	function VH_PlayerLib.PLUpdateBan(SID)
		local Data = VH_DataLib.getData(SID, "PLBan")
		if Data then
			if Data.Start and Data.BanLength and Data.Reason then
				if Data.Start + Data.BanLength <= os.time() then
					VH_PlayerLib.PLUnBan(SID)
					return false
				else
					return true, Data
				end
			else
				VH_PlayerLib.PLUnBan(SID)
				return false
			end
		end
		return false
	end

	function VH_PlayerLib.PLEditBan(SID, Length, Banner, Reason)
		local Data = VH_DataLib.getData(SID, "PLBan")
		if Data then
			local Start = Data.Start
			if Start + Length <= os.time() then
				VH_PLUnBan(SID)
				return true
			else
				local Edits = Data.Edits or {}
				table.insert(Edits, Banner)
				VH_DataLib.setData(SID, "PLBan", {Start = Start, Banner = Data.Banner, Edits = Edits, BanLength = Length, Reason = Reason})
				return false
			end
		end
	end

	function VH_PlayerLib.PLUnBan(SID)
		VH_DataLib.setData(SID, "PLBan", nil)
	end

	function Registry.Player:PLBan(Length, Banner, Reason)
		VH_PlayerLib.PLBan(self:SteamID(), Length, Banner, Reason)
	end
	
else

	net.Receive("VH-PlayerLib-UpdateBool", function(Length, Client)
		local Property = net.ReadString()
		local Value = net.ReadBit()
		local Plr = net.ReadEntity()
		if Property and Value ~= nil and Plr then
			Plr[Property] = (Value == 1)
		end
	end)

end

function Registry.Player:PLGetPreventSuicide()
	return self.PLPreventSuicide or false
end

local PlrHasGodMode = Registry.Player.HasGodMode
function Registry.Player:HasGodMode()
	return self.PLGod or false// or PlrHasGodMode(self)
end

function Registry.Player:PLisLocked()
	return self.PLLocked or false
end

function Registry.Player:PLGetLastPos()
	return self.PLLastPos
end

function Registry.Player:PLGetChatMuted()
	return self.PLChatMuted or false
end

function Registry.Player:PLGetMicMuted()
	return self.PLMicMuted or false
end

hook.Add("CanPlayerSuicide", "PLPreventSuicide", function(Plr)
	if Plr:PLGetPreventSuicide() then
		return false
	end
end)

hook.Add("PlayerSpawnEffect", "PLLock_EffectSpawn", function(Plr, Object)
	if Plr:PLisLocked() then
		return false
	end
end)

hook.Add("PlayerSpawnNPC", "PLLock_NPCSpawn", function(Plr, Object)
	if Plr:PLisLocked() then
		return false
	end
end)

hook.Add("PlayerSpawnObject", "PLLock_ObjectSpawn", function(Plr, Object)
	if Plr:PLisLocked() then
		return false
	end
end)

hook.Add("PlayerSpawnProp", "PLLock_PropSpawn", function(Plr, Object)
	if Plr:PLisLocked() then
		return false
	end
end)

hook.Add("PlayerSpawnRagdoll", "PLLock_RagdollSpawn", function(Plr, Object)
	if Plr:PLisLocked() then
		return false
	end
end)

hook.Add("PlayerSpawnSENT", "PLLock_SENTSpawn", function(Plr, Object)
	if Plr:PLisLocked() then
		return false
	end
end)

hook.Add("PlayerSpawnVehicle", "PLLock_VehicleSpawn", function(Plr, Object)
	if Plr:PLisLocked() then
		return false
	end
end)

hook.Add("PlayerGiveSWEP", "PLLock_SWEPSpawn", function(Plr, Weapon, SWEP)
	if Plr:PLisLocked() then
		return false
	end
end)

hook.Add("CanProperty", "PLLock_CanProperty", function(Plr, Trace, Tool)
	if Plr:PLisLocked() then
		return false
	end
end)

hook.Add("CanDrive", "PLLock_CanDrive", function(Plr, Trace, Tool)
	if Plr:PLisLocked() then
		return false
	end
end)

hook.Add("PlayerBindPress", "PLLock_BindPress", function(Plr, Bind, Pressed)
	if Plr:PLisLocked() then
		return true
	end
	if Plr:PLGetMicMuted() and string.lower(Bind) == "+voicerecord" then
		return true
	end
	if Plr:PLGetChatMuted() and (string.lower(Bind) == "messagemode" or string.lower(Bind) == "messagemode2") then
		return true
	end
end)

hook.Add("PlayerSwitchWeapon", "PLLock_SwitchWeapon", function(Plr, oldWep, newWep)
	if Plr:PLisLocked() then
		return true
	end
end)

VH_HookLib.addHook("PlayerSay", VH_HookLib.HookPriority.Lowest, "PLChatMuted", function(Plr, Message, TeamChat)
	if Plr:PLGetChatMuted() then
		return nil, true
	end
end)

hook.Add("PlayerStartVoice", "PLMicMuted", function(Plr)
	if Plr:PLGetMicMuted() and CLIENT then
		RunConsoleCommand("-voicerecord")
	end
end)

VH_HookLib.addHook("PlayerInitialSpawn", "PlayerNick", function(Plr)
	Plr:setPlayerData("SavedNick", Plr:Nick())
end)

hook.Add("PlayerDisconnected", "PlayerNick", function(Plr)
	Plr:setPlayerData("SavedNick", Plr:Nick())
end)

hook.Add("CheckPassword", "PLBan", function(SID, IP, svPass, clPass, Name)
	SID = util.SteamIDFrom64(SID)
	local Banned, Data = VH_PlayerLib.PLUpdateBan(SID)
	
	if not Banned then
		Banned, Data = VH_PlayerLib.PLUpdateBan(IP)
		if not Banned then
			return
		end
	end
	
	local TimeLeft = (Data.Start + Data.BanLength) - os.time()
	
	hook.Run("PLBan_Joining", Data)
	
	return false, "You have been banned by " .. Data.BannerN .. " for " .. TimeLeft .. " second(s):\n" .. Data.Reason
end)