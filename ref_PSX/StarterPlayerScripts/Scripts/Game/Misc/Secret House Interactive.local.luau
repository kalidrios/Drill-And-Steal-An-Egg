-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local bool1 = false;
local Interactive = nil;
function Give() -- Line: 18
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	if not m_Library.WorldCmds.CanDoAction() then return end
	local v1, v2 = m_Library.Network.Invoke("Give Purple Hoverboard");
	if not v1 then
		m_Library.Message.New(v2 or "Something went wrong.");
	end
end
function Has() -- Line: 30
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v3 = m_Library.Save.Get(nil, true);
	if not v3 then return end
	return m_Library.Functions.SearchArray(v3.Hoverboards, "Purple");
end
function Teleport() -- Line: 40
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.WorldCmds.Load("Spawn");
end
function Hook() -- Line: 45
	--[[
		Upvalues:
			[1] = m_Library
			[2] = Interactive
			[3] = bool1
	--]]
	local v4, _ = m_Library.Interact.Add(Interactive:FindFirstChild("Hoverboard"), {dist = 8});
	v4:Connect(function() -- Line: 47
		--[[
			Upvalues:
				[1] = bool1
		--]]
		if not bool1 then
			bool1 = true;
			Give();
			bool1 = false;
		end
	end);
	local v5, _ = m_Library.Interact.Add(Interactive:FindFirstChild("Door").PrimaryPart, {dist = 8});
	v5:Connect(function() -- Line: 56
		--[[
			Upvalues:
				[1] = bool1
		--]]
		if not bool1 then
			bool1 = true;
			Teleport();
			bool1 = false;
		end
	end);
end
function Update() -- Line: 66
	--[[
		Upvalues:
			[1] = Interactive
	--]]
	if Has() and Interactive then
		Interactive:FindFirstChild("Hoverboard"):Destroy();
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function(p1, p2) -- Line: 77
	--[[
		Upvalues:
			[1] = Interactive
	--]]
	Interactive = nil;
	if p1 == "Secret House" then
		Interactive = p2:FindFirstChild("Interactive");
		Hook();
		Update();
	end
end);
m_Library.Signal.Fired("Stat Changed"):Connect(function(p3) -- Line: 87
	if p3 == "Hoverboards" then
		Update();
	end
end);
