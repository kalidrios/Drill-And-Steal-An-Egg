-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local bool1 = false;
local Interactive = nil;
function Teleport() -- Line: 18
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.WorldCmds.Load("Spawn");
end
function Hook() -- Line: 23
	--[[
		Upvalues:
			[1] = m_Library
			[2] = Interactive
			[3] = bool1
	--]]
	local v1, _ = m_Library.Interact.Add(Interactive:FindFirstChild("Diamond Mine Exit").PrimaryPart, {
		dist = 8,
		label = "Return to Spawn!"
	});
	v1:Connect(function() -- Line: 25
		--[[
			Upvalues:
				[1] = bool1
		--]]
		if not bool1 then
			bool1 = true;
			Teleport();
			bool1 = false;
		end
	end);
end
m_Library.Signal.Fired("World Changed"):Connect(function(p1, p2) -- Line: 38
	--[[
		Upvalues:
			[1] = Interactive
	--]]
	Interactive = nil;
	if p1 == "Diamond Mine" then
		Interactive = p2:FindFirstChild("Interactive");
		Hook();
	end
end);
