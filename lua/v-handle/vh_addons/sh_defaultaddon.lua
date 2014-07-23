local addon = {}
addon.Name = "Default"
addon.Description = "Default addon"
addon.Commands = {}
addon.Commands.DefaultCommand = {
  Aliases = {"AnotherCommand"},
  Prefix = "!",
  Description = "Does default stuff",
  Usage = "<Player>"
}

function addon.Commands.DefaultCommand.Run(Player, Args)
	Player:PrintMessage( HUD_PRINTTALK, "Ran default command!" )
end

function addon.Commands.DefaultCommand.Vars(ArgNumber)
	if (ArgNumber == 1) then
		return {"1", "2"}
	elseif (ArgNumber == 2) then
		return {"NotNow", "Okay"}
	end
	return
end

addon.ConCommands = {}
addon.ConCommands.DefaultConCommand = {}

function addon.ConCommands.DefaultConCommand.Run(Player, Command, Args)
	Player:PrintMessage( HUD_PRINTTALK, "Ran default command!" )
end

vh.RegisterAddon(addon)
