-- https://github.com/kalidrios

local _ = {
	"rbxassetid://6907636858",
	"rbxassetid://6907636843"
};
local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_IsHardcore = m_Library.Shared.IsHardcore;
local t_Inventory = m_Library.GUI.Inventory;
local t_Inventory2 = m_Library.Assets.UI.Inventory;
local Random_new_ret = Random.new();
local bool1 = false;
local u1 = false;
local u2 = 0;
local u3 = false;
local table1 = {};
local u4 = false;
local u5 = false;
local table2 = {};
local bool2 = true;
local table3 = {};
local u6 = 0;
local u7 = 0;
function isVisible() -- Line: 40
	--[[
		Upvalues:
			[1] = t_Inventory
	--]]
	return t_Inventory.Gui.Enabled;
end
function UpdatePetsEquipped() -- Line: 46
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v1 = m_Library.Save.Get();
	if v1 then
		local t_Inventory3 = m_Library.GUI.Main.Bottom.Inventory;
		local v30 = #m_Library.PetCmds.GetEquipped();
		local MaxEquippedSlots = m_Library.Shared.GetMaxEquippedSlots(v1);
		if v1.InfPetsEnabled then
			t_Inventory3.Equipped.Text = v30 .. "/" .. "\226\136\158";
			return;
		end
		t_Inventory3.Equipped.Text = v30 .. "/" .. MaxEquippedSlots;
	end
end
function UpdateLazy() -- Line: 60
	--[[
		Upvalues:
			[1] = bool2
	--]]
	bool2 = true;
end
function computePetsPerRow(p1) -- Line: 64
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
	--]]
	local v2 = m_Library.Functions.ResolutionScale();
	local v3 = v2 <= 0.5 and 4 or v2 <= 0.65 and 5 or v2 <= 1 and 6 or v2 <= 1.2 and 7 or 8;
	if p1 then
		v3 = math.floor(v3 / 2);
	end
	if u1 then
		v3 = v3 * 2;
	end
	return v3;
end
function doEmptySlots(p2, p3) -- Line: 91
	--[[
		Upvalues:
			[1] = t_Inventory2
	--]]
	local v4 = 0;
	for _, child1 in ipairs(p2:GetChildren()) do
		if child1.Name ~= "Empty" then continue end
		v4 = v4 + 1;
	end
	local v5 = p3 - v4;
	if v5 > 0 then
		for index1 = 1, v5 do
			t_Inventory2.Empty:Clone().Parent = p2;
		end
	elseif v5 < 0 then
		for index2 = 1, -v5 do
			local Empty = p2:FindFirstChild("Empty");
			if not Empty then break end
			Empty:Destroy();
		end
	end
