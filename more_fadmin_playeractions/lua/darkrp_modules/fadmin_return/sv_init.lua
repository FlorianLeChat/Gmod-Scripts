local function Return(ply, cmd, args)

	if not FAdmin.Access.PlayerHasPrivilege(ply, "Return") then

		FAdmin.Messages.SendMessage(ply, 5, "No access!")

		return false

	end

	local playerID = args[1]

	if not playerID then

		FAdmin.Messages.SendMessage(ply, 5, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), "(PlayerID)"))

		return false

	end

	local targets = FAdmin.FindPlayer(args[1]) or {}

	if #targets == 0 then

		FAdmin.Messages.SendMessage(ply, 5, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), "(Targets)"))

		return false

	end

	for i = 1, #targets do

		local target = targets[i]

		if FAdmin.Access.PlayerHasPrivilege(ply, "Return", target) then

			target:ExitVehicle()

			target:SetPos(target.previousPosition or target:GetPos())
			target:SetEyeAngles(target.previousAngles or target:EyeAngles())

			target.previousPosition = nil
			target.previousAngles = nil

		end

	end

	FAdmin.Messages.FireNotification("return", ply, targets)

	return true, targets

end

FAdmin.StartHooks["Return"] = function()

	FAdmin.Messages.RegisterNotification({

		name = "return",
		hasTarget = true,
		receivers = "everyone",
		message = {"instigator", " has returned ", "targets", " at its last position"}

	})

	FAdmin.Access.AddPrivilege("Return", 2)
	FAdmin.Commands.AddCommand("return", Return)

end

-- The old position/angles of the players are saved just before their teleportation.
-- This avoids modifying the DarkRP core files, which can cause issues if there are updates in the future.
local commands = {"teleport", "tp", "bring", "goto", "tptopos"}

hook.Add("Think", "Gmod.Workshop.More_FAdmin_Actions", function()

	-- I don't know yet what black magic DarkRP uses to have a hook triggered after EVERYTHING is loaded.
	if not istable(FAdmin.Commands.List["teleport"]) then

		return

	end

	hook.Remove("Think", "Gmod.Workshop.More_FAdmin_Actions")

	for i = 1, #commands do

		local command = commands[i]
		local oldCallback = FAdmin.Commands.List[command].callback

		FAdmin.Commands.List[command].callback = function(ply, name, args)

			-- The player must be allowed to run these commands.
			if FAdmin.Access.PlayerHasPrivilege(ply, "Teleport") then

				local targets = FAdmin.FindPlayer(args[1])

				if istable(targets) then

					-- Each player targeted by the command must have his old position in memory.
					for j = 1, #targets do

						local target = targets[j]

						target.previousPosition = target:GetPos()
						target.previousAngles = target:EyeAngles()

					end

				end

			end

			-- Afterwards, the old function is executed without modification.
			oldCallback(ply, name, args)

		end

	end

end)