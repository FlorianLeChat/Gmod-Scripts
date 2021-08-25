util.AddNetworkString("DeathReport")

hook.Add("PlayerDeath", "DeathReport", function(victim, inflictor, attacker)
	if victim ~= attacker and victim:IsPlayer() and attacker:IsPlayer() then
		net.Start("DeathReport")
		net.Send(victim)
	end
end)