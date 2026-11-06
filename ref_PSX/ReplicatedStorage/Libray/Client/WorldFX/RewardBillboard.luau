-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Library = ReplicatedStorage:WaitForChild("Library");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local __DEBRIS = workspace:WaitForChild("__DEBRIS");
local m_Functions = require(Library.Functions);
return function(p1, p2, p3, p4) -- Line: 35
	--[[
		Upvalues:
			[1] = __DEBRIS
			[2] = Assets
			[3] = m_Functions
			[4] = RunService
	--]]
	local _ = {};
	local v1 = typeof(p1) == "Vector3" and CFrame.new(p1) or p1;
	local u1 = p4 or 2;
	local RewardBillboard = Instance.new("Part");
	RewardBillboard.Anchored = true;
	RewardBillboard.CanCollide = false;
	RewardBillboard.Size = Vector3.new(0.05, 0.05, 0.05);
	RewardBillboard.Transparency = 1;
	RewardBillboard.CFrame = v1;
	RewardBillboard.Name = "RewardBillboard";
	RewardBillboard.Parent = __DEBRIS;
	local Clone_ret = Assets.Billboards:FindFirstChild(p3):Clone();
	local Descendants = Clone_ret:GetDescendants();
	if p2 then
		for _, val2 in ipairs(Descendants) do
			if val2.ClassName ~= "TextLabel" then continue end
			val2.Text = p2;
		end
	end
	local t_Size = Clone_ret.Size;
	Clone_ret.Size = UDim2.new(Clone_ret.Size.X.Scale * 0.5, Clone_ret.Size.X.Offset * 0.5, Clone_ret.Size.Y.Scale * 0.5, Clone_ret.Size.Y.Offset * 0.5);
	m_Functions.Tween(Clone_ret, {Size = t_Size}, {
		0.5,
		"Expo",
		"Out"
	});
	Clone_ret.Parent = RewardBillboard;
	local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 88
		--[[
			Upvalues:
				[1] = Clone_ret
				[2] = u1
				[3] = m_Functions
				[4] = RunService
		--]]
		local os_clock_ret = os.clock();
		local t_StudsOffsetWorldSpace = Clone_ret.StudsOffsetWorldSpace;
		while Clone_ret and Clone_ret.Parent and os.clock() - os_clock_ret <= u1 do
			Clone_ret.StudsOffsetWorldSpace = t_StudsOffsetWorldSpace + Vector3.new(0, m_Functions.Easing((os.clock() - os_clock_ret) / u1, "Linear", "InOut") * 3, 0);
			RunService.RenderStepped:Wait();
		end
	end);
	coroutine_wrap_ret();
	local v2 = nil;
	for _, descendant1 in ipairs(Clone_ret:GetDescendants()) do
		if descendant1.ClassName == "TextLabel" then
			v2 = m_Functions.Tween(descendant1, {
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
			v2 = m_Functions.Tween(descendant1, {ImageTransparency = 1}, {
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
	v2.Completed:Connect(function() -- Line: 112
		--[[
			Upvalues:
				[1] = RewardBillboard
		--]]
		RewardBillboard:Destroy();
	end);
	return Clone_ret, RewardBillboard;
end;
