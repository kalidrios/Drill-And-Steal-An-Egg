local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do game:GetService("RunService").Heartbeat:Wait(); end

local t_Bank = m_Library.GUI.Bank;
local t_Bank2 = m_Library.Assets.UI.Bank;
local t_BankLoading = m_Library.GUI.BankLoading;
local t_Settings = t_Bank.Container.Settings;
local Random_new_ret = Random.new();
local _ = m_Library.RunService:IsStudio();
local u1 = {};
local bool1 = false;
local u2 = {};
local bool2 = false;
local u3 = nil;
local bool3 = false;
local u4 = false;
local u5 = false;
local u6 = 0;
local table1 = {};
local u7 = 0;
local table2 = {};
local bool4 = false;
local bool5 = false;
local u8 = false;
local u9 = false;
local u10 = 0;
local u11 = 0;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = 0;
local u17 = nil;
function Deposit()
	local v1 = u7 > 0;
	local v2 = #table2 > 0;
	if not u5 or not bool3 or not v2 and not v1 then return end
	local v3 = "";
	if v2 and v1 then
		v3 = "Are you sure you want to deposit " .. m_Library.Functions.Commas(#table2) .. " Pet" .. (#table2 > 1 and "s" or "") .. " and " .. m_Library.Functions.Commas(u7) .. " Diamonds?";
	elseif v2 then
		v3 = "Are you sure you want to deposit " .. m_Library.Functions.Commas(#table2) .. " Pet" .. (#table2 > 1 and "s" or "") .. "?";
	elseif v1 then
		v3 = "Are you sure you want to deposit " .. m_Library.Functions.Commas(u7) .. " Diamonds?";
	end
	local v4 = m_Library.Message.New(v3, true);
	if v4 then
		Processing(true, true);
		local t_BUID = u3.BUID;
		local v48, v49 = m_Library.Network.Invoke("Bank Deposit", t_BUID, table2, u7);
		Processing(false);
		if v48 then
			m_Library.Audio.Play("rbxassetid://8168485698", script);
			m_Library.Message.New("\226\156\133 Success!");
			u5 = false;
			UpdateDeposit();
			UpdateBank(t_BUID);
			return;
		end
		m_Library.Message.New(v49 or "Something went wrong. Try again!");
	end
end
local bool6 = false;
local table3 = {};
local u18 = nil;
local u19 = nil;
local u20 = nil;
function updateInventoryDrag(p1, p2, p3, p4)  
	if not t_Bank.Gui.Enabled then return end
	if m_Library.Variables.MessageOpen then return end
	if not m_Library.FFlags.Get(m_Library.FFlags.Keys.DragDelete) then return end
	if u5 == false and u4 == false then return end
	if bool6 then return end
	bool6 = true;
	local v5 = u5 == true and t_Bank.Deposit.Pets or t_Bank.Container.Bank.Pets;
	local v6 = v5.AbsolutePosition.Y + v5.AbsoluteSize.Y;
	local t_Y = v5.AbsolutePosition.Y;
	if p2 == p4 then
		p4 = p4 + 1;
	end
	local vec2 = Vector2.new(p1, p2);
	local vec2_2 = Vector2.new(p3, p4);
	if (vec2 - vec2_2).magnitude < 20 then
		bool6 = false;
		return;
	end
	local table4 = {};
	for _, child2 in ipairs(v5:GetChildren()) do
		if not child2:isA("TextButton") then continue end
		table.insert(table4, child2);
	end
	local num1 = nil;
	for _, val3 in ipairs(table3) do
		local t_Name2 = val3.Name;
		local _ = m_Library.PetCmds.Get(t_Name2);
		local t_AbsolutePosition = val3.AbsolutePosition;
		local v50 = t_AbsolutePosition.X or 0;
		local v51 = t_AbsolutePosition.Y or 0;
		if v6 < v51 or v51 < t_Y then continue end
		local t_AbsoluteSize = val3.AbsoluteSize;
		local vec2_5 = Vector2.new(v50, v51);
		local vec2_6 = Vector2.new(v50 + t_AbsoluteSize.X, v51 + t_AbsoluteSize.Y);
		if m_Library.Functions.CheckRectangleIntersection(vec2, vec2_2, vec2_5, vec2_6) then continue end
		if num1 == nil then
			num1 = 1;
		end
		if num1 == 1 then
			for _, val23 in ipairs(u5 == true and table2 or table1) do
				if val23 ~= t_Name2 then continue end
				SelectPet(u5 == true and table2 or table1, t_Name2);
				if u5 == true then
					UpdateDeposit();
					break;
				end
				UpdateBank();
				UpdateWithdraw();
				break;
			end
		end
		table.remove(table3, table.find(table3, val3));
	end
	for _, val4 in ipairs(table4) do
		if table.find(table3, val4) or not val4:GetAttribute("isVisible") or not val4.Visible then continue end
		local t_X = val4.AbsolutePosition.X;
		local t_Y2 = val4.AbsolutePosition.Y;
		local vec2_3 = Vector2.new(t_X, t_Y2);
		local vec2_4 = Vector2.new(t_X + val4.AbsoluteSize.X, t_Y2 + val4.AbsoluteSize.Y);
		local bool7 = false;
		if not m_Library.Functions.CheckRectangleIntersection(vec2, vec2_2, vec2_3, vec2_4) or v6 < t_Y2 + val4.AbsoluteSize.Y / 2 or t_Y2 + val4.AbsoluteSize.Y / 2 < t_Y then continue end
		local t_Name = val4.Name;
		local v52 = nil;
		local v53 = nil;
		if u5 == true then
			v52 = m_Library.PetCmds.Get(t_Name);
			if not v52 then continue end
			assert(v52);
			v53 = m_Library.Directory.Pets[v52.id];
		end
		if not m_Library.Functions.SearchArray(u5 == true and table2 or table1, t_Name) then
			if num1 == nil then
				num1 = 0;
			end
			if num1 == 0 then
				if u5 == true then
					if v52.l or v53.titanic then continue end
					local v97 = m_Library.Signal.Invoke("Is Trading Booth Pet", t_Name);
					if v97 then continue end
				end
				SelectPet(u5 == true and table2 or table1, t_Name);
				if u5 then
					UpdateDeposit();
				else
					UpdateBank();
					UpdateWithdraw();
				end
				bool7 = true;
			end
		end
		if not bool7 then continue end
		table.insert(table3, val4);
	end
	bool6 = false;
end
function newDrag()  
	assert(u19 and u20);
	local Mouse = game.Players.LocalPlayer:GetMouse();
	local t_X2 = Mouse.X;
	local t_Y3 = Mouse.Y;
	u18 = Instance.new("ScreenGui");
	assert(u18);
	u18.DisplayOrder = 9999;
	u18.Name = "DragUI";
	local Frame = Instance.new("Frame");
	Frame.BackgroundColor3 = Color3.fromRGB(39, 233, 55);
	Frame.Parent = u18;
	u18.Parent = m_Library.LocalPlayer.PlayerGui;
	Frame.Position = UDim2.new(0, u19, 0, u20);
	Frame.Size = UDim2.new(0, t_X2 - u19, 0, t_Y3 - u20);
	Frame.ZIndex = 9999;
	Frame.BackgroundTransparency = 0.5;
end
function updateDrag() 
	local DragUI = m_Library.LocalPlayer.PlayerGui:FindFirstChild("DragUI");
	if not DragUI then return end
	local Frame2 = DragUI:FindFirstChild("Frame");
	if not Frame2 then return end
	assert(u19 and u20);
	local Mouse2 = game.Players.LocalPlayer:GetMouse();
	local t_X3 = Mouse2.X;
	local t_Y4 = Mouse2.Y;
	Frame2.Position = UDim2.new(0, u19, 0, u20);
	Frame2.Size = UDim2.new(0, t_X3 - u19, 0, t_Y4 - u20);
end
m_Library.Signal.Fired("Click Drag Complete"):Connect(function() 
	table3 = {};
end);
m_Library.Signal.Fired("Click Drag Update"):Connect(updateInventoryDrag);
m_Library.UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)  
	if not t_Bank.Gui.Enabled then return end
	if m_Library.Variables.MessageOpen then return end
	if not m_Library.FFlags.Get(m_Library.FFlags.Keys.DragDelete) then return end
	if not m_Library.FFlags.Get(m_Library.FFlags.Keys.BankDragDelete) then return end
	if u5 == false and u4 == false then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local Mouse3 = game.Players.LocalPlayer:GetMouse();
		u19 = Mouse3.X;
		u20 = Mouse3.Y;
		m_Library.Signal.Fire("Click Drag Start", u19, u20);
	end
end);
m_Library.UserInputService.InputEnded:Connect(function(input2, gameProcessedEvent2)  
	if input2.UserInputType == Enum.UserInputType.MouseButton1 then
		local Mouse4 = game.Players.LocalPlayer:GetMouse();
		local t_X4 = Mouse4.X;
		local t_Y5 = Mouse4.Y;
		if u19 and u20 then
			m_Library.Signal.Fire("Click Drag Complete", u19, u20, t_X4, t_Y5);
			if u18 then
				u18:Destroy();
				u18 = nil;
			end
			u19 = nil;
			u20 = nil;
		end
	end
end);
m_Library.UserInputService.InputChanged:Connect(function(input3, gameProcessedEvent3)  
	if input3.UserInputType == Enum.UserInputType.MouseMovement and u19 and u20 then
		if not u18 then
			newDrag();
			return;
		end
		updateDrag();
		local Mouse5 = game.Players.LocalPlayer:GetMouse();
		local t_X5 = Mouse5.X;
		local t_Y6 = Mouse5.Y;
		m_Library.Signal.Fire("Click Drag Update", u19, u20, t_X5, t_Y6);
	end
end);
function Withdraw() 
	local v7 = u6 > 0;
	local v8 = #table1 > 0;
	if not u4 or not bool3 or not v8 and not v7 then return end
	local v9 = "";
	if v8 and v7 then
		v9 = "Are you sure you want to withdraw " .. m_Library.Functions.Commas(#table1) .. " Pet" .. (#table1 > 1 and "s" or "") .. " and " .. m_Library.Functions.Commas(u6) .. " Diamonds?";
	elseif v8 then
		v9 = "Are you sure you want to withdraw " .. m_Library.Functions.Commas(#table1) .. " Pet" .. (#table1 > 1 and "s" or "") .. "?";
	elseif v7 then
		v9 = "Are you sure you want to withdraw " .. m_Library.Functions.Commas(u6) .. " Diamonds?";
	end
	local v10 = m_Library.Message.New(v9, true);
	if v10 then
		Processing(true, true);
		local t_BUID2 = u3.BUID;
		local v54, v55 = m_Library.Network.Invoke("Bank Withdraw", t_BUID2, table1, u6);
		Processing(false);
		if v54 then
			m_Library.Audio.Play("rbxassetid://8168485924", script);
			m_Library.Message.New("\226\156\133 Success!");
			u4 = false;
			UpdateWithdraw();
			UpdateBank(t_BUID2);
			return;
		end
		m_Library.Message.New(v55 or "Something went wrong. Try again!");
	end
end
function UpgradeBank(p5)  
	if not bool3 then return end
	local v11 = u3.Tier + 1;
	local t_BUID3 = u3.BUID;
	if p5 then
		local t_ProductId = m_Library.Directory.Banks[v11].ProductId;
		local v56, v57 = m_Library.Network.Invoke("Prompt Upgrade Bank", t_BUID3, t_ProductId);
		if v56 then
			m_Library.Shared.PromptPurchase(t_ProductId, true);
			return;
		end
		m_Library.Message.New(v57 or "Something went wrong. Try again later!");
		return;
	end
	local v12 = m_Library.Message.New("Are you sure you want to upgrade your bank to Tier " .. v11 .. "?", true);
	if v12 then
		Processing(true);
		local v58, v59 = m_Library.Network.Invoke("Upgrade Bank", t_BUID3);
		Processing(false);
		if v58 then
			m_Library.Audio.Play("rbxassetid://8167470240", script);
			m_Library.Message.New("\226\156\133 Success! Your bank is now Tier " .. v11 .. "!");
			GetBank(t_BUID3);
			UpdateSettings();
			return;
		end
		m_Library.Message.New(v59 or "Something went wrong. Try again!");
	end
end
function LeaveBank(p6)  
	local v13 = m_Library.Message.New("Are you sure you want to leave this bank?", true);
	if v13 then
		Processing(true);
		local v60, v61 = m_Library.Network.Invoke("Leave Bank", p6 or u3.BUID);
		Processing(false);
		if v60 then
			GetMyBanks();
			UpdateSide();
			SwitchWindow("Empty");
			return;
		end
		m_Library.Message.New(v61 or "Something went wrong. Try again!");
	end
end
function BuyBank()  
	local v14 = m_Library.Message.New("This costs " .. m_Library.Functions.Commas(m_Library.Directory.Banks[1].Cost) .. " Diamonds. Are you sure?", true);
	if v14 then
		Processing(true);
		local v62, v63, v64 = m_Library.Network.Invoke("Buy Bank");
		Processing(false);
		if v62 then
			m_Library.Audio.Play("rbxassetid://8167470240", script);
			m_Library.Message.New("\240\159\142\137 Congrats! You now own a bank account!");
			GetMyBanks();
			UpdateSide();
			UpdateBank(v64);
			return;
		end
		m_Library.Message.New(v63 or "Something went wrong. Try again!");
	end
end
function CancelOutgoingInvites()  
	local v15 = m_Library.Message.New("Are you sure? This will cancel ALL outgoing invites.", true);
	if v15 then
		Processing(true);
		local v65, v66 = m_Library.Network.Invoke("Cancel Bank Outgoing Invites");
		Processing(false);
		if v65 then
			m_Library.Message.New("Any outgoing invites are now canceled!");
			return;
		end
		m_Library.Message.New(v66 or "Something went wrong. Try again!");
	end
end
function DecideInvite(p7)  
	local v16 = m_Library.Message.New("Do you want to accept this invite?", true);
	if v16 then
		local v67, v68 = m_Library.Network.Invoke("Accept Bank Invite", p7);
		if v67 then
			m_Library.Message.New("Success! You are now a member.");
			GetMyBanks();
			GetMyInvites();
			UpdateSide();
			UpdateBank(p7);
			return;
		end
		m_Library.Message.New(v68 or "Something went wrong. Try again!");
		return;
	end
	local v17, _ = m_Library.Network.Invoke("Decline Bank Invite", p7);
	if v17 then
		GetMyInvites();
		UpdateSide();
	end
end
function RejectAllInvites() 
	local v18 = m_Library.Message.New("Are you sure you want to reject ALL invites?", true);
	if v18 then
		local v69, _ = m_Library.Network.Invoke("Decline All Bank Invites");
		if v69 then
			GetMyInvites();
			UpdateSide();
		end
	end
end
function InviteToBank(p8) 
	local UserIdFromNameAsync = nil;
	local success = pcall(function()  
		UserIdFromNameAsync = game.Players:GetUserIdFromNameAsync(p8 or "");
	end);
	
	local TESTID = {
		["Player1"] = -1,
		["Player2"] = -2
	}
	
	if not success or not UserIdFromNameAsync and not (TESTID[p8] and m_Library.RunService:IsStudio()) then
		m_Library.Message.New("Couldn't find player. Are you sure that's the correct @?");
		return;
	end
	
	if TESTID[p8] then
		UserIdFromNameAsync = TESTID[p8]
	end
	
	if u3.Owner == UserIdFromNameAsync then
		m_Library.Message.New("You may not invite yourself!");
		return;
	end
	if table.find(u3.Players, UserIdFromNameAsync) then
		m_Library.Message.New("Player is already a member of your bank!");
		return;
	end
	local v19 = m_Library.Message.New("Are you sure you want to invite " .. p8 .. " to your bank? They will have access to your pets & diamonds.", true);
	if v19 then
		Processing(true);
		local v70, v71 = m_Library.Network.Invoke("Invite To Bank", u3.BUID, UserIdFromNameAsync);
		Processing(false);
		if v70 then
			m_Library.Message.New("\240\159\147\169 Bank invite sent to " .. p8 .. "!");
		else
			m_Library.Message.New(v71 or "Something went wrong. Try again!");
		end
	end
end
function KickMember(p9, p10)  
	local v20 = m_Library.Message.New("Are you sure you want to kick " .. p10 .. " from your bank?", true);
	if v20 then
		Processing(true);
		local t_BUID4 = u3.BUID;
		local v72, v73 = m_Library.Network.Invoke("Kick From Bank", t_BUID4, p9);
		Processing(false);
		if v72 then
			m_Library.Message.New("\226\156\133 Player has been kicked.");
			GetBank(t_BUID4);
			UpdateSettings();
			return;
		end
		m_Library.Message.New(v73 or "Something went wrong. Try again!");
	end
end
function CollectInterest()  
	if not bool3 then return end
	m_Library.Message.New("This is temporarily disabled!");
end
function UpdateBank(p11) 
	local t_Bank3 = t_Bank.Container.Bank;
	local t_Pets = t_Bank3.Pets;
	local t_Balance = t_Bank3.Bottom.Balance;
	local t_Top = t_Bank3.Top;
	local function LocalProcessing(p24)  
		local t_Processing = t_Bank.Container.Bank.Processing;
		if p24 and not u15 then
			u15 = m_Library.GIF.Create(t_Processing.GIF, {
				100,
				100
			}, {
				5,
				6
			}, 28, 0.65, true);
			t_Processing.Visible = true;
			t_Bank3.NoPets.Visible = false;
			t_Pets.Visible = false;
			return;
		end
		if u15 then
			u15();
			u15 = nil;
			t_Processing.Visible = false;
			t_Pets.Visible = true;
		end
	end
	if p11 ~= u16 then
		LocalProcessing(true);
		u16 = p11;
		t_Top.PetsAm.Text = "";
		t_Balance.Amount.Text = "";
		t_Bank3.Pets.CanvasPosition = Vector2.new();
	end
	local Bank = nil;
	if p11 then
		Bank = GetBank(p11);
		u4 = false;
		UpdateWithdraw();
	end
	if not bool3 then
		for _, child20 in ipairs(t_Pets:GetChildren()) do
			if not child20:GetAttribute("PetId") then continue end
			child20:Destroy();
		end
		if Bank and string.find(Bank, "banned") then
			u17 = p11;
			SwitchWindow("Banned");
		end
		return;
	end
	SwitchWindow("Bank");
	UpdateSide();
	local v22 = u3;
	if not v22 then return end
	if not v22.Storage then return end
	local table5 = {};
	local t_Pets2 = v22.Storage.Pets;
	local u23 = v22.Owner == (m_Library.LocalPlayer:GetAttribute("CustomUserId") or m_Library.LocalPlayer.UserId);
	t_Bank3.Bottom.Settings.Visible = not u4 and u23;
	local t_Search = t_Bank3.Top.Search;
	local v74;
	if t_Search.Query.Text == "" then
		v74 = false;
	else
		v74 = tostring(t_Search.Query.Text) ~= nil;
	end
	local v23 = v74 and string.lower(tostring(t_Search.Query.Text)) or nil;
	local v24 = 0;
	local table_clone_ret = table.clone(t_Pets2);
	local v25 = m_Library.Shared.SortPets(nil, table_clone_ret);
	for key5, val5 in pairs(v25) do
		local t_uid = val5.uid;
		local v75 = m_Library.Directory.Pets[val5.id];
		local t_name = v75.name;
		local t_rarity = v75.rarity;
		local t_powers = val5.powers;
		local t_g = val5.g;
		local t_r = val5.r;
		local t_dm = val5.dm;
		local t_sh = val5.sh;
		local t_l = val5.l;
		local v76 = t_Pets:FindFirstChild(t_uid);
		if not v76 then
			v24 = v24 + 1;
			if v24 % 250 == 0 then
				m_Library.Heartbeat();
			end
			v76 = m_Library.Assets.UI.Inventory.Pet:Clone();
			v76.Name = t_uid;
			v76:SetAttribute("PetId", t_uid);
			m_Library.PetUI.Create(v76, t_uid, val5);
			m_Library.GUIFX.ButtonFX(v76);
			v76.PetIcon.ImageTransparency = (not val5.l or u23) and 0 or 0.5;
			v76.Parent = t_Pets;
			v76.Activated:Connect(function() 
				if not bool4 and u4 then
					bool4 = true;
					if val5.l and not u23 then
						m_Library.Message.New("You cannot withdraw someone else's locked pets!");
					else
						SelectPet(table1, t_uid);
						UpdateBank();
						UpdateWithdraw();
					end
					bool4 = false;
				end
			end);
		end
		v76.LayoutOrder = key5;
		v76.Level:FindFirstChildOfClass("UIStroke").Thickness = u9 and 2 or 4;
		v76.HC:FindFirstChildOfClass("UIStroke").Thickness = u9 and 2 or 4;
		local v77 = u4 and m_Library.Functions.SearchArray(table1, t_uid);
		v76.Equipped.Visible = v77;
		if v74 then
			local bool8 = false;
			if string.find(string.lower(t_name), v23, 1, true) then
				bool8 = true;
			elseif val5.nk and string.find(string.lower(val5.nk), v23, 1, true) then
				bool8 = true;
			elseif string.find(string.lower(t_rarity), v23, 1, true) then
				bool8 = true;
			elseif t_sh and string.find("shiny", v23, 1, true) then
				bool8 = true;
			elseif t_g and (string.find("gold", v23, 1, true) or string.find("golden", v23, 1, true)) then
				bool8 = true;
			elseif t_r and string.find("rainbow", v23, 1, true) then
				bool8 = true;
			elseif t_dm and string.find("dark matter", v23, 1, true) then
				bool8 = true;
			elseif t_l and string.find("lock", v23, 1, true) then
				bool8 = true;
			elseif t_powers and #t_powers > 0 then
				for _, val25 in ipairs(t_powers) do
					local unpack_ret1, unpack_ret2 = unpack(val25);
					local v101, _ = m_Library.Shared.GetPowerDir(unpack_ret1, unpack_ret2);
					if not string.find(string.lower(v101.title), v23, 1, true) then continue end
					bool8 = true;
					break;
				end
			end
			v76.Visible = bool8 or v77;
		else
			v76.Visible = true;
		end
		table5[t_uid] = true;
	end
	for _, child6 in ipairs(t_Pets:GetChildren()) do
		local Attribute = child6:GetAttribute("PetId");
		if not Attribute or table5[Attribute] then continue end
		child6:Destroy();
	end
	t_Bank3.NoPets.Text = "Bank is empty. Deposit some pets! \240\159\153\130";
	t_Bank3.NoPets.Visible = #v25 <= 0;
	t_Balance.Amount.Text = m_Library.Functions.NumberShorten(v22.Storage.Currency.Diamonds, false);
	t_Top.PetsAm.Text = #v25 .. " Pets";
	t_Top.Grid.Image = u9 and "rbxassetid://6958935961" or "rbxassetid://6958936066";
	BankScrolling();
	LocalProcessing(false);
end
function UpdateSide() 
	local t_Holder = t_Bank.Side.Holder;
	u10 = u10 + 1;
	for index1 = 1, 2 do
		local FindFirstChild_ret = t_Holder:FindFirstChild(index1 == 1 and "_BanksLoading" or "_InvitesLoading");
		if index1 == 1 and not bool1 or index1 == 2 and not bool2 then
			if not FindFirstChild_ret then
				local Clone_ret3 = t_Bank2.Side.Loading:Clone();
				Clone_ret3.LayoutOrder = index1 == 1 and 2 or 101;
				Clone_ret3.Name = index1 == 1 and "_BanksLoading" or "_InvitesLoading";
				Clone_ret3.Parent = t_Holder;
				m_Library.GIF.Create(Clone_ret3.GIF, {
					100,
					100
				}, {
					5,
					6
				}, 28, 0.65, true);
			end
		elseif FindFirstChild_ret then
			FindFirstChild_ret:Destroy();
		end
	end
	if bool1 then
		local v78 = false;
		for _, val21 in ipairs(u1) do
			local t_BUID6 = val21.BUID;
			local t_Owner = val21.Owner;
			local v87 = t_Owner == (m_Library.LocalPlayer:GetAttribute("CustomUserId") or m_Library.LocalPlayer.UserId);
			local u28 = t_Holder:FindFirstChild(t_BUID6);
			if not u28 then
				if v87 then
					u28 = t_Bank2.Side.MyBank:Clone();
					u28.LayoutOrder = 2;
				else
					u28 = t_Bank2.Side.Account:Clone();
					u28.LayoutOrder = 10;
					coroutine.wrap(function() 
						u28.Owner.Text = "...";
						local v99 = m_Library.Functions.UserIdToUsername(t_Owner);
						if u28 and u28:FindFirstChild("Owner") then
							u28.Owner.Text = "@" .. v99 or "???";
						end
					end)()
				end
				u28.Name = t_BUID6;
				u28.Parent = t_Holder;
				m_Library.GUIFX.ButtonFX(u28);
				u28.Activated:Connect(function()  
					if not bool4 and not bool5 then
						bool4 = true;
						bool5 = true;
						m_Library.Audio.Play({
							"rbxassetid://8168486176",
							"rbxassetid://8168485794"
						}, script, Random_new_ret:NextNumber(0.95, 1.01), 0.5);
						UpdateBank(t_BUID6);
						bool4 = false;
						task.wait(2);
						bool5 = false;
					end
				end);
			end
			u28:SetAttribute("Tick", u10);
			if bool3 and u3.BUID == t_BUID6 then
				u28.Image = "rbxassetid://8121303915";
				u28.HoverImage = "rbxassetid://8121307910";
			else
				u28.Image = "rbxassetid://7045637286";
				u28.HoverImage = "rbxassetid://7045637411";
			end
			v78 = v78 or v87;
		end
		local _BuyBankButton = t_Holder:FindFirstChild("_BuyBankButton");
		if not v78 and not _BuyBankButton then
			local Clone_ret2 = t_Bank2.Side.BuyAccount:Clone();
			Clone_ret2.LayoutOrder = 2;
			Clone_ret2.Name = "_BuyBankButton";
			Clone_ret2.Parent = t_Holder;
			m_Library.GUIFX.ButtonFX(Clone_ret2);
			Clone_ret2.Activated:Connect(function()  
				if not bool4 then
					bool4 = true;
					BuyBank();
					bool4 = false;
				end
			end);
		elseif v78 and _BuyBankButton then
			_BuyBankButton:Destroy();
		end
	end
	if bool2 then
		local v79 = #u2 > 0;
		if v79 then
			local v88 = 0;
			for _, val24 in ipairs(u2) do
				local t_BUID5 = val24.BUID;
				local u29 = t_Holder:FindFirstChild("INVITE-" .. t_BUID5);
				if not u29 then
					u29 = t_Bank2.Side.Invite:Clone();
					u29.Name = "INVITE-" .. t_BUID5;
					coroutine.wrap(function()  
						u29.Player.Text = "...";
						local v100 = m_Library.Functions.UserIdToUsername(val24.Sender);
						if u29:FindFirstChild("Player") then
							u29.Player.Text = "@" .. v100 or "???";
						end
					end)()
					u29.LayoutOrder = val24.Timestamp;
					u29.Parent = t_Holder;
					if v88 < val24.Timestamp then
						v88 = val24.Timestamp;
					end
					m_Library.GUIFX.ButtonFX(u29);
					u29.Activated:Connect(function()  
						if not bool4 then
							bool4 = true;
							DecideInvite(val24.BUID);
							bool4 = false;
						end
					end);
				end
				u29:SetAttribute("Tick", u10);
			end
			local v89 = t_Holder:FindFirstChild("RejectAll");
			if not v89 then
				v89 = t_Bank2.Side.Invite:Clone();
				v89.HoverImage = "rbxassetid://7045637564";
				v89.Image = "rbxassetid://7045637481";
				v89.PressedImage = "rbxassetid://6903534547";
				v89:FindFirstChild("Icon").Visible = false;
				v89:FindFirstChild("Player").Position = UDim2.new(0.25, 0, 0, 0);
				v89.Name = "RejectAll";
				v89.Player.Text = "Reject All";
				v89.LayoutOrder = v88 + 1;
				v89.Parent = t_Holder;
				m_Library.GUIFX.ButtonFX(v89);
				v89.Activated:Connect(function() 
					if not bool4 then
						bool4 = true;
						RejectAllInvites();
						bool4 = false;
					end
				end);
			end
			v89.Visible = v88 > 0;
		end
		local _NoInvites = t_Holder:FindFirstChild("_NoInvites");
		if not v79 and not _NoInvites then
			local Clone_ret = t_Bank2.Side.Desc:Clone();
			Clone_ret.Title.Text = "No invites pending.";
			Clone_ret.Name = "_NoInvites";
			Clone_ret.LayoutOrder = 101;
			Clone_ret.Parent = t_Holder;
		elseif v79 and _NoInvites then
			_NoInvites:Destroy();
		end
	end
	for _, child7 in ipairs(t_Holder:GetChildren()) do
		local Attribute2 = child7:GetAttribute("Tick");
		if not Attribute2 or Attribute2 == u10 then continue end
		child7:Destroy();
	end
	local _Banks = t_Holder:FindFirstChild("_Banks");
	t_Holder:FindFirstChild("_Invites").Title.Text = #u2 >= 1 and "Invites (" .. #u2 .. "/50)" or "Invites";
	_Banks.Title.Text = #u1 >= 1 and "Banks (" .. #u1 .. "/5)" or "Banks";
	SideScrolling();
end
function UpdateHistory() 
	local function TranslateHistory(p25) 
		local t_kind = p25.kind;
		local table6 = {
			[1] = "%s deposited %s pets & %s Diamonds.",
			[2] = "%s withdrew %s pets & %s Diamonds.",
			[3] = "%s was invited.",
			[4] = "%s was kicked.",
			[5] = "%s left!",
			[6] = "%s joined!",
			[7] = "Upgraded to Tier %s.",
			[8] = "Collected %s Diamonds.",
			[9] = "%s pet(s) were deleted for being duplicated."
		};
		local string_format_ret = nil;
		if t_kind == 1 or t_kind == 2 then
			string_format_ret = string.format(table6[t_kind], m_Library.Functions.UserIdToUsername(p25.sender), m_Library.Functions.Commas(p25.pets), m_Library.Functions.NumberShorten(p25.diamonds or 0));
		elseif t_kind == 3 or t_kind == 4 or t_kind == 5 or t_kind == 6 then
			string_format_ret = string.format(table6[t_kind], m_Library.Functions.UserIdToUsername(p25.target or p25.sender));
		elseif t_kind == 7 or t_kind == 8 then
			string_format_ret = string.format(table6[t_kind], m_Library.Functions.NumberShorten(p25.amount or p25.newLevel or 0));
		elseif t_kind == 9 then
			string_format_ret = string.format(table6[t_kind], m_Library.Functions.Commas(p25.pets or 0));
		end
		local v86 = workspace:GetServerTimeNow() - p25.ts;
		return string_format_ret, v86 <= 120 and "Just now" or m_Library.Functions.TimeString(v86) .. " ago";
	end
	local t_History = t_Settings.History;
	for _, child8 in ipairs(t_History.Logs:GetChildren()) do
		if child8.ClassName ~= "Frame" then continue end
		child8:Destroy();
	end
	local t_History2 = u3.History;
	for key9, val9 in ipairs(t_History2) do
		local Clone_ret5 = t_Bank2.History.HistoryLog:Clone();
		Clone_ret5.LayoutOrder = key9;
		Clone_ret5.desc.Text = "Loading...";
		Clone_ret5.date.Text = "";
		Clone_ret5.Name = "Log" .. key9;
		Clone_ret5.Parent = t_History.Logs;
		coroutine.wrap(function()  
			local v92, v93 = TranslateHistory(val9);
			if Clone_ret5 and Clone_ret5.Parent then
				Clone_ret5.desc.Text = v92;
				Clone_ret5.date.Text = v93;
			end
		end)()
	end
	if #t_History2 <= 0 then
		local Clone_ret4 = t_Bank2.History.HistoryLog:Clone();
		Clone_ret4.LayoutOrder = 1;
		Clone_ret4.desc.Text = "No recent history";
		Clone_ret4.Name = "Log1";
		Clone_ret4.Parent = t_History.Logs;
	end
end
function UpdateMembers() 
	local t_List = t_Settings.Members.Members.List;
	for _, child10 in ipairs(t_List:GetChildren()) do
		if child10.ClassName ~= "Frame" then continue end
		child10:Destroy();
	end
	local Clone_ret6 = t_Bank2.Settings.Owner:Clone();
	Clone_ret6.Username.Text = m_Library.LocalPlayer.Name;
	Clone_ret6.LayoutOrder = 1;
	Clone_ret6.Parent = t_List;
	local t_Players = u3.Players;
	for key11, val11 in ipairs(t_Players) do
		local Clone_ret9 = t_Bank2.Settings.Member:Clone();
		Clone_ret9.LayoutOrder = key11 + 1;
		local u25 = nil;
		coroutine.wrap(function() 
			u25 = m_Library.Functions.UserIdToUsername(val11);
			Clone_ret9:WaitForChild("Username").Text = "@" .. u25 or "???";
		end)()
		Clone_ret9.Parent = t_List;
		m_Library.GUIFX.ButtonFX(Clone_ret9.Kick);
		Clone_ret9.Kick.Activated:Connect(function() 
			if not bool4 then
				bool4 = true;
				KickMember(val11, "@" .. u25 or "[UNKNOWN PLAYER]");
				bool4 = false;
			end
		end);
	end
	local v26 = m_Library.Directory.Banks[u3.Tier].MaxPlayers - (#t_Players + 1);
	local math_max_ret = math.max(6 - (#t_Players + 1) - v26, 0);
	for index2 = 1, v26 do
		local Clone_ret8 = t_Bank2.Settings.MemberEmpty:Clone();
		Clone_ret8.LayoutOrder = index2 + 20;
		Clone_ret8.Parent = t_List;
	end
	for index3 = 1, math_max_ret do
		local Clone_ret7 = t_Bank2.Settings.MemberLocked:Clone();
		Clone_ret7.LayoutOrder = index3 + 100;
		Clone_ret7.Parent = t_List;
	end
end
function UpdateUpgrades()  
	local t_Upgrades = t_Settings.Upgrades;
	local v27 = m_Library.Directory.Banks[u3.Tier];
	local v28 = m_Library.Directory.Banks[u3.Tier + 1];
	local v29 = not v28;
	t_Upgrades.CostFrame.isMax.Visible = v29;
	t_Upgrades.CostFrame.Cost.Visible = not v29;
	t_Upgrades.CostFrame.Currency.Visible = not v29;
	t_Upgrades.Buttons.Visible = not v29;
	t_Upgrades.Info.Current.Tier.Text = "Tier " .. v27.Tier;
	t_Upgrades.Info.Current.Title.Text = v27.Title;
	if not v29 then
		t_Upgrades.Info.New.Tier.Text = "Tier " .. v28.Tier;
		t_Upgrades.Info.New.Title.Text = v28.Title;
		t_Upgrades.CostFrame.Cost.Text = m_Library.Functions.NumberShorten(v28.Cost, false);
		if v28.ProductId ~= 0 then
			t_Upgrades.Buttons.BuyRobux.Robux.Text = m_Library.Functions.Commas(m_Library.Functions.GetPrice(v28.ProductId, true));
			t_Upgrades.Buttons.BuyRobux.Visible = true;
		else
			t_Upgrades.Buttons.BuyRobux.Visible = false;
		end
	else
		t_Upgrades.Info.New.Tier.Text = "Max";
		t_Upgrades.Info.New.Title.Text = "You have the best bank!";
	end
	for _, child12 in ipairs(t_Upgrades.Stats:GetChildren()) do
		if child12.ClassName ~= "Frame" then continue end
		if child12.Name == "MaxDiamonds" then
			child12.Old.Amount.Text = m_Library.Functions.NumberShorten(v27.MaxDiamonds, false) .. " Cap";
			child12.New.Amount.Text = v29 and "Max" or m_Library.Functions.NumberShorten(v28.MaxDiamonds, false) .. " Cap";
			continue;
		end
		if child12.Name == "MaxPlayers" then
			child12.Old.Amount.Text = v27.MaxPlayers .. " Players";
			child12.New.Amount.Text = v29 and "Max" or v28.MaxPlayers .. " Players";
			continue;
		end
		if child12.Name ~= "PetSlots" then continue end
		child12.Old.Amount.Text = v27.PetSlots .. " Pets";
		child12.New.Amount.Text = v29 and "Max" or v28.PetSlots .. " Pets";
	end
end
function UpdateSettings() 
	if not bool3 then return end
	UpdateUpgrades();
	UpdateHistory();
	UpdateMembers();
	SwitchWindow("Settings");
end
function SelectPet(p12, p13) 
	for key13, val13 in ipairs(p12) do
		if val13 ~= p13 then continue end
		m_Library.Audio.Play("rbxassetid://7139317909", script, Random_new_ret:NextNumber(0.95, 1.05), 0.75);
		table.remove(p12, key13);
		return;
	end
	if #p12 < m_Library.Shared.BankMaxPetsPerTransaction then
		m_Library.Audio.Play("rbxassetid://7139317934", script, Random_new_ret:NextNumber(0.95, 1.05), 0.75);
		table.insert(p12, p13);
	end
end
function UpdateDeposit()  
	t_Bank.Container.Visible = not u5;
	t_Bank.Side.Visible = not u5;
	t_Bank.Deposit.Visible = u5;
	t_Bank.Deposit.Bottom.Diamonds.Add.Visible = m_Library.Variables.Console;
	t_Bank.Deposit.Bottom.Diamonds.Minus.Visible = m_Library.Variables.Console;
	t_Bank.Deposit.Bottom.Cancel.ButtonKeybind.Visible = m_Library.Variables.Console;
	t_Bank.Deposit.Bottom.Ok.ButtonKeybind.Visible = m_Library.Variables.Console;
	local v30 = m_Library.Save.Get();
	if not v30 then return end
	local t_Pets3 = t_Bank.Deposit.Pets;
	local t_Diamonds = t_Bank.Deposit.Bottom.Diamonds;
	if not u5 then
		table2 = {};
		u7 = 0;
		t_Diamonds.Display.Input.Text = "";
		for _, child22 in ipairs(t_Pets3:GetChildren()) do
			if child22.ClassName ~= "Frame" then continue end
			child22:Destroy();
		end
		return;
	end
	local t_Search2 = t_Bank.Deposit.Top.Search;
	local v80;
	if t_Search2.Query.Text == "" then
		v80 = false;
	else
		v80 = tostring(t_Search2.Query.Text) ~= nil;
	end
	local v31 = v80 and string.lower(tostring(t_Search2.Query.Text)) or nil;
	u11 = u11 + 1;
	local v32 = m_Library.Shared.SortPets(v30, table.clone(v30.Pets));
	for key14, val14 in ipairs(v32) do
		local t_uid2 = val14.uid;
		local v81 = m_Library.Directory.Pets[val14.id];
		local t_name2 = v81.name;
		local t_rarity2 = v81.rarity;
		local t_powers2 = val14.powers;
		local t_g2 = val14.g;
		local t_r2 = val14.r;
		local t_dm2 = val14.dm;
		local t_sh2 = val14.sh;
		local t_l2 = val14.l;
		local t_tradeable = v81.tradeable;
		local v82 = t_Pets3:FindFirstChild(t_uid2);
		local _ = m_Library.Functions.SearchArray(table2, t_uid2);
		if not t_tradeable then continue end
		if not v82 then
			v82 = m_Library.Assets.UI.Inventory.Pet:Clone();
			v82.Name = t_uid2;
			m_Library.PetUI.Create(v82, t_uid2);
			m_Library.GUIFX.ButtonFX(v82);
			v82.Activated:Connect(function()  
				local v96 = u3 and u3.Owner == (m_Library.LocalPlayer:GetAttribute("CustomUserId") or m_Library.LocalPlayer.UserId);
				if not bool4 then
					bool4 = true;
					local v98 = m_Library.Signal.Invoke("Is Trading Booth Pet", t_uid2);
					if val14.l and not v96 then
						m_Library.Message.New("You can only deposit locked pets into your own bank!");
					elseif v98 then
						m_Library.Message.New("This pet is currently in your trading booth! Remove it before you can deposit it!");
					else
						SelectPet(table2, t_uid2);
						UpdateDeposit();
					end
					bool4 = false;
				end
			end);
		end
		local v83 = u5 and m_Library.Functions.SearchArray(table2, t_uid2);
		v82.Equipped.Visible = v83;
		if v31 then
			local bool9 = false;
			if string.find(string.lower(t_name2), v31, 1, true) then
				bool9 = true;
			elseif string.find(string.lower(val14.nk), v31, 1, true) then
				bool9 = true;
			elseif string.find(string.lower(t_rarity2), v31, 1, true) then
				bool9 = true;
			elseif t_sh2 and string.find("shiny", v31, 1, true) then
				bool9 = true;
			elseif t_g2 and (string.find("gold", v31, 1, true) or string.find("golden", v31, 1, true)) then
				bool9 = true;
			elseif t_r2 and string.find("rainbow", v31, 1, true) then
				bool9 = true;
			elseif t_dm2 and string.find("dark matter", v31, 1, true) then
				bool9 = true;
			elseif t_l2 and string.find("lock", v31, 1, true) then
				bool9 = true;
			elseif t_powers2 and #t_powers2 > 0 then
				for _, val26 in ipairs(t_powers2) do
					local unpack_ret1_2, unpack_ret2_2 = unpack(val26);
					local v102, _ = m_Library.Shared.GetPowerDir(unpack_ret1_2, unpack_ret2_2);
					if not string.find(string.lower(v102.title), v31, 1, true) then continue end
					bool9 = true;
					break;
				end
			end
			v82.Visible = bool9 or v83;
		else
			v82.Visible = true;
		end
		v82.LayoutOrder = key14;
		v82:SetAttribute("Tick", u11);
		v82.Parent = t_Pets3;
	end
	for _, child15 in ipairs(t_Pets3:GetChildren()) do
		local Attribute3 = child15:GetAttribute("Tick");
		if not Attribute3 or Attribute3 == u11 then continue end
		child15:Destroy();
	end
	t_Bank.Deposit.Bottom.Ok.ImageColor3 = (#table2 >= 1 and true or u7 >= 1) and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
	t_Bank.Deposit.Bottom.Ok.Label.TextColor3 = t_Bank.Deposit.Bottom.Ok.ImageColor3;
	t_Diamonds.Display.Input.TextScaled = false;
	t_Diamonds.Display.Input.TextScaled = true;
	DepositScrolling();
end
function UpdateDepositDiamonds() 
	local t_Display = t_Bank.Deposit.Bottom.Diamonds.Display;
	local t_Input = t_Bank.Deposit.Bottom.Diamonds.Display.Input;
	local v33 = m_Library.Save.Get();
	if v33 and u5 and bool3 then
		local u26 = 0;
		pcall(function() 
			u26 = math.round((m_Library.Functions.ParseNumberSmart(t_Input.Text)));
		end);
		if u26 < 0 then
			u26 = 0;
		end
		if v33.Diamonds <= u26 then
			u26 = v33.Diamonds;
		end
		u7 = u26;
		t_Input.Text = m_Library.Functions.Commas(u26);
		m_Library.Audio.Play(4586418198, script, 1, 0.2);
		m_Library.GUIFX.FlashText(t_Input);
		t_Display.Input.TextScaled = false;
		t_Display.Input.TextScaled = true;
		UpdateDeposit();
	end
end
function UpdateWithdraw()  
	if not bool3 then return end
	local v34 = u3.Owner == (m_Library.LocalPlayer:GetAttribute("CustomUserId") or m_Library.LocalPlayer.UserId);
	local t_Bottom = t_Bank.Container.Bank.Bottom;
	t_Bottom.CancelWithdraw.Visible = u4;
	t_Bottom.CancelWithdraw.ButtonKeybind.Visible = u4 and m_Library.Variables.Console;
	t_Bottom.AcceptWithdraw.Visible = u4;
	t_Bottom.AcceptWithdraw.ButtonKeybind.Visible = u4 and m_Library.Variables.Console;
	t_Bottom.Deposit.Visible = not u4;
	t_Bottom.Deposit.ButtonKeybind.Visible = not u4 and m_Library.Variables.Console;
	t_Bottom.Withdraw.Visible = not u4;
	t_Bottom.Withdraw.ButtonKeybind.Visible = not u4 and m_Library.Variables.Console;
	t_Bottom.Settings.Visible = not u4 and v34;
	t_Bottom.Balance.Visible = not u4;
	t_Bottom.BalanceInput.Visible = u4;
	t_Bottom.WithdrawMsg.Visible = u4;
	t_Bottom.Leave.Visible = not u4 and not v34;
	t_Bottom.Leave.ButtonKeybind.Visible = not u4 and not v34 and m_Library.Variables.Console;
	t_Bottom.BalanceInput.Add.Visible = m_Library.Variables.Console;
	t_Bottom.BalanceInput.Minus.Visible = m_Library.Variables.Console;
	if not u4 then
		local t_BalanceInput = t_Bottom.BalanceInput;
		table1 = {};
		u6 = 0;
		t_BalanceInput.Display.Input.Text = "";
		UpdateBank();
		return;
	end
	local v35 = #table1;
	if v35 > 0 then
		if m_Library.Shared.BankMaxPetsPerTransaction <= v35 then
			t_Bottom.WithdrawMsg.Text = "Withdrawing " .. m_Library.Functions.Commas(v35) .. " Pet" .. (v35 > 1 and "s" or "" .. " (max)");
		else
			t_Bottom.WithdrawMsg.Text = "Withdrawing " .. m_Library.Functions.Commas(v35) .. " Pet" .. (v35 > 1 and "s" or "");
		end
	else
		t_Bottom.WithdrawMsg.Text = "Select Pets to Withdraw";
	end
	t_Bottom.AcceptWithdraw.ImageColor3 = (#table1 >= 1 and true or u6 >= 1) and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
	t_Bottom.AcceptWithdraw.Label.TextColor3 = t_Bottom.AcceptWithdraw.ImageColor3;
end
function UpdateWithdrawDiamonds()  
	local t_Input2 = t_Bank.Container.Bank.Bottom.BalanceInput.Display.Input;
	local v36 = m_Library.Save.Get();
	if v36 and u4 and bool3 then
		local u27 = 0;
		pcall(function()  
			u27 = math.round((m_Library.Functions.ParseNumberSmart(t_Input2.Text)));
		end);
		if u27 < 0 then
			u27 = 0;
		end
		if u3.Storage.Currency.Diamonds <= u27 then
			u27 = u3.Storage.Currency.Diamonds;
		end
		u6 = u27;
		t_Input2.Text = m_Library.Functions.Commas(u27);
		m_Library.Audio.Play(4586418198, script, 1, 0.2);
		m_Library.GUIFX.FlashText(t_Input2);
		UpdateWithdraw();
	end
end
function BankScrolling()  
	local t_Pets4 = t_Bank.Container.Bank.Pets;
	local UIGridLayout = t_Pets4:FindFirstChildOfClass("UIGridLayout");
	local UIPadding = t_Pets4:FindFirstChildOfClass("UIPadding");
	local v37 = m_Library.Functions.ResolutionScale();
	local v38 = v37 <= 0.5 and 3 or v37 <= 1 and 4 or v37 <= 1.3 and 5 or 6;
	if u9 then
		UIGridLayout.CellPadding = UDim2.new(0, 10, 0, 10);
	else
		UIGridLayout.CellPadding = UDim2.new(0, 20, 0, 20);
	end
	if u9 then
		v38 = v38 * 2;
	end
	local v39 = (t_Pets4.AbsoluteSize.X - t_Pets4.ScrollBarThickness - UIPadding.PaddingLeft.Offset - UIPadding.PaddingRight.Offset) / v38 - UIGridLayout.CellPadding.X.Offset;
	local udim2 = UDim2.new(0, v39, 0, v39);
	UIGridLayout.CellSize = udim2;
	UIGridLayout:ApplyLayout();
	t_Pets4.CanvasSize = UDim2.new(1, 0, 0, UIGridLayout.AbsoluteContentSize.Y + (u9 and 55 or 65));
end
function DepositScrolling()  
	local t_Pets5 = t_Bank.Deposit.Pets;
	local UIGridLayout2 = t_Pets5:FindFirstChildOfClass("UIGridLayout");
	local UIPadding2 = t_Pets5:FindFirstChildOfClass("UIPadding");
	local v40 = m_Library.Functions.ResolutionScale();
	local v41 = (t_Pets5.AbsoluteSize.X - t_Pets5.ScrollBarThickness - UIPadding2.PaddingLeft.Offset - UIPadding2.PaddingRight.Offset) / (v40 <= 0.5 and 4 or v40 <= 0.7 and 5 or v40 <= 1 and 6 or v40 <= 1.2 and 7 or 8) - UIGridLayout2.CellPadding.X.Offset;
	local udim2_2 = UDim2.new(0, v41, 0, v41);
	UIGridLayout2.CellSize = udim2_2;
	UIGridLayout2:ApplyLayout();
	t_Pets5.CanvasSize = UDim2.new(0, UIGridLayout2.AbsoluteContentSize.X, 0, UIGridLayout2.AbsoluteContentSize.Y + 30);
end
function SideScrolling() 
	local t_Holder2 = t_Bank.Side.Holder;
	local UIListLayout = t_Holder2:FindFirstChildOfClass("UIListLayout");
	local UIPadding3 = t_Holder2:FindFirstChildOfClass("UIPadding");
	UIListLayout:ApplyLayout();
	t_Holder2.CanvasSize = UDim2.new(0, UIListLayout.AbsoluteContentSize.X, 0, UIListLayout.AbsoluteContentSize.Y + UIPadding3.PaddingBottom.Offset + UIPadding3.PaddingTop.Offset);
end
function GetBank(p14)  
	local v42, v43 = m_Library.Network.Invoke("Get Bank", p14);
	if v42 then
		bool3 = true;
		u3 = v42;
		return;
	end
	bool3 = false;
	m_Library.Print("Failed to grab bank (" .. tostring(v43) .. ")", true);
	return v43;
end
function GetMyBanks()  
	local v44, v45 = m_Library.Network.Invoke("Get My Banks");
	if v44 then
		bool1 = true;
		u1 = v44;
		return;
	end
	bool1 = false;
	m_Library.Print("Failed to load banks (" .. tostring(v45) .. ")", true);
end
function GetMyInvites()  
	local v46, v47 = m_Library.Network.Invoke("Get Bank Invites");
	if v46 then
		bool2 = true;
		u2 = v46;
		return;
	end
	bool2 = false;
	m_Library.Print("Failed to get bank invites (" .. tostring(v47) .. ")", true);
end
function Processing(p15, p16)
	u8 = p15;
	m_Library.Variables.UsingMachine = u8;
	if u8 and not u12 then
		u12 = m_Library.GIF.Create(t_Bank.Processing.GIF, {100,100}, {5,6}, 28, 0.65, true);
		u14 = m_Library.GIF.Create(t_BankLoading.Loading.GIF, {100,100}, {5,6}, 28, 0.65, true);
		if p16 then
			u13 = m_Library.Audio.Play("rbxassetid://8167470315", script, 1, 1, nil, nil, true);
		end
	elseif not u8 and u12 then
		u12();
		u14();
		u12 = nil;
		u14 = nil;
		if u13 then
			u13:Stop();
			u13 = nil;
		end
	end
	t_BankLoading.Gui.Enabled = u8;
	t_Bank.Processing.Visible = u8;
end
function SwitchWindow(p17)  
	if p17 == "Settings" then
		SwitchSettingsWindow("Info");
	end
	for _, child16 in ipairs(t_Bank.Container:GetChildren()) do
		if child16.ClassName ~= "Frame" then continue end
		child16.Visible = child16.Name == p17;
	end
	if p17 ~= "Empty" and bool3 then
		t_Bank.BankTitle.Tier.Text = "Tier " .. u3.Tier .. " Bank";
		coroutine.wrap(function() 
			t_Bank.BankTitle.Owner.Text = "@" .. m_Library.Functions.UserIdToUsername(u3.Owner) or "???";
		end)()
		t_Bank.BankTitle.Visible = true;
		t_Bank.Title.Visible = false;
		return;
	end
	t_Bank.BankTitle.Visible = false;
	t_Bank.Title.Visible = true;
end
function SwitchSettingsWindow(p18)  
	for _, child17 in ipairs(t_Settings:GetChildren()) do
		if child17.ClassName ~= "Frame" and child17.ClassName ~= "ScrollingFrame" then continue end
		child17.Visible = p18 == child17.Name;
	end
end
function Reset() 
	u4 = false;
	u5 = false;
	u6 = 0;
	table1 = {};
	u7 = 0;
	table2 = {};
	u3 = nil;
	bool3 = false;
	u9 = false;
	t_Bank.Deposit.Visible = false;
	SwitchWindow("Empty");
	UpdateBank();
	UpdateDeposit();
	UpdateWithdraw();
end
local t_Top2 = t_Bank.Container.Bank.Top;
local t_Bottom2 = t_Bank.Container.Bank.Bottom;
m_Library.GUIFX.ButtonFX(t_Top2.Grid);
t_Top2.Grid.Activated:Connect(function()  
	if not bool4 then
		bool4 = true;
		u9 = not u9;
		m_Library.Audio.Play("rbxassetid://7004248320", script, 1, 0.5);
		UpdateBank();
		bool4 = false;
	end
end);
m_Library.GUIFX.Tooltip(t_Bottom2.Deposit, "Deposit");
m_Library.GUIFX.ButtonFX(t_Bottom2.Deposit);
function openDeposit()  
	if not bool4 then
		bool4 = true;
		u5 = not u5;
		UpdateDeposit();
		bool4 = false;
	end
end
t_Bottom2.Deposit.Activated:Connect(openDeposit);
m_Library.GUIFX.Tooltip(t_Bottom2.Withdraw, "Withdraw");
m_Library.GUIFX.ButtonFX(t_Bottom2.Withdraw);
function openWithdraw()  
	if not bool4 then
		bool4 = true;
		u4 = not u4;
		UpdateWithdraw();
		bool4 = false;
	end
end
t_Bottom2.Withdraw.Activated:Connect(openWithdraw);
m_Library.GUIFX.ButtonFX(t_Bottom2.Settings);
m_Library.GUIFX.Tooltip(t_Bottom2.Settings, "Settings");
function openSettings() 
	if not bool4 then
		bool4 = true;
		UpdateSettings();
		bool4 = false;
	end
end
t_Bottom2.Settings.Activated:Connect(openSettings);
m_Library.GUIFX.ButtonFX(t_Bottom2.Leave);
function pressedLeave()  
	if not bool4 then
		bool4 = true;
		LeaveBank();
		bool4 = false;
	end
end
t_Bottom2.Leave.Activated:Connect(pressedLeave);
m_Library.GUIFX.ButtonFX(t_Bottom2.AcceptWithdraw);
function acceptWithdraw() 
	if not bool4 then
		bool4 = true;
		Withdraw();
		bool4 = false;
	end
end
t_Bottom2.AcceptWithdraw.Activated:Connect(acceptWithdraw);
m_Library.GUIFX.ButtonFX(t_Bottom2.CancelWithdraw);
function cancelWithdraw()  
	if not bool4 then
		bool4 = true;
		u4 = false;
		UpdateWithdraw();
		bool4 = false;
	end
end
t_Bottom2.CancelWithdraw.Activated:Connect(cancelWithdraw);
t_Bottom2.BalanceInput.Display.Input.FocusLost:Connect(function() 
	if u4 then
		UpdateWithdrawDiamonds();
	end
end);
t_Top2.Search.Query:GetPropertyChangedSignal("Text"):Connect(function() 
	if bool3 then
		if t_Top2.Search.Query.Text ~= "" then
			t_Bank.Container.Bank.Pets.CanvasPosition = Vector2.new();
		end
		UpdateBank();
	end
end);
m_Library.GUIFX.ContentScale(t_Settings.Info);
m_Library.GUIFX.ContentScale(t_Settings.Upgrades);
m_Library.GUIFX.ContentScale(t_Settings.Members);
m_Library.GUIFX.ContentScale(t_Settings.History);
for _, child1 in ipairs(t_Settings.Info:GetChildren()) do
	local Button = child1:FindFirstChild("Button");
	if child1.ClassName ~= "Frame" or not Button then continue end
	m_Library.GUIFX.ButtonFX(Button);
	Button.Activated:Connect(function()  
		if not bool4 then
			bool4 = true;
			if child1.Name == "Interest" then
				CollectInterest();
			else
				SwitchSettingsWindow(child1.Name);
			end
			bool4 = false;
		end
	end);
end
m_Library.GUIFX.ButtonFX(t_Settings.Back);
t_Settings.Back.Activated:Connect(function() 
	if not bool4 then
		bool4 = true;
		if not t_Settings.Info.Visible then
			SwitchSettingsWindow("Info");
		else
			SwitchWindow("Bank");
		end
		bool4 = false;
	end
end);
local t_Upgrades2 = t_Settings.Upgrades;
m_Library.GUIFX.ButtonFX(t_Upgrades2.Buttons.Buy);
t_Upgrades2.Buttons.Buy.Activated:Connect(function() 
	if not bool4 then
		bool4 = true;
		UpgradeBank(false);
		bool4 = false;
	end
end);
m_Library.GUIFX.ButtonFX(t_Upgrades2.Buttons.BuyRobux);
t_Upgrades2.Buttons.BuyRobux.Activated:Connect(function()  
	if not bool4 then
		bool4 = true;
		UpgradeBank(true);
		bool4 = false;
	end
end);
local t_Members = t_Settings.Members;
m_Library.GUIFX.ButtonFX(t_Members.Members.Search.Invite);
t_Members.Members.Search.Invite.Activated:Connect(function() 
	if not bool4 then
		bool4 = true;
		local t_Query = t_Members.Members.Search.InputField.Query;
		local t_Text = t_Query.Text;
		t_Query.Text = "(...)";
		InviteToBank(t_Text);
		t_Query.Text = "";
		bool4 = false;
	end
end);
m_Library.GUIFX.ButtonFX(t_Members.CancelInvites.Button);
t_Members.CancelInvites.Button.Activated:Connect(function()  
	if not bool4 then
		bool4 = true;
		CancelOutgoingInvites();
		bool4 = false;
	end
end);
local t_Bottom3 = t_Bank.Deposit.Bottom;
t_Bottom3.Diamonds.Display.Input.FocusLost:Connect(function() 
	if u5 then
		UpdateDepositDiamonds();
	end
end);
m_Library.GUIFX.ButtonFX(t_Bottom3.Cancel);
function promptWithdraw() 
	if not bool4 then
		bool4 = true;
		local v84 = true;
		if #table1 >= 1 or u6 > 0 then
			v84 = m_Library.Message.New("Are you sure?", true);
		end
		if v84 then
			u5 = false;
			UpdateDeposit();
		end
		bool4 = false;
	end
end
t_Bottom3.Cancel.Activated:Connect(promptWithdraw);
m_Library.GUIFX.ButtonFX(t_Bottom3.Ok);
function acceptDeposit() 
	if not bool4 then
		bool4 = true;
		Deposit();
		bool4 = false;
	end
end
t_Bottom3.Ok.Activated:Connect(acceptDeposit);
t_Bank.Deposit.Top.Search.Query:GetPropertyChangedSignal("Text"):Connect(function()  
	if bool3 then
		if t_Bank.Deposit.Top.Search.Query.Text ~= "" then
			t_Bank.Deposit.Pets.CanvasPosition = Vector2.new();
		end
		UpdateDeposit();
	end
end);
m_Library.GUIFX.ButtonFX(t_Bank.Close);
t_Bank.Close.Activated:Connect(function() 
	if not bool4 then
		t_Bank.Gui.Enabled = false;
	end
end);
m_Library.GUIFX.ButtonFX(t_Bank.Container.Banned.LeaveBank);
t_Bank.Container.Banned.LeaveBank.Activated:Connect(function()  
	if not bool4 then
		bool4 = true;
		LeaveBank(u17);
		bool4 = false;
	end
end);
local bool10 = false;
local bool11 = false;
local u21 = 0;
m_Library.Signal.Fired("Xbox Start Subtract"):Connect(function() 
	if not m_Library.Variables.Console then return end
	bool10 = true;
	u21 = 0;
end);
m_Library.Signal.Fired("Xbox Stop Subtract"):Connect(function()  
	if not m_Library.Variables.Console then return end
	bool10 = false;
	u21 = 0;
end);
m_Library.Signal.Fired("Xbox Start Add"):Connect(function()  
	if not m_Library.Variables.Console then return end
	bool11 = true;
	u21 = 0;
end);
m_Library.Signal.Fired("Xbox Stop Add"):Connect(function()  
	if not m_Library.Variables.Console then return end
	bool11 = false;
	u21 = 0;
end);
m_Library.RunService.Heartbeat:Connect(function(p19) 
	if not m_Library.Variables.Console then return end
	if m_Library.GUI.Bank.Gui.Enabled and (bool10 or bool11) then
		u21 = u21 + p19;
		local math_pow_ret = math.pow(10, (math.floor(u21 / 4)));
		local v85 = 1;
		if bool10 then
			v85 = v85 - math_pow_ret * 1;
			if v85 < 10 then
				v85 = 0;
			end
		elseif bool11 then
			v85 = v85 + math_pow_ret * 1;
			if v85 < 10 then
				v85 = 10;
			end
		end
		print("Bank Hold RB/LB", v85);
		if (bool11 or bool10) and (v85 > 0 or v85 == 0) then
			local v90 = m_Library.Save.Get();
			if not v90 or not bool3 then return end
			if u5 then
				local t_Display2 = t_Bank.Deposit.Bottom.Diamonds.Display;
				local t_Input4 = t_Bank.Deposit.Bottom.Diamonds.Display.Input;
				local v94 = bool11 and u7 + v85 or u7 - v85;
				if v94 < 0 then
					v94 = 0;
				end
				if v90.Diamonds <= v94 then
					v94 = v90.Diamonds;
				end
				u7 = v94;
				t_Input4.Text = m_Library.Functions.Commas(v94);
				m_Library.GUIFX.FlashText(t_Input4);
				t_Display2.Input.TextScaled = false;
				t_Display2.Input.TextScaled = true;
				UpdateDeposit();
				return;
			end
			if u4 then
				local t_Input3 = t_Bank.Container.Bank.Bottom.BalanceInput.Display.Input;
				local v95 = m_Library.Save.Get();
				if v95 and u4 and bool3 then
					local u30 = 0;
					pcall(function() 
						u30 = math.round((m_Library.Functions.ParseNumberSmart(t_Input3.Text)));
					end);
					u30 = bool11 and u6 + v85 or u6 - v85;
					if u30 < 0 then
						u30 = 0;
					end
					if u3.Storage.Currency.Diamonds <= u30 then
						u30 = u3.Storage.Currency.Diamonds;
					end
					u6 = u30;
					t_Input3.Text = m_Library.Functions.Commas(u30);
					m_Library.GUIFX.FlashText(t_Input3);
					UpdateWithdraw();
				end
			end
		end
	end
end);
local table7 = {
	{
		Name = "Accept Deposit",
		Requirement = function() 
			return t_Bank.Gui.Frame.Deposit.Bottom.Ok.Visible and u5 and (#table2 >= 1 and true or u7 >= 1);
		end,
		Keycode = Enum.KeyCode.ButtonX,
		Action = acceptDeposit
	},
	{
		Name = "Accept Withdraw",
		Requirement = function()  
			return t_Bank.Gui.Frame.Container.Bank.Bottom.AcceptWithdraw.Visible and u4 and (#table1 >= 1 and true or u6 >= 1);
		end,
		Keycode = Enum.KeyCode.ButtonX,
		Action = acceptWithdraw
	},
	{
		Name = "Open Deposit",
		Requirement = function() 
			return t_Bank.Gui.Frame.Container.Bank.Bottom.Deposit.Visible and not u4;
		end,
		Keycode = Enum.KeyCode.ButtonX,
		Action = openDeposit
	},
	{
		Name = "Open Withdraw",
		Requirement = function()  
			return t_Bank.Gui.Frame.Container.Bank.Bottom.Withdraw.Visible and not u5 and not u4;
		end,
		Keycode = Enum.KeyCode.ButtonY,
		Action = openWithdraw
	},
	{
		Name = "Cancel Withdraw",
		Requirement = function() 
			return t_Bank.Gui.Frame.Container.Bank.Bottom.CancelWithdraw.Visible and not u5 and u4;
		end,
		Keycode = Enum.KeyCode.ButtonY,
		Action = function() 
			u4 = false;
			UpdateWithdraw();
		end
	},
	{
		Name = "Cancel Deposit",
		Requirement = function()  
			return t_Bank.Gui.Frame.Deposit.Bottom.Cancel.Visible and not u4 and u5;
		end,
		Keycode = Enum.KeyCode.ButtonY,
		Action = function() 
			u5 = false;
			UpdateDeposit();
		end
	}
};
m_Library.UserInputService.InputEnded:Connect(function(input4, gameProcessedEvent4)  
	if gameProcessedEvent4 or not m_Library.Variables.Console then return end
	if not m_Library.GUI.Bank.Gui.Enabled then
		return false;
	end
	for _, val18 in ipairs(table7) do
		if not val18.Requirement() or val18.Keycode ~= input4.KeyCode then continue end
		print("Calling", val18.Name, "=", val18.Requirement, "withdrawing=", u4, "depositing=", u5);
		val18.Action();
		return;
	end
end);
m_Library.Signal.Fired("Resolution Changed"):Connect(function()  
	task.defer(function()  
		BankScrolling();
		SideScrolling();
		DepositScrolling();
	end);
end);
m_Library.Signal.Fired("Stat Changed"):Connect(function(p20)  
	if p20 == "Pets" and bool3 then
		UpdateDeposit();
		UpdateBank();
	end
end);
m_Library.Signal.Fired("Window Opened"):Connect(function(p21) 
	if p21 == t_Bank.Gui and not bool3 then
		m_Library.Signal.Fire("Hide HUD Keybinds");
		m_Library.Variables.BankOpen = true;
		GetMyBanks();
		GetMyInvites();
		UpdateSide();
		UpdateBank();
		UpdateDeposit();
		UpdateWithdraw();
		if m_Library.Variables.Console then
			m_Library.GuiService.SelectedObject = t_Bank.Gui.Frame.Side.Holder;
		end
		m_Library.Audio.Play("rbxassetid://8167469855", script, 1, 0.4);
	end
end);
m_Library.Signal.Fired("Window Closed"):Connect(function(p22)  
	if u8 or bool4 then return end
	if p22 == t_Bank.Gui then
		m_Library.Signal.Fire("Show HUD Keybinds");
		m_Library.Variables.BankOpen = false;
		Reset();
	end
end);
m_Library.Signal.Fired("Lock Status Changed"):Connect(function(p23) 
	local t_Pets6 = t_Bank.Deposit.Pets;
	for key19, _ in pairs(p23) do
		local FindFirstChild_ret2 = t_Pets6:FindFirstChild(key19);
		if not FindFirstChild_ret2 then continue end
		FindFirstChild_ret2:Destroy();
	end
end);
coroutine.wrap(function()
	while true do
		task.wait(10);
		if t_Bank.Gui.Enabled then
			GetMyInvites();
			UpdateSide();
		end
	end
end)()
coroutine.wrap(function() 
	while true do
		task.wait(5);
		if bool3 and t_Bank.Container.Visible and t_Bank.Container.Bank.Visible and not bool5 then
			bool5 = true;
			GetBank(u3.BUID);
			UpdateBank();
			bool5 = false;
		end
	end
end)()
local function CheckForWorldShop()  
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		local Bank2 = Map.Interactive:FindFirstChild("Bank");
		if Bank2 and Bank2.PrimaryPart then
			local v91 = m_Library.Audio.Play("rbxassetid://8168486040", Bank2.PrimaryPart, 1, 0.15, nil, nil, true);
			if v91 then
				v91.RollOffMaxDistance = 90;
				v91.RollOffMinDistance = 35;
			end
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function()  
	CheckForWorldShop();
end);