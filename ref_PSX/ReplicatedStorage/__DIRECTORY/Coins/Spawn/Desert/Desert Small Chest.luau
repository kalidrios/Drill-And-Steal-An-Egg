-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__CoinAssets__1 = game.ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("CoinAssets");
local l__Small_Chest__2 = l__CoinAssets__1:FindFirstChild("Small Chest");
local v3 = {
	health = 10000, 
	scaleHealth = true, 
	textureID = "rbxassetid://6888123497", 
	currencyType = "Coins", 
	totalMult = 7, 
	diamondsMult = 5, 
	orbsRandom = {
		rewardMult = 0.25, 
		amountMult = 3, 
		speedMult = 0.5
	}, 
	orbsBreak = {
		rewardMult = 1.5, 
		amountMult = 5
	}, 
	landSound = "chest", 
	breakSound = "great", 
	model = l__CoinAssets__1:FindFirstChild("Small Chest"):FindFirstChildWhichIsA("BasePart"), 
	modelHasStages = l__Small_Chest__2:FindFirstChild("Stages") ~= nil
};
local v4 = false;
if l__Small_Chest__2:FindFirstChild("Stages") ~= nil then
	v4 = l__Small_Chest__2:FindFirstChild("Stages"):FindFirstChild("Mid");
end;
v3.modelMidHealth = v4;
local v5 = false;
if l__Small_Chest__2:FindFirstChild("Stages") ~= nil then
	v5 = l__Small_Chest__2:FindFirstChild("Stages"):FindFirstChild("Low");
end;
v3.modelLowHealth = v5;
v3.world = string.match(script.Parent.Parent.Name, "%a+");
return v3;
