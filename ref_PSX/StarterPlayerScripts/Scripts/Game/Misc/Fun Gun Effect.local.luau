-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
m_Library.Network.Fired("Explode Pet"):Connect(function(p1) 
	m_Library.WorldFX.Explosion(p1);
end);
