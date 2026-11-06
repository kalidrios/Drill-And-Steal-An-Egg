-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__CoinAssets__1 = game.ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("CoinAssets");
local l__Rainbow_Fruit__2 = l__CoinAssets__1:FindFirstChild("Rainbow Fruit");
local v3 = {
	health = 500, 
	scaleHealth = true, 
	textureID = "", 
	currencyType = "Diamonds", 
	disableScaling = true, 
	totalMult = 5, 
	diamondsMult = 3, 
	specialBonus = {
		enabled = false
	}, 
	orbsRandom = {
		rewardMult = 0.25, 
		amountMult = 1.5, 
		speedMult = 1.5
	}, 
	orbsBreak = {
		rewardMult = 0.25, 
		amountMult = 3
	}, 
	landSound = "coin", 
	breakSound = "fruit", 
	breakSoundMultiplier = 3, 
	model = l__CoinAssets__1:FindFirstChild("Rainbow Fruit"):FindFirstChildWhichIsA("BasePart"), 
	modelHasStages = l__Rainbow_Fruit__2:FindFirstChild("Stages") ~= nil
};
local v4 = false;
if l__Rainbow_Fruit__2:FindFirstChild("Stages") ~= nil then
	v4 = l__Rainbow_Fruit__2:FindFirstChild("Stages"):FindFirstChild("Mid");
end;
v3.modelMidHealth = v4;
local v5 = false;
if l__Rainbow_Fruit__2:FindFirstChild("Stages") ~= nil then
	v5 = l__Rainbow_Fruit__2:FindFirstChild("Stages"):FindFirstChild("Low");
end;
v3.modelLowHealth = v5;
v3.world = string.match(script.Parent.Parent.Name, "%a+");
return v3;
