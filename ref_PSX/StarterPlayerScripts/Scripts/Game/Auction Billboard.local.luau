-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local v1 = m_Library.Shared.IsTradingPlaza or m_Library.RunService:IsStudio();
local t_Inventory = m_Library.Assets.UI.Inventory;
local FindFirstChild_ret = nil;
local Color3_fromHSV_ret = nil;
local u1 = nil;
local table1 = {};
local u2 = {};
local table2 = {};
function PlaySound(p1, p2, p3) -- Line: 51
	--[[
		Upvalues:
			[1] = FindFirstChild_ret
			[2] = m_Library
	--]]
	if not FindFirstChild_ret then return end
	if not p3 then
		local v5 = m_Library.Audio.Play(p1, FindFirstChild_ret.PrimaryPart, 1, p2 or 1, nil, nil, false);
		v5.RollOffMaxDistance = 500;
		v5.RollOffMinDistance = 400;
		return;
	end
	m_Library.Audio.Play(p1, script, 1, 1);
end
function GetCurrentAuction() -- Line: 67
	--[[
		Upvalues:
			[1] = u2
	--]]
	if #u2 == 0 or u2[1].Completed or not u2[1].EndTime then
		return nil;
	end
	return u2[1];
end
function SetupPetGui(p4, p5, p6) -- Line: 76
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Inventory
			[3] = Color3_fromHSV_ret
	--]]
	local _ = m_Library.Directory.Pets[p4.id];
	if p5 then
		p5:Destroy();
	end
	p5 = t_Inventory.Pet:Clone();
	m_Library.PetUI.Create(p5, p4.uid, p4);
	p5.Size = UDim2.new(1, 0, 1, 0);
	p5.Level:FindFirstChildOfClass("UIStroke").Thickness = 4;
	p5.HC:FindFirstChildOfClass("UIStroke").Thickness = 4;
	p5.Stars.Visible = true;
	p5.Equipped.Visible = false;
	p5.Name = "Pet";
	p5.Parent = p6;
	p5:SetAttribute("SurfaceElement", true);
	if p4.r then
		local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 98
			--[[
				Upvalues:
					[1] = p5
					[2] = Color3_fromHSV_ret
					[3] = m_Library
			--]]
			while p5 and p5.Parent and p5.Parent.Parent do
				p5.PetIcon.ImageColor3 = Color3_fromHSV_ret;
				m_Library.RenderStepped();
			end
		end);
		coroutine_wrap_ret();
	end
end
function UpdateAuctionTime(p7, p8) -- Line: 108
	local math_max_ret = math.max(p7.EndTime - workspace:GetServerTimeNow(), 0);
	local v2 = math_max_ret / 60;
	p8.Progress.Bar.Size = UDim2.new(v2, 0, 1, 0);
	p8.Seconds.Text = math.ceil(math_max_ret) .. "s";
