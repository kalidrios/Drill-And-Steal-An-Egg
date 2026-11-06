-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local IsStudio_ret = m_Library.RunService:IsStudio();
if not IsStudio_ret then
	m_Library.Print("CLIENT TEST SCRIPT IS ENABLED. MAKE SURE TO DISABLE!", true);
	return;
end
wait(3);
local _ = m_Library.WorldFX.QuestGlow(game.Workspace.__MAP.Areas["Area 1"].Side.building, 1.5);
