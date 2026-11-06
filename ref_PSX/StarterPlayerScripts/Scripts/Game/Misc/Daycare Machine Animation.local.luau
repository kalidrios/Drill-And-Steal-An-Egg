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
			[2] = u1
			[3] = m_Library
	--]]
	if bool1 then return end
	bool1 = true;
	local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 25
		--[[
			Upvalues:
				[1] = u1
				[2] = m_Library
		--]]
		local v3 = 0;
		while u1 and u1.Parent and u1:FindFirstChild("Light") do
			v3 = v3 + 1;
			local Light = u1:FindFirstChild("Light");
			if v3 % 2 == 0 then
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
function UseAnimation(p1) -- Line: 43
	--[[
		Upvalues:
			[1] = u1
			[2] = m_Library
	--]]
	if not u1 or not u1.PrimaryPart then return end
	if not u1 or not u1.PrimaryPart then return end
	if p1 then
		local v1, v2 = m_Library.Functions.CreateParticleHost(u1:GetPrimaryPartCFrame().p);
		local Children = m_Library.Assets.Particles:FindFirstChild("Golden Machine"):GetChildren();
		for _, val1 in ipairs(Children) do
			local Clone_ret = val1:Clone();
			Clone_ret.Parent = v2;
			Clone_ret:Emit(40);
		end
		m_Library.Functions.AddDebris(v1, 4);
	end
end
function Check() -- Line: 69
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		u1 = Map.Interactive:FindFirstChild("Daycare");
		if u1 then
			Setup();
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 85
	--[[
		Upvalues:
			[1] = bool1
			[2] = u1
	--]]
	bool1 = false;
	u1 = nil;
	Check();
end);
m_Library.Network.Fired("Using Daycare Machine"):Connect(function(_, p2) -- Line: 93
	UseAnimation(p2);
end);
