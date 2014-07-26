local Module = {}
Module.Name = "Kick"
Module.Description = "Kick a player"
Module.Commands = {}
Module.Commands.Kick = {
  Aliases = {},
  Prefix = "!",
  Description = Module.Description,
  Usage = "<Player> <Reason>"
}

function Module.Commands.Cloak.Run(Player, Args)
	local Players = vh.FindPlayers(Arg, Player)
	if (not Players or #Players == 0) then return "No players found." end
	
	for _, ply in ipairs(Players) do
		ply:Kick()
	end
	
	return "You kicked "..vh:CreatePlayerList(Players) -- Todo proper message
end

function Module.Commands.Cloak.Vars(ArgNumber)
	local playerList = {}
	for _, v in pairs(player.GetAll()) do
		table.insert(playerList, v:Nick())
	end
	if (ArgNumber == 1) then
		return playerList
	end
	return
end

vh.RegisterModule(Module)