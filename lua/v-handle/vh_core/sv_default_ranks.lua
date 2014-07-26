vh.DefaultRankTypes = {
	{
		Name = "User",
		UserGroup = "user",
		UID = 1,
		Inherits = 0,
		Target = {1},
		Permissions = {
			
		}
	},
	{
		Name = "Moderator",
		UserGroup = "user",
		UID = 2,
		Inherits = 1,
		Target = {1, 2},
		Permissions = {
			TestPerm = {Value = true, Target = {1}},
			TestPermB = {Value = true, Target = {1, 2}}
		}
	},
	{
		Name = "Admin",
		UserGroup = "admin",
		UID = 3,
		Inherits = 2,
		Target = {1, 2, 3},
		Permissions = {
			TestPerm = {Value = false, Target = {1}}
		}
	},
	{
		Name = "Super Admin",
		UserGroup = "superadmin",
		UID = 4,
		Inherits = 3,
		Target = {1, 2, 3, 4},
		Permissions = {
			SetRank = {Value = true, Target = {1, 2, 3}}
		}
	},
	{
		Name = "Owner",
		UserGroup = "superadmin",
		UID = 0,
		Inherits = 0,
		Target = {0},
		Permissions = {
			All = {Value = true}
		}
	},
	{
		Name = "Console",
		UserGroup = "superadmin",
		UID = -1,
		Inherits = 0,
		Target = {0},
		Permissions = {
			All = {Value = true}
		}
	}
}