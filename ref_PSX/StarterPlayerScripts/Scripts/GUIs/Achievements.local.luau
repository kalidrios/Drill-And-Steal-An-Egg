-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_Achievements = m_Library.GUI.Achievements;
local bool1 = false;
local bool2 = true;
function UpdateAchievement(p1) -- Line: 22
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Achievements
	--]]
	local v1 = m_Library.Save.Get();
	if not v1 then return end
	assert(v1);
	local v2 = m_Library.Directory.Achievements[p1];
	local v3 = v1.Achievements[p1];
	local v4 = v3 and v3.stage or 1;
	local v5 = v3 and v3.progress or 0;
	local v6 = v2[v4];
	local v7 = v2[v4 + 1];
	local v8;
	if v6 == nil then
		v8 = false;
	else
		v8 = v6.secret;
	end
	if v8 then return end
	local v9 = t_Achievements.Container.Holder:FindFirstChild(p1);
	if not v9 then
		v9 = m_Library.Assets.UI.Achievements.Achievement:Clone();
		v9.Name = p1;
		v9.Parent = t_Achievements.Container.Holder;
	end
	local v10 = v7 == nil;
	local v11 = v6 == nil;
	v9.Top.Title.New.Visible = not v11 and not v10;
	v9.Top.Title.arrow.Visible = not v11 and not v10;
	v9.Top.Progress.Visible = not v11;
	v9.Top.Percent.Visible = not v11;
	local v12 = v9.Top.Title.New.Visible and v9.Top.Title.AbsoluteSize.X / 2 - v9.Top.Title.arrow.AbsoluteSize.X / 2 or math.huge;
	v9.Top.Title.Old:FindFirstChildOfClass("UISizeConstraint").MaxSize = Vector2.new(v12, math.huge);
	v9.Top.Title.New:FindFirstChildOfClass("UISizeConstraint").MaxSize = Vector2.new(v12, math.huge);
	if v11 then
		v6 = v2[v4 - 1];
	end
	local v13 = 100;
	if v6 then
		local math_round_ret = math.round(v5 / v6.amount * 100);
		v13 = math.clamp(math_round_ret, 0, 100);
	end
	v9.Top.Title.Old.Text = v6.title;
	v9.Top.Title.New.Text = v7 and v7.title or "";
	v9.Bottom.Frame.Desc.Text = v6.desc;
	local v14 = m_Library.Shared.AchievementDifficulty[v6.difficulty];
	v9.Top.Difficulty.Text = v11 and "Completed" or v14.Name;
	v9.Top.BackgroundColor3 = v11 and Color3.fromRGB(80, 255, 86) or v14.Color;
	v9.LayoutOrder = v6.difficulty * 1000 + (v11 and 10000 or -v13) + (v8 and 100000 or 0);
	if v8 and not v11 then
		v9.Top.BackgroundColor3 = Color3.fromRGB(115, 115, 115);
	end
	v9.Top.Percent.Text = v13 == 100 and "Done" or v13 .. "%";
	v9.Top.Progress.Bar.Size = UDim2.new(v13 / 100, 0, 1, 0);
	if v6 then
		local t_rewardType = v6.rewardType;
		local t_reward = v6.reward;
		v9.Bottom.Frame.CurrencyReward.Visible = t_rewardType == "Diamonds" and true or string.find(t_rewardType, "Coins") ~= nil;
		v9.Bottom.Frame.PetReward.Visible = t_rewardType == "Pet" and true or t_rewardType == "GoldenPet" and true or t_rewardType == "RainbowPet" and true or t_rewardType == "DarkMatterPet";
		v9.Bottom.Frame.SlotReward.Visible = t_rewardType == "Slots";
		if v9.Bottom.Frame.CurrencyReward.Visible then
			local t_Reward = v9.Bottom.Frame.CurrencyReward.Reward;
			local t_CurrencyIcon = v9.Bottom.Frame.CurrencyReward.CurrencyIcon;
			t_Reward.Text = m_Library.Functions.Commas(t_reward);
			local v16 = m_Library.Directory.Currency[t_rewardType];
			if t_CurrencyIcon.Image ~= v16.Image then
				t_CurrencyIcon.Image = v16.Image;
				t_Reward:FindFirstChildOfClass("UIGradient"):Destroy();
				v16.Gradient:Clone().Parent = t_Reward;
			end
		else
			if v9.Bottom.Frame.PetReward.Visible then
				local v17 = m_Library.Directory.Pets[t_reward];
				v9.Bottom.Frame.PetReward.PetIcon.Image = t_rewardType == "DarkMatterPet" and v17.darkMatterThumbnail or t_rewardType == "GoldenPet" and v17.goldenThumbnail or v17.thumbnail;
				return;
			end
			if v9.Bottom.Frame.SlotReward.Visible then
				v9.Bottom.Frame.SlotReward.Amount.Text = m_Library.Functions.Commas(t_reward);
			end
		end
	end
end
function UpdateAll() -- Line: 116
	--[[
		Upvalues:
			[1] = bool2
			[2] = t_Achievements
			[3] = m_Library
	--]]
	if not bool2 then return end
	if not t_Achievements.Gui.Enabled then return end
	local v15 = m_Library.Save.Get();
	if not v15 then return end
	bool2 = false;
	for key1, _ in pairs(m_Library.Directory.Achievements) do
		UpdateAchievement(key1);
	end
	Scrolling();
end
function UpdateLazy() -- Line: 134
	--[[
		Upvalues:
			[1] = bool2
	--]]
	bool2 = true;
end
function Scrolling() -- Line: 139
	--[[
		Upvalues:
			[1] = t_Achievements
	--]]
	local t_Holder = t_Achievements.Container.Holder;
	local UIListLayout = t_Holder:FindFirstChildOfClass("UIListLayout");
	local UIPadding = t_Holder:FindFirstChildOfClass("UIPadding");
	t_Holder.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset);
end
m_Library.GUIFX.ButtonFX(t_Achievements.Close);
t_Achievements.Close.Activated:Connect(function() -- Line: 151
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_Achievements
	--]]
	if not bool1 then
		bool1 = true;
		t_Achievements.Gui.Enabled = false;
		bool1 = false;
	end
end);
UpdateLazy();
m_Library.Signal.Fired("Stat Changed"):Connect(function(p2) -- Line: 164
	if p2 == "Achievements" then
		UpdateLazy();
	end
end);
m_Library.Signal.Fired("Resolution Changed"):Connect(function() -- Line: 170
	task.defer(function() -- Line: 171
		Scrolling();
	end);
end);
m_Library.RunService.RenderStepped:Connect(function() -- Line: 176
	UpdateAll();
end);
local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 180
	--[[
		Upvalues:
			[1] = t_Achievements
			[2] = m_Library
	--]]
	while true do
		if t_Achievements.Gui.Enabled then
			Scrolling();
		end
		m_Library.Heartbeat(30);
	end
end);
coroutine_wrap_ret();
