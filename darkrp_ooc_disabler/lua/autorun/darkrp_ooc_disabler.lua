-- [[ SETTINGS ]] --

-- What the name of this command? (default : "ooccontrol")
local command_name = "ooccontrol"
-- What is the delay for DarkRP anti-spam command? (default : 1.5)
local command_delay = 1.5
-- Admins can always use ooc when is disabled? (default : true)
local admin_can_always_use_ooc = true

-- [[ CODE ]] --

hook.Add("PostGamemodeLoaded", "Gmod.Workshop.DarkRP_OOC_Disabler", function()

	-- Gamemode check
	if not DarkRP then

		timer.Create("Gmod.Workshop.DarkRP_OOC_Disabler", 30, 0, function()

			local players = player.GetAll()

			for i = 1, #players do

				players[i]:ChatPrint("The addon \"[DarkRP] OOC Disabler\" didn't load because it works only on the DarkRP or derived gamemode.")

			end

		end)

		return

	end

	if SERVER then

		-- OOC CONTROL COMMAND

		local function OOC_CONTROL(ply, args)

			if ply:IsAdmin() then

				local playerName = ply:Nick()

				if GAMEMODE.Config.ooc then

					DarkRP.notifyAll(0, 5, "The OOC channel has been disabled by " .. playerName .. ".")

				else

					DarkRP.notifyAll(0, 5, "The OOC channel has been enabled by " .. playerName .. ".")

				end

				GAMEMODE.Config.ooc = not GAMEMODE.Config.ooc

			else

				DarkRP.notify("You are not authorized to execute this command.")

			end

			return ""

		end
		DarkRP.defineChatCommand(command_name, OOC_CONTROL)

		-- OOC COMMAND MODIFICATION

		if admin_can_always_use_ooc then

			local function OOC(ply, args)

				-- https://github.com/FPtje/DarkRP/blob/7e06296120f4b6891fc65fd325018e3391a603e4/gamemode/modules/chat/sv_chatcommands.lua#L85-L113
				if not GAMEMODE.Config.ooc and not ply:IsAdmin() then
					DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("disabled", DarkRP.getPhrase("ooc"), ""))
					return ""
				end

				local DoSay = function(text)

					if text == "" then
						DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ""))
						return ""
					end

					local col = team.GetColor(ply:Team())
					local col2 = Color(255, 255, 255, 255)
					if not ply:Alive() then
						col2 = Color(255, 200, 200, 255)
						col = col2
					end

					local phrase = DarkRP.getPhrase("ooc")
					local name = ply:Nick()
					for _, v in ipairs(player.GetAll()) do
						DarkRP.talkToPerson(v, col, "(" .. phrase .. ") " .. name, col2, text, ply)
					end

				end

				return args, DoSay

			end
			DarkRP.defineChatCommand("/", OOC)
			DarkRP.defineChatCommand("a", OOC)
			DarkRP.defineChatCommand("ooc", OOC)

		end

	end

	DarkRP.declareChatCommand({

		command = command_name,
		description = "Allows you to disable or re-enable the OOC channel.",
		delay = command_delay

	})

end)

-- Made by "The Cat" alias "Florian #" ( http://steamcommunity.com/profiles/76561198053479101 )
-- I'm french baguette.. #TeamBaguette <3