-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not v1.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end;
local u1 = false;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = v1.Player.PlayerGui();
function PurchasePending()
	if u1 then
		return;
	end;
	u1 = true;
	u2 = script:FindFirstChild("Purchase Pending"):Clone();
	u3 = v1.GIF.Create(u2.Frame.GIF, { 100, 100 }, { 5, 6 }, 28, 0.65, true);
	u4 = Instance.new("BlurEffect");
	u4.Size = 0;
	u4.Name = "PurchasePendingBlur";
	u4.Parent = game.Lighting;
	u2.Frame.BackgroundTransparency = 1;
	u2.Parent = u5;
	v1.Functions.Tween(u4, {
		Size = 20
	}, { 0.25, "Sine", "Out" });
	v1.Functions.Tween(u2.Frame, {
		BackgroundTransparency = 0.5
	}, { 0.2, "Expo", "Out" });
	v1.Functions.Tween(u2.Frame.GIF, {
		ImageTransparency = 0
	}, { 0.2, "Expo", "Out" });
end;
function Close()
	if not u1 then
		return;
	end;
	u3();
	v1.Functions.Tween(u2.Frame.GIF, {
		ImageTransparency = 1
	}, { 0.3, "Expo", "Out" });
	v1.Functions.Tween(u2.Frame, {
		BackgroundTransparency = 1
	}, { 0.3, "Expo", "Out" }).Completed:Connect(function()
	end);

	pcall(function()
		u2:Destroy()
		u4:Destroy()
	end)

	u1 = false;
	u2 = nil;
	u3 = nil;
end;
v1.Network.Fired("Process Pending Start"):Connect(function()
	PurchasePending();
end);
v1.Network.Fired("Process Pending Stop"):Connect(function()
	Close();
end);
v1.MarketplaceService.PromptGamePassPurchaseFinished:Connect(function()
	Close();
end);
v1.MarketplaceService.PromptProductPurchaseFinished:Connect(function()
	Close();
end);
v1.MarketplaceService.PromptPurchaseFinished:Connect(function()
	Close();
end);
v1.MarketplaceService.PromptPremiumPurchaseFinished:Connect(function()
	Close();
end);
