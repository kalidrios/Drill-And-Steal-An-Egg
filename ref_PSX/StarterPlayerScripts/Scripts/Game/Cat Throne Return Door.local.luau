-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local FindFirstChild_ret = nil;
local _ = m_Library.Shared.IsHardcore;
function Teleport() -- Line: 18
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local FindFirstChild_ret2 = m_Library.WorldCmds.GetMap().Teleports:FindFirstChild("Dog Park");
	if FindFirstChild_ret2 then
		local v1 = m_Library.Player.Character();
		local v2 = m_Library.Player.Humanoid();
		m_Library.GUIFX.Flash(0.25, 0.75, Color3.new(255, 255, 255));
		m_Library.Variables.Teleporting = true;
		m_Library.Signal.Fire("Teleporting");
		m_Library.Functions.Wait(0.25);
		v1:SetPrimaryPartCFrame(FindFirstChild_ret2.CFrame + Vector3.new(0, v2.HipHeight + 1, 0));
		m_Library.Audio.Play("rbxassetid://7210953148", script, 1, 1);
		m_Library.Network.Fire("Performed Teleport", "Dog Park");
		m_Library.Functions.Wait(0.25);
		m_Library.Variables.Teleporting = false;
		return;
	end
	m_Library.Message.New("Something went wrong. Try again!");
end
function Setup() -- Line: 40
	--[[
		Upvalues:
			[1] = m_Library
			[2] = FindFirstChild_ret
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		FindFirstChild_ret = Map.Interactive:FindFirstChild("Throne Return Door");
		if FindFirstChild_ret then
			local v3, _ = m_Library.Interact.Add(FindFirstChild_ret.PrimaryPart, {dist = 12});
			if v3 then
				v3:Connect(function() -- Line: 47
					Teleport();
				end);
			end
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function(p1) -- Line: 56
	if p1 == "Cat" then
		Setup();
	end
end);
