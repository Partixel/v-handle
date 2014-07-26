local Module = {}
Module.Name = "Rank Commands"
Module.Description = "Contains rank related commands"
Module.PrecacheStrings = {
	nrank = "_red_ That is not a valid rank",
	irank = "_red_ You cannot target that rank"
}
Module.Commands = {}
Module.Commands.SetRank = {
  Aliases = {},
  Prefix = "!",
  Description = "Set a players rank",
  Usage = "<Player> <Rank>",
  Permission = "SetRank",
  MinArgs = 2
}

function Module.Commands.SetRank.Run(Player, Args, Alias, RankID, Perm)
	local Rank = vh.RankTypeUtil.FromName(table.concat(Args, " ", 2))
	if Rank then
		if vh.RankTypeUtil.GetRanking(Rank.UID) >= vh.RankTypeUtil.GetRanking(RankID) then
			vh.ChatUtil.SendMessage("irank", Player)
			return
		end

		local Targets = vh.FindPlayers(Args[1])
		local Complete = {}
		local Invalid = {}
		
		for a, b in pairs(Targets) do
			if vh.RankTypeUtil.CanTarget(Perm, RankID, Rank.UID) then
				b:VH_SetRank(Rank.UID)
				table.insert(Complete, b)
			else
				table.insert(Invalid, b)
			end
		end
		
		if #Complete != 0 then
			local Nick = "Console"
			if Player:IsValid() then
				Nick = Player:Nick()
			end
			local Players = player.GetAll()
			for a, b in pairs(Players) do
				if b:Nick() == Nick then
					table.remove(Players, a)
				end
			end
			vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has set the rank of _reset_ " .. vh.CreatePlayerList(Complete) .. " _white_ to _red_ " .. Rank.Name, Players)
			if Player:IsValid() then
				vh.ChatUtil.SendMessage("_lime_ You _white_ have set the rank of _reset_ " .. vh.CreatePlayerList(Complete) .. " _white_ to _red_ " .. Rank.Name, Player)
			end
			return
		end
		
		if #Invalid != 0 then
			vh.ChatUtil.SendMessage("_lime_ You _white_ cannot set the rank of _reset_ " .. vh.CreatePlayerList(Complete) .. " _white_ to _red_ " .. Rank.Name, Player)
			return
		end
		
		vh.ChatUtil.SendMessage("nplr", Player)
		return
	else
		vh.ChatUtil.SendMessage("nrank", Player)
		return
	end
end

function Module.Commands.SetRank.Vars(ArgNumber)
	if (ArgNumber == 1) then
		local Players = {}
		for a, b in pairs(player.GetAll()) do
			table.insert(Players, b:Nick())
		end
		return Players
	elseif (ArgNumber == 2) then
		local Types = {}
		for a, b in pairs(vh.RankTypes) do
			table.insert(Types, b.Name)
		end
		return Types
	end
	return nil
end

vh.RegisterModule(Module)
