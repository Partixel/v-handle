local Module = {}
Module.Name = "Kick"
Module.Description = "Kick a player"
Module.Commands = {}
Module.Commands.Kick = {
	Aliases = {},
	Prefix = "!",
	Description = Module.Description,
	Usage = "<Player> <Reason>",
	Permission = "Kick",
	MinArgs = 2
}

function Module.Commands.Kick.Run(Player, Args, Alias, RankID, Perm)
	local Players = vh.FindPlayers({Args[1]})
	if (not Players or #Players == 0) then
		vh.ChatUtil.SendMessage("nplr", Player)
		return
	end
	
	local Nick = "Console"
	if Player:IsValid() then
		Nick = Player:Nick()
	end
	
	for _, ply in ipairs(Players) do
		ply:Kick(table.concat(Args, " ", 2))
	end
	
	vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has kicked _reset_ " .. vh.CreatePlayerList(Players) .. " _white_ because _red_ " .. table.concat(Args, " ", 2))
	return
end

function Module.Commands.Kick.Vars(ArgNumber)
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