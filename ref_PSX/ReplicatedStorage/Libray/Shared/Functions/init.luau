-- https://github.com/kalidrios

local table1 = {
	PromptPurchase = require(script.PromptPurchase), 
	IsInTransaction = require(script.IsInTransaction), 
	ComputeSaveAge = require(script.ComputeSaveAge), 
	SignalStatUpdated = require(script.SignalStatUpdated), 
	MasteryLevelToXP = require(script.MasteryLevelToXP), 
	MasteryXPToLevel = require(script.MasteryXPToLevel), 
	GetMaxEquippedSlots = require(script.GetMaxEquippedSlots), 
	HasPetEquipped = require(script.HasPetEquipped), 
	GetPetEgg = require(script.GetPetEgg), 
	GetPetChance = require(script.GetPetChance), 
	PetInEgg = require(script.PetInEgg), 
	GetAllCollectablePets = require(script.GetAllCollectablePets), 
	GetPowerDir = require(script.GetPowerDir), 
	HasPower = require(script.HasPower), 
	GetDMSkipProduct = require(script.GetDMSkipProduct), 
	GetHugeMachineProduct = require(script.GetHugeMachineProduct), 
	ComputeHugeMachinePoints = require(script.ComputeHugeMachinePoints), 
	ComputeEventMachinePoints = require(script.ComputeEventMachinePoints), 
	ComputeEvolveMachinePets = require(script.ComputeEvolveMachinePets), 
	ApplyRarityColor = require(script.ApplyRarityColor), 
	PetTypeIndex = require(script.PetTypeIndex), 
	PetOrderBest = require(script.PetOrderBest), 
	PetOrderParty = require(script.PetOrderParty), 
	PetOrderInv = require(script.PetOrderInv), 
	SortPets = require(script.SortPets), 
	ValidateInteractable = require(script.ValidateInteractable), 
	ValidateEgg = require(script.ValidateEgg), 
	ValidateGate = require(script.ValidateGate), 
	ShowPetExists = require(script.ShowPetExists), 
	ValidateDistanceGeneric = require(script.ValidateDistanceGeneric), 
	ValidateCannon = require(script.ValidateCannon), 
	ValidateBooth = require(script.ValidateBooth), 
	HatchMessage = require(script.HatchMessage), 
	DaycareComparePossibleLoot = require(script.DaycareComparePossibleLoot), 
	DaycareComputeRemainingTime = require(script.DaycareComputeRemainingTime), 
	DaycareComputeSlotsForTier = require(script.DaycareComputeSlotsForTier), 
	ComputePetStrength = require(script.ComputePetStrength), 
	CanAuctionPet = require(script.CanAuctionPet), 
	CanAuctionPetDir = require(script.CanAuctionPetDir), 
	PetName = require(script.PetName), 
	PetNameShort = require(script.PetNameShort), 
	HasProTradingAccess = require(script.HasProTradingAccess), 
	ScavengerEggCFrameToString = require(script.ScavengerEggCFrameToString), 
	GetSave = require(script.GetSave), 
	CanAccessDiamondMine = require(script.CanAccessDiamondMine), 
	OwnsGamepass = require(script.OwnsGamepass),
	GetAllBloombergPets = require(script.GetAllBloombergPets),
	GetYeetPower = require(script.GetYeetPower),
	PetOrderYeet = require(script.PetOrderYeet)
};
local v1 = "";
for _, child1 in ipairs(script:GetChildren()) do
	if not child1:IsA("ModuleScript") or table1[child1.Name] ~= nil then continue end
	v1 = v1 .. string.format("%s = require(script.%s),\n", child1.Name, child1.Name);
end
if #v1 > 0 then
	warn(string.format("Unadded entries: \n\n%s\n", v1));
end
for key2, _ in pairs(table1) do
	if script:FindFirstChild(key2) then continue end
	warn(string.format("Unknown entry: %s", tostring(key2)));
end
for _, child3 in ipairs(script:GetChildren()) do
	if not child3:IsA("ModuleScript") or table1[child3.Name] ~= nil then continue end
	table1[child3.Name] = require(child3);
end
return table1;
