-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__CoinAssets__1 = game.ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("CoinAssets");
local l__Black_Lucky_Block__2 = l__CoinAssets__1:FindFirstChild("Black Lucky Block");
local v3 = {
	health = 8.75E+20, 
	scaleHealth = false, 
	textureID = "", 
	finalRewardMultiplier = 4000, 
	luckyBlockRewards = { { { "Big Currency", 1 }, 25 }, { { "Big Diamonds", 0.125 }, 25 }, { { "Big Boosters", 0.25 }, 25 }, { { "Open Egg", "Super Lucky Egg" }, 25 } }, 
	currencyType = "Diamonds", 
	disableScaling = true, 
	totalMult = 5, 
	diamondsMult = 3, 
	specialBonus = {
		enabled = false
	}, 
	orbsRandom = {
		rewardMult = 0.25, 
		amountMult = 1, 
		speedMult = 2
	}, 
	orbsBreak = {
		rewardMult = 0.25, 
		amountMult = 5
	}, 
	landSound = "luckyblock", 
	breakSound = "great", 
	model = l__CoinAssets__1:FindFirstChild("Black Lucky Block"):FindFirstChildWhichIsA("BasePart"), 
	modelHasStages = l__Black_Lucky_Block__2:FindFirstChild("Stages") ~= nil
};
local v4 = false;
if l__Black_Lucky_Block__2:FindFirstChild("Stages") ~= nil then
	v4 = l__Black_Lucky_Block__2:FindFirstChild("Stages"):FindFirstChild("Mid");
end;
v3.modelMidHealth = v4;
local v5 = false;
if l__Black_Lucky_Block__2:FindFirstChild("Stages") ~= nil then
	v5 = l__Black_Lucky_Block__2:FindFirstChild("Stages"):FindFirstChild("Low");
end;
v3.modelLowHealth = v5;
v3.world = string.match(script.Parent.Parent.Name, "%a+");
return v3;
