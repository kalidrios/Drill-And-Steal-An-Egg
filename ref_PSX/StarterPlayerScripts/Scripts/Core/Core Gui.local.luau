-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local StarterGui = game:GetService("StarterGui");
wait();
StarterGui:SetCoreGuiEnabled("Health", false);
StarterGui:SetCoreGuiEnabled("Backpack", false);
StarterGui.ResetPlayerGuiOnSpawn = false;
StarterGui:SetCore("ResetButtonCallback", false);
