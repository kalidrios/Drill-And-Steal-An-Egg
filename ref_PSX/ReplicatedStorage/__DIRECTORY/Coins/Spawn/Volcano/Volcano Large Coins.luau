-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__CoinAssets__1 = game.ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("CoinAssets");
local l__Large_Coins__2 = l__CoinAssets__1:FindFirstChild("Large Coins");
local v3 = {
	health = 1200, 
	scaleHealth = true, 
	textureID = "rbxassetid://122705318634544", 
	currencyType = "Coins", 
	totalMult = 2.25, 
	diamondsMult = 1, 
	orbsRandom = {
		rewardMult = 0, 
		amountMult = 1.5, 
		speedMult = 1
	}, 
	orbsBreak = {
		rewardMult = 0.35, 
		amountMult = 2.5
	}, 
	landSound = "coin", 
	breakSound = "good", 
	model = l__CoinAssets__1:FindFirstChild("Large Coins"):FindFirstChildWhichIsA("BasePart"), 
	modelHasStages = l__Large_Coins__2:FindFirstChild("Stages") ~= nil
};
local v4 = false;
if l__Large_Coins__2:FindFirstChild("Stages") ~= nil then
	v4 = l__Large_Coins__2:FindFirstChild("Stages"):FindFirstChild("Mid");
end;
v3.modelMidHealth = v4;
local v5 = false;
if l__Large_Coins__2:FindFirstChild("Stages") ~= nil then
	v5 = l__Large_Coins__2:FindFirstChild("Stages"):FindFirstChild("Low");
end;
v3.modelLowHealth = v5;
v3.world = string.match(script.Parent.Parent.Name, "%a+");
return v3;
