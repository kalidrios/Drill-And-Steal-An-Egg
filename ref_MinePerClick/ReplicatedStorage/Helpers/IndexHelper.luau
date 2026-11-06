-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Databases = game:GetService("ReplicatedStorage"):WaitForChild("Databases")
local ItemsList = require(Databases:WaitForChild("ItemsList"))
local TraitsList = require(Databases:WaitForChild("TraitsList"))

return {
	IsIndexComplete = function(p1, p2) --[[ IsIndexComplete | Line: 11 | Upvalues: ItemsList (copy) ]]
		if type(p2) ~= "table" then
			return false
		end

		for k, v in pairs(ItemsList) do
			if not (v.Unobtainable or table.find(p2, k)) then
				return false
			end
		end

		return true
	end,
	IsTraitIndexComplete = function(p1, p2) --[[ IsTraitIndexComplete | Line: 28 | Upvalues: TraitsList (copy) ]]
		if type(p2) ~= "table" then
			return false
		end

		for k, v in pairs(TraitsList) do
			if not table.find(p2, k) then
				return false
			end
		end

		return true
	end
}