end
function Update() -- Line: 118
	--[[
		Upvalues:
			[1] = bool2
			[2] = m_Library
			[3] = u2
			[4] = table3
			[5] = t_Inventory
			[6] = u6
			[7] = u7
			[8] = t_Inventory2
			[9] = u4
			[10] = u3
			[11] = table1
			[12] = t_IsHardcore
			[13] = Random_new_ret
			[14] = u5
			[15] = table2
			[16] = bool1
			[17] = u1
	--]]
	if not bool2 then return end
	if not isVisible() then return end
	local u11 = m_Library.Save.Get();
	if not u11 then return end
	assert(u11);
	local t_Pets = u11.Pets;
	if not t_Pets then
		m_Library.Print("Failed to grab pets", true);
		return;
	end
	bool2 = false;
	debug.profilebegin("Inventory.Update");
	local v6 = u2 == 0;
	u2 = u2 + 1;
	local table4 = {};
	for _, val2 in ipairs(t_Pets) do
		if table3[val2.uid] then continue end
		table.insert(table4, val2);
	end
	local v7 = m_Library.Shared.SortPets(u11, table4);
	local v31;
	if t_Inventory.Query.Text == "" then
		v31 = false;
	else
		v31 = t_Inventory.Query.Text ~= nil;
	end
	local v8 = v31 and m_Library.Functions.RegexEscape(string.lower(tostring(t_Inventory.Query.Text))) or nil;
	t_Inventory.PetAmount.Text = #v7 .. (#v7 <= 1 and " Brainrot" or " Brainrots");
	u6 = 0;
	u7 = 0;
	for key3, val3 in ipairs(v7) do
		local t_uid = val3.uid;
		local t_id = val3.id;
		local _ = val3.idt;
		local u12 = m_Library.Shared.HasPetEquipped(u11, val3);
		local t_s = val3.s;
		local t_g = val3.g;
		local t_r = val3.r;
		local t_dm = val3.dm;
		local t_powers = val3.powers;
		local u13 = m_Library.Directory.Pets[t_id];
		local t_isGift = u13.isGift;
		if not t_g or not u13.goldenThumbnail then
			local _ = u13.thumbnail;
		end
		local t_name = u13.name;
		local t_rarity = u13.rarity;
		local t_sh = val3.sh;
		local t_l = val3.l;
		local v32 = u13.titanic and t_Inventory.Main.Pets.Titanic or t_Inventory.Main.Pets.Normal;
		local u14 = v32:FindFirstChild(t_uid);
		if not u14 then
			u14 = t_Inventory2.Pet:Clone();
			m_Library.PetUI.Create(u14, t_uid);
			local function RefreshPetData() -- Line: 189
				--[[
					Upvalues:
						[1] = val3
						[2] = m_Library
						[3] = t_uid
						[4] = u12
						[5] = u11
						[6] = t_s
						[7] = t_g
						[8] = t_r
						[9] = t_dm
				--]]
				debug.profilebegin("Inventory.Update.RefreshPetData");
				val3 = m_Library.PetCmds.Get(t_uid);
				if not val3 or type(val3) ~= 'table' then -- WTF????
					warn(val3, t_uid)
					return
				end
				u12 = m_Library.Shared.HasPetEquipped(u11, val3);
				t_s = val3.s;
				t_g = val3.g;
				t_r = val3.r;
				t_dm = val3.dm;
				debug.profileend();
			end
			local function Clicked() -- Line: 200
				--[[
					Upvalues:
						[1] = RefreshPetData
						[2] = u4
						[3] = t_isGift
						[4] = m_Library
						[5] = t_uid
						[6] = u3
						[7] = table1
						[8] = val3
						[9] = u13
						[10] = t_IsHardcore
						[11] = u11
						[12] = Random_new_ret
						[13] = u5
						[14] = table2
						[15] = u12
				--]]
				RefreshPetData();
				if u4 and not t_isGift then
					u4 = false;
					UpdateBottom();
					m_Library.Signal.Invoke("Rename Pet", t_uid);
					return;
				end
				if not u3 then
					if not u5 or t_isGift then
						if t_isGift then
							local v54 = m_Library.Signal.Invoke("Is Trading Booth Pet", t_uid);
							if v54 then
								m_Library.Message.New("This box is currently in your trading booth! Remove it before you can open it!");
								return;
							end
							OpenGift(t_uid);
							return;
						end
						if u12 then
							local v55, v56 = m_Library.Network.Invoke("Unequip Pet", t_uid);
							if not v55 then
								m_Library.Message.New(v56 or "Something went wrong. Try again!");
								return;
							end
							m_Library.PetCmds.LocalEquipPet(m_Library.LocalPlayer, t_uid, false);
							m_Library.Audio.Play("rbxassetid://8863194418", script, Random_new_ret:NextNumber(0.95, 1.05), 0.75);
							return;
						end
						local v52, v53 = m_Library.Network.Invoke("Equip Pet", t_uid);
						if not v52 then
							m_Library.Message.New(v53 or "Something went wrong. Try again!");
							return;
						end
						m_Library.PetCmds.LocalEquipPet(m_Library.LocalPlayer, t_uid, true);
						m_Library.Audio.Play("rbxassetid://8863194499", script, Random_new_ret:NextNumber(0.95, 1.05), 0.75);
						return;
					end
					local v50 = m_Library.Signal.Invoke("Is Trading Booth Pet", t_uid);
					if v50 then
						m_Library.Message.New("This pet is currently in your trading booth! Remove it before you can lock it!");
						return;
					end
					if table2[t_uid] ~= nil then
						table2[t_uid] = nil;
					else
						table2[t_uid] = not val3.l;
					end
					local function locked() -- Line: 260
						--[[
							Upvalues:
								[1] = table2
								[2] = t_uid
								[3] = val3
						--]]
						if table2[t_uid] ~= nil then
							return table2[t_uid];
						end
						return val3.l == true;
					end
					m_Library.Audio.Play((table2[t_uid] == nil and val3.l == true or table2[t_uid]) and "rbxassetid://11524408229" or "rbxassetid://11524408191", script);
					UpdateBottom();
					return;
				end
				if not m_Library.Functions.SearchArray(table1, t_uid) then
					if val3.l then
						m_Library.Message.New("This pet is locked! Unlock it before you can delete it!");
						return;
					end
					if u13.huge and (t_IsHardcore and u11.Hardcore.World == "Diamond Mine" or u11.World == "Diamond Mine") then
						m_Library.Message.New("This is not how you release a pet! Go to the gate!");
						return;
					end
					local v51 = m_Library.Signal.Invoke("Is Trading Booth Pet", t_uid);
					if v51 then
						m_Library.Message.New("This pet is currently in your trading booth! Remove it before you can delete it!");
						return;
					end
					table.insert(table1, t_uid);
					m_Library.Audio.Play("rbxassetid://7139317934", script, Random_new_ret:NextNumber(0.95, 1.05), 0.75);
				else
					for key19, val19 in ipairs(table1) do
						if val19 ~= t_uid then continue end
						table.remove(table1, key19);
						m_Library.Audio.Play("rbxassetid://7139317909", script, Random_new_ret:NextNumber(0.95, 1.05), 0.75);
						break;
					end
				end
				UpdateBottom();
			end
			local function NewAnimation() -- Line: 313
				--[[
					Upvalues:
						[1] = u14
						[2] = t_Inventory
						[3] = u3
				--]]
				local u18 = 0;
				local Connect_ret = nil;
				Connect_ret = game:GetService("RunService").RenderStepped:Connect(function(p15) -- Line: 318
					--[[
						Upvalues:
							[1] = u14
							[2] = t_Inventory
							[3] = u18
							[4] = Connect_ret
							[5] = u3
					--]]
					if not u14 or not u14.Parent or not u14.PetIcon or not u14:GetAttribute("isVisible") or not t_Inventory.Gui.Enabled then return end
					u18 = u18 + p15;
					if u18 < 4 then
						local v57 = math.sin(u18 / 4 * math.pi * 6) / 2;
						u14.PetIcon.ImageTransparency = math.abs(v57);
						return;
					end
					Connect_ret:Disconnect();
					if not u3 then
						u14.PetIcon.ImageTransparency = 0;
					end
				end);
			end
			if not v6 then
				local Attribute3 = u14:GetAttribute("HasNewAnimated");
				if not Attribute3 then
					u14:SetAttribute("HasNewAnimated", true);
					task.spawn(NewAnimation);
				end
			end
			u14.Activated:Connect(function() -- Line: 376
				--[[
					Upvalues:
						[1] = bool1
						[2] = Clicked
				--]]
				if not bool1 then
					bool1 = true;
					Clicked();
					UpdateLazy();
					bool1 = false;
				end
			end);
			m_Library.GUIFX.ButtonFX(u14);
		end
		u14.Equipped.Visible = u12;
		u14:SetAttribute("Tick", u2);
		u14.LayoutOrder = key3;
		u14.Level:FindFirstChildOfClass("UIStroke").Thickness = u1 and 2 or 4;
		u14.HC:FindFirstChildOfClass("UIStroke").Thickness = u1 and 2 or 4;
		if u3 then
			local v43 = m_Library.Functions.SearchArray(table1, t_uid);
			u14.DeleteOverlay.Visible = v43;
			u14.PetIcon.ImageTransparency = v43 and 0 or 0.5;
		else
			u14.DeleteOverlay.Visible = false;
			u14.PetIcon.ImageTransparency = 0;
		end
		local function shouldLock() -- Line: 405
			--[[
				Upvalues:
					[1] = table2
					[2] = t_uid
					[3] = val3
			--]]
			if table2[t_uid] ~= nil then
				return table2[t_uid];
			end
			return val3.l == true;
		end
		u14.Locked.Visible = table2[t_uid] == nil and val3.l == true or table2[t_uid];
		u14.Stars.Visible = not u14.Locked.Visible;
		local bool3 = false;
		if v31 then
			assert(v8);
			if string.find(string.lower(t_name), v8, 1, true) then
				bool3 = true;
			elseif val3.nk and string.find(string.lower(val3.nk), v8, 1, true) then
				bool3 = true;
			elseif string.find(string.lower(t_rarity), v8, 1, true) then
				bool3 = true;
			elseif t_sh and string.find("shiny", v8, 1, true) then
				bool3 = true;
			elseif t_g and (string.find("gold", v8, 1, true) or string.find("golden", v8, 1, true)) then
				bool3 = true;
			elseif t_r and string.find("rainbow", v8, 1, true) then
				bool3 = true;
			elseif t_dm and string.find("dark matter", v8, 1, true) then
				bool3 = true;
			elseif t_l and string.find("lock", v8, 1, true) then
				bool3 = true;
			elseif t_powers and #t_powers > 0 then
				for _, val20 in ipairs(t_powers) do
					local unpack_ret1, unpack_ret2 = unpack(val20);
					local v58, _ = m_Library.Shared.GetPowerDir(unpack_ret1, unpack_ret2);
					if not string.find(string.lower(v58.title), v8, 1, true) then continue end
					bool3 = true;
					break;
				end
			end
		else
			bool3 = true;
		end
		u14.Visible = bool3;
		if bool3 then
			if not u13.titanic then
				u6 = u6 + 1;
			else
				u7 = u7 + 1;
			end
		end
		u14.Parent = v32;
	end
	for _, child4 in ipairs(t_Inventory.Main.Pets.Normal:GetChildren()) do
		local Attribute2 = child4:GetAttribute("Tick");
		if not Attribute2 or Attribute2 == u2 then continue end
		child4:Destroy();
	end
	for _, child5 in ipairs(t_Inventory.Main.Pets.Titanic:GetChildren()) do
		local Attribute = child5:GetAttribute("Tick");
		if not Attribute or Attribute == u2 then continue end
		child5:Destroy();
	end
	t_Inventory.Main.Pets.Titanic.Visible = u7 > 0;
	local v9 = u11.MaxSlots - #v7;
	doEmptySlots(t_Inventory.Main.Pets.Normal, v9);
	local computePetsPerRow_ret = computePetsPerRow(true);
	local v10 = math.ceil(u7 / computePetsPerRow_ret) * computePetsPerRow_ret - u7;
	doEmptySlots(t_Inventory.Main.Pets.Titanic, v10);
	UpdateScrolling();
	UpdatePetsEquipped();
	UpdateEquipButtons();
	debug.profileend();
