-- https://github.com/kalidrios

local _ = {
	"rbxassetid://6907636858",
	"rbxassetid://6907636843"
};
local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_AuctionSelect = m_Library.GUI.AuctionSelect;
local t_Inventory = m_Library.Assets.UI.Inventory;
local Random_new_ret = Random.new();
local bool1 = false;
local u1 = 0;
local bool2 = true;
function isVisible() -- Line: 26
	--[[
		Upvalues:
			[1] = t_AuctionSelect
	--]]
	return t_AuctionSelect.Gui.Enabled;
end
function UpdateLazy() -- Line: 32
	--[[
		Upvalues:
			[1] = bool2
	--]]
	bool2 = true;
	Update();
end
function Update() -- Line: 37
	--[[
		Upvalues:
			[1] = bool2
			[2] = m_Library
			[3] = u1
			[4] = t_AuctionSelect
			[5] = t_Inventory
			[6] = bool1
	--]]
	if not bool2 then return end
	if not isVisible() then return end
	local u2 = m_Library.Save.Get();
	if not u2 then return end
	assert(u2);
	local t_Pets = u2.Pets;
	if not t_Pets then
		m_Library.Print("Failed to grab pets", true);
		return;
	end
	bool2 = false;
	debug.profilebegin("AuctionSelect.Update");
	u1 = u1 + 1;
	local v9;
	if t_AuctionSelect.Query.Text == "" then
		v9 = false;
	else
		v9 = t_AuctionSelect.Query.Text ~= nil;
	end
	local v1 = v9 and m_Library.Functions.RegexEscape(string.lower(tostring(t_AuctionSelect.Query.Text))) or nil;
	t_AuctionSelect.PetAmount.Text = #t_Pets .. (#t_Pets <= 1 and " Brainrot" or " Brainrots");
	local table_clone_ret = table.clone(t_Pets);
	local v2 = m_Library.Shared.SortPets(u2, table_clone_ret);
	for key1, val1 in ipairs(v2) do
		local t_uid = val1.uid;
		local t_id = val1.id;
		local _ = val1.idt;
		local u3 = m_Library.Shared.HasPetEquipped(u2, val1);
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
		local v11 = t_AuctionSelect.Main.Pets:FindFirstChild(t_uid);
		if not v11 then
			v11 = t_Inventory.Pet:Clone();
			m_Library.PetUI.Create(v11, t_uid);
			local function RefreshPetData() -- Line: 94
				--[[
					Upvalues:
						[1] = m_Library
						[2] = t_uid
						[3] = val1
						[4] = u3
						[5] = u2
						[6] = t_s
						[7] = t_g
						[8] = t_r
						[9] = t_l
						[10] = t_dm
				--]]
				debug.profilebegin("AuctionSelect.Update.RefreshPetData");
				local v12, v13 = m_Library.PetCmds.Get(t_uid);
				if v12 and v13 == m_Library.LocalPlayer then
					val1 = v12;
					u3 = m_Library.Shared.HasPetEquipped(u2, val1);
					t_s = val1.s;
					t_g = val1.g;
					t_r = val1.r;
					t_l = val1.l;
					t_dm = val1.dm;
				end
				debug.profileend();
			end
			local function Clicked() -- Line: 109
				--[[
					Upvalues:
						[1] = RefreshPetData
						[2] = t_l
						[3] = m_Library
						[4] = t_uid
				--]]
				RefreshPetData();
				if t_l then
					m_Library.Message.New("This pet is locked! Unlock it before you can auction it!");
					return;
				end
				m_Library.Signal.Invoke("Auction Pet", t_uid);
			end
			v11.Activated:Connect(function() -- Line: 121
				--[[
					Upvalues:
						[1] = bool1
						[2] = RefreshPetData
						[3] = t_l
						[4] = m_Library
						[5] = t_uid
				--]]
				if not bool1 then
					bool1 = true;
					RefreshPetData();
					if t_l then
						m_Library.Message.New("This pet is locked! Unlock it before you can auction it!");
					else
						m_Library.Signal.Invoke("Auction Pet", t_uid);
					end
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
		v11.Equipped.Visible = t_uid == nil;
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
				for _, val4 in ipairs(t_powers) do
					local unpack_ret1, unpack_ret2 = unpack(val4);
					local v14, _ = m_Library.Shared.GetPowerDir(unpack_ret1, unpack_ret2);
					if not string.find(string.lower(v14.title), v1, 1, true) then continue end
					bool3 = true;
					break;
				end
			end
			v11.Visible = bool3;
		else
			v11.Visible = true;
		end
		v11.Parent = t_AuctionSelect.Main.Pets;
	end
	for _, child2 in ipairs(t_AuctionSelect.Main.Pets:GetChildren()) do
		local Attribute = child2:GetAttribute("Tick");
		if not Attribute or Attribute == u1 then continue end
		child2:Destroy();
	end
	local v3 = 0;
	local v4 = u2.MaxSlots - #v2;
	for _, child3 in ipairs(t_AuctionSelect.Main.Pets:GetChildren()) do
		if child3.Name ~= "Empty" then continue end
		v3 = v3 + 1;
	end
	local v5 = v4 - v3;
	if v5 > 0 then
		for index1 = 1, v5 do
			t_Inventory.Empty:Clone().Parent = t_AuctionSelect.Main.Pets;
		end
	elseif v5 < 0 then
		for index2 = 1, -v5 do
			local Empty = t_AuctionSelect.Main.Pets:FindFirstChild("Empty");
			if not Empty then break end
			Empty:Destroy();
		end
	end
	UpdateScrolling();
	debug.profileend();
end
function UpdateScrolling() -- Line: 231
	--[[
		Upvalues:
			[1] = t_AuctionSelect
			[2] = m_Library
	--]]
	debug.profilebegin("AuctionSelect.UpdateScrolling");
	local t_Pets2 = t_AuctionSelect.Main.Pets;
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
t_AuctionSelect.Gui:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 277
	--[[
		Upvalues:
			[1] = t_AuctionSelect
	--]]
	if not t_AuctionSelect.Gui.Enabled then return end
	UpdateLazy();
end);
t_AuctionSelect.Frame.Bottom.Search.Query:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 286
	--[[
		Upvalues:
			[1] = t_AuctionSelect
	--]]
	if t_AuctionSelect.Frame.Bottom.Search.Query.Text ~= "" then
		t_AuctionSelect.Main.Pets.CanvasPosition = Vector2.new();
	end
	UpdateLazy();
end);
t_AuctionSelect.Close.Activated:Connect(function() -- Line: 295
	--[[
		Upvalues:
			[1] = bool1
			[2] = m_Library
			[3] = Random_new_ret
			[4] = t_AuctionSelect
	--]]
	if not bool1 then
		debug.profilebegin("AuctionSelect.Close.Activated");
		bool1 = true;
		m_Library.Audio.Play("rbxassetid://8951380772", script, Random_new_ret:NextNumber(0.95, 1.05), 0.1);
		t_AuctionSelect.Gui.Enabled = false;
		bool1 = false;
		debug.profileend();
	end
end);
m_Library.Signal.Fired("Resolution Changed"):Connect(function() -- Line: 308
	task.defer(function() -- Line: 310
		UpdateScrolling();
	end);
end);
m_Library.GUIFX.ButtonFX(t_AuctionSelect.Close);
Update();
