VH_DataLib = {}

VH_DataLib.DataLocation = "v-handle"
-- The directory the file is located in

file.CreateDir(VH_DataLib.DataLocation) -- Make sure the directories exist

Registry = debug.getregistry()

VH_DataLib.DataTable = {}

function VH_DataLib.toString()
	local DataString = ""
	for a, b in pairs(VH_DataLib.DataTable) do
		if b == nil or #b == 0 then continue end
		DataString = DataString .. table.ToString(b, "VH_DataLib.DataTable['" .. a .. "']", true) .. "\n"
	end
	return DataString
end

function VH_DataLib.fromString(String)
	RunStringEx(String, "VH-DataLib")
end

if SERVER then
	
	util.AddNetworkString("VH-DataLib-Update")
	util.AddNetworkString("VH-DataLib-Initial")
	
	VH_HookLib.addHook("PlayerInitialSpawn", "VH-DataLib-Initial", function(Plr)
		net.Start("VH-DataLib-Initial")
			net.WriteString(util.Compress(VH_DataLib.toString()))
		net.Send(Plr)
	end)
	
	function VH_DataLib.loadData()
		local Data = file.Read(VH_DataLib.DataLocation .. "/VH-DataLib.txt")
		if Data and Data != "" then
			VH_DataLib.fromString(Data)
		end
	end
	
	function VH_DataLib.saveData()
		file.Write(VH_DataLib.DataLocation .. "/VH-DataLib.txt", VH_DataLib.toString())
	end
	
	-- Will send changed data to clients
	function VH_DataLib.setData(Container, Key, Value)
		VH_DataLib.setServerData(Container, Key, Value)
		local Data = table.ToString({Value})
		Data = string.sub(Data, 2, string.len(Data) - 2)
		if Data == "" then
			Data = "nil"
		end
		net.Start("VH-DataLib-Update")
			net.WriteString(util.Compress(Container))
			net.WriteString(util.Compress(Key))
			net.WriteString(util.Compress("VH_TempData = " .. Data))
		net.Broadcast()
	end
	
	-- Will not send changed data to clients
	function VH_DataLib.setServerData(Container, Key, Value)
		local Data = VH_DataLib.getDataTable(Container)
		Data[Key] = Value
		VH_DataLib.saveData()
	end
	
	function Registry.Player:setServerPlayerData(Key, Value)
		local Data = VH_DataLib.setServerData(self:SteamID(), Key, Value)
	end

	function Registry.Player:setPlayerData(Key, Value)
		local Data = VH_DataLib.setData(self:SteamID(), Key, Value)
	end
	
	VH_DataLib.loadData()
	
else
	
	net.Receive("VH-DataLib-Update", function(Length, Client)
		local Container = util.Decompress(net.ReadString())
		local Key = util.Decompress(net.ReadString())
		local Data = util.Decompress(net.ReadString())
		if Container and Key then
			RunStringEx(Data, "VH-DataLib")
			VH_DataLib.DataTable[Container] = VH_DataLib.DataTable[Container] or {}
			VH_DataLib.DataTable[Container][Key] = VH_TempData
		end
	end)
	
	net.Receive("VH-DataLib-Initial", function(Length, Client)
		local Data = util.Decompress(net.ReadString())
		if Data then
			VH_DataLib.fromString(Data)
		end
	end)
	
end

function VH_DataLib.getDataTable(Container)
	local Data = VH_DataLib.DataTable[Container] or {}
	return Data
end

function VH_DataLib.PlayerFromSID(String)
	for a, b in pairs(player.GetAll()) do
		if b:SteamID() == String then
			return b
		end
	end
end

function VH_DataLib.getData(Container, Key)
	local Data = VH_DataLib.getDataTable(Container)
	return Data[Key]
end

function Registry.Player:getPlayerData(Key)
	return VH_DataLib.getData(self:SteamID(), Key)
end