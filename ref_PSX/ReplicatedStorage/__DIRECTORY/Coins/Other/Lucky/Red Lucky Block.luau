-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__CoinAssets__1 = game.ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("CoinAssets");
local l__Red_Lucky_Block__2 = l__CoinAssets__1:FindFirstChild("Red Lucky Block");
local v3 = {
	health = 1200, 
	scaleHealth = true, 
	textureID = "", 
	luckyBlockRewards = { { { "Small Currency", 0.06666666666666667 }, 30 }, { { "Med Currency", 0.3333333333333333 }, 25 }, { { "Big Currency", 1 }, 6.25 }, { { "Random Zone Egg" }, 70 }, { { "Small Diamonds", 0.06666666666666667 }, 25 }, { { "Med Diamonds", 0.3333333333333333 }, 12.5 }, { { "Big Diamonds", 1 }, 3.125 }, { { "Small Boosters", 1 }, 20 }, { { "Med Boosters", 5 }, 5 }, { { "Big Boosters", 15 }, 1.25 }, { { "Open Egg", "Lucky Egg" }, 8 } }, 
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
	model = l__CoinAssets__1:FindFirstChild("Red Lucky Block"):FindFirstChildWhichIsA("BasePart"), 
	modelHasStages = l__Red_Lucky_Block__2:FindFirstChild("Stages") ~= nil
};
local v4 = false;
if l__Red_Lucky_Block__2:FindFirstChild("Stages") ~= nil then
	v4 = l__Red_Lucky_Block__2:FindFirstChild("Stages"):FindFirstChild("Mid");
end;
v3.modelMidHealth = v4;
local v5 = false;
if l__Red_Lucky_Block__2:FindFirstChild("Stages") ~= nil then
	v5 = l__Red_Lucky_Block__2:FindFirstChild("Stages"):FindFirstChild("Low");
end;
v3.modelLowHealth = v5;
v3.world = string.match(script.Parent.Parent.Name, "%a+");
return v3;
