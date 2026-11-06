-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__CoinAssets__1 = game.ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("CoinAssets");
local l__Diamonds__2 = l__CoinAssets__1:FindFirstChild("Diamonds");
local v3 = {
	health = 500, 
	scaleHealth = true, 
	textureID = "", 
	currencyType = "Diamonds", 
	disableScaling = true, 
	disableRandomization = false, 
	disableRandomRewards = true, 
	workScaling = true, 
	totalMult = 0, 
	diamondsMult = 4, 
	specialBonus = {}, 
	orbsRandom = {
		rewardMult = 0, 
		amountMult = 3, 
		speedMult = 1
	}, 
	orbsBreak = {
		rewardMult = 0, 
		amountMult = 3
	}, 
	landSound = "coin", 
	breakSound = "normal", 
	model = l__CoinAssets__1:FindFirstChild("Diamonds"):FindFirstChildWhichIsA("BasePart"), 
	modelHasStages = l__Diamonds__2:FindFirstChild("Stages") ~= nil
};
local v4 = false;
if l__Diamonds__2:FindFirstChild("Stages") ~= nil then
	v4 = l__Diamonds__2:FindFirstChild("Stages"):FindFirstChild("Mid");
end;
v3.modelMidHealth = v4;
local v5 = false;
if l__Diamonds__2:FindFirstChild("Stages") ~= nil then
	v5 = l__Diamonds__2:FindFirstChild("Stages"):FindFirstChild("Low");
end;
v3.modelLowHealth = v5;
v3.world = string.match(script.Parent.Parent.Name, "%a+");
return v3;
