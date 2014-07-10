function vm.Include(fileName)
	if (fileName:find("sv_") and SERVER) then
		include(fileName)
	elseif (fileName:find("cl_")) then
		if (SERVER) then
			AddCSLuaFile(fileName)
		else
			include(fileName)
		end
	elseif (fileName:find("sh_")) then
		if (SERVER) then
			AddCSLuaFile(fileName)
		end

		include(fileName)
	end
end

function vm.IncludeFolder(folder)
	for k, v in pairs(file.Find("vm/"..folder.."/*.lua", "LUA")) do
		vm.Include(folder.."/"..v)
	end
end

vm.IncludeFolder("libs/external")

function vm.StringMatches(a, b)
	if (a == b) then return true end
	if (a:find(b, nil, true)) then return true end

	a = a:lower()
	b = b:lower()

	if (a == b) then return true end
	if (a:find(b, nil, true)) then return true end

	return false
end

function vm.FindPlayerByName(name, onlyTableReturns, limit)
	local found = {}
	local i = 0

	for k, v in pairs(player.GetAll()) do
		if (limit and i > limit) then
			break
		end

		if (vm.StringMatches(v:Name(), name)) then
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

function vm.FindPlayers(names, client, strict, nocheck)
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
				if ( vm.IsNameMatch(player1, player2) and !table.HasValue( found, player1 ) ) then
					if ( !nocheck and vm.HasInfluence(client, player2, strict or false) ) then
						table.insert(found, player1)
					end
				end
			end
		end
	end

	return found
end

function vm.IsNameMatch( ply, str )
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

function vm:CreatePlayerList( tbl, notall )
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

function vm.TableToList(info, word, hasNoTarget)
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

function vm.SplitStringByLength(value, length)
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

function vm.ConsoleMessage( Message )
	print("Vector-Moderation -- " .. Message)
end

vm.data = vm.data or {}

function vm.SetData(key, value, noSave)
	vm.data[key] = value

	if (!noSave) then
		file.CreateDir("vm")
		file.Write("vm/"..key..".txt", util.Compress(von.serialize(vm.data)))
	end
end

function vm.GetData(key, default, noCache)
	if (noCache or vm.data[key] == nil) then
		local contents = file.Read("vm/"..key..".txt", "DATA")

		if (contents and contents != "") then
			local deserialized = von.deserialize(util.Decompress(contents))

			if (deserialized[key] != nil) then
				vm.data[key] = deserialized[key]

				return deserialized[key]
			end
		end
	elseif (vm.data[key] != nil) then
		return vm.data[key]
	end

	return default
end
