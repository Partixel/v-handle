DefaultRankTypes = {
	"0" = {
		Name = "User",
		Removable = false,
		Inherits = "-1",
		Target = {"0"},
		Permissions = {
			
		}
	},
	"1" = {
		Name = "Moderator",
		Removable = true,
		Inherits = "0",
		Target = {"0", "1"},
		Permissions = {
			
		}
	},
	"2" = {
		Name = "Admin",
		Removable = true,
		Inherits = "1",
		Target = {"0", "1", "2"},
		Permissions = {
			TestPerm = {Value = true, Target = {"0"}}
		}
	}
}


vh.RankTypes = vh.GetData("RankTypes") or DefaultRankTypes

function vh.RankTypes.CanTarget( Perm, ID, TargetID)
  if Perm != nil and Perm.Target != nil and table.HasValue(Perm.Target, tostring(TargetID)) then
    return true
  else
    local Rank = vh.Ranks.FromID( ID )
    return table.HasValue(Rank.Target, TargetID)
  end
end

function vh.RankTypes.Rename( ID, NewName )
	local Rank = vh.RankTypes.FromID( ID )
	if Rank then
		Rank.Name = NewName
	end
end

function vh.RankTypes.IsInheritted( ID, Perm )
	local Rank = vh.RankTypes.FromID( ID )
	if Rank then
		return Rank.Permissions[ Perm ] == nil
	end
	return nil
end

function vh.RankTypes.GetDirectPermissions( ID )
	local Rank = vh.RankTypes.FromID( ID )
	if Rank then
		return Rank.Permissions
	end
	return nil
end

function vh.RankTypes.GetFullPermissions( ID )
	local Rank = vh.RankTypes.FromID( ID )
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
				ChildRank = vh.RankTypes[ ChildRank.Inherits ]
			until ChildRank == nil
		end
		return Perms
	end
	return nil
end

function vh.RankTypes.GetID( Name )
	for a, b in pairs( vh.RankTypes ) do
		if string.lower( Name ) == string.lower( b.Name ) then
			return tostring( a )
		end
	end
	return nil
end

function vh.RankTypes.FromID( ID )
	return vh.RankTypes[ ID ]
end

function vh.RankTypes.FromName( Name )
	for a, b in pairs( vh.RankTypes ) do
		if string.lower( Name ) == string.lower( b.Name ) then
			return b
		end
	end
	return nil
end
