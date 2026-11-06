-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local m_Functions = require(ReplicatedStorage:WaitForChild("Library").Functions);
local m_CacheProperty = require(script.Parent.CacheProperty);
return function(p1) 
	local FindFirstAncestorOfClass_ret = p1:FindFirstAncestorOfClass("ScreenGui");
	assert(FindFirstAncestorOfClass_ret);
	local function Scrollbar() 
		local UIListLayout = p1:FindFirstChildOfClass("UIListLayout");
		assert(UIListLayout);
		local UIPadding = p1:FindFirstChildOfClass("UIPadding");
		assert(UIPadding);
		local v1 = UIListLayout.AbsoluteContentSize.Y;
		if UIPadding then
			v1 = v1 + (UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset);
		end
		p1.CanvasSize = UDim2.new(0, 0, 0, v1);
	end
	local function SizeFrame(p2) 
		local v2 = m_Functions.ResolutionScale();
		local v3 = 0;
		for _, child1 in ipairs(p2:GetChildren()) do
			if child1:IsA("UIPadding") then
				local v5 = m_CacheProperty(child1, "PaddingTop");
				local v6 = m_CacheProperty(child1, "PaddingBottom");
				child1.PaddingTop = UDim.new(v5.Scale, v5.Offset * v2);
				child1.PaddingBottom = UDim.new(v6.Scale, v6.Offset * v2);
				v3 = v3 + (child1.PaddingTop.Offset + child1.PaddingBottom.Offset);
				continue;
			end
			if not child1:IsA("UIListLayout") and not child1:IsA("UIGridLayout") or child1.ClassName == "UIListLayout" and child1.FillDirection == Enum.FillDirection.Horizontal then continue end
			v3 = v3 + child1.AbsoluteContentSize.Y;
			if child1:IsA("UIListLayout") then
				local v7 = m_CacheProperty(child1, "Padding");
				child1.Padding = UDim.new(v7.Scale, v7.Offset * v2);
				continue;
			end
			if not child1:IsA("UIGridLayout") then continue end
			local v4 = m_CacheProperty(child1, "CellPadding");
			child1.CellPadding = UDim2.new(v4.X.Scale, v4.X.Offset * v2, v4.Y.Scale, v4.Y.Offset * v2);
			if not child1:FindFirstChildOfClass("UIAspectRatioConstraint") then continue end
			child1.CellSize = UDim2.new(child1.CellSize.X.Scale, child1.CellSize.X.Offset, 0, child1.AbsoluteCellSize.Y + 2);
		end
		if v3 <= 0 then
			p2.Size = UDim2.new(p2.Size.X.Scale, p2.Size.X.Offset, 1, 0);
			return;
		end
		p2.Size = UDim2.new(p2.Size.X.Scale, p2.Size.X.Offset, 0, v3);
	end
	local function Scaling() 
		if not FindFirstAncestorOfClass_ret.Enabled or not p1.Visible then return end
		local _ = game.Workspace.CurrentCamera.ViewportSize.Y <= 1000;
		for _, child2 in ipairs(p1:GetChildren()) do
			if not child2:IsA("GuiObject") then continue end
			for _, child3 in ipairs(child2:GetChildren()) do
				if not child3:FindFirstChildOfClass("UIListLayout") and not child3:FindFirstChildOfClass("UIGridLayout") then continue end
				if child3:IsA("GuiObject") then
					SizeFrame(child3);
					continue;
				end
				warn("WHAT IS THIS?", child3);
			end
			SizeFrame(child2);
		end
		Scrollbar();
	end
	task.spawn(function()
		while true do
			RunService.Heartbeat:Wait();
			Scaling();
		end
	end);
end;
