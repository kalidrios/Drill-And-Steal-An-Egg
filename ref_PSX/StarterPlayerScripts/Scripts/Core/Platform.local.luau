-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local RunService = game:GetService("RunService");
local IsStudio_ret = RunService:IsStudio();
function Update() -- Line: 18
	--[[
		Upvalues:
			[1] = m_Library
			[2] = IsStudio_ret
	--]]
	local t_TouchEnabled = m_Library.UserInputService.TouchEnabled;
	local _ = m_Library.UserInputService.KeyboardEnabled;
	local t_MouseEnabled = m_Library.UserInputService.MouseEnabled;
	local t_GamepadEnabled = m_Library.UserInputService.GamepadEnabled;
	local t_GyroscopeEnabled = m_Library.UserInputService.GyroscopeEnabled;
	local t_AccelerometerEnabled = m_Library.UserInputService.AccelerometerEnabled;
	local t_VREnabled = m_Library.UserInputService.VREnabled;
	local IsTenFootInterface_ret = game:GetService("GuiService"):IsTenFootInterface();
	local bool1 = false;
	local bool2 = false;
	local v1 = false;
	local bool3 = false;
	if t_GamepadEnabled then
		bool1 = true;
	elseif IsTenFootInterface_ret and not t_MouseEnabled then
		bool1 = true;
	elseif t_VREnabled then
		bool3 = true;
		v1 = m_Library.Settings.SupportsVR or false;
	elseif t_TouchEnabled and not t_MouseEnabled then
		bool2 = true;
	elseif t_TouchEnabled and IsStudio_ret then
		bool2 = true;
	elseif t_GyroscopeEnabled or t_AccelerometerEnabled then
		bool2 = true;
	else
		v1 = true;
	end
	local t_Desktop = m_Library.Variables.Desktop;
	local t_Mobile = m_Library.Variables.Mobile;
	local t_Console = m_Library.Variables.Console;
	local t_VR = m_Library.Variables.VR;
	m_Library.Variables.Desktop = v1;
	m_Library.Variables.Mobile = bool2;
	m_Library.Variables.Console = bool1;
	m_Library.Variables.VR = bool3;
	if v1 and not t_Desktop then
		m_Library.Signal.Fire("Changed Platform", "Desktop");
		return;
	end
	if bool2 and not t_Mobile then
		m_Library.Signal.Fire("Changed Platform", "Mobile");
		return;
	end
	if bool1 and not t_Console then
		m_Library.Signal.Fire("Changed Platform", "Console");
		return;
	end
	if bool3 and not t_VR then
		m_Library.Signal.Fire("Changed Platform", "VR");
	end
end
m_Library.UserInputService.GamepadConnected:Connect(Update);
m_Library.UserInputService.GamepadDisconnected:Connect(Update);
while true do
	Update();
	wait(3);
end
