_V = _V or {}

_V.PlayerDataLib = {}

Registry = debug.getregistry()

_V.PlayerDataLib.PlayerData = {}

if SERVER then
	
	util.AddNetworkString("PlayerData-Update")
	
	hook.Add("PlayerInitialSpawn", "_V-PlayerDataLib-Initial", function(Player)
		_V.PlayerDataLib.updatePlayerData(Player:SteamID())
	end
	
	function _V.PlayerDataLib.updatePlayerData(SID)
		local Player = _V.PlayerDataLib.PlayerFromSID(SID)
		if Player then
			local Data = Player:getDataTable()
			net.Start("PlayerData-Update")
				net.WriteTable(Data)
			net.Send(Player)
		end
	end
	
	function _V.PlayerDataLib.setPlayerData(SID, Key, Value)
		local Data = _V.PlayerDataLib.getDataTable(SID)
		Data[Key] = Value
		_V.PlayerDataLib.updatePlayerData(SID)
	end

	function Registry.Player:setPlayerData(Key, Value)
		local Data = _V.PlayerDataLib.setPlayerData(self:UniqueID(), Key, Value)
	end
	
	function _V.PlayerDataLib.getDataTable(SID)
		local Data = _V.PlayerDataLib.PlayerData[SID]
		if Data == nil then
			_V.PlayerDataLib.PlayerData[SID] = {}
			Data = _V.PlayerDataLib.PlayerData[SID]
		end
		return Data
	end
	
	function Registry.Player:getDataTable()
		return _V.PlayerDataLib.getDataTable(self:UniqueID())
	end

else
	
	function _V.PlayerDataLib.getDataTable()
		return _V.PlayerDataLib.PlayerData
	end
	
	function Registry.Player:getDataTable()
		return _V.PlayerDataLib.getDataTable()
	end
	
	net.Receive("PlayerData-Update", function(Length, Client)
		local NewData = net.ReadTable()
		if NewData then
			_V.PlayerDataLib.PlayerData = NewData
		end
	end)
	
end

function _V.PlayerDataLib.PlayerFromSID(String)
	for a, b in pairs(player.GetAll()) do
		if b:SteamID() == String then
			return b
		end
	end
end

function _V.PlayerDataLib.getPlayerData(SID, Key)
	local Data = _V.PlayerDataLib.getDataTable(SID)
	return Data[Key]
end

function Registry.Player:getPlayerData(Key)
	return _V.PlayerDataLib.getPlayerData(self:UniqueID(), Key)
end