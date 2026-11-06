-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_IsHardcore = m_Library.Shared.IsHardcore;
local bool1 = false;
local Interactive = nil;
function Give() -- Line: 19
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	if not m_Library.WorldCmds.CanDoAction() then return end
	local v1, v2 = m_Library.Network.Invoke("Give Doodle Hoverboard");
	if not v1 then
		m_Library.Message.New(v2 or "Something went wrong.");
	end
end
function Has() -- Line: 31
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v3 = m_Library.Save.Get();
	if not v3 then
		return false;
	end
	return m_Library.Functions.SearchArray(v3.Hoverboards, "Doodle");
end
function Teleport() -- Line: 41
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local FindFirstChild_ret = m_Library.WorldCmds.GetMap().Teleports:FindFirstChild("Doodle Farm");
	if FindFirstChild_ret then
		local v6 = m_Library.Player.Character();
		local v7 = m_Library.Player.Humanoid();
		m_Library.GUIFX.Flash(0.25, 0.75, Color3.new(255, 255, 255));
		m_Library.Variables.Teleporting = true;
		m_Library.Signal.Fire("Teleporting");
		m_Library.Functions.Wait(0.25);
		v6:SetPrimaryPartCFrame(FindFirstChild_ret.CFrame + Vector3.new(0, v7.HipHeight + 1, 0));
		m_Library.Audio.Play("rbxassetid://7210953148", script, 1, 1);
		m_Library.Network.Fire("Performed Teleport", "Doodle Farm");
		m_Library.Functions.Wait(0.25);
		m_Library.Variables.Teleporting = false;
		return;
	end
	m_Library.Message.New("Something went wrong. Try again!");
end
function Hook() -- Line: 64
	--[[
		Upvalues:
			[1] = m_Library
			[2] = Interactive
			[3] = bool1
	--]]
	local v4, _ = m_Library.Interact.Add(Interactive:FindFirstChild("Hoverboard"), {dist = 8});
	v4:Connect(function() -- Line: 66
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
	local v5, _ = m_Library.Interact.Add(Interactive:FindFirstChild("Barn Return Door").PrimaryPart, {dist = 8});
	v5:Connect(function() -- Line: 75
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
function Update() -- Line: 85
	--[[
		Upvalues:
			[1] = Interactive
			[2] = t_IsHardcore
	--]]
	if Interactive and (not t_IsHardcore or Has()) then
		local Hoverboard = Interactive:FindFirstChild("Hoverboard");
		if Hoverboard then
			Hoverboard:Destroy();
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function(p1, p2) -- Line: 98
	--[[
		Upvalues:
			[1] = Interactive
	--]]
	Interactive = nil;
	if p1 == "Doodle" then
		Interactive = p2:FindFirstChild("Interactive");
		Hook();
		Update();
	end
end);
m_Library.Signal.Fired("Stat Changed"):Connect(function(p3) -- Line: 108
	if p3 == "Hoverboards" then
		Update();
	end
end);
