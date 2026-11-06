-- https://github.com/kalidrios

return function(p1) -- Line: 3
	assert(typeof(p1) == "Instance" and p1:IsA("ScrollingFrame") or false);
	local u1 = p1:FindFirstChildOfClass("UIListLayout") or p1:FindFirstChildOfClass("UIGridLayout");
	assert(u1);
	local UIPadding = p1:FindFirstChildOfClass("UIPadding");
	local function isVisible(p2) -- Line: 18
		--[[
			Upvalues:
				[1] = isVisible
		--]]
		if p2 then
			if p2:IsA("LayerCollector") then
				return p2.Enabled;
			end
			if p2:IsA("GuiObject") and not p2.Visible then
				return false;
			end
			return isVisible(p2.Parent);
		end
		return false;
	end
	local bool1 = false;
	local u3 = p1 and (p1:IsA("LayerCollector") and p1.Enabled or (not p1:IsA("GuiObject") or p1.Visible) and isVisible(p1.Parent) or false) or false;
	local function update() -- Line: 39
		--[[
			Upvalues:
				[1] = u3
				[2] = bool1
				[3] = p1
				[4] = u1
				[5] = UIPadding
		--]]
		if not u3 then return end
		if not bool1 then return end
		bool1 = false;
		local t_AbsoluteWindowSize = p1.AbsoluteWindowSize;
		local v1 = u1.AbsoluteContentSize;
		if UIPadding then
			v1 = v1 + Vector2.new(UIPadding.PaddingLeft.Offset, UIPadding.PaddingTop.Offset) + Vector2.new(UIPadding.PaddingRight.Offset, UIPadding.PaddingBottom.Offset) + t_AbsoluteWindowSize * Vector2.new(UIPadding.PaddingLeft.Scale, UIPadding.PaddingTop.Scale) + t_AbsoluteWindowSize * Vector2.new(UIPadding.PaddingRight.Scale, UIPadding.PaddingBottom.Scale);
		end
		if p1.ScrollingDirection == Enum.ScrollingDirection.X then
			v1 = Vector2.new(v1.X, t_AbsoluteWindowSize.Y);
		elseif p1.ScrollingDirection == Enum.ScrollingDirection.Y then
			v1 = Vector2.new(t_AbsoluteWindowSize.X, v1.Y);
		end
		p1.CanvasSize = UDim2.new(0, v1.X, 0, v1.Y);
	end
	local function lazyUpdate() -- Line: 73
		--[[
			Upvalues:
				[1] = u3
				[2] = p1
				[3] = isVisible
				[4] = bool1
		--]]
		local v2 = p1;
		u3 = v2 and (v2:IsA("LayerCollector") and v2.Enabled or (not v2:IsA("GuiObject") or v2.Visible) and isVisible(v2.Parent) or false) or false;
		bool1 = true;
	end
	game:GetService("RunService").RenderStepped:Connect(function(_) -- Line: 79
		--[[
			Upvalues:
				[1] = update
		--]]
		update();
	end);
	u1:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line: 84
		--[[
			Upvalues:
				[1] = u3
				[2] = p1
				[3] = isVisible
				[4] = bool1
		--]]
		local v3 = p1;
		u3 = v3 and (v3:IsA("LayerCollector") and v3.Enabled or (not v3:IsA("GuiObject") or v3.Visible) and isVisible(v3.Parent) or false) or false;
		bool1 = true;
	end);
	p1:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- Line: 93
		--[[
			Upvalues:
				[1] = u3
				[2] = p1
				[3] = isVisible
				[4] = bool1
		--]]
		local v4 = p1;
		u3 = v4 and (v4:IsA("LayerCollector") and v4.Enabled or (not v4:IsA("GuiObject") or v4.Visible) and isVisible(v4.Parent) or false) or false;
		bool1 = true;
	end);
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- Line: 98
		--[[
			Upvalues:
				[1] = u3
				[2] = p1
				[3] = isVisible
				[4] = bool1
		--]]
		local v5 = p1;
		u3 = v5 and (v5:IsA("LayerCollector") and v5.Enabled or (not v5:IsA("GuiObject") or v5.Visible) and isVisible(v5.Parent) or false) or false;
		bool1 = true;
	end);
	update();
	local t_Parent = p1.Parent;
	while t_Parent do
		if t_Parent:IsA("BillboardGui") then
			local u5 = t_Parent;
			t_Parent:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 111
				--[[
					Upvalues:
						[1] = u5
						[2] = u3
						[3] = p1
						[4] = isVisible
						[5] = bool1
				--]]
				if u5.Enabled then
					local v6 = p1;
					u3 = v6 and (v6:IsA("LayerCollector") and v6.Enabled or (not v6:IsA("GuiObject") or v6.Visible) and isVisible(v6.Parent) or false) or false;
					bool1 = true;
				end
			end);
			break;
		end
		if t_Parent:IsA("ScreenGui") then
			local u6 = t_Parent;
			t_Parent:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 121
				--[[
					Upvalues:
						[1] = u6
						[2] = u3
						[3] = p1
						[4] = isVisible
						[5] = bool1
				--]]
				if u6.Enabled then
					local v7 = p1;
					u3 = v7 and (v7:IsA("LayerCollector") and v7.Enabled or (not v7:IsA("GuiObject") or v7.Visible) and isVisible(v7.Parent) or false) or false;
					bool1 = true;
				end
			end);
			break;
		end
		if t_Parent:IsA("Frame") then
			local u7 = t_Parent;
			t_Parent:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 131
				--[[
					Upvalues:
						[1] = u7
						[2] = u3
						[3] = p1
						[4] = isVisible
						[5] = bool1
				--]]
				if u7.Visible then
					local v8 = p1;
					u3 = v8 and (v8:IsA("LayerCollector") and v8.Enabled or (not v8:IsA("GuiObject") or v8.Visible) and isVisible(v8.Parent) or false) or false;
					bool1 = true;
				end
			end);
		end
		t_Parent = t_Parent.Parent;
	end
end;
