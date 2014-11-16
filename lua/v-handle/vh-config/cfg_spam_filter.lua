---- SpamFilter Config ----
VH_SpamFilter = VH_SpamFilter or {}
VH_SpamFilter.ChatBlacklist = {
	"Retard",
	"Faggot",
	"Fag",
	"Disabled"
}
-- Add words you want blacklisted into the table, requires a comma at end
VH_SpamFilter.MaxWordLength = 15
-- Maximum length of words
VH_SpamFilter.CapsPercentage = 70
-- Maximum percentage of capitals per word
VH_SpamFilter.CensorPercentage = 70
-- Maximum percentage of censoring per word
VH_SpamFilter.LetterDragging = 3
-- Maximum letters in a row
VH_SpamFilter.AdvancedFiltering = true
-- Checks for common letter changes to bypass filters, e.g using @ instead of a
VH_SpamFilter.SoftFiltering = true
-- Checks for similarities in words that bypass filters, allows 1 difference per 4 letters compared to blacklisted words
VH_SpamFilter.MatchingChars = {
	{"a", "@", "2"},
	{"3", "#"},
	{"s", "5", "$", "4"},
	{"5", "%"},
	{"6", "^"},
	{"7", "&"},
	{"8", "*"},
	{"9", "("},
	{"0", ")"},
	{"i", "1", "!", "|"},
	{"o", "0"},
	{"ate", "8"},
	{"e", "3"},
	{"l", "|"}
}
-- Characters that may be used in place of other characters
-- e.g. 1 instead of I