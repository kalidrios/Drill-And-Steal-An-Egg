-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local _ = game:GetService("RunService");
local m_Functions = require(ReplicatedStorage:WaitForChild("Library").Functions);
local m_GetHolder = require(script.Parent.GetHolder);
return function(p1, p2, p3, p4) -- Line: 36
	--[[
		Upvalues:
			[1] = m_GetHolder
			[2] = m_Functions
	--]]
	local u1 = p1 or 1;
	local u2 = p2 or 1;
	local u3 = p3 or Color3.new(1, 1, 1);
	local u4 = p4 or 0;
	task.spawn(function() -- Line: 44
		--[[
			Upvalues:
				[1] = u3
				[2] = m_GetHolder
				[3] = u1
				[4] = m_Functions
				[5] = u4
				[6] = u2
		--]]
		local Frame = Instance.new("Frame");
		Frame.BackgroundTransparency = 1;
		Frame.BackgroundColor3 = u3;
		Frame.Size = UDim2.new(2, 0, 2, 0);
		Frame.AnchorPoint = Vector2.new(0.5, 0.5);
		Frame.Position = UDim2.new(0.5, 0, 0.5, 0);
		Frame.BorderSizePixel = 0;
		Frame.Parent = m_GetHolder();
		if u1 > 0 then
			m_Functions.Tween(Frame, {BackgroundTransparency = u4}, {
				u1,
				"Expo",
				"Out"
			});
			wait(u1);
		else
			Frame.BackgroundTransparency = u4;
		end
		if u2 > 0 then
			m_Functions.Tween(Frame, {BackgroundTransparency = 1}, {
				u2,
				"Sine",
				"Out"
			});
			wait(u2);
		else
			Frame.BackgroundTransparency = 1;
		end
		Frame:Destroy();
	end);
end;
