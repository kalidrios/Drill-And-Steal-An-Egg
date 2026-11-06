-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__CoinAssets__1 = game.ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("CoinAssets");
local l__Candy_Canes__2 = l__CoinAssets__1:FindFirstChild("Candy Canes");
local v3 = {
	health = 7500, 
	scaleHealth = true, 
	textureID = "", 
	currencyType = "Gingerbread", 
	disableScaling = false, 
	totalMult = 20, 
	diamondsMult = 2, 
	orbsRandom = {
		rewardMult = 95, 
		amountMult = 2, 
		speedMult = 0.6
	}, 
	orbsBreak = {
		rewardMult = 10, 
		amountMult = 3
	}, 
	landSound = "chest", 
	breakSound = "special", 
	model = l__CoinAssets__1:FindFirstChild("Candy Canes"):FindFirstChildWhichIsA("BasePart"), 
	modelHasStages = l__Candy_Canes__2:FindFirstChild("Stages") ~= nil
};
local v4 = false;
if l__Candy_Canes__2:FindFirstChild("Stages") ~= nil then
	v4 = l__Candy_Canes__2:FindFirstChild("Stages"):FindFirstChild("Mid");
end;
v3.modelMidHealth = v4;
local v5 = false;
if l__Candy_Canes__2:FindFirstChild("Stages") ~= nil then
	v5 = l__Candy_Canes__2:FindFirstChild("Stages"):FindFirstChild("Low");
end;
v3.modelLowHealth = v5;
v3.world = string.match(script.Parent.Parent.Name, "%a+");
return v3;
