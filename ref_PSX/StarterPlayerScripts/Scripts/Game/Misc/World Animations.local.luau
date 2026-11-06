-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local _ = Random.new();
function ObliskAnimations() -- Line: 42
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	local Volcano = Map.Areas:FindFirstChild("Volcano");
	local Children = Volcano:FindFirstChild("Oblisks"):GetChildren();
	local os_clock_ret = os.clock();
	local os_clock_ret2 = nil;
	local DistanceFromCharacter_ret = nil;
	local function Tick() -- Line: 51
		--[[
			Upvalues:
				[1] = os_clock_ret2
				[2] = DistanceFromCharacter_ret
				[3] = m_Library
				[4] = Volcano
				[5] = os_clock_ret
				[6] = Children
		--]]
		if not os_clock_ret2 or os.clock() - os_clock_ret2 >= 2 then
			DistanceFromCharacter_ret = m_Library.Player.Player():DistanceFromCharacter(Volcano.Ground.CFrame.p);
			os_clock_ret2 = os.clock();
		end
		if DistanceFromCharacter_ret >= 600 then return end
		local v1 = os.clock() - os_clock_ret;
		for _, val1 in ipairs(Children) do
			local Spell = val1:FindFirstChild("Spell");
			Spell:SetPrimaryPartCFrame(val1:FindFirstChild("Center").CFrame * CFrame.Angles(0, math.rad(v1 * 10), 0) + Vector3.new(0, math.sin(v1 / 5) * 5, 0));
		end
	end
	local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 69
		--[[
			Upvalues:
				[1] = Map
				[2] = Tick
				[3] = m_Library
		--]]
		while Map.Parent do
			Tick();
			m_Library.Stepped();
		end
	end);
	coroutine_wrap_ret();
end
m_Library.Signal.Fired("World Changed"):Connect(function(p1) -- Line: 78
	local _ = p1 == "Spawn";
end);
