-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local Pad = nil;
local u1 = nil;
local os_clock_ret = nil;
function Animation() -- Line: 18
	--[[
		Upvalues:
			[1] = Pad
			[2] = m_Library
	--]]
	if not Pad then return end
	m_Library.Audio.Play("rbxassetid://7055150312", Pad, 1, 1, 350);
	local Clone_ret = m_Library.Assets.Particles:FindFirstChild("Rank Redeem"):Clone();
	Clone_ret.Parent = Pad;
	Clone_ret:Emit(50);
	m_Library.Functions.AddDebris(Clone_ret, 5);
end
function Redeem() -- Line: 32
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v1 = m_Library.Network.Invoke("Redeem Rank Rewards");
	if v1 then
		Animation();
	else
		m_Library.Message.New("Could not redeem rewards.");
	end
	wait(3);
end
function Raycast() -- Line: 43
	--[[
		Upvalues:
			[1] = m_Library
			[2] = Pad
	--]]
	if not m_Library.WorldCmds.CanDoAction() then return end
	local v2 = m_Library.Player.UpperTorso();
	if not Pad or not v2 then return end
	local RaycastParams_new_ret = RaycastParams.new();
	RaycastParams_new_ret.FilterDescendantsInstances = {Pad};
	RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Whitelist;
	local Raycast_ret = workspace:Raycast(v2.CFrame.p, Vector3.new(0, -1, 0).Unit * 25, RaycastParams_new_ret);
	if Raycast_ret and Raycast_ret.Instance then
		Redeem();
	end
end
function UpdateHUD() -- Line: 64
	--[[
		Upvalues:
			[1] = Pad
			[2] = m_Library
			[3] = u1
			[4] = os_clock_ret
	--]]
	if not Pad then return end
	local v3 = m_Library.Save.Get();
	if not v3 then return end
	local BillboardGui = Pad:FindFirstChildOfClass("BillboardGui");
	if not BillboardGui or not BillboardGui:FindFirstChild("Timer") then return end
	local t_Rank = v3.Rank;
	local t_RankTimer = v3.RankTimer;
	local v4 = m_Library.Directory.Ranks[t_Rank];
	local v5 = #v4.rewards > 0;
	if not u1 or not os_clock_ret then
		local v6 = m_Library.Network.Invoke("Get OSTime");
		os_clock_ret = os.clock();
		u1 = v6;
	end
	if not BillboardGui or not BillboardGui:FindFirstChild("Timer") then return end
	if v5 then
		local v7 = v4.rewardCooldown - (u1 + (os.clock() - os_clock_ret) - t_RankTimer);
		if v7 > 0 then
			BillboardGui.Timer.Text = m_Library.Functions.TimerString(v7);
			return;
		end
		BillboardGui.Timer.Text = "Redeem!";
		return;
	end
	BillboardGui.Timer.Text = "(None)";
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 108
	--[[
		Upvalues:
			[1] = m_Library
			[2] = Pad
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map and Map:FindFirstChild("Interactive") and Map.Interactive:FindFirstChild("Rank Rewards") then
		Pad = Map.Interactive:FindFirstChild("Rank Rewards"):FindFirstChild("Pad");
		return;
	end
	Pad = nil;
end);
task.spawn(function() -- Line: 121
	while true do
		UpdateHUD();
		wait(0.5);
	end
end);
task.spawn(function() -- Line: 129
	while true do
		Raycast();
		wait(0.5);
	end
end);