end
function UpdateLayout() -- Line: 117
	--[[
		Upvalues:
			[1] = FindFirstChild_ret
			[2] = u1
			[3] = u2
	--]]
	if not FindFirstChild_ret then return end
	local Main = FindFirstChild_ret:FindFirstChild("Main");
	local SurfaceGui = Main:FindFirstChild("SurfaceGui");
	local t_LeftPanel = SurfaceGui.LeftPanel;
	local t_RightPanel = SurfaceGui.RightPanel;
	local t_CurrentAuction = t_LeftPanel.CurrentAuction;
	local t_PreviousBids = t_LeftPanel.PreviousBids;
	local t_PetHolder = t_CurrentAuction.PetHolder;
	local t_UpcomingAuctions = t_RightPanel.UpcomingAuctions;
	local t_TextHolder = t_CurrentAuction.TextHolder;
	local Pet = t_PetHolder:FindFirstChild("Pet");
	if u1 then
		local v6 = u1.CurrentBid ~= nil;
		t_TextHolder.Position = UDim2.new(1, 0, 0.1, 0);
		t_PetHolder.NoAuction.Visible = false;
		t_LeftPanel.Title.Text = v6 and "\240\159\142\137 Winning Bid! \240\159\142\137" or "\226\152\185 No Winner! \226\152\185";
		t_LeftPanel.TimeLeft.Visible = false;
		t_LeftPanel.WinningBid.Visible = true;
		t_PreviousBids.Visible = false;
		t_TextHolder.CurrentBid.Visible = true;
		t_TextHolder.PlaceBidHolder.Visible = false;
	elseif #u2 == 0 or not u1 and not GetCurrentAuction() then
		t_TextHolder.Position = UDim2.new(1, 0, 0.2, 0);
		if Pet then
			Pet:Destroy();
			t_PetHolder.NoAuction.Visible = true;
		end
		t_LeftPanel.Title.Text = "No Current Auction!";
		t_LeftPanel.TimeLeft.Visible = false;
		t_LeftPanel.WinningBid.Visible = false;
		t_PreviousBids.Visible = false;
		t_TextHolder.CurrentBid.Visible = false;
		t_TextHolder.PlaceBidHolder.Visible = false;
	else
		t_TextHolder.Position = UDim2.new(1, 0, 0, 0);
		t_PetHolder.NoAuction.Visible = false;
		t_LeftPanel.Title.Text = "\240\159\155\141 Current Auction \240\159\155\141";
		t_LeftPanel.TimeLeft.Visible = true;
		t_LeftPanel.WinningBid.Visible = false;
		t_PreviousBids.Visible = true;
		t_TextHolder.CurrentBid.Visible = true;
		t_TextHolder.PlaceBidHolder.Visible = true;
	end
	t_UpcomingAuctions.NoAuction.Visible = #u2 == 0 and true or #u2 == 1 and GetCurrentAuction() or false;
