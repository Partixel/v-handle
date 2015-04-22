local Command = VH_CommandLib.Command:new("ReloadCfg", VH_CommandLib.UserTypes.SuperAdmin, "Reloads the V-Handle config", "")
Command:addAlias({Prefix = "!", Alias = "reloadcfg"})

Command.Callback = function(Sender, Alias, Targets)
	VH_LoadConfigs()
	
	return ""
end