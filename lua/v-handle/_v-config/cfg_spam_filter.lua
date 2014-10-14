
---- SpamFilter Config ----
_V.Config.SpamFilter = {}

_V.Config.SpamFilter.ChatBlacklist = {"PutBlacklistWordsHere", "LikeTheseWords"} -- Add words you want blacklisted into the table, requires a comma at end

_V.Config.SpamFilter.MaxWordLength = 15 -- Maximum length of words

_V.Config.SpamFilter.CapsPercentage = 70 -- Maximum percentage of capitals per word

_V.Config.SpamFilter.CensorPercentage = 70 -- Maximum percentage of censoring per word

_V.Config.SpamFilter.LetterDragging = 3 -- Maximum letters in a row

_V.Config.SpamFilter.AdvancedFiltering = true -- Checks for common letter changes to bypass filters, e.g using @ instead of a

_V.Config.SpamFilter.ExtremeFiltering = true -- Checks for similarities in words that bypass filters, allows 1 difference per 4 letters compared to blacklisted words
