DefaultRankTypes = {
	{
		Name = "User",
		UserGroup = "user",
		UID = 1,
		Inherits = 0,
		Target = {1},
		Permissions = {
			
		}
	},
	{
		Name = "Moderator",
		UserGroup = "user",
		UID = 2,
		Inherits = 1,
		Target = {1, 2},
		Permissions = {
			TestPerm = {Value = true, Target = {1}},
			TestPermB = {Value = true, Target = {1, 2}}
		}
	},
	{
		Name = "Admin",
		UserGroup = "admin",
		UID = 3,
		Inherits = 2,
		Target = {1, 2, 3},
		Permissions = {
			TestPerm = {Value = false, Target = {1}}
		}
	},
	{
		Name = "Super Admin",
		UserGroup = "superadmin",
		UID = 4,
		Inherits = 3,
		Target = {1, 2, 3, 4},
		Permissions = {
			SetRank = {Value = true, Target = {1, 2, 3}}
		}
	},
	{
		Name = "Owner",
		UserGroup = "superadmin",
		UID = 0,
		Inherits = 0,
		Target = {0},
		Permissions = {
			All = {Value = true}
		}
	},
	{
		Name = "Console",
		UserGroup = "superadmin",
		UID = -1,
		Inherits = 0,
		Target = {0},
		Permissions = {
			All = {Value = true}
		}
	}
}

vh.RankTypes =  {}
vh.RankTypeUtil = {}

function vh.RankTypeUtil.CanTarget( Perm, ID, TargetID)
	local Rank = vh.RankTypeUtil.FromID( ID )
	if Rank.UID == -1 then return true end
	if Perm != nil and Perm.Target != nil then
		return table.HasValue(Perm.Target, TargetID) or table.HasValue(Perm.Target, 0)
	else
		return table.HasValue(Rank.Target, TargetID) or table.HasValue(Rank.Target, 0)
	end
end

function vh.RankTypeUtil.GetUsers( ID )
	local Users = {}
	for a, b in pairs(vh.PlayerData) do
		if vh.GetPlayerData(a, "VH_Rank") == ID then
			table.insert(Users, a)
		end
	end
	return Users
end

function vh.RankTypeUtil.HasPermission( ID, PermName )
	if ID == -1 then return {Value = true, Target = {0}} end
	local Perms = vh.RankTypeUtil.GetFullPermissions(ID)
	for a, b in pairs(Perms) do
		if string.lower(a) == string.lower(PermName) or string.lower(a) == "all" then
			return {Value = true}
		end
	end
	return nil
end

function vh.RankTypeUtil.IsInheritted( ID, Perm )
	local Rank = vh.RankTypeUtil.FromID( ID )
	if Rank then
		return Rank.Permissions[ Perm ] == nil
	end
	return nil
end

function vh.RankTypeUtil.GetDirectPermissions( ID )
	local Rank = vh.RankTypeUtil.FromID( ID )
	if Rank then
		return Rank.Permissions
	end
	return nil
end

function vh.RankTypeUtil.GetFullPermissions( ID )
	local Rank = vh.RankTypeUtil.FromID( ID )
	if Rank then
		local Perms = Rank.Permissions
		local ChildRank = vh.RankTypes[ Rank.Inherits ]
		if ChildRank then
			repeat
				for a, b in pairs( ChildRank.Permissions ) do
				  if Perms[a] == nil then
  					Perms[a] = b
  				end
				end
				if vh.RankTypes[ ChildRank.Inherits ] and vh.RankTypes[ ChildRank.Inherits ].Inherits == ChildRank.Inherits then
					ChildRank = nil
				else
					ChildRank = vh.RankTypes[ ChildRank.Inherits ]
				end
			until ChildRank == nil
		end
		return Perms
	end
	return {}
end

function vh.RankTypeUtil.GetID( Name )
	for a, b in pairs( vh.RankTypes ) do
		if string.lower( Name ) == string.lower( b.Name ) then
			return b.UID
		end
	end
	return nil
end

function vh.RankTypeUtil.GetRanking( ID )
	for a, b in pairs( vh.RankTypes ) do
		if b.UID == ID or string.lower(b.Name) == string.lower(ID) then
			return a
		end
	end
	return nil
end

function vh.RankTypeUtil.FromRanking( Ranking )
	return vh.RankTypes[ Ranking ]
end

