-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_ID = m_Library.Directory.Gamepasses["Auto Hatch"].ID;
function AttemptHatch() -- Line: 17
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v1 = m_Library.Save.Get();
	if not v1 then return end
	local t_AutoHatchEggId = m_Library.Variables.AutoHatchEggId;
	if not t_AutoHatchEggId then return end
	local v2 = v1.AutoHatchSettings.TripleEggs or false;
	local v3 = v1.AutoHatchSettings.OctupleEggs or false;
	local v4, v5 = m_Library.Network.Invoke("Buy Egg", t_AutoHatchEggId, v2, v3);
	if not v4 then
		m_Library.Signal.Fire("Notification", "Failed to buy egg (" .. (v5 or "An error occurred") .. ")", {color = Color3.fromRGB(255, 46, 46)});
		if v1.AutoHatchSettings.StopOnFailure then
			m_Library.Variables.AutoHatchEnabled = false;
			m_Library.Variables.AutoHatchEggId = nil;
			m_Library.Signal.Fire("Notification", "Auto Hatch is now turned off", {color = Color3.fromRGB(255, 46, 46)});
		end
	end
end
function CanPerform() -- Line: 44
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_ID
	--]]
	if not m_Library.Gamepasses.Owns(t_ID) then return end
	if not m_Library.WorldCmds.CanDoAction() then return end
	return m_Library.Variables.AutoHatchEnabled;
end
task.spawn(function() -- Line: 56
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_ID
	--]]
	local bool1 = false;
	while true do
		if bool1 then return end
		if not m_Library.WorldCmds.CanDoAction() then
			m_Library.Heartbeat(5);
		else
			bool1 = true;
			if not m_Library.Gamepasses.Owns(t_ID) then return end
			local LocalPlayerTeleportData = m_Library.TeleportService:GetLocalPlayerTeleportData();
			if LocalPlayerTeleportData ~= nil then
				local t_AutoHatchEnabled = LocalPlayerTeleportData.AutoHatchEnabled;
				local t_AutoHatchEggId2 = LocalPlayerTeleportData.AutoHatchEggId;
				if t_AutoHatchEnabled ~= nil and typeof(t_AutoHatchEnabled) == "boolean" and t_AutoHatchEggId2 ~= nil and typeof(t_AutoHatchEggId2) == "string" then
					if not m_Library.Directory.Eggs[t_AutoHatchEggId2] then return end
					if not m_Library.Signal.Invoke("Can Continue Auto") then return end
					m_Library.Variables.AutoHatchEnabled = t_AutoHatchEnabled;
					m_Library.Variables.AutoHatchEggId = t_AutoHatchEggId2;
					AttemptHatch();
				end
			end
		end
	end
end);
while true do
	if CanPerform() then
		wait(0.75);
		if CanPerform() then
			AttemptHatch();
		end
	end
	m_Library.Heartbeat(5);
end
