
Registry = debug.getregistry()

if SERVER then
	function vh.SetRank(UID, ID)
		if vh.RankTypeUtil.FromID(ID) == nil then return end
		
		-- Compatability
		local Plr = player.GetByUniqueID(UID)
		if Plr then
			Plr:SetNWString("usergroup", vh.RankTypeUtil.FromID(ID).Name)
		end

		if ID == 1 then
			vh.SetPlayerData(UID, "VH_Rank", nil)
		elseif vh.RankTypeUtil.FromID(ID) then
			vh.SetPlayerData(UID, "VH_Rank", ID)
		end
	end
	
	function Registry.Player:VH_SetRank(ID)
		self:SetNWString("usergroup", vh.RankTypeUtil.FromID(ID).Name)
		return vh.SetRank(self:UniqueID(), ID)
	end
end

function vh.GetRank(UID)
	local ID = vh.GetPlayerData(UID, "VH_Rank") or 1
	return vh.RankTypeUtil.FromID(ID)
end

function Registry.Player:VH_GetRank()
	return vh.GetRank(self:UniqueID())
end

-- Compatibility --
function Registry.Player:EV_GetRank()
	return vh.GetRank(self:UniqueID()).Name
end

function Registry.Player:GetUserGroup()
	return string.lower(vh.GetRank(self:UniqueID()).UserGroup)
end

function Registry.Player:IsUserGroup(Name)
	return self:GetUserGroup() == string.lower(Name)
end