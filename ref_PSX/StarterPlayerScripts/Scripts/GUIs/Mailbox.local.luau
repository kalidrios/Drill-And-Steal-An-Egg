-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_Mailbox = m_Library.GUI.Mailbox;
t_Mailbox.Gui.Frame.MainMenu.Visible = true;
t_Mailbox.Gui.Frame.GiftPet.Visible = false;
t_Mailbox.Gui.Frame.GiftInventory.Visible = false;
local bool1 = false;
local t_Inventory = m_Library.Assets.UI.Inventory;
local Random_new_ret = Random.new();
local _ = require(game.ReplicatedStorage.Library.Modules.Pets);
local bool2 = false;
local u1 = false;
local u2 = "Default";
local u3 = 0;
local u4 = "";
local u5 = "";
local u6 = nil;
local u7 = false;
local table1 = {};
local table2 = {};
local table3 = {};
local u8 = nil;
local Mailbox = nil;
local bool3 = false;
local bool4 = false;
local bool5 = false;
function ToggleButton(p1, p2) -- Line: 98
	if p2 then
		p1.Image = "rbxassetid://7045637286";
		p1.HoverImage = "rbxassetid://7045637411";
		p1.PressedImage = "rbxassetid://6903534547";
		return;
	end
	p1.HoverImage = "rbxassetid://7045637564";
	p1.Image = "rbxassetid://7045637481";
	p1.PressedImage = "rbxassetid://6903534547";
end
function ComposeMail() -- Line: 111
	--[[
		Upvalues:
			[1] = u4
			[2] = u5
			[3] = u6
			[4] = u3
	--]]
	local table4 = {
		Recipient = u4,
		Message = u5,
		Pets = {u6},
		Diamonds = u3
	};
	return table4;
end
function CanSend() -- Line: 121
	--[[
		Upvalues:
			[1] = u4
			[2] = u3
			[3] = u6
	--]]
	local v1;
	if u4 == "" then
		v1 = false;
	else
		v1 = u3 == 0 and u6 ~= nil or true;
	end
	return v1;
end
function Update() -- Line: 126
	--[[
		Upvalues:
			[1] = u8
			[2] = m_Library
			[3] = bool3
			[4] = t_Mailbox
			[5] = bool2
	--]]
	if not u8 then
		u8 = m_Library.Network.Invoke("Get Mail");
	end
	local v2 = u8 and #u8.Inbox > 0;
	if v2 then
		UpdateWorldMailbox();
	end
	if not bool3 then
		local t_Button = t_Mailbox.Gui.Frame.MainMenu.Categories.Receive.Frame.Button;
		m_Library.GUIFX.ButtonFX(t_Button);
		t_Button.Activated:Connect(function() -- Line: 138
			--[[
				Upvalues:
					[1] = bool2
					[2] = t_Mailbox
					[3] = m_Library
			--]]
			if not bool2 then
				bool2 = true;
				t_Mailbox.Gui.Frame.MainMenu.Visible = false;
				m_Library.Audio.Play("rbxassetid://11839132640", script, 1, 1);
				InboxMode("Default");
				t_Mailbox.Gui.Frame.GiftInventory.Main.History.Visible = false;
				t_Mailbox.Gui.Frame.GiftInventory.Main.Gifts.Visible = true;
				UpdateInbox();
				t_Mailbox.Gui.Frame.GiftInventory.Visible = true;
				bool2 = false;
			end
		end);
		local t_Button2 = t_Mailbox.Gui.Frame.MainMenu.Categories.Send.Frame.Button;
		m_Library.GUIFX.ButtonFX(t_Button2);
		t_Button2.Activated:Connect(function() -- Line: 156
			--[[
				Upvalues:
					[1] = bool2
					[2] = t_Mailbox
					[3] = m_Library
			--]]
			if not bool2 then
				bool2 = true;
				t_Mailbox.Gui.Frame.MainMenu.Visible = false;
				m_Library.Audio.Play("rbxassetid://11839132336", script, 1, 1);
				UpdateOutboxLazy();
				t_Mailbox.Gui.Frame.GiftPet.Visible = true;
				bool2 = false;
			end
		end);
		bool3 = true;
	end
	local t_Notification = t_Mailbox.Gui.Frame.MainMenu.Categories.Receive.Frame.Button.Notification;
	local t_PetReady = t_Mailbox.Gui.Frame.MainMenu.Categories.Receive.Frame.PetReady;
	t_Notification.Count.Text = v2 and #u8.Inbox or 0;
	t_Notification.Visible = v2;
	t_PetReady.Visible = v2;
end
function Select(p3) -- Line: 180
	--[[
		Upvalues:
			[1] = m_Library
			[2] = Random_new_ret
			[3] = u6
			[4] = u7
	--]]
	local v3 = m_Library.PetCmds.Get(p3);
	if not p3 then return end
	local v4 = m_Library.Signal.Invoke("Is Trading Booth Pet", p3);
	if v4 then
		m_Library.Message.New("This pet is currently in your trading booth! Remove it before you can enchant it!");
		return;
	end
	m_Library.Audio.Play("rbxassetid://7139317934", script, Random_new_ret:NextNumber(0.95, 1.05), 0.75);
	u6 = p3;
	u7 = v3.hc or false;
	UpdatePets();
	UpdateSendButtons();
end
function Deselect(_) -- Line: 203
	--[[
		Upvalues:
			[1] = u6
			[2] = u7
	--]]
	u6 = nil;
	u7 = false;
	UpdatePets();
	UpdateSendButtons();
end
function UpdateDiamondsAmount() -- Line: 213
	--[[
		Upvalues:
			[1] = t_Mailbox
			[2] = m_Library
			[3] = u3
	--]]
	local t_Input = t_Mailbox.Gui.Frame.GiftPet.Container.Inventory.Bottom.BalanceInput.Display.Input;
	local v5 = m_Library.Save.Get();
	if v5 then
		local u10 = 0;
		pcall(function() -- Line: 219
			--[[
				Upvalues:
					[1] = u10
					[2] = m_Library
					[3] = t_Input
			--]]
			u10 = math.round((m_Library.Functions.ParseNumberSmart(t_Input.Text)));
		end);
		if u10 < 0 then
			u10 = 0;
		end
		if v5.Diamonds <= u10 then
			u10 = v5.Diamonds;
		end
		u3 = u10;
		t_Input.Text = m_Library.Functions.Commas(u10);
		m_Library.Audio.Play(4586418198, script, 1, 0.2);
		m_Library.GUIFX.FlashText(t_Input);
		UpdateSendButtons();
		t_Mailbox.Gui.Frame.GiftPet.Container.Inventory.Bottom.BalanceInput.Display.Input:SetAttribute("Amount", u10);
	end
end
function UpdateSendButtons() -- Line: 242
	--[[
		Upvalues:
			[1] = t_Mailbox
	--]]
	local t_SendDiamonds = t_Mailbox.Gui.Frame.GiftPet.Side.BottomInputFrame.SendDiamonds;
	t_SendDiamonds.ImageColor3 = CanSend() and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
end
function UpdateTargetPlayer() -- Line: 250
	--[[
		Upvalues:
			[1] = t_Mailbox
			[2] = u4
	--]]
	local t_Input2 = t_Mailbox.Gui.Frame.GiftPet.Side.UsernameInputFrame.Input;
	u4 = t_Input2.Text and t_Input2.Text or "";
	UpdateSendButtons();
