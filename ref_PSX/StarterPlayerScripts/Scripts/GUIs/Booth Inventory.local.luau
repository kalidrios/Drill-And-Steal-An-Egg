-- https://github.com/kalidrios

local _ = {
	"rbxassetid://6907636858",
	"rbxassetid://6907636843"
};
local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_BoothInventory = m_Library.GUI.BoothInventory;
local t_Inventory = m_Library.Assets.UI.Inventory;
local Random_new_ret = Random.new();
local bool1 = false;
local u1 = 0;
local u2 = nil;
local u3 = false;
function Update(p1, p2) -- Line: 26
	--[[
		Upvalues:
			[1] = u2
			[2] = t_BoothInventory
			[3] = m_Library
			[4] = u3
			[5] = u1
			[6] = t_Inventory
			[7] = bool1
			[8] = Random_new_ret
	--]]
	if not p1 then
		p1 = u2;
		if not p1 then
			t_BoothInventory.Gui.Enabled = false;
			return;
		end
	end
	local v1 = m_Library.Save.Get();
	local u5;
	local u4;
	if p2 then
		u4 = p1;
		u5 = p2;
	else
        u4, u5 = m_Library.Network.Invoke("Get Booth Data By Id", p1);
        if not u4 then
			m_Library.Print("Failed to grab booth", true);
			return;
		end
	end
	if not u5 then
		t_BoothInventory.Gui.Enabled = false;
		return;
	end
	u3 = u5.Owner == m_Library.LocalPlayer.UserId;
	local table1 = {};
	for key1, _ in pairs(u5.Listings) do
		local v13 = m_Library.PetCmds.Get(key1);
		table.insert(table1, v13);
	end
	u2 = u4;
	local _ = u1 == 0;
	u1 = u1 + 1;
	local v14;
	if t_BoothInventory.Query.Text == "" then
		v14 = false;
	else
		v14 = tostring(t_BoothInventory.Query.Text) ~= nil;
	end
	local v2 = v14 and m_Library.Functions.RegexEscape(string.lower(tostring(t_BoothInventory.Query.Text))) or nil;
	t_BoothInventory.PetAmount.Text = #table1 .. (#table1 <= 1 and " Brainrot" or " Brainrots");
	local v3 = u3 and t_BoothInventory.Main.YourPets or t_BoothInventory.Main.PlayerPets;
	if u3 then
		t_BoothInventory.Main.YourPets.Visible = true;
		t_BoothInventory.Main.PlayerPets.Visible = false;
		t_BoothInventory.Gui.Frame.Title.Text = "My Booth!";
	else
		t_BoothInventory.Main.PlayerPets.Visible = true;
		t_BoothInventory.Main.YourPets.Visible = false;
		t_BoothInventory.Gui.Frame.Title.Text = "Their Booth!";
	end
	local t_PetHolderTemplate = v3.PetHolderTemplate;
	t_PetHolderTemplate.Visible = false;
	for _, child2 in ipairs(v3:GetChildren()) do
		if not child2:GetAttribute("PetId") or u5.Listings[child2:GetAttribute("PetId")] then continue end
		child2:Destroy();
	end
	local v4 = 0;
	local v5 = m_Library.Shared.SortPets(v1, table1);
	for key3, val3 in ipairs(v5) do
		local t_uid = val3.uid;
		local t_id = val3.id;
		local _ = val3.idt;
		local _ = m_Library.Shared.HasPetEquipped(v1, val3);
		local _ = val3.s;
		local t_g = val3.g;
		local t_r = val3.r;
		local t_dm = val3.dm;
		local t_powers = val3.powers;
		local v15 = m_Library.Directory.Pets[t_id];
		local _ = v15.isGift;
		if not t_g or not v15.goldenThumbnail then
			local _ = v15.thumbnail;
		end
		local t_name = v15.name;
		local t_rarity = v15.rarity;
		local t_sh = val3.sh;
		local t_l = val3.l;
		local v16 = v3:FindFirstChild(t_uid);
		local t_Price = u5.Listings[t_uid].Price;
		if not v16 then
			v16 = t_PetHolderTemplate:Clone();
			v16.Pet:Destroy();
			v16:SetAttribute("PetId", t_uid);
			v16.Name = t_uid;
			v16.LayoutOrder = v4;
			v4 = v4 + 1;
			local Clone_ret2 = t_Inventory.Pet:Clone();
			Clone_ret2.Visible = true;
			m_Library.PetUI.Create(Clone_ret2, t_uid);
			Clone_ret2.Parent = v16;
			if u3 then
				local Remove = v16:FindFirstChild("Remove");
				Remove.Activated:Connect(function() -- Line: 161
					--[[
						Upvalues:
							[1] = bool1
							[2] = m_Library
							[3] = t_uid
							[4] = Random_new_ret
							[5] = u4
					--]]
					if not bool1 then
						bool1 = true;
						local v22 = m_Library.Message.New("Are you sure you want to remove this pet from sale?", true);
						if v22 then
							local v23, v24 = m_Library.Network.Invoke("Remove Trading Booth Pet", t_uid);
							if not v23 then
								m_Library.Message.New(v24);
							else
								m_Library.Audio.Play("rbxassetid://7139317909", script, Random_new_ret:NextNumber(0.95, 1.05), 0.75);
							end
							Update(u4);
						end
						bool1 = false;
					end
				end);
				local Buy2 = v16:FindFirstChild("Buy");
				Buy2.Cost.Text = m_Library.Functions.NumberShorten(t_Price);
				Buy2.HoverImage = "";
				Buy2.PressedImage = "";
				m_Library.GUIFX.ButtonFX(Remove);
			else
				local Buy = v16:FindFirstChild("Buy");
				Buy.Cost.Text = m_Library.Functions.NumberShorten(t_Price);
				Buy.Activated:Connect(function() -- Line: 191
					--[[
						Upvalues:
							[1] = bool1
							[2] = u4
							[3] = t_uid
							[4] = val3
							[5] = t_Price
					--]]
					if not bool1 then
						bool1 = true;
						AttemptBuy(u4, t_uid, val3, t_Price);
						bool1 = false;
					end
				end);
				m_Library.GUIFX.ButtonFX(Buy);
			end
			m_Library.GUIFX.ButtonFX(Clone_ret2);
		else
			v16.LayoutOrder = v4;
			v4 = v4 + 1;
		end
		local WaitForChild_ret = v16:WaitForChild(t_uid);
		WaitForChild_ret.Equipped.Visible = false;
		WaitForChild_ret:SetAttribute("Tick", u1);
		WaitForChild_ret.LayoutOrder = key3;
		WaitForChild_ret.Level:FindFirstChildOfClass("UIStroke").Thickness = 4;
		WaitForChild_ret.HC:FindFirstChildOfClass("UIStroke").Thickness = 4;
		WaitForChild_ret.DeleteOverlay.Visible = false;
		WaitForChild_ret.PetIcon.ImageTransparency = 0;
		WaitForChild_ret.Locked.Visible = false;
		WaitForChild_ret.Stars.Visible = true;
		if v14 then
			local bool2 = false;
			if string.find(string.lower(t_name), v2, 1, true) then
				bool2 = true;
			elseif val3.nk and string.find(string.lower(val3.nk), v2, 1, true) then
				bool2 = true;
			elseif string.find(string.lower(t_rarity), v2, 1, true) then
				bool2 = true;
			elseif t_sh and string.find("shiny", v2, 1, true) then
				bool2 = true;
			elseif t_g and (string.find("gold", v2, 1, true) or string.find("golden", v2, 1, true)) then
				bool2 = true;
			elseif t_r and string.find("rainbow", v2, 1, true) then
				bool2 = true;
			elseif t_dm and string.find("dark matter", v2, 1, true) then
				bool2 = true;
			elseif t_l and string.find("lock", v2, 1, true) then
				bool2 = true;
			elseif t_powers and #t_powers > 0 then
				for _, val5 in ipairs(t_powers) do
					local unpack_ret1, unpack_ret2 = unpack(val5);
					local v25, _ = m_Library.Shared.GetPowerDir(unpack_ret1, unpack_ret2);
					if not string.find(string.lower(v25.title), v2, 1, true) then continue end
					bool2 = true;
					break;
				end
			end
			v16.Visible = bool2;
		else
			v16.Visible = true;
		end
		v16.Parent = v3;
	end
	if u3 then
		local t_PetAddTemplate = v3.PetAddTemplate;
		t_PetAddTemplate.Visible = false;
		if v3:FindFirstChild("PetAddButton") then
			v3:FindFirstChild("PetAddButton"):Destroy();
		end
		local Clone_ret = t_PetAddTemplate:Clone();
		Clone_ret.Name = "PetAddButton";
		Clone_ret.Visible = true;
		Clone_ret.Add.Activated:Connect(function() -- Line: 276
			--[[
				Upvalues:
					[1] = m_Library
					[2] = u5
			--]]
			m_Library.Signal.Invoke("Select Booth Pet", u5);
		end);
		Clone_ret.Parent = v3;
		m_Library.GUIFX.ButtonFX(Clone_ret.Add);
	end
	t_BoothInventory.Bottom.Customize.Visible = u3;
	t_BoothInventory.Bottom.Exit.Visible = u3;
	t_BoothInventory.Bottom.Search.Size = UDim2.new(u3 and 0.7 or 0.95, 0, 0.7, 0);
	UpdateScrolling();
