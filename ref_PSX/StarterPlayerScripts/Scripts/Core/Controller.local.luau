-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
function update() -- Line: 16
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	if m_Library.Variables.Console == true then
		m_Library.Controller.UpdateSelections();
	end
end
while true do
	update();
	task.wait(0.5);
end
