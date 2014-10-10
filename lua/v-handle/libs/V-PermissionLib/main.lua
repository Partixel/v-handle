_V = _V or {}

_V.PermissionLib = {}

_V.PermissionLib.Permissions = {}

local Registry = debug.getregistry()

function _V.PermissionLib.getPermissions(Container)
	return _V.DataLib.getData(Container, "Permissions")
end

function _V.PermissionLib.hasPermission(Container, Key)
	local Perms = V.PermissionLib.getPermissions(Container)
	return Perms[Key] == true
end

function Registry.Player:hasPermission(Key)
	return _V.PermissionLib.hasPermission(self:SteamID(), Key)
end

if SERVER then
	
	function _V.PermissionLib.setPermission(Container, Key, State)
		local Perms = _V.PermissionLib.getPermissions(Container)
		Perms[Key] = State
		_V.DataLib.setData(Container, "Permissions", Perms)
	end

	function Registry.Player:setPermission(Key, State)
		_V.PermissionLib.setPermission(self:SteamID(), Key, State)
	end
	
end