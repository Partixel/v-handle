local Command = VH_CommandLib.Command:new("Punish", VH_CommandLib.UserTypes.Admin, "Punish the player according to the reason.", "")
Command:addArg(VH_CommandLib.ArgTypes.Plr, {required = true})
Command:addArg(VH_CommandLib.ArgTypes.String, {required = true, Name = "Reason"})
Command:addAlias({Prefix = "!", Alias = "punish"})

local Reasons = {
	TA = {"Tool Abuse", 2},
	PA = {"Prop Abuse", 2},
	LTA = {"Lying to Admin", 3},
	IA = {"Ignoring Admin", 2},
	MS = {"Microphone Spam", 1},
	CS = {"Chat Spam", 1},
	VA = {"Verbal Abuse", 3},
	ATAP = {"Action to avoid Punishment", 3}
}

local DarkRPReasons = {
	JA = {"Job Abuse", 1},
	RDM = {"Random Deathmatch", 1},
	RA = {"Random Arrest", 1},
	SS = {"Self Supply", 1},
	FARP = {"FailRP", 2},
	NLR = {"New Life Rule", 2},
	AM = {"Advert Misuse", 1},
	RPWA = {"Roleplay without Advert", 2},
}

if DarkRP then
	for i, v in pairs(DarkRPReasons) do
		Reasons[i] = v
	end
end

local Modifiers = {
	M = {"Mass", 5},
	X2 = {"Times Two", 2},
	X3 = {"Times Three", 3},
	X4 = {"Times Four", 4},
	IS = {"In Sit", 3},
	OD = {"On Duty", 3},
	A = {"Attempted", 0.5},
}

local Times = {
	{Name = "Warning", Limit = 5, Commands = {"warn"}},
	{Name = "Warning and a Slay", Limit = 10, Commands = {"slay", "warn"}},
	{Name = "Kick", Limit = 15, Commands = {"kick"}},
	{Name = "60 Minute Ban", Limit = 20, Commands = {"ban"}, Time = 60},
	{Name = "1 Day Ban", Limit = 25, Commands = {"ban"}, Time = 1440},
	{Name = "1 Week Ban", Limit = 30, Commands = {"ban"}, Time = 10080},
	{Name = "Permanent Ban", Limit = 1000, Commands = {"ban"}, Time = 0}
}

Command.Callback = function(Sender, Alias, Target, Reason)
	local severity = 0
	
	local fullreason = ""
	local reasons = {}
	for _, v in ipairs(string.Explode(" ", Reason)) do
		table.insert(reasons, v)
	end
	
	if #reasons == 0 then
		print("noreason")
		--evolve:Notify( ply, evolve.colors.red, "You must supply a reason." )
		return
	end
	
	for x, v in pairs(reasons) do
		if Reasons[string.upper(v)] then
			local value = Reasons[string.upper(v)]
			fullreason = fullreason..value[1]
			severity = severity + value[2]
			if x ~= #reasons then
				fullreason = fullreason.." + "
			end
		elseif string.find(v, "-") then
			local splits = string.Split(v, "-")
			if #splits < 2 then
				return
			end
			if Reasons[string.upper(splits[1])] then
				local value = Reasons[string.upper(splits[1])]
				fullreason = fullreason..value[1]
				local currentseverity = value[2]
				for i = 2, #splits do
					if Modifiers[string.upper(splits[i])] then
						currentseverity = currentseverity * Modifiers[string.upper(splits[i])][2]
						fullreason = fullreason.."-"..Modifiers[string.upper(splits[i])][1]
					else
						print("notvalid1")
						--evolve:Notify( ply, evolve.colors.red, splits[i].." is not a valid modifier, for a list of modifiers, go here: http://goo.gl/wctswy" )
						return
					end
				end
				severity = severity + currentseverity
				if x ~= #reasons then
					fullreason = fullreason.." + "
				end
			else
			print("notvalid2")
				--evolve:Notify( ply, evolve.colors.red, splits[1].." is not a valid reason, for a list of reasons, go here: http://goo.gl/wctswy" )
				return
			end
		else
			print("notvalid3")
			--evolve:Notify( ply, evolve.colors.red, v.." is not a valid reason, for a list of reasons, go here: http://goo.gl/wctswy" )
			return
		end
	end
	print(severity, fullreason)
	local name = Target:Nick()
	local punishment = ""
	--[[for _, v in pairs(Times) do
		if severity < v.Limit then
			punishment = v.Name
			for _, c in pairs(v.Commands) do
				if c == "warn" then
					RunConsoleCommand("awarn_warn", pl[1]:Nick(), "Punished by", ply:Nick(), "for", fullreason)
				elseif c == "slay" then
					Slay(ply, pl[1])
				elseif c == "kick" then
					Kick(ply, pl[1], fullreason)
				elseif c == "ban" then
					Ban(ply, pl[1], v.Time, fullreason)
				end
			end
			break
		end
	end]]
	--evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has punished ", evolve.colors.red, name, evolve.colors.white, " with a " .. punishment .." for the reason " .. fullreason .. "." )
	
	return ""
end