local Module = {}
Module.Name = "Default"
Module.Description = "Default Module"
Module.Commands = {}
Module.Commands.DefaultCommand = {
  Aliases = {"AnotherCommand"},
  Prefix = "!",
  Description = "Does default stuff",
  Usage = "<Player>"
}

function Module.Commands.DefaultCommand.Run(Player, Args)
	Player:PrintMessage( HUD_PRINTTALK, "Ran default command!" )
end

function Module.Commands.DefaultCommand.Vars(ArgNumber)
	if (ArgNumber == 1) then
		return {"1", "2"}
	elseif (ArgNumber == 2) then
		return {"NotNow", "Okay"}
	end
	return
end

Module.ConCommands = {}
Module.ConCommands.DefaultConCommand = {}

function Module.ConCommands.DefaultConCommand.Run(Player, Command, Args)
	Player:PrintMessage( HUD_PRINTTALK, "Ran default command!" )
end

vh.RegisterModule(Module)
