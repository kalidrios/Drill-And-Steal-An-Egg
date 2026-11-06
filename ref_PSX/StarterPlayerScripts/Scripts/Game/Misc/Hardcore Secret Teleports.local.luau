-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local table1 = {};
local bool1 = false;
function Teleport(p1) -- Line: 18
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	Clear();
	local Lock = p1:FindFirstChild("Lock");
	m_Library.Audio.Play("rbxassetid://7751703357", Lock.CFrame.p, 0.8, 1, 150);
	m_Library.WorldFX.ModelFlash(Lock, 0.3);
	Lock:Destroy();
	wait(1.25);
	local Attribute = p1:GetAttribute("TeleportTo");
	m_Library.WorldCmds.Load(Attribute);
end
function Attempt(p2) -- Line: 32
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local function LockedAnimation() -- Line: 33
		--[[
			Upvalues:
				[1] = m_Library
				[2] = p2
		--]]
		m_Library.Message.New("It's locked.");
		m_Library.Audio.Play("rbxassetid://10344377360", p2:FindFirstChild("Lock").CFrame.p, 0.8, 1, 100);
	end
	if not m_Library.WorldCmds.CanDoAction() then return end
	local v2 = m_Library.Save.Get();
	if not v2 or not v2.HardcoreUnlocked or not m_Library.Shared.IsHardcore then
		return LockedAnimation();
	end
	local Attribute2 = p2:GetAttribute("RequiredArea");
	if not m_Library.WorldCmds.HasArea(Attribute2) then
		return LockedAnimation();
	end
	local v3 = m_Library.Message.New("Do you want to enter?", true);
	if v3 then
		Teleport(p2);
	end
end
function Setup(p3) -- Line: 60
	--[[
		Upvalues:
			[1] = m_Library
			[2] = bool1
			[3] = table1
	--]]
	local v4, v5 = m_Library.Interact.Add(p3:FindFirstChild("Interact"), {dist = 8});
	v4:Connect(function() -- Line: 62
		--[[
			Upvalues:
				[1] = bool1
				[2] = p3
		--]]
		if not bool1 then
			bool1 = true;
			Attempt(p3);
			bool1 = false;
		end
	end);
	table1[p3] = v5;
end
function Check() -- Line: 74
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	local Interactive = Map:FindFirstChild("Interactive");
	if Interactive then
		for _, child2 in Interactive:GetChildren() do
			if child2.Name ~= "Hardcore Secret Teleport" then continue end
			Setup(child2);
		end
	end
end
function Clear() -- Line: 87
	--[[
		Upvalues:
			[1] = table1
	--]]
	for _, val1 in pairs(table1) do
		val1();
	end
	table1 = {};
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 98
	Clear();
	Check();
end);
