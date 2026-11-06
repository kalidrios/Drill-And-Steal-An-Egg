-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_TradingHistory = m_Library.GUI.TradingHistory;
local Random_new_ret = Random.new();
local bool1 = false;
local str1 = "";
local table1 = {};
function UpdateHistory() -- Line: 21
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_TradingHistory
			[3] = table1
			[4] = bool1
	--]]
	local v1 = m_Library.Save.Get();
	if not v1 then return end
	local v2 = m_Library.Functions.RegexEscape(string.lower(tostring(t_TradingHistory.Bottom.Search.Query.Text)));
	local v13;
	if v2 == nil then
		v13 = false;
	else
		v13 = v2 ~= "";
	end
	local t_History = t_TradingHistory.History;
	local u1 = v1.TradeHistory2 or {};
	local HistoryLog = t_History:FindFirstChild("HistoryLog");
	for _, child1 in pairs(t_History:GetChildren()) do
		if child1:GetAttribute("Template") then
			child1.Visible = false;
			continue;
		end
		if not child1:IsA("Frame") or GetTrade(child1.Name, u1) then continue end
		child1:Destroy();
	end
	local t_NoHistory = t_TradingHistory.History.NoHistory;
	if #u1 == 0 then
		t_NoHistory.Visible = true;
		local _, GetTradeRating_ret2_2 = GetTradeRating(m_Library.LocalPlayer);
		t_TradingHistory.TradingHistory.Rating.Text = GetTradeRating_ret2_2;
		UpdateScrolling();
		return;
	end
	t_NoHistory.Visible = false;
	for key2, val2 in ipairs(u1) do
		local FindFirstChild_ret = t_History:FindFirstChild(val2.ts);
		if FindFirstChild_ret then
			UpdateRating(val2, FindFirstChild_ret);
			FindFirstChild_ret.LayoutOrder = 99999 - key2;
			if v13 then
				local v20 = table1[val2.u];
				FindFirstChild_ret.Visible = v20 and string.find(string.lower(v20.Name), v2) ~= nil;
			else
				FindFirstChild_ret.Visible = true;
			end
			continue;
		end
		local Clone_ret = HistoryLog:Clone();
		Clone_ret.LogMessage.Log.Player.Image = "";
		UpdateTradeDescription(val2, Clone_ret.LogMessage.Log.Description.Description, Clone_ret.LogMessage.Log.Player);
		Clone_ret.LogMessage.Log.Timestamp.Text = GetStringTime(val2.ts);
		UpdateRating(val2, Clone_ret);
		m_Library.GUIFX.ButtonFX(Clone_ret.Positive.Button);
		m_Library.GUIFX.ButtonFX(Clone_ret.Negative.Button);
		if val2.r == nil then
			Clone_ret.Positive.Button.Activated:Connect(function() -- Line: 90
				--[[
					Upvalues:
						[1] = bool1
						[2] = m_Library
						[3] = val2
						[4] = Clone_ret
				--]]
				if not bool1 then
					bool1 = true;
					local v21, v22 = m_Library.Network.Invoke("Rate Trade", val2.u, val2.ts, val2.t, true);
					if not v21 then
						m_Library.Message.New(v22);
					else
						val2.r = true;
						UpdateRating(val2, Clone_ret);
						AnimateThumb(Clone_ret.Positive);
					end
					bool1 = false;
				end
			end);
			Clone_ret.Negative.Button.Activated:Connect(function() -- Line: 107
				--[[
					Upvalues:
						[1] = bool1
						[2] = m_Library
						[3] = val2
						[4] = Clone_ret
				--]]
				if not bool1 then
					bool1 = true;
					local v23, v24 = m_Library.Network.Invoke("Rate Trade", val2.u, val2.ts, val2.t, false);
					if not v23 then
						m_Library.Message.New(v24);
					else
						val2.r = false;
						UpdateRating(val2, Clone_ret);
						AnimateThumb(Clone_ret.Negative);
					end
					bool1 = false;
				end
			end);
		end
		m_Library.GUIFX.ButtonFX(Clone_ret.LogMessage.Log);
		Clone_ret.LogMessage.Log.Activated:Connect(function() -- Line: 125
			--[[
				Upvalues:
					[1] = val2
					[2] = u1
					[3] = m_Library
			--]]
			local Trade = GetTrade(val2.ts, u1);
			if not Trade or not Trade.p or not Trade.op then
				m_Library.Message.New("You can no longer view this trade!");
				return;
			end
			UpdateView(Trade);
			ShowView();
		end);
		Clone_ret:SetAttribute("Template", false);
		Clone_ret.LayoutOrder = 99999 - key2;
		Clone_ret.Parent = t_History;
		if v13 then
			local v18 = table1[val2.u];
			Clone_ret.Visible = v18 and string.find(string.lower(v18.Name), v2) ~= nil;
		else
			Clone_ret.Visible = true;
		end
	end
	local _, GetTradeRating_ret2 = GetTradeRating(m_Library.LocalPlayer);
	t_TradingHistory.TradingHistory.Rating.Text = GetTradeRating_ret2;
	UpdateScrolling();
