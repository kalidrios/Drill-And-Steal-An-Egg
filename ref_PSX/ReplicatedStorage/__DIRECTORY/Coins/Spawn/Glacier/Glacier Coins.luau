-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__CoinAssets__1 = game.ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("CoinAssets");
local l__Coins__2 = l__CoinAssets__1:FindFirstChild("Coins");
local v3 = {
	health = 500, 
	scaleHealth = true, 
	textureID = "rbxassetid://129559769873198", 
	currencyType = "Coins", 
	totalMult = 1.65, 
	diamondsMult = 1, 
	orbsRandom = {
		rewardMult = 0, 
		amountMult = 1.25, 
		speedMult = 1
	}, 
	orbsBreak = {
		rewardMult = 0, 
		amountMult = 1.5
	}, 
	landSound = "coin", 
	breakSound = "normal", 
	model = l__CoinAssets__1:FindFirstChild("Coins"):FindFirstChildWhichIsA("BasePart"), 
	modelHasStages = l__Coins__2:FindFirstChild("Stages") ~= nil
};
local v4 = false;
if l__Coins__2:FindFirstChild("Stages") ~= nil then
	v4 = l__Coins__2:FindFirstChild("Stages"):FindFirstChild("Mid");
end;
v3.modelMidHealth = v4;
local v5 = false;
if l__Coins__2:FindFirstChild("Stages") ~= nil then
	v5 = l__Coins__2:FindFirstChild("Stages"):FindFirstChild("Low");
end;
v3.modelLowHealth = v5;
v3.world = string.match(script.Parent.Parent.Name, "%a+");
return v3;
