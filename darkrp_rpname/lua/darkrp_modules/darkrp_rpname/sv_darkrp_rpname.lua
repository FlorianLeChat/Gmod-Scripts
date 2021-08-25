-- https://github.com/FPtje/DarkRP/blob/61d689ded48341b7d9f5f4a303161c3731e7f633/gamemode/modules/base/sv_gamemode_functions.lua#L29-L37
local blacklist = {
	["ooc"] = true,
	["shared"] = true,
	["world"] = true,
	["world prop"] = true
}

GAMEMODE.CanChangeRPName = function() end

hook.Add("CanChangeRPName", "Gmod.Workshop.DarkRP_Name", function(ply, name)

	if blacklist[string.lower(name)] then

		return false, DarkRP.getPhrase("forbidden_name")

	end

	local length = utf8.len(name)

	if length > 35 then

		return false, DarkRP.getPhrase("too_long")

	end

	if length < 3 then

		return false, DarkRP.getPhrase("too_short")

	end

end)