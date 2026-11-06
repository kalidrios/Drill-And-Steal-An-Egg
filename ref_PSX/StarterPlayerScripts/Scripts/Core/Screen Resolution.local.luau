-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local u1 = m_Library.Player.Camera();
local t_ViewportSize = nil;
local u2 = nil;
function UpdateResolution() -- Line: 19
	--[[
		Upvalues:
			[1] = t_ViewportSize
			[2] = u1
			[3] = u2
			[4] = m_Library
	--]]
	t_ViewportSize = u1.ViewportSize;
	u2 = m_Library.Functions.ResolutionScale();
	m_Library.Variables.Resolution = t_ViewportSize;
	m_Library.Variables.ResolutionScale = u2;
	m_Library.Signal.Fire("Resolution Changed", t_ViewportSize, u2);
end
u1:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateResolution);
UpdateResolution();
