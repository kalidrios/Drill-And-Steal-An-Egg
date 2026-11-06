-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local u1 = m_Library.Player.PlayerGui();
local u2 = nil;
if m_Library.Settings.ForcedPortrait then
	u1.ScreenOrientation = Enum.ScreenOrientation.Portrait;
elseif m_Library.Settings.SupportsPortrait then
	u1.ScreenOrientation = Enum.ScreenOrientation.Sensor;
end
function Check() -- Line: 25
	--[[
		Upvalues:
			[1] = u1
			[2] = m_Library
			[3] = u2
	--]]
	local t_CurrentScreenOrientation = u1.CurrentScreenOrientation;
	m_Library.Variables.Orientation = t_CurrentScreenOrientation;
	m_Library.Variables.Portrait = t_CurrentScreenOrientation == Enum.ScreenOrientation.Portrait;
	m_Library.Variables.Landscape = t_CurrentScreenOrientation ~= Enum.ScreenOrientation.Portrait;
	if not u2 or u2 ~= t_CurrentScreenOrientation then
		m_Library.Signal.Fire("Orientation Changed", t_CurrentScreenOrientation, u2);
	end
	u2 = t_CurrentScreenOrientation;
end
while true do
	Check();
	m_Library.Heartbeat();
end
