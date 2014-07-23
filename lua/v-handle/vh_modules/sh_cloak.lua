local Module = {}
Module.Name = "Cloak"
Module.Description = "Cloak or uncloak a player"
Module.Commands = {}
Module.Commands.Cloak = {
  Aliases = {"uncloak"},
  Prefix = "!",
  Description = Module.Description,
  Usage = "<Player>"
}

function Module.Commands.Cloak.Run(Player, Args)
	vh.ConsoleMessage("Ran cloak, todo.")
	local Players = vh.FindPlayers(Arg, Player)
	local Success = false
	local Toggle = false
	if (not Players or #Players == 0) then return "No players found." end
	
	for _, ply in ipairs(Players) do
		ply:SetNoDraw(true)
	end
	
	return "You cloaked "..vh:CreatePlayerList(Players)
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