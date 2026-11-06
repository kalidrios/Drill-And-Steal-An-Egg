-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local _ = Random.new();
function PortalAnimation() -- Line: 17
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local FindFirstChild_ret = m_Library.WorldCmds.GetMap().Interactive:FindFirstChild("Hacker Portal");
	if FindFirstChild_ret then
		for index1 = 1, 3 do
			local FindFirstChild_ret2 = FindFirstChild_ret:FindFirstChild("Ring" .. index1);
			local t_PrimaryPart = FindFirstChild_ret2.PrimaryPart;
			for _, descendant1 in ipairs(FindFirstChild_ret2:GetDescendants()) do
				if not descendant1:IsA("BasePart") or descendant1 == t_PrimaryPart then continue end
				descendant1.Anchored = false;
				m_Library.Functions.Weld(t_PrimaryPart, descendant1);
			end
			local os_clock_ret = os.clock();
			local DistanceFromCharacter_ret = nil;
			local os_clock_ret2 = nil;
			local t_CFrame = t_PrimaryPart.CFrame;
			local u1 = index1 == 1 and 4 or index1 == 2 and -4 or 12;
			local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 38
				--[[
					Upvalues:
						[1] = FindFirstChild_ret2
						[2] = DistanceFromCharacter_ret
						[3] = os_clock_ret2
						[4] = m_Library
						[5] = t_PrimaryPart
						[6] = os_clock_ret
						[7] = t_CFrame
						[8] = u1
				--]]
				while FindFirstChild_ret2 and FindFirstChild_ret2.Parent do
					if not DistanceFromCharacter_ret or os.clock() - os_clock_ret2 >= 1 then
						DistanceFromCharacter_ret = m_Library.LocalPlayer:DistanceFromCharacter(t_PrimaryPart.CFrame.p);
						os_clock_ret2 = os.clock();
					end
					if DistanceFromCharacter_ret <= 800 then
						t_PrimaryPart.CFrame = t_CFrame * CFrame.Angles(math.rad((os.clock() - os_clock_ret) * u1), 0, 0);
					end
					m_Library.RenderStepped();
				end
			end);
			coroutine_wrap_ret();
		end
	end
end
function ShakeAnimation() -- Line: 58
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local FindFirstChild_ret3 = m_Library.WorldCmds.GetMap().Interactive:FindFirstChild("Hacker Portal");
	if FindFirstChild_ret3 then
		local coroutine_wrap_ret2 = coroutine.wrap(function() -- Line: 62
			--[[
				Upvalues:
					[1] = FindFirstChild_ret3
					[2] = m_Library
			--]]
			local t_LocalPlayer = game.Players.LocalPlayer;
			while FindFirstChild_ret3 and FindFirstChild_ret3.Parent do
				local DistanceFromCharacter_ret2 = t_LocalPlayer:DistanceFromCharacter(FindFirstChild_ret3.PrimaryPart.CFrame.p);
				if DistanceFromCharacter_ret2 <= 200 then
					local math_clamp_ret = math.clamp(0.5 - DistanceFromCharacter_ret2 / 200 / 2, 0.03, 0.33);
					m_Library.Shake.Create(0.1, math_clamp_ret, 0.5, false);
					m_Library.Functions.Wait(0.1);
				else
					m_Library.RenderStepped();
				end
			end
		end);
		coroutine_wrap_ret2();
	end
end
function Animations() -- Line: 82
	PortalAnimation();
	ShakeAnimation();
end
m_Library.Signal.Fired("World Changed"):Connect(function(p1) -- Line: 88
	if p1 == "Tech" then
		Animations();
	end
end);
