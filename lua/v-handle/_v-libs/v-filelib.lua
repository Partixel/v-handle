_V = _V or {}

_V.FileLib = {}

_V.FileLib.Side = {
	Client = 0,
	Server = 1,
	Shared = 2
}

_V.FileLib.Loaded = {"_v-libs/v-filelib.lua"}

function _V.FileLib.IncludeFile(Location, Side)
	local File = file.Find(Location, "LUA")
	if File then
		if table.HasValue(_V.FileLib.Loaded, Location) then
			return
		end
		
		if Side == _V.FileLib.Side.Client then
			if SERVER then
				AddCSLuaFile(Location)
			else
				table.insert(_V.FileLib.Loaded, Location)
				include(Location)
			end
		elseif Side == _V.FileLib.Side.Server then
			if SERVER then
				table.insert(_V.FileLib.Loaded, Location)
				include(Location)
			end
		elseif Side == _V.FileLib.Side.Shared then
			if SERVER then
				table.insert(_V.FileLib.Loaded, Location)
				AddCSLuaFile(Location)
				include(Location)
			else
				table.insert(_V.FileLib.Loaded, Location)
				include(Location)
			end
		else
			print("_V-LogLib - Invalid side for file " .. Location)
		end
	else
		print("_V-LogLib - File not found: " .. Location)
	end
end

function _V.FileLib.IncludeDir(Dir)
	local Files, Dirs = file.Find("v-handle/" .. Dir .. "/*", "LUA")

	for a, b in ipairs(Files) do
		if string.lower(string.Right(b, 4)) == ".lua" then
			if string.lower(string.Left(b, 3)) == "cl_" then
				_V.FileLib.IncludeFile(Dir .. "/" .. b, _V.FileLib.Side.Client)
			elseif string.lower(string.Left(b, 3)) == "sv_" then
				_V.FileLib.IncludeFile(Dir .. "/" .. b, _V.FileLib.Side.Server)
			else
				_V.FileLib.IncludeFile(Dir .. "/" .. b, _V.FileLib.Side.Shared)
			end
		end
	end

	for a, b in ipairs(Dirs) do
		_V.FileLib.IncludeDir(Dir .. "/" .. b)
	end
end

function _V.FileLib.AddResourceDir(Dir)
	local Files, Dirs = file.Find("v-handle/" .. Dir .. "/*", "LUA")

	for a, b in ipairs(Files) do
		resource.AddFile(Dir .. "/" .. b)
	end

	for a, b in ipairs(Dirs) do
		_V.FileLib.AddResourceDir(Dir .. "/" .. b)
	end
end