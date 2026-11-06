-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
if m_Library.Shared.IsHardcore then return end
local t_Merchant = m_Library.GUI.Merchant;
local bool1 = false;
local u1 = nil;
local u2 = {};
function Buy(p1) -- Line: 37
	--[[
		Upvalues:
			[1] = u2
			[2] = m_Library
	--]]
	local v1 = u2["Level " .. p1];
	if not v1 then return end
	local v2 = m_Library.Message.New("Are you sure you want to purchase this " .. string.lower(v1.itemType) .. " for " .. m_Library.Functions.Commas(v1.price) .. " Diamonds?", true);
	if v2 then
		local v8, v9 = m_Library.Network.Invoke("Buy Merchant Item", p1);
		if not v8 then
			m_Library.Message.New(v9 or "Something went wrong.");
			return;
		end
		m_Library.Audio.Play("rbxassetid://7399584366", script, 1, 1.25);
		m_Library.Message.New("\226\156\133 Purchase successful!");
	end
end
function UpdateLevel() -- Line: 56
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Merchant
	--]]
	local v3 = m_Library.Save.Get();
	if not v3 then return end
	local t_MerchantLevel = v3.MerchantLevel;
	local t_MerchantSales = v3.MerchantSales;
	local v4 = m_Library.Shared.MerchantLevelReq[t_MerchantLevel + 1];
	t_Merchant.Level.Text = "Respect Level " .. m_Library.Functions.ToRomanNum(t_MerchantLevel);
	if v4 then
		local v10 = (t_MerchantSales - m_Library.Shared.MerchantLevelReq[t_MerchantLevel]) / (v4 - m_Library.Shared.MerchantLevelReq[t_MerchantLevel]);
		t_Merchant.LevelBar.Bar.Size = UDim2.new(v10, 0, 1, 0);
		return;
	end
	t_Merchant.LevelBar.Bar.Size = UDim2.new(1, 0, 1, 0);
end
function UpdateTimer() -- Line: 75
	--[[
		Upvalues:
			[1] = u1
			[2] = m_Library
			[3] = t_Merchant
	--]]
	if not u1 then
		local v11, v12 = m_Library.Network.Invoke("Get Merchant Timer");
		if not v11 then
			u1 = nil;
			return;
		end
		local v13 = v12 - v11;
		u1 = os.clock() + v13;
	end
	local v5 = u1 - os.clock();
	if v5 <= 0 then
		t_Merchant.Timer.Text = "Closed";
		return;
	end
	if v5 <= 5 then
		t_Merchant.Timer.Text = "Departing now...";
		return;
	end
	t_Merchant.Timer.Text = "Departs in " .. m_Library.Functions.TimerString(v5);
end
function UpdateItems() -- Line: 98
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u2
			[3] = t_Merchant
	--]]
	ClearItems();
	local v6 = m_Library.Save.Get();
	if not v6 then return end
	local v7 = m_Library.Functions.DictionaryLength(u2) > 0;
	t_Merchant.Container.Visible = v7;
	if not v7 then return end
	for key1, val1 in pairs(u2) do
		if val1.itemType ~= "Pet" then continue end
		local tonumber_ret = tonumber(key1:match("%d+"));
		local v14 = val1.left <= 0;
		local v15 = not v14 and tonumber_ret <= v6.MerchantLevel;
		local FindFirstChild_ret = t_Merchant.Container:FindFirstChild(tonumber_ret);
		local Clone_ret = m_Library.Assets.UI.Inventory.Pet:Clone();
		Clone_ret.Size = UDim2.new(1, 0, 0.7, 0);
		Clone_ret.Position = UDim2.new(0.5, 0, 0.5, 0);
		Clone_ret.AnchorPoint = Vector2.new(0.5, 0.5);
		Clone_ret.Parent = FindFirstChild_ret.Item;
		local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
		UIAspectRatioConstraint.Parent = Clone_ret;
		m_Library.PetUI.Create(Clone_ret, val1.petId, val1.petExtra);
		if v6.MerchantLevel < tonumber_ret then
			FindFirstChild_ret.Locked.Desc.Text = "Respect Level " .. m_Library.Functions.ToRomanNum(tonumber_ret) .. " Required";
		elseif v14 then
			FindFirstChild_ret.Locked.Desc.Text = "Out of Stock";
		end
		FindFirstChild_ret.Locked.Visible = not v15;
		FindFirstChild_ret.Buy.ImageColor3 = v15 and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
		FindFirstChild_ret.CostFrame.Cost.Text = not v14 and m_Library.Functions.NumberShorten(val1.price) or "Offsale";
	end
end
function ClearItems() -- Line: 146
	--[[
		Upvalues:
			[1] = t_Merchant
	--]]
	for _, child2 in ipairs(t_Merchant.Container:GetChildren()) do
		if not child2:FindFirstChild("Item") then continue end
		child2.Item:ClearAllChildren();
	end
end
function SetupButtons() -- Line: 160
	--[[
		Upvalues:
			[1] = t_Merchant
			[2] = m_Library
			[3] = bool1
	--]]
	for _, child3 in ipairs(t_Merchant.Container:GetChildren()) do
		local Buy_ = child3:FindFirstChild("Buy");
		if not Buy_ then continue end
		m_Library.GUIFX.ButtonFX(Buy_);
		Buy_.Activated:Connect(function() -- Line: 165
			--[[
				Upvalues:
					[1] = bool1
					[2] = child3
			--]]
			if not bool1 then
				bool1 = true;
				Buy(tonumber(child3.Name));
				bool1 = false;
			end
		end);
	end
end
SetupButtons();
m_Library.GUIFX.ButtonFX(t_Merchant.Close);
t_Merchant.Close.Activated:Connect(function() -- Line: 179
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_Merchant
	--]]
	if not bool1 then
		bool1 = true;
		t_Merchant.Gui.Enabled = false;
		bool1 = false;
	end
end);
local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 191
	--[[
		Upvalues:
			[1] = t_Merchant
	--]]
	while true do
		if t_Merchant.Gui.Enabled then
			UpdateTimer();
		end
		wait(0.5);
	end
end);
coroutine_wrap_ret();
m_Library.Network.Fired("Merchant Departed"):Connect(function() -- Line: 201
	--[[
		Upvalues:
			[1] = u2
			[2] = u1
			[3] = t_Merchant
	--]]
	u2 = {};
	ClearItems();
	u1 = nil;
	t_Merchant.Gui.Enabled = false;
end);
m_Library.Network.Fired("Merchant Arrival"):Connect(function(_) -- Line: 209
	--[[
		Upvalues:
			[1] = u2
			[2] = m_Library
	--]]
	u2 = m_Library.Network.Invoke("Get Merchant Items");
	UpdateItems();
end);
m_Library.Network.Fired("Merchant Updated"):Connect(function(p2) -- Line: 215
	--[[
		Upvalues:
			[1] = u2
	--]]
	u2 = p2;
	UpdateItems();
end);
m_Library.Signal.Fired("Stat Changed"):Connect(function(p3) -- Line: 221
	if p3 == "MerchantLevel" then
		UpdateItems();
		UpdateLevel();
		return;
	end
	if p3 == "MerchantSales" then
		UpdateLevel();
	end
end);
u2 = m_Library.Network.Invoke("Get Merchant Items");
UpdateItems();
UpdateLevel();
