local function SetModel(ply, cmd, args)

	if not FAdmin.Access.PlayerHasPrivilege(ply, "SetModel") then

		FAdmin.Messages.SendMessage(ply, 5, "No access!")

		return false

	end

	local playerID = args[1]

	if not playerID then

		FAdmin.Messages.SendMessage(ply, 5, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), "(PlayerID)"))

		return false

	end

	local value = args[2] ~= "" and args[2] or "models/player/group01/male_02.mdl"

	if not value then

		FAdmin.Messages.SendMessage(ply, 5, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), "(Value)"))

		return false

	end

	local targets = FAdmin.FindPlayer(args[1]) or {}

	if #targets == 0 then

		FAdmin.Messages.SendMessage(ply, 5, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), "(Targets)"))

		return false

	end

	for i = 1, #targets do

		local target = targets[i]

		if FAdmin.Access.PlayerHasPrivilege(ply, "SetModel", target) then

			target:SetModel(value)

		end

	end

	FAdmin.Messages.FireNotification("setmodel", ply, targets, {value})

	return true, targets, value

end

FAdmin.StartHooks["SetModel"] = function()

	FAdmin.Messages.RegisterNotification({

		name = "setmodel",
		hasTarget = true,
		receivers = "everyone",
		writeExtraInfo = function(info) net.WriteString(info[1]) end,
		message = {"instigator", " set the model of ", "targets", " to ", "extraInfo.1"}

	})

	FAdmin.Access.AddPrivilege("SetModel", 2)

	FAdmin.Commands.AddCommand("model", SetModel)
	FAdmin.Commands.AddCommand("setmodel", SetModel)

end