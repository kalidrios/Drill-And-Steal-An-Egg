-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local u1 = nil;
local bool1 = false;
local u2 = 1;
function Setup() -- Line: 19
	--[[
		Upvalues:
			[1] = bool1
			[2] = m_Library
			[3] = u1
			[4] = u2
	--]]
	if bool1 then return end
	bool1 = true;
	local v1 = m_Library.Audio.Play("rbxassetid://7216322534", u1.PrimaryPart, 0.75, 0.125, nil, nil, true);
	v1.RollOffMaxDistance = 100;
	v1.RollOffMinDistance = 10;
	local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 31
		--[[
			Upvalues:
				[1] = u1
				[2] = m_Library
		--]]
		local table1 = {};
		for _, child2 in ipairs(u1:FindFirstChild("BOOKS"):GetChildren()) do
			for _, descendant4 in ipairs(child2:GetDescendants()) do
				if not descendant4:IsA("BasePart") or descendant4 == child2.PrimaryPart then continue end
				descendant4.Anchored = false;
				m_Library.Functions.Weld(child2.PrimaryPart, descendant4);
			end
			table.insert(table1, {
				child2,
				child2.PrimaryPart.CFrame
			});
		end
		local DistanceFromCharacter_ret = nil;
		local os_clock_ret = nil;
		local os_clock_ret2 = os.clock();
		while u1 and u1.Parent do
			if not DistanceFromCharacter_ret or os.clock() - os_clock_ret >= 1 then
				DistanceFromCharacter_ret = m_Library.LocalPlayer:DistanceFromCharacter(u1.PrimaryPart.CFrame.p);
				os_clock_ret = os.clock();
			end
			if DistanceFromCharacter_ret <= 125 then
				local v3 = os.clock() - os_clock_ret2;
				for key5, val5 in ipairs(table1) do
					local unpack_ret1, unpack_ret2 = unpack(val5);
					unpack_ret1.PrimaryPart.CFrame = unpack_ret2 * CFrame.new(0, math.sin(v3 * (key5 / 4 + 1)) * ((key5 % 2 + 1) / 4) + 2, 0);
				end
			end
			m_Library.Heartbeat();
		end
	end);
	coroutine_wrap_ret();
	local coroutine_wrap_ret2 = coroutine.wrap(function() -- Line: 67
		--[[
			Upvalues:
				[1] = u1
				[2] = m_Library
				[3] = u2
		--]]
		local CIRCLE = u1:FindFirstChild("CIRCLE");
		local t_PrimaryPart = CIRCLE.PrimaryPart;
		for _, descendant3 in ipairs(CIRCLE:GetDescendants()) do
			if not descendant3:IsA("BasePart") or descendant3 == t_PrimaryPart then continue end
			descendant3.Anchored = false;
			m_Library.Functions.Weld(t_PrimaryPart, descendant3);
		end
		local t_CFrame = t_PrimaryPart.CFrame;
		local DistanceFromCharacter_ret2 = nil;
		local os_clock_ret3 = nil;
		local os_clock_ret4 = os.clock();
		while u1 and u1.Parent do
			if not DistanceFromCharacter_ret2 or os.clock() - os_clock_ret3 >= 1 then
				DistanceFromCharacter_ret2 = m_Library.LocalPlayer:DistanceFromCharacter(u1.PrimaryPart.CFrame.p);
				os_clock_ret3 = os.clock();
			end
			if DistanceFromCharacter_ret2 <= 175 then
				t_PrimaryPart.CFrame = t_CFrame * CFrame.Angles(0, -math.rad((os.clock() - os_clock_ret4) * 40) * u2, 0);
			end
			m_Library.Heartbeat();
		end
	end);
	coroutine_wrap_ret2();
end
function UseAnimation(p1, p2, p3, p4, p5) -- Line: 98
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
			[3] = u2
	--]]
	local v2 = (p1 == m_Library.LocalPlayer or not p4) and not p5;
	if not u1 or not u1.PrimaryPart then return end
	if v2 then
		m_Library.Audio.Play("rbxassetid://7216322492", u1:GetPrimaryPartCFrame().p, 1.55, 1, 325);
		local coroutine_wrap_ret4 = coroutine.wrap(function() -- Line: 108
			--[[
				Upvalues:
					[1] = u2
					[2] = m_Library
			--]]
			local os_clock_ret5 = os.clock();
			while os.clock() - os_clock_ret5 <= 3 do
				u2 = 1 - math.sin((os.clock() - os_clock_ret5) / 3 * math.pi) * 2;
				m_Library.Heartbeat();
			end
			u2 = 1;
		end);
		coroutine_wrap_ret4();
	end
	m_Library.Functions.Wait(2);
	if not u1 or not u1.PrimaryPart then return end
	if v2 then
		local coroutine_wrap_ret3 = coroutine.wrap(function() -- Line: 126
			--[[
				Upvalues:
					[1] = u1
					[2] = m_Library
			--]]
			if not u1 or not u1:FindFirstChild("CIRCLE") then return end
			local Clone_ret2 = m_Library.Assets.Other.EnchantFX:Clone();
			Clone_ret2.CFrame = u1:FindFirstChild("CIRCLE").PrimaryPart.CFrame * CFrame.Angles(0, 0, 1.5707963267948966);
			Clone_ret2.Parent = m_Library.Debris;
			m_Library.Functions.Tween(Clone_ret2, {Transparency = 1}, {
				1.33,
				"Expo",
				"Out"
			}).Completed:Wait();
			Clone_ret2:Destroy();
		end);
		coroutine_wrap_ret3();
	end
	local FindFirstChild_ret = m_Library.Things.Pets:FindFirstChild(p2);
	if FindFirstChild_ret then
		local Clone_ret = m_Library.Assets.Particles:FindFirstChild("Pet Enchant"):Clone();
		Clone_ret.Parent = FindFirstChild_ret;
		Clone_ret:Emit(20);
		m_Library.Functions.AddDebris(Clone_ret, 3);
	end
	local bool2 = false;
	for _, val1 in ipairs(p3) do
		if not m_Library.Directory.Powers[val1[1]].isUnique then continue end
		bool2 = true;
		break;
	end
	if not u1 or not u1.PrimaryPart then return end
	if u1.PrimaryPart and v2 then
		if bool2 then
			m_Library.Audio.Play("rbxassetid://7216322461", u1:GetPrimaryPartCFrame().p, 1, 1.25, 325);
			return;
		end
		m_Library.Audio.Play("rbxassetid://7216322585", u1:GetPrimaryPartCFrame().p, 1, 1, 325);
	end
end
function Check() -- Line: 191
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		u1 = Map.Interactive:FindFirstChild("Enchanting");
		if u1 then
			Setup();
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 206
	--[[
		Upvalues:
			[1] = bool1
			[2] = u1
	--]]
	bool1 = false;
	u1 = nil;
	Check();
end);
m_Library.Network.Fired("Enchanted Pets"):Connect(function(p6, p7, p8, p9, p10) -- Line: 214
	UseAnimation(p6, p7, p8, p9, p10);
end);
