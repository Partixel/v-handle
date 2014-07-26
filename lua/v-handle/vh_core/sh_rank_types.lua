DefaultRankTypes = {
	{
		Name = "User",
		UserGroup = "user",
		Inherits = 0,
		Target = {1},
		Permissions = {
			
		}
	},
	{
		Name = "Moderator",
		UserGroup = "user",
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
		Inherits = 2,
		Target = {1, 2, 3},
		Permissions = {
			TestPerm = {Value = false, Target = {1}}
		}
	},
	{
		Name = "Super Admin",
		UserGroup = "superadmin",
		Inherits = 2,
		Target = {1, 2, 3},
		Permissions = {
			TestPerm = {Value = false, Target = {1}},
			SetRank = {Value = true, Target = {1, 2, 3, 4}}
		}
	}
}

vh.RankTypes =  {}
vh.RankTypeUtil = {}

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
			table.insert(vh.RankTypes, NewRank)
		end
		vh.RankTypeUtil.Save()
	end

	function vh.RankTypeUtil.SetPerm( ID, PermName, Perm )
		local Rank = vh.RankTypeUtil.FromID( ID )
		if Rank then
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
		if Rank and ID != 1 then
			Rank.Inherits = InheritID
		end
		vh.RankTypeUtil.Save()
	end

	function vh.RankTypeUtil.Remove( ID )
		local Rank = vh.RankTypeUtil.FromID( ID )
		if Rank and ID != 1 then
			vh.RankTypes[ ID ] = nil
			local Users = vh.RankTypeUtil.GetUsers( ID )
			for a, b in pairs(Users) do
				vh.SetRank(b, 1)
			end
		end
		vh.RankTypeUtil.Save()
	end

	function vh.RankTypeUtil.UserGroup( ID, NewGroup )
		local Rank = vh.RankTypeUtil.FromID( ID )
		if Rank and table.HasValue({"user", "admin", "superadmin"}, string.lower(NewGroup)) then
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

end

function vh.RankTypeUtil.CanTarget( Perm, ID, TargetID)
	if ID == 0 then return true end
	if Perm != nil and Perm.Target != nil then
		return table.HasValue(Perm.Target, TargetID)
	else
		local Rank = vh.RankTypeUtil.FromID( ID )
		return table.HasValue(Rank.Target, TargetID)
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
	if ID == 0 then return {Value = true, Target = {0}} end
	local Perms = vh.RankTypeUtil.GetFullPermissions(ID)
	for a, b in pairs(Perms) do
		if string.lower(a) == string.lower(PermName) then
			return b
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
			return a
		end
	end
	return nil
end

function vh.RankTypeUtil.FromID( ID )
	return vh.RankTypes[ ID ]
end

function vh.RankTypeUtil.FromName( Name )
	for a, b in pairs( vh.RankTypes ) do
		if string.lower( Name ) == string.lower( b.Name ) then
			return b
		end
	end
	return nil
end

hook.Add("PlayerSpawn", "VH_RankTypes", function( Plr )
	if !Plr.AFirstSpawn then
		Plr.AFirstSpawn = true

		net.Start("VH_RankTypes")
			net.WriteString(von.serialize(vh.RankTypes))
		net.Send(Plr)
	end
end)

net.Receive( "VH_RankTypes", function( Length )
	local Types = von.deserialize(net.ReadString())
	vh.RankTypes = Types
end)