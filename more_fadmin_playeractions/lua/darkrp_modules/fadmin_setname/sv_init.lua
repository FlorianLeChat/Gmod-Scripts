local function SetName(ply, cmd, args)

	if not FAdmin.Access.PlayerHasPrivilege(ply, "SetName") then

		FAdmin.Messages.SendMessage(ply, 5, "No access!")

		return false

	end

	local playerID = args[1]

	if not playerID then

		FAdmin.Messages.SendMessage(ply, 5, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), "(PlayerID)"))

		return false

	end

	local value = args[2]

	if not value or value == "" then

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

		if FAdmin.Access.PlayerHasPrivilege(ply, "SetName", target) then

			target:setRPName(value)

		end

	end

	FAdmin.Messages.FireNotification("setname", ply, targets, {value})

	return true, targets, value

end

FAdmin.StartHooks["SetName"] = function()

	FAdmin.Messages.RegisterNotification({
		name = "setname",
		hasTarget = true,
		receivers = "everyone",
		writeExtraInfo = function(info) net.WriteString(info[1]) end,
		message = {"instigator", " set the name of ", "targets", " to ", "extraInfo.1"},
	})

	FAdmin.Access.AddPrivilege("SetName", 2)
	FAdmin.Commands.AddCommand("setname", SetName)

end