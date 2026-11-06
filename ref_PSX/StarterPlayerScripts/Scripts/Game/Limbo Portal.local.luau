-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local _ = m_Library.Shared.IsHardcore;
local bool1 = false;
local FindFirstChild_ret = nil;
function TryTravel() -- Line: 18
	--[[
		Upvalues:
			[1] = m_Library
			[2] = FindFirstChild_ret
	--]]
	local v1 = m_Library.Save.Get();
	if not v1 then return end
	assert(v1);
	local v2 = m_Library.Message.New("Step into the portal?", true);
	if v2 then
		if not FindFirstChild_ret:GetAttribute("RequiredArea") or m_Library.WorldCmds.HasArea(FindFirstChild_ret:GetAttribute("RequiredArea")) then
			m_Library.Audio.Play("rbxassetid://7210953203", m_Library.Player.PrimaryPart(), 1, 1, 325);
			m_Library.WorldCmds.Load(FindFirstChild_ret:GetAttribute("DestinationWorld"));
			return;
		end
		m_Library.Audio.Play("rbxassetid://8803688837", m_Library.Player.PrimaryPart(), 4, 1, 325);
		local LaunchDirection = FindFirstChild_ret.PrimaryPart:FindFirstChild("LaunchDirection");
		local t_Character = m_Library.LocalPlayer.Character;
		if t_Character then
			local t_PrimaryPart = t_Character.PrimaryPart;
			if t_PrimaryPart then
				t_PrimaryPart.Velocity = LaunchDirection.WorldCFrame.UpVector * 250;
				task.delay(2.5, function() -- Line: 39
					--[[
						Upvalues:
							[1] = m_Library
					--]]
					m_Library.Message.New("Primum oportet Cat Regnum reserare!");
				end);
			end
		end
	end
end
function Clicked() -- Line: 49
	TryTravel();
end
function Setup() -- Line: 54
	--[[
		Upvalues:
			[1] = FindFirstChild_ret
			[2] = m_Library
			[3] = bool1
	--]]
	local v3, _ = m_Library.Interact.Add(FindFirstChild_ret:FindFirstChild("_INTERACT").CFrame.p, {dist = 30});
	v3:Connect(function() -- Line: 57
		--[[
			Upvalues:
				[1] = bool1
		--]]
		if not bool1 then
			bool1 = true;
			Clicked();
			bool1 = false;
		end
	end);
end
function Check() -- Line: 75
	--[[
		Upvalues:
			[1] = m_Library
			[2] = FindFirstChild_ret
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		FindFirstChild_ret = Map.Interactive:FindFirstChild("Limbo Portal");
		if FindFirstChild_ret then
			Setup();
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 90
	Check();
end);
