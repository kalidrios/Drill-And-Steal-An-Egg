-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Library = ReplicatedStorage:WaitForChild("Library");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local m_Functions = require(Library.Functions);
local t_List = Assets.UI.FRAMEWORK.List;
return function(p1, p2, p3, p4) -- Line: 53
	--[[
		Upvalues:
			[1] = m_Functions
			[2] = t_List
			[3] = RunService
	--]]
	local u1 = p3 ~= nil and p3 or false;
	local u2 = p4 ~= nil and p4 or true;
	if not m_Functions.IsArray(p2) then
		local table1 = {};
		for key1, val1 in pairs(p2) do
			table.insert(table1, {
				key1,
				val1
			});
		end
		p2 = table1;
	end
	local u3 = type(p2[1]) == "table";
	local BindableEvent = Instance.new("BindableEvent");
	local BindableEvent2 = Instance.new("BindableEvent");
	local u4 = false;
	local bool1 = false;
	local Connect_ret = nil;
	local u5 = nil;
	local Clone_ret = nil;
	local table2 = {};
	local function Update() -- Line: 80
		--[[
			Upvalues:
				[1] = Clone_ret
				[2] = u3
				[3] = p2
				[4] = m_Functions
		--]]
		if Clone_ret and u3 then
			local list = Clone_ret:FindFirstChild("list");
			for _, val3 in ipairs(p2) do
				local v3 = val3[1];
				local v4 = val3[2];
				local FindFirstChild_ret = list:FindFirstChild(v3);
				if v4 then
					m_Functions.Tween(FindFirstChild_ret:FindFirstChild("Enabled"), {BackgroundTransparency = 0.7}, {
						0.15,
						nil,
						"Out"
					});
					continue;
				end
				m_Functions.Tween(FindFirstChild_ret:FindFirstChild("Enabled"), {BackgroundTransparency = 1}, {
					0.15,
					nil,
					"Out"
				});
			end
		end
	end
	local function Hide(p5) -- Line: 97
		--[[
			Upvalues:
				[1] = Clone_ret
				[2] = u4
				[3] = u5
				[4] = m_Functions
				[5] = table2
				[6] = BindableEvent2
		--]]
		if not Clone_ret then return end
		assert(Clone_ret);
		if u4 then
			Clone_ret.Visible = true;
		end
		u5 = m_Functions.Tween(Clone_ret, {Size = UDim2.new(1, 0, 0, 0)}, {0.075});
		assert(u5);
		u5.Completed:Connect(function() -- Line: 107
			--[[
				Upvalues:
					[1] = u4
					[2] = p5
					[3] = table2
					[4] = Clone_ret
			--]]
			if not u4 or p5 then
				for key5, _ in ipairs(table2) do
					table2[key5]:Disconnect();
				end
				table2 = {};
				Clone_ret:Destroy();
				Clone_ret = nil;
			end
		end);
		BindableEvent2:Fire(false);
	end
	local function Show() -- Line: 123
		--[[
			Upvalues:
				[1] = Clone_ret
				[2] = t_List
				[3] = p1
				[4] = p2
				[5] = table2
				[6] = bool1
				[7] = u2
				[8] = u4
				[9] = Hide
				[10] = u3
				[11] = BindableEvent
				[12] = u1
				[13] = Update
				[14] = RunService
				[15] = u5
				[16] = m_Functions
				[17] = BindableEvent2
		--]]
		if not Clone_ret then
			Clone_ret = t_List.Base:Clone();
			assert(Clone_ret);
			Clone_ret.Size = UDim2.new(1, 0, 0, 0);
			Clone_ret.AnchorPoint = Vector2.new(0.5, 0);
			Clone_ret.Position = UDim2.new(0.5, 0, 1, 0);
			Clone_ret.Name = "__LIST";
			Clone_ret.ZIndex = p1.ZIndex + 1;
			Clone_ret.Parent = p1;
			local Clone_ret2 = t_List.BaseScroll:Clone();
			Clone_ret2.AnchorPoint = Vector2.new(0.5, 0.5);
			Clone_ret2.Position = UDim2.new(0.5, 0, 0.5, 0);
			Clone_ret2.Size = UDim2.new(1, 0, 1, 0);
			Clone_ret2.CanvasSize = UDim2.new(1, 0, 1, 0);
			Clone_ret2.Name = "list";
			Clone_ret2.ZIndex = Clone_ret.ZIndex;
			Clone_ret2.Parent = Clone_ret;
			for key4, val4 in ipairs(p2) do
				local u9 = type(val4) == "table" and val4[1] or val4;
				local _ = type(val4) == "table";
				local Clone_ret3 = t_List.Block:Clone();
				Clone_ret3.Size = UDim2.new(Clone_ret3.Size.X.Scale, 0, 0, 1000);
				Clone_ret3.Text = u9;
				Clone_ret3.TextScaled = false;
				Clone_ret3.LayoutOrder = key4;
				Clone_ret3.TextWrapped = true;
				Clone_ret3.Name = u9;
				Clone_ret3.ZIndex = Clone_ret.ZIndex;
				Clone_ret3.Enabled.ZIndex = Clone_ret.ZIndex + 1;
				Clone_ret3.div_b.ZIndex = Clone_ret.ZIndex;
				Clone_ret3.div_u.ZIndex = Clone_ret.ZIndex;
				Clone_ret3.Parent = Clone_ret2;
				table2[#table2 + 1] = Clone_ret3.Activated:Connect(function() -- Line: 160
					--[[
						Upvalues:
							[1] = bool1
							[2] = u2
							[3] = u4
							[4] = Hide
							[5] = u3
							[6] = BindableEvent
							[7] = u9
							[8] = u1
							[9] = val4
							[10] = p2
							[11] = Update
					--]]
					if not bool1 then
						bool1 = true;
						if u2 then
							u4 = false;
							Hide();
						end
						if not u3 then
							BindableEvent:Fire(u9);
						elseif u3 and u1 then
							val4[2] = not val4[2];
							BindableEvent:Fire(u9, val4[2]);
						elseif u3 and not val4[2] then
							val4[2] = not val4[2];
							for _, val6 in ipairs(p2) do
								if val6[1] == val4[1] then continue end
								val6[2] = false;
							end
							BindableEvent:Fire(u9, val4[2]);
						end
						Update();
						bool1 = false;
					end
				end);
				local coroutine_wrap_ret2 = coroutine.wrap(function() -- Line: 191
					--[[
						Upvalues:
							[1] = Clone_ret3
							[2] = Clone_ret
							[3] = RunService
					--]]
					while Clone_ret3 and Clone_ret and Clone_ret.Parent do
						Clone_ret3.Size = UDim2.new(Clone_ret3.Size.X.Scale, 0, 0, (math.max(Clone_ret3.TextBounds.Y + 6, 25)));
						RunService.RenderStepped:Wait();
					end
				end);
				coroutine_wrap_ret2();
			end
			local UIListLayout = Instance.new("UIListLayout");
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
			UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom;
			UIListLayout.Parent = Clone_ret2;
			local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 205
				--[[
					Upvalues:
						[1] = Clone_ret
						[2] = UIListLayout
						[3] = Clone_ret2
						[4] = p1
						[5] = RunService
				--]]
				while Clone_ret and Clone_ret.Parent do
					UIListLayout:ApplyLayout();
					if Clone_ret.AbsoluteSize.Y < 20 then
						Clone_ret2.CanvasSize = UDim2.new(1, 0, 0, 0);
					else
						Clone_ret2.CanvasSize = UDim2.new(1, 0, 0, UIListLayout.AbsoluteContentSize.Y);
					end
					if workspace.CurrentCamera.ViewportSize.Y - 36 <= p1.AbsolutePosition.Y + p1.AbsoluteSize.Y + Clone_ret.AbsoluteSize.Y then
						Clone_ret.AnchorPoint = Vector2.new(0.5, 1);
						Clone_ret.Position = UDim2.new(0.5, 0, 0, 0);
					else
						Clone_ret.AnchorPoint = Vector2.new(0.5, 0);
						Clone_ret.Position = UDim2.new(0.5, 0, 1, 0);
					end
					RunService.RenderStepped:Wait();
				end
			end);
			coroutine_wrap_ret();
		end
		assert(Clone_ret);
		local udim2 = UDim2.new(1, 0, 0, (math.min(#p2 * 25, 125)));
		u5 = m_Functions.Tween(Clone_ret, {Size = udim2}, {0.075});
		BindableEvent2:Fire(true);
		Update();
	end
	local function Toggle() -- Line: 236
		--[[
			Upvalues:
				[1] = u4
				[2] = Show
				[3] = Hide
		--]]
		u4 = not u4;
		if u4 then
			Show();
			return;
		end
		Hide();
	end
	local function Stop() -- Line: 246
		--[[
			Upvalues:
				[1] = Connect_ret
				[2] = BindableEvent
				[3] = BindableEvent2
				[4] = u4
				[5] = Hide
		--]]
		if Connect_ret then
			Connect_ret:Disconnect();
		end
		BindableEvent:Destroy();
		BindableEvent2:Destroy();
		if u4 then
			Hide(true);
		end
	end
	local function OverrideOption(p6) -- Line: 259
		--[[
			Upvalues:
				[1] = p2
		--]]
		for _, val2 in ipairs(p2) do
			val2[2] = val2[1] == p6;
		end
	end
	Connect_ret = p1.Activated:Connect(function() -- Line: 266
		--[[
			Upvalues:
				[1] = u4
				[2] = Show
				[3] = Hide
		--]]
		u4 = not u4;
		if u4 then
			Show();
			return;
		end
		Hide();
	end);
	return BindableEvent, Stop, BindableEvent2, OverrideOption;
end;
