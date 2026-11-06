-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__CoinAssets__1 = game.ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("CoinAssets");
local l__Super_Chest__2 = l__CoinAssets__1:FindFirstChild("Super Chest");
local v3 = {
	health = 500000, 
	textureID = "", 
	currencyType = "Coins", 
	totalMult = 3.5, 
	diamondsMult = 5, 
	orbsRandom = {
		rewardMult = 1, 
		amountMult = 1, 
		speedMult = 1.75
	}, 
	orbsBreak = {
		rewardMult = 3, 
		amountMult = 25
	}, 
	landSound = "special", 
	breakSound = "special", 
	model = l__CoinAssets__1:FindFirstChild("Super Chest"):FindFirstChildWhichIsA("BasePart"), 
	modelHasStages = l__Super_Chest__2:FindFirstChild("Stages") ~= nil
};
local v4 = false;
if l__Super_Chest__2:FindFirstChild("Stages") ~= nil then
	v4 = l__Super_Chest__2:FindFirstChild("Stages"):FindFirstChild("Mid");
end;
v3.modelMidHealth = v4;
local v5 = false;
if l__Super_Chest__2:FindFirstChild("Stages") ~= nil then
	v5 = l__Super_Chest__2:FindFirstChild("Stages"):FindFirstChild("Low");
end;
v3.modelLowHealth = v5;
v3.world = string.match(script.Parent.Parent.Name, "%a+");
return v3;