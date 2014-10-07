local Command = _V.CommandLib.Command:new("Punish", _V.CommandLib.UserTypes.Admin, "Punish the player according to the reason.", "")
Command:addArg(_V.CommandLib.ArgTypes.Player, {required = true})
Command:addArg(_V.CommandLib.ArgTypes.String, {required = true})
Command:addAlias("!punish")

local Reasons = {
	{"TA", "Tool Abuse", 2},
	{"PA", "Prop Abuse", 2},
	{"LTA", "Lying to Admin", 3},
	{"IA", "Ignoring Admin", 2},
	{"MS", "Microphone Spam", 1},
	{"CS", "Chat Spam", 1},
	{"VA", "Verbal Abuse", 3},
	{"ATAP", "Action to avoid Punishment", 3}
}

local DarkRPReasons = {
	{"JA", "Job Abuse", 1},
	{"RA", "Random Arrest", 1},
	{"SS", "Self Supply", 1},
	{"FARP", "FailRP", 2},
	{"NLR", "New Life Rule", 2},
	{"AM", "Advert Misuse", 1},
	{"RPWA", "Roleplay without Advert", 2},
}

if DarkRP then
	for _, v in ipairs(DarkRPReasons) do
		table.insert(Reasons, v)
	end
end

local Modifiers = {
	{"M", "Mass", 5},
	{"x2", "Times Two", 2},
	{"x3", "Times Three", 3},
	{"x4", "Times Four", 4},
	{"IS", "In Sit", 3},
	{"OD", "On Duty", 3},
	{"A", "Attempted", 0.5},
}

Command.Callback = function(Sender, Alias, Target, Reason)
	return ""
end