end
function UpdateScrolling0(p4, p5) -- Line: 498
	--[[
		Upvalues:
			[1] = u1
	--]]
	debug.profilebegin("Inventory.UpdateScrolling");
	local UIGridLayout = p4:FindFirstChildOfClass("UIGridLayout");
	local UIPadding = p4:FindFirstChildOfClass("UIPadding");
	local computePetsPerRow_ret2 = computePetsPerRow(p5);
	local v11 = 1;
	if not u1 then
		v11 = v11 * 2;
	end
	if p5 then
		v11 = v11 * 2;
	end
	UIGridLayout.CellPadding = UDim2.new(0, v11 * 10, 0, v11 * 10);
	local math_floor_ret = math.floor((p4.AbsoluteSize.X - UIPadding.PaddingLeft.Offset - UIPadding.PaddingRight.Offset - 1 - UIGridLayout.CellPadding.X.Offset * (computePetsPerRow_ret2 - 1)) / computePetsPerRow_ret2);
	local udim2 = UDim2.new(0, math_floor_ret, 0, math_floor_ret);
	UIGridLayout.CellSize = udim2;
	UIGridLayout:ApplyLayout();
	local t_AbsoluteContentSize = UIGridLayout.AbsoluteContentSize;
	debug.profileend();
	return t_AbsoluteContentSize;
