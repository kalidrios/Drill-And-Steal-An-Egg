-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__CoinAssets__1 = game.ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("CoinAssets");
local l__Clover_Coins_Pot__2 = l__CoinAssets__1:FindFirstChild("Clover Coins Pot");
local v3 = {
	health = 7500, 
	scaleHealth = true, 
	textureID = "", 
	currencyType = "Clover Coins", 
	disableScaling = true, 
	totalMult = 6, 
	diamondsMult = 1, 
	orbsRandom = {
		rewardMult = 0, 
		amountMult = 3, 
		speedMult = 1
	}, 
	orbsBreak = {
		rewardMult = 0, 
		amountMult = 1.5
	}, 
	landSound = "chest", 
	breakSound = "special", 
	model = l__CoinAssets__1:FindFirstChild("Clover Coins Pot"):FindFirstChildWhichIsA("BasePart"), 
	modelHasStages = l__Clover_Coins_Pot__2:FindFirstChild("Stages") ~= nil
};
local v4 = false;
if l__Clover_Coins_Pot__2:FindFirstChild("Stages") ~= nil then
	v4 = l__Clover_Coins_Pot__2:FindFirstChild("Stages"):FindFirstChild("Mid");
end;
v3.modelMidHealth = v4;
local v5 = false;
if l__Clover_Coins_Pot__2:FindFirstChild("Stages") ~= nil then
	v5 = l__Clover_Coins_Pot__2:FindFirstChild("Stages"):FindFirstChild("Low");
end;
v3.modelLowHealth = v5;
v3.world = string.match(script.Parent.Parent.Name, "%a+");
return v3;
