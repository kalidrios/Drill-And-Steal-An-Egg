-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not v1.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end;
local v2 = v1.Network.Invoke("Get OSTime");
local v3 = workspace:GetServerTimeNow();
local v4 = {};
function PromptPurchase(p1)
	local v5 = v1.QuestCmds.GetStock(p1.Name);
	if v5 then
		if v5 <= 0 then
			v1.Message.New("This item is out of stock!");
			return;
		end;
	end;
	if v1.Message.New("Are you sure you want to purchase this for " .. v1.Functions.Commas(p1.Cost) .. " Quest Points?", true) then
		local v6, v7 = v1.QuestCmds.RedeemReward(p1.Name);
		if v6 then
			v1.Message.New("✅ Success!");
			return;
		end;
		v1.Message.New(v7 or "Failed to purchase!");
	end;
end;
local u1 = {};
local u2 = false;
local l__QuestShop__3 = v1.GUI.QuestShop;
function UpdateDiamonds()
	local function v8(p2)
		if u1[p2] then
			return;
		end;
		u1[p2] = true;
		local v9 = v1.Directory.QuestRewards[p2:GetAttribute("Reward")];
		UpdatePriceFrame(p2:FindFirstChild("Price"), v9);
		v1.GUIFX.ButtonFX(p2);
		p2.Activated:Connect(function()
			if not u2 then
				u2 = true;
				PromptPurchase(v9);
				u2 = false;
			end;
		end);
	end;
	for v10, v11, v12 in ipairs(l__QuestShop__3.Container.Diamonds.CurrencyGroup:GetChildren())do
		if v11.ClassName == "TextButton" then
			v8(v11);
		end;	
	end;
end;
local u4 = {};
function UpdateRewards()
	local function v13(p3)
		v1.GUIFX.ButtonFX(p3);
		local u5 = v1.Directory.QuestRewards[p3:GetAttribute("Reward")];
		p3.Activated:Connect(function()
			if not u2 then
				u2 = true;
				PromptPurchase(u5);
				u2 = false;
			end;
		end);
	end;
	for v14, v15 in ipairs(l__QuestShop__3.Rewards:GetChildren())do
		for v17, v18 in ipairs(v15:GetChildren())do
			if v18:GetAttribute("Reward") then
				if not u4[v18] then
					u4[v18] = true;
					v13(v18);
				end;
				UpdatePriceFrame(v18:FindFirstChild("Price"), v1.Directory.QuestRewards[v18:GetAttribute("Reward")]);
			end;		
		end;	
	end;
end;
function UpdatePoints()
	l__QuestShop__3.Points.Text = v1.Functions.Commas(v1.QuestCmds.GetPoints()) .. " Points";
end;
function UpdatePriceFrame(p4, p5)
	local l__Cost__20 = p5.Cost;
	local v21 = v1.QuestCmds.GetStock(p5.Name);
	local l__Points__22 = p4:FindFirstChild("Points");
	if v21 then
		if v21 <= 0 then
			l__Points__22.Text = "Sold Out!";
			return l__Cost__20;
		end;
	end;
	l__Points__22.Text = v1.Functions.Commas(l__Cost__20);
	return l__Cost__20;
end;
function Scrollbar()
	local v23 = l__QuestShop__3.Container:FindFirstChildOfClass("UIPadding");
	l__QuestShop__3.Container.CanvasSize = UDim2.new(0, 0, 0, l__QuestShop__3.Container:FindFirstChildOfClass("UIListLayout").AbsoluteContentSize.Y + v23.PaddingTop.Offset + v23.PaddingBottom.Offset);
end;
function SizeFrame(p4)  
	local v17 = v1.Functions.ResolutionScale();
	local v18 = 1;
	for _, child8 in ipairs(p4:GetChildren()) do
		if child8.ClassName == "UIPadding" then
			local v28 = v1.GUIFX.CacheProperty(child8, "PaddingTop");
			local v29 = v1.GUIFX.CacheProperty(child8, "PaddingBottom");
			child8.PaddingTop = UDim.new(v28.Scale, v28.Offset * v17);
			child8.PaddingBottom = UDim.new(v29.Scale, v29.Offset * v17);
			v18 = v18 + (child8.PaddingTop.Offset + child8.PaddingBottom.Offset);
			continue;
		end
		if child8.ClassName ~= "UIListLayout" and child8.ClassName ~= "UIGridLayout" then continue end
		v18 = v18 + child8.AbsoluteContentSize.Y;
		if child8.ClassName == "UIListLayout" then
			local v30 = v1.GUIFX.CacheProperty(child8, "Padding");
			child8.Padding = UDim.new(v30.Scale, v30.Offset * v17);
		elseif child8.ClassName == "UIGridLayout" then
			local v40 = v1.GUIFX.CacheProperty(child8, "CellPadding");
			child8.CellPadding = UDim2.new(v40.X.Scale, v40.X.Offset * v17, v40.Y.Scale, v40.Y.Offset * v17);
		end
		if child8.ClassName ~= "UIGridLayout" or not child8:FindFirstChildOfClass("UIAspectRatioConstraint") then continue end
		child8.CellSize = UDim2.new(child8.CellSize.X.Scale, child8.CellSize.X.Offset, 0, child8.AbsoluteCellSize.Y + 2);
	end
	p4.Size = UDim2.new(p4.Size.X.Scale, p4.Size.X.Offset, 0, v18);
end
function Scaling()
	if not l__QuestShop__3.Gui.Enabled then
		return;
	end;
	local v34 = game.Workspace.CurrentCamera.ViewportSize.Y <= 1000;
	local v35 
	if v34 then
		v35 = 1.6;
	else
		v35 = 1.2;
	end;
	l__QuestShop__3.Frame:FindFirstChildOfClass("UIAspectRatioConstraint").AspectRatio = v35;
	l__QuestShop__3.Tabs.Size = v34 and UDim2.new(0.365, 0, 0.1, 0) or UDim2.new(0.365, 0, 0.065, 0);
	for v36, v37, v38 in ipairs(l__QuestShop__3.Container:GetChildren())do
		if v37:IsA("GuiObject") then
			for v39, v40, v41 in ipairs(v37:GetChildren())do
				if not v40:FindFirstChildOfClass("UIListLayout") then
					if v40:FindFirstChildOfClass("UIGridLayout") then
						SizeFrame(v40);
					end;
				else
					SizeFrame(v40);
				end;			
			end;
			SizeFrame(v37);
		end;	
	end;
	Scrollbar();
end;
coroutine.wrap(function()
	while true do
		v1.Heartbeat();
		Scaling();	
	end;
end)();
v1.GUIFX.ButtonFX(l__QuestShop__3.Close);
l__QuestShop__3.Close.Activated:Connect(function()
	if not u2 then
		u2 = true;
		l__QuestShop__3.Gui.Enabled = false;
		u2 = false;
	end;
end);
UpdateRewards();
UpdateDiamonds();
UpdatePoints();
v1.Signal.Fired("Stat Changed"):Connect(function(p7)
	if p7 == "Quest Points" then
		UpdateRewards();
		UpdateDiamonds();
		UpdatePoints();
	end;
end);
