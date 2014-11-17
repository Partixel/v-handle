VH_DataLib = {}

VH_DataLib.DataLocation = "v-handle"
-- The directory the file is located in

file.CreateDir(VH_DataLib.DataLocation) -- Make sure the directories exist

Registry = debug.getregistry()

VH_DataLib.DataTable = {}

if SERVER then
	
	util.AddNetworkString("VH-DataLib-Update")
	
	hook.Add("PlayerInitialSpawn", "VH-DataLib-Initial", function(Player)
		VH_DataLib.sendData(Player:SteamID())
	end)
	
	function VH_DataLib.loadData()
		local Data = file.Read(VH_DataLib.DataLocation .. "/VH-DataLib.txt")
		if Data and Data != "" then
			RunStringEx(Data, "VH_DataLib")
		end
	end
	
	function VH_DataLib.saveData()
		for a, b in pairs(VH_DataLib.DataTable) do
			if b == {} then
				VH_DataLib.DataTable[a] = nil
			end
		end
		local DataString = ""
		for a, b in pairs(VH_DataLib.DataTable) do
			DataString = DataString .. table.ToString(b, "VH_DataLib.DataTable['" .. a .. "']", true) .. "\n"
		end
		file.Write(VH_DataLib.DataLocation .. "/VH-DataLib.txt", DataString)
	end
	
	-- If the data belongs to a player, send it to them for use client-side
	function VH_DataLib.sendData(Container)
		local Player = VH_DataLib.PlayerFromSID(Container)
		if Player then
			local Data = VH_DataLib.getDataTable(Player:SteamID())
			net.Start("VH-DataLib-Update")
				net.WriteTable(Data)
			net.Send(Player)
		end
	end
	
	function VH_DataLib.setData(Container, Key, Value)
		local Data = VH_DataLib.getDataTable(Container)
		Data[Key] = Value
		VH_DataLib.saveData()
		VH_DataLib.sendData(Container)
	end

	function Registry.Player:setPlayerData(Key, Value)
		local Data = VH_DataLib.setData(self:SteamID(), Key, Value)
	end
	
	-- Server stores all data
	function VH_DataLib.getDataTable(Container)
		local Data = VH_DataLib.DataTable[Container]
		if Data == nil then
			VH_DataLib.DataTable[Container] = {}
			Data = VH_DataLib.DataTable[Container]
		end
		return Data
	end
	
	VH_DataLib.loadData()
	
else
	
	-- Client only stores data related to the client
	function VH_DataLib.getDataTable(Container)
		return VH_DataLib.DataTable or {}
	end
	
	net.Receive("VH-DataLib-Update", function(Length, Client)
		local NewData = net.ReadTable()
		if NewData then
			VH_DataLib.DataTable = NewData
		end
	end)
	
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