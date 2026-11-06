-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {
	StartingLevelAmount = 45,
	StartingMaxLevel = 25,
	Growth = 1.095
}

function t.GetLevel(p1, p2) --[[ GetLevel | Line: 7 | Upvalues: t (copy) ]]
	local StartingLevelAmount = t.StartingLevelAmount
	local sum = 0
	local count = 1

	while math.floor(sum + StartingLevelAmount) <= p2 do
		sum = sum + StartingLevelAmount
		StartingLevelAmount = StartingLevelAmount * t.Growth
		count = count + 1
	end

	return count, p2 - math.floor(sum), math.floor(StartingLevelAmount)
end
function t.GetStrengthForLevel(p1, p2) --[[ GetStrengthForLevel | Line: 23 | Upvalues: t (copy) ]]
	local StartingLevelAmount = t.StartingLevelAmount
	local sum = 0

	for i = 1, p2 - 1 do
		sum = sum + math.floor(StartingLevelAmount)
		StartingLevelAmount = StartingLevelAmount * t.Growth
	end

	return sum
end
function t.GetRequiredRebirthLevel(p1, p2) --[[ GetRequiredRebirthLevel | Line: 35 | Upvalues: t (copy) ]]
	return t.StartingMaxLevel + p2 * t.StartingMaxLevel
end
function t.GetCashMultiplier(p1, p2) --[[ GetCashMultiplier | Line: 39 ]]
	return 1 + p2 * 0.2
end
function t.GetStrengthMultiplier(p1, p2) --[[ GetStrengthMultiplier | Line: 45 ]]
	return 1 + p2 * 0.5
end

local Utils = game:GetService("ReplicatedStorage"):WaitForChild("Utils")
local Formatting = require(Utils:WaitForChild("Formatting"))

function t.PrintSimulation(p1) --[[ PrintSimulation | Line: 55 | Upvalues: Formatting (copy) ]]
	for i = 1, 17 do
		local v1 = p1:GetRequiredRebirthLevel(i - 1)

		print((("Rebirth %* (Level %*): %*"):format(i, v1, (Formatting:FormatNumber((math.floor((p1:GetStrengthForLevel(v1)))))))))
	end
end
game:GetService("RunService"):IsStudio()

return t