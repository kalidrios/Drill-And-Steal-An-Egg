-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__CoinAssets__1 = game.ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("CoinAssets");
local l__Massive_Comet__2 = l__CoinAssets__1:FindFirstChild("Massive Comet");
local v3 = {
	health = 1000000000, 
	scaleHealth = false, 
	instantSpawn = true, 
	textureID = "", 
	currencyType = "Diamonds", 
	disableScaling = true, 
	totalMult = 1, 
	diamondsMult = 1, 
	specialBonus = {
		enabled = false
	}, 
	orbsRandom = {
		rewardMult = 1, 
		amountMult = 1, 
		speedMult = 1
	}, 
	orbsBreak = {
		rewardMult = 1, 
		amountMult = 1
	}, 
	landSound = "coin", 
	breakSound = "special", 
	model = l__CoinAssets__1:FindFirstChild("Massive Comet"):FindFirstChildWhichIsA("BasePart"), 
	modelHasStages = l__Massive_Comet__2:FindFirstChild("Stages") ~= nil
};
local v4 = false;
if l__Massive_Comet__2:FindFirstChild("Stages") ~= nil then
	v4 = l__Massive_Comet__2:FindFirstChild("Stages"):FindFirstChild("Mid");
end;
v3.modelMidHealth = v4;
local v5 = false;
if l__Massive_Comet__2:FindFirstChild("Stages") ~= nil then
	v5 = l__Massive_Comet__2:FindFirstChild("Stages"):FindFirstChild("Low");
end;
v3.modelLowHealth = v5;
v3.world = string.match(script.Parent.Parent.Name, "%a+");
return v3;
