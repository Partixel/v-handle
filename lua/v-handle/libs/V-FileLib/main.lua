_V.FileLib = {}

_V.FileLib.Side = {
	Client = 0,
	Server = 1,
	Shared = 2
}

function _V.FileLib.IncludeFile(Location, Side)
	local File = file.Find(Location)
	if File then
		if Side == _V.FileLib.Side.Client then
			if SERVER then
				AddCSLuaFile(Location)
			else
				include(Location)
			end
		elseif Side == _V.FileLib.Side.Server then
			if SERVER then
				include(Location)
			end
		elseif Side == _V.FileLib.Side.Shared then
			if SERVER then
				AddCSLuaFile(Location)
				include(Location)
			else
				include(Location)
			end
		else
			_V.FileLib.Logger("Invalid side for file " .. Location, _V.LogLib.Type.Error)
		end
	else
		_V.FileLib.Logger("File not found: " .. Location, _V.LogLib.Type.Error)
	end
end

function _V.FileLib.IncludeDir(Dir)
	local Files, Dirs = file.Find("v-handle/" .. Dir .. "/*", "LUA")

	for a, b in ipairs(Files) do
		if string.lower(string.Right(b, 4)) == ".lua" then
			if string.lower(string.Left(b, 3)) == "cl_" then
				vh.IncludeFile(Name .. "/" .. b, _V.FileLib.Side.Client)
			elseif string.lower(string.Left(b, 3)) == "sv_" then
				vh.IncludeFile(Name .. "/" .. b, _V.FileLib.Side.Server)
			else
				vh.IncludeFile(Name .. "/" .. b, _V.FileLib.Side.Shared)
			end
		end
	end

	for a, b in ipairs(Dirs) do
		vh.IncludeFolder(Name .. "/" .. b)
	end
end

function _V.FileLib.Logger(Message, Type)
	if _V.LogLib then
		_V.LogLib.Log(Message, Type)
	else
		print("Log lib missing - " .. Message)
	end
end