function vh.RankTypeUtil.FromID( ID )
	for a, b in pairs( vh.RankTypes ) do
		if b.UID == ID then
			return b
		end
	end
	return nil
end

function vh.RankTypeUtil.FromName( Name )
	for a, b in pairs( vh.RankTypes ) do
		if string.lower( Name ) == string.lower( b.Name ) then
			return b
		end
	end
	return nil
end


if SERVER then

	vh.RankTypes = vh.GetData("RankTypes") or {}
	util.AddNetworkString("VH_RankTypes")
	
	function vh.RankTypeUtil.Save()
		vh.SetData("RankTypes", vh.RankTypes)
		net.Start("VH_RankTypes")
			net.WriteString(von.serialize(vh.RankTypes))
		net.Broadcast()
	end

	if #vh.RankTypes == 0 then
		vh.RankTypes = table.Copy(DefaultRankTypes)
	end
		
	timer.Simple(1, function()
		vh.RankTypeUtil.Save()
	end)

	function vh.RankTypeUtil.Add( Name, InheritID )
		local Rank = vh.RankTypeUtil.FromID( InheritID )
		if Rank then
			local NewRank = table.Copy(Rank)
			NewRank.Name = Name
			NewRank.UID = #vh.RankTypes + 1
			table.insert(vh.RankTypes, NewRank, InheritID + 1)
		end
		vh.RankTypeUtil.Save()
	end

	function vh.RankTypeUtil.SetPerm( ID, PermName, Perm )
		local Rank = vh.RankTypeUtil.FromID( ID )
		if Rank and Rank.UID > 1 then
			Rank.Permissions[PermName] = Perm
		end
		vh.RankTypeUtil.Save()
	end

	function vh.RankTypeUtil.SetTarget( ID, TargetID, Targetable )
		local Rank = vh.RankTypeUtil.FromID( ID )
		if Rank then
			table.RemoveByValue(Rank.Target, TargetID)
			if Targetable then
				table.insert(Rank.Target, TargetID)
			end
		end
		vh.RankTypeUtil.Save()
	end

	function vh.RankTypeUtil.Inherits( ID, InheritID )
		local Rank = vh.RankTypeUtil.FromID( ID )
		if Rank and Rank.UID > 1 then
			Rank.Inherits = InheritID
		end
		vh.RankTypeUtil.Save()
	end

	function vh.RankTypeUtil.Remove( ID )
		local Rank = vh.RankTypeUtil.FromID( ID )
		if Rank and Rank.UID > 1 then
			vh.RankTypes[ vh.RankTypeUtil.GetRanking(ID) ] = nil
			local Users = vh.RankTypeUtil.GetUsers( ID )
			for a, b in pairs(Users) do
				vh.SetRank(b, 1)
			end
		end
		vh.RankTypeUtil.Save()
	end

	function vh.RankTypeUtil.UserGroup( ID, NewGroup )
		local Rank = vh.RankTypeUtil.FromID( ID )
		if Rank and Rank.UID > 0 and table.HasValue({"user", "admin", "superadmin"}, string.lower(NewGroup)) then
			Rank.UserGroup = NewGroup
		end
		vh.RankTypeUtil.Save()
	end

	function vh.RankTypeUtil.Rename( ID, NewName )
		local Rank = vh.RankTypeUtil.FromID( ID )
		if Rank then
			Rank.Name = NewName
		end
		vh.RankTypeUtil.Save()
	end

	function vh.RankTypeUtil.SetRanking( ID, NewRank)
		local Rank = vh.RankTypeUtil.FromID( ID )
		if Rank and NewRank > 0 then
			local OldRank = table.Copy(Rank)
			table.remove(vh.RankTypes, vh.RankTypeUtil.GetRanking(ID))
			table.insert(vh.RankTypes, NewRank, OldRank)
		end
		vh.RankTypeUtil.Save()
	end
end

hook.Add("PlayerSpawn", "VH_RankTypes", function( Plr )
	if !Plr.AFirstSpawn then
		Plr.AFirstSpawn = true
		
		timer.Simple(1, function()
			net.Start("VH_RankTypes")
				net.WriteString(von.serialize(vh.RankTypes))
			net.Send(Plr)
		end)
	end
end)

net.Receive( "VH_RankTypes", function( Length )
	local Types = von.deserialize(net.ReadString())
	vh.RankTypes = Types
end)
