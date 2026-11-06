-- https://github.com/kalidrios

local table1 = {
	0.25,
	0.5,
	0.75,
	0.9
};
local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_AchievementProgress = m_Library.GUI.AchievementProgress;
local u1 = t_AchievementProgress.Frame.Position;
local udim2 = UDim2.new(0.5, 0, -1, 0);
local bool1 = true;
local table2 = {};
local table3 = {};
function Notification(p1, p2, p3) -- Line: 24
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table3
			[3] = bool1
			[4] = t_AchievementProgress
			[5] = udim2
			[6] = u1
	--]]
	local u2 = m_Library.Save.Get();
	if not u2 then return end
	if not p2 and table3[p1] and os.clock() - table3[p1] < 10 then return end
	table3[p1] = os.clock();
	local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 38
		--[[
			Upvalues:
				[1] = bool1
				[2] = m_Library
				[3] = u2
				[4] = p1
				[5] = p2
				[6] = p3
				[7] = t_AchievementProgress
				[8] = udim2
				[9] = u1
		--]]
		while not bool1 do
			m_Library.Heartbeat(5);
		end
		bool1 = false;
		local v4 = u2.Achievements[p1];
		local v5 = v4 and v4.stage or 1;
		local v6 = v4 and v4.progress or 0;
		if p2 then
			v5 = p3 - 1;
		end
		local v7 = m_Library.Directory.Achievements[p1][v5];
		if p2 then
			if v7.difficulty <= 2 then
				m_Library.Audio.Play("rbxassetid://7000716242", script, 1, 1);
			elseif v7.difficulty == 3 then
				m_Library.Audio.Play("rbxassetid://7000716206", script, 1, 1.25);
			else
				m_Library.Audio.Play("rbxassetid://7000716222", script, 1, 1.65);
			end
			local t_p = m_Library.Player.UpperTorso().CFrame.p;
			local t_rewardType = v7.rewardType;
			local t_reward = v7.reward;
			if t_rewardType == "Pet" or t_rewardType == "GoldenPet" or t_rewardType == "RainbowPet" or t_rewardType == "DarkMatterPet" then
				local v8 = m_Library.Directory.Pets[t_reward];
				local v9 = m_Library.WorldFX.RewardImage(t_p, "+1 Brainrot", t_rewardType == "DarkMatterPet" and v8.darkMatterThumbnail or t_rewardType == "GoldenPet" and v8.goldenThumbnail or v8.thumbnail, {time = 4});
				if t_rewardType == "RainbowPet" then
					m_Library.GUIFX.Rainbow(v9:FindFirstChild("icon"), "ImageColor3", 2);
				end
			elseif t_rewardType == "Slots" then
				m_Library.WorldFX.RewardImage(t_p, "+" .. t_reward .. " Brainrot Slots", "rbxassetid://104111144013969", {time = 4});
			else
				m_Library.WorldFX.AddCurrency(t_p, t_reward, t_rewardType, false);
			end
		end
		t_AchievementProgress.Frame.Position = udim2;
		t_AchievementProgress.Gui.Enabled = true;
		m_Library.Functions.Tween(t_AchievementProgress.Frame, {Position = u1}, {
			1.25,
			"Quad",
			"Out"
		});
		t_AchievementProgress.Completed.Visible = p2;
		t_AchievementProgress.Progress.Visible = not p2;
		t_AchievementProgress.ProgressBar.Visible = not p2;
		t_AchievementProgress.Title.Visible = p2;
		t_AchievementProgress.Desc.Visible = not p2;
		t_AchievementProgress.Title.Text = v7.title;
		t_AchievementProgress.Desc.Text = v7.desc;
		if not p2 then
			local t_amount = v7.amount;
			t_AchievementProgress.Progress.Text = m_Library.Functions.Commas(v6) .. "/" .. m_Library.Functions.Commas(t_amount);
			t_AchievementProgress.ProgressBar.Bar.Size = UDim2.new(math.clamp(v6 / t_amount, 0, 1), 0, 1, 0);
		end
		task.delay(5, function() -- Line: 103
			--[[
				Upvalues:
					[1] = m_Library
					[2] = t_AchievementProgress
					[3] = udim2
					[4] = bool1
			--]]
			m_Library.Functions.Tween(t_AchievementProgress.Frame, {Position = udim2}, {
				0.6,
				"Linear"
			}).Completed:Wait();
			t_AchievementProgress.Gui.Enabled = false;
			bool1 = true;
		end);
	end);
	coroutine_wrap_ret();
end
function CheckForProgress() -- Line: 114
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table2
			[3] = table1
	--]]
	local v1 = m_Library.Save.Get();
	if not v1 then return end
	for key1, val1 in pairs(v1.Achievements) do
		local t_progress = val1.progress;
		local t_stage = val1.stage;
		if not m_Library.Directory.Achievements[key1] then continue end
		local v2 = m_Library.Directory.Achievements[key1][t_stage];
		if not v2 then continue end
		local t_amount2 = v2.amount;
		local v3 = table2[key1];
		if v3 and v3 < t_progress then
			local math_clamp_ret = math.clamp(v3 / t_amount2, 0, 1);
			local math_clamp_ret2 = math.clamp(t_progress / t_amount2, 0, 1);
			for _, val2 in ipairs(table1) do
				if val2 > math_clamp_ret2 or math_clamp_ret >= val2 then continue end
				Notification(key1);
			end
		end
		table2[key1] = t_progress;
	end
end
CheckForProgress();
m_Library.Network.Fired("Achievement Completed"):Connect(function(p4, p5) -- Line: 154
	Notification(p4, true, p5);
end);
m_Library.Signal.Fired("Stat Changed"):Connect(function(p6) -- Line: 159
	if p6 == "Achievements" then
		CheckForProgress();
	end
end);
task.spawn(function() -- Line: 166
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
	--]]
	wait(2);
	if m_Library.Variables.Mobile then
		u1 = u1 - UDim2.new(0, 0, 0, 30);
	end
end);
