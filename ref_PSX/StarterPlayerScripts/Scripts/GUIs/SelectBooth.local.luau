-- https://github.com/kalidrios

local _ = {
	"rbxassetid://6907636858",
	"rbxassetid://6907636843"
};
local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_SelectBooth = m_Library.GUI.SelectBooth;
local t_Inventory = m_Library.Assets.UI.Inventory;
local Random_new_ret = Random.new();
local bool1 = false;
local u1 = 0;
local u2 = nil;
local table1 = {};
local bool2 = true;
function isVisible() -- Line: 27
	--[[
		Upvalues:
			[1] = t_SelectBooth
	--]]
	return t_SelectBooth.Gui.Enabled;
end
function UpdateLazy() -- Line: 33
	--[[
		Upvalues:
			[1] = bool2
	--]]
	bool2 = true;
	Update();
end
function Update() -- Line: 38
	--[[
		Upvalues:
			[1] = bool2
			[2] = m_Library
			[3] = u1
			[4] = t_SelectBooth
			[5] = u2
			[6] = t_Inventory
			[7] = table1
			[8] = Random_new_ret
			[9] = bool1
	--]]
	if not bool2 then return end
	if not isVisible() then return end
	local u3 = m_Library.Save.Get();
	if not u3 then return end
	assert(u3);
	local t_Pets = u3.Pets;
	if not t_Pets then
		m_Library.Print("Failed to grab pets", true);
		return;
	end
	bool2 = false;
	debug.profilebegin("SelectBooth.Update");
	u1 = u1 + 1;
	local v9;
	if t_SelectBooth.Query.Text == "" then
		v9 = false;
	else
		v9 = t_SelectBooth.Query.Text ~= nil;
	end
	local v1 = v9 and m_Library.Functions.RegexEscape(string.lower(tostring(t_SelectBooth.Query.Text))) or nil;
	t_SelectBooth.PetAmount.Text = #t_Pets .. (#t_Pets <= 1 and " Brainrot" or " Brainrots");
	local table_clone_ret = table.clone(t_Pets);
	local v2 = m_Library.Shared.SortPets(u3, table_clone_ret);
	for key1, val1 in ipairs(v2) do
		local t_uid = val1.uid;
		local t_id = val1.id;
		local _ = val1.idt;
		local u4 = m_Library.Shared.HasPetEquipped(u3, val1);
		local t_s = val1.s;
		local t_g = val1.g;
		local t_r = val1.r;
		local t_dm = val1.dm;
		local t_powers = val1.powers;
		local v10 = m_Library.Directory.Pets[t_id];
		local _ = v10.isGift;
		if not t_g or not v10.goldenThumbnail then
			local _ = v10.thumbnail;
		end
		local t_name = v10.name;
		local t_rarity = v10.rarity;
		local t_l = val1.l;
		local t_sh = val1.sh;
		local v11 = t_SelectBooth.Main.Pets:FindFirstChild(t_uid);
		if u2 and u2.Listings[t_uid] then continue end
		if not v11 then
			v11 = t_Inventory.Pet:Clone();
			m_Library.PetUI.Create(v11, t_uid);
			local function RefreshPetData() -- Line: 99
				--[[
					Upvalues:
						[1] = m_Library
						[2] = t_uid
						[3] = val1
						[4] = u4
						[5] = u3
						[6] = t_s
						[7] = t_g
						[8] = t_r
						[9] = t_l
						[10] = t_dm
				--]]
				debug.profilebegin("SelectBooth.Update.RefreshPetData");
				local v13, v14 = m_Library.PetCmds.Get(t_uid);
				if v13 and v14 == m_Library.LocalPlayer then
					val1 = v13;
					u4 = m_Library.Shared.HasPetEquipped(u3, val1);
					t_s = val1.s;
					t_g = val1.g;
					t_r = val1.r;
					t_l = val1.l;
					t_dm = val1.dm;
				end
				debug.profileend();
			end
			local function Clicked() -- Line: 114
				--[[
					Upvalues:
						[1] = RefreshPetData
						[2] = t_l
						[3] = m_Library
						[4] = table1
						[5] = t_uid
						[6] = Random_new_ret
				--]]
				RefreshPetData();
				if t_l then
					m_Library.Message.New("This pet is locked! Unlock it before you can sell it!");
					return;
				end
				if m_Library.Functions.SearchArray(table1, t_uid) then
					m_Library.Audio.Play("rbxassetid://7139317909", script, Random_new_ret:NextNumber(0.95, 1.05), 0.75);
					m_Library.Functions.RemoveTable(table1, t_uid);
				else
					m_Library.Audio.Play("rbxassetid://7139317934", script, Random_new_ret:NextNumber(0.95, 1.05), 0.75);
					table.insert(table1, t_uid);
				end
				UpdateLazy();
			end
			v11.Activated:Connect(function() -- Line: 134
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
			m_Library.GUIFX.ButtonFX(v11);
		end
		v11:SetAttribute("Tick", u1);
		v11.LayoutOrder = key1;
		v11.Level:FindFirstChildOfClass("UIStroke").Thickness = 4;
		v11.HC:FindFirstChildOfClass("UIStroke").Thickness = 4;
		v11.Locked.Visible = val1.l;
		v11.Stars.Visible = not v11.Locked.Visible;
		v11.Equipped.Visible = m_Library.Functions.SearchArray(table1, t_uid);
		if v9 and v1 then
			local bool3 = false;
			if string.find(string.lower(t_name), v1, 1, true) then
				bool3 = true;
			elseif val1.nk and string.find(string.lower(val1.nk), v1, 1, true) then
				bool3 = true;
			elseif string.find(string.lower(t_rarity), v1, 1, true) then
				bool3 = true;
			elseif t_sh and string.find("shiny", v1, 1, true) then
				bool3 = true;
			elseif t_g and (string.find("gold", v1, 1, true) or string.find("golden", v1, 1, true)) then
				bool3 = true;
			elseif t_r and string.find("rainbow", v1, 1, true) then
				bool3 = true;
			elseif t_dm and string.find("dark matter", v1, 1, true) then
				bool3 = true;
			elseif t_l and string.find("lock", v1, 1, true) then
				bool3 = true;
			elseif t_powers and #t_powers > 0 then
				for _, val6 in ipairs(t_powers) do
					local unpack_ret1, unpack_ret2 = unpack(val6);
					local v15, _ = m_Library.Shared.GetPowerDir(unpack_ret1, unpack_ret2);
					if not string.find(string.lower(v15.title), v1, 1, true) then continue end
					bool3 = true;
					break;
				end
			end
			v11.Visible = bool3;
		else
			v11.Visible = true;
		end
		v11.Parent = t_SelectBooth.Main.Pets;
	end
	for _, child2 in ipairs(t_SelectBooth.Main.Pets:GetChildren()) do
		local Attribute = child2:GetAttribute("Tick");
		if not Attribute or Attribute == u1 and u2 and not u2.Listings[child2.Name] then continue end
		child2:Destroy();
	end
	local v3 = 0;
	local v4 = u3.MaxSlots - #v2;
	for _, child3 in ipairs(t_SelectBooth.Main.Pets:GetChildren()) do
		if child3.Name ~= "Empty" then continue end
		v3 = v3 + 1;
	end
	local v5 = v4 - v3;
	if v5 > 0 then
		for index1 = 1, v5 do
			t_Inventory.Empty:Clone().Parent = t_SelectBooth.Main.Pets;
		end
	elseif v5 < 0 then
		for index2 = 1, -v5 do
			local Empty = t_SelectBooth.Main.Pets:FindFirstChild("Empty");
			if not Empty then break end
			Empty:Destroy();
		end
	end
	UpdateSelectButton();
	UpdateScrolling();
	debug.profileend();
end
function UpdateScrolling() -- Line: 246
	--[[
		Upvalues:
			[1] = t_SelectBooth
			[2] = m_Library
	--]]
	debug.profilebegin("SelectBooth.UpdateScrolling");
	local t_Pets2 = t_SelectBooth.Main.Pets;
	local UIGridLayout = t_Pets2:FindFirstChildOfClass("UIGridLayout");
	local UIPadding = t_Pets2:FindFirstChildOfClass("UIPadding");
	local v6 = m_Library.Functions.ResolutionScale();
	local v7 = v6 <= 0.5 and 4 or v6 <= 0.65 and 5 or v6 <= 1 and 6 or v6 <= 1.2 and 7 or 8;
	UIGridLayout.CellPadding = UDim2.new(0, 20, 0, 20);
	local v8 = (t_Pets2.AbsoluteSize.X - t_Pets2.ScrollBarThickness - UIPadding.PaddingLeft.Offset - UIPadding.PaddingRight.Offset) / v7 - UIGridLayout.CellPadding.X.Offset;
	local udim2 = UDim2.new(0, v8, 0, v8);
	UIGridLayout.CellSize = udim2;
	UIGridLayout:ApplyLayout();
	t_Pets2.CanvasSize = UDim2.new(0, UIGridLayout.AbsoluteContentSize.X, 0, UIGridLayout.AbsoluteContentSize.Y + 65);
	debug.profileend();
end
function UpdateSelectButton() -- Line: 279
	--[[
		Upvalues:
			[1] = t_SelectBooth
			[2] = table1
	--]]
	t_SelectBooth.Frame.Bottom.SelectPets.ImageColor3 = #table1 > 0 and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
	t_SelectBooth.Frame.Bottom.SelectPets.Label.Text = "List Pet" .. (#table1 > 1 and "s" or "");
end
t_SelectBooth.Gui:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 298
	Update();
end);
t_SelectBooth.Frame.Bottom.SelectPets.Activated:Connect(function() -- Line: 302
	--[[
		Upvalues:
			[1] = bool1
			[2] = table1
			[3] = m_Library
	--]]
	if not bool1 then
		bool1 = true;
		local table2 = {};
		if #table1 > 0 then
			for _, val4 in ipairs(table1) do
				local v12 = m_Library.PetCmds.Get(val4);
				if not v12 then
					table.insert(table2, val4);
					continue;
				end
				assert(v12);
				if not v12.l then continue end
				m_Library.Message.New("A selected pet is locked! Unlock it before you can sell it!");
				bool1 = false;
				return;
			end
			for _, val5 in ipairs(table2) do
				m_Library.Functions.RemoveTable(table1, val5);
			end
			if #table1 > 0 then
				m_Library.Signal.Invoke("List Pet", table1);
			end
		end
		bool1 = false;
	end
end);
t_SelectBooth.Frame.Bottom.Search.Query:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 336
	--[[
		Upvalues:
			[1] = t_SelectBooth
	--]]
	if t_SelectBooth.Frame.Bottom.Search.Query.Text ~= "" then
		t_SelectBooth.Main.Pets.CanvasPosition = Vector2.new();
	end
	UpdateLazy();
end);
t_SelectBooth.Close.Activated:Connect(function() -- Line: 345
	--[[
		Upvalues:
			[1] = bool1
			[2] = m_Library
			[3] = Random_new_ret
			[4] = t_SelectBooth
	--]]
	if not bool1 then
		debug.profilebegin("SelectBooth.Close.Activated");
		bool1 = true;
		m_Library.Audio.Play("rbxassetid://8951380772", script, Random_new_ret:NextNumber(0.95, 1.05), 0.1);
		t_SelectBooth.Gui.Enabled = false;
		bool1 = false;
		debug.profileend();
	end
end);
m_Library.Signal.Fired("Resolution Changed"):Connect(function() -- Line: 358
	task.defer(function() -- Line: 360
		UpdateScrolling();
	end);
end);
m_Library.GUIFX.ButtonFX(t_SelectBooth.Close);
m_Library.GUIFX.ButtonFX(t_SelectBooth.Frame.Bottom.SelectPets);
Update();
m_Library.Signal.Invoked("Select Booth Pet").OnInvoke = function(p1) -- Line: 381
	--[[
		Upvalues:
			[1] = u2
			[2] = table1
			[3] = t_SelectBooth
	--]]
	u2 = p1;
	table1 = {};
	UpdateLazy();
	t_SelectBooth.Gui.Enabled = true;
end
