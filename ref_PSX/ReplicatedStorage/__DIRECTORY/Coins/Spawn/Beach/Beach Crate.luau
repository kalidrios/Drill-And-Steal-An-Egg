-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__CoinAssets__1 = game.ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("CoinAssets");
local l__Crate__2 = l__CoinAssets__1:FindFirstChild("Crate Tropical");
local v3 = {
	health = 2000, 
	scaleHealth = true, 
	textureID = "", 
	currencyType = "Coins", 
	totalMult = 3.75, 
	diamondsMult = 1, 
	orbsRandom = {
		rewardMult = 0, 
		amountMult = 1.5, 
		speedMult = 1.33
	}, 
	orbsBreak = {
		rewardMult = 0.5, 
		amountMult = 3
	}, 
	landSound = "chest", 
	breakSound = "great", 
	model = l__CoinAssets__1:FindFirstChild("Crate Tropical"):FindFirstChildWhichIsA("BasePart"), 
	modelHasStages = l__Crate__2:FindFirstChild("Stages") ~= nil
};
local v4 = false;
if l__Crate__2:FindFirstChild("Stages") ~= nil then
	v4 = l__Crate__2:FindFirstChild("Stages"):FindFirstChild("Mid");
end;
v3.modelMidHealth = v4;
local v5 = false;
if l__Crate__2:FindFirstChild("Stages") ~= nil then
	v5 = l__Crate__2:FindFirstChild("Stages"):FindFirstChild("Low");
end;
v3.modelLowHealth = v5;
v3.world = string.match(script.Parent.Parent.Name, "%a+");
return v3;
