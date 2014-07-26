
Registry = debug.getregistry()

if SERVER then
	function vh.SetRank(UID, ID)
		if ID == 1 then
			vh.SetPlayerData(UID, "VH_Rank", nil)
		elseif vh.RankTypeUtil.FromID(ID) then
			vh.SetPlayerData(UID, "VH_Rank", ID)
		else
			vh.ConsoleMessage("Invalid rank ID")
		end
	end
	
	function Registry.Player:VH_SetRank(ID)
		return vh.SetRank(self:UniqueID(), ID)
	end
end

function vh.GetRank(UID)
	local ID = vh.GetPlayerData(UID, "VH_Rank") or 1
	return vh.RankTypeUtil.FromID(ID).Name
end

function vh.GetRankObject(UID)
	local ID = vh.GetPlayerData(UID, "VH_Rank") or 1
	return vh.RankTypeUtil.FromID(ID)
end

function Registry.Player:VH_GetRank()
	return vh.GetRank(self:UniqueID())
end

function Registry.Player:VH_GetRankObject()
	return vh.GetRankObject(self:UniqueID())
end

-- Compatibility --
function Registry.Player:EV_GetRank()
	return vh.GetRank(self:UniqueID())
end

function Registry.Player:GetUserGroup()
	return string.lower(vh.GetRankObject(self:UniqueID()).UserGroup)
end

function Registry.Player:IsUserGroup(Name)
	return self:GetUserGroup() == string.lower(Name)
end