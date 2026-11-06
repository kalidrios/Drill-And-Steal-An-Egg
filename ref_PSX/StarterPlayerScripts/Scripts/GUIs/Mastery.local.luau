-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_Mastery = m_Library.GUI.Mastery;
local t_Holder = t_Mastery.Skills.Holder;
local bool1 = false;
function Update() -- Line: 19
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Holder
			[3] = t_Mastery
	--]]
	local u1 = m_Library.Save.Get();
	if not u1 then return end
	for key1, val1 in pairs(m_Library.Directory.Mastery) do
		local u2 = m_Library.Directory.Mastery[key1];
		if not u2.enabled then continue end
		local u3 = t_Holder:FindFirstChild(key1);
		if not u3 then
			u3 = m_Library.Assets.UI.Mastery.Skill:Clone();
			u3.Icon.Image = val1.icon;
			u3.Name = key1;
			m_Library.GUIFX.ButtonFX(u3);
			m_Library.GUIFX.CircularBar(u3.CircularBar);
			u3.Level.Text = math.random(1, 99);
			u3.CircularBar:SetAttribute("Progress", math.random());
			u3.Parent = t_Holder;
			local function ShowOverlay() -- Line: 45
				--[[
					Upvalues:
						[1] = u1
						[2] = m_Library
						[3] = key1
						[4] = u2
						[5] = u3
				--]]
				u1 = m_Library.Save.Get();
				local v14 = u1.Mastery[key1] or 0;
				local v15 = m_Library.Shared.MasteryXPToLevel(v14);
				local v16 = m_Library.Shared.MasteryLevelToXP(v15);
				local v17 = m_Library.Shared.MasteryLevelToXP(v15 + 1);
				local table1 = {{
					"Title",
					u2.title .. " Mastery"
				}};
				if u2.maxLvl <= v15 then
					table.insert(table1, {
						"MasteryLvl",
						"Lvl " .. v15 .. " (Max)"
					});
					table.insert(table1, {
						"MasteryXP",
						"Max XP"
					});
				else
					table.insert(table1, {
						"MasteryLvl",
						"Lvl " .. v15 .. " (" .. u2.maxLvl .. " Max)"
					});
					table.insert(table1, {
						"MasteryXP",
						m_Library.Functions.Commas(v14 - v16) .. " / " .. m_Library.Functions.Commas(v17 - v16) .. " XP"
					});
				end
				for _, val4 in ipairs(u2.perks) do
					local t_level = val4.level;
					local v18 = t_level <= v15;
					table.insert(table1, {
						"MasteryPerk",
						t_level,
						val4.desc,
						v18
					});
				end
				m_Library.InfoOverlay.Add(u3, unpack(table1));
			end
			u3.MouseEnter:Connect(function() -- Line: 72
				--[[
					Upvalues:
						[1] = m_Library
						[2] = ShowOverlay
				--]]
				m_Library.Audio.Play("rbxassetid://6907626084", script, 1, 0.2);
				ShowOverlay();
			end);
			u3.SelectionGained:Connect(function() -- Line: 77
				--[[
					Upvalues:
						[1] = m_Library
						[2] = ShowOverlay
				--]]
				m_Library.Audio.Play("rbxassetid://6907626084", script, 1, 0.2);
				ShowOverlay();
			end);
		end
		local v7 = u1.Mastery[key1];
		if not v7 then
			u3.CircularBar:SetAttribute("Progress", 0);
			u3.Level.Text = "??";
			continue;
		end
		local v8 = m_Library.Shared.MasteryXPToLevel(v7);
		local v9 = m_Library.Shared.MasteryLevelToXP(v8);
		local v10 = m_Library.Shared.MasteryLevelToXP(v8 + 1);
		u3.Level.Text = v8;
		if u2.maxLvl <= v8 then
			u3.CircularBar:SetAttribute("Progress", 1);
			u3.CircularBar.Left.ImageColor3 = Color3.fromRGB(252, 50, 242);
			u3.CircularBar.Right.ImageColor3 = Color3.fromRGB(252, 50, 242);
		else
			local math_clamp_ret = math.clamp((v7 - v9) / (v10 - v9), 0, 1);
			u3.CircularBar:SetAttribute("Progress", math_clamp_ret);
		end
		u3.LayoutOrder = 10000000 - v8 * 1000 + u2.sort;
	end
	local v1 = 0;
	local v2 = 0;
	for key2, val2 in pairs(m_Library.Directory.Mastery) do
		if not val2.enabled then continue end
		v1 = v1 + val2.maxLvl;
		local v11 = u1.Mastery[key2];
		if not v11 then continue end
		v2 = v2 + m_Library.Shared.MasteryXPToLevel(v11);
	end
	t_Mastery.Skills.Completed.Text = (m_Library.Functions.Commas(v2) .. " / " .. m_Library.Functions.Commas(v1)) .. " (" .. math.floor(v2 / v1 * 100) .. "%)";
	Scaling();
