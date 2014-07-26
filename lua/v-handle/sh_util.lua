function vh.Include(fileName)
	if (fileName:find("sv_") and SERVER) then
		include(fileName)
	elseif (fileName:find("cl_")) then
		if (SERVER) then
			AddCSLuaFile(fileName)
		else
			include(fileName)
		end
	else
		if (SERVER) then
			AddCSLuaFile(fileName)
		end

		include(fileName)
	end
end

function vh.IncludeFolder(folder)
	for k, v in pairs(file.Find("v-handle/"..folder.."/*.lua", "LUA")) do
		vh.Include(folder.."/"..v)
	end
end

vh.IncludeFolder("vh_core/external")

function vh.StringMatches(a, b)
	return a:lower() == b:lower() or a:lower():find(b:lower())
end

function vh.FindPlayerByName(name, onlyTableReturns, limit)
	local found = {}
	local i = 0

	for k, v in pairs(player.GetAll()) do
		if (limit and i > limit) then
			break
		end

		if (vh.StringMatches(v:Name(), name)) then
			found[#found + 1] = v
			i = i + 1
		end
	end

	if (!onlyTableReturns and #found == 1) then
		return found[1]
	elseif (#found > 0) then
		return found
	end
end

function vh.FindPlayers(names, client)
	local found = {}

	if ( (type(names) != "string") and (type(names) != "table") ) then return end

	if ( type(names) == "string" ) then
		names = { names }
	end

	if ( #names == 0 ) then
		found[1] = client
	else
		for _, player1 in pairs( player.GetAll() ) do
			for _, player2 in ipairs( names ) do
				if ( vh.IsNameMatch(player1, player2) and !table.HasValue( found, player1 ) ) then
					table.insert(found, player1)
				end
			end
		end
	end

	return found
end

function vh.IsNameMatch( ply, str )
	if (type(str) != "string") then return end
	if ( str == "*" ) then
		return true
	elseif ( str == "@" and ply:IsAdmin() ) then
		return true
	elseif ( str == "!@" and !ply:IsAdmin() ) then
		return true
	elseif ( string.match( str, "STEAM_[0-5]:[0-9]:[0-9]+" ) ) then
		return ply:SteamID() == str
	elseif ( string.Left( str, 1 ) == "\"" and string.Right( str, 1 ) == "\"" ) then
		return ( ply:Nick() == string.sub( str, 2, #str - 1 ) )
	else
		return ( string.lower( ply:Nick() ) == string.lower( str ) or string.find( string.lower( ply:Nick() ), string.lower( str ), nil, true ) )
	end
end

function vh.CreatePlayerList( tbl, notall )
	local lst = ""
	local lword = "and"
	if ( notall ) then
		lword = "or"
	end

	if ( #tbl == 1 ) then
		lst = tbl[1]:Nick()
	elseif ( #tbl == #player.GetAll() ) then
		lst = "everyone"
	else
		for i = 1, #tbl do
			if ( i == #tbl ) then
				lst = lst .. " " .. lword .. " " .. tbl[i]:Nick()
			elseif ( i == 1 ) then
				lst = tbl[i]:Nick()
			else
				lst = lst .. ", " .. tbl[i]:Nick()
			end
		end
	end
	return lst
end

function vh.TableToList(info, word, hasNoTarget)
	word = word or "and"

	local output = {}
	local index = 1
	local maximum = table.Count(info)

	if (maximum == 0 and !hasNoTarget) then
		output[#output + 1] = color_white
		output[#output + 1] = "no one"

		return output
	end

	if (maximum > 1 and maximum == #player.GetAll()) then
		output[#output + 1] = color_white
		output[#output + 1] = "everyone"

		return output
	end

	if (maximum > 0) then
		for k, v in pairs(info) do
			local isLast = index == maximum

			if (isLast and maximum > 1) then
				output[#output + 1] = color_white
				output[#output + 1] = word.." "
			end

			if (v == LocalPlayer()) then
				output[#output + 1]	= team.GetColor(v:Team())
				output[#output + 1] = "you"
			else
				output[#output + 1] = v
			end

			if (!isLast) then
				if (table.Count(info) > 2) then
					output[#output + 1] = color_white
					output[#output + 1] = ", "
				else
					output[#output + 1] = " "
				end
			end

			index = index + 1
		end
	end

	output[#output + 1] = color_white

	return output
end

function vh.SplitStringByLength(value, length)
	local output = {}

	while (#value > length) do
		output[#output + 1] = value:sub(1, length)
		value = value:sub(length + 1)
	end

	if (value != "") then
		output[#output + 1] = value
	end

	return output
end

vh.data = vh.data or {}

function vh.SetData(key, value, noSave)
	vh.data[key] = value

	if (!noSave) then
		file.CreateDir("v-handle")
		file.Write("v-handle/"..key..".txt", util.Compress(von.serialize(vh.data)))
	end
end

function vh.GetData(key, default, noCache)
	if (noCache or vh.data[key] == nil) then
		local contents = file.Read("v-handle/"..key..".txt", "DATA")

		if (contents and contents != "") then
			local deserialized = von.deserialize(util.Decompress(contents))

			if (deserialized[key] != nil) then
				vh.data[key] = deserialized[key]

				return deserialized[key]
			end
		end
	elseif (vh.data[key] != nil) then
		return vh.data[key]
	end

	return default
end
