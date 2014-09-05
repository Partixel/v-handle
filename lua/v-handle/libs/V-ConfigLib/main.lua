_V = _V or {}

_V.ConfigLib = {}

_V.ConfigLib.ConfigLocation = "_V/Config"
-- The directory the file is located in

file.CreateDir(_V.ConfigLib.ConfigLocation) -- Make sure the directories exist

_V.ConfigLib.Containers = {}
-- A table containing a cache of the configs to save on file I/O

function _V.ConfigLib.ReadConfig(Location)
	-- Reads the config from file and formats it correctly
	local Data = file.Read(_V.ConfigLib.ConfigLocation .. "/" .. Location .. ".txt", "DATA")
	if Data and Data != "" then
		return von.deserialize(util.Decompress(Data))
	end
end

function _V.ConfigLib.WriteConfig(Location, Data)
	-- Writes the config to file and formats it correctly
	file.Write(_V.ConfigLib.ConfigLocation .. "/" .. Location .. ".txt", util.Compress(von.serialize(Data)))
end

function _V.ConfigLib.Get(Key, ConKey, Default)
	-- Returns the value of the key (KEY) within the specificied config (CONKEY)
	-- If value or config file is not found it returns default and saves file
	local Container = _V.ConfigLib.Containers[ConKey]
	if Container != nil then -- Check if the config is cached
		if Container[Key] then
			if type(Container[Key]) != type(Default) then
				-- Make sure the data is valid
				Container[Key] = Default
			end
			return Container[Key]
		else
			local Data = _V.ConfigLib.ReadConfig(ConKey)
			if Data[Key] and type(Data[Key]) == type(Default) then
				-- Make sure the data is valid
				Container[Key] = Data[Key]
				return Container[Key]
			else
				Container[Key] = Default
				_V.ConfigLib.WriteConfig(ConKey, Container)
				-- Save the corrected value
				return Default
			end
		end
	else
		local Data = _V.ConfigLib.ReadConfig(ConKey)
		if Data then
			_V.ConfigLib.Containers[ConKey] = Data
			return _V.ConfigLib.Get(Key, ConKey, Default)
			-- Runs the function again to save on repetitive code
		else
			Container = {} -- Creates the config file with default value
			_V.ConfigLib.Containers[ConKey] = Container
			_V.ConfigLib.WriteConfig(ConKey, Container) -- Saves the file
			return Default
		end
	end
end