end
function UpdateBillboard() -- Line: 174
	--[[
		Upvalues:
			[1] = FindFirstChild_ret
			[2] = u1
			[3] = m_Library
			[4] = u2
			[5] = table2
	--]]
	if not FindFirstChild_ret then return end
	local CurrentAuction = GetCurrentAuction();
	local Main2 = FindFirstChild_ret:FindFirstChild("Main");
	local SurfaceGui2 = Main2:FindFirstChild("SurfaceGui");
	local t_LeftPanel2 = SurfaceGui2.LeftPanel;
	local t_RightPanel2 = SurfaceGui2.RightPanel;
	local t_CurrentAuction2 = t_LeftPanel2.CurrentAuction;
	local t_PreviousBids2 = t_LeftPanel2.PreviousBids;
	local t_TimeLeft = t_LeftPanel2.TimeLeft;
	local t_PetHolder2 = t_CurrentAuction2.PetHolder;
	local t_TextHolder2 = t_CurrentAuction2.TextHolder;
	local Pet2 = t_PetHolder2:FindFirstChild("Pet");
	if u1 then
		local t_WinningBid = t_LeftPanel2.WinningBid;
		local t_PetData3 = u1.PetData;
		local v7 = u1.CurrentBid ~= nil;
		SetupPetGui(t_PetData3, Pet2, t_PetHolder2);
		t_WinningBid.Visible = true;
		t_WinningBid.Title.Text = v7 and "\240\159\165\179 Congrats!" or "\226\157\140 Failed!";
		t_WinningBid.Subtitle.Text = v7 and "Won by @" .. u1.CurrentBid.UserName or "Pet was not bid on!";
		t_TextHolder2.Title.Text = m_Library.Shared.PetNameShort(t_PetData3);
		t_TextHolder2.Player.Text = "@" .. u1.UserName;
		t_TextHolder2.CurrentBid.Cost.Text = u1.CurrentBid and m_Library.Functions.NumberShorten(u1.CurrentBid.Amount) or m_Library.Functions.NumberShorten(u1.MinimumBidAmount);
	elseif not CurrentAuction then
		t_TextHolder2.Title.Text = "No Auction";
		t_TextHolder2.Player.Text = "Start one!";
	else
		local t_PetData2 = CurrentAuction.PetData;
		SetupPetGui(t_PetData2, Pet2, t_PetHolder2);
		t_TextHolder2.Title.Text = m_Library.Shared.PetNameShort(t_PetData2);
		t_TextHolder2.Player.Text = "@" .. CurrentAuction.UserName;
		t_TextHolder2.CurrentBid.Cost.Text = CurrentAuction.CurrentBid and m_Library.Functions.NumberShorten(CurrentAuction.CurrentBid.Amount) or m_Library.Functions.NumberShorten(CurrentAuction.MinimumBidAmount);
		UpdateAuctionTime(CurrentAuction, t_TimeLeft);
	end
	local _ = t_RightPanel2.StartAuction.ListPet;
	local t_UpcomingAuctions2 = t_RightPanel2.UpcomingAuctions;
	local UpcomingAuction = t_UpcomingAuctions2:FindFirstChild("UpcomingAuction");
	UpcomingAuction.Visible = false;
	for _, child1 in pairs(t_UpcomingAuctions2:GetChildren()) do
		if not child1:IsA("Frame") or child1.Name == "UpcomingAuction" or child1.Name == "NoAuction" then continue end
		local t_LayoutOrder2 = child1.LayoutOrder;
		if u2[t_LayoutOrder2] and u2[t_LayoutOrder2].Id == child1.Name and not u2[t_LayoutOrder2].Completed and not u2[t_LayoutOrder2].EndTime then continue end
		child1:Destroy();
	end
	for _, val2 in ipairs(u2) do
		if t_UpcomingAuctions2:FindFirstChild(val2.Id) or val2.Completed or val2.EndTime then continue end
		local Clone_ret2 = UpcomingAuction:Clone();
		local t_PetData = val2.PetData;
		Clone_ret2.Visible = true;
		Clone_ret2.PetName.Text = m_Library.Shared.PetNameShort(t_PetData);
		local t_PetHolder3 = Clone_ret2.PetHolder;
		local Pet3 = t_PetHolder3:FindFirstChild("Pet");
		SetupPetGui(t_PetData, Pet3, t_PetHolder3);
		Clone_ret2.Name = val2.Id;
		Clone_ret2.Parent = t_UpcomingAuctions2;
	end
	local t_PreviousBid = t_PreviousBids2.PreviousBid;
	t_PreviousBid.Visible = false;
	if not CurrentAuction and not u1 then
		for _, child4 in pairs(t_PreviousBids2:GetChildren()) do
			if not child4:IsA("Frame") or child4.Name == "PreviousBid" then continue end
			child4:Destroy();
		end
	else
		local v8 = u1 and u1.PreviousBids or CurrentAuction.PreviousBids;
		local t_CurrentBid = nil;
		if u1 then
			t_CurrentBid = u1.CurrentBid;
		elseif CurrentAuction then
			t_CurrentBid = CurrentAuction.CurrentBid;
		end
		if t_CurrentBid then
			table.insert(v8, 1, t_CurrentBid);
		end
		for _, child5 in pairs(t_PreviousBids2:GetChildren()) do
			if not child5:IsA("Frame") or child5.Name == "PreviousBid" then continue end
			local t_LayoutOrder = child5.LayoutOrder;
			if v8[t_LayoutOrder] and v8[t_LayoutOrder].UserId .. "-" .. v8[t_LayoutOrder].Amount == child5.Name then continue end
			child5:Destroy();
		end
		for key6, val6 in ipairs(v8) do
			local FindFirstChild_ret2 = t_PreviousBids2:FindFirstChild(val6.UserId .. "-" .. val6.Amount);
			if FindFirstChild_ret2 or key6 > 3 then continue end
			local Clone_ret = t_PreviousBid:Clone();
			Clone_ret.Name = val6.UserId .. "-" .. val6.Amount;
			Clone_ret.CurrentBid.Cost.Text = m_Library.Functions.NumberShorten(val6.Amount);
			Clone_ret.LayoutOrder = key6;
			Clone_ret.Parent = t_PreviousBids2;
			Clone_ret.Visible = true;
			task.spawn(function() -- Line: 305
				--[[
					Upvalues:
						[1] = m_Library
						[2] = table2
						[3] = val6
						[4] = Clone_ret
				--]]
				if m_Library.Functions.DictionaryLength(table2) > 1000 then
					table2 = {};
				end
				local v11 = table2[val6.UserId] or game.Players:GetUserThumbnailAsync(val6.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180);
				if v11 then
					Clone_ret.AvatarHolder.Player.Image = v11;
					table2[val6.UserId] = v11;
				end
			end);
		end
	end
	UpdateLayout();
