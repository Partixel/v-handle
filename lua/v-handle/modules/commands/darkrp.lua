if DarkRP then
	local Command = VH_CommandLib.Command:new("Job", VH_CommandLib.UserTypes.Admin, "Set the job of or demote the player(s).", "")
	Command:addArg(VH_CommandLib.ArgTypes.Plrs, {required = true})
	Command:addArg(VH_CommandLib.ArgTypes.String, {required = false})
	Command:addAlias({Prefix = "!", Alias = {"setjob", "demote"}})

	Command.Callback = function(Sender, Alias, Targets, Job)
		for _, ply in ipairs(Targets) do
			if Alias == "setjob" then
				RunConsoleCommand( "rp_"..string.lower(Job or "citizen"), ply:Nick())
			else
				RunConsoleCommand( "rp_citizen", ply:Nick())
			end
		end
		
		if Alias == "setjob" then
			VH_CommandLib.SendCommandMessage(Sender, "set the job of", Targets, "to "..(Job or "Citizen"))
		else
			VH_CommandLib.SendCommandMessage(Sender, "demoted", Targets, "to Citizen")
		end
		
		return ""
	end

	local Command = VH_CommandLib.Command:new("Arrest", VH_CommandLib.UserTypes.Admin, "Arrest or unarrest the player(s).", "")
	Command:addArg(VH_CommandLib.ArgTypes.Plrs, {required = true})
	Command:addAlias({Prefix = "!", Alias = {"arrest", "unarrest"}})

	Command.Callback = function(Sender, Alias, Targets)
		local Success, Toggle = VH_CommandLib.DoToggleableCommand(Alias, {"arrest"}, {"unarrest"}, {""})
		
		for _, ply in ipairs(Targets) do
			if Success then
				RunConsoleCommand( "rp_arrest", ply:Nick())
			else
				RunConsoleCommand( "rp_unarrest", ply:Nick())
			end
		end
		
		VH_CommandLib.SendCommandMessage(Sender, (Success and "" or "un").."arrested", Targets, "")
		
		return ""
	end

	local Command = VH_CommandLib.Command:new("Money", VH_CommandLib.UserTypes.Admin, "Add or set the players money.", "")
	Command:addArg(VH_CommandLib.ArgTypes.Plr, {required = true})
	Command:addArg(VH_CommandLib.ArgTypes.Number, {required = true})
	Command:addAlias({Prefix = "!", Alias = {"setmoney", "addmoney"}})

	Command.Callback = function(Sender, Alias, Target, Amount)
		if Alias == "setmoney" then
			RunConsoleCommand("rp_setmoney", Target:Nick(), Amount)
		else
			Target:addMoney(Amount)
		end
		
		VH_CommandLib.SendCommandMessage(Sender, "armed", Targets, "")
		
		return ""
	end
end