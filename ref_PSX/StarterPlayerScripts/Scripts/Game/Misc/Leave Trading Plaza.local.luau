-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local u1 = nil;
local u2 = nil;
local bool1 = false;
local u3 = nil;
function Request() -- Line: 19
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u3
	--]]
	m_Library.Variables.LoadingWorld = true;
	local v1, v2 = m_Library.Network.Invoke("Travel to Main World");
	if v1 then
		u3 = m_Library.GUIFX.Loading("Spawn");
		return;
	end
	m_Library.Variables.LoadingWorld = false;
	m_Library.Message.New(v2 or "Failed to travel back to Spawn.");
end
function Setup(p1) -- Line: 31
	--[[
		Upvalues:
			[1] = u1
			[2] = u2
			[3] = m_Library
			[4] = bool1
	--]]
	u1, u2 = m_Library.Interact.Add(p1, {dist = 18});
	if not u1 then return end
	u1:Connect(function() -- Line: 37
		--[[
			Upvalues:
				[1] = bool1
		--]]
		if not bool1 then
			bool1 = true;
			Request();
			bool1 = false;
		end
	end);
end
function Check() -- Line: 47
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	if not m_Library.Shared.IsTradingPlaza then return end
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		local FindFirstChild_ret = Map.Interactive:FindFirstChild("Leave Gate");
		if FindFirstChild_ret then
			Setup(FindFirstChild_ret);
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 65
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
m_Library.TeleportService.TeleportInitFailed:Connect(function(_, _, _, _, _) -- Line: 73
	--[[
		Upvalues:
			[1] = u3
	--]]
	if u3 then
		u3();
	end
end);
