-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	MaxBackpackSize = 15,
	MaxWalkspeed = 50,
	GetBackpackUpgradeCost = function(p1, p2) --[[ GetBackpackUpgradeCost | Line: 5 ]]
		return math.floor(2.85 ^ math.max(p2 - 3, 0) * 180000)
	end,
	GetWalkspeedUpgradeCost = function(p1, p2) --[[ GetWalkspeedUpgradeCost | Line: 15 ]]
		return math.floor(10000 * 1.4 ^ p2)
	end
}