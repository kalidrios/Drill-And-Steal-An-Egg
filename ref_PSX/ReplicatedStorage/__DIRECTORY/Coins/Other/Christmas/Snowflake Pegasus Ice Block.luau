-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__Ice_Blocks__1 = game.ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("CoinAssets"):FindFirstChild("Ice Blocks");
local v2 = l__Ice_Blocks__1:FindFirstChild("Snowflake Pegasus Ice Block");
local v3 = {
	health = 87500000000000000, 
	scaleHealth = false, 
	textureID = "", 
	currencyType = "Gingerbread", 
	disableScaling = true, 
	totalMult = 5, 
	diamondsMult = 3, 
	specialBonus = {
		enabled = false
	}, 
	orbsRandom = {
		rewardMult = 0.25, 
		amountMult = 1, 
		speedMult = 2
	}, 
	orbsBreak = {
		rewardMult = 0.25, 
		amountMult = 5
	}, 
	grinchPetId = "446", 
	landSound = "chest", 
	breakSound = "special", 
	model = l__Ice_Blocks__1:FindFirstChild("Snowflake Pegasus Ice Block"):FindFirstChildWhichIsA("BasePart"), 
	modelHasStages = v2:FindFirstChild("Stages") ~= nil
};
local v4 = false;
if v2:FindFirstChild("Stages") ~= nil then
	v4 = v2:FindFirstChild("Stages"):FindFirstChild("Mid");
end;
v3.modelMidHealth = v4;
local v5 = false;
if v2:FindFirstChild("Stages") ~= nil then
	v5 = v2:FindFirstChild("Stages"):FindFirstChild("Low");
end;
v3.modelLowHealth = v5;
v3.world = string.match(script.Parent.Parent.Name, "%a+");
return v3;
