-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Library = ReplicatedStorage:WaitForChild("Library");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local __DEBRIS = workspace:WaitForChild("__DEBRIS");
local m_Functions = require(Library.Functions);
local Random_new_ret = Random.new();
return function(p1, p2, p3) -- Line: 36
	--[[
		Upvalues:
			[1] = __DEBRIS
			[2] = Assets
			[3] = m_Functions
			[4] = Random_new_ret
			[5] = RunService
	--]]
	local u1 = p3 == true;
	local v1 = p2 or 0;
	local RewardBillboard = Instance.new("Part");
	RewardBillboard.Anchored = true;
	RewardBillboard.CanCollide = false;
	RewardBillboard.Size = Vector3.new(0.05, 0.05, 0.05);
	RewardBillboard.CastShadow = false;
	RewardBillboard.Transparency = 1;
	RewardBillboard.CFrame = p1;
	RewardBillboard.Name = "RewardBillboard";
	RewardBillboard.Parent = __DEBRIS;
	local Clone_ret = Assets.Billboards:FindFirstChild(u1 and "Critical" or "Damage"):Clone();
	Clone_ret.Parent = RewardBillboard;
	local v2 = "-" .. m_Functions.Commas(v1);
	Clone_ret.Damage.Text = v2;
	for _, child1 in ipairs(Clone_ret.Damage:GetChildren()) do
		if child1.ClassName ~= "TextLabel" then continue end
		child1.Text = v2;
	end
	local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 65
		--[[
			Upvalues:
				[1] = Clone_ret
				[2] = u1
				[3] = m_Functions
		--]]
		local t_Size = Clone_ret.Size;
		local v3 = u1 and 3 or 2;
		Clone_ret.Size = UDim2.new(Clone_ret.Size.X.Scale * v3, Clone_ret.Size.X.Offset * v3, Clone_ret.Size.Y.Scale * v3, Clone_ret.Size.Y.Offset * v3);
		m_Functions.Wait(u1 and 0.08 or 0.05);
		m_Functions.Tween(Clone_ret, {Size = t_Size}, {
			0.1,
			"Sine",
			"Out"
		});
	end);
	coroutine_wrap_ret();
	if u1 then
		local coroutine_wrap_ret3 = coroutine.wrap(function() -- Line: 75
			--[[
				Upvalues:
					[1] = Clone_ret
					[2] = m_Functions
			--]]
			Clone_ret.Damage:FindFirstChildOfClass("UIGradient").Enabled = false;
			m_Functions.Wait(0.05);
			Clone_ret.Damage:FindFirstChildOfClass("UIGradient").Enabled = true;
		end);
		coroutine_wrap_ret3();
	end
	local coroutine_wrap_ret2 = coroutine.wrap(function() -- Line: 83
		--[[
			Upvalues:
				[1] = Random_new_ret
				[2] = m_Functions
				[3] = Clone_ret
				[4] = RunService
		--]]
		local os_clock_ret = os.clock();
		local NextNumber_ret = Random_new_ret:NextNumber(-3, 3);
		local NextNumber_ret2 = Random_new_ret:NextNumber(3.5, 5);
		local NextNumber_ret3 = Random_new_ret:NextNumber(-3, 3);
		while os.clock() - os_clock_ret <= 1.3 do
			local v4 = m_Functions.Easing((os.clock() - os_clock_ret) / 1.3, "Sine", "Out");
			local _ = Clone_ret.StudsOffsetWorldSpace;
			Clone_ret.StudsOffsetWorldSpace = Vector3.new(NextNumber_ret * v4, NextNumber_ret2 * v4 * math.sin(v4 * math.pi), NextNumber_ret3 * v4);
			RunService.RenderStepped:Wait();
		end
	end);
	coroutine_wrap_ret2();
	local udim2 = UDim2.new(0, 0, 0, 0);
	m_Functions.Tween(Clone_ret, {Size = udim2}, {
		0.4,
		"Back",
		"Out"
	}, 0.9).Completed:Connect(function() -- Line: 100
		--[[
			Upvalues:
				[1] = RewardBillboard
		--]]
		RewardBillboard:Destroy();
	end);
end;