end
function UpdateScrolling() -- Line: 298
	--[[
		Upvalues:
			[1] = u3
			[2] = t_BoothInventory
			[3] = m_Library
	--]]
	local v6 = u3 and t_BoothInventory.Main.YourPets or t_BoothInventory.Main.PlayerPets;
	local UIGridLayout = v6:FindFirstChildOfClass("UIGridLayout");
	local UIPadding = v6:FindFirstChildOfClass("UIPadding");
	local v7 = m_Library.Functions.ResolutionScale();
	local v8 = v7 <= 0.5 and 4 or v7 <= 0.65 and 5 or v7 <= 1 and 6 or v7 <= 1.2 and 7 or 8;
	if m_Library.Variables.Mobile then
		v8 = v8 + 1;
	end
	UIGridLayout.CellPadding = UDim2.new(0, 20, 0, 20);
	local v9 = (v6.AbsoluteSize.X - v6.ScrollBarThickness - UIPadding.PaddingLeft.Offset - UIPadding.PaddingRight.Offset) / v8 - UIGridLayout.CellPadding.X.Offset;
	local _ = UDim2.new(0, v9, 0, v9);
	UIGridLayout:ApplyLayout();
	v6.CanvasSize = UDim2.new(0, UIGridLayout.AbsoluteContentSize.X, 0, UIGridLayout.AbsoluteContentSize.Y + 65);
