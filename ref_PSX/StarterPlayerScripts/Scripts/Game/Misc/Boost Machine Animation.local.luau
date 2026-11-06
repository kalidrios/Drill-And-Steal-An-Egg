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
	local v1 = m_Library.Audio.Play("rbxassetid://11603330712", u1.PrimaryPart, 1, 0.3, nil, nil, true);
	if v1 then
		v1.RollOffMaxDistance = 80;
		v1.RollOffMinDistance = 10;
	end
	local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 32
		--[[
			Upvalues:
				[1] = u1
				[2] = m_Library
		--]]
		local bool2 = true;
		while u1 and u1.Parent and u1:FindFirstChild("Rings") do
			local Rings = u1:FindFirstChild("Rings");
			if bool2 then
				local v2 = nil;
				for _, child1 in pairs(Rings:GetChildren()) do
					v2 = m_Library.Functions.Tween(child1, {Position = child1.Position + Vector3.new(0, -9.5, 0)}, {
						5,
						Enum.EasingStyle.Cubic,
						Enum.EasingDirection.Out
					});
				end
				v2.Completed:Wait();
				bool2 = false;
			else
				local v3 = nil;
				for _, child2 in pairs(Rings:GetChildren()) do
					v3 = m_Library.Functions.Tween(child2, {Position = child2.Position + Vector3.new(0, 9.5, 0)}, {
						5,
						Enum.EasingStyle.Cubic,
						Enum.EasingDirection.Out
					});
				end
				v3.Completed:Wait();
				bool2 = true;
			end
			m_Library.Heartbeat();
		end
	end);
	coroutine_wrap_ret();
end
function UseAnimation() -- Line: 76
	--[[
		Upvalues:
			[1] = u1
	--]]
	if not u1 or not u1.PrimaryPart then
	end
end
function Check() -- Line: 88
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		u1 = Map.Interactive:FindFirstChild("Boost Machine");
		if u1 then
			Setup();
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 104
	--[[
		Upvalues:
			[1] = bool1
			[2] = u1
	--]]
	bool1 = false;
	u1 = nil;
	Check();
end);
