-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local Random_new_ret = Random.new();
function CubeAnimations() -- Line: 17
	--[[
		Upvalues:
			[1] = Random_new_ret
			[2] = m_Library
	--]]
	local function AnimateCube(p2) -- Line: 18
		--[[
			Upvalues:
				[1] = Random_new_ret
				[2] = m_Library
		--]]
		local _ = p2:FindFirstChildOfClass("SelectionBox");
		local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 21
			--[[
				Upvalues:
					[1] = p2
					[2] = Random_new_ret
					[3] = m_Library
			--]]
			local os_clock_ret = os.clock();
			local v2 = p2.CFrame * CFrame.Angles(Random_new_ret:NextNumber(0, math.pi), Random_new_ret:NextNumber(0, math.pi), Random_new_ret:NextNumber(0, math.pi));
			local NextNumber_ret = Random_new_ret:NextNumber(0, 0.5);
			local NextNumber_ret2 = Random_new_ret:NextNumber(15, 100);
			while p2 and p2.Parent do
				local v4 = os.clock() - os_clock_ret;
				p2.CFrame = v2 * CFrame.new(0, math.sin(v4 * NextNumber_ret) * NextNumber_ret2, 0) * CFrame.Angles(math.rad(v4 * 10), math.rad(-v4 * 10), (math.rad(v4 * 10)));
				m_Library.RenderStepped();
			end
		end);
		coroutine_wrap_ret();
	end
	local Map = m_Library.WorldCmds.GetMap();
	local FloatingCubes = Map:WaitForChild("Areas"):WaitForChild("Void"):WaitForChild("FloatingCubes");
	if FloatingCubes then
		for _, child1 in ipairs(FloatingCubes:GetChildren()) do
			local _ = child1:FindFirstChildOfClass("SelectionBox");
			local coroutine_wrap_ret2 = coroutine.wrap(function() -- Line: 21
				--[[
					Upvalues:
						[1] = child1
						[2] = Random_new_ret
						[3] = m_Library
				--]]
				local os_clock_ret2 = os.clock();
				local v3 = child1.CFrame * CFrame.Angles(Random_new_ret:NextNumber(0, math.pi), Random_new_ret:NextNumber(0, math.pi), Random_new_ret:NextNumber(0, math.pi));
				local NextNumber_ret3 = Random_new_ret:NextNumber(0, 0.5);
				local NextNumber_ret4 = Random_new_ret:NextNumber(15, 100);
				while child1 and child1.Parent do
					local v5 = os.clock() - os_clock_ret2;
					child1.CFrame = v3 * CFrame.new(0, math.sin(v5 * NextNumber_ret3) * NextNumber_ret4, 0) * CFrame.Angles(math.rad(v5 * 10), math.rad(-v5 * 10), (math.rad(v5 * 10)));
					m_Library.RenderStepped();
				end
			end);
			coroutine_wrap_ret2();
		end
	end
end
function RockAnimations() -- Line: 45
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local function AnimateRock(p3) -- Line: 46
		--[[
			Upvalues:
				[1] = m_Library
		--]]
		local u1 = math.random() * 2 + 3;
		local u2 = math.random() * 0.6 + 2.7;
		local coroutine_wrap_ret3 = coroutine.wrap(function() -- Line: 50
			--[[
				Upvalues:
					[1] = p3
					[2] = u1
					[3] = u2
					[4] = m_Library
			--]]
			local PrimaryPartCFrame = p3:GetPrimaryPartCFrame();
			local t_Position = PrimaryPartCFrame.Position;
			while p3 and p3.Parent do
				p3:SetPrimaryPartCFrame(PrimaryPartCFrame - t_Position + (t_Position + Vector3.new(0, u1 * math.sin(tick() * math.pi / u2), 0)));
				m_Library.RenderStepped();
			end
		end);
		coroutine_wrap_ret3();
	end
	local Map2 = m_Library.WorldCmds.GetMap();
	local AncientRocks = Map2:WaitForChild("Areas"):WaitForChild("Void"):WaitForChild("AncientRocks");
	if AncientRocks then
		for _, child2 in ipairs(AncientRocks:GetChildren()) do
			AnimateRock(child2);
		end
	end
end
function FloatingRockAnimations() -- Line: 74
	--[[
		Upvalues:
			[1] = Random_new_ret
			[2] = m_Library
	--]]
	local function AnimateRock(p4) -- Line: 75
		--[[
			Upvalues:
				[1] = Random_new_ret
				[2] = m_Library
		--]]
		local coroutine_wrap_ret4 = coroutine.wrap(function() -- Line: 76
			--[[
				Upvalues:
					[1] = p4
					[2] = Random_new_ret
					[3] = m_Library
			--]]
			local os_clock_ret3 = os.clock();
			local t_CFrame = p4.CFrame;
			local NextNumber_ret5 = Random_new_ret:NextNumber(0.1, 1);
			local NextNumber_ret6 = Random_new_ret:NextNumber(3, 7);
			while p4 and p4.Parent do
				p4.CFrame = t_CFrame * CFrame.new(0, math.sin((os.clock() - os_clock_ret3) * NextNumber_ret5) * NextNumber_ret6, 0);
				m_Library.RenderStepped();
			end
		end);
		coroutine_wrap_ret4();
	end
	local Map3 = m_Library.WorldCmds.GetMap();
	local Rocks = Map3:WaitForChild("Areas"):WaitForChild("Void"):WaitForChild("Rocks");
	if Rocks then
		for key3, child3 in ipairs(Rocks:GetChildren()) do
			if key3 % 3 ~= 0 and child3.Name ~= "alwaysfloat" then continue end
			local coroutine_wrap_ret5 = coroutine.wrap(function() -- Line: 76
				--[[
					Upvalues:
						[1] = child3
						[2] = Random_new_ret
						[3] = m_Library
				--]]
				local os_clock_ret4 = os.clock();
				local t_CFrame2 = child3.CFrame;
				local NextNumber_ret7 = Random_new_ret:NextNumber(0.1, 1);
				local NextNumber_ret8 = Random_new_ret:NextNumber(3, 7);
				while child3 and child3.Parent do
					child3.CFrame = t_CFrame2 * CFrame.new(0, math.sin((os.clock() - os_clock_ret4) * NextNumber_ret7) * NextNumber_ret8, 0);
					m_Library.RenderStepped();
				end
			end);
			coroutine_wrap_ret5();
		end
	end
end
function Animations() -- Line: 105
	CubeAnimations();
	FloatingRockAnimations();
	RockAnimations();
end
m_Library.Signal.Fired("World Changed"):Connect(function(p1) -- Line: 112
	if p1 == "Void" then
		Animations();
	end
end);
