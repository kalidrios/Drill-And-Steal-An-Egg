-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_IsHardcore = m_Library.Shared.IsHardcore;
local bool1 = false;
local table1 = {};
local FindFirstChild_ret = nil;
local table2 = {
	[1] = "Leprechaun Village",
	[2] = "Rainbow Heights",
	[3] = "Lucky Castle"
};
local u1 = m_Library.Network.Invoke("Giant Rainbow: Get First Time");
function GetNextGiantRainbowTime() -- Line: 18
	--[[
		Upvalues:
			[1] = u1
	--]]
	while workspace:GetServerTimeNow() > u1 do
		u1 = u1 + 14400;
	end
	return u1 - workspace:GetServerTimeNow();
end
function PromptQuest() -- Line: 26
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_IsHardcore
			[3] = FindFirstChild_ret
	--]]
	local v1 = m_Library.Save.Get();
	local unpack_ret1, unpack_ret2 = unpack(t_IsHardcore and v1.Hardcore.StPatricks2022Quest or v1.StPatricks2022Quest);
	if unpack_ret2 <= 0 then
		local v16 = m_Library.Network.Invoke("Kawaii Quest: Attempt Start Quest");
		if v16 then
			if t_IsHardcore then
				v1.Hardcore.StPatricks2022Quest = v16;
			else
				v1.StPatricks2022Quest = v16;
			end
		end
	end
	local v2 = m_Library.Shared.StPatricks2022Quests[unpack_ret2];
	if not v2 then return end
	if unpack_ret1 < v2 then
		local CurrentTask = GetCurrentTask();
		m_Library.Message.New(CurrentTask);
		return;
	end
	m_Library.Signal.Fire("Attempt Buy Gate", FindFirstChild_ret);
end
function GetCurrentTask() -- Line: 56
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_IsHardcore
	--]]
	local str1 = "?";
	local v3 = m_Library.Save.Get();
	if not v3 then
		return str1;
	end
	assert(v3);
	local unpack_ret1_2, unpack_ret2_2 = unpack(t_IsHardcore and v3.Hardcore.StPatricks2022Quest or v3.StPatricks2022Quest);
	local v4 = m_Library.Shared.StPatricks2022Quests[unpack_ret2_2];
	if not v4 then
		return str1;
	end
	local v5 = v4 - unpack_ret1_2;
	if unpack_ret2_2 == 1 then
		local string_format_ret2 = string.format("Break %s Clover Coin%s", v5, v5 <= 1 and "" or "s");
		return string_format_ret2;
	end
	if unpack_ret2_2 == 2 then
		local string_format_ret = string.format("Break %s Pot%s of Gold", v5, v5 <= 1 and "" or "s");
		return string_format_ret;
	end
	if unpack_ret2_2 == 3 then
		str1 = "Participate in Giant Rainbow Event";
	end
	return str1;