end
function UpdateView(p1) -- Line: 157
	--[[
		Upvalues:
			[1] = t_TradingHistory
			[2] = m_Library
			[3] = table1
	--]]
	if not p1.p or not p1.op then return end
	for _, child3 in pairs(t_TradingHistory.Client.Pets:GetChildren()) do
		if not child3:IsA("TextButton") then continue end
		child3:Destroy();
	end
	for _, child4 in pairs(t_TradingHistory.Player.Pets:GetChildren()) do
		if not child4:IsA("TextButton") then continue end
		child4:Destroy();
	end
	for _, val5 in ipairs(p1.p) do
		local Clone_ret3 = m_Library.Assets.UI.Inventory.Pet:Clone();
		m_Library.PetUI.Create(Clone_ret3, "6969", val5);
		Clone_ret3.Parent = t_TradingHistory.Client.Pets;
	end
	for _, val6 in ipairs(p1.op) do
		local Clone_ret2 = m_Library.Assets.UI.Inventory.Pet:Clone();
		m_Library.PetUI.Create(Clone_ret2, "6969", val6);
		Clone_ret2.Parent = t_TradingHistory.Player.Pets;
	end
	t_TradingHistory.Client.Diamonds.Amount.Text = m_Library.Functions.Commas(p1.d);
	t_TradingHistory.Player.Diamonds.Amount.Text = m_Library.Functions.Commas(p1.od);
	-- Tokens display
	if t_TradingHistory.Client:FindFirstChild("Tokens") then
		t_TradingHistory.Client.Tokens.Amount.Text = m_Library.Functions.Commas(p1.tk or 0);
	end
	if t_TradingHistory.Player:FindFirstChild("Tokens") then
		t_TradingHistory.Player.Tokens.Amount.Text = m_Library.Functions.Commas(p1.otk or 0);
	end
	t_TradingHistory.Player.Title.Text = table1[p1.u] and table1[p1.u].Name .. "'s Pets" or "Their Pets";
	UpdatePetsScaling();
end
function ShowView() -- Line: 197
	--[[
		Upvalues:
			[1] = t_TradingHistory
	--]]
	t_TradingHistory.TradingHistory.Visible = false;
	t_TradingHistory.TradeView.Visible = true;
	t_TradingHistory.Gui.Enabled = true;
end
function UpdateTradeDescription(p2, p3, p4) -- Line: 207
	--[[
		Upvalues:
			[1] = table1
			[2] = m_Library
	--]]
	local t_u = p2.u;
	if not table1[t_u] then
		p3.Text = GetTradeDescription(p2, "Loading...");
		task.spawn(function() -- Line: 212
			--[[
				Upvalues:
					[1] = m_Library
					[2] = t_u
					[3] = table1
					[4] = p3
					[5] = p2
					[6] = p4
			--]]
			local success, pcall_ret2 = pcall(function() -- Line: 213
				--[[
					Upvalues:
						[1] = m_Library
						[2] = t_u
						[3] = table1
				--]]
				local v25 = m_Library.Functions.UserIdToUsername(t_u);
				local UserThumbnailAsync = game.Players:GetUserThumbnailAsync(t_u, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180);
				local table2 = {
					Name = v25,
					Avatar = UserThumbnailAsync
				};
				table1[t_u] = table2;
				return table2;
			end);
			if not success then return end
			p3.Text = GetTradeDescription(p2, pcall_ret2.Name);
			p4.Image = pcall_ret2.Avatar;
		end);
		return;
	end
	p3.Text = GetTradeDescription(p2, table1[t_u].Name);
	p4.Image = table1[t_u].Avatar;
end
function UpdateRating(p5, p6) -- Line: 240
	if p5.r == true then
		p6.Positive.Button.Image = "rbxassetid://12047990832";
		p6.Negative.Button.HoverImage = "";
		return;
	end
	if p5.r == false then
		p6.Negative.Button.Image = "rbxassetid://12065403063";
		p6.Positive.Button.HoverImage = "";
	end
