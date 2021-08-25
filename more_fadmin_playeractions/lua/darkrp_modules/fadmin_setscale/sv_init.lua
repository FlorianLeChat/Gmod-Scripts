local minHull = Vector(-16, -16, 0)

local function SetScale(ply, cmd, args)

	if not FAdmin.Access.PlayerHasPrivilege(ply, "SetScale") then

		FAdmin.Messages.SendMessage(ply, 5, "No access!")

		return false

	end

	local playerID = args[1]

	if not playerID then

		FAdmin.Messages.SendMessage(ply, 5, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), "(PlayerID)"))

		return false

	end

	local value = tonumber(args[2]) or 1
	local targets = FAdmin.FindPlayer(args[1]) or {}

	if #targets == 0 then

		FAdmin.Messages.SendMessage(ply, 5, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), "(Targets)"))

		return false

	end

	for i = 1, #targets do

		local target = targets[i]

		if FAdmin.Access.PlayerHasPrivilege(ply, "SetScale", target) then

			target:SetModelScale(value, 0)
			target:SetHull(minHull, Vector(16, 16, 72 * value))

		end

	end

	FAdmin.Messages.FireNotification("setscale", ply, targets, {value})

	return true, targets, value

end

FAdmin.StartHooks["SetScale"] = function()

	FAdmin.Messages.RegisterNotification({
		name = "setscale",
		hasTarget = true,
		receivers = "everyone",
		writeExtraInfo = function(info) net.WriteString(info[1]) end,
		message = {"instigator", " set the scale of ", "targets", " to ", "extraInfo.1"},
	})

	FAdmin.Access.AddPrivilege("SetScale", 2)

	FAdmin.Commands.AddCommand("scale", SetScale)
	FAdmin.Commands.AddCommand("setscale", SetScale)

end