end
function Setup() -- Line: 81
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_IsHardcore
			[3] = FindFirstChild_ret
			[4] = table2
			[5] = table1
			[6] = bool1
	--]]
	local v6 = m_Library.Save.Get();
	local t_StPatricks2022Quest;
	while true do
		if not v6 then
			task.wait(0.25);
			if not m_Library.LocalPlayer then return end
			v6 = m_Library.Save.Get();
			continue;
		end
		assert(v6);
		if t_IsHardcore then
			t_StPatricks2022Quest = v6.Hardcore.StPatricks2022Quest;
			if t_StPatricks2022Quest then break end
		end
		t_StPatricks2022Quest = v6.StPatricks2022Quest;
		break;
	end
	local _, unpack_ret2_3 = unpack(t_StPatricks2022Quest);
	if unpack_ret2_3 <= 0 then
		local v17 = m_Library.Network.Invoke("Kawaii Quest: Attempt Start Quest");
		if v17 then
			if t_IsHardcore then
				v6.Hardcore.StPatricks2022Quest = v17;
			else
				v6.StPatricks2022Quest = v17;
			end
		end
	end
	local unpack_ret1_3, unpack_ret2_4 = unpack(t_IsHardcore and v6.Hardcore.StPatricks2022Quest or v6.StPatricks2022Quest);
	local v7 = m_Library.Shared.StPatricks2022Quests[unpack_ret2_4];
	if not v7 then return end
	local v8 = v7 - unpack_ret1_3;
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Gates") then
		FindFirstChild_ret = Map.Gates:FindFirstChild(table2[unpack_ret2_4]);
		if FindFirstChild_ret then
			local v18 = m_Library.Directory.Areas[table2[unpack_ret2_4]];
			local BasePart = FindFirstChild_ret:FindFirstChildWhichIsA("BasePart");
			if v8 > 0 then
				local SaintPatricksHUD = BasePart:FindFirstChild("SaintPatricksHUD");
				SaintPatricksHUD.Task.Text = GetCurrentTask();
				if unpack_ret2_4 == 3 then
					SaintPatricksHUD.Line2.Visible = true;
					task.spawn(function() -- Line: 124
						--[[
							Upvalues:
								[1] = SaintPatricksHUD
								[2] = m_Library
						--]]
						while SaintPatricksHUD do
							if SaintPatricksHUD and SaintPatricksHUD:FindFirstChild("Line2") then
								local v31 = m_Library.Signal.Invoke("Rainbow: Enabled");
								if v31 then
									SaintPatricksHUD.Line2.Text = "Event is active now!";
								else
									SaintPatricksHUD.Line2.Text = "Next event in " .. m_Library.Functions.FormatTime(GetNextGiantRainbowTime());
								end
							end
							task.wait(1);
						end
					end);
				end
				SaintPatricksHUD.Parent = BasePart;
			else
				if BasePart:FindFirstChild("SaintPatricksHUD") then
					BasePart:FindFirstChild("SaintPatricksHUD"):Destroy();
				end
				if not BasePart:FindFirstChild("GateHUB") then
					local Clone_ret = m_Library.Assets.Billboards.GateHUD:Clone();
					Clone_ret.Req.Cost.Text = m_Library.Functions.NumberShorten(v18.gate.cost, false);
					local v25 = m_Library.Directory.Currency[v18.gate.currency];
					Clone_ret.Req.Currency.Image = v25.ImageOutline;
					v25.Gradient:Clone().Parent = Clone_ret.Req.Cost;
					Clone_ret.Parent = BasePart;
				end
			end
			local v19 = v8 > 0 and "Check Quest" or "Buy Area";
			local v20, v21 = m_Library.Interact.Add(BasePart.CFrame.p - Vector3.new(0, BasePart.Size.Y / 3, 0), {
				label = v19,
				dist = 40
			});
			table.insert(table1, v21);
			v20:Connect(function() -- Line: 158
				--[[
					Upvalues:
						[1] = bool1
				--]]
				if not bool1 then
					bool1 = true;
					PromptQuest();
					bool1 = false;
				end
			end);
		end
	end
end
function Advance(p1) -- Line: 169
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table1
			[3] = t_IsHardcore
			[4] = FindFirstChild_ret
			[5] = table2
			[6] = bool1
	--]]
	local v9 = m_Library.Save.Get();
	if not v9 then return end
	assert(v9);
	for _, val1 in ipairs(table1) do
		val1();
	end
	table1 = {};
	if t_IsHardcore then
		v9.Hardcore.StPatricks2022Quest = p1;
	else
		v9.StPatricks2022Quest = p1;
	end
	local unpack_ret1_4, unpack_ret2_5 = unpack(t_IsHardcore and v9.Hardcore.StPatricks2022Quest or v9.StPatricks2022Quest);
	local v10 = m_Library.Shared.StPatricks2022Quests[unpack_ret2_5];
	if not v10 then return end
	local v11 = v10 - unpack_ret1_4;
	local Map2 = m_Library.WorldCmds.GetMap();
	if Map2:FindFirstChild("Gates") then
		FindFirstChild_ret = Map2.Gates:FindFirstChild(table2[unpack_ret2_5]);
		if FindFirstChild_ret then
			local BasePart2 = FindFirstChild_ret:FindFirstChildWhichIsA("BasePart");
			local SaintPatricksHUD2 = BasePart2:FindFirstChild("SaintPatricksHUD");
			SaintPatricksHUD2.Task.Text = GetCurrentTask();
			if unpack_ret2_5 == 3 then
				SaintPatricksHUD2.Line2.Visible = true;
				task.spawn(function() -- Line: 203
					--[[
						Upvalues:
							[1] = SaintPatricksHUD2
							[2] = m_Library
					--]]
					while SaintPatricksHUD2 do
						if SaintPatricksHUD2 and SaintPatricksHUD2:FindFirstChild("Line2") then
							local v30 = m_Library.Signal.Invoke("Rainbow: Enabled");
							if v30 then
								SaintPatricksHUD2.Line2.Text = "Event is active now!";
							else
								SaintPatricksHUD2.Line2.Text = "Next event in " .. m_Library.Functions.FormatTime(GetNextGiantRainbowTime());
							end
						end
						task.wait(1);
					end
				end);
			end
			local v22 = v11 > 0 and "Check Quest" or "Buy Area";
			local v23, v24 = m_Library.Interact.Add(BasePart2.CFrame.p - Vector3.new(0, BasePart2.Size.Y / 3, 0), {
				label = v22,
				dist = 40
			});
			table.insert(table1, v24);
			v23:Connect(function() -- Line: 221
				--[[
					Upvalues:
						[1] = bool1
				--]]
				if not bool1 then
					bool1 = true;
					PromptQuest();
					bool1 = false;
				end
			end);
		end
	end
