-- https://github.com/kalidrios
-- Join UGC Vault (based on Join Trading Plaza pattern)

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local u1 = nil;
local u2 = nil;
local FindFirstChild_ret = nil;
local bool1 = false;
local u3 = nil;
function Request() -- Travel to Vault
	if not m_Library.WorldCmds.CanDoAction() then return end
	m_Library.Variables.LoadingWorld = true;
	local v1, v2 = m_Library.Network.Invoke("Travel to UGC Vault");
	if v1 then
		u3 = m_Library.GUIFX.Loading("UGC Vault");
		return;
	end
	m_Library.Variables.LoadingWorld = false;
	m_Library.Message.New(v2 or "Failed to travel to UGC Vault.");
end
function Buy()
	local sv = m_Library.Save.Get();
	if not sv then return end
	-- Show inflated price for non-Cave players (anti-cheat troll)
	local hasCave = sv.AreasUnlocked and m_Library.Functions.SearchDictionary(sv.AreasUnlocked, "Cave")
	local cost = hasCave and 100 or 180
	local v3 = m_Library.Message.New("Do you want to unlock the UGC Vault for " .. cost .. " Paw Tokens?", true);
	if v3 then
		local v5, v6 = m_Library.Network.Invoke("Buy UGC Gate");
		if not v5 then
			m_Library.Message.New(v6 or "Something went wrong.");
			return;
		end
		m_Library.Audio.Play("rbxassetid://7399584366", script, 1, 1.25);
		m_Library.Message.New("✅ Success!");
		Update(); -- Force update immediately
	end
end
function Update()
	if not FindFirstChild_ret then return end
	local v4 = m_Library.Save.Get();
	if not v4 then return end
	if v4.OwnsUGCVault and FindFirstChild_ret:FindFirstChild("Lock") then
		m_Library.Audio.Play("rbxassetid://7751703357", FindFirstChild_ret.Lock.PrimaryPart.CFrame, 0.8, 1, 150);
		m_Library.WorldFX.ModelFlash(FindFirstChild_ret.Lock, 0.5);
		FindFirstChild_ret.Lock:Destroy();
	end
end
function Setup()
	Update();
	u1, u2 = m_Library.Interact.Add(FindFirstChild_ret, {dist = 18});
	u1:Connect(function()
		if not bool1 then
			bool1 = true;
			local v7 = m_Library.Save.Get();
			if v7 then
				if v7.OwnsUGCVault then
					Request();
				else
					Buy();
				end
			end
			bool1 = false;
		end
	end);
end
function Check()
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		FindFirstChild_ret = Map.Interactive:FindFirstChild("UGC Gate");
		if FindFirstChild_ret then
			Setup();
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function()
	if u2 then
		u2();
		u2 = nil;
	end
	Check();
end);
m_Library.Signal.Fired("Stat Changed"):Connect(function(p2)
	if p2 == "OwnsUGCVault" then
		Update();
	end
end);
m_Library.TeleportService.TeleportInitFailed:Connect(function(_, _, _, _, _)
	if u3 then
		u3();
	end
end);
