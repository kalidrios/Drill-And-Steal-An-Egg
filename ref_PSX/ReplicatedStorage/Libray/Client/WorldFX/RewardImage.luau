-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Library = ReplicatedStorage:WaitForChild("Library");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local __DEBRIS = workspace:WaitForChild("__DEBRIS");
local m_Functions = require(Library.Functions);
return function(p1, p2, p3, p4) -- Line: 39
	--[[
		Upvalues:
			[1] = Assets
			[2] = __DEBRIS
			[3] = m_Functions
			[4] = RunService
	--]]
	local v1 = typeof(p1) == "Vector3" and CFrame.new(p1) or p1;
	local v2 = p4 or {};
	local v3 = v2.color or Color3.new(1, 1, 1);
	local u1 = v2.time or 3;
	local Clone_ret = Assets.Billboards:FindFirstChild("Reward"):Clone();
	local RewardBillboard = Instance.new("Part");
	RewardBillboard.Anchored = true;
	RewardBillboard.CanCollide = false;
	RewardBillboard.Size = Vector3.new();
	RewardBillboard.Transparency = 1;
	RewardBillboard.CFrame = v1;
	RewardBillboard.Name = "RewardBillboard";
	RewardBillboard.Parent = __DEBRIS;
	Clone_ret.amount.Text = p2;
	Clone_ret.amount.TextColor3 = v3;
	Clone_ret.icon.Image = p3;
	Clone_ret.icon.shadow.Image = p3;
	Clone_ret.Parent = RewardBillboard;
	local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 72
		--[[
			Upvalues:
				[1] = Clone_ret
				[2] = m_Functions
		--]]
		local t_Size = Clone_ret.Size;
		Clone_ret.Size = UDim2.new(Clone_ret.Size.X.Scale * 1.3, Clone_ret.Size.X.Offset * 1.3, Clone_ret.Size.Y.Scale * 1.3, Clone_ret.Size.Y.Offset * 1.3);
		m_Functions.Wait(0.05);
		m_Functions.Tween(Clone_ret, {Size = t_Size}, {
			0.1,
			"Sine",
			"Out"
		});
	end);
	coroutine_wrap_ret();
	local coroutine_wrap_ret2 = coroutine.wrap(function() -- Line: 81
		--[[
			Upvalues:
				[1] = Clone_ret
				[2] = u1
				[3] = m_Functions
				[4] = RunService
		--]]
		local os_clock_ret = os.clock();
		local t_StudsOffsetWorldSpace = Clone_ret.StudsOffsetWorldSpace;
		while os.clock() - os_clock_ret <= u1 do
			Clone_ret.StudsOffsetWorldSpace = t_StudsOffsetWorldSpace + Vector3.new(0, m_Functions.Easing((os.clock() - os_clock_ret) / u1, "Linear", "InOut") * 3, 0);
			RunService.RenderStepped:Wait();
		end
	end);
	coroutine_wrap_ret2();
	local v4 = nil;
	for _, descendant1 in ipairs(Clone_ret:GetDescendants()) do
		if descendant1.ClassName == "TextLabel" then
			v4 = m_Functions.Tween(descendant1, {
				TextTransparency = 1,
				TextStrokeTransparency = 1
			}, {
				0.5,
				"Linear",
				"Out"
			}, u1 - 0.5);
			continue;
		end
		if descendant1.ClassName == "ImageLabel" then
			v4 = m_Functions.Tween(descendant1, {ImageTransparency = 1}, {
				0.5,
				"Linear",
				"Out"
			}, u1 - 0.5);
			continue;
		end
		if descendant1.ClassName ~= "UIStroke" then continue end
		m_Functions.Tween(descendant1, {Transparency = 1}, {
			0.5,
			"Linear",
			"Out"
		}, u1 - 0.5);
	end
	v4.Completed:Connect(function() -- Line: 104
		--[[
			Upvalues:
				[1] = RewardBillboard
		--]]
		RewardBillboard:Destroy();
	end);
	return Clone_ret;
end;
