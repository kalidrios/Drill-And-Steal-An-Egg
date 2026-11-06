-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__CoinAssets__1 = game.ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("CoinAssets");
local l__Chest__2 = l__CoinAssets__1:FindFirstChild("Chest");
local v3 = {
	health = 25000, 
	scaleHealth = true, 
	textureID = "rbxassetid://6888747214", 
	currencyType = "Coins", 
	totalMult = 8, 
	diamondsMult = 5, 
	orbsRandom = {
		rewardMult = 0.5, 
		amountMult = 3, 
		speedMult = 0.5
	}, 
	orbsBreak = {
		rewardMult = 4, 
		amountMult = 5
	}, 
	landSound = "chest", 
	breakSound = "special", 
	model = l__CoinAssets__1:FindFirstChild("Chest"):FindFirstChildWhichIsA("BasePart"), 
	modelHasStages = l__Chest__2:FindFirstChild("Stages") ~= nil
};
local v4 = false;
if l__Chest__2:FindFirstChild("Stages") ~= nil then
	v4 = l__Chest__2:FindFirstChild("Stages"):FindFirstChild("Mid");
end;
v3.modelMidHealth = v4;
local v5 = false;
if l__Chest__2:FindFirstChild("Stages") ~= nil then
	v5 = l__Chest__2:FindFirstChild("Stages"):FindFirstChild("Low");
end;
v3.modelLowHealth = v5;
v3.world = string.match(script.Parent.Parent.Name, "%a+");
return v3;
