local Module = {}
Module.Name = "Slay"
Module.Description = "Slay a player"
Module.Commands = {}
Module.Commands.Cloak = {
	Aliases = {},
	Prefix = "!",
	Description = Module.Description,
	Usage = "<Player>",
	Permission = "Slay",
	MinArgs = 1,
	MinPlayers = 1,
	NonPlayerArgs = 0,
}

function Module.Commands.Cloak.Run(Player, Args, Alias, RankID, Perm)
	local Players = vh.FindPlayers(Args, Player)
	if (not Players or #Players == 0) then
		vh.ChatUtil.SendMessage("nplr", Player)
		return
	end
	
	local Nick = "Console"
	if Player:IsValid() then
		Nick = Player:Nick()
	end
	
	local Complete = {}
	local Invalid = {}
	
	for a, b in pairs(Players) do
		if vh.RankTypeUtil.CanTarget(Perm, RankID, b:VH_GetRankObject().UID) then
			b:VH_SetRank(Rank.UID)
			table.insert(Complete, b)
		else
			table.insert(Invalid, b)
		end
	end
	
	for _, ply in ipairs(Players) do
		ply:Kill()
	end
	
	vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has slain cloak on _reset_ " .. vh.CreatePlayerList(Players))
	return
end

function Module.Commands.Cloak.Vars(ArgNumber)
	if (ArgNumber == 1) then
		local playerList = {}
		for _, v in pairs(player.GetAll()) do
			table.insert(playerList, v:Nick())
		end
		return playerList
	end
	return
end

vh.RegisterModule(Module)