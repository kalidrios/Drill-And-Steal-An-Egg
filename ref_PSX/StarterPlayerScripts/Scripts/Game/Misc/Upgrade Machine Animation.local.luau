-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local Random_new_ret = Random.new();
local u1 = nil;
local bool1 = false;
function Setup() -- Line: 19
	--[[
		Upvalues:
			[1] = bool1
			[2] = m_Library
			[3] = u1
	--]]
	if bool1 then return end
	bool1 = true;
	local v1 = m_Library.Audio.Play("rbxassetid://6958868932", u1.PrimaryPart, 1, 0.25, nil, nil, true);
	v1.RollOffMaxDistance = 120;
	v1.RollOffMinDistance = 10;
end
function UseAnimation() -- Line: 32
	--[[
		Upvalues:
			[1] = u1
			[2] = m_Library
			[3] = Random_new_ret
	--]]
	if not u1 then return end
	local FindFirstChild_ret = m_Library.Assets.Other:FindFirstChild("Upgrade Station");
	local Pad = u1:FindFirstChild("Pad");
	m_Library.Audio.Play("rbxassetid://6940331703", Pad, 1, 1, 375);
	local Clone_ret = m_Library.Assets.Particles:FindFirstChild("Upgrade Station").Success:Clone();
	Clone_ret.Parent = Pad;
	Clone_ret:Emit(20);
	m_Library.Functions.AddDebris(Clone_ret, 3);
	local Clone_ret2 = FindFirstChild_ret:FindFirstChildOfClass("PointLight"):Clone();
	Clone_ret2.Parent = Pad;
	m_Library.Functions.Tween(Clone_ret2, {Brightness = 0}, {
		0.2,
		"Linear"
	});
	for index1 = 1, 5 do
		local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 56
			--[[
				Upvalues:
					[1] = FindFirstChild_ret
					[2] = index1
					[3] = Pad
					[4] = Random_new_ret
					[5] = m_Library
			--]]
			local Clone_ret3 = FindFirstChild_ret.Effect:Clone();
			Clone_ret3.Color = index1 % 2 == 0 and Clone_ret3.Color or Color3.new(1, 1, 1);
			Clone_ret3.CFrame = Pad.CFrame * CFrame.Angles(0, Random_new_ret:NextNumber(0, 360), 0) + Vector3.new(0, Clone_ret3.Size.Y / 2.5, 0);
			Clone_ret3.Parent = m_Library.Debris;
			local vec3 = Vector3.new(Clone_ret3.Size.X, 15, Clone_ret3.Size.Z);
			local v2 = Clone_ret3.CFrame + Vector3.new(0, vec3.Y / 2.5, 0);
			m_Library.Functions.Tween(Clone_ret3, {
				Size = vec3,
				CFrame = v2,
				Transparency = 1
			}, {
				0.2,
				"Expo",
				"Out"
			}).Completed:Wait();
			Clone_ret3:Destroy();
		end);
		coroutine_wrap_ret();
		m_Library.Functions.Wait(0.05);
	end
end
function Check() -- Line: 75
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		u1 = Map.Interactive:FindFirstChild("Upgrade Station");
		if u1 then
			Setup();
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 90
	--[[
		Upvalues:
			[1] = bool1
			[2] = u1
	--]]
	bool1 = false;
	u1 = nil;
	Check();
end);
m_Library.Network.Fired("Upgrade Station Animation"):Connect(function(_) -- Line: 98
	UseAnimation();
end);
