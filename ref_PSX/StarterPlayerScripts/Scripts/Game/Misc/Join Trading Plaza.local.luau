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
function Request(p1) -- Line: 20
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u3
	--]]
	if not m_Library.WorldCmds.CanDoAction() then return end
	m_Library.Variables.LoadingWorld = true;
	local v1, v2 = m_Library.Network.Invoke("Travel to Trading Plaza", p1);
	if v1 then
		u3 = m_Library.GUIFX.Loading("Trading Plaza");
		return;
	end
	m_Library.Variables.LoadingWorld = false;
	m_Library.Message.New(v2 or "Failed to travel to Trading Plaza.");
end
function Buy() -- Line: 36
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v3 = m_Library.Message.New("Do you want to unlock the Trading Plaza for 1,000,000 Diamonds?", true);
	if v3 then
		local v5, v6 = m_Library.Network.Invoke("Buy Trading Plaza");
		if not v5 then
			m_Library.Message.New(v6 or "Something went wrong.");
			return;
		end
		m_Library.Audio.Play("rbxassetid://7399584366", script, 1, 1.25);
		m_Library.Message.New("\226\156\133 Success!");
	end
end
function Update() -- Line: 50
	--[[
		Upvalues:
			[1] = FindFirstChild_ret
			[2] = m_Library
	--]]
	if not FindFirstChild_ret then return end
	local v4 = m_Library.Save.Get();
	if not v4 then return end
	if v4.OwnsTradingPlaza and FindFirstChild_ret:FindFirstChild("Lock") then
		m_Library.Audio.Play("rbxassetid://7751703357", FindFirstChild_ret.Lock.PrimaryPart.CFrame, 0.8, 1, 150);
		m_Library.WorldFX.ModelFlash(FindFirstChild_ret.Lock, 0.5);
		FindFirstChild_ret.Lock:Destroy();
	end
end
function Setup() -- Line: 70
	--[[
		Upvalues:
			[1] = u1
			[2] = u2
			[3] = m_Library
			[4] = FindFirstChild_ret
			[5] = bool1
	--]]
	Update();
	u1, u2 = m_Library.Interact.Add(FindFirstChild_ret, {dist = 18});
	u1:Connect(function() -- Line: 75
		--[[
			Upvalues:
				[1] = bool1
				[2] = m_Library
		--]]
		if not bool1 then
			bool1 = true;
			local v7 = m_Library.Save.Get();
			if v7 then
				if v7.OwnsTradingPlaza then
					local u4 = false;
					pcall(function() -- Line: 83
						--[[
							Upvalues:
								[1] = u4
								[2] = m_Library
						--]]
						u4 = m_Library.VoiceChatService:IsVoiceEnabledForUserIdAsync(m_Library.LocalPlayer.UserId);
					end);
					m_Library.Signal.Fire("Show Trading Plaza Choice", u4);
				else
					Buy();
				end
			end
			bool1 = false;
		end
	end);
end
function Check() -- Line: 99
	--[[
		Upvalues:
			[1] = m_Library
			[2] = FindFirstChild_ret
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		FindFirstChild_ret = Map.Interactive:FindFirstChild("Trading Plaza Gate");
		if FindFirstChild_ret then
			Setup();
		end
	end
end
m_Library.Signal.Fired("Trading Plaza Request"):Connect(Request);
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 115
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
m_Library.Signal.Fired("Stat Changed"):Connect(function(p2) -- Line: 124
	if p2 == "OwnsTradingPlaza" then
		Update();
	end
end);
m_Library.TeleportService.TeleportInitFailed:Connect(function(_, _, _, _, _) -- Line: 130
	--[[
		Upvalues:
			[1] = u3
	--]]
	if u3 then
		u3();
	end
end);
