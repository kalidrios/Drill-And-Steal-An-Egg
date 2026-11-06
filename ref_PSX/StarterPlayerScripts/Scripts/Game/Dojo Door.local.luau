-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local FindFirstChild_ret = nil;
local t_IsHardcore = m_Library.Shared.IsHardcore;
function Unlock(p1) -- Line: 18
	--[[
		Upvalues:
			[1] = FindFirstChild_ret
			[2] = m_Library
	--]]
	FindFirstChild_ret:SetAttribute("Unlocked", true);
	local Lock = FindFirstChild_ret:FindFirstChild("Lock");
	if Lock and p1 then
		m_Library.Audio.Play("rbxassetid://7751703357", Lock.CFrame.p, 0.8, 1, 150);
		m_Library.WorldFX.ModelFlash(Lock, 0.3);
		Lock:Destroy();
		return;
	end
	if Lock then
		Lock:Destroy();
	end
end
function IsUnlocked() -- Line: 32
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_IsHardcore
	--]]
	local v1 = m_Library.Save.Get();
	if v1 then
		return t_IsHardcore and m_Library.Functions.SearchDictionary(v1.Hardcore.AreasUnlocked, "Kawaii Dojo") or not t_IsHardcore and m_Library.Functions.SearchDictionary(v1.AreasUnlocked, "Kawaii Dojo");
	end
	return false;
end
function Teleport() -- Line: 42
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local FindFirstChild_ret2 = m_Library.WorldCmds.GetMap().Teleports:FindFirstChild("Kawaii Dojo");
	if FindFirstChild_ret2 then
		local v6 = m_Library.Player.Character();
		local v7 = m_Library.Player.Humanoid();
		m_Library.GUIFX.Flash(0.25, 0.75, Color3.new(255, 255, 255));
		m_Library.Variables.Teleporting = true;
		m_Library.Signal.Fire("Teleporting");
		m_Library.Functions.Wait(0.25);
		v6:SetPrimaryPartCFrame(FindFirstChild_ret2.CFrame + Vector3.new(0, v7.HipHeight + 1, 0));
		m_Library.Audio.Play("rbxassetid://7210953148", script, 1, 1);
		m_Library.Network.Fire("Performed Teleport", "Kawaii Dojo");
		m_Library.Functions.Wait(0.25);
		m_Library.Variables.Teleporting = false;
		return;
	end
	m_Library.Message.New("Something went wrong. Try again!");
end
function Buy() -- Line: 65
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v2, v3 = m_Library.Network.Invoke("Buy Area", "Kawaii Dojo");
	if not v2 then
		m_Library.Message.New(v3 or "Error");
		return;
	end
	Unlock(true);
end
function PromptBuy() -- Line: 75
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v4 = m_Library.WorldCmds.HasArea("Kawaii Temple");
	if not v4 then
		m_Library.Message.New("\227\129\130\227\129\170\227\129\159\227\129\175\227\129\181\227\129\149\227\130\143\227\129\151\227\129\143\227\129\130\227\130\138\227\129\190\227\129\155\227\130\147\239\188\129");
		return;
	end
	local v5 = m_Library.Message.New("Are you sure you want to buy this area for 45b Cartoon Coins?", true);
	if v5 then
		Buy();
	end
end
function Setup() -- Line: 89
	--[[
		Upvalues:
			[1] = m_Library
			[2] = FindFirstChild_ret
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Gates") then
		FindFirstChild_ret = Map.Gates:FindFirstChild("Kawaii Dojo");
		if FindFirstChild_ret then
			if IsUnlocked() then
				Unlock(false);
				local v8, _ = m_Library.Interact.Add(FindFirstChild_ret.PrimaryPart, {
					dist = 12,
					label = "Enter Dojo!"
				});
				if v8 then
					v8:Connect(function() -- Line: 99
						Teleport();
					end);
				end
			else
				local v9, _ = m_Library.Interact.Add(FindFirstChild_ret.PrimaryPart, {
					dist = 12,
					label = "Enter Dojo!"
				});
				if v9 then
					v9:Connect(function() -- Line: 106
						--[[
							Upvalues:
								[1] = FindFirstChild_ret
						--]]
						if FindFirstChild_ret:GetAttribute("Unlocked") then
							Teleport();
							return;
						end
						PromptBuy();
					end);
				end
			end
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function(p2) -- Line: 120
	if p2 == "Kawaii" then
		Setup();
	end
end);
