_V = _V or {}

_V.DataLib = {}

_V.DataLib.DataLocation = "_V"
-- The directory the file is located in

file.CreateDir(_V.DataLib.DataLocation) -- Make sure the directories exist

Registry = debug.getregistry()

_V.DataLib.DataTable = {}

if SERVER then
	
	util.AddNetworkString("DataLib-Update")
	
	hook.Add("PlayerInitialSpawn", "_V-DataLib-Initial", function(Player)
		_V.DataLib.sendData(Player:SteamID())
	end)
	
	function _V.DataLib.loadData()
		local Data = file.Read(_V.DataLib.DataLocation .. "/V-DataLib.txt")
		if Data and Data != "" then
			_V.DataLib.DataTable = von.deserialize(util.Decompress(Data))
		end
	end
	
	function _V.DataLib.saveData()
		for a, b in pairs(_V.DataLib.DataTable) do
			if b == {} then
				_V.DataLib.DataTable[a] = nil
			end
		end
		file.Write(_V.DataLib.DataLocation .. "/V-DataLib.txt", util.Compress(von.serialize(_V.DataLib.DataTable)))
	end
	
	-- If the data belongs to a player, send it to them for use client-side
	function _V.DataLib.sendData(Container)
		local Player = _V.DataLib.PlayerFromSID(Container)
		if Player then
			local Data = _V.DataLib.getDataTable(Player:SteamID())
			net.Start("_V-DataLib-Update")
				net.WriteTable(Data)
			net.Send(Player)
		end
	end
	
	function _V.DataLib.setData(Container, Key, Value)
		local Data = _V.DataLib.getDataTable(Container)
		Data[Key] = Value
		_V.DataLib.saveData()
		_V.DataLib.sendData(Container)
	end

	function Registry.Player:setPlayerData(Key, Value)
		local Data = _V.DataLib.setData(self:SteamID(), Key, Value)
	end
	
	-- Server stores all data
	function _V.DataLib.getDataTable(Container)
		local Data = _V.DataLib.DataTable[Container]
		if Data == nil then
			_V.DataLib.DataTable[Container] = {}
			Data = _V.DataLib.DataTable[Container]
		end
		return Data
	end
	
	_V.DataLib.loadData()
	
else
	
	-- Client only stores data related to the client
	function _V.DataLib.getDataTable(Container)
		return _V.DataLib.DataTable or {}
	end
	
	net.Receive("_V-DataLib-Update", function(Length, Client)
		local NewData = net.ReadTable()
		if NewData then
			_V.DataLib.DataTable = NewData
		end
	end)
	
end

function _V.DataLib.PlayerFromSID(String)
	for a, b in pairs(player.GetAll()) do
		if b:SteamID() == String then
			return b
		end
	end
end

function _V.DataLib.getData(Container, Key)
	local Data = _V.DataLib.getDataTable(Container)
	return Data[Key]
end

function Registry.Player:getPlayerData(Key)
	return _V.DataLib.getData(self:SteamID(), Key)
end