end
m_Library.Network.Fired("Kawaii Quest: Quest Progressed"):Connect(function(p2, p3) -- Line: 232
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_IsHardcore
			[3] = table1
			[4] = table2
			[5] = FindFirstChild_ret
			[6] = bool1
	--]]
	local v12 = m_Library.Save.Get();
	if not v12 then return end
	assert(v12);
	if t_IsHardcore then
		v12.Hardcore.StPatricks2022Quest = {
			p3,
			p2
		};
	else
		v12.StPatricks2022Quest = {
			p3,
			p2
		};
	end
	local v13 = m_Library.Shared.StPatricks2022Quests[p2];
	if not v13 then return end
	for _, val2 in ipairs(table1) do
		val2();
	end
	local v14 = m_Library.Directory.Areas[table2[p2]];
	local v15 = v13 - p3;
	local Map3 = m_Library.WorldCmds.GetMap();
	if Map3:FindFirstChild("Gates") then
		FindFirstChild_ret = Map3.Gates:FindFirstChild(table2[p2]);
		if FindFirstChild_ret then
			local BasePart3 = FindFirstChild_ret:FindFirstChildWhichIsA("BasePart");
			local SaintPatricksHUD3 = BasePart3:FindFirstChild("SaintPatricksHUD");
			if v15 > 0 then
				SaintPatricksHUD3.Task.Text = GetCurrentTask();
				if p2 == 3 then
					SaintPatricksHUD3.Line2.Visible = true;
					task.spawn(function() -- Line: 266
						--[[
							Upvalues:
								[1] = SaintPatricksHUD3
								[2] = m_Library
						--]]
						while SaintPatricksHUD3 do
							if SaintPatricksHUD3 and SaintPatricksHUD3:FindFirstChild("Line2") then
								local v32 = m_Library.Signal.Invoke("Rainbow: Enabled");
								if v32 then
									SaintPatricksHUD3.Line2.Text = "Event is active now!";
								else
									SaintPatricksHUD3.Line2.Text = "Next event in " .. m_Library.Functions.FormatTime(GetNextGiantRainbowTime());
								end
							end
							task.wait(1);
						end
					end);
				end
			elseif not BasePart3:FindFirstChild("GateHUD") then
				if SaintPatricksHUD3 then
					SaintPatricksHUD3:Destroy();
				end
				if not BasePart3:FindFirstChild("GateHUD") then
					local Clone_ret2 = m_Library.Assets.Billboards.GateHUD:Clone();
					Clone_ret2.Req.Cost.Text = m_Library.Functions.NumberShorten(v14.gate.cost, false);
					local Dir = m_Library.WorldCmds.GetDir();
					if Dir and Dir.display == "Doodle World" then
						Clone_ret2.TextLabel.Font = Enum.Font.IndieFlower;
					end
					local v26 = m_Library.Directory.Currency[v14.gate.currency];
					Clone_ret2.Req.Currency.Image = v26.ImageOutline;
					v26.Gradient:Clone().Parent = Clone_ret2.Req.Cost;
					Clone_ret2.Parent = BasePart3;
					local v27 = v15 > 0 and "Check Quest" or "Buy Area";
					local v28, v29 = m_Library.Interact.Add(BasePart3.CFrame.p - Vector3.new(0, BasePart3.Size.Y / 3, 0), {
						label = v27,
						dist = 40
					});
					table.insert(table1, v29);
					v28:Connect(function() -- Line: 304
						--[[
							Upvalues:
								[1] = bool1
						--]]
						if not bool1 then
							bool1 = true;
							PromptQuest();
							bool1 = false;
						end
					end);
				end
				m_Library.Signal.Fire("Notification", "You can now unlock the next Kawaii Quest gate!", {
					color = Color3.fromRGB(255, 82, 218),
					force = true
				});
			end
		end
	end
end);
m_Library.Signal.Fired("World Changed"):Connect(function(p4) -- Line: 318
	--[[
		Upvalues:
			[1] = table1
	--]]
	for _, val3 in ipairs(table1) do
		val3();
	end
	table1 = {};
	if p4 == "Kawaii Quest" then
		Setup();
	end
end);
m_Library.Network.Fired("Kawaii Quest: Quest Advanced"):Connect(Advance);
