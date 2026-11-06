-- https://github.com/kalidrios

local _ = {
	[0] = "rbxassetid://6869856569",
	[1] = "rbxassetid://6869856667",
	[2] = "rbxassetid://6869856744",
	[3] = "rbxassetid://6869856835",
	[4] = "rbxassetid://6869856917",
	[5] = "rbxassetid://6869856979"
};
local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_Upgrades = m_Library.GUI.Upgrades;
local Holder = t_Upgrades.Container:FindFirstChild("Holder");
local _ = Random.new();
local bool1 = false;
function Buy(p1) -- Line: 28
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v1, v2 = m_Library.Network.Invoke("Buy Upgrade", p1);
	if not v1 then
		m_Library.Message.New(v2 or "Something went wrong. Try again!");
		return;
	end
	m_Library.Functions.Wait(0.66);
end
function Update() -- Line: 38
	--[[
		Upvalues:
			[1] = m_Library
			[2] = Holder
			[3] = bool1
			[4] = t_Upgrades
	--]]
	local v3 = m_Library.Save.Get();
	if not v3 then return end
	local v4 = 0;
	local v5 = 0;
	for key1, val1 in pairs(m_Library.Directory.Upgrades) do
		if val1.isHalloweenEvent then continue end
		v4 = v4 + 5;
		local v6 = Holder:FindFirstChild(key1);
		if not v6 then
			v6 = m_Library.Assets.UI.Upgrades.Upgrade:Clone();
			v6.Frame.Title.Text = val1.title;
			v6.Frame.Icon.Image = val1.icon;
			v6.Name = key1;
			local v9 = m_Library.Directory.Currency[val1.currency];
			v6.Frame.CostFrame.Currency.Image = v9.ImageOutline;
			v9.Gradient:Clone().Parent = v6.Frame.CostFrame.Cost;
			v6.Buy.Activated:Connect(function() -- Line: 67
				--[[
					Upvalues:
						[1] = bool1
						[2] = key1
				--]]
				if not bool1 then
					bool1 = true;
					Buy(key1);
					bool1 = false;
				end
			end);
			m_Library.GUIFX.ButtonFX(v6.Buy);
			v6.Parent = Holder;
		end
		local v7 = v3.Upgrades[key1] or 0;
		local v8 = val1.prices[v7 + 1];
		v6.Frame.CostFrame.Cost.Text = v8 and m_Library.Functions.NumberShorten(v8) or "Maxed";
		for _, child2 in ipairs(v6.Frame.Bars:GetChildren()) do
			if child2.ClassName ~= "ImageLabel" then continue end
			child2.Image = child2.LayoutOrder <= v7 and "rbxassetid://7055997958" or "rbxassetid://7055998070";
		end
		v5 = v5 + v7;
	end
	t_Upgrades.Completed.Text = math.round(v5 / v4 * 100) .. "% Complete";
	local UIListLayout = Holder:FindFirstChildOfClass("UIListLayout");
	local UIPadding = Holder:FindFirstChildOfClass("UIPadding");
	UIListLayout:ApplyLayout();
	Holder.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset);
end
t_Upgrades.Close.Activated:Connect(function() -- Line: 110
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_Upgrades
	--]]
	if not bool1 then
		bool1 = true;
		t_Upgrades.Gui.Enabled = false;
		bool1 = false;
	end
end);
m_Library.Signal.Fired("Open Upgrades"):Connect(function() -- Line: 119
	--[[
		Upvalues:
			[1] = t_Upgrades
	--]]
	t_Upgrades.Gui.Enabled = true;
end);
m_Library.GUIFX.ButtonFX(t_Upgrades.Close);
Update();
m_Library.Signal.Fired("Stat Changed"):Connect(function(p2) -- Line: 132
	if p2 == "Upgrades" then
		Update();
	end
end);
