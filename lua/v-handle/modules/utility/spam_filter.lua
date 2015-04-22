local LastSaid = {}
local LastSaidTime = {}

local function WordDifferences(WordA, WordB)
	local Differences = 0
	local ShortestWord = (#WordA < #WordB) and WordA or WordB
	local LongestWord = (#WordA < #WordB) and WordB or WordA
	if #ShortestWord ~= #LongestWord then
		Differences = Differences + #LongestWord - #ShortestWord
	end
	local LongTable = string.ToTable(LongestWord)
	for i, v in pairs(string.ToTable(ShortestWord)) do
		if v ~= LongTable[i] then
			Differences = Differences + 1
		end
	end
	return Differences
end

local function WordSimilar(WordA, WordB)
	local WordA = string.lower(WordA)
	local WordB = string.lower(WordB)
	if WordA == WordB then
		return true
	end
	if VH_SpamFilter.AdvancedFiltering then
		if string.len(WordA) == string.len(WordB) then
			local NewWordA = WordA
			local NewWordB = WordB
			for _, v in ipairs(VH_SpamFilter.MatchingChars) do
				for i, x in ipairs(v) do
					if i == 1 then continue end
					NewWordA = string.Replace(NewWordA, v[i], v[1])
					NewWordB = string.Replace(NewWordB, v[i], v[1])
				end
			end
			if NewWordA == NewWordB then
				return true
			end
		end
	end
	if VH_SpamFilter.SoftFiltering then
		local Differences = WordDifferences(WordA, WordB)
		if Differences <= #WordA/4 then
			return true
		end
	end
	return false
end

function PlayerTalk(Player, Message, TeamChat)
	if string.StartWith(Message, "!") then return end
	local Return = string.Trim(Message)
	local BlacklistTable = VH_SpamFilter.ChatBlacklist
	local Explode = string.Explode(" ", Return)
	local TotalCensored = 0
	for i, word in pairs(Explode) do
		local Caps = 0
		local Repeats = 0
		local LastLetter = ""
		local NewWord = ""
		for _, v in pairs(string.ToTable(word)) do
			if string.lower(v) ~= v then
				Caps = Caps + 1
			end
			if v == LastLetter then
				Repeats = Repeats + 1
				if Repeats < VH_SpamFilter.LetterDragging then
					NewWord = NewWord..v
				end
			else
				LastLetter = v
				Repeats = 0
				NewWord = NewWord..v
			end
		end
		
		if string.len(NewWord) > VH_SpamFilter.MaxWordLength then
			NewWord = string.sub(word, 1, VH_SpamFilter.MaxWordLength - 2)..".."
		end
		
		Return = string.Replace(Return, word, NewWord)
		
		local Percent = math.Round((Caps / string.len(NewWord)) * 100)
		if Percent >= VH_SpamFilter.CapsPercentage and string.len(word) > 1 then
			local FirstChar = string.upper(string.GetChar(NewWord, 1))
			Return = string.Replace(Return, NewWord, string.SetChar(string.lower(NewWord), 1, FirstChar))
		end
		for _, v in pairs(BlacklistTable) do
			if WordSimilar(NewWord, v) then
				Return = string.Replace(Return, NewWord, "****")
				TotalCensored = TotalCensored + string.len(NewWord)
			end
		end
	end
	local Percent = math.Round((TotalCensored / string.len(Message)) * 100);
	if Percent >= VH_SpamFilter.CensorPercentage then
		HookInfo.Disabled = true
		return
	end
	
	local SID = Player:SteamID()
	
	if LastSaid[SID] and VH_SpamFilter.DuplicateFiltering then
		if WordSimilar(Return, LastSaid[SID]) then
			return nil, true
		end
	end
	
	local Time = RealTime()
	if LastSaidTime[SID] and VH_SpamFilter.ChatSpam ~= -1 and (Time - LastSaidTime[SID]) < VH_SpamFilter.ChatSpam then
		return nil, true
	end
	
	LastSaid[SID] = Return
	LastSaidTime[SID] = Time
	return Return
end

VH_HookLib.addHook("PlayerSay", VH_HookLib.HookPriority.Lowest, "VH_SpamFilter", PlayerTalk)
