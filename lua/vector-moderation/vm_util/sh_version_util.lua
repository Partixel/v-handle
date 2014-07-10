version_util = {}


-- Returns a table in the format of a version
function version_util.Version(Ma, Mi, Pa)
  return {Major = Ma, Minor = Mi, Patch = Pa}
end

-- Compares the two versions passed
-- Returns true if the first version passed is newer
function version_util.isNewer(Ver, CVer)
	return Ver.Major > Cver.Major ? true : (Ver.Minor > Cver.Minor ? true
			: (Ver.Patch > Cver.Patch ? true : false));
end

-- Converst the version to a string
function version_util.toString(Ver)
	return Ver.Major + "." + Ver.Minor + "." + Ver.Patch;
end
