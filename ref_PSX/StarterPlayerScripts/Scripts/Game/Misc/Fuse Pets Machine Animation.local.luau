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
	local v1 = m_Library.Audio.Play("rbxassetid://7082609487", u1.PrimaryPart, 1, 0.225, nil, nil, true);
	v1.RollOffMaxDistance = 90;
	v1.RollOffMinDistance = 20;
	local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 30
		--[[
			Upvalues:
				[1] = u1
				[2] = m_Library
		--]]
		local Pump1 = u1:FindFirstChild("Pump1");
		local Pump2 = u1:FindFirstChild("Pump2");
		local DistanceFromCharacter_ret = nil;
		local os_clock_ret = nil;
		local t_CFrame = Pump1.CFrame;
		local t_CFrame2 = Pump2.CFrame;
		local os_clock_ret2 = os.clock();
		while u1 and u1.Parent do
			if not DistanceFromCharacter_ret or os.clock() - os_clock_ret >= 1 then
				DistanceFromCharacter_ret = m_Library.LocalPlayer:DistanceFromCharacter(u1.PrimaryPart.CFrame.p);
				os_clock_ret = os.clock();
			end
			if DistanceFromCharacter_ret <= 350 then
				local v4 = os.clock() - os_clock_ret2;
				Pump1.CFrame = t_CFrame + Vector3.new(0, math.sin(v4 * 1.4) * 1.5, 0);
				Pump2.CFrame = t_CFrame2 + Vector3.new(0, math.sin(v4 * 2) * 0.75, 0);
			end
			m_Library.Heartbeat();
		end
	end);
	coroutine_wrap_ret();
end
function UseAnimation() -- Line: 55
	--[[
		Upvalues:
			[1] = u1
			[2] = m_Library
	--]]
	if not u1 or not u1.PrimaryPart then return end
	m_Library.Audio.Play("rbxassetid://7082614240", u1:GetPrimaryPartCFrame().p, 1, 0.85, 400);
	m_Library.Functions.Wait(1.5);
	if not u1 or not u1.PrimaryPart then return end
	local v2, v3 = m_Library.Functions.CreateParticleHost(u1:GetPrimaryPartCFrame().p);
	local Children = m_Library.Assets.Particles:FindFirstChild("Fuse Pets Machine"):GetChildren();
	for _, val1 in ipairs(Children) do
		local Clone_ret = val1:Clone();
		Clone_ret.Parent = v3;
		Clone_ret:Emit(30);
	end
	m_Library.Functions.AddDebris(v2, 4);
end
function Check() -- Line: 82
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		u1 = Map.Interactive:FindFirstChild("Fuse Pets");
		if u1 then
			Setup();
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 98
	--[[
		Upvalues:
			[1] = bool1
			[2] = u1
	--]]
	bool1 = false;
	u1 = nil;
	Check();
end);
m_Library.Network.Fired("Using Fuse Pets Machine"):Connect(function(_) -- Line: 105
	UseAnimation();
end);
