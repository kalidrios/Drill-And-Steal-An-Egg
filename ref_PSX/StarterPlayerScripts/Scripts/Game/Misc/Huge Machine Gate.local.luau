-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local u1 = nil;
local u2 = nil;
local FindFirstChild_ret = nil;
local bool1 = false;
function Buy() -- Line: 21
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u2
	--]]
	local v1 = m_Library.Message.New("Do you want to unlock the Huge Machine for 10,000,000 Diamonds?", true);
	if v1 then
		local v4, v5 = m_Library.Network.Invoke("Buy Huge Machine");
		if not v4 then
			m_Library.Message.New(v5 or "Something went wrong.");
			return;
		end
		u2();
		u2 = nil;
		m_Library.Audio.Play("rbxassetid://7399584366", script, 1, 1.25);
		m_Library.Message.New("\226\156\133 Success!");
	end
end
function Update() -- Line: 37
	--[[
		Upvalues:
			[1] = FindFirstChild_ret
			[2] = m_Library
	--]]
	if not FindFirstChild_ret then return end
	local v2 = m_Library.Save.Get();
	if not v2 then return end
	if v2.OwnsHugeMachine and FindFirstChild_ret:FindFirstChild("invisible-wall") then
		m_Library.Audio.Play("rbxassetid://7751703357", FindFirstChild_ret.PrimaryPart.CFrame, 0.8, 1, 150);
		FindFirstChild_ret:FindFirstChild("invisible-wall"):Destroy();
		FindFirstChild_ret:FindFirstChild("Interact"):Destroy();
		FindFirstChild_ret.Gate.CanCollide = false;
		FindFirstChild_ret.Gate.Transparency = 1;
		FindFirstChild_ret.Gate.Beam.Enabled = false;
	end
end
function Setup() -- Line: 60
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
			[3] = u2
			[4] = FindFirstChild_ret
			[5] = bool1
	--]]
	Update();
	local v3 = m_Library.Save.Get();
	if not v3 then return end
	if v3.OwnsHugeMachine then return end
	u1, u2 = m_Library.Interact.Add(FindFirstChild_ret.Interact, {
		dist = 18,
		label = "Buy Huge Machine!"
	});
	u1:Connect(function() -- Line: 74
		--[[
			Upvalues:
				[1] = bool1
				[2] = m_Library
		--]]
		if not bool1 then
			bool1 = true;
			local v6 = m_Library.Save.Get();
			if v6 and not v6.OwnsHugeMachine then
				Buy();
			end
			bool1 = false;
		end
	end);
end
function Check() -- Line: 91
	--[[
		Upvalues:
			[1] = m_Library
			[2] = FindFirstChild_ret
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		FindFirstChild_ret = Map.Interactive:FindFirstChild("Huge Machine Gate");
		if FindFirstChild_ret then
			Setup();
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 105
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
m_Library.Signal.Fired("Stat Changed"):Connect(function(p1) -- Line: 114
	if p1 == "OwnsHugeMachine" then
		Update();
	end
end);