end
function RequestAuctions() -- Line: 323
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u2
			[3] = table1
	--]]
	local v3 = m_Library.Network.Invoke("Auction: List");
	if not v3 then
		UpdateBillboard();
		return;
	end
	u2 = v3;
	for _, val3 in ipairs(v3) do
		table1[val3.Id] = val3;
	end
	UpdateBillboard();
end
function SetupBillboard() -- Line: 340
	--[[
		Upvalues:
			[1] = m_Library
			[2] = FindFirstChild_ret
			[3] = u2
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		FindFirstChild_ret = Map.Interactive:FindFirstChild("Auction Board");
		if FindFirstChild_ret then
			RequestAuctions();
			local Main3 = FindFirstChild_ret:FindFirstChild("Main");
			local SurfaceGui3 = Main3:FindFirstChild("SurfaceGui");
			local t_LeftPanel3 = SurfaceGui3.LeftPanel;
			local t_RightPanel3 = SurfaceGui3.RightPanel;
			local t_PlaceBid = t_LeftPanel3.CurrentAuction.TextHolder.PlaceBidHolder.PlaceBid;
			local t_ListPet = t_RightPanel3.StartAuction.ListPet;
			m_Library.GUIFX.ButtonFX(t_PlaceBid);
			t_PlaceBid.Activated:Connect(function() -- Line: 355
				--[[
					Upvalues:
						[1] = m_Library
				--]]
				local CurrentAuction2 = GetCurrentAuction();
				if CurrentAuction2 and CurrentAuction2.UserId == m_Library.LocalPlayer.UserId then
					if m_Library.Variables.MessageOpen then return end
					if m_Library.RunService:IsStudio() == false then
						m_Library.Message.New("You cannot bid on your own auction!");
						return;
					end	
				end
				local CurrentAuction3 = GetCurrentAuction();
				m_Library.Signal.Fire("Auction Bid", CurrentAuction3, ComputeRequiredBid(CurrentAuction3));
			end);
			m_Library.GUIFX.ButtonFX(t_ListPet);
			t_ListPet.Activated:Connect(function() -- Line: 371
				--[[
					Upvalues:
						[1] = u2
						[2] = m_Library
				--]]
				for _, val11 in ipairs(u2) do
					if val11.UserId ~= m_Library.LocalPlayer.UserId then continue end
					if m_Library.Variables.MessageOpen then return end
					m_Library.Message.New("You already have an auction pending!");
					return;
				end
				m_Library.GUI.AuctionSelect.Gui.Enabled = true;
			end);
		end
	end
end
function ComputeRequiredBid(p9) -- Line: 391
	if not p9 then
		return 0;
	end
	local v4 = p9.MinimumBidAmount;
	local t_CurrentBid2 = p9.CurrentBid;
	if t_CurrentBid2 then
		local t_Amount = t_CurrentBid2.Amount;
		v4 = t_Amount + math.ceil(t_Amount * 0.01);
	end
	return v4;
end
m_Library.Network.Fired("Auction: Update"):Connect(function(p10) -- Line: 422
	--[[
		Upvalues:
			[1] = u1
			[2] = u2
			[3] = table1
			[4] = m_Library
			[5] = FindFirstChild_ret
	--]]
	if p10.Completed then
		u1 = p10;
		local t_Id = p10.Id;
		local v9 = nil;
		for key7, val7 in ipairs(u2) do
			if val7.Id ~= t_Id then continue end
			v9 = key7;
			break;
		end
		if v9 then
			table.remove(u2, v9);
		end
		table1[t_Id] = nil;
		m_Library.Signal.Fire("Auction Ended", p10);
		if FindFirstChild_ret and p10.CurrentBid then
			local ConfettiCannons = FindFirstChild_ret:FindFirstChild("ConfettiCannons");
			for _, child8 in pairs(ConfettiCannons:GetChildren()) do
				for _, child10 in pairs(child8:GetChildren()) do
					child10:Emit(12);
				end
			end
			PlaySound(p10.CurrentBid.Amount >= 200000000000 and "rbxassetid://12625270848" or "rbxassetid://12625271057", 1, false);
		end
		if FindFirstChild_ret and not p10.CurrentBid then
			PlaySound("rbxassetid://12625270945", 1, false);
		end
		if m_Library.LocalPlayer.UserId == p10.UserId and p10.CurrentBid then
			PlaySound("rbxassetid://11648890524", 1, true);
		end
	else
		if p10.EndTime then
			u1 = nil;
			m_Library.Signal.Fire("Minimum Bid Update", ComputeRequiredBid(p10));
		end
		local v10 = table1[p10.Id];
		if not v10 then
			table1[p10.Id] = p10;
			table.insert(u2, p10);
		else
			if not v10.EndTime and p10.EndTime then
				if p10.UserId == m_Library.LocalPlayer.UserId then
					m_Library.Signal.Fire("Notification", "Your " .. m_Library.Shared.PetNameShort(p10.PetData) .. " auction has started!", {
						color = Color3.fromRGB(78, 244, 252),
						force = true
					});
				end
				PlaySound("rbxassetid://12629752694", 0.7, false);
			end
			if p10.CurrentBid and (not v10.CurrentBid or v10.CurrentBid.UserId ~= p10.CurrentBid.UserId) then
				PlaySound("rbxassetid://12629775896", 0.5, false);
				if p10.UserId == m_Library.LocalPlayer.UserId then
					PlaySound("rbxassetid://12629775773", 1, true);
					m_Library.Signal.Fire("Notification", p10.CurrentBid.UserName .. " bid " .. m_Library.Functions.NumberShorten(p10.CurrentBid.Amount) .. " Diamonds on your " .. m_Library.Shared.PetNameShort(p10.PetData) .. "!", {
						color = Color3.fromRGB(105, 255, 168),
						force = true
					});
				end
			end
			table1[p10.Id] = p10;
			for key9, val9 in ipairs(u2) do
				if val9.Id ~= p10.Id then continue end
				u2[key9] = p10;
				break;
			end
		end
	end
	UpdateBillboard();
end);
m_Library.Signal.Fired("World Changed"):Connect(function(p11) -- Line: 506
	if p11 == "Trading Plaza" then
		SetupBillboard();
	end
end);
m_Library.Signal.Invoked("Get Current Auction").OnInvoke = function() -- Line: 513
	return GetCurrentAuction();
end
m_Library.Signal.Invoked("Get Auctions").OnInvoke = function() -- Line: 518
	--[[
		Upvalues:
			[1] = u2
			[2] = table1
	--]]
	return u2, table1;
end
local u3 = 0;
if v1 then
	m_Library.RunService.RenderStepped:Connect(function(p13) -- Line: 529
		--[[
			Upvalues:
				[1] = u3
				[2] = FindFirstChild_ret
				[3] = u1
		--]]
		u3 = u3 + p13;
		if u3 < 0.1 then return end
		u3 = u3 - 0.1;
		local CurrentAuction4 = GetCurrentAuction();
		if not FindFirstChild_ret or not CurrentAuction4 or u1 then return end
		local Main4 = FindFirstChild_ret:FindFirstChild("Main");
		UpdateAuctionTime(CurrentAuction4, Main4:FindFirstChild("SurfaceGui").LeftPanel.TimeLeft);
	end);
end
local u4 = 0;
game:GetService("RunService").RenderStepped:Connect(function(p12) -- Line: 553
	--[[
		Upvalues:
			[1] = u4
			[2] = Color3_fromHSV_ret
	--]]
	u4 = u4 + p12;
	Color3_fromHSV_ret = Color3.fromHSV(u4 / 2 % 1, 1, 1);
end);
