-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
m_Library.Network.Fired("Force Load World"):Connect(function(p1) -- Line: 16
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.WorldCmds.Load(p1);
end);
