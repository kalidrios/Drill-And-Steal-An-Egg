-- kalidrios was here --


-- | load library | --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = ReplicatedStorage:WaitForChild("Library")
local ClientLibrary = Library:WaitForChild("Client")
local Modules = Library:WaitForChild("Modules")
local Types = Library:WaitForChild("Types")

-- | load modules | --
local Directory = require(Library.Directory)
local Pets = require(Modules.Pets)
local Variables = require(Library.Shared.Variables)

-- Calculate Yeet Power based on strength
local function CalculateYeetPowerFromStrength(strength)
	local normalizedStrength = strength / 3e16
	local scaledStrength = normalizedStrength * 1000000
	return math.max(25000, math.round(scaledStrength))
end

-- Calculate Yeet Power of a pet
local function GetYeetPower(pet, companions)
	local petData = Directory.Pets[pet.id]
	local companionPower = 0
	
	if not petData then
		return 0
	end
	
	if companions then
		for _, companion in ipairs(companions) do
			local companionData = Directory.Pets[companion.id]
			if not companionData.huge and not companionData.titanic and not companionData.companionEnchantLevel then
				local companionYeetPower = GetYeetPower(companion)
				companionPower = math.max(companionPower, companionYeetPower)
			end
		end
	end	
	
	if petData.companionEnchantLevel then
		if not companions then
			return 0
		end

		local enchantLevelFactors = {0.2, 0.3, 0.5}
		local enchantFactor = enchantLevelFactors[petData.companionEnchantLevel]
		return math.max(25000, math.round(companionPower * enchantFactor))
	elseif petData.huge then
		if not companions then
			return 0
		end
 
		return math.max(25000, math.round(companionPower * 0.7))
	elseif petData.titanic then
		if not companions then
			return 0
		end

		return math.max(25000, math.round(companionPower * 0.85))
	elseif petData.yeetPower then
		local yeetPower = petData.yeetPower
		if pet.g then
			yeetPower = yeetPower * Variables.PetTypeMult.Golden
		elseif pet.r then
			yeetPower = yeetPower * Variables.PetTypeMult.Rainbow
		elseif pet.dm then
			yeetPower = yeetPower * Variables.PetTypeMult["Dark Matter"]
		end
		if pet.sh then
			yeetPower = yeetPower * Variables.PetTypeMult.Shiny
		end
		return yeetPower
	end
	--
	return CalculateYeetPowerFromStrength(pet.s or 0)
end

return GetYeetPower