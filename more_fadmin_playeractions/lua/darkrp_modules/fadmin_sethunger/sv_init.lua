local function SetHunger(ply, cmd, args)

	if not FAdmin.Access.PlayerHasPrivilege(ply, "SetHunger") then

		FAdmin.Messages.SendMessage(ply, 5, "No access!")

		return false

	end

	local playerID = args[1]

	if not playerID then

		FAdmin.Messages.SendMessage(ply, 5, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), "(PlayerID)"))

		return false

	end

	local value = tonumber(args[2]) or 100
	local targets = FAdmin.FindPlayer(args[1]) or {}

	if #targets == 0 then

		FAdmin.Messages.SendMessage(ply, 5, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), "(Targets)"))

		return false

	end

	for i = 1, #targets do

		local target = targets[i]

		if FAdmin.Access.PlayerHasPrivilege(ply, "SetHunger", target) then

			target:setSelfDarkRPVar("Energy", value)

		end

	end

	FAdmin.Messages.FireNotification("sethunger", ply, targets, {value})

	return true, targets, value

end

FAdmin.StartHooks["SetHunger"] = function()

	if DarkRP.disabledDefaults["modules"]["hungermod"] then return end

	FAdmin.Messages.RegisterNotification({

		name = "sethunger",
		hasTarget = true,
		receivers = "everyone",
		writeExtraInfo = function(info) net.WriteString(info[1]) end,
		message = {"instigator", " set the hunger of ", "targets", " to ", "extraInfo.1"}

	})

	FAdmin.Access.AddPrivilege("SetHunger", 2)

	FAdmin.Commands.AddCommand("hunger", SetHunger)
	FAdmin.Commands.AddCommand("sethunger", SetHunger)

end