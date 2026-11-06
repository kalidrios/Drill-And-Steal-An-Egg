-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__CoinAssets__1 = game.ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("CoinAssets");
local l__Giant_Present__2 = l__CoinAssets__1:FindFirstChild("Giant Present");
local v3 = {
	health = 75000, 
	scaleHealth = true, 
	textureID = "", 
	currencyType = "Diamonds", 
	disableScaling = true, 
	totalMult = 25, 
	diamondsMult = 5, 
	orbsRandom = {
		rewardMult = 1, 
		amountMult = 3, 
		speedMult = 0.6
	}, 
	orbsBreak = {
		rewardMult = 20, 
		amountMult = 7
	}, 
	landSound = "chest", 
	breakSound = "special", 
	model = l__CoinAssets__1:FindFirstChild("Giant Present"):FindFirstChildWhichIsA("BasePart"), 
	modelHasStages = l__Giant_Present__2:FindFirstChild("Stages") ~= nil
};
local v4 = false;
if l__Giant_Present__2:FindFirstChild("Stages") ~= nil then
	v4 = l__Giant_Present__2:FindFirstChild("Stages"):FindFirstChild("Mid");
end;
v3.modelMidHealth = v4;
local v5 = false;
if l__Giant_Present__2:FindFirstChild("Stages") ~= nil then
	v5 = l__Giant_Present__2:FindFirstChild("Stages"):FindFirstChild("Low");
end;
v3.modelLowHealth = v5;
v3.world = string.match(script.Parent.Parent.Name, "%a+");
return v3;
