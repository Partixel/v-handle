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
	
end

function _V.FileLib.Logger(Message, Type)
	if _V.LogLib then
		_V.LogLib.Log(Message, Type)
	else
		print("Log lib missing - " .. Message)
	end
end