end
function UpdateScrolling() -- Line: 527
	--[[
		Upvalues:
			[1] = t_Inventory
			[2] = u1
	--]]
	local t_Pets2 = t_Inventory.Main.Pets;
	local UIListLayout = t_Pets2:FindFirstChildOfClass("UIListLayout");
	local UIPadding2 = t_Pets2:FindFirstChildOfClass("UIPadding");
	local v12 = 1 * 2;
	if not u1 then
		v12 = v12 * 2;
	end
	local UDim_new_ret = UDim.new(0, v12 * 10);
	local function update() -- Line: 539
		--[[
			Upvalues:
				[1] = t_Pets2
				[2] = UIPadding2
				[3] = UDim_new_ret
		--]]
		local UpdateScrolling0_ret = UpdateScrolling0(t_Pets2:FindFirstChild("Normal"), false);
		local UpdateScrolling0_ret2 = UpdateScrolling0(t_Pets2:FindFirstChild("Titanic"), true);
		local math_max_ret = math.max(UpdateScrolling0_ret.X, UpdateScrolling0_ret2.X);
		local v39 = UpdateScrolling0_ret.Y + UpdateScrolling0_ret2.Y + UIPadding2.PaddingTop.Offset + UIPadding2.PaddingBottom.Offset + UDim_new_ret.Offset;
		t_Pets2.CanvasSize = UDim2.new(0, math_max_ret, 0, v39);
	end
	if UIListLayout.Padding ~= UDim_new_ret then
		UIListLayout.Padding = UDim_new_ret;
		task.defer(update);
		return;
	end
	update();
end
function UpdateBottom() -- Line: 557
	--[[
		Upvalues:
			[1] = t_Inventory
			[2] = u3
			[3] = table1
			[4] = m_Library
			[5] = table2
			[6] = u5
			[7] = u1
			[8] = u4
	--]]
	debug.profilebegin("Inventory.UpdateBottom");
	t_Inventory.Bottom.MultiDelete.Image = u3 and "rbxassetid://92728388326404" or "rbxassetid://115466612777351";
	t_Inventory.Bottom.VerifyDelete.Visible = u3;
	local v14 = #table1 > 0;
	t_Inventory.Bottom.VerifyDelete.Label.Text = v14 and "Delete" or "Cancel";
	t_Inventory.Bottom.VerifyDelete.Image = v14 and "rbxassetid://131186641922862" or "rbxassetid://107819359453310";
	t_Inventory.Bottom.VerifyDelete.HoverImage = v14 and "rbxassetid://131186641922862" or "rbxassetid://131987204292501";
	local v15 = m_Library.Functions.DictionaryLength(table2) > 0;
	t_Inventory.Bottom.VerifyLock.Label.Text = v15 and "Confirm" or "Cancel";
	t_Inventory.Bottom.VerifyLock.Image = v15 and "rbxassetid://131186641922862" or "rbxassetid://107819359453310";
	t_Inventory.Bottom.VerifyLock.HoverImage = v15 and "rbxassetid://131186641922862" or "rbxassetid://131987204292501";
	t_Inventory.Bottom.Grid.Visible = not u3 and not u5;
	t_Inventory.Bottom.Rename.Visible = not u3 and not u5;
	t_Inventory.Bottom.MultiDelete.Visible = not u5;
	t_Inventory.Bottom.Lock.Visible = not u3;
	t_Inventory.Bottom.Grid.Image = u1 and "rbxassetid://78913427597194" or "rbxassetid://124631269349457";
	t_Inventory.Bottom.Rename.Image = u4 and "rbxassetid://104813878010890" or "rbxassetid://137252269984746";
	t_Inventory.Bottom.Lock.Image = u5 and "rbxassetid://112449822420798" or "rbxassetid://139579752301476";
	t_Inventory.Bottom.VerifyLock.Visible = u5;
	UpdateLazy();
	debug.profileend();