end
function UpdateMessage() -- Line: 256
	--[[
		Upvalues:
			[1] = t_Mailbox
			[2] = m_Library
			[3] = u5
	--]]
	local t_Input3 = t_Mailbox.Gui.Frame.GiftPet.Side.MessageInputFrame.Input;
	local v6 = t_Input3.Text and t_Input3.Text or "";
	if not m_Library.Functions.IsASCII(v6) then
		m_Library.Message.New("That message isn't valid!");
		return;
	end
	u5 = v6;
	UpdateSendButtons();
end
function PetScrolling() -- Line: 269
	--[[
		Upvalues:
			[1] = t_Mailbox
			[2] = m_Library
			[3] = u1
	--]]
	local t_Pets = t_Mailbox.Gui.Frame.GiftPet.Container.Inventory.Pets;
	local UIGridLayout = t_Pets:FindFirstChildOfClass("UIGridLayout");
	local UIPadding = t_Pets:FindFirstChildOfClass("UIPadding");
	local v7 = m_Library.Functions.ResolutionScale();
	local v8 = v7 <= 0.5 and 3 or v7 <= 1 and 4 or v7 <= 1.3 and 5 or 6;
	if u1 then
		UIGridLayout.CellPadding = UDim2.new(0, 10, 0, 10);
	else
		UIGridLayout.CellPadding = UDim2.new(0, 20, 0, 20);
	end
	if u1 then
		v8 = v8 * 2;
	end
	local v9 = (t_Pets.AbsoluteSize.X - t_Pets.ScrollBarThickness - UIPadding.PaddingLeft.Offset - UIPadding.PaddingRight.Offset) / v8 - UIGridLayout.CellPadding.X.Offset;
	local udim2 = UDim2.new(0, v9, 0, v9);
	UIGridLayout.CellSize = udim2;
	UIGridLayout:ApplyLayout();
	t_Pets.CanvasSize = UDim2.new(1, 0, 0, UIGridLayout.AbsoluteContentSize.Y + (u1 and 55 or 65));
end
function UpdatePets() -- Line: 308
	--[[
		Upvalues:
			[1] = t_Mailbox
			[2] = m_Library
			[3] = u6
	--]]
	for _, child1 in ipairs(t_Mailbox.Gui.Frame.GiftPet.Container.Inventory.Pets:GetChildren()) do
		if child1.ClassName ~= "TextButton" then continue end
		if not m_Library.PetCmds.Get(child1.Name) then
			child1:Destroy();
			return;
		end
		local v20 = child1.Name == u6;
		child1.Equipped.Visible = v20;
		child1.BackgroundColor3 = v20 and Color3.fromRGB(69, 239, 69) or Color3.fromRGB(39, 233, 55);
		local Attribute = child1:GetAttribute("Locked");
		if Attribute then continue end
		child1.BackgroundColor3 = v20 and Color3.fromRGB(69, 239, 69) or Color3.fromRGB(39, 233, 55);
		child1.PetIcon.ImageTransparency = 0;
	end
	PetScrolling();
end
function UpdateOutboxLazy(p4) -- Line: 337
	--[[
		Upvalues:
			[1] = bool1
	--]]
	bool1 = true;
	if p4 then
		clearOutboxFields = true;
	end
end
function isVisible() -- Line: 344
	--[[
		Upvalues:
			[1] = t_Mailbox
	--]]
	return t_Mailbox.Gui.Enabled;
end
function UpdateOutbox() -- Line: 348
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_Mailbox
			[3] = m_Library
			[4] = u3
			[5] = u4
			[6] = u5
			[7] = u6
			[8] = bool2
			[9] = Random_new_ret
			[10] = u1
			[11] = bool5
	--]]
	if not bool1 then return end
	if not isVisible() then return end
	local t_GiftPet = t_Mailbox.Gui.Frame.GiftPet;
	local t_Texts = t_GiftPet.Container.Texts;
	local t_Bottom = t_GiftPet.Container.Inventory.Bottom;
	local t_Top = t_GiftPet.Container.Inventory.Top;
	local t_Input4 = t_GiftPet.Side.MessageInputFrame.Input;
	local t_Input5 = t_GiftPet.Side.UsernameInputFrame.Input;
	local t_BalanceInput = t_GiftPet.Container.Inventory.Bottom.BalanceInput;
	local _ = t_BalanceInput.Display.Input;
	local t_Pets2 = t_GiftPet.Container.Inventory.Pets;
	local v10 = m_Library.Save.Get(m_Library.LocalPlayer);
	if not v10 then return end
	assert(v10);
	bool1 = false;
	if clearOutboxFields then
		clearOutboxFields = false;
		t_Input5.Text = "";
		t_Input4.Text = "";
		u3 = 0;
		u4 = "";
		u5 = "";
		if u6 then
			Deselect(u6);
		end
	end
	t_BalanceInput.Add.Visible = m_Library.Variables.Console;
	t_BalanceInput.Minus.Visible = m_Library.Variables.Console;
	local t_Pets3 = v10.Pets;
	local table5 = {};
	if not m_Library.LocalPlayer:GetAttribute("CustomUserId") then
		local _ = m_Library.LocalPlayer.UserId;
	end
	local t_Search = t_Top.Search;
	local v21;
	if t_Search.Query.Text == "" then
		v21 = false;
	else
		v21 = tostring(t_Search.Query.Text) ~= nil;
	end
	local v11 = v21 and string.lower(tostring(t_Search.Query.Text)) or nil;
	local v12 = 0;
	local table_clone_ret = table.clone(t_Pets3);
	local v13 = m_Library.Shared.SortPets(v10, table_clone_ret);
	for key2, val2 in pairs(v13) do
		local t_uid = val2.uid;
		local v22 = m_Library.Directory.Pets[val2.id];
		local t_name = v22.name;
		local t_rarity = v22.rarity;
		local t_powers = val2.powers;
		local t_g = val2.g;
		local t_r = val2.r;
		local t_dm = val2.dm;
		local t_sh = val2.sh;
		local t_l = val2.l;
		local v23 = t_Pets2:FindFirstChild(t_uid);
		if not v23 then
			v12 = v12 + 1;
			if v12 % 250 == 0 then
				m_Library.Heartbeat();
			end
			v23 = m_Library.Assets.UI.Inventory.Pet:Clone();
			v23.Name = t_uid;
			v23:SetAttribute("PetId", t_uid);
			m_Library.PetUI.Create(v23, t_uid);
			m_Library.GUIFX.ButtonFX(v23);
			v23.Parent = t_Pets2;
			v23.Activated:Connect(function() -- Line: 427
				--[[
					Upvalues:
						[1] = bool2
						[2] = m_Library
						[3] = t_uid
						[4] = u6
						[5] = Random_new_ret
				--]]
				if not bool2 then
					bool2 = true;
					if m_Library.PetCmds.Get(t_uid).l then
						m_Library.Message.New("You cannot select locked pets!");
					elseif not u6 or u6 ~= t_uid then
						Select(t_uid);
					else
						m_Library.Audio.Play("rbxassetid://7139317909", script, Random_new_ret:NextNumber(0.95, 1.05), 0.75);
						Deselect(t_uid);
					end
					bool2 = false;
				end
			end);
		end
		v23.Locked.Visible = val2.l;
		v23.PetIcon.ImageTransparency = 0;
		v23.LayoutOrder = key2;
		v23.Level:FindFirstChildOfClass("UIStroke").Thickness = u1 and 2 or 4;
		v23.HC:FindFirstChildOfClass("UIStroke").Thickness = u1 and 2 or 4;
		if v21 then
			local bool6 = false;
			if string.find(string.lower(t_name), v11, 1, true) then
				bool6 = true;
			elseif val2.nk and string.find(string.lower(val2.nk), v11, 1, true) then
				bool6 = true;
			elseif string.find(string.lower(t_rarity), v11, 1, true) then
				bool6 = true;
			elseif t_sh and string.find("shiny", v11, 1, true) then
				bool6 = true;
			elseif t_g and (string.find("gold", v11, 1, true) or string.find("golden", v11, 1, true)) then
				bool6 = true;
			elseif t_r and string.find("rainbow", v11, 1, true) then
				bool6 = true;
			elseif t_dm and string.find("dark matter", v11, 1, true) then
				bool6 = true;
			elseif t_l and string.find("lock", v11, 1, true) then
				bool6 = true;
			elseif t_powers and #t_powers > 0 then
				for _, val18 in ipairs(t_powers) do
					local unpack_ret1, unpack_ret2 = unpack(val18);
					local v65, _ = m_Library.Shared.GetPowerDir(unpack_ret1, unpack_ret2);
					if not string.find(string.lower(v65.title), v11, 1, true) then continue end
					bool6 = true;
					break;
				end
			end
			v23.Visible = bool6;
		else
			v23.Visible = true;
		end
		table5[t_uid] = true;
	end
	for _, child3 in ipairs(t_Pets2:GetChildren()) do
		local Attribute2 = child3:GetAttribute("PetId");
		if not Attribute2 or table5[Attribute2] then continue end
		child3:Destroy();
	end
	PetScrolling();
	t_Texts.NoPets.Text = "Inventory is empty. Hatch some pets first! \240\159\153\130";
	t_Texts.NoPets.Visible = #v13 <= 0;
	t_Bottom.BalanceInput.Display.Input.Text = m_Library.Functions.NumberShorten(u3, false);
	t_Top.Grid.Image = u1 and "rbxassetid://6958935961" or "rbxassetid://6958936066";
	local t_SendDiamonds2 = t_GiftPet.Side.BottomInputFrame.SendDiamonds;
	UpdateSendButtons();
	if not bool5 then
		m_Library.GUIFX.ButtonFX(t_Mailbox.Gui.Frame.GiftPet.Container.Inventory.Top.Grid);
		m_Library.GUIFX.ButtonFX(t_SendDiamonds2);
		t_SendDiamonds2.Activated:Connect(function() -- Line: 522
			--[[
				Upvalues:
					[1] = bool2
					[2] = m_Library
					[3] = t_Input5
					[4] = u5
			--]]
			if not bool2 then
				bool2 = true;
				if not CanSend() then
					bool2 = false;
					return;
				end
				local v42 = m_Library.Message.New("\226\156\133 Are you sure you want to send this mail to " .. t_Input5.Text .. "?", true);
				if v42 then
					if u5 and string.len(u5) > 100 then
						m_Library.Message.New("Your message is too long!");
						bool2 = false;
						return;
					end
					local ComposeMail_ret = ComposeMail();
					local function send() -- Line: 538
						--[[
							Upvalues:
								[1] = m_Library
								[2] = ComposeMail_ret
						--]]
						local v59, v60 = m_Library.Network.Invoke("Send Mail", ComposeMail_ret);
						if not v59 then
							m_Library.Message.New(v60 or "Failed to send pets! (Unknown error)");
							return;
						end
						m_Library.Audio.Play("rbxassetid://11839132565", script);
					end
					if string.match(string.lower(ComposeMail_ret.Message), "sign") then
						local v51 = m_Library.Message.New("WARNING!! This is a gift and you're not guaranteed to get your pet back!", true);
						if v51 then
							local v61, v62 = m_Library.Network.Invoke("Send Mail", ComposeMail_ret);
							if not v61 then
								m_Library.Message.New(v62 or "Failed to send pets! (Unknown error)");
							else
								m_Library.Audio.Play("rbxassetid://11839132565", script);
							end
						end
					else
						local v52, v53 = m_Library.Network.Invoke("Send Mail", ComposeMail_ret);
						if not v52 then
							m_Library.Message.New(v53 or "Failed to send pets! (Unknown error)");
						else
							m_Library.Audio.Play("rbxassetid://11839132565", script);
						end
					end
				end
				bool2 = false;
			end
		end);
		bool5 = true;
	end
