-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
task.spawn(function() -- Line: 16
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	wait(5);
	if m_Library.Variables.Console then
		m_Library.Network.Fire("Console Player");
	end
end);
