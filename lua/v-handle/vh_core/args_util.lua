vh.ArgsUtil = {}

function vh.ArgsUtil.GetPlayer(Arg)
	if type(Arg) != "string" then
		return
	end
	if string.match(Arg, "STEAM_[0-5]:[0-9]:[0-9]+") then
		return Arg
	elseif Arg == "*" then
		local Found = {}
		for a, b in ipairs(player.GetAll()) do
			table.insert(Found, player:SteamID())
		end
		return Found
	elseif Arg == "@" then
		local Found = {}
		for a, b in ipairs(player.GetAll()) do
			if b:IsAdmin() then
				table.insert(Found, b:SteamID())
			end
		end
		return Found
	elseif Arg == "!@" then
		local Found = {}
		for a, b in ipairs(player.GetAll()) do
			if !b:IsAdmin() then
				table.insert(Found, b:SteamID())
			end
		end
		return Found
	elseif string.Left(Arg, 1) == "/" and string.Right(Arg, 1) == "/" then
		local Players = string.Explode(",", string.sub(Arg, 2, #Arg - 1))
		local Found = {}

		for a, b in ipairs(Players) do
			local Player = vh.ArgsUtil.GetPlayer(b)
			if Player then
				for b, c in ipairs(Player) do
					if !table.HasValue(Found, c) then
						table.insert(Found, c)
					end
				end
			end
		end
		return Found
	else
		local Found = {}
		for a, b in ipairs(player.GetAll()) do
			if string.lower(b:Nick()) == string.lower(Arg) then
				return {b:SteamID()}
			elseif string.sub(string.lower(b:Nick()), 1, string.len(Arg)) == string.lower(Arg) then
				table.insert(Found, b:SteamID())
			end
		end
		return Found
	end
end

function vh.ArgsUtil.PlayerFromSID(SID)
	for a, b in ipairs(player.GetAll()) do
		if b:SteamID() == SID then
			return b
		end
	end
end

function vh.ArgsUtil.SIDToUID(SID)
	return util.CRC("gm_" .. SID .. "_gm")
end

function vh.ArgsUtil.FormatList(List)
	for a, b in ipairs(List) do
		if a == #List - 1 then
			List[a] = b .. " and "
		elseif a != #List then
			List[a] = b .. ", "
		end
	end
	return List
end

function vh.ArgsUtil.PlayersToString(Players)
	if #Players == 1 then
		local Player = vh.ArgsUtil.PlayerFromSID(Players[1])
		if Player then
			return Player:Nick()
		end
		return Players[1]
	elseif #Players > 1 then
		local Names = {}
		for a, b in ipairs(Players) do
			local Player = vh.ArgsUtil.PlayerFromSID(b)
			if Player then
				table.insert(Names, Player:Nick())
			else
				table.insert(Names, b)
			end
		end
		return table.concat(vh.ArgsUtil.FormatList(Names))
	end
	return ""
end
