if game.SinglePlayer() then return end

local redColor = Color(255, 0, 0, 255)
local greenColor = Color(22, 184, 78, 255)

-- [[ SETTINGS ]] --

local limitedAccount = true

-- Requires a Steam API key!
local familySharing = false

-- Requires a Steam API key!
local vacBanCheck = false
local maxVACBans = 2

-- Find an API Key here: https://steamcommunity.com/dev/apikey.
local apiKey = ""

-- Put the SteamIDs which not be checked on their connection.
local noCheck = {

	["STEAM_0:1:46606686"] = true,

}

-- [[ CODE ]] --

hook.Add("CheckPassword", "Gmod.Workshop.Steam_Account_Check", function(steamID64, ipAddress, svPassword, clPassword, name)

	local steamID = util.SteamIDFrom64(steamID64)

	if noCheck[steamID] then

		return

	end

	if limitedAccount then

		http.Fetch("https://steamcommunity.com/profiles/" .. steamID64 .. "/?xml=1",

			function(body, length, headers, code)

				if body == "" or length == 0 and code ~= 200 then

					return

				end

				if string.find(body, "<isLimitedAccount>1</isLimitedAccount>") then

					game.KickID(steamID, "You have been disconnected from the server (Limited account)")

					MsgC(greenColor, "Stopping a Steam limited account (SteamID: \"" .. steamID .. "\" | IP: \"" .. ipAddress .. "\").\n")

				end

			end,

			function(code)

				MsgC(redColor, "Unable to check an Steam account (SteamID: \"" .. steamID .. "\" | Error : \"" .. code .. "\").\n")

			end

		)

	end

	if vacBanCheck and apiKey ~= "" then

		http.Fetch("https://api.steampowered.com/ISteamUser/GetPlayerBans/v1/?key=" .. apikey .. "&steamids=" .. steamID64,

			function(body, length, headers, code)

				if body == "" or length == 0 and code ~= 200 then

					return

				end

				body = util.JSONToTable(body) .. players[1]

				if body.VACBanned and body.NumberOfVACBans > maxVACBans then

					game.KickID(steamID, "You have been disconnected from the server (VAC Banned account)")

					MsgC(greenColor, "Stopping a Steam VAC banned account ! (VAC Bans: " .. body.NumberOfVACBans .. " | SteamID: " .. steamID .. " | IP: " .. ipAddress .. ").\n")

					return

				end

			end,

			function(code)

				MsgC(redColor, "Unable to check an Steam account (SteamID: \"" .. steamID .. "\" | Error : \"" .. code .. "\").\n")

			end

		)

	end

	if familySharing and apiKey ~= "" then

		http.Fetch("https://api.steampowered.com/IPlayerService/IsPlayingSharedGame/v0001/?key=" .. apikey .. "&steamid=" .. steamID64 .. "&appid_playing=4000",

			function(body, length, headers, code)

				if body == "" or length == 0 and code ~= 200 then

					return

				end

				body = util.JSONToTable(body).response.lender_steamid

				if body ~= "0" then

					game.KickID(steamID, "You have been disconnected from the server (Family Sharing game)")

					MsgC(greenColor, "Stopping a family sharing game (SteamID : " .. steamID .. " | IP: " .. ipAddress .. ").\n")

					return

				end

			end,

			function(code)

				MsgC(redColor, "Unable to check an Steam account (SteamID: \"" .. steamID .. "\" | Error : \"" .. code .. "\").\n")

			end

		)

	end

end)

-- Made by "The Cat" alias "Florian #" ( http://steamcommunity.com/profiles/76561198053479101 )
-- I'm french baguette.. #TeamBaguette <3