end
function InboxMode(p5) -- Line: 583
	--[[
		Upvalues:
			[1] = t_Mailbox
			[2] = table3
			[3] = u2
	--]]
	local t_GiftInventory = t_Mailbox.Gui.Frame.GiftInventory;
	local _ = t_GiftInventory.Bottom.RejectMode;
	local _ = t_GiftInventory.Bottom.ClaimMode;
	local _ = t_GiftInventory.Bottom.History;
	local t_ClaimAll = t_GiftInventory.Bottom.ClaimAll;
	local _ = t_GiftInventory.Bottom.VerifyReject;
	local _ = t_GiftInventory.Bottom.VerifyClaim;
	local _ = t_GiftInventory.Bottom.Settings;
	if ({
		Delete = function() -- Line: 594
			--[[
				Upvalues:
					[1] = t_GiftInventory
					[2] = t_ClaimAll
			--]]
			for _, child12 in ipairs(t_GiftInventory.Main.Gifts:GetChildren()) do
				if not child12:isA("TextButton") then continue end
				child12.FadeOverlay.Visible = true;
				child12.Container.Claim.Label.Text = "Select";
				child12.Container.Reject.Visible = false;
			end
			t_ClaimAll.Label.Text = "Select All";
			return true;
		end,
		Claim = function() -- Line: 607
			--[[
				Upvalues:
					[1] = t_GiftInventory
					[2] = t_ClaimAll
			--]]
			for _, child13 in ipairs(t_GiftInventory.Main.Gifts:GetChildren()) do
				if not child13:isA("TextButton") then continue end
				child13.FadeOverlay.Visible = true;
				child13.Container.Claim.Label.Text = "Select";
				child13.Container.Reject.Visible = false;
			end
			t_ClaimAll.Label.Text = "Select All";
			return true;
		end,
		Default = function() -- Line: 620
			--[[
				Upvalues:
					[1] = t_GiftInventory
					[2] = t_ClaimAll
					[3] = table3
			--]]
			for _, child14 in ipairs(t_GiftInventory.Main.Gifts:GetChildren()) do
				if not child14:isA("TextButton") then continue end
				child14.FadeOverlay.Visible = false;
				ToggleButton(child14.Container.Claim, true);
				child14.Container.Claim.Label.Text = "Claim";
				child14.Container.Reject.Visible = true;
			end
			t_ClaimAll.Label.Text = "Claim All";
			table3 = {};
			return true;
		end
	})[p5]() then
		u2 = p5;
		UpdateInboxBottom();
	end
