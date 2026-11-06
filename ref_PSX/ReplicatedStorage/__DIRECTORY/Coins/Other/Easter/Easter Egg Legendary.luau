-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__CoinAssets__1 = game.ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("CoinAssets");
local l__Easter_Egg_Legendary__2 = l__CoinAssets__1:FindFirstChild("Easter Egg Legendary");
local v3 = {
	health = 5E+17, 
	scaleHealth = false, 
	textureID = "", 
	eggReward = "Best Easter Egg", 
	currencyType = "Diamonds", 
	disableScaling = true, 
	totalMult = 25, 
	diamondsMult = 3, 
	orbsRandom = {
		rewardMult = 0.25, 
		amountMult = 1, 
		speedMult = 2
	}, 
	orbsBreak = {
		rewardMult = 0.25, 
		amountMult = 5
	}, 
	landSound = "", 
	breakSound = "easteregg", 
	model = l__CoinAssets__1:FindFirstChild("Easter Egg Legendary"):FindFirstChildWhichIsA("BasePart"), 
	modelHasStages = l__Easter_Egg_Legendary__2:FindFirstChild("Stages") ~= nil
};
local v4 = false;
if l__Easter_Egg_Legendary__2:FindFirstChild("Stages") ~= nil then
	v4 = l__Easter_Egg_Legendary__2:FindFirstChild("Stages"):FindFirstChild("Mid");
end;
v3.modelMidHealth = v4;
local v5 = false;
if l__Easter_Egg_Legendary__2:FindFirstChild("Stages") ~= nil then
	v5 = l__Easter_Egg_Legendary__2:FindFirstChild("Stages"):FindFirstChild("Low");
end;
v3.modelLowHealth = v5;
v3.world = string.match(script.Parent.Parent.Name, "%a+");
return v3;
