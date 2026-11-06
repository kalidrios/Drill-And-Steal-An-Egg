-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local u1 = m_Library.Player.PlayerGui();
function Check(p1) -- Line: 18
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
	--]]
	if p1.ClassName == "ScreenGui" then
		m_Library.Heartbeat();
		p1.Parent = u1;
	end
end
for _, child1 in ipairs(m_Library.LocalPlayer:GetChildren()) do
	Check(child1);
end
m_Library.LocalPlayer.ChildAdded:Connect(function(child) -- Line: 31
	Check(child);
end);
