local function SetMoney(ply, cmd, args)

	if not FAdmin.Access.PlayerHasPrivilege(ply, "SetMoney") then

		FAdmin.Messages.SendMessage(ply, 5, "No access!")

		return false

	end

	local playerID = args[1]

	if not playerID then

		FAdmin.Messages.SendMessage(ply, 5, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), "(PlayerID)"))

		return false

	end

	local value = tonumber(args[2]) or 0
	local targets = FAdmin.FindPlayer(args[1]) or {}

	if #targets == 0 then

		FAdmin.Messages.SendMessage(ply, 5, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), "(Targets)"))

		return false

	end

	for i = 1, #targets do

		local target = targets[i]

		if FAdmin.Access.PlayerHasPrivilege(ply, "SetMoney", target) then

			DarkRP.storeMoney(target, value)
			target:setDarkRPVar("money", value)

		end

	end

	FAdmin.Messages.FireNotification("setmoney", ply, targets, {value})

	return true, targets, value

end

FAdmin.StartHooks["SetMoney"] = function()

	FAdmin.Messages.RegisterNotification({
		name = "setmoney",
		hasTarget = true,
		receivers = "everyone",
		writeExtraInfo = function(info) net.WriteString(info[1]) end,
		message = {"instigator", " set the money of ", "targets", " to ", "extraInfo.1"},
	})

	FAdmin.Access.AddPrivilege("SetMoney", 2)
	FAdmin.Commands.AddCommand("money", SetMoney)

end