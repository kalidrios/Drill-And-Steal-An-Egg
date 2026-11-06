-- https://github.com/kalidrios

local _ = {
	"rbxassetid://6907636858",
	"rbxassetid://6907636843"
};
local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_ReleasePet = m_Library.GUI.ReleasePet;
local t_Inventory = m_Library.Assets.UI.Inventory;
local Random_new_ret = Random.new();
local bool1 = false;
local u1 = 0;
local u2 = nil;
local u3 = nil;
local bool2 = true;
function isVisible() -- Line: 28
	--[[
		Upvalues:
			[1] = t_ReleasePet
	--]]
	return t_ReleasePet.Gui.Enabled;
end
function UpdateLazy() -- Line: 34
	--[[
		Upvalues:
			[1] = bool2
	--]]
	bool2 = true;
	Update();
end
function Update() -- Line: 39
	--[[
		Upvalues:
			[1] = bool2
			[2] = m_Library
			[3] = u1
			[4] = t_ReleasePet
			[5] = t_Inventory
			[6] = u2
			[7] = u3
			[8] = bool1
	--]]
	if not bool2 then return end
	if not isVisible() then return end
	local u4 = m_Library.Save.Get();
	if not u4 then return end
	assert(u4);
	local t_Pets = u4.Pets;
	if not t_Pets then
		m_Library.Print("Failed to grab pets", true);
		return;
	end
	bool2 = false;
	debug.profilebegin("ReleasePet.Update");
	u1 = u1 + 1;
	local v9;
	if t_ReleasePet.Query.Text == "" then
		v9 = false;
	else
		v9 = t_ReleasePet.Query.Text ~= nil;
	end
	local v1 = v9 and m_Library.Functions.RegexEscape(string.lower(tostring(t_ReleasePet.Query.Text))) or nil;
	t_ReleasePet.PetAmount.Text = #t_Pets .. (#t_Pets <= 1 and " Brainrot" or " Brainrots");
	local table_clone_ret = table.clone(t_Pets);
	local v2 = m_Library.Shared.SortPets(u4, table_clone_ret);
	for key1, val1 in ipairs(v2) do
		local t_uid = val1.uid;
		local t_id = val1.id;
		local _ = val1.idt;
		local u5 = m_Library.Shared.HasPetEquipped(u4, val1);
		local t_s = val1.s;
		local t_g = val1.g;
		local t_r = val1.r;
		local t_dm = val1.dm;
		local t_powers = val1.powers;
		local u6 = m_Library.Directory.Pets[t_id];
		local _ = u6.isGift;
		if not t_g or not u6.goldenThumbnail then
			local _ = u6.thumbnail;
		end
		local t_name = u6.name;
		local t_rarity = u6.rarity;
		local t_l = val1.l;
		local t_sh = val1.sh;
		local v10 = t_ReleasePet.Main.Pets:FindFirstChild(t_uid);
		if not u6.huge then continue end
		if not v10 then
			v10 = t_Inventory.Pet:Clone();
			m_Library.PetUI.Create(v10, t_uid);
			local function RefreshPetData() -- Line: 100
				--[[
					Upvalues:
						[1] = m_Library
						[2] = t_uid
						[3] = val1
						[4] = u5
						[5] = u4
						[6] = t_s
						[7] = t_g
						[8] = t_r
						[9] = t_l
						[10] = t_dm
				--]]
				debug.profilebegin("ReleasePet.Update.RefreshPetData");
				local v11, v12 = m_Library.PetCmds.Get(t_uid);
				if v11 and v12 == m_Library.LocalPlayer then
					val1 = v11;
					u5 = m_Library.Shared.HasPetEquipped(u4, val1);
					t_s = val1.s;
					t_g = val1.g;
					t_r = val1.r;
					t_l = val1.l;
					t_dm = val1.dm;
				end
				debug.profileend();
			end
			local function Clicked() -- Line: 115
				--[[
					Upvalues:
						[1] = RefreshPetData
						[2] = t_l
						[3] = m_Library
						[4] = val1
						[5] = u6
						[6] = t_ReleasePet
						[7] = u2
						[8] = t_uid
						[9] = u3
				--]]
				RefreshPetData();
				if t_l then
					m_Library.Message.New("This pet is locked! Unlock it before you can release it!");
					return;
				end
				if val1.ugcData or not u6.tradeable then
					m_Library.Message.New("You cannot release this pet!");
					return;
				end
				t_ReleasePet.Gui.Enabled = false;
				local v13 = m_Library.Message.New("Are you sure you want to release your " .. m_Library.Shared.PetNameShort(val1) .. " to open the gate? You will LOSE it FOREVER!", true);
				if v13 then
					local v14 = m_Library.Message.New("ARE YOU SURE? You will DELETE your pet FOREVER!!", true);
					if v14 then
						local v15 = m_Library.Message.New("ARE YOU REALLY SURE? THIS CANNOT BE UNDONE EVER!", true);
						if v15 then
							local v16, v17 = m_Library.Network.Invoke("Diamond Mine: Release Pet", u2, t_uid);
							if not v16 then
								m_Library.Message.New(v17);
								return;
							end
							if u3 then
								local BasePart = u3:FindFirstChildWhichIsA("BasePart");
								local t_Size = BasePart.Size;
								Animation(t_Size, BasePart.CFrame);
							end
						end
					end
				end
			end
			v10.Activated:Connect(function() -- Line: 160
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
			m_Library.GUIFX.ButtonFX(v10);
		end
		v10:SetAttribute("Tick", u1);
		v10.LayoutOrder = key1;
		v10.Level:FindFirstChildOfClass("UIStroke").Thickness = 4;
		v10.HC:FindFirstChildOfClass("UIStroke").Thickness = 4;
		v10.Locked.Visible = val1.l;
		v10.Stars.Visible = not v10.Locked.Visible;
		v10.Equipped.Visible = t_uid == nil;
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
					local v18, _ = m_Library.Shared.GetPowerDir(unpack_ret1, unpack_ret2);
					if not string.find(string.lower(v18.title), v1, 1, true) then continue end
					bool3 = true;
					break;
				end
			end
			v10.Visible = bool3;
		else
			v10.Visible = true;
		end
		v10.Parent = t_ReleasePet.Main.Pets;
	end
	for _, child2 in ipairs(t_ReleasePet.Main.Pets:GetChildren()) do
		local Attribute = child2:GetAttribute("Tick");
		if not Attribute or Attribute == u1 then continue end
		child2:Destroy();
	end
	local v3 = 0;
	local v4 = u4.MaxSlots - #v2;
	for _, child3 in ipairs(t_ReleasePet.Main.Pets:GetChildren()) do
		if child3.Name ~= "Empty" then continue end
		v3 = v3 + 1;
	end
	local v5 = v4 - v3;
	if v5 > 0 then
		for index1 = 1, v5 do
			t_Inventory.Empty:Clone().Parent = t_ReleasePet.Main.Pets;
		end
	elseif v5 < 0 then
		for index2 = 1, -v5 do
			local Empty = t_ReleasePet.Main.Pets:FindFirstChild("Empty");
			if not Empty then break end
			Empty:Destroy();
		end
	end
	UpdateScrolling();
	debug.profileend();
end
function UpdateScrolling() -- Line: 270
	--[[
		Upvalues:
			[1] = t_ReleasePet
			[2] = m_Library
	--]]
	debug.profilebegin("ReleasePet.UpdateScrolling");
	local t_Pets2 = t_ReleasePet.Main.Pets;
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
function Animation(p1, p2) -- Line: 303
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local Part = Instance.new("Part");
	Part.Anchored = true;
	Part.CanCollide = false;
	Part.Transparency = 1;
	Part.Size = p1;
	Part.CFrame = p2;
	Part.Parent = m_Library.Debris;
	m_Library.Audio.Play("rbxassetid://6980742890", Part, 1, 1.25, 500);
	local Clone_ret = m_Library.Assets.Particles:FindFirstChild("Gate Unlock"):Clone();
	Clone_ret.Parent = Part;
	Clone_ret:Emit(100);
	m_Library.Functions.AddDebris(Part, 10);
end
t_ReleasePet.Gui:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 335
	--[[
		Upvalues:
			[1] = t_ReleasePet
	--]]
	if not t_ReleasePet.Gui.Enabled then return end
	UpdateLazy();
end);
t_ReleasePet.Frame.Bottom.Search.Query:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 344
	--[[
		Upvalues:
			[1] = t_ReleasePet
	--]]
	if t_ReleasePet.Frame.Bottom.Search.Query.Text ~= "" then
		t_ReleasePet.Main.Pets.CanvasPosition = Vector2.new();
	end
	UpdateLazy();
end);
t_ReleasePet.Close.Activated:Connect(function() -- Line: 353
	--[[
		Upvalues:
			[1] = bool1
			[2] = m_Library
			[3] = Random_new_ret
			[4] = t_ReleasePet
	--]]
	if not bool1 then
		debug.profilebegin("ReleasePet.Close.Activated");
		bool1 = true;
		m_Library.Audio.Play("rbxassetid://8951380772", script, Random_new_ret:NextNumber(0.95, 1.05), 0.1);
		t_ReleasePet.Gui.Enabled = false;
		bool1 = false;
		debug.profileend();
	end
end);
m_Library.Signal.Fired("Open Release Pet"):Connect(function(p3, p4) -- Line: 366
	--[[
		Upvalues:
			[1] = u2
			[2] = u3
			[3] = t_ReleasePet
	--]]
	u2 = p3;
	u3 = p4;
	t_ReleasePet.Gui.Enabled = true;
end);
m_Library.Signal.Fired("Resolution Changed"):Connect(function() -- Line: 374
	task.defer(function() -- Line: 376
		UpdateScrolling();
	end);
end);
m_Library.GUIFX.ButtonFX(t_ReleasePet.Close);
Update();
