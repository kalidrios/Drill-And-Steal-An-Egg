-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local u1 = nil;
local u2 = nil;
local FindFirstChild_ret = nil;
local bool1 = false;
local u3 = nil;
function Request() -- Line: 20
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u3
	--]]
	if not m_Library.WorldCmds.CanDoAction() then return end
	local v1 = m_Library.Save.Get();
	if not v1 then return end
	local v2 = m_Library.Message.New(m_Library.Shared.IsHardcore and "Return back to normal mode?" or "Are you sure you want to enter Hardcore mode? You won't lose any progress.", true);
	if not v2 then return end
	m_Library.Variables.LoadingWorld = true;
	local v3, v4 = m_Library.Network.Invoke("Toggle Hardcore Mode");
	if v3 then
		if m_Library.Shared.IsHardcore then
			u3 = m_Library.GUIFX.Loading("Normal Mode");
			return;
		end
		u3 = m_Library.GUIFX.Loading("Hardcore Mode");
		return;
	end
	m_Library.Variables.LoadingWorld = false;
	m_Library.Message.New(v4 or "Failed to enter Hardcore Mode.");
end
function Setup() -- Line: 51
	--[[
		Upvalues:
			[1] = u1
			[2] = u2
			[3] = m_Library
			[4] = FindFirstChild_ret
			[5] = bool1
	--]]
	u1, u2 = m_Library.Interact.Add(FindFirstChild_ret, {dist = 18});
	u1:Connect(function() -- Line: 54
		--[[
			Upvalues:
				[1] = bool1
				[2] = m_Library
		--]]
		if not bool1 then
			bool1 = true;
			local v5 = m_Library.Save.Get();
			if v5 then
				if v5.HardcoreUnlocked then
					Request();
				else
					m_Library.Message.New("You must have 25% of the Mastery completed to unlock Hardcore Mode.");
				end
			end
			bool1 = false;
		end
	end);
end
function Check() -- Line: 73
	--[[
		Upvalues:
			[1] = m_Library
			[2] = FindFirstChild_ret
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		FindFirstChild_ret = Map.Interactive:FindFirstChild("Hardcore Portal");
		if FindFirstChild_ret then
			Setup();
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 87
	--[[
		Upvalues:
			[1] = u2
	--]]
	if u2 then
		u2();
		u2 = nil;
	end
	Check();
end);
m_Library.TeleportService.TeleportInitFailed:Connect(function(_, _, _, _, _) -- Line: 95
	--[[
		Upvalues:
			[1] = u3
	--]]
	if u3 then
		u3();
	end
end);