end
function GetFullName(p3) -- Line: 332
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local str1 = "";
	local t_name2 = m_Library.Directory.Pets[p3.id].name;
	local t_g2 = p3.g;
	local t_r2 = p3.r;
	local t_dm2 = p3.dm;
	if t_g2 then
		str1 = "Golden ";
	elseif t_r2 then
		str1 = "Rainbow ";
	elseif t_dm2 then
		str1 = "Dark Matter ";
	end
	return str1 .. t_name2;
end
local table2 = {};
function ThrottleRequest(p4, p5) -- Line: 357
	--[[
		Upvalues:
			[1] = table2
	--]]
	if table2[p4] then
		return true;
	end
	table2[p4] = true;
	task.delay(p5 or 1, function() -- Line: 364
		--[[
			Upvalues:
				[1] = table2
				[2] = p4
		--]]
		table2[p4] = nil;
	end);
	return false;
end
function AttemptBuy(p6, p7, p8, p9) -- Line: 371
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v10 = m_Library.Save.Get();
	if not v10 then return end
	if v10.Diamonds < p9 then
		m_Library.Message.New("You don't have enough Diamonds to buy this!");
		return;
	end
	if ThrottleRequest("AttemptBuy", 7) then
		m_Library.Message.New("You are doing this too fast!");
		return;
	end
	local v11 = m_Library.Directory.Pets[p8.id];
	local math_ceil_ret = math.ceil(m_Library.Signal.Invoke("Get Booth By Id", p6).Listings[p7].Timestamp + 3 - workspace:GetServerTimeNow());
	if math_ceil_ret > 0 and (v11.isGift and m_Library.Message.New("Would you like to buy this " .. GetFullName(p8) .. " for " .. m_Library.Functions.Commas(p9) .. " Diamonds?", true, math_ceil_ret) or m_Library.Message.New("Would you like to buy this " .. GetFullName(p8) .. " pet for " .. m_Library.Functions.Commas(p9) .. " Diamonds?", true, math_ceil_ret)) or v11.isGift and m_Library.Message.New("Would you like to buy this " .. GetFullName(p8) .. " for " .. m_Library.Functions.Commas(p9) .. " Diamonds?", true) or m_Library.Message.New("Would you like to buy this " .. GetFullName(p8) .. " pet for " .. m_Library.Functions.Commas(p9) .. " Diamonds?", true) then
		local v17, v18 = m_Library.Network.Invoke("Purchase Trading Booth Pet", p6, p7);
		if not v17 then
			m_Library.Message.New(v18);
			return;
		end
		m_Library.Signal.Fire("Notification", "Success! \226\156\133", {
			color = Color3.fromRGB(105, 255, 168),
			sound = "rbxassetid://11648890466"
		});
	end
	Update(p6);
