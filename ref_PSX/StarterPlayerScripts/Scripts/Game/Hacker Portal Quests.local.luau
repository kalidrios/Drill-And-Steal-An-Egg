-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_IsHardcore = m_Library.Shared.IsHardcore;
local bool1 = false;
local FindFirstChild_ret = nil;
function Travel() -- Line: 19
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v1 = m_Library.Message.New("Travel through the portal?", true);
	if v1 then
		m_Library.WorldCmds.Load("Void");
	end
end
function OpenPortal() -- Line: 27
	--[[
		Upvalues:
			[1] = FindFirstChild_ret
			[2] = m_Library
	--]]
	local CENTER = FindFirstChild_ret:FindFirstChild("CENTER");
	m_Library.Audio.Play(8803688837, CENTER, 1, 1.5, 500);
	m_Library.Functions.Tween(CENTER, {Color = Color3.new(0.75, 0.75, 0.75)}, {
		1,
		"Expo",
		"Out"
	}).Completed:Wait();
	while FindFirstChild_ret and FindFirstChild_ret.Parent do
		m_Library.Functions.Tween(CENTER, {Color = Color3.new(0.8, 0.8, 0.8)}, {
			1.5,
			"Sine",
			"InOut"
		}).Completed:Wait();
		m_Library.Functions.Tween(CENTER, {Color = Color3.new(0.65098, 0.592157, 0.690196)}, {
			2,
			"Sine",
			"InOut"
		}).Completed:Wait();
		m_Library.RenderStepped();
	end
end
function PromptQuest() -- Line: 42
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_IsHardcore
	--]]
	local v2 = m_Library.Save.Get();
	local v3, v4 = unpack(t_IsHardcore and v2.Hardcore.HackerPortalProgress or v2.HackerPortalProgress);
	if v4 <= 0 then
		local v9 = m_Library.Message.New("To unlock the portal, you need to complete a quest. Start?", true);
		if v9 then
			m_Library.Network.Fire("Start Hacker Portal Quests");
		end
		return;
	end
	if v4 > 1 then
		v4 = 1;
		v3 = m_Library.Shared.HackerPortalQuests[1];
	end
	local v5 = m_Library.Shared.HackerPortalQuests[v4];
	if not v5 then
		print("Not needed");
		return;
	end
	if v5 <= v3 then
		local v10 = m_Library.Network.Invoke("Finish Hacker Portal Quest");
		if v10 then
			m_Library.Audio.Play(8803681943, script, 1, 1.5);
		end
	else
		local v11 = v5 - v3;
		if v4 == 1 then
			m_Library.Message.New(string.format("Quest - Break %s Giant Hacker Chest%s. Return when you have finished.", v11, v11 <= 1 and "" or "s"));
		end
	end
end
function Clicked() -- Line: 85
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_IsHardcore
	--]]
	local v6 = m_Library.Save.Get();
	if t_IsHardcore and v6.Hardcore.HackerPortalUnlocked or not t_IsHardcore and v6.HackerPortalUnlocked then
		Travel();
		return;
	end
	PromptQuest();
end
function Setup() -- Line: 97
	--[[
		Upvalues:
			[1] = FindFirstChild_ret
			[2] = m_Library
			[3] = bool1
			[4] = t_IsHardcore
	--]]
	local v7, _ = m_Library.Interact.Add(FindFirstChild_ret:FindFirstChild("_INTERACT").CFrame.p, {dist = 30});
	v7:Connect(function() -- Line: 100
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
	local v8 = m_Library.Save.Get();
	if v8 and (t_IsHardcore and v8.Hardcore.HackerPortalUnlocked or not t_IsHardcore and v8.HackerPortalUnlocked) then
		OpenPortal();
	end
end
function Check() -- Line: 118
	--[[
		Upvalues:
			[1] = m_Library
			[2] = FindFirstChild_ret
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		FindFirstChild_ret = Map.Interactive:FindFirstChild("Hacker Portal");
		if FindFirstChild_ret then
			Setup();
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 133
	Check();
end);
m_Library.Network.Fired("Hacker Portal Progressed"):Connect(function() -- Line: 138
	--[[
		Upvalues:
			[1] = FindFirstChild_ret
	--]]
	if FindFirstChild_ret then
		wait(0.5);
		PromptQuest();
	end
end);
m_Library.Network.Fired("Hacker Portal Unlocked"):Connect(function() -- Line: 146
	--[[
		Upvalues:
			[1] = FindFirstChild_ret
			[2] = m_Library
	--]]
	if FindFirstChild_ret then
		m_Library.Message.New("Congrats! The portal is now permanently unlocked.");
		OpenPortal();
	end
end);
