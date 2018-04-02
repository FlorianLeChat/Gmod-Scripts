-- [[ SETTINGS ]] --

-- Command name (Default : "ooccontrol")
local command_name = "ooccontrol"
-- Execution command delay (Default : 1.5)
local command_delay = 1.5
-- Admins can always use ooc when is disabled
local admin_can_always_use_ooc = true

-- [[ CODE WORK ]] --

function OOC_Disabler_GamemodeCheck()
	if string.find(string.lower(GAMEMODE.Name), "rp") then
		if SERVER then

			-- OOC CONTROL COMMAND

			local function OOC_CONTROL(ply)
				local pname = ply:Nick()
				
				if ply:IsAdmin() then
					if GAMEMODE.Config.ooc then
						GAMEMODE.Config.ooc = false
						DarkRP.notifyAll(0, 5, "OOC was disabled by " .. pname .. " !")
					else
						GAMEMODE.Config.ooc = true
						DarkRP.notifyAll(0, 5, "OOC was enabled by " .. pname .. " !")
					end
				else
					DarkRP.notify("You're not authorized to execute this command.")
				end

				return ""
			end
			DarkRP.defineChatCommand(command_name, OOC_CONTROL)

			-- OOC COMMAND MODIFICATION

			if admin_can_always_use_ooc then
				local function OOC(ply, args)
					if not GAMEMODE.Config.ooc and not ply:IsAdmin() then
						DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("disabled", DarkRP.getPhrase("ooc"), ""))
						return ""
					end

					local DoSay = function(text)
						if text == "" then
							DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
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
				DarkRP.defineChatCommand("/", OOC, true, 1.5)
				DarkRP.defineChatCommand("a", OOC, true, 1.5)
				DarkRP.defineChatCommand("ooc", OOC, true, 1.5)
			end
		end

		DarkRP.declareChatCommand{
			command = command_name,
			description = "Enable or disable OOC.",
			delay = command_delay
		}
	else
		timer.Create("OOC_Disabler.GamemodeInitError", 30, 0, function()
			for _, v in ipairs(player.GetAll()) do
				if IsValid(v) then
					v:ChatPrint("'OOC Disabler' not loaded because he only work with RP Gamemodes !")
				end
			end
		end)
	end
end
hook.Add("OnGamemodeLoaded", "OOC_Disabler_GamemodeCheck", OOC_Disabler_GamemodeCheck)

concommand.Add("oocdisaber_check", function(ply)
	ply:ChatPrint("This server use 'OOC Disabler' script ! ( https://steamcommunity.com/sharedfiles/filedetails/?id=1314167955 )")
end)

-- Made by "The Cat" alias "Florian #" ( http://steamcommunity.com/profiles/76561198053479101 )
-- I'm french baguette.. sorry <3
