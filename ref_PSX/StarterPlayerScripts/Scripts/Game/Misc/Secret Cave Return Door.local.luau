-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local FindFirstChild_ret = nil;
local _ = m_Library.Shared.IsHardcore;
function Teleport() -- Line: 18
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.WorldCmds.Load("Fantasy");
end
function Setup() -- Line: 23
	--[[
		Upvalues:
			[1] = m_Library
			[2] = FindFirstChild_ret
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		FindFirstChild_ret = Map.Interactive:FindFirstChild("Secret Cave Return Door");
		if FindFirstChild_ret then
			local v1, _ = m_Library.Interact.Add(FindFirstChild_ret.PrimaryPart, {dist = 12});
			if v1 then
				v1:Connect(function() -- Line: 30
					Teleport();
				end);
			end
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function(p1) -- Line: 39
	if p1 == "Secret Cave" then
		Setup();
	end
end);
