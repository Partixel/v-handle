local Module = {}
Module.Name = "Rank Commands"
Module.Description = "Contains rank related commands"
Module.PrecacheStrings = {
	_nrank_ = "_red_ That is not a valid rank",
	_irank_ = "_red_ You cannot target that rank"
}
Module.Commands = {}
Module.Commands.SetRank = {
	Aliases = {},
	Prefix = "!",
	Description = "Set a players rank",
	Usage = "<Player> <Rank>",
	Permission = "SetRank",
	Arguments = {"Player", "Rank"}
}

function Module.Commands.SetRank.Run(Player, Args, Alias, RankID, Perm)
	local Rank = vh.RankTypeUtil.FromName(table.concat(Args, " ", 2))
	if Rank then
		if vh.RankTypeUtil.GetRanking(Rank.UID) >= vh.RankTypeUtil.GetRanking(RankID) then
			vh.ChatUtil.SendMessage("_irank_", Player)
			return
		end

		local Targets = vh.ArgsUtil.GetPlayer(Args[1])
		local Complete = {}
		local Invalid = {}
		
		for a, b in pairs(Targets) do
			local TUID = vh.ArgsUtil.SIDToUID(b)
			local TRank = vh.GetRank(TUID)
			if vh.RankTypeUtil.CanTarget(Perm, RankID, TRank.UID) then
				vh.SetRank(TUID, Rank.UID)
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
			vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has set the rank of _reset_ " .. vh.ArgsUtil.PlayersToString(Complete) .. " _white_ to _red_ " .. Rank.Name, nil, true)
			return
		end
		
		if #Invalid != 0 then
			vh.ChatUtil.SendMessage("_lime_ You _white_ cannot set the rank of _reset_ " .. vh.ArgsUtil.PlayersToString(Complete) .. " _white_ to _red_ " .. Rank.Name, Player)
			return
		end
		
		vh.ChatUtil.SendMessage("_nplr_", Player)
		return
	else
		vh.ChatUtil.SendMessage("_nrank_", Player)
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
