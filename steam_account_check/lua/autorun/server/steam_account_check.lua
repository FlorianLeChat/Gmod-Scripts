if game.IsDedicated() then
	-- [[ SETTINGS ]] --

	local limitedaccountcheck = true

	-- The family sharing game check requires a Steam key API
	local familysharing = false

	-- The vac bans check requires a Steam key API
	local vacbancheck = false
	-- Limit of vac bans before kick the player (if vacbancheck set to true)
	local maxvacbans = 1

	-- Find an API Key here : https://steamcommunity.com/dev/apikey
	local apikey = ""

	-- Put the SteamIDs which not be checked on their connection
	local nocheck = {"STEAM_0:1:46606686"}

	local redcolor = Color(255, 0, 0, 255)
	local greencolor = Color(22, 184, 78, 255)

	-- [[ CODE ]] --

	hook.Add("CheckPassword", "SteamAccountChecks", function(steamID64, ipAddress)
		local steamid = util.SteamIDFrom64(steamID64)

		if limitedaccountcheck and not table.HasValue(nocheck, steamid) then
			http.Fetch(string.format("https://steamcommunity.com/profiles/%s/?xml=1", steamID64),
				function(body, len, headers, code)
					if body != nil and len != 0 and code == 200 then
						if string.find(body, "<isLimitedAccount>1</isLimitedAccount>") then
							game.KickID(steamid, "You have been disconnected from the server (Limited account)")
							MsgC(greencolor, "Stopping a steam limited account ! (SteamID64 : " .. steamID64 .. " | IP : " .. ipAddress .. ")\n")
							return
						end
					end
				end,

				function(error)
					MsgC(redcolor, "Unable to check an steam account. (ID : " .. steamID64 .. " | Error : '" .. error .. "')\n")
				end
			)
		end

		if vacbancheck and apikey != "" and not table.HasValue(nocheck, steamid) then
			http.Fetch(string.format("https://api.steampowered.com/ISteamUser/GetPlayerBans/v1/?key=%s&steamids=%s", apikey, steamID64),
				function(body, len, headers, code)
					if body != nil and len != 0 and code == 200 then
						body = util.JSONToTable(body)
						body = body["players"][1]

	 					if body.VACBanned and body.NumberOfVACBans > maxvacbans then
							game.KickID(steamid, "You have been disconnected from the server (VAC Banned account)")
							MsgC(greencolor, "Stopping a steam vac banned account ! (VAC Bans : " .. body.NumberOfVACBans .. " | SteamID64 : " .. steamID64 .. " | IP : " .. ipAddress .. ")\n")
							return
						end
					end
				end,

				function(error)
					MsgC(redcolor, "Unable to check an steam account. (ID : " .. steamID64 .. " | Error : '" .. error .. "')\n")
				end
			)
		end

		if familysharing and apikey != "" and not table.HasValue(nocheck, steamid) then
			http.Fetch(string.format("https://api.steampowered.com/IPlayerService/IsPlayingSharedGame/v0001/?key=%s&steamid=%s&appid_playing=4000", apikey, steamID64),
				function(body, len, headers, code)
					if body != nil and len != 0 and code == 200 then
						body = util.JSONToTable(body)
						body = body.response.lender_steamid

						if body != "0" then
							game.KickID(steamid, "You have been disconnected from the server (Family Sharing game)")
							MsgC(greencolor, "Stopping a family sharing game ! (SteamID64 : " .. steamID64 .. " | IP : " .. ipAddress .. ")\n")
							return
						end
					end
				end,

				function(error)
					MsgC(redcolor, "Unable to check an steam account. (ID : " .. steamID64 .. " | Error : '" .. error .. "')\n")
				end
			)
		end
	end)
else
	timer.Create("SteamAccountChecks.DedicatedServersInitError", 30, 0, function()
		for _, v in ipairs(player.GetAll()) do
			v:ChatPrint("'Steam Account Checks' was not loaded because he only work on dedicated servers !")
		end
	end)
end

concommand.Add("steamaccountchecks_check", function(ply)
	ply:ChatPrint("This server use 'Steam Account Checks' script ! ( https://steamcommunity.com/sharedfiles/filedetails/?id=1314167955 )")
end)

-- Made by "The Cat" alias "Florian #" ( http://steamcommunity.com/profiles/76561198053479101 )
-- I'm french baguette.. #TeamBaguette <3