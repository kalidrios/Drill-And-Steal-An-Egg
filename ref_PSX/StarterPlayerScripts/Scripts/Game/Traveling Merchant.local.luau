-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
if m_Library.Shared.IsHardcore then return end
local u1 = nil;
local u2 = nil;
local u3 = false;
local u4 = false;
function UpdateTimer() -- Line: 24
	--[[
		Upvalues:
			[1] = u1
			[2] = u2
			[3] = m_Library
	--]]
	if not u1 then return end
	if not u2 then
		local v5, v6 = m_Library.Network.Invoke("Get Merchant Timer");
		if not v5 then
			u2 = nil;
			return;
		end
		local v7 = v6 - v5;
		u2 = os.clock() + v7;
	end
	local v1 = u2 - os.clock();
	local Sign = u1:FindFirstChild("Sign");
	if Sign then
		if v1 <= 5 then
			Sign.SurfaceGui.Timer.Text = "Leaving...";
			return;
		end
		Sign.SurfaceGui.Timer.Text = m_Library.Functions.TimerString(v1);
	end
end
function Show() -- Line: 52
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u4
			[3] = u1
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	local v2 = m_Library.WorldCmds.Get();
	if u4 then
		u1 = m_Library.Assets.Models:FindFirstChild(v2 == "Spawn" and "Secret Merchant" or "Secret Merchant (Trading Plaza)"):Clone();
	else
		u1 = m_Library.Assets.Models:FindFirstChild(v2 == "Spawn" and "Traveling Merchant" or "Traveling Merchant (Trading Plaza)"):Clone();
	end
	u1.Parent = Map.Interactive;
	m_Library.Audio.Play("rbxassetid://7399584411", u1.PrimaryPart, 1, 0.33, 125, nil, true);
end
function Depart() -- Line: 66
	--[[
		Upvalues:
			[1] = u2
			[2] = u1
	--]]
	u2 = nil;
	if not u1 then return end
	u1:Destroy();
	u1 = nil;
end
function Check() -- Line: 78
	--[[
		Upvalues:
			[1] = u1
			[2] = u3
			[3] = m_Library
	--]]
	if u1 and not u3 then
		Depart();
	end
	if not u3 then return end
	local v3 = m_Library.WorldCmds.Get();
	local v4 = v3 == "Spawn" and true or v3 == "Trading Plaza";
	if not v4 and u1 then
		u1 = nil;
		return;
	end
	if v4 and not u1 then
		Show();
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 101
	--[[
		Upvalues:
			[1] = u1
	--]]
	u1 = nil;
	Check();
end);
m_Library.Network.Fired("Merchant Departed"):Connect(function() -- Line: 107
	--[[
		Upvalues:
			[1] = u3
	--]]
	u3 = false;
	Check();
end);
m_Library.Network.Fired("Merchant Arrival"):Connect(function(p1) -- Line: 113
	--[[
		Upvalues:
			[1] = u3
			[2] = u4
	--]]
	u3 = true;
	u4 = p1;
	Check();
end);
task.spawn(function() -- Line: 120
	--[[
		Upvalues:
			[1] = u3
			[2] = u4
			[3] = m_Library
	--]]
	u3, u4 = m_Library.Network.Invoke("Is Merchant Here");
end);
local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 128
	--[[
		Upvalues:
			[1] = u1
	--]]
	while true do
		if u1 then
			UpdateTimer();
		end
		wait(0.5);
	end
end);
coroutine_wrap_ret();