end
local bool4 = false;
local table5 = {};
local u8 = nil;
local u9 = nil;
local u10 = nil;
function updateInventoryDrag(p6, p7, p8, p9) -- Line: 599
	--[[
		Upvalues:
			[1] = t_Inventory
			[2] = m_Library
			[3] = bool4
			[4] = table5
			[5] = u3
			[6] = table1
			[7] = u5
			[8] = table2
	--]]
	if not t_Inventory.Gui.Enabled then return end
	if m_Library.Variables.MessageOpen then return end
	if not m_Library.FFlags.Get(m_Library.FFlags.Keys.DragDelete) then return end
	if not m_Library.FFlags.Get(m_Library.FFlags.Keys.InventoryDragDelete) then return end
	if bool4 then return end
	bool4 = true;
	local v16 = t_Inventory.Main.Pets.AbsolutePosition.Y + t_Inventory.Main.Pets.AbsoluteSize.Y;
	local t_Y = t_Inventory.Main.Pets.AbsolutePosition.Y;
	if p7 == p9 then
		p9 = p9 + 1;
	end
	local vec2 = Vector2.new(p6, p7);
	local vec2_2 = Vector2.new(p8, p9);
	local table6 = {};
	for _, child6 in ipairs(t_Inventory.Main.Pets.Normal:GetChildren()) do
		if not child6:isA("TextButton") then continue end
		table.insert(table6, child6);
	end
	for _, child7 in ipairs(t_Inventory.Main.Pets.Titanic:GetChildren()) do
		if not child7:isA("TextButton") then continue end
		table.insert(table6, child7);
	end
	local num1 = nil;
	for _, val8 in ipairs(table5) do
		local t_Name2 = val8.Name;
		local _ = m_Library.PetCmds.Get(t_Name2);
		local t_AbsolutePosition = val8.AbsolutePosition;
		local v33 = t_AbsolutePosition.X or 0;
		local v34 = t_AbsolutePosition.Y or 0;
		if v16 < v34 or v34 < t_Y then continue end
		local t_AbsoluteSize = val8.AbsoluteSize;
		local vec2_5 = Vector2.new(v33, v34);
		local vec2_6 = Vector2.new(v33 + t_AbsoluteSize.X, v34 + t_AbsoluteSize.Y);
		if m_Library.Functions.CheckRectangleIntersection(vec2, vec2_2, vec2_5, vec2_6) then continue end
		if num1 == nil then
			num1 = 1;
		end
		if num1 == 1 then
			if u3 then
				for key17, val17 in ipairs(table1) do
					if val17 ~= t_Name2 then continue end
					table.remove(table1, key17);
					break;
				end
			elseif u5 then
				for key18, _ in pairs(table2) do
					if key18 ~= t_Name2 then continue end
					table2[t_Name2] = nil;
					break;
				end
			end
		end
		table.remove(table5, table.find(table5, val8));
	end
	for _, val9 in ipairs(table6) do
		if table.find(table5, val9) or not val9:GetAttribute("isVisible") or not val9.Visible then continue end
		local t_X = val9.AbsolutePosition.X;
		local t_Y2 = val9.AbsolutePosition.Y;
		local vec2_3 = Vector2.new(t_X, t_Y2);
		local vec2_4 = Vector2.new(t_X + val9.AbsoluteSize.X, t_Y2 + val9.AbsoluteSize.Y);
		local bool5 = false;
		if not m_Library.Functions.CheckRectangleIntersection(vec2, vec2_2, vec2_3, vec2_4) or v16 < t_Y2 + val9.AbsoluteSize.Y / 2 or t_Y2 + val9.AbsoluteSize.Y / 2 < t_Y then continue end
		local t_Name = val9.Name;
		local u15 = m_Library.PetCmds.Get(t_Name);
		if not u15 then continue end
		assert(u15);
		local v35 = m_Library.Directory.Pets[u15.id];
		if u3 then
			if not m_Library.Functions.SearchArray(table1, t_Name) then
				if num1 == nil then
					num1 = 0;
				end
				if num1 == 0 then
					if u15.l or v35.huge or v35.titanic then continue end
					local v48 = m_Library.Signal.Invoke("Is Trading Booth Pet", t_Name);
					if v48 then continue end
					table.insert(table1, t_Name);
					bool5 = true;
				end
			end
		elseif u5 then
			if num1 == nil then
				num1 = 0;
			end
			if num1 == 0 then
				if v35.isGift then continue end
				local v49 = m_Library.Signal.Invoke("Is Trading Booth Pet", t_Name);
				if v49 then continue end
				if table2[t_Name] ~= nil then
					table2[t_Name] = nil;
				else
					table2[t_Name] = not u15.l;
				end
				local function locked() -- Line: 816
					--[[
						Upvalues:
							[1] = table2
							[2] = t_Name
							[3] = u15
					--]]
					if table2[t_Name] ~= nil then
						return table2[t_Name];
					end
					return u15.l == true;
				end
				bool5 = true;
			end
		end
		if not bool5 then continue end
		table.insert(table5, val9);
	end
	UpdateBottom();
	bool4 = false;
end
function newDrag() -- Line: 841
	--[[
		Upvalues:
			[1] = u9
			[2] = u10
			[3] = u8
			[4] = m_Library
	--]]
	assert(u9 and u10);
	local Mouse = game.Players.LocalPlayer:GetMouse();
	local t_X2 = Mouse.X;
	local t_Y3 = Mouse.Y;
	u8 = Instance.new("ScreenGui");
	assert(u8);
	u8.DisplayOrder = 9999;
	u8.Name = "DragUI";
	local Frame = Instance.new("Frame");
	Frame.BackgroundColor3 = Color3.fromRGB(39, 233, 55);
	Frame.Parent = u8;
	u8.Parent = m_Library.LocalPlayer.PlayerGui;
	Frame.Position = UDim2.new(0, u9, 0, u10);
	Frame.Size = UDim2.new(0, t_X2 - u9, 0, t_Y3 - u10);
	Frame.ZIndex = 9999;
	Frame.BackgroundTransparency = 0.5;
end
function updateDrag() -- Line: 861
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u9
			[3] = u10
	--]]
	local DragUI = m_Library.LocalPlayer.PlayerGui:FindFirstChild("DragUI");
	if not DragUI then return end
	local Frame2 = DragUI:FindFirstChild("Frame");
	if not Frame2 then return end
	assert(u9 and u10);
	local Mouse2 = game.Players.LocalPlayer:GetMouse();
	local t_X3 = Mouse2.X;
	local t_Y4 = Mouse2.Y;
	Frame2.Position = UDim2.new(0, u9, 0, u10);
	Frame2.Size = UDim2.new(0, t_X3 - u9, 0, t_Y4 - u10);
