-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__CoinAssets__1 = game.ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("CoinAssets");
local l__Blue_Lucky_Block__2 = l__CoinAssets__1:FindFirstChild("Blue Lucky Block");
local v3 = {
	health = 850, 
	scaleHealth = true, 
	textureID = "", 
	luckyBlockRewards = { { { "Small Currency", 0.06666666666666667 }, 40 }, { { "Med Currency", 0.3333333333333333 }, 12.5 }, { { "Big Currency", 1 }, 0.78125 }, { { "Random Zone Egg" }, 60 }, { { "Small Diamonds", 0.06666666666666667 }, 25 }, { { "Med Diamonds", 0.3333333333333333 }, 6.25 }, { { "Big Diamonds", 1 }, 0.390625 }, { { "Small Boosters", 1 }, 20 }, { { "Med Boosters", 5 }, 2.5 }, { { "Big Boosters", 15 }, 0.15625 }, { { "Open Egg", "Lucky Egg" }, 7 } }, 
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
	model = l__CoinAssets__1:FindFirstChild("Blue Lucky Block"):FindFirstChildWhichIsA("BasePart"), 
	modelHasStages = l__Blue_Lucky_Block__2:FindFirstChild("Stages") ~= nil
};
local v4 = false;
if l__Blue_Lucky_Block__2:FindFirstChild("Stages") ~= nil then
	v4 = l__Blue_Lucky_Block__2:FindFirstChild("Stages"):FindFirstChild("Mid");
end;
v3.modelMidHealth = v4;
local v5 = false;
if l__Blue_Lucky_Block__2:FindFirstChild("Stages") ~= nil then
	v5 = l__Blue_Lucky_Block__2:FindFirstChild("Stages"):FindFirstChild("Low");
end;
v3.modelLowHealth = v5;
v3.world = string.match(script.Parent.Parent.Name, "%a+");
return v3;
