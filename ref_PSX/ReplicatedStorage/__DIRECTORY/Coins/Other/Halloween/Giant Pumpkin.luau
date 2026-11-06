-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__CoinAssets__1 = game.ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("CoinAssets");
local l__Giant_Pumpkin__2 = l__CoinAssets__1:FindFirstChild("Giant Pumpkin");
local v3 = {
	health = 125000, 
	scaleHealth = true, 
	textureID = "", 
	currencyType = "Halloween Candy", 
	disableScaling = false, 
	totalMult = 750, 
	diamondsMult = 5, 
	orbsRandom = {
		rewardMult = 1, 
		amountMult = 2.5, 
		speedMult = 0.5
	}, 
	orbsBreak = {
		rewardMult = 5000, 
		amountMult = 10
	}, 
	landSound = "chest", 
	breakSound = "special", 
	model = l__CoinAssets__1:FindFirstChild("Giant Pumpkin"):FindFirstChildWhichIsA("BasePart"), 
	modelHasStages = l__Giant_Pumpkin__2:FindFirstChild("Stages") ~= nil
};
local v4 = false;
if l__Giant_Pumpkin__2:FindFirstChild("Stages") ~= nil then
	v4 = l__Giant_Pumpkin__2:FindFirstChild("Stages"):FindFirstChild("Mid");
end;
v3.modelMidHealth = v4;
local v5 = false;
if l__Giant_Pumpkin__2:FindFirstChild("Stages") ~= nil then
	v5 = l__Giant_Pumpkin__2:FindFirstChild("Stages"):FindFirstChild("Low");
end;
v3.modelLowHealth = v5;
v3.world = string.match(script.Parent.Parent.Name, "%a+");
return v3;