end
function Scaling() -- Line: 127
	--[[
		Upvalues:
			[1] = t_Holder
			[2] = m_Library
	--]]
	local UIGridLayout = t_Holder:FindFirstChildOfClass("UIGridLayout");
	local UIPadding = t_Holder:FindFirstChildOfClass("UIPadding");
	local v3 = m_Library.Functions.ResolutionScale();
	local num1 = 5;
	if v3 <= 0.65 then
		num1 = 3;
	elseif v3 <= 1.2 then
		num1 = 4;
	end
	local v4 = (t_Holder.AbsoluteSize.X - t_Holder.ScrollBarThickness - UIPadding.PaddingLeft.Offset - UIPadding.PaddingRight.Offset) / num1 - UIGridLayout.CellPadding.X.Offset;
	local udim2 = UDim2.new(0, v4, 0, v4);
	UIGridLayout.CellSize = udim2;
	UIGridLayout:ApplyLayout();
	t_Holder.CanvasSize = UDim2.new(0, 0, 0, UIGridLayout.AbsoluteContentSize.Y + (UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset));
end
function LevelUpNotification(p1, p2) -- Line: 150
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v5 = m_Library.Directory.Mastery[p1];
	local bool2 = false;
	for _, val3 in ipairs(v5.perks) do
		if val3.level ~= p2 then continue end
		bool2 = true;
		break;
	end
	local v6 = bool2 and "rbxassetid://8951545959" or "rbxassetid://8951545789";
	if v5.maxLvl <= p2 then
		local v12 = v5.title .. " Mastery reached Max Level!";
		m_Library.Signal.Fire("Notification", v12, {
			color = Color3.fromRGB(185, 246, 255),
			time = 5,
			sound = v6
		});
	else
		local v13 = v5.title .. " Mastery is now Level " .. p2 .. "!";
		m_Library.Signal.Fire("Notification", v13, {
			color = Color3.fromRGB(185, 246, 255),
			time = 5,
			sound = v6
		});
	end
	if bool2 then
		m_Library.Signal.Fire("Notification", "\226\156\168 New perk unlocked!", {
			color = Color3.fromRGB(255, 204, 77),
			time = 5
		});
	end
end
m_Library.Network.Fired("Mastery Leveled Up"):Connect(function(p3, p4) -- Line: 179
	LevelUpNotification(p3, p4);
end);
m_Library.Signal.Fired("Resolution Changed"):Connect(function() -- Line: 187
	task.defer(function() -- Line: 188
		Scaling();
	end);
end);
m_Library.Signal.Fired("Stat Changed"):Connect(function(p5) -- Line: 194
	if p5 == "Mastery" or p5 == "MasteryUnlocked" then
		Update();
	end
end);
t_Mastery.Gui:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 200
	Scaling();
end);
m_Library.GUIFX.ButtonFX(t_Mastery.Close);
t_Mastery.Close.Activated:Connect(function() -- Line: 206
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_Mastery
	--]]
	if not bool1 then
		bool1 = true;
		t_Mastery.Gui.Enabled = false;
		bool1 = false;
	end
end);
Update();
