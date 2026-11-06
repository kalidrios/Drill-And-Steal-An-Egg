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
	local Interact = FindFirstChild_ret:FindFirstChild("Interact");
	if Interact then
		Interact:Destroy();
	end
end
function IsUnlocked() -- Line: 27
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_IsHardcore
	--]]
	local v1 = m_Library.Save.Get();
	if v1 then
		return t_IsHardcore and v1.CaveShinyBoost;
	end
	return false;
end
function Buy() -- Line: 36
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v2, v3 = m_Library.Network.Invoke("Offer Shiny Relic");
	if not v2 then
		m_Library.Message.New(v3 or "Error");
		return;
	end
	Unlock();
	PlayAnimation();
end
function Prompt() -- Line: 47
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_IsHardcore
	--]]
	local v4 = m_Library.Save.Get();
	if v4 then
		local v7 = v4.Achievements["Unlock Secret Cave"];
		if not t_IsHardcore or not v7 then
			m_Library.Message.New("Leave now... you aren't supposed to be here!");
			return;
		end
		local v8 = m_Library.Message.New("Are you willing to sacrifice 250m Diamonds to the Shiny Relic?", true);
		if v8 then
			Buy();
		end
	end
end
function Setup() -- Line: 64
	--[[
		Upvalues:
			[1] = m_Library
			[2] = FindFirstChild_ret
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		FindFirstChild_ret = Map.Interactive:FindFirstChild("Shiny Relic");
		if FindFirstChild_ret then
			if IsUnlocked() then
				Unlock();
				return;
			end
			local v9, _ = m_Library.Interact.Add(FindFirstChild_ret:WaitForChild("Interact"), {dist = 12});
			if v9 then
				v9:Connect(function() -- Line: 74
					Prompt();
				end);
			end
		end
	end
end
function PlayAnimation(_) -- Line: 84
	--[[
		Upvalues:
			[1] = FindFirstChild_ret
			[2] = m_Library
	--]]
	if not FindFirstChild_ret or not FindFirstChild_ret.PrimaryPart then return end
	m_Library.Audio.Play(11788144854, FindFirstChild_ret:GetPrimaryPartCFrame().p, 1, 1, 400);
	local v5, v6 = m_Library.Functions.CreateParticleHost(FindFirstChild_ret:GetPrimaryPartCFrame().p);
	local Children = m_Library.Assets.Particles:FindFirstChild("Golden Machine"):GetChildren();
	for _, val1 in ipairs(Children) do
		local Clone_ret = val1:Clone();
		Clone_ret.Parent = v6;
		Clone_ret:Emit(40);
	end
	m_Library.Functions.AddDebris(v5, 4);
	m_Library.Functions.Wait(1.5);
	m_Library.Message.New("Offering accepted! Shiny pet chances have been increased! \226\156\168");
end
m_Library.Signal.Fired("World Changed"):Connect(function(p1) -- Line: 109
	--[[
		Upvalues:
			[1] = t_IsHardcore
	--]]
	if p1 == "Secret Cave" and t_IsHardcore then
		Setup();
	end
end);
