-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local FindFirstChild_ret = nil;
local t_IsHardcore = m_Library.Shared.IsHardcore;
function Unlock() -- Line: 18
	--[[
		Upvalues:
			[1] = FindFirstChild_ret
	--]]
	FindFirstChild_ret:Destroy();
end
function IsUnlocked() -- Line: 23
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_IsHardcore
	--]]
	local v1 = m_Library.Save.Get();
	if v1 then
		return t_IsHardcore and v1.Hardcore.OwnsDominusGate or not t_IsHardcore and v1.OwnsDominusGate;
	end
	return false;
end
function Buy() -- Line: 32
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v2, v3 = m_Library.Network.Invoke("Buy Dominus Gate");
	if not v2 then
		m_Library.Message.New(v3 or "Error");
		return;
	end
	Unlock();
end
function Prompt() -- Line: 42
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_IsHardcore
	--]]
	local v4 = m_Library.WorldCmds.HasArea("Cave");
	if not v4 then
		m_Library.Message.New("(Ad hoc enim estis carnales...)");
		return;
	end
	local v5 = m_Library.Message.New(string.format("Do you wish to sacrifice %s Diamonds?", m_Library.Functions.Commas(t_IsHardcore and 10000000 or 100000)), true);
	if v5 then
		Buy();
	end
end
function Setup() -- Line: 57
	--[[
		Upvalues:
			[1] = m_Library
			[2] = FindFirstChild_ret
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		FindFirstChild_ret = Map.Interactive:FindFirstChild("Dominus Gate");
		if FindFirstChild_ret then
			if IsUnlocked() then
				Unlock();
				return;
			end
			local v6, _ = m_Library.Interact.Add(FindFirstChild_ret.PrimaryPart, {dist = 15});
			v6:Connect(function() -- Line: 66
				Prompt();
			end);
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function(p1) -- Line: 75
	if p1 == "Spawn" then
		Setup();
	end
end);
