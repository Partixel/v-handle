local Module = {} -- A list containing the modules values and functions
Module.Name = "Default" -- Name of the module
Module.Description = "Default Module" -- Description of the module
Module.Commands = {} -- List of commands this module adds
Module.Commands.DefaultCommand = { -- A command
  Aliases = {"AnotherCommand"}, -- Names that can be used to run the command as well as the key
  Prefix = "!", -- The character(s) that needs to be put before the command
  Description = "Does default stuff", -- The desciption of the command for display
  Usage = "<Player>", -- A description of how the command is used
  Permission = "SetRank", -- The permission required to run the command
  MinArgs = 2 -- The minimum amount of arguements needed for the command
}

Module.Disabled = true -- Disables the module

function Module.Commands.DefaultCommand.Run(Player, Args, Alias, RankID, Perm) -- The function that is ran via the framework when the command is ran
				-- Player - The player that ran the command ( Could be the console )
				-- Args - The arguements passed with the command
				-- Alias - The alias used to run the command
				-- RankID - The ID of the rank the player used to run the command
				-- Perm - The permission that was used to run the command
	Player:PrintMessage( HUD_PRINTTALK, "Ran default command!" )
end

function Module.Commands.DefaultCommand.Vars(ArgNumber) -- The function that is called when getting valid inputs for arguements
							-- return nil if the #Arguement is invalid
							-- ArgNumber is the position of the arguement;
							-- e.g. !cloak part 1 - "part" would be arguement 1 and in this
							-- function would return a list of player names
	if (ArgNumber == 1) then
		return {"1", "2"}
	elseif (ArgNumber == 2) then
		return {"NotNow", "Okay"}
	end
	return
end

Module.ConCommands = {} -- list of console commands this module adds ( Seperate to vh_[command] )
Module.ConCommands.DefaultConCommand = {} -- A console command, the key is what is registered as a console command

function Module.ConCommands.DefaultConCommand.Run(Player, Command, Args) -- The function that is ran via the framework when the
									 -- console command is ran
	Player:PrintMessage( HUD_PRINTTALK, "Ran default command!" )
end

Module.Hooks = { -- List of hooks required by the module
	{
		Type = "PlayerSay", -- The hook required
		Run = (function( Player, Message, TeamChat ) -- The function to be ran with the corresponding variables
			Player:PrintMessage( HUD_PRINTTALK, "Hook triggered!" )	
		end)
	}
}

vh.RegisterModule(Module) -- Registers this module to the framework for handling of commands, console commands and hooks
