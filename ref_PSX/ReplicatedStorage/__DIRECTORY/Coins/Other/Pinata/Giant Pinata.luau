-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__CoinAssets__1 = game.ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("CoinAssets");
local l__Giant_Pinata__2 = l__CoinAssets__1:FindFirstChild("Giant Pinata");
local v3 = {};
if game:GetService("RunService"):IsStudio() then
	local v4 = 3;
else
	v4 = 9.375E+22;
end;
v3.health = v4;
v3.scaleHealth = false;
v3.textureID = "";
v3.finalRewardMultiplier = 25;
v3.luckyBlockRewards = { { { "Big Currency", 1 }, 25 }, { { "Big Diamonds", 0.5 }, 25 }, { { "Small Boosters", 0.25 }, 25 }, { { "Open Egg", "Giant Pinata Egg" }, 25 } };
v3.currencyType = "Diamonds";
v3.disableScaling = true;
v3.totalMult = 5;
v3.diamondsMult = 3;
v3.specialBonus = {
	enabled = false
};
v3.orbsRandom = {
	rewardMult = 0.25, 
	amountMult = 1, 
	speedMult = 2
};
v3.orbsBreak = {
	rewardMult = 0.25, 
	amountMult = 5
};
v3.landSound = "luckyblock";
v3.breakSound = "great";
v3.model = l__CoinAssets__1:FindFirstChild("Giant Pinata"):FindFirstChildWhichIsA("BasePart");
v3.modelHasStages = l__Giant_Pinata__2:FindFirstChild("Stages") ~= nil;
local v5 = false;
if l__Giant_Pinata__2:FindFirstChild("Stages") ~= nil then
	v5 = l__Giant_Pinata__2:FindFirstChild("Stages"):FindFirstChild("Mid");
end;
v3.modelMidHealth = v5;
local v6 = false;
if l__Giant_Pinata__2:FindFirstChild("Stages") ~= nil then
	v6 = l__Giant_Pinata__2:FindFirstChild("Stages"):FindFirstChild("Low");
end;
v3.modelLowHealth = v6;
v3.world = string.match(script.Parent.Parent.Name, "%a+");
return v3;
