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
	local v1 = m_Library.Audio.Play("rbxassetid://88853978934707", u1.PrimaryPart, 1, 0.2, nil, nil, true);
	v1.RollOffMaxDistance = 80;
	v1.RollOffMinDistance = 10;
	local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 30
		--[[
			Upvalues:
				[1] = u1
				[2] = m_Library
		--]]
		local v4 = 0;
		while u1 and u1.Parent and u1:FindFirstChild("Light") do
			v4 = v4 + 1;
			local Light = u1:FindFirstChild("Light");
			if v4 % 2 == 0 then
				m_Library.Functions.Tween(Light, {Transparency = 0.1}, {
					1,
					Enum.EasingStyle.Cubic,
					Enum.EasingDirection.Out
				}).Completed:Wait();
			else
				m_Library.Functions.Tween(Light, {Transparency = 0.4}, {
					2,
					Enum.EasingStyle.Cubic,
					Enum.EasingDirection.InOut
				}).Completed:Wait();
			end
			m_Library.Heartbeat();
		end
	end);
	coroutine_wrap_ret();
end
function UseAnimation(p1) -- Line: 48
	--[[
		Upvalues:
			[1] = u1
			[2] = m_Library
	--]]
	if not u1 or not u1.PrimaryPart then return end
	m_Library.Audio.Play(4489068263, u1:GetPrimaryPartCFrame().p, 1, 0.75, 400);
	m_Library.Functions.Wait(1.5);
	if not u1 or not u1.PrimaryPart then return end
	if p1 then
		m_Library.Audio.Play(4489068140, u1:GetPrimaryPartCFrame().p, 1, 1, 400);
		local v2, v3 = m_Library.Functions.CreateParticleHost(u1:GetPrimaryPartCFrame().p);
		local Children = m_Library.Assets.Particles:FindFirstChild("Golden Machine"):GetChildren();
		for _, val1 in ipairs(Children) do
			local Clone_ret = val1:Clone();
			Clone_ret.Parent = v3;
			Clone_ret:Emit(40);
		end
		m_Library.Functions.AddDebris(v2, 4);
		return;
	end
	m_Library.Audio.Play(4489274818, u1:GetPrimaryPartCFrame().p, 1, 1, 400);
end
function Check() -- Line: 85
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		u1 = Map.Interactive:FindFirstChild("Gold Machine");
		if u1 then
			Setup();
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 101
	--[[
		Upvalues:
			[1] = bool1
			[2] = u1
	--]]
	bool1 = false;
	u1 = nil;
	Check();
end);
m_Library.Network.Fired("Using Golden Machine"):Connect(function(_, p2) -- Line: 109
	UseAnimation(p2);
end);