end
m_Library.Signal.Fired("Click Drag Complete"):Connect(function() -- Line: 881
	--[[
		Upvalues:
			[1] = table5
	--]]
	table5 = {};
end);
m_Library.Signal.Fired("Click Drag Update"):Connect(updateInventoryDrag);
m_Library.UserInputService.InputBegan:Connect(function(input, gameProcessedEvent) -- Line: 887
	--[[
		Upvalues:
			[1] = u3
			[2] = u5
			[3] = t_Inventory
			[4] = m_Library
			[5] = u9
			[6] = u10
	--]]
	if not u3 and not u5 then return end
	if not t_Inventory.Gui.Enabled then return end
	if m_Library.Variables.MessageOpen then return end
	if not m_Library.FFlags.Get(m_Library.FFlags.Keys.DragDelete) then return end
	if not m_Library.FFlags.Get(m_Library.FFlags.Keys.InventoryDragDelete) then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local Mouse3 = game.Players.LocalPlayer:GetMouse();
		u9 = Mouse3.X;
		u10 = Mouse3.Y;
		m_Library.Signal.Fire("Click Drag Start", u9, u10);
	end
end);
m_Library.UserInputService.InputEnded:Connect(function(input2, gameProcessedEvent2) -- Line: 918
	--[[
		Upvalues:
			[1] = u9
			[2] = u10
			[3] = m_Library
			[4] = u8
	--]]
	if input2.UserInputType == Enum.UserInputType.MouseButton1 then
		local Mouse4 = game.Players.LocalPlayer:GetMouse();
		local t_X4 = Mouse4.X;
		local t_Y5 = Mouse4.Y;
		if u9 and u10 then
			m_Library.Signal.Fire("Click Drag Complete", u9, u10, t_X4, t_Y5);
			if u8 then
				u8:Destroy();
				u8 = nil;
			end
			u9 = nil;
			u10 = nil;
		end
	end
end);
m_Library.UserInputService.InputChanged:Connect(function(input3, gameProcessedEvent3) -- Line: 936
	--[[
		Upvalues:
			[1] = u9
			[2] = u10
			[3] = u8
			[4] = m_Library
	--]]
	if input3.UserInputType == Enum.UserInputType.MouseMovement and u9 and u10 then
		if not u8 then
			newDrag();
			return;
		end
		updateDrag();
		local Mouse5 = game.Players.LocalPlayer:GetMouse();
		local t_X5 = Mouse5.X;
		local t_Y6 = Mouse5.Y;
		m_Library.Signal.Fire("Click Drag Update", u9, u10, t_X5, t_Y6);
	end
end);
function ToggleMultiDelete() -- Line: 955
	--[[
		Upvalues:
			[1] = u3
			[2] = u4
			[3] = u5
			[4] = table2
			[5] = table1
	--]]
	debug.profilebegin("Inventory.ToggleMultiDelete");
	u3 = not u3;
	u4 = false;
	u5 = false;
	table2 = {};
	if not u3 then
		table1 = {};
	end
	UpdateBottom();
	debug.profileend();
end
function ToggleGrid() -- Line: 969
	--[[
		Upvalues:
			[1] = u1
			[2] = m_Library
	--]]
	debug.profilebegin("Inventory.ToggleGrid");
	u1 = not u1;
	m_Library.Audio.Play("rbxassetid://7004248320", script, 1, 0.5);
	UpdateBottom();
	debug.profileend();
end
function ToggleRename() -- Line: 978
	--[[
		Upvalues:
			[1] = u4
			[2] = u3
			[3] = u5
			[4] = table2
	--]]
	debug.profilebegin("Inventory.ToggleRename");
	u4 = not u4;
	u3 = false;
	u5 = false;
	table2 = {};
	UpdateBottom();
	debug.profileend();
end
function LockPets() -- Line: 989
	--[[
		Upvalues:
			[1] = u5
			[2] = m_Library
			[3] = table2
			[4] = u3
			[5] = u4
	--]]
	if u5 and m_Library.Functions.DictionaryLength(table2) > 0 then
		local _ = m_Library.Network.Invoke("Lock Pet", table2);
		for _, _ in pairs(table2) do
			m_Library.Signal.Fire("Lock Status Changed", table2);
		end
	end
	u5 = not u5;
	table2 = {};
	u3 = false;
	u4 = false;
	UpdateBottom();
end
function ToggleLock() -- Line: 1006
	--[[
		Upvalues:
			[1] = u5
			[2] = table2
			[3] = u3
			[4] = u4
	--]]
	u5 = not u5;
	table2 = {};
	u3 = false;
	u4 = false;
	UpdateBottom();
end
function UpdateNotifications() -- Line: 1015
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	debug.profilebegin("Inventory.UpdateNotifications");
	local v17 = m_Library.Save.Get();
	if v17 then
		local t_InventoryNotifications = v17.InventoryNotifications;
		local Notification = m_Library.GUI.Main.Bottom.Inventory:FindFirstChild("Notification");
		Notification.Visible = t_InventoryNotifications > 0;
		Notification:FindFirstChild("Count").Text = math.clamp(t_InventoryNotifications, 0, 999);
	end
	debug.profileend();
end
function ClearNotifications() -- Line: 1030
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v18 = m_Library.Save.Get();
	if v18 and v18.InventoryNotifications > 0 then
		m_Library.Network.Fire("Clear Inventory Notifications");
	end
end
function EquipBestPets() -- Line: 1040
	--[[
		Upvalues:
			[1] = m_Library
			[2] = Random_new_ret
	--]]
	local v19, v20 = m_Library.Network.Invoke("Equip Best Pets");
	if not v19 then
		m_Library.Message.New(v20 or "An error occurred.");
		return;
	end
	m_Library.Audio.Play("rbxassetid://7139317934", script, Random_new_ret:NextNumber(0.95, 1.05), 0.75);
end
function UnequipAllPets() -- Line: 1050
	--[[
		Upvalues:
			[1] = m_Library
			[2] = Random_new_ret
	--]]
	local v21, v22 = m_Library.Network.Invoke("Unequip All Pets");
	if not v21 then
		m_Library.Message.New(v22 or "An error occurred.");
		return;
	end
	m_Library.Audio.Play("rbxassetid://7139317934", script, Random_new_ret:NextNumber(0.95, 1.05), 0.75);
end
function UpdateEquipButtons() -- Line: 1060
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Inventory
			[3] = u3
	--]]
	debug.profilebegin("Inventory.UpdateEquipButtons");
	local v23 = m_Library.PetCmds.HasBestEquipped();
	t_Inventory.Bottom.EquipBest.Visible = not v23 and not u3;
	t_Inventory.Bottom.UnequipAll.Visible = v23 and not u3;
	debug.profileend();