end
function GetTradeDescription(p7, p8) -- Line: 252
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local str2 = "Traded ";
	local v3 = p7.p and #p7.p or p7.pn;
	local t_d = p7.d;
	local t_tk = p7.tk or 0;
	local v4 = p7.op and #p7.op or p7.opn;
	local t_od = p7.od;
	local t_otk = p7.otk or 0;
	local v5 = "";
	local hasContent = false;
	if v3 > 0 then
		v5 = m_Library.Functions.NumberShorten(v3) .. " Pets";
		hasContent = true;
	end
	if t_d > 0 then
		if hasContent then v5 = v5 .. " & " end;
		v5 = v5 .. m_Library.Functions.NumberShorten(t_d) .. " Diamonds";
		hasContent = true;
	end
	if t_tk > 0 then
		if hasContent then v5 = v5 .. " & " end;
		v5 = v5 .. m_Library.Functions.NumberShorten(t_tk) .. " Tokens";
		hasContent = true;
	end
	if not hasContent then
		v5 = "nothing";
	end
	local v6 = "";
	local hasOtherContent = false;
	if v4 > 0 then
		v6 = m_Library.Functions.NumberShorten(v4) .. " Pets";
		hasOtherContent = true;
	end
	if t_od > 0 then
		if hasOtherContent then v6 = v6 .. " & " end;
		v6 = v6 .. m_Library.Functions.NumberShorten(t_od) .. " Diamonds";
		hasOtherContent = true;
	end
	if t_otk > 0 then
		if hasOtherContent then v6 = v6 .. " & " end;
		v6 = v6 .. m_Library.Functions.NumberShorten(t_otk) .. " Tokens";
		hasOtherContent = true;
	end
	if not hasOtherContent then
		v6 = nil;
	end
	local v7 = str2 .. v5;
	if not v6 then
		return v7 .. " to " .. p8;
	end
	return v7 .. " for " .. p8 .. "'s " .. v6;
end
function GetStringTime(p9) -- Line: 293
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v8 = workspace:GetServerTimeNow() - p9;
	return v8 <= 120 and "Just now" or m_Library.Functions.TimeString(v8) .. " ago";
end
function GetTrade(p10, p11) -- Line: 304
	for _, val7 in ipairs(p11) do
		if val7.ts ~= p10 then continue end
		return val7;
	end
	return nil;
end
function UpdateScrolling() -- Line: 315
	--[[
		Upvalues:
			[1] = t_TradingHistory
	--]]
	local t_History2 = t_TradingHistory.Gui.Frame.TradingHistory.Main.History;
	local UIListLayout = t_History2:FindFirstChildOfClass("UIListLayout");
	local UIPadding = t_History2:FindFirstChildOfClass("UIPadding");
	t_History2.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset);
end
function UpdatePetsScaling() -- Line: 323
	--[[
		Upvalues:
			[1] = t_TradingHistory
			[2] = m_Library
	--]]
	for index1 = 1, 2 do
		local v14 = index1 == 1 and t_TradingHistory.Client.Pets or t_TradingHistory.Player.Pets;
		local UIGridLayout = v14:FindFirstChildOfClass("UIGridLayout");
		local UIPadding2 = v14:FindFirstChildOfClass("UIPadding");
		local v15 = m_Library.Functions.ResolutionScale();
		local v16 = v15 <= 0.5 and 2 or v15 <= 1.1 and 3 or 4;
		UIGridLayout.CellPadding = UDim2.new(0, 20, 0, 20);
		local v17 = (v14.AbsoluteSize.X - v14.ScrollBarThickness - UIPadding2.PaddingLeft.Offset - UIPadding2.PaddingRight.Offset) / v16 - UIGridLayout.CellPadding.X.Offset;
		local udim2 = UDim2.new(0, v17, 0, v17);
		UIGridLayout.CellSize = udim2;
		UIGridLayout:ApplyLayout();
		v14.CanvasSize = UDim2.new(0, UIGridLayout.AbsoluteContentSize.X, 0, UIGridLayout.AbsoluteContentSize.Y + 30);
	end
