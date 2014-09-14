local Module = {}
Module.Name = "Slay"
Module.Description = "Slay a player"
Module.Commands = {}
Module.Commands.Slay = {
	Aliases = {"kill"},
	Prefix = "!",
	Description = Module.Description,
	Usage = "<Player>",
	Permission = "Slay",
	Arguments = {"Player"}
}

function Module.Commands.Slay.Run(Player, Args, Alias, RankID, Perm)
	local Players = vh.ArgsUtil.GetPlayer(Args[1])
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
			table.insert(Complete, b)
		else
			table.insert(Invalid, b)
		end
	end
	
	for _, ply in ipairs(Complete) do
		ply:Kill()
	end
	
	vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has slain cloak on _reset_ " .. vh.ArgsUtil.PlayersToString(Complete))
	if #Invalid > 0 then
		vh.ChatUtil.SendMessage("_lime_ You _white_ cannot target _reset_ " .. vh.ArgsUtil.PlayersToString(Complete), Player)
	end
	return
end
--[[
function Module.Commands.Slay.Run(Player, Players, Args, Alias, RankID, Perm)
	local Nick = "Console"
	if Player:IsValid() then
		Nick = Player:Nick()
	end
	
	for _, ply in ipairs(Players) do
		ply:Kill()
	end
	
	vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has slain cloak on _reset_ " .. vh.ArgsUtil.PlayersToString(Complete))
	return
end
]]
function Module.Commands.Slay.Vars(ArgNumber)
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