end
function ShowAutoDeleteNotice() -- Line: 1069
	--[[
		Upvalues:
			[1] = t_Inventory
			[2] = m_Library
	--]]
	t_Inventory.AutoDeleteNotification.TextTransparency = 0;
	t_Inventory.AutoDeleteNotification.TextStrokeTransparency = 0;
	t_Inventory.AutoDeleteNotification.Visible = true;
	m_Library.Functions.Tween(t_Inventory.AutoDeleteNotification, {
		TextTransparency = 1,
		TextStrokeTransparency = 1
	}, {
		3,
		"Expo",
		"In"
	}).Completed:Connect(function() -- Line: 1075
		--[[
			Upvalues:
				[1] = t_Inventory
		--]]
		t_Inventory.AutoDeleteNotification.Visible = false;
	end);
end
function DeletePets() -- Line: 1081
	--[[
		Upvalues:
			[1] = table1
			[2] = m_Library
			[3] = u3
	--]]
	local function Delete() -- Line: 1082
		--[[
			Upvalues:
				[1] = table1
				[2] = m_Library
		--]]
		local v40 = 0;
		for _, val16 in ipairs(table1) do
			local v44 = m_Library.PetCmds.Get(val16);
			if not v44 then continue end
			local v45 = m_Library.Directory.Pets[v44.id];
			if not v45.isPremium and not v44.merchData and v45.rarity ~= "Event" and v45.rarity ~= "Exclusive" then continue end
			v40 = v40 + 1;
		end
		local v41 = m_Library.Message.New("\226\157\140 Are you SURE you want to DELETE these pets? You cannot undo this.", true);
		if v40 > 0 and v41 then
			v41 = m_Library.Message.New(m_Library.Functions.Commas(v40) .. " of these pets are valuable. Are you really sure?", true);
		end
		if v41 then
			local v46, v47 = m_Library.Network.Invoke("Delete Several Pets", table1);
			ToggleMultiDelete();
			if not v46 then
				m_Library.Message.New(v47 or "Failed to delete pets! (Unknown error)");
				return;
			end
			m_Library.Audio.Play("rbxassetid://7047631781", script);
			return;
		end
		ToggleMultiDelete();
	end
	if u3 and #table1 > 0 then
		Delete();
		return;
	end
	if u3 and #table1 == 0 then
		ToggleMultiDelete();
	end
end
function OpenGift(p10) -- Line: 1119
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Inventory
	--]]
	local v25 = m_Library.Save.Get();
	if not v25 then return end
	assert(v25);
	local v26, v27 = m_Library.PetCmds.Get(p10);
	if not v26 or v27 ~= m_Library.LocalPlayer then return end
	assert(v26 and v27);
	local v28 = 0;
	for _, val10 in ipairs(v25.Pets) do
		if val10.id ~= v26.id then continue end
		v28 = v28 + 1;
	end
	local table7 = {};
	for _, val11 in ipairs(m_Library.Shared.ExclusiveEggOpenAmounts) do
		if val11 > v28 then continue end
		table.insert(table7, val11);
	end
	if #table7 <= 0 then return end
	local table8 = {};
	for _, val12 in ipairs(table7) do
		table.insert(table8, (("Open %*"):format(val12)));
	end
	--local v29 =  or m_Library.Message.New("Are you sure you want to open this?", table.unpack(table8));
	
	local v29 = nil
	if #table8 == 1 then
		v29 = (m_Library.Message.New("Are you sure you want to open this?", true)) and 1 or nil
	else
		v29 = m_Library.Message.New("Are you sure you want to open this?", table.unpack(table8))
	end
	
	if v29 then
		t_Inventory.Gui.Enabled = false;
		m_Library.Variables.GuiThatWasEnabled = nil;
		local v36 = table7[v29];
		local v37, v38 = m_Library.Signal.Invoke("Exclusive Eggs: Open", p10, v36);
		if not v37 then
			t_Inventory.Gui.Enabled = true;
			m_Library.Message.New(v38 or "Unable to open. Try again!");
		end
	end
end
t_Inventory.Gui:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 1195
	Update();