end
t_BoothInventory.Frame.Bottom.Search.Query:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 427
	--[[
		Upvalues:
			[1] = u3
			[2] = t_BoothInventory
			[3] = u2
	--]]
	local v12 = u3 and t_BoothInventory.Main.YourPets or t_BoothInventory.Main.PlayerPets;
	if t_BoothInventory.Frame.Bottom.Search.Query.Text ~= "" then
		v12.CanvasPosition = Vector2.new();
	end
	Update(u2);
end);
t_BoothInventory.Close.Activated:Connect(function() -- Line: 436
	--[[
		Upvalues:
			[1] = bool1
			[2] = m_Library
			[3] = Random_new_ret
			[4] = t_BoothInventory
	--]]
	if not bool1 then
		bool1 = true;
		m_Library.Audio.Play("rbxassetid://8951380772", script, Random_new_ret:NextNumber(0.95, 1.05), 0.1);
		t_BoothInventory.Gui.Enabled = false;
		bool1 = false;
	end
end);
t_BoothInventory.Bottom.Customize.Activated:Connect(function() -- Line: 446
	--[[
		Upvalues:
			[1] = bool1
			[2] = u3
			[3] = m_Library
	--]]
	if not bool1 and u3 then
		bool1 = true;
		m_Library.Signal.Fire("Customize Booth");
		bool1 = false;
	end
end);
t_BoothInventory.Bottom.Exit.Activated:Connect(function() -- Line: 455
	--[[
		Upvalues:
			[1] = bool1
			[2] = u3
			[3] = t_BoothInventory
			[4] = m_Library
	--]]
	if not bool1 and u3 then
		bool1 = true;
		t_BoothInventory.Gui.Enabled = false;
		local v19 = m_Library.Message.New("Are you sure you want to leave your booth?", true);
		if v19 then
			local v20, v21 = m_Library.Network.Invoke("Unclaim Trading Booth");
			if not v20 then
				m_Library.Message.New(v21);
			end
		end
		bool1 = false;
	end
end);
m_Library.Signal.Fired("Resolution Changed"):Connect(function() -- Line: 472
	task.defer(function() -- Line: 473
		UpdateScrolling();
	end);
end);
m_Library.Signal.Fired("Window Opened"):Connect(function(p10) -- Line: 479
	--[[
		Upvalues:
			[1] = t_BoothInventory
	--]]
	if p10 == t_BoothInventory.Gui then
		Update();
	end
end);
m_Library.Signal.Fired("Window Closed"):Connect(function(p11) -- Line: 485
	--[[
		Upvalues:
			[1] = t_BoothInventory
			[2] = u2
			[3] = u3
	--]]
	if p11 == t_BoothInventory.Gui then
		u2 = nil;
		u3 = false;
	end
end);
m_Library.Signal.Fired("Show Booth"):Connect(function(p12) -- Line: 492
	--[[
		Upvalues:
			[1] = t_BoothInventory
	--]]
	Update(p12);
	t_BoothInventory.Gui.Enabled = true;
end);
m_Library.GUIFX.ButtonFX(t_BoothInventory.Close);
m_Library.GUIFX.ButtonFX(t_BoothInventory.Bottom.Customize);
m_Library.GUIFX.ButtonFX(t_BoothInventory.Bottom.Exit);
m_Library.GUIFX.ButtonFX(t_BoothInventory.Add);
m_Library.GUIFX.Tooltip(t_BoothInventory.Bottom.Customize, "Customize Booth");
m_Library.GUIFX.Tooltip(t_BoothInventory.Bottom.Exit, "Exit Booth");
m_Library.Network.Fired("Trade Booth Updated"):Connect(function(p13, p14) -- Line: 514
	--[[
		Upvalues:
			[1] = u2
			[2] = m_Library
	--]]
	if u2 and u2 == p13 then
		local function waitForPets(p16, p17) -- Line: 516
			--[[
				Upvalues:
					[1] = m_Library
					[2] = waitForPets
			--]]
			if p17 and p17 > 4 then return end
			for key4, _ in pairs(p16.Listings) do
				if m_Library.PetCmds.Get(key4) then continue end
				if not p17 then
					p17 = 0;
				end
				p17 = p17 + 1;
				task.delay(0.1, waitForPets, p16, p17);
				return;
			end
		end
		waitForPets(p14);
		Update(u2, p14);
	end
end);
m_Library.Network.Fired("Trading Booth Unclaimed"):Connect(function(p15) -- Line: 538
	--[[
		Upvalues:
			[1] = u2
			[2] = t_BoothInventory
	--]]
	if u2 == p15 then
		t_BoothInventory.Gui.Enabled = false;
	end
end);
