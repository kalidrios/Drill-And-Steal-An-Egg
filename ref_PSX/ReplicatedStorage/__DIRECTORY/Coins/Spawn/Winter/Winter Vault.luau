-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__CoinAssets__1 = game.ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("CoinAssets");
local l__Vault__2 = l__CoinAssets__1:FindFirstChild("Vault Ice");
local v3 = {
	health = 20000, 
	scaleHealth = true, 
	textureID = "", 
	currencyType = "Coins", 
	totalMult = 9, 
	diamondsMult = 1, 
	orbsRandom = {
		rewardMult = 0, 
		amountMult = 2.5, 
		speedMult = 0.66
	}, 
	orbsBreak = {
		rewardMult = 3, 
		amountMult = 5
	}, 
	landSound = "vault", 
	breakSound = "great", 
	model = l__CoinAssets__1:FindFirstChild("Vault Ice"):FindFirstChildWhichIsA("BasePart"), 
	modelHasStages = l__Vault__2:FindFirstChild("Stages") ~= nil
};
local v4 = false;
if l__Vault__2:FindFirstChild("Stages") ~= nil then
	v4 = l__Vault__2:FindFirstChild("Stages"):FindFirstChild("Mid");
end;
v3.modelMidHealth = v4;
local v5 = false;
if l__Vault__2:FindFirstChild("Stages") ~= nil then
	v5 = l__Vault__2:FindFirstChild("Stages"):FindFirstChild("Low");
end;
v3.modelLowHealth = v5;
v3.world = string.match(script.Parent.Parent.Name, "%a+");
return v3;
