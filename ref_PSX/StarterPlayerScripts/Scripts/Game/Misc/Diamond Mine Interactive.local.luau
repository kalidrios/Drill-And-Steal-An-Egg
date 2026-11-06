-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local bool1 = false;
local Interactive = nil;
function Teleport() -- Line: 18
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.WorldCmds.Load("Diamond Mine");
end
function SetupInteract()
	local v1, _ = m_Library.Interact.Add(Interactive:FindFirstChild("Diamond Mine Cave").PrimaryPart, {
		dist = 8,
		label = "Visit Diamond Mine!"
	});
	v1:Connect(function()  
		if not bool1 then
			bool1 = true;
			if not m_Library.Save.Get() then
				bool1 = false
				return 
			end
			local v36 = m_Library.Signal.Invoke("Get Diamond Mine Collpase Time")
			if v36 then
				m_Library.Message.New("The Diamond Mine has collapsed! Reopening in " .. m_Library.Functions.FormatTime(v36))
			else
				Teleport()
			end
			bool1 = false;
		end
	end);
end
function Hook()  
	if not m_Library.Save.Get() then
		return 
	end
	local v61 = m_Library.Signal.Invoke("Get Diamond Mine Collpase Time")
	if v61 then
		return 
	end
	SetupInteract()
end
m_Library.Signal.Fired("World Changed"):Connect(function(p1, p2) -- Line: 38
	--[[
		Upvalues:
			[1] = Interactive
	--]]
	Interactive = nil;
	if p1 == "Spawn" then
		Interactive = p2:FindFirstChild("Interactive");
		Hook();
	end
end);
m_Library.Signal.Fired("Diamond Mine: Setup Interact"):Connect(function()
	SetupInteract()
end)
