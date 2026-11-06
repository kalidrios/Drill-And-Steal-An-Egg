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
	local v1 = m_Library.Audio.Play("rbxassetid://7160550471", u1.PrimaryPart, 1, 0.175, nil, nil, true);
	if v1 then
		v1.RollOffMaxDistance = 90;
		v1.RollOffMinDistance = 10;
	end
	local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 32
		--[[
			Upvalues:
				[1] = u1
				[2] = m_Library
		--]]
		local table1 = {};
		local table2 = {};
		for _, child2 in ipairs(u1:GetChildren()) do
			if not child2:IsA("BasePart") or child2.Name ~= "Cylinder" then continue end
			table.insert(table1, child2);
			table.insert(table2, child2.CFrame);
		end
		local DistanceFromCharacter_ret = nil;
		local os_clock_ret = nil;
		local os_clock_ret2 = os.clock();
		while u1 and u1.Parent do
			if not DistanceFromCharacter_ret or os.clock() - os_clock_ret >= 1 then
				if u1.PrimaryPart then
					DistanceFromCharacter_ret = m_Library.LocalPlayer:DistanceFromCharacter(u1.PrimaryPart.CFrame.p);
				end
				os_clock_ret = os.clock();
			end
			if DistanceFromCharacter_ret <= 300 then
				local v4 = os.clock() - os_clock_ret2;
				for key3, val3 in ipairs(table1) do
					val3.CFrame = table2[key3] * CFrame.new(0, math.sin((v4 + key3 / 3) * 3) / 2, 0);
				end
			end
			m_Library.Heartbeat();
		end
	end);
	coroutine_wrap_ret();
end
function UseAnimation(p1) -- Line: 67
	--[[
		Upvalues:
			[1] = u1
			[2] = m_Library
	--]]
	if not u1 or not u1.PrimaryPart then return end
	m_Library.Audio.Play("rbxassetid://7160505672", u1:GetPrimaryPartCFrame().p, 1, 0.75, 400);
	m_Library.Functions.Tween(u1.Chute, {Color = Color3.fromRGB(180, 180, 180)}, {
		0.75,
		"Quad",
		"InOut"
	});
	m_Library.Functions.Wait(1.5);
	if not u1 or not u1.PrimaryPart then return end
	if p1 then
		m_Library.Audio.Play("rbxassetid://7160552287", u1:GetPrimaryPartCFrame().p, 1, 1, 400);
		local v2, v3 = m_Library.Functions.CreateParticleHost(u1:GetPrimaryPartCFrame().p);
		local Children = m_Library.Assets.Particles:FindFirstChild("Rainbow Machine"):GetChildren();
		for _, val1 in ipairs(Children) do
			local Clone_ret = val1:Clone();
			Clone_ret.Parent = v3;
			Clone_ret:Emit(10);
		end
		m_Library.Functions.AddDebris(v2, 4);
	else
		m_Library.Audio.Play(4489274818, u1:GetPrimaryPartCFrame().p, 1, 1, 400);
	end
	m_Library.Functions.Tween(u1.Chute, {Color = Color3.fromRGB(0, 0, 0)}, {
		0.3,
		"Linear"
	});
end
function Check() -- Line: 108
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		u1 = Map.Interactive:FindFirstChild("Rainbow Machine");
		if u1 then
			Setup();
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 123
	--[[
		Upvalues:
			[1] = bool1
			[2] = u1
	--]]
	bool1 = false;
	u1 = nil;
	Check();
end);
m_Library.Network.Fired("Using Rainbow Machine"):Connect(function(_, p2) -- Line: 130
	UseAnimation(p2);
end);
