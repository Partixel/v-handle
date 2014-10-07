if DarkRP then
	local Command = _V.CommandLib.Command:new("Job", _V.CommandLib.UserTypes.Admin, "Set the job of or demote the player(s).", "")
	Command:addArg(_V.CommandLib.ArgTypes.Players, {required = false})
	Command:addArg(_V.CommandLib.ArgTypes.String, {required = false})
	Command:addAlias("!setjob", "!demote")

	Command.Callback = function(Sender, Alias, Targets, Job)
		local Targets = Targets or {Sender}
		
		for _, ply in ipairs(Targets) do
			if Alias == "!setjob" then
				RunConsoleCommand( "rp_"..string.lower(Job or "citizen"), ply:Nick())
			else
				RunConsoleCommand( "rp_citizen", ply:Nick())
			end
		end
		
		if Alias == "!setjob" then
			_V.CommandLib.SendCommandMessage(Sender, "set the job of", Targets, "to "..(Job or "Citizen"))
		else
			_V.CommandLib.SendCommandMessage(Sender, "demoted", Targets, "to Citizen")
		end
		
		return ""
	end

	local Command = _V.CommandLib.Command:new("Arrest", _V.CommandLib.UserTypes.Admin, "Arrest or unarrest the player(s).", "")
	Command:addArg(_V.CommandLib.ArgTypes.Players, {required = false})
	Command:addAlias("!arrest", "!unarrest")

	Command.Callback = function(Sender, Alias, Targets)
		local Targets = Targets or {Sender}
		local Success, Toggle = _V.CommandLib.DoToggleableCommand(Alias, {"!arrest"}, {"!unarrest"}, {""})
		
		for _, ply in ipairs(Targets) do
			if Success then
				RunConsoleCommand( "rp_arrest", ply:Nick())
			else
				RunConsoleCommand( "rp_unarrest", ply:Nick())
			end
		end
		
		_V.CommandLib.SendCommandMessage(Sender, (Success and "" or "un").."arrested", Targets, "")
		
		return ""
	end

	local Command = _V.CommandLib.Command:new("Money", _V.CommandLib.UserTypes.Admin, "Add or set the players money.", "")
	Command:addArg(_V.CommandLib.ArgTypes.Player, {required = true})
	Command:addArg(_V.CommandLib.ArgTypes.Number, {required = true})
	Command:addAlias("!setmoney", "!addmoney")

	Command.Callback = function(Sender, Alias, Target, Amount)
		if Alias == "!setmoney" then
			RunConsoleCommand("rp_setmoney", Target:Nick(), Amount)
		else
			Target:addMoney(Amount)
		end
		
		_V.CommandLib.SendCommandMessage(Sender, "armed", Targets, "")
		
		return ""
	end
end