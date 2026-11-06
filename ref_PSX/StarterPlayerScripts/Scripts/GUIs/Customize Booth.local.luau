-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_BoothCustomize = m_Library.GUI.BoothCustomize;
local bool1 = false;
function getBoothStyle(p1) -- Line: 21
	return p1 or "Default Booth";
end
function Update() -- Line: 26
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_BoothCustomize
			[3] = bool1
	--]]
	local v1 = m_Library.Save.Get();
	if not v1 then return end
	assert(v1);
	local t_Booths = t_BoothCustomize.Main.Booths;
	local t_Booth = t_Booths.Booth;
	t_Booth.Visible = false;
	local v2 = v1.TradingBoothStyles or {};
	for key1, val1 in pairs(m_Library.Directory.Booths) do
		local v4 = t_Booths:FindFirstChild(key1);
		if not v4 then
			if val1.OffSale and not m_Library.Functions.SearchArray(v2, key1) then continue end
			v4 = t_Booth:Clone();
			v4.Visible = true;
			v4.Name = key1;
			v4.BoothIcon.Image = val1.Icon;
			v4.LayoutOrder = val1.Order;
			v4.Parent = t_Booths;
			local function Clicked() -- Line: 56
				--[[
					Upvalues:
						[1] = m_Library
						[2] = key1
						[3] = val1
				--]]
				local v7 = m_Library.Save.Get();
				if not v7 then return end
				assert(v7);
				local v8 = v7.TradingBoothStyles or {};
				if key1 ~= "Default Booth" and not m_Library.Functions.SearchArray(v8, key1) then
					if val1.ProductId then
						m_Library.Shared.PromptPurchase(val1.ProductId, true);
						return;
					end
					if val1.RequirementMessage then
						m_Library.Message.New(val1.RequirementMessage);
						return;
					end
					if val1.DiamondPrice then
						local v11 = "Buy " .. val1.DisplayName .. " for " .. m_Library.Functions.Commas(val1.DiamondPrice) .. " Diamonds?";
						local v12 = m_Library.Message.New(v11, true);
						if v12 then
							local v13, v14 = m_Library.Network.Invoke("Purchase Booth Style", key1);
							if not v13 then
								m_Library.Message.New(v14 or "Something went wrong!");
								return;
							end
							m_Library.Signal.Fire("Notification", "Success! \226\156\133", {
								color = Color3.fromRGB(105, 255, 168),
								sound = "rbxassetid://11648890466"
							});
						end
					end
				else
					local v9, v10 = m_Library.Network.Invoke("Change Booth Style", key1);
					if not v9 and v10 then
						m_Library.Message.New(v10);
					end
					Update();
				end
			end
			v4.Activated:Connect(function() -- Line: 92
				--[[
					Upvalues:
						[1] = bool1
						[2] = Clicked
				--]]
				if not bool1 then
					bool1 = true;
					Clicked();
					bool1 = false;
				end
			end);
			m_Library.GUIFX.ButtonFX(v4);
		end
		local v5 = v1.TradingBoothStyles or {};
		v4.Equipped.Visible = getBoothStyle(v1.SelectedTradingBooth) == key1;
		if key1 == "Default Booth" then continue end
		v4.Locked.Visible = not m_Library.Functions.SearchArray(v5, key1);
	end
	Scrolling();
end
function Scrolling() -- Line: 115
	--[[
		Upvalues:
			[1] = t_BoothCustomize
			[2] = m_Library
	--]]
	local t_Booths2 = t_BoothCustomize.Main.Booths;
	local UIGridLayout = t_Booths2:FindFirstChildOfClass("UIGridLayout");
	local UIPadding = t_Booths2:FindFirstChildOfClass("UIPadding");
	local _ = m_Library.Functions.ResolutionScale();
	UIGridLayout.CellPadding = UDim2.new(0, 20, 0, 20);
	local v3 = (t_Booths2.AbsoluteSize.X - t_Booths2.ScrollBarThickness - UIPadding.PaddingLeft.Offset - UIPadding.PaddingRight.Offset) / 4 - UIGridLayout.CellPadding.X.Offset;
	local udim2 = UDim2.new(0, v3, 0, v3);
	UIGridLayout.CellSize = udim2;
	UIGridLayout:ApplyLayout();
	t_Booths2.CanvasSize = UDim2.new(0, UIGridLayout.AbsoluteContentSize.X, 0, UIGridLayout.AbsoluteContentSize.Y + 65);
end
m_Library.GUIFX.ButtonFX(t_BoothCustomize.Close);
t_BoothCustomize.Close.Activated:Connect(function() -- Line: 151
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_BoothCustomize
	--]]
	if not bool1 then
		bool1 = true;
		t_BoothCustomize.Gui.Enabled = false;
		bool1 = false;
	end
end);
Update();
Scrolling();
m_Library.Signal.Fired("Stat Changed"):Connect(function(p2) -- Line: 167
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_BoothCustomize
	--]]
	if p2 == "TradingBoothStyles" then
		local v6 = m_Library.Save.Get();
		if v6 then
			local t_Booths3 = t_BoothCustomize.Main.Booths;
			for _, val3 in ipairs(v6.TradingBoothStyles) do
				local FindFirstChild_ret = t_Booths3:FindFirstChild(val3);
				if not FindFirstChild_ret then continue end
				FindFirstChild_ret.Locked.Visible = false;
			end
		end
	end
end);
m_Library.Signal.Fired("Booth Style Updated"):Connect(function(p3) -- Line: 184
	--[[
		Upvalues:
			[1] = t_BoothCustomize
			[2] = m_Library
	--]]
	local t_Booths4 = t_BoothCustomize.Main.Booths;
	local BoothStyle = getBoothStyle(p3);
	for _, child2 in pairs(t_Booths4:GetChildren()) do
		if not child2:IsA("Frame") or not m_Library.Directory.Booths[child2.Name] then continue end
		child2.Equipped.Visible = child2.Name == BoothStyle;
	end
end);
m_Library.Signal.Fired("Customize Booth"):Connect(function() -- Line: 198
	--[[
		Upvalues:
			[1] = t_BoothCustomize
	--]]
	Update();
	t_BoothCustomize.Gui.Enabled = true;
end);
m_Library.Signal.Fired("Resolution Changed"):Connect(function() -- Line: 204
	task.defer(function() -- Line: 205
		Scrolling();
	end);
end);
