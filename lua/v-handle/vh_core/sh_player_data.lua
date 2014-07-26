
vh.PlayerData = vh.GetData("PlayerData") or {}

Registry = debug.getregistry()

if SERVER then
	util.AddNetworkString("VH_PlayerData")
	
	timer.Simple( 1, function()
		for a, b in pairs(vh.PlayerData) do
			net.Start("VH_PlayerData")
				net.WriteString(a)
				net.WriteString(von.serialize(b))
			net.Send(Plr)
		end
	end)
	
	function vh.SetPlayerData(UID, Key, Value)
		local Data = vh.PlayerData[tostring(UID)]
		if Data then
			vh.PlayerData[tostring(UID)][Key] = Value
		else
			vh.PlayerData[tostring(UID)] = {Key = Value}
		end
		if vh.PlayerData[tostring(UID)] == {} then
			vh.PlayerData[tostring(UID)] = nil
		end
		vh.SetData("PlayerData", vh.PlayerData)
		net.Start("VH_PlayerData")
			net.WriteString(tostring(UID))
			net.WriteString(von.serialize(vh.PlayerData[tostring(UID)]))
		net.Broadcast()
	end
	
	function Registry.Player:VH_SetPlayerData(Key, Value)
		vh.SetPlayerData(self:UniqueID, Key, Value)
	end
end

function vh.PlayerHasData(UID, Key)
	return vh.GetPlayerData(UID, Key) != nil
end

function vh.GetPlayerData(UID, Key)
	local Data = vh.PlayerData[tostring(UID)]
	if Data != nil then
		return vh.PlayerData[tostring(UID)][Key]
	end
	return nil
end

function Registry.Player:VH_GetPlayerData(Key)
	vh.GetPlayerData(self:UniqueID, Key)
end

hook.Add("PlayerSpawn", "VH_PlayerData", function( Plr )
	if !Plr.FirstSpawn then
		Plr.FirstSpawn = true
		
		for a, b in pairs(vh.PlayerData) do
			net.Start("VH_PlayerData")
				net.WriteString(a)
				net.WriteString(von.serialize(b))
			net.Send(Plr)
		end
	end
end)

net.Receive( "VH_PlayerData", function( Length )
	local UID = net.ReadString()
	local Data = von.deserialize(net.ReadString())
	vh.PlayerData[UID] = Data
end)
