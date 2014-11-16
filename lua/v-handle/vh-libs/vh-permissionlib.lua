VH_PermissionLib = {}

local Registry = debug.getregistry()

function VH_PermissionLib.getPermissions(Container)
	return VH_DataLib.getData(Container, "Permissions")
end

function VH_PermissionLib.hasPermission(Container, Key)
	local Perms = V.PermissionLib.getPermissions(Container)
	return Perms[Key] == true
end

function Registry.Player:hasPermission(Key)
	return VH_PermissionLib.hasPermission(self:SteamID(), Key)
end

if SERVER then
	
	function VH_PermissionLib.setPermission(Container, Key, State)
		local Perms = VH_PermissionLib.getPermissions(Container)
		Perms[Key] = State
		VH_DataLib.setData(Container, "Permissions", Perms)
	end

	function Registry.Player:setPermission(Key, State)
		VH_PermissionLib.setPermission(self:SteamID(), Key, State)
	end
	
end