end
function UpdateHistory() -- Line: 645
	--[[
		Upvalues:
			[1] = t_Mailbox
			[2] = m_Library
			[3] = table2
	--]]
	local t_History = t_Mailbox.Gui.Frame.GiftInventory.Main.History;
	local v14 = m_Library.Save.Get();
	if not v14 then
		t_History.NoHistory.Visible = true;
		HistoryScrolling();
		return;
	end
	if not v14.MailLog then
		t_History.NoHistory.Visible = true;
		HistoryScrolling();
		return;
	end
	t_History.NoHistory.Visible = false;
	local t_HistoryLogClaimed = t_History.HistoryLogClaimed;
	local table6 = {};
	for index1 = #v14.MailLog, 1, -1 do
		local v24 = v14.MailLog[index1];
		if v24.Sender and not table.find(table6, v24.Sender) and not table2[v24.Sender] then
			table.insert(table6, v24.Sender);
		end
		if v24.Receiver and not table.find(table6, v24.Receiver) and not table2[v24.Receiver] then
			table.insert(table6, v24.Receiver);
		end
	end
	if #table6 > 0 then
		local success, pcall_ret2 = pcall(function() -- Line: 680
			--[[
				Upvalues:
					[1] = m_Library
					[2] = table6
			--]]
			return m_Library.UserService:GetUserInfosByUserIdsAsync(table6);
		end);
		if success then
			for _, val7 in ipairs(pcall_ret2) do
				table2[val7.Id] = val7;
			end
		end
		if not success then
			warn(pcall_ret2);
		end
	end
	local v15 = 1;
	for index2 = math.min(#v14.MailLog, 100), 1, -1 do
		local u11 = v14.MailLog[index2];
		if t_History:FindFirstChild(u11.UUID) then
			t_History:FindFirstChild(u11.UUID).LayoutOrder = v15;
			v15 = v15 + 1;
		else
			local Clone_ret = t_HistoryLogClaimed:Clone();
			Clone_ret:SetAttribute("Template", false);
			local _ = u11.Receiver == nil;
			Clone_ret.Parent = t_History;
			local Description = Clone_ret:WaitForChild("HistoryLogClaimed"):WaitForChild("Description");
			local Timestamp = Clone_ret:WaitForChild("HistoryLogClaimed"):WaitForChild("Timestamp");
			local v29 = m_Library.Functions.NumberShorten(u11.Diamonds);
			local v30 = u11.Timestamp or 0;
			local function resolveName() -- Line: 715
				--[[
					Upvalues:
						[1] = u11
						[2] = table2
				--]]
				local v43 = u11.Sender or u11.Receiver;
				return table2[v43] and table2[v43].Username or "???";
			end
			local v31 = u11.Sender or u11.Receiver;
			local u13 = table2[v31] and table2[v31].Username or "???";
			local v32 = u11.Sender and "Claimed " .. u13 .. "'s" or "Sent " .. u13 .. " a";
			local v33 = nil;
			if #u11.Pets > 0 then
				v33 = m_Library.Directory.Pets[u11.Pets[1].id].name;
				local v39 = u11.Pets[1];
				if v39.dm then
					v33 = "Dark Matter " .. v33;
				elseif v39.r then
					v33 = "Rainbow " .. v33;
				elseif v39.g then
					v33 = "Gold " .. v33;
				end
				if v39.sh then
					v33 = "Shiny " .. v33;
				end
			end
			if #u11.Pets > 0 and u11.Diamonds == 0 then
				Description.Text = string.format("%s gift with %s.", v32, v33);
			elseif #u11.Pets < 1 and u11.Diamonds > 0 then
				Description.Text = string.format("%s gift with %s Diamonds.", v32, v29);
			elseif #u11.Pets > 0 and u11.Diamonds > 0 then
				local _ = m_Library.Directory.Pets[u11.Pets[1].id];
				Description.Text = string.format("%s gift with %s and %s Diamonds.", v32, v33, v29);
			end
			local v34 = workspace:GetServerTimeNow() - v30;
			Timestamp.Text = v34 <= 120 and "Just now" or m_Library.Functions.TimeString(v34) .. " ago";
			Clone_ret.Name = u11.UUID;
			Clone_ret.Visible = true;
			Clone_ret:WaitForChild("HistoryLogClaimed").Activated:Connect(function() -- Line: 762
				--[[
					Upvalues:
						[1] = t_Mailbox
						[2] = u13
						[3] = m_Library
				--]]
				UpdateOutboxLazy();
				t_Mailbox.Gui.Frame.MainMenu.Visible = false;
				t_Mailbox.Gui.Frame.GiftInventory.Visible = false;
				t_Mailbox.Gui.Frame.GiftPet.Visible = false;
				t_Mailbox.Gui.Frame.GiftInventory.Main.Gifts.Visible = true;
				t_Mailbox.Gui.Frame.GiftInventory.Main.History.Visible = false;
				t_Mailbox.Gui.Frame.GiftPet.Visible = true;
				t_Mailbox.Gui.Frame.GiftPet.Side.UsernameInputFrame.Input.Text = u13;
				m_Library.Audio.Play("rbxassetid://11839132336", script, 1, 1);
				UpdateTargetPlayer();
			end);
			m_Library.GUIFX.Tooltip(Clone_ret:WaitForChild("HistoryLogClaimed"), "Reply to " .. u13);
			m_Library.GUIFX.ButtonFX(Clone_ret:WaitForChild("HistoryLogClaimed"));
			v15 = v15 + 1;
		end
	end
	HistoryScrolling();
end
function HistoryScrolling() -- Line: 782
	--[[
		Upvalues:
			[1] = t_Mailbox
	--]]
	local t_History2 = t_Mailbox.Gui.Frame.GiftInventory.Main.History;
	local UIListLayout = t_History2:FindFirstChildOfClass("UIListLayout");
	local UIPadding2 = t_History2:FindFirstChildOfClass("UIPadding");
	t_History2.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + UIPadding2.PaddingTop.Offset + UIPadding2.PaddingBottom.Offset);