end);
m_Library.Signal.Fired("Nickname Changed"):Connect(function(_, _) -- Line: 1199
	UpdateLazy();
end);
m_Library.Signal.Fired("Lock Changed"):Connect(function(_, _) -- Line: 1204
	UpdateLazy();
end);
m_Library.Signal.Fired("Stat Changed"):Connect(function(p11) -- Line: 1209
	if p11 == "Pets" or p11 == "MaxSlots" or p11 == "MaxEquipped" or p11 == "Gamepasses" or p11 == "InfPetsEnabled" or p11 == "HardcorePetsEquipped" or p11 == "PetsEquipped" then
		UpdateLazy();
		UpdatePetsEquipped();
		return;
	end
	if p11 == "InventoryNotifications" then
		UpdateNotifications();
	end
end);
m_Library.Signal.Fired("Loaded Stats"):Connect(function() -- Line: 1219
	UpdateLazy();
	UpdatePetsEquipped();
end);
m_Library.Signal.Fired("Pet Equips Changed"):Connect(function(_) -- Line: 1225
	UpdateLazy();
	UpdatePetsEquipped();
end);
m_Library.Signal.Fired("Window Opened"):Connect(function(p12) -- Line: 1232
	--[[
		Upvalues:
			[1] = t_Inventory
			[2] = m_Library
	--]]
	if p12 == t_Inventory.Gui then
		ClearNotifications();
		if m_Library.Variables.AutoDeleteEnabled then
			ShowAutoDeleteNotice();
		end
	end
end);
t_Inventory.Bottom.VerifyDelete.Activated:Connect(function() -- Line: 1246
	--[[
		Upvalues:
			[1] = bool1
	--]]
	if not bool1 then
		bool1 = true;
		DeletePets();
		bool1 = false;
	end
end);
t_Inventory.Bottom.VerifyLock.Activated:Connect(function() -- Line: 1256
	--[[
		Upvalues:
			[1] = bool1
	--]]
	if not bool1 then
		bool1 = true;
		LockPets();
		bool1 = false;
	end
end);
t_Inventory.Bottom.Grid.Activated:Connect(function() -- Line: 1265
	--[[
		Upvalues:
			[1] = bool1
	--]]
	if not bool1 then
		bool1 = true;
		ToggleGrid();
		bool1 = false;
	end
end);
t_Inventory.Bottom.MultiDelete.Activated:Connect(function() -- Line: 1274
	--[[
		Upvalues:
			[1] = bool1
	--]]
	if not bool1 then
		bool1 = true;
		ToggleMultiDelete();
		bool1 = false;
	end
end);
t_Inventory.Bottom.Rename.Activated:Connect(function() -- Line: 1283
	--[[
		Upvalues:
			[1] = bool1
	--]]
	if not bool1 then
		bool1 = true;
		ToggleRename();
		bool1 = false;
	end
end);
t_Inventory.Bottom.Lock.Activated:Connect(function() -- Line: 1292
	--[[
		Upvalues:
			[1] = bool1
	--]]
	if not bool1 then
		bool1 = true;
		ToggleLock();
		bool1 = false;
	end
end);
t_Inventory.Bottom.EquipBest.Activated:Connect(function() -- Line: 1301
	--[[
		Upvalues:
			[1] = bool1
	--]]
	if not bool1 then
		bool1 = true;
		EquipBestPets();
		bool1 = false;
	end
end);
t_Inventory.Bottom.UnequipAll.Activated:Connect(function() -- Line: 1310
	--[[
		Upvalues:
			[1] = bool1
	--]]
	if not bool1 then
		bool1 = true;
		UnequipAllPets();
		bool1 = false;
	end
end);
t_Inventory.Frame.Bottom.Search.Query:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 1319
	--[[
		Upvalues:
			[1] = t_Inventory
	--]]
	if t_Inventory.Frame.Bottom.Search.Query.Text ~= "" then
		t_Inventory.Main.Pets.CanvasPosition = Vector2.new();
	end
	UpdateLazy();
end);
t_Inventory.Close.Activated:Connect(function() -- Line: 1327
	--[[
		Upvalues:
			[1] = bool1
			[2] = m_Library
			[3] = Random_new_ret
			[4] = t_Inventory
	--]]
	if not bool1 then
		bool1 = true;
		m_Library.Audio.Play("rbxassetid://8951380772", script, Random_new_ret:NextNumber(0.95, 1.05), 0.1);
		t_Inventory.Gui.Enabled = false;
		bool1 = false;
	end
end);
m_Library.Signal.Fired("Resolution Changed"):Connect(function() -- Line: 1337
	task.defer(function() -- Line: 1338
		UpdateScrolling();
	end);
end);
m_Library.Signal.Fired("Hide Pets"):Connect(function(p13) -- Line: 1344
	--[[
		Upvalues:
			[1] = table3
	--]]
	local bool6 = false;
	for _, val13 in ipairs(p13) do
		if table3[val13] then continue end
		table3[val13] = true;
		bool6 = true;
	end
	if bool6 then
		UpdateLazy();
	end
end);
m_Library.Signal.Fired("Show Pets"):Connect(function(p14) -- Line: 1357
	--[[
		Upvalues:
			[1] = table3
	--]]
	local bool7 = false;
	for _, val14 in ipairs(p14) do
		if not table3[val14] then continue end
		table3[val14] = nil;
		bool7 = true;
	end
	if bool7 then
		UpdateLazy();
	end
end);
m_Library.RunService.Heartbeat:Connect(function() -- Line: 1370
	Update();
end);
m_Library.GUIFX.Tooltip(t_Inventory.Bottom.Grid, "Toggle Grid View");
m_Library.GUIFX.Tooltip(t_Inventory.Bottom.Lock, "Toggle Lock Mode");
m_Library.GUIFX.Tooltip(t_Inventory.Bottom.MultiDelete, "Toggle Delete");
m_Library.GUIFX.Tooltip(t_Inventory.Bottom.Rename, "Rename Pet");
m_Library.GUIFX.Tooltip(t_Inventory.Bottom.EquipBest, "Equip Best Pets");
m_Library.GUIFX.Tooltip(t_Inventory.Bottom.UnequipAll, "Unequip Pets");
m_Library.GUIFX.ButtonFX(t_Inventory.Close);
m_Library.GUIFX.ButtonFX(t_Inventory.Bottom.Grid);
m_Library.GUIFX.ButtonFX(t_Inventory.Bottom.MultiDelete);
m_Library.GUIFX.ButtonFX(t_Inventory.Bottom.VerifyDelete);
m_Library.GUIFX.ButtonFX(t_Inventory.Bottom.Rename);
m_Library.GUIFX.ButtonFX(t_Inventory.Bottom.Lock);
m_Library.GUIFX.ButtonFX(t_Inventory.Bottom.VerifyLock);
m_Library.GUIFX.ButtonFX(t_Inventory.Bottom.EquipBest);
m_Library.GUIFX.ButtonFX(t_Inventory.Bottom.UnequipAll);
UpdateBottom();
UpdateNotifications();
UpdatePetsEquipped();
UpdateEquipButtons();