end
function GetTradeRating(p12) -- Line: 351
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v9 = m_Library.Save.Get(p12);
	if not v9 then
		return -1, "(Unrated)";
	end
	assert(v9);
	local v10 = 0;
	local v11 = 0;
	if v9.TradeHistory2 then
		local table3 = {};
		for index2 = #v9.TradeHistory2, 1, -1 do
			local v19 = v9.TradeHistory2[index2];
			if v19.or_ ~= nil and not table3[v19.u] then
				table3[v19.u] = true;
				if v19.or_ then
					v10 = v10 + 1;
				else
					v11 = v11 + 1;
				end
			end
		end
	end
	if v10 + v11 < m_Library.Shared.TradeRatingRequirement then
		return 0, "(Unrated)";
	end
	local v12 = math.round(v10 * 9 / (v10 + v11) * 10) / 10 + 1;
	return v12, string.format("%0.1f", v12) .. "/10 Rating";
end
function AnimateThumb(p13) -- Line: 395
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local TweenInfo_new_ret = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0);
	local Create_ret = m_Library.TweenService:Create(p13.Button, TweenInfo_new_ret, {Rotation = 360});
	Create_ret:Play();
	local TweenInfo_new_ret2 = TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0);
	local Create_ret2 = m_Library.TweenService:Create(p13.TextLabel, TweenInfo_new_ret2, {TextTransparency = 0});
	Create_ret2:Play();
	local TweenInfo_new_ret3 = TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0);
	local Create_ret3 = m_Library.TweenService:Create(p13.TextLabel.UIStroke, TweenInfo_new_ret3, {Transparency = 0});
	Create_ret3:Play();
	Create_ret2.Completed:Connect(function() -- Line: 408
		--[[
			Upvalues:
				[1] = m_Library
				[2] = p13
		--]]
		local TweenInfo_new_ret4 = TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0);
		local Create_ret4 = m_Library.TweenService:Create(p13.TextLabel, TweenInfo_new_ret4, {TextTransparency = 1});
		Create_ret4:Play();
	end);
	Create_ret3.Completed:Connect(function() -- Line: 414
		--[[
			Upvalues:
				[1] = m_Library
				[2] = p13
		--]]
		local TweenInfo_new_ret5 = TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0);
		local Create_ret5 = m_Library.TweenService:Create(p13.TextLabel.UIStroke, TweenInfo_new_ret5, {Transparency = 1});
		Create_ret5:Play();
	end);
end
t_TradingHistory.Bottom.Search.Query:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 425
	UpdateHistory();
end);
t_TradingHistory.Close.Activated:Connect(function() -- Line: 430
	--[[
		Upvalues:
			[1] = bool1
			[2] = m_Library
			[3] = Random_new_ret
			[4] = t_TradingHistory
	--]]
	if not bool1 then
		bool1 = true;
		m_Library.Audio.Play("rbxassetid://8951380772", script, Random_new_ret:NextNumber(0.95, 1.05), 0.1);
		t_TradingHistory.Gui.Enabled = false;
		bool1 = false;
	end
end);
t_TradingHistory.Bottom.Back.Activated:Connect(function() -- Line: 440
	--[[
		Upvalues:
			[1] = bool1
			[2] = m_Library
	--]]
	if not bool1 then
		bool1 = true;
		m_Library.Signal.Fire("Open Trade List");
		bool1 = false;
	end
end);
t_TradingHistory.ViewBottom.Back.Activated:Connect(function() -- Line: 449
	--[[
		Upvalues:
			[1] = bool1
			[2] = m_Library
	--]]
	if not bool1 then
		bool1 = true;
		m_Library.Signal.Fire("Open Trading History");
		bool1 = false;
	end
end);
m_Library.Signal.Fired("Stat Changed"):Connect(function(p14) -- Line: 461
	if p14 == "TradingHistory2" then
		UpdateHistory();
	end
end);
m_Library.Signal.Fired("Open Trading History"):Connect(function() -- Line: 468
	--[[
		Upvalues:
			[1] = str1
			[2] = t_TradingHistory
	--]]
	UpdateHistory();
	str1 = "";
	t_TradingHistory.TradingHistory.Bottom.Search.Query.Text = "";
	t_TradingHistory.TradingHistory.Visible = true;
	t_TradingHistory.TradeView.Visible = false;
	t_TradingHistory.Gui.Enabled = true;
end);
m_Library.GUIFX.ButtonFX(t_TradingHistory.Close);
m_Library.GUIFX.ButtonFX(t_TradingHistory.Bottom.Back);
m_Library.GUIFX.ButtonFX(t_TradingHistory.ViewBottom.Back);
m_Library.GUIFX.Tooltip(t_TradingHistory.TradingHistory.Rating, "Requires " .. m_Library.Shared.TradeRatingRequirement .. " ratings to be rated");
