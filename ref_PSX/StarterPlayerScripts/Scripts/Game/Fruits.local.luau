-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
function UpdateFruits(_) -- Line: 16
end
m_Library.Signal.Fired("Loaded Stats"):Connect(function(_) -- Line: 21
end);