end
function UpdateInboxBottom() -- Line: 790
	--[[
		Upvalues:
			[1] = u8
			[2] = t_Mailbox
			[3] = u2
			[4] = table3
			[5] = bool4
			[6] = m_Library
			[7] = bool2
	--]]
	if not u8 then return end
	local t_GiftInventory2 = t_Mailbox.Gui.Frame.GiftInventory;
	local t_RejectMode = t_GiftInventory2.Bottom.RejectMode;
	local t_History3 = t_GiftInventory2.Bottom.History;
	local t_ClaimAll2 = t_GiftInventory2.Bottom.ClaimAll;
	local t_ClaimMode = t_GiftInventory2.Bottom.ClaimMode;
	local t_VerifyReject = t_GiftInventory2.Bottom.VerifyReject;
	local t_VerifyClaim = t_GiftInventory2.Bottom.VerifyClaim;
	local t_Settings = t_GiftInventory2.Bottom.Settings;
	t_GiftInventory2.PetAmount.Visible = not t_GiftInventory2.Main.History.Visible;
	t_ClaimAll2.Visible = not t_GiftInventory2.Main.History.Visible;
	t_RejectMode.ImageColor3 = #u8.Inbox > 0 and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
	t_ClaimMode.ImageColor3 = #u8.Inbox > 0 and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
	t_ClaimAll2.ImageColor3 = #u8.Inbox > 0 and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
	if u2 == "Delete" then
		t_History3.Visible = false;
		t_Settings.Visible = false;
		t_ClaimMode.Visible = false;
		t_RejectMode.Visible = true;
		t_VerifyReject.Visible = true;
		t_VerifyClaim.Visible = false;
		if #table3 > 0 then
			t_VerifyReject.Label.Text = "Confirm";
			ToggleButton(t_VerifyReject, true);
		else
			t_VerifyReject.Label.Text = "Cancel";
			ToggleButton(t_VerifyReject, false);
		end
	elseif u2 == "Claim" then
		t_History3.Visible = false;
		t_Settings.Visible = false;
		t_ClaimMode.Visible = true;
		t_RejectMode.Visible = false;
		t_VerifyReject.Visible = false;
		t_VerifyClaim.Visible = true;
		if #table3 > 0 then
			t_VerifyClaim.Label.Text = "Confirm";
			ToggleButton(t_VerifyClaim, true);
		else
			t_VerifyClaim.Label.Text = "Cancel";
			ToggleButton(t_VerifyClaim, false);
		end
	elseif u2 == "Default" then
		t_History3.Visible = true;
		t_Settings.Visible = true;
		t_ClaimMode.Visible = true;
		t_RejectMode.Visible = true;
		t_VerifyReject.Visible = false;
		t_VerifyClaim.Visible = false;
	end
	if not bool4 then
		m_Library.GUIFX.ButtonFX(t_RejectMode);
		m_Library.GUIFX.ButtonFX(t_ClaimMode);
		m_Library.GUIFX.ButtonFX(t_History3);
		m_Library.GUIFX.ButtonFX(t_ClaimAll2);
		m_Library.GUIFX.ButtonFX(t_Settings);
		m_Library.GUIFX.ButtonFX(t_VerifyClaim);
		m_Library.GUIFX.ButtonFX(t_VerifyReject);
		m_Library.GUIFX.Tooltip(t_RejectMode, "Toggle Reject Mode");
		m_Library.GUIFX.Tooltip(t_ClaimMode, "Toggle Claim Mode");
		m_Library.GUIFX.Tooltip(t_History3, "Show Mail History");
		m_Library.GUIFX.Tooltip(t_ClaimAll2, "Claim All Mail");
		m_Library.GUIFX.Tooltip(t_Settings, "Mail Settings");
		t_VerifyReject.Activated:Connect(function() -- Line: 868
			--[[
				Upvalues:
					[1] = bool2
					[2] = table3
					[3] = m_Library
			--]]
			if not bool2 then
				bool2 = true;
				if #table3 < 1 then
					InboxMode("Default");
					bool2 = false;
					return;
				end
				local v44 = m_Library.Message.New("\226\157\140 Are you SURE you want to REJECT " .. #table3 .. " gift(s)? You cannot undo this.", true);
				if v44 then
					local v46, v47 = m_Library.Network.Invoke("Reject Mail", table3);
					if not v46 then
						m_Library.Message.New(v47 or "Failed to reject pets! (Unknown error)");
					else
						m_Library.Audio.Play("rbxassetid://7047631781", script);
					end
					InboxMode("Default");
				end
				bool2 = false;
			end
		end);
		t_VerifyClaim.Activated:Connect(function() -- Line: 892
			--[[
				Upvalues:
					[1] = bool2
					[2] = table3
					[3] = m_Library
			--]]
			if not bool2 then
				bool2 = true;
				if #table3 < 1 then
					InboxMode("Default");
					bool2 = false;
					return;
				end
				local v45 = m_Library.Message.New("\226\156\133 Claim " .. #table3 .. " gift(s)?", true);
				if v45 then
					local v48, v49 = m_Library.Network.Invoke("Claim Mail", table3);
					if not v48 then
						m_Library.Message.New(v49 or "Failed to delete pets! (Unknown error)");
					else
						m_Library.Audio.Play("rbxassetid://7047631781", script);
					end
					InboxMode("Default");
				end
				bool2 = false;
			end
		end);
		t_RejectMode.Activated:Connect(function() -- Line: 916
			--[[
				Upvalues:
					[1] = bool2
					[2] = u8
					[3] = t_GiftInventory2
					[4] = u2
			--]]
			if not bool2 then
				bool2 = true;
				if #u8.Inbox < 1 then
					bool2 = false;
					return;
				end
				t_GiftInventory2.Main.Gifts.Visible = true;
				t_GiftInventory2.Main.History.Visible = false;
				if u2 ~= "Delete" then
					InboxMode("Delete");
				else
					InboxMode("Default");
				end
				bool2 = false;
			end
		end);
		t_ClaimMode.Activated:Connect(function() -- Line: 938
			--[[
				Upvalues:
					[1] = bool2
					[2] = u8
					[3] = t_GiftInventory2
					[4] = u2
			--]]
			if not bool2 then
				bool2 = true;
				if #u8.Inbox < 1 then
					bool2 = false;
					return;
				end
				t_GiftInventory2.Main.Gifts.Visible = true;
				t_GiftInventory2.Main.History.Visible = false;
				if u2 ~= "Claim" then
					InboxMode("Claim");
				else
					InboxMode("Default");
				end
				bool2 = false;
			end
		end);
		t_ClaimAll2.Activated:Connect(function() -- Line: 960
			--[[
				Upvalues:
					[1] = bool2
					[2] = u2
					[3] = u8
					[4] = m_Library
			--]]
			if not bool2 then
				bool2 = true;
				if u2 == "Default" then
					if #u8.Inbox < 1 then
						bool2 = false;
						return;
					end
					local v50 = m_Library.Message.New("Are you sure you want to claim ALL mail?", true);
					if v50 then
						local v54, v55 = m_Library.Network.Invoke("Claim All Mail");
						if not v54 then
							m_Library.Message.New(v55);
						end
					end
				else
					for _, val17 in ipairs(u8.Inbox) do
						MultiSelect(val17.uuid);
					end
				end
				bool2 = false;
			end
		end);
		t_Settings.Activated:Connect(function() -- Line: 986
			--[[
				Upvalues:
					[1] = bool2
					[2] = m_Library
			--]]
			if not bool2 then
				bool2 = true;
				m_Library.Signal.Fire("Open Mail Settings");
				bool2 = false;
			end
		end);
		t_History3.Activated:Connect(function() -- Line: 996
			--[[
				Upvalues:
					[1] = bool2
					[2] = t_GiftInventory2
			--]]
			if not bool2 then
				bool2 = true;
				if not t_GiftInventory2.Main.History.Visible then
					UpdateHistory();
					t_GiftInventory2.Main.Gifts.Visible = false;
					t_GiftInventory2.Main.History.Visible = true;
				else
					t_GiftInventory2.Main.Gifts.Visible = true;
					t_GiftInventory2.Main.History.Visible = false;
				end
				UpdateInboxBottom();
				bool2 = false;
			end
		end);
		bool4 = true;
	end
end
function MultiSelect(p6) -- Line: 1018
	--[[
		Upvalues:
			[1] = table3
			[2] = t_Mailbox
	--]]
	local table_find_ret = table.find(table3, p6);
	local FindFirstChild_ret = t_Mailbox.Gui.Frame.GiftInventory.Main.Gifts:FindFirstChild(p6);
	if not FindFirstChild_ret then
		warn("Couldn't find the gift!");
		return;
	end
	if FindFirstChild_ret.Visible == false then return end
	local Container = FindFirstChild_ret:FindFirstChild("Container");
	if not Container then
		warn("No container!");
		return;
	end
	if not table_find_ret then
		ToggleButton(Container.Claim, false);
		Container.Claim.Label.Text = "Remove";
		Container.Parent.FadeOverlay.Visible = false;
		table.insert(table3, p6);
	else
		ToggleButton(Container.Claim, true);
		Container.Claim.Label.Text = "Select";
		Container.Parent.FadeOverlay.Visible = true;
		table.remove(table3, table_find_ret);
	end
	UpdateInboxBottom();
end
function createDefaultMailbox(p7) -- Line: 1051
	local v16 = p7 or {
		Enabled = true,
		FriendsOnly = false,
		HugesOnly = false,
		RequiredPet = false,
		Rarities = {
			Basic = false,
			Epic = false,
			Exclusive = false,
			Legendary = false,
			Mythical = false,
			Rare = false
		}
	};
	local table7 = {
		Inbox = {},
		Settings = v16
	};
	return table7;
end
function UpdateInbox(p8) -- Line: 1073
	--[[
		Upvalues:
			[1] = t_Mailbox
			[2] = m_Library
			[3] = u8
			[4] = table2
			[5] = t_Inventory
			[6] = bool2
			[7] = u2
			[8] = table1
	--]]
	local t_GiftInventory3 = t_Mailbox.Gui.Frame.GiftInventory;
	if not p8 then
		local v25 = m_Library.Network.Invoke("Get Mail");
		p8 = v25 ~= nil and v25 or u8;
		if not p8 then
			p8 = createDefaultMailbox();
		end
	end
	local v17 = u8 ~= nil and not m_Library.Functions.DeepEqualsUnsafe(u8.Inbox, p8.Inbox) or u8 == nil;
	u8 = p8;
	if v17 then
		UpdateWorldMailbox();
	end
	local Children = t_GiftInventory3.Main.Gifts:GetChildren();
	for _, val4 in ipairs(Children) do
		if val4:isA("UIPadding") or val4:isA("UIListLayout") or val4.Name == "Template" then continue end
		local bool8 = false;
		for _, val6 in ipairs(u8.Inbox) do
			if val6.uuid ~= val4.Name then continue end
			bool8 = true;
			break;
		end
		if bool8 then continue end
		val4:Destroy();
	end
	local t_Template = t_GiftInventory3.Main.Gifts.Template;
	t_GiftInventory3.PetAmount.Text = string.format("%d/%d Gifts", #u8.Inbox, 100);
	local t_Query = t_GiftInventory3.Bottom.Search.Query;
	local v26;
	if t_Query.Text == "" then
		v26 = false;
	else
		v26 = t_Query.Text ~= nil;
	end
	local v18 = v26 and m_Library.Functions.RegexEscape(string.lower(tostring(t_Mailbox.Query.Text))) or nil;
	local table8 = {};
	for _, val5 in ipairs(u8.Inbox) do
		if table.find(table8, val5.Sender) or table2[val5.Sender] then continue end
		table.insert(table8, val5.Sender);
	end
	if #table8 > 0 then
		local success2, pcall_ret2_2 = pcall(function() -- Line: 1126
			--[[
				Upvalues:
					[1] = m_Library
					[2] = table8
			--]]
			return m_Library.UserService:GetUserInfosByUserIdsAsync(table8);
		end);
		if success2 then
			for _, val8 in ipairs(pcall_ret2_2) do
				table2[val8.Id] = val8;
			end
		end
		if not success2 then
			warn(pcall_ret2_2);
		end
	end
	local v19 = 0;
	for index3 = #u8.Inbox, 1, -1 do
		v19 = v19 + 1;
		local u12 = u8.Inbox[index3];
		local v27 = u12.Pets[1] and u12.Pets[1] or nil;
		local t_g2 = nil;
		local t_r2 = nil;
		local t_dm2 = nil;
		local t_powers2 = nil;
		local t_name2 = nil;
		local t_rarity2 = nil;
		local t_sh2 = nil;
		local t_l2 = nil;
		if v27 then
			local _ = v27.uid;
			local t_id = v27.id;
			local _ = v27.idt;
			local _ = v27.s;
			t_g2 = v27.g;
			t_r2 = v27.r;
			t_dm2 = v27.dm;
			t_powers2 = v27.powers;
			local v35 = m_Library.Directory.Pets[t_id];
			local _ = v35.isGift;
			local _ = t_g2 and v35.goldenThumbnail or v35.thumbnail;
			t_name2 = v35.name;
			t_rarity2 = v35.rarity;
			t_sh2 = v27.sh;
			t_l2 = v27.l;
		end
		if not t_GiftInventory3.Main.Gifts:FindFirstChild(u12.uuid) then
			local Clone_ret2 = t_Template:Clone();
			Clone_ret2.Name = u12.uuid;
			Clone_ret2.Parent = t_GiftInventory3.Main.Gifts;
			Clone_ret2:SetAttribute("Template", false);
			local t_Container = Clone_ret2.Container;
			t_Container.BothDiamonds.Visible = false;
			t_Container.BothPet.Visible = false;
			t_Container.OnlyDiamonds.Visible = false;
			t_Container.OnlyPet.Visible = false;
			local v36 = u12.Diamonds > 0;
			local v37 = #u12.Pets > 0;
			if v36 and v37 then
				t_Container.BothDiamonds.Visible = true;
				t_Container.BothDiamonds.Cost.Text = m_Library.Functions.NumberShorten(u12.Diamonds);
				t_Container.BothPet.Visible = true;
				local Clone_ret4 = t_Inventory.Pet:Clone();
				Clone_ret4.Visible = true;
				m_Library.PetUI.Create(Clone_ret4, u12.Pets[1].uid, u12.Pets[1]);
				local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint");
				UIAspectRatioConstraint2.Parent = Clone_ret4;
				Clone_ret4.Position = UDim2.new(0.5, 0, 0.5, 0);
				Clone_ret4.AnchorPoint = Vector2.new(0.5, 0.5);
				Clone_ret4.RarityGradient.ZIndex = 5;
				Clone_ret4.ZIndex = 6;
				if Clone_ret4:FindFirstChild("ShinePulse") then
					Clone_ret4.ShinePulse.ShineImage.ZIndex = 7;
				end
				Clone_ret4.PetIcon.ZIndex = 7;
				Clone_ret4.Size = UDim2.new(1, 0, 1, 0);
				Clone_ret4.Parent = t_Container.BothPet;
			elseif v36 and not v37 then
				t_Container.OnlyDiamonds.Visible = true;
				t_Container.OnlyDiamonds.Cost.Text = m_Library.Functions.NumberShorten(u12.Diamonds);
			elseif not v36 and v37 then
				t_Container.OnlyPet.Visible = true;
				local Clone_ret3 = t_Inventory.Pet:Clone();
				Clone_ret3.Visible = true;
				m_Library.PetUI.Create(Clone_ret3, u12.Pets[1].uid, u12.Pets[1]);
				Clone_ret3.RarityGradient.ZIndex = 5;
				Clone_ret3.ZIndex = 6;
				if Clone_ret3:FindFirstChild("ShinePulse") then
					Clone_ret3.ShinePulse.ShineImage.ZIndex = 7;
				end
				Clone_ret3.PetIcon.ZIndex = 7;
				Clone_ret3.Size = UDim2.new(1, 0, 1, 0);
				local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
				UIAspectRatioConstraint.Parent = Clone_ret3;
				Clone_ret3.Position = UDim2.new(0.5, 0, 0.5, 0);
				Clone_ret3.AnchorPoint = Vector2.new(0.5, 0.5);
				Clone_ret3.Parent = t_Container.OnlyPet;
			end
			m_Library.GUIFX.ButtonFX(t_Container.Claim);
			t_Container.Claim.Activated:Connect(function() -- Line: 1225
				--[[
					Upvalues:
						[1] = bool2
						[2] = u2
						[3] = m_Library
						[4] = u12
				--]]
				if not bool2 then
					bool2 = true;
					if u2 == "Default" then
						local v56, v57 = m_Library.Network.Invoke("Claim Mail", {u12.uuid});
						if not v56 then
							m_Library.Message.New(v57);
						end
					elseif u2 == "Delete" then
						MultiSelect(u12.uuid);
						UpdateInboxBottom();
					elseif u2 == "Claim" then
						MultiSelect(u12.uuid);
						UpdateInboxBottom();
					end
					bool2 = false;
				end
			end);
			m_Library.GUIFX.ButtonFX(t_Container.Reject);
			t_Container.Reject.Activated:Connect(function() -- Line: 1248
				--[[
					Upvalues:
						[1] = bool2
						[2] = u2
						[3] = m_Library
						[4] = u12
				--]]
				if not bool2 then
					bool2 = true;
					if u2 == "Default" then
						local v58 = m_Library.Message.New("Are you sure you want to REJECT this mail? THIS CANNOT BE UNDONE!", true);
						if v58 then
							local v63, v64 = m_Library.Network.Invoke("Reject Mail", {u12.uuid});
							if not v63 then
								m_Library.Message.New(v64);
							else
								m_Library.Audio.Play("rbxassetid://11839132565", script);
							end
						end
					end
					bool2 = false;
				end
			end);
			if table2[u12.Sender] then
				local v40 = table2[u12.Sender];
				t_Container.Username.Text = "@" .. v40.Username;
				t_Container.DisplayName.Text = v40.DisplayName;
			else
				t_Container.Username.Text = "@???";
				t_Container.DisplayName.Text = "???";
			end
			local u14 = table1[u12.Sender] or nil;
			if not u14 then
				task.spawn(function() -- Line: 1279
					--[[
						Upvalues:
							[1] = u14
							[2] = u12
							[3] = table1
							[4] = t_Container
					--]]
					u14 = game.Players:GetUserThumbnailAsync(u12.Sender, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180);
					table1[u12.Sender] = u14;
					t_Container.PlayerImage.Image = u14;
				end);
			end
			t_Container.PlayerImage.Image = u14 ~= nil and u14 or "rbxassetid://7249691240";
			if t_Container.Message and u12.Message then
				t_Container.Message.Text = u12.Message;
			end
		end
		local FindFirstChild_ret2 = t_GiftInventory3.Main.Gifts:FindFirstChild(u12.uuid);
		if FindFirstChild_ret2 then
			FindFirstChild_ret2.LayoutOrder = v19;
			local t_Container2 = FindFirstChild_ret2.Container;
			if t_Container2.Time then
				local v41 = workspace:GetServerTimeNow() - u12.Timestamp;
				t_Container2.Time.Text = v41 <= 120 and "Just now" or m_Library.Functions.TimeString(v41) .. " ago";
			end
			if v26 then
				local bool7 = false;
				if u12.Message and string.find(string.lower(t_Container2.Message.Text), v18, 1, true) then
					bool7 = true;
				elseif t_Container2.Username and string.find(string.lower(t_Container2.Username.Text), v18, 1, true) then
					bool7 = true;
				elseif t_Container2.DisplayName and string.find(string.lower(t_Container2.DisplayName.Text), v18, 1, true) then
					bool7 = true;
				elseif string.find(string.lower(u12.Diamonds), v18, 1, true) then
					bool7 = true;
				elseif v27 then
					if string.find(string.lower(t_name2), v18, 1, true) then
						bool7 = true;
					elseif v27.nk and string.find(string.lower(v27.nk), v18, 1, true) then
						bool7 = true;
					elseif string.find(string.lower(t_rarity2), v18, 1, true) then
						bool7 = true;
					elseif t_sh2 and string.find("shiny", v18, 1, true) then
						bool7 = true;
					elseif t_g2 and (string.find("gold", v18, 1, true) or string.find("golden", v18, 1, true)) then
						bool7 = true;
					elseif t_r2 and string.find("rainbow", v18, 1, true) then
						bool7 = true;
					elseif t_dm2 and string.find("dark matter", v18, 1, true) then
						bool7 = true;
					elseif t_l2 and string.find("lock", v18, 1, true) then
						bool7 = true;
					elseif t_powers2 and #t_powers2 > 0 then
						for _, val19 in ipairs(t_powers2) do
							local unpack_ret1_2, unpack_ret2_2 = unpack(val19);
							local v66, _ = m_Library.Shared.GetPowerDir(unpack_ret1_2, unpack_ret2_2);
							if not string.find(string.lower(v66.title), v18, 1, true) then continue end
							bool7 = true;
							break;
						end
					end
				end
				FindFirstChild_ret2.Visible = bool7;
			else
				FindFirstChild_ret2.Visible = true;
			end
		end
	end
	UpdateInboxBottom();
	local t_Gifts = t_GiftInventory3.Main.Gifts;
	local UIListLayout2 = t_Gifts:FindFirstChildOfClass("UIListLayout");
	local UIPadding3 = t_Gifts:FindFirstChildOfClass("UIPadding");
	t_Gifts.CanvasSize = UDim2.new(0, 0, 0, UIListLayout2.AbsoluteContentSize.Y + UIPadding3.PaddingTop.Offset + UIPadding3.PaddingBottom.Offset);
end
function UpdateWorldMailbox() -- Line: 1364
	--[[
		Upvalues:
			[1] = m_Library
			[2] = Mailbox
			[3] = u8
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		Mailbox = Map.Interactive:FindFirstChild("Mailbox");
		if Mailbox then
			local v38 = u8 and u8.Inbox and #u8.Inbox or 0;
			for _, descendant9 in ipairs(Mailbox:GetDescendants()) do
				if not descendant9:isA("PointLight") and not descendant9:isA("ParticleEmitter") then continue end
				descendant9.Enabled = false;
			end
			for index4 = 2, 4 do
				local FindFirstChild_ret4 = Mailbox:FindFirstChild("Gifts" .. index4);
				if FindFirstChild_ret4 then
					for _, descendant15 in ipairs(FindFirstChild_ret4:GetDescendants()) do
						if descendant15:isA("MeshPart") then
							descendant15.Transparency = 1;
							descendant15.CanCollide = false;
						end
						if not descendant15:isA("PointLight") and not descendant15:isA("ParticleEmitter") then continue end
						descendant15.Enabled = false;
					end
				end
			end
			if v38 == 0 then
				local Opened2 = Mailbox:FindFirstChild("Opened");
				local Closed2 = Mailbox:FindFirstChild("Closed");
				Opened2.Transparency = 1;
				Closed2.Transparency = 0;
				return;
			end
			if v38 > 0 then
				local Pad = Mailbox:FindFirstChild("Pad");
				local Opened = Mailbox:FindFirstChild("Opened");
				local Closed = Mailbox:FindFirstChild("Closed");
				Opened.Transparency = 0;
				Closed.Transparency = 1;
				for _, descendant10 in ipairs(Opened:GetDescendants()) do
					if not descendant10:isA("PointLight") and not descendant10:isA("ParticleEmitter") then continue end
					descendant10.Enabled = true;
				end
				for _, descendant11 in ipairs(Pad:GetDescendants()) do
					if not descendant11:isA("PointLight") and not descendant11:isA("ParticleEmitter") then continue end
					descendant11.Enabled = true;
				end
			end
			for index5 = 2, math.clamp(v38, 2, 4) do
				local FindFirstChild_ret3 = Mailbox:FindFirstChild("Gifts" .. index5);
				if FindFirstChild_ret3 then
					for _, descendant16 in ipairs(FindFirstChild_ret3:GetDescendants()) do
						if descendant16:isA("MeshPart") then
							descendant16.Transparency = 0;
							descendant16.CanCollide = true;
						end
						if not descendant16:isA("PointLight") and not descendant16:isA("ParticleEmitter") then continue end
						descendant16.Enabled = true;
					end
				end
			end
		end
	end
end
function Close() -- Line: 1439
	--[[
		Upvalues:
			[1] = t_Mailbox
	--]]
	t_Mailbox.Gui.Enabled = false;
	t_Mailbox.Gui.Frame.MainMenu.Visible = true;
	t_Mailbox.Gui.Frame.GiftInventory.Visible = false;
	t_Mailbox.Gui.Frame.GiftPet.Visible = false;
	t_Mailbox.Gui.Frame.GiftInventory.Main.Gifts.Visible = true;
	t_Mailbox.Gui.Frame.GiftInventory.Main.History.Visible = false;
end
m_Library.GUIFX.ButtonFX(t_Mailbox.Gui.Frame.GiftPet.Close);
m_Library.GUIFX.ButtonFX(t_Mailbox.Gui.Frame.GiftInventory.Close);
m_Library.GUIFX.ButtonFX(t_Mailbox.Gui.Frame.MainMenu.Close);
t_Mailbox.Gui.Frame.GiftPet.Container.Inventory.Bottom.BalanceInput.Display.Input.FocusLost:Connect(UpdateDiamondsAmount);
t_Mailbox.Gui.Frame.GiftPet.Side.UsernameInputFrame.Input.FocusLost:Connect(UpdateTargetPlayer);
t_Mailbox.Gui.Frame.GiftPet.Side.MessageInputFrame.Input.FocusLost:Connect(UpdateMessage);
t_Mailbox.Gui.Frame.GiftInventory.Close.Activated:Connect(function() -- Line: 1458
	--[[
		Upvalues:
			[1] = bool2
	--]]
	if not bool2 then
		bool2 = true;
		Close();
		bool2 = false;
	end
end);
t_Mailbox.Gui.Frame.MainMenu.Close.Activated:Connect(function() -- Line: 1466
	--[[
		Upvalues:
			[1] = bool2
	--]]
	if not bool2 then
		bool2 = true;
		Close();
		bool2 = false;
	end
end);
t_Mailbox.Gui.Frame.GiftPet.Close.Activated:Connect(function() -- Line: 1474
	--[[
		Upvalues:
			[1] = bool2
	--]]
	if not bool2 then
		bool2 = true;
		Close();
		bool2 = false;
	end
end);
t_Mailbox.Gui.Frame.GiftPet.Container.Inventory.Top.Grid.Activated:Connect(function() -- Line: 1482
	--[[
		Upvalues:
			[1] = bool2
			[2] = u1
			[3] = m_Library
			[4] = t_Mailbox
	--]]
	if not bool2 then
		bool2 = true;
		u1 = not u1;
		m_Library.Audio.Play("rbxassetid://7004248320", script, 1, 0.5);
		t_Mailbox.Gui.Frame.GiftPet.Container.Inventory.Top.Grid.Image = u1 and "rbxassetid://6958935961" or "rbxassetid://6958936066";
		UpdatePets();
		bool2 = false;
	end
end);
t_Mailbox.Gui.Frame.GiftPet.Container.Inventory.Top.Search.Query:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 1493
	--[[
		Upvalues:
			[1] = t_Mailbox
			[2] = bool1
	--]]
	if t_Mailbox.Frame.GiftInventory.Bottom.Search.Query.Text ~= "" then
		t_Mailbox.Frame.GiftInventory.Main.Gifts.CanvasPosition = Vector2.new();
	end
	bool1 = true;
	UpdateOutbox();
end);
t_Mailbox.Frame.GiftInventory.Bottom.Search.Query:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 1501
	--[[
		Upvalues:
			[1] = t_Mailbox
	--]]
	if t_Mailbox.Frame.GiftInventory.Bottom.Search.Query.Text ~= "" then
		t_Mailbox.Frame.GiftInventory.Main.Gifts.CanvasPosition = Vector2.new();
	end
	UpdateInbox();
end);
local bool9 = false;
local bool10 = false;
local u9 = 0;
m_Library.Signal.Fired("Xbox Start Subtract"):Connect(function() -- Line: 1511
	--[[
		Upvalues:
			[1] = bool9
			[2] = u9
	--]]
	bool9 = true;
	u9 = 0;
end);
m_Library.Signal.Fired("Xbox Stop Subtract"):Connect(function() -- Line: 1516
	--[[
		Upvalues:
			[1] = bool9
			[2] = u9
	--]]
	bool9 = false;
	u9 = 0;
	UpdateDiamondsAmount();
end);
m_Library.Signal.Fired("Xbox Start Add"):Connect(function() -- Line: 1522
	--[[
		Upvalues:
			[1] = bool10
			[2] = u9
	--]]
	bool10 = true;
	u9 = 0;
end);
m_Library.Signal.Fired("Xbox Stop Add"):Connect(function() -- Line: 1527
	--[[
		Upvalues:
			[1] = bool10
			[2] = u9
	--]]
	bool10 = false;
	u9 = 0;
	UpdateDiamondsAmount();
end);
m_Library.Signal.Fired("Nickname Changed"):Connect(function(_, _) -- Line: 1533
	UpdateOutboxLazy();
end);
m_Library.Signal.Fired("Lock Changed"):Connect(function(_, _) -- Line: 1538
	UpdateOutboxLazy();
end);
m_Library.Signal.Fired("Stat Changed"):Connect(function(p9) -- Line: 1543
	if p9 == "Pets" then
		UpdateOutboxLazy();
	end
end);
m_Library.Signal.Fired("Window Opened"):Connect(function(p10) -- Line: 1549
	--[[
		Upvalues:
			[1] = t_Mailbox
			[2] = m_Library
	--]]
	if p10 == t_Mailbox.Gui then
		Update();
		if t_Mailbox.Gui.Frame.MainMenu.Visible then
			m_Library.Audio.Play("rbxassetid://86679922140267", script, 1, 0.5);
		end
	end
end);
m_Library.Signal.Invoked("Get Mailbox Settings").OnInvoke = function() -- Line: 1558
	--[[
		Upvalues:
			[1] = u8
	--]]
	if not u8 then
		return nil;
	end
	return u8.Settings;
end
m_Library.Signal.Fired("Set Mailbox Settings"):Connect(function(p11) -- Line: 1566
	--[[
		Upvalues:
			[1] = u8
	--]]
	u8.Settings = p11;
end);
m_Library.Signal.Invoked("Get Mail Settings").OnInvoke = function() -- Line: 1570
	--[[
		Upvalues:
			[1] = u8
	--]]
	return u8.Settings;
end
m_Library.Signal.Fired("Open Mailbox"):Connect(function(_) -- Line: 1574
	--[[
		Upvalues:
			[1] = t_Mailbox
	--]]
	t_Mailbox.Gui.Enabled = true;
end);
m_Library.Signal.Fired("Close Mailbox"):Connect(function() -- Line: 1578
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	Close();
	if m_Library.Variables.Console then
		m_Library.GuiService.SelectedObject = nil;
	end
end);
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 1585
	--[[
		Upvalues:
			[1] = u8
	--]]
	if u8 ~= nil then
		UpdateWorldMailbox();
	end
end);
m_Library.Network.Fired("Inbox Updated"):Connect(function(p12) -- Line: 1592
	UpdateInbox(p12);
	Update();
	UpdateWorldMailbox();
end);
m_Library.Network.Fired("Outbox Updated"):Connect(function() -- Line: 1598
	UpdateOutboxLazy(true);
	UpdatePets();
	Update();
	Close();
end);
m_Library.RunService.Heartbeat:Connect(function() -- Line: 1605
	UpdateOutbox();
end);
local t_Input6 = t_Mailbox.Gui.Frame.GiftPet.Container.Inventory.Bottom.BalanceInput.Display.Input;
m_Library.RunService.Heartbeat:Connect(function(p13) -- Line: 1610
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Mailbox
			[3] = bool9
			[4] = bool10
			[5] = u9
			[6] = t_Input6
	--]]
	if not m_Library.Variables.Console then return end
	if t_Mailbox.Gui.Frame.GiftPet.Visible and (bool9 or bool10) then
		u9 = u9 + p13;
		local math_pow_ret = math.pow(10, (math.floor(u9 / 3)));
		local v28 = t_Input6:GetAttribute("Amount") or 0;
		if bool9 then
			v28 = v28 - math_pow_ret * 1;
			if v28 < 10 then
				v28 = 0;
			end
		elseif bool10 then
			v28 = v28 + math_pow_ret * 1;
			if v28 < 10 then
				v28 = 10;
			end
		end
		if (bool10 or bool9) and (v28 > 0 or v28 == 0) then
			t_Input6.PlaceholderText = v28 > 0 and v28 or "None";
			t_Input6.Text = m_Library.Functions.Commas(v28);
			t_Input6:SetAttribute("Amount", v28);
		end
	end
end);
Update();
UpdateInbox();
UpdateOutboxLazy();
UpdateWorldMailbox();
