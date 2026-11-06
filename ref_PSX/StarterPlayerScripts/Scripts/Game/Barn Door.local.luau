-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local FindFirstChild_ret = nil;
local t_IsHardcore = m_Library.Shared.IsHardcore;
local bool1 = false;
local bool2 = false;
function AnimateOpen() -- Line: 20
	--[[
		Upvalues:
			[1] = bool1
			[2] = FindFirstChild_ret
			[3] = m_Library
	--]]
	if bool1 then return end
	bool1 = true;
	local Door1 = FindFirstChild_ret:FindFirstChild("Door1");
	local Door2 = FindFirstChild_ret:FindFirstChild("Door2");
	local t_Position = Door1.Position;
	local t_Position2 = Door2.Position;
	if Door1 and Door2 then
		m_Library.Functions.Tween(Door1, {Position = Vector3.new(6880.327, 99.959, -4012603 / -1000)}, {
			3,
			"Sine",
			"Out"
		});
		m_Library.Functions.Tween(Door2, {Position = Vector3.new(6862.396, 99.959, -4012603 / -1000)}, {
			3,
			"Sine",
			"Out"
		}).Completed:Connect(function() -- Line: 37
			--[[
				Upvalues:
					[1] = Door1
					[2] = t_Position
					[3] = Door2
					[4] = t_Position2
					[5] = bool1
			--]]
			Teleport();
			task.defer(function() -- Line: 40
				--[[
					Upvalues:
						[1] = Door1
						[2] = t_Position
						[3] = Door2
						[4] = t_Position2
						[5] = bool1
				--]]
				Door1.Position = t_Position;
				Door2.Position = t_Position2;
				bool1 = false;
			end);
		end);
	end
end
function IsUnlocked() -- Line: 51
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_IsHardcore
	--]]
	local v1 = m_Library.Save.Get();
	if v1 then
		return t_IsHardcore and m_Library.Functions.SearchDictionary(v1.Hardcore.AreasUnlocked, "Doodle Barn") or not t_IsHardcore and m_Library.Functions.SearchDictionary(v1.AreasUnlocked, "Doodle Barn");
	end
	return false;
end
function Teleport() -- Line: 61
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local FindFirstChild_ret2 = m_Library.WorldCmds.GetMap().Teleports:FindFirstChild("Doodle Barn");
	if FindFirstChild_ret2 then
		local v6 = m_Library.Player.Character();
		local v7 = m_Library.Player.Humanoid();
		m_Library.GUIFX.Flash(0.25, 0.75, Color3.new(255, 255, 255));
		m_Library.Variables.Teleporting = true;
		m_Library.Signal.Fire("Teleporting");
		m_Library.Functions.Wait(0.25);
		v6:SetPrimaryPartCFrame(FindFirstChild_ret2.CFrame + Vector3.new(0, v7.HipHeight + 1, 0));
		m_Library.Audio.Play("rbxassetid://7210953148", script, 1, 1);
		m_Library.Network.Fire("Performed Teleport", "Doodle Barn");
		m_Library.Functions.Wait(0.25);
		m_Library.Variables.Teleporting = false;
		return;
	end
	m_Library.Message.New("Something went wrong. Try again!");
end
function Buy() -- Line: 84
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v2, v3 = m_Library.Network.Invoke("Buy Area", "Doodle Barn");
	if not v2 then
		m_Library.Message.New(v3 or "Error");
		return;
	end
	AnimateOpen();
end
function PromptBuy() -- Line: 94
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v4 = m_Library.WorldCmds.HasArea("Doodle Oasis");
	if not v4 then
		m_Library.Message.New("The cow says moooo!");
		return;
	end
	local v5 = m_Library.Message.New("Are you sure you want to buy this area for 3.25m Cartoon Coins?", true);
	if v5 then
		Buy();
	end
end
function Setup() -- Line: 108
	--[[
		Upvalues:
			[1] = m_Library
			[2] = FindFirstChild_ret
			[3] = bool2
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Gates") then
		FindFirstChild_ret = Map.Gates:FindFirstChild("Doodle Barn");
		if FindFirstChild_ret then
			if IsUnlocked() then
				local v8, _ = m_Library.Interact.Add(FindFirstChild_ret.PrimaryPart, {dist = 6});
				if v8 then
					v8:Connect(function() -- Line: 116
						--[[
							Upvalues:
								[1] = bool2
						--]]
						if not bool2 then
							bool2 = true;
							AnimateOpen();
							bool2 = false;
						end
					end);
				end
			else
				local v9, _ = m_Library.Interact.Add(FindFirstChild_ret.PrimaryPart, {dist = 6});
				if v9 then
					v9:Connect(function() -- Line: 127
						--[[
							Upvalues:
								[1] = bool2
						--]]
						if not bool2 then
							bool2 = true;
							if IsUnlocked() then
								AnimateOpen();
							else
								PromptBuy();
							end
							bool2 = false;
						end
					end);
				end
			end
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function(p1) -- Line: 145
	if p1 == "Doodle" then
		Setup();
	end
end);
