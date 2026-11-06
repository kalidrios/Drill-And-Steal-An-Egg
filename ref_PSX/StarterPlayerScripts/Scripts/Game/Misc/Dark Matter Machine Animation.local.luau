-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local u1 = nil;
local bool1 = false;
function Setup() -- Line: 18
	--[[
		Upvalues:
			[1] = bool1
			[2] = m_Library
			[3] = u1
	--]]
	if bool1 then return end
	bool1 = true;
	local v1 = m_Library.Audio.Play("rbxassetid://7495293142", u1.PrimaryPart, 0.8, 0.3, nil, nil, true);
	if v1 then
		v1.RollOffMaxDistance = 150;
		v1.RollOffMinDistance = 50;
	end
	local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 32
		--[[
			Upvalues:
				[1] = u1
				[2] = m_Library
		--]]
		local Crystal1 = u1:FindFirstChild("Crystal1");
		local Crystal2 = u1:FindFirstChild("Crystal2");
		local DistanceFromCharacter_ret = nil;
		local os_clock_ret = nil;
		local t_CFrame = Crystal1.CFrame;
		local t_CFrame2 = Crystal2.CFrame;
		local os_clock_ret2 = os.clock();
		while u1 and u1.Parent do
			if not DistanceFromCharacter_ret or os.clock() - os_clock_ret >= 1 then
				DistanceFromCharacter_ret = m_Library.LocalPlayer:DistanceFromCharacter(u1.PrimaryPart.CFrame.p);
				os_clock_ret = os.clock();
			end
			if DistanceFromCharacter_ret <= 500 then
				local v2 = os.clock() - os_clock_ret2;
				Crystal1.CFrame = t_CFrame + Vector3.new(0, math.sin(v2 * 0.2) * 8, 0);
				Crystal2.CFrame = t_CFrame2 + Vector3.new(0, math.sin(v2 * 0.125) * 8, 0);
			end
			m_Library.Heartbeat();
		end
	end);
	coroutine_wrap_ret();
end
function UseAnimation(_) -- Line: 58
	--[[
		Upvalues:
			[1] = u1
			[2] = m_Library
	--]]
	if not u1 or not u1.PrimaryPart then return end
	m_Library.Audio.Play("rbxassetid://7495430575", u1:GetPrimaryPartCFrame().p, 1, 1.25, 500);
end
function ClaimAnimation(_) -- Line: 67
	--[[
		Upvalues:
			[1] = u1
			[2] = m_Library
	--]]
	if not u1 or not u1.PrimaryPart then return end
	m_Library.Audio.Play("rbxassetid://7495292957", u1:GetPrimaryPartCFrame().p, 1, 1.33, 500);
end
function Check() -- Line: 76
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		u1 = Map.Interactive:FindFirstChild("Dark Matter Machine");
		if u1 then
			Setup();
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 91
	--[[
		Upvalues:
			[1] = bool1
			[2] = u1
	--]]
	bool1 = false;
	u1 = nil;
	Check();
end);
m_Library.Network.Fired("Dark Matter Machine Used"):Connect(function(p1) -- Line: 98
	UseAnimation(p1);
end);
m_Library.Network.Fired("Dark Matter Machine Redeemed"):Connect(function(p2) -- Line: 103
	ClaimAnimation(p2);
end);
