-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__CoinAssets__1 = game.ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("CoinAssets");
local l__Magma_Chest__2 = l__CoinAssets__1:FindFirstChild("Magma Chest");
local v3 = {
	health = 200000000, 
	scaleHealth = false, 
	textureID = "", 
	currencyType = "Coins", 
	totalMult = 12, 
	diamondsMult = 4, 
	orbsRandom = {
		rewardMult = 0, 
		amountMult = 2.5, 
		speedMult = 2
	}, 
	orbsBreak = {
		rewardMult = 9, 
		amountMult = 8
	}, 
	landSound = "chest", 
	breakSound = "special", 
	model = l__CoinAssets__1:FindFirstChild("Magma Chest"):FindFirstChildWhichIsA("BasePart"), 
	modelHasStages = l__Magma_Chest__2:FindFirstChild("Stages") ~= nil
};
local v4 = false;
if l__Magma_Chest__2:FindFirstChild("Stages") ~= nil then
	v4 = l__Magma_Chest__2:FindFirstChild("Stages"):FindFirstChild("Mid");
end;
v3.modelMidHealth = v4;
local v5 = false;
if l__Magma_Chest__2:FindFirstChild("Stages") ~= nil then
	v5 = l__Magma_Chest__2:FindFirstChild("Stages"):FindFirstChild("Low");
end;
v3.modelLowHealth = v5;
v3.world = string.match(script.Parent.Parent.Name, "%a+");
return v3;
