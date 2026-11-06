-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = require(game.ReplicatedStorage.Library);
v1.Load();
local v2 = require(game.ReplicatedStorage.Library.Modules.Pets);
local v3 = require(game.ReplicatedStorage.Library.Modules.Daycare);
local v4 = {};
local u1 = false;
local u2 = {};
local u3 = Random.new();
function PetsSelect(p1)
	local v5 = v1.PetCmds.Get(p1);
	if not p1 then
		return;
	end;
	local v6 = v1.Save.Get();
	if not v6 then
		return;
	end;
	assert(v6);
	local v7
	if v1.Shared.IsHardcore then
		v7 = v6.DaycareHardcoreQueue;
	else
		v7 = v6.DaycareQueue;
	end;
	local v8 = v1.Shared.DaycareComputeSlotsForTier(v6.DaycareTier);
	local v9 = math.max(0, v8 - #v7);
	if v9 == 0 then

	elseif v9 <= #u2 then
		return;
	elseif table.find(u2, p1) then
		return;
	else
		v1.Audio.Play("rbxassetid://7139317934", script, u3:NextNumber(0.95, 1.05), 0.75);
		table.insert(u2, p1);
		UpdateSelectedAmount();
		UpdateEnrollLazy();
		return;
	end;
	if v8 < 20 then
		if v1.Message.New("You're out of daycare slots! Would you like to buy more?", true) then

		else
			return;
		end;
	else
		v1.Message.New("You're out of daycare slots!");
		return;
	end;
	local v10, v11 = v1.Network.Invoke("Attempt Buy +10 Daycare Slots");
	if v10 ~= true then

	else
		v1.Shared.PromptPurchase(1378709263, true);
		return;
	end;
	v1.Message.New(v11);
	u1 = false;
end;
function PetsDeselect(p2)
	v1.Audio.Play("rbxassetid://7139317909", script, u3:NextNumber(0.95, 1.05), 0.75);
	table.remove(u2, table.find(u2, p2));
	UpdateSelectedAmount();
	UpdateEnrollLazy();
end;
local l__Daycare__4 = v1.GUI.Daycare;
function PetsUpdate()
	(function()
		if u2[1] then
			if not v1.PetCmds.Get(u2[1]) then

			end;
		end;
		for v12, v13 in ipairs((0 < #u2 and l__Daycare__4.Holder1Stage2 or l__Daycare__4.HolderStage1):GetChildren()) do
			if v13.ClassName == "TextButton" then
				local v15 = v13:GetAttribute("Locked");
				local v16 = v13:GetAttribute("Hardcore");
				if v13:GetAttribute("DirId") then
					local v17 = v1.Functions.SearchArray(u2, v13.Name);
					v13.Equipped.Visible = v17;
					v13.BackgroundColor3 = v17 and Color3.fromRGB(69, 239, 69) or Color3.fromRGB(39, 233, 55);
					if not v15 then
						v13.BackgroundColor3 = v17 and Color3.fromRGB(69, 239, 69) or Color3.fromRGB(39, 233, 55);
						v13.PetIcon.ImageTransparency = 0;
					end;
				end;
			end;		
		end;
	end)();
	ScaleScrolling();
end;
local u5 = false;
function Update()
	local v18 = v1.Save.Get();
	if not v18 then
		return;
	end;
	assert(v18);
	if 0 < v18.DaycareTier then
		l__Daycare__4.UpgradeSlots.Visible = false;
	end;
	l__Daycare__4.Categories.ViewPets.Frame.PetReady.Visible = u5;
end;
local u6 = {
	Diamonds = {
		Position = UDim2.new(0.47, 0, 0.5, 0), 
		Size = UDim2.new(0.7, 0, 0.7, 0)
	}, 
	Currency = {
		Position = UDim2.new(0.5, 0, 0.5, 0), 
		Size = UDim2.new(0.8, 0, 0.8, 0)
	}, 
	["Super Lucky"] = {
		Position = UDim2.new(0.54, 0, 0.5, 0), 
		Size = UDim2.new(1.05, 0, 1.05, 0)
	}, 
	["Triple Coins"] = {
		Position = UDim2.new(0.54, 0, 0.5, 0), 
		Size = UDim2.new(1.05, 0, 1.05, 0)
	}, 
	["Triple Damage"] = {
		Position = UDim2.new(0.54, 0, 0.5, 0), 
		Size = UDim2.new(1.05, 0, 1.05, 0)
	}, 
	["Ultra Lucky"] = {
		Position = UDim2.new(0.47, 0, 0.5, 0), 
		Size = UDim2.new(0.9, 0, 0.9, 0)
	}
};
local u7 = {
	["Triple Coins"] = "rbxassetid://87286773439915", 
	["Triple Damage"] = "rbxassetid://78491418509874", 
	["Super Lucky"] = "rbxassetid://113476250487312", 
	["Ultra Lucky"] = "rbxassetid://104432957516372"
};
local u8 = nil;
function UpdateClaim(p3, p4)
	local v19 = v1.Save.Get();
	if not v19 then
		return;
	end;
	assert(v19);
	local l__Pets__20 = l__Daycare__4.LootView.Pets;
	for v21, v22 in ipairs(l__Pets__20:GetChildren()) do
		if v22:isA("TextButton") then
			v22:Destroy();
		end;	
	end;
	for v24, v25 in ipairs(p3) do
		local l__s__27 = v25.s;
		local l__g__28 = v25.g;
		local l__r__29 = v25.r;
		local l__dm__30 = v25.dm;
		local v31 = v1.Directory.Pets[v25.id];
		local l__rarity__32 = v31.rarity;
		if not v31.huge then
			if v31.companionEnchantLevel == nil then
				if not v31.titanic then
					if not v31.isGift then
						local v33 = v1.Assets.UI.Inventory.Pet:Clone();
						v1.PetUI.Create(v33, v25.uid);
						v33:SetAttribute("DirId", v25.id);
						v33:SetAttribute("Hardcore", v25.hc);
						v33.Size = UDim2.new(1, 0, 1, 0);
						v33.Parent = l__Pets__20;
					end;
				end;
			end;
		end;	
	end;
	local l__LootHolder__34 = l__Daycare__4.LootHolder;
	for v35, v36 in ipairs(l__LootHolder__34:GetChildren()) do
		if v36.ClassName == "Frame" then
			if not v36:GetAttribute("template") then
				v36:Destroy();
			end;
		end;	
	end;
	local l__Loot__38 = l__LootHolder__34:FindFirstChild("Loot");
	l__Loot__38.Visible = false;
	for v39, v40 in ipairs(p4) do
		local v42 = l__Loot__38:Clone();
		v42:SetAttribute("template", false);
		v42.NonPet.Level.AutoLocalize = false;
		v42.NonPet.Level.Text = v1.Functions.NumberShorten(v40.Min);
		if v40.Category == "Currency" then
			v42.NonPet.Icon.Image = v1.Directory.Currency[v40.Data].ImageTiny;
			if u6[v40.Data] then
				v42.NonPet.Icon.Position = u6[v40.Data].Position;
				v42.NonPet.Icon.Size = u6[v40.Data].Size;
			else
				v42.NonPet.Icon.Position = u6.Currency.Position;
				v42.NonPet.Icon.Size = u6.Currency.Size;
			end;
			if v1.Shared.IsHardcore then
				if v1.Directory.Currency[v40.Data].HardcoreSeparate then
					v42.NonPet.Icon.HC.Visible = true;
				end;
			end;
			v1.GUIFX.Tooltip(v42.NonPet, v40.Data);
		elseif v40.Category == "Boost" then
			v42.NonPet.Icon.Image = u7[v40.Data];
			if u6[v40.Data] then
				v42.NonPet.Icon.Position = u6[v40.Data].Position;
				v42.NonPet.Icon.Size = u6[v40.Data].Size;
			end;
			v1.GUIFX.Tooltip(v42.NonPet, v40.Data);
		elseif v40.Category == "Pet" then
			v42.NonPet.Visible = false;
			local l__Data__43 = v40.Data;
			local l__id__44 = l__Data__43.id;
			local l__isGolden__45 = l__Data__43.isGolden;
			local l__isRainbow__46 = l__Data__43.isRainbow;
			local l__isDarkMatter__47 = l__Data__43.isDarkMatter;
			local v48 = v1.Directory.Pets[l__id__44];
			local v49 = v1.Assets.UI.Inventory.Pet:Clone();
			v49.Size = UDim2.new(1, 0, 1, 0);
			v1.PetUI.Create(v49, l__id__44, {
				g = l__isGolden__45, 
				r = l__isRainbow__46, 
				dm = l__isDarkMatter__47
			});
			v49:FindFirstChild("Level"):Destroy();
			v49:SetAttribute("petId", l__id__44);
			v49:SetAttribute("name", v48.name);
			v49:SetAttribute("rarity", v48.rarity);
			v49:SetAttribute("isGolden", l__isGolden__45);
			v49:SetAttribute("isRainbow", l__isRainbow__46);
			v49:SetAttribute("isDarkMatter", l__isDarkMatter__47);
			local v50 = v49:GetAttribute("petId");
			local v51 = v49:GetAttribute("isRainbow");
			local v52 = v49:GetAttribute("isDarkMatter");
			if v49:GetAttribute("isGolden") then

			elseif v51 then

			elseif v52 then

			end;
			v49.PetIcon.ImageColor3 = Color3.new(1, 1, 1);
			v49.PetIcon.Locked.Visible = false;
			if l__Data__43.id ~= "1027" then
				u8 = l__Data__43;
			end;
			v49.Parent = v42;
		elseif u6[v40.Data] then
			v42.NonPet.Icon.Position = u6[v40.Data].Position;
			v42.NonPet.Icon.Size = u6[v40.Data].Size;
		end;
		v42.Parent = l__LootHolder__34;
		v42.Visible = true;	
	end;
	ClaimScrolling();
end;
function ClaimScrolling()
	local l__Pets__53 = l__Daycare__4.Pets;
	local v54 = l__Pets__53:FindFirstChildOfClass("UIGridLayout");
	local v55 = l__Pets__53:FindFirstChildOfClass("UIPadding");
	local v56 = v1.Functions.ResolutionScale();
	local v57
	if v56 <= 0.5 then
		v57 = 2;
	elseif v56 <= 1.1 then
		v57 = 2.5;
	else
		v57 = 3;
	end;
	local v58 = (l__Pets__53.AbsoluteSize.X - l__Pets__53.ScrollBarThickness - v55.PaddingLeft.Offset - v55.PaddingRight.Offset) / v57 - v54.CellPadding.X.Offset;
	v54.CellSize = UDim2.new(0, v58, 0, v58);
	v54:ApplyLayout();
	l__Pets__53.CanvasSize = UDim2.new(0, v54.AbsoluteContentSize.X, 0, v54.AbsoluteContentSize.Y + 30);
	local l__LootHolder__59 = l__Daycare__4.LootHolder;
	local v60 = l__LootHolder__59:FindFirstChildOfClass("UIGridLayout");
	local v61 = l__LootHolder__59:FindFirstChildOfClass("UIPadding");
	local v62 = v1.Functions.ResolutionScale();
	local v63 
	if v62 <= 0.5 then
		v63 = 2;
	elseif v62 <= 1.1 then
		v63 = 2.5;
	else
		v63 = 3;
	end;
	local v64 = (l__LootHolder__59.AbsoluteSize.X - l__LootHolder__59.ScrollBarThickness - v61.PaddingLeft.Offset - v61.PaddingRight.Offset) / v63 - v60.CellPadding.X.Offset;
	v60.CellSize = UDim2.new(0, v64, 0, v64);
	v60:ApplyLayout();
	l__LootHolder__59.CanvasSize = UDim2.new(0, v60.AbsoluteContentSize.X, 0, v60.AbsoluteContentSize.Y + 30);
end;
local u9 = 0;
local u10 = nil;
local u11 = nil;
game:GetService("RunService").RenderStepped:Connect(function(p5)
	u9 = u9 + p5;
	u10 = Color3.fromHSV(u9 / 2 % 1, 1, 1);
	u11 = 0.7 + math.sin(u9 * 4) * 0.2;
end);
function UpdateView()
	local v65 = v1.Save.Get();
	if not v65 then
		return;
	end;
	assert(v65);
	local l__Holder__66 = l__Daycare__4.View.Holder;
	local v67 
	if v1.Shared.IsHardcore then
		v67 = v65.DaycareHardcoreQueue;
	else
		v67 = v65.DaycareQueue;
	end;
	for v68, v69 in ipairs(v67) do
		local v71 = l__Holder__66:FindFirstChild(v68);
		if v71 then

		else
			local l__Pet__72 = v69.Pet;
			local v73 = v1.Directory.Pets[l__Pet__72.id];
			local u12 = v69;
			local u13 = v1.Shared.DaycareComputeRemainingTime(v65, v69);
			local u14 = v71;
			local function v74()
				u12 = v67[v68];
				if not u12 then
					return;
				end;
				u13 = v1.Shared.DaycareComputeRemainingTime(v65, u12);
				local v75 = u13 <= 0;
				u14.TimeDescStage1.Visible = not v75;
				u14.TimeLeftStage1.Visible = not v75;
				u14.ClaimStage2.Visible = v75;
				u14.ClaimDescStage2.Visible = v75;
				u14.PetIcon.UIGradient.Enabled = not v75;
				if l__Pet__72.hc then
					u14.PetIcon.HC.Visible = true;
				end;
				if not v75 then
					u14.TimeLeftStage1.Text = v1.Functions.FormatTime(u13);
					return;
				end;
				u5 = true;
				l__Daycare__4.ClaimAll.ImageColor3 = u5 and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
				l__Daycare__4.Categories.ViewPets.Frame.PetReady.Visible = u5;
			end;
			u14 = l__Daycare__4.View.Holder.ViewTemplate:Clone();
			u14.Name = v68;
			u14.PetIcon.Image = l__Pet__72.dm and v73.darkMatterThumbnail or (l__Pet__72.g and v73.goldenThumbnail or v73.thumbnail);
			u14:SetAttribute("SlotId", v68);
			u14.Parent = l__Holder__66;
			u14.Visible = true;
			if l__Pet__72.r then
				coroutine.wrap(function()
					while true do
						if u14 then

						else
							break;
						end;
						if u14.Parent then

						else
							break;
						end;
						if l__Pet__72.r then

						else
							break;
						end;
						if l__Daycare__4.Gui.Enabled then
							if u14.PetIcon.ImageColor3 ~= Color3.new(0, 0, 0) then
								u14.PetIcon.ImageColor3 = u10;
							end;
						end;
						if l__Daycare__4.Gui.Enabled then
							v1.RunService.RenderStepped:Wait();
						else
							task.wait(0.5);
						end;					
					end;
				end)();
			end;
			v74();
			v1.GUIFX.ButtonFX(u14.ClaimStage2);
			u14.ClaimStage2.Activated:Connect(function()
				if not u1 then
					u1 = true;
					local v76, v77, v78, v79, v80 = v1.Network.Invoke("Daycare: Claim", v68);
					if not v76 then
						v1.Message.New(v77 or "Something went wrong!");
						u1 = false;
						return;
					end;
					assert(v78);
					assert(v79);
					if v80 then
						if v1.Shared.IsHardcore then
							v65.DaycareHardcoreQueue = v80;
						else
							v65.DaycareQueue = v80;
						end;
						UpdateView();
					end;
					l__Daycare__4.Title.Text = "Your Loot!";
					UpdateClaim(v78, v79);
					u5 = false;
					l__Daycare__4.Categories.ViewPets.Frame.PetReady.Visible = false;
					l__Daycare__4.Categories.Visible = false;
					l__Daycare__4.LootView.Visible = true;
					l__Daycare__4.PetsAndLoot.Visible = false;
					l__Daycare__4.View.Visible = false;
					u1 = false;
				end;
			end);
			task.spawn(function()
				while true do
					if u14 then

					else
						break;
					end;
					if u14.Parent then

					else
						break;
					end;
					if l__Daycare__4.Gui.Enabled then
						v74();
					end;
					v1.Heartbeat(5);				
				end;
			end);
		end;	
	end;
	for v81, v82 in ipairs(l__Holder__66:GetChildren()) do
		local v84 = v82:GetAttribute("SlotId");
		if v84 then
			if not v67[v84] then
				v82:Destroy();
			end;
		end;	
	end;
	l__Daycare__4.View.None.Visible = #v67 <= 0;
	l__Daycare__4.ClaimAll.ImageColor3 = u5 and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
	l__Daycare__4.SlotAmount.Text = GetUsedSlots() .. "/" .. GetMaxSlots() .. " Slots";
	QueueScrolling();
end;
function QueueScrolling()
	local l__Holder__85 = l__Daycare__4.View.Holder;
	local v86 = l__Holder__85:FindFirstChildOfClass("UIPadding");
	local v87 = l__Holder__85:FindFirstChildOfClass("UIListLayout");
	v87:ApplyLayout();
	l__Holder__85.CanvasSize = UDim2.new(0, v87.AbsoluteContentSize.X + v86.PaddingLeft.Offset + v86.PaddingRight.Offset, 0, 0);
end;
function GetRemainingSlots()
	return math.max(0, GetMaxSlots() - GetUsedSlots());
end;
function GetMaxSlots()
	local v88 = v1.Save.Get();
	if not v88 then
		return 0;
	end;
	assert(v88);
	if v1.Shared.IsHardcore then
		local l__DaycareHardcoreQueue__89 = v88.DaycareHardcoreQueue;
	else
		local l__DaycareQueue__90 = v88.DaycareQueue;
	end;
	return v1.Shared.DaycareComputeSlotsForTier(v88.DaycareTier);
end;
function GetUsedSlots()
	local v91 = v1.Save.Get();
	if not v91 then
		return 0;
	end;
	assert(v91);
	local v92 
	if v1.Shared.IsHardcore then
		v92 = v91.DaycareHardcoreQueue;
	else
		v92 = v91.DaycareQueue;
	end;
	return #v92;
end;
function UpdateSelectedAmount()
	l__Daycare__4.AmountStage2.Text = "Selected " .. #u2 .. "/" .. GetRemainingSlots() .. " Pets";
end;
function isVisible()
	return l__Daycare__4.Gui.Enabled;
end;
local u15 = false;
local u16 = true;
local u17 = false;
function UpdateEnroll(p6)
	if u15 then
		return;
	end;
	u15 = true;
	if not u16 then
		u15 = false;
		return;
	end;
	if not isVisible() then
		u15 = false;
		return;
	end;
	local v93 = v1.Save.Get();
	if not v93 then
		u15 = false;
		return;
	end;
	assert(v93);
	if not v93.Pets then
		u15 = false;
		v1.Print("Failed to grab pets", true);
		return;
	end;
	u16 = false;
	local v94 = 0 < #u2;
	l__Daycare__4.DividerStage2.Visible = v94;
	l__Daycare__4.Holder1Stage2.Visible = v94;
	l__Daycare__4.Holder2Stage2.Visible = v94;
	l__Daycare__4.TimerFrameStage2.Visible = v94;
	l__Daycare__4.TimerStage2.Visible = v94;
	l__Daycare__4.AmountStage2.Visible = v94;
	l__Daycare__4.NoticeOnStage1.Visible = not v94;
	l__Daycare__4.HolderStage1.Visible = not v94;
	l__Daycare__4.NoticeStage1.Visible = not v94;
	l__Daycare__4.TitleRight.Text = "Possible Loot";
	l__Daycare__4.TitleRight.Visible = v94;
	l__Daycare__4.SlotAmount.Visible = not v94;
	local v95 = v94 and l__Daycare__4.Holder1Stage2 or l__Daycare__4.HolderStage1;
	for v96, v97 in ipairs(v95:GetChildren()) do
		if v97:isA("TextButton") then
			if not v1.PetCmds.Get(v97.Name) then
				v97:Destroy();
			end;
		end;	
	end;
	local v99 = 0;
	for v100, v101 in ipairs((v1.Shared.SortPets(v93, table.clone(v93.Pets), true))) do
		local v103 = v1.Shared.HasPetEquipped(v93, v101);
		local v104 = v95:FindFirstChild(v101.uid);
		if v104 then
			if v104.Locked.Visible ~= v101.l then
				v104.Locked.Visible = v101.l;
			end;
			if v104.Stars.Visible ~= not v104.Locked.Visible then
				v104.Stars.Visible = not v104.Locked.Visible;
			end;
			if v104.LayoutOrder ~= v100 then
				v104.LayoutOrder = v100;
			end;
		else
			local l__uid__105 = v101.uid;
			local l__s__106 = v101.s;
			local l__g__107 = v101.g;
			local l__r__108 = v101.r;
			local l__dm__109 = v101.dm;
			local v110 = v1.Directory.Pets[v101.id];
			local l__rarity__111 = v110.rarity;
			if not v110.huge then
				if v110.companionEnchantLevel == nil then
					if not v110.titanic then
						if v110.isGift then

						else
							local v112 = v1.Assets.UI.Inventory.Pet:Clone();
							v1.PetUI.Create(v112, l__uid__105);
							v112.LayoutOrder = v100;
							v112:SetAttribute("DirId", v101.id);
							v112:SetAttribute("Hardcore", v101.hc);
							v112.Parent = v95;
							local u18 = v101;
							v112.Activated:Connect(function()
								if not u1 then
									u1 = true;
									u18 = v1.PetCmds.Get(l__uid__105);
									local v113 = v1.Signal.Invoke("Is Trading Booth Pet", l__uid__105);
									if u18.l then
										v1.Message.New("This pet is locked! Unlock it before you can enroll it in Daycare!");
									elseif v113 then
										v1.Message.New("This pet is currently in your trading booth! Remove it before you can enroll it in Daycare!");
									elseif not v1.Functions.SearchArray(u2, l__uid__105) then
										PetsSelect(l__uid__105);
									else
										PetsDeselect(l__uid__105);
									end;
									u1 = false;
								end;
							end);
							v1.GUIFX.ButtonFX(v112);
							v99 = v99 + 1;
						end;
					end;
				end;
			end;
		end;	
	end;
	if v94 then
		if not p6 then
			local l__Holder2Stage2__114 = l__Daycare__4.Holder2Stage2;
			if not u17 then
				u17 = true;
				local v115 = {};
				local v116 = nil;
				if not p6 then
					local v117, v118 = v1.Network.Invoke("Daycare: Compute Loot", u2);
					v115 = v117;
					v116 = v118;
				end;
				u17 = false;
				if not v115 then
					v1.Message.New(v116 or "Error!");
					u15 = false;
					return;
				end;
				assert(v115);
				for v119, v120 in ipairs(l__Holder2Stage2__114:GetChildren()) do
					if v120.ClassName == "Frame" then
						if not v120:GetAttribute("template") then
							v120:Destroy();
						end;
					end;				
				end;
				local l__Loot__122 = l__Holder2Stage2__114:FindFirstChild("Loot");
				l__Loot__122.Visible = false;
				for v123, v124 in ipairs(v115) do
					local v126 = l__Loot__122:Clone();
					v126:SetAttribute("template", false);
					v126.LootRange.Range.AutoLocalize = false;
					v126.LootRange.Range.Text = v1.Functions.NumberShorten(v124.Min) .. " - " .. v1.Functions.NumberShorten(v124.Max);
					if v124.Min == 0 then
						v126.LootRange.Range.Text = "Max " .. v1.Functions.NumberShorten(v124.Max);
					end;
					if v124.Category == "Currency" then
						local v127 = v1.Directory.Currency[v124.Data];
						v126.NonPet.Icon.Image = v127.ImageTiny;
						if u6[v124.Data] then
							v126.NonPet.Icon.Position = u6[v124.Data].Position;
							v126.NonPet.Icon.Size = u6[v124.Data].Size;
						else
							v126.NonPet.Icon.Position = u6.Currency.Position;
							v126.NonPet.Icon.Size = u6.Currency.Size;
						end;
						if v1.Shared.IsHardcore then
							if v127.HardcoreSeparate then
								v126.NonPet.Icon.HC.Visible = true;
							end;
						end;
						v1.GUIFX.Tooltip(v126.NonPet, v124.Data);
					elseif v124.Category == "Boost" then
						v126.NonPet.Icon.Image = u7[v124.Data];
						if u6[v124.Data] then
							v126.NonPet.Icon.Position = u6[v124.Data].Position;
							v126.NonPet.Icon.Size = u6[v124.Data].Size;
						end;
						v1.GUIFX.Tooltip(v126.NonPet, v124.Data);
					elseif v124.Category == "Pet" then
						v126.NonPet.Visible = false;
						local l__Data__128 = v124.Data;
						local l__id__129 = l__Data__128.id;
						local l__isGolden__130 = l__Data__128.isGolden;
						local l__isRainbow__131 = l__Data__128.isRainbow;
						local l__isDarkMatter__132 = l__Data__128.isDarkMatter;
						local v133 = v1.Directory.Pets[l__id__129];
						local v134 = v1.Assets.UI.Inventory.Pet:Clone();
						v1.PetUI.Create(v134, l__id__129, {
							g = l__isGolden__130, 
							r = l__isRainbow__131, 
							dm = l__isDarkMatter__132
						});
						v134:FindFirstChild("Level"):Destroy();
						v134:SetAttribute("petId", l__id__129);
						v134:SetAttribute("name", v133.name);
						v134:SetAttribute("rarity", v133.rarity);
						v134:SetAttribute("isGolden", l__isGolden__130);
						v134:SetAttribute("isRainbow", l__isRainbow__131);
						v134:SetAttribute("isDarkMatter", l__isDarkMatter__132);
						local v135 = v134:GetAttribute("petId");
						local v136 = v134:GetAttribute("isGolden");
						local v137 = v134:GetAttribute("isRainbow");
						local v138 = v134:GetAttribute("isDarkMatter");
						if v136 then

						elseif v137 then

						elseif v138 then

						end;
						v134.PetIcon.ImageColor3 = Color3.new(1, 1, 1) or Color3.new(0, 0, 0);
						v134.PetIcon.Locked.Visible = false;
						if v136 then

						elseif v137 then

						elseif v138 then

						end;
						v126.LootRange.Range.Text = "???";
						v134.Parent = v126;
					elseif u6[v124.Data] then
						v126.NonPet.Icon.Position = u6[v124.Data].Position;
						v126.NonPet.Icon.Size = u6[v124.Data].Size;
					end;
					v126.Parent = l__Holder2Stage2__114;
					v126.Visible = true;				
				end;
			end;
		end;
	end;
	l__Daycare__4.EnrollStage12.ImageColor3 = 0 < #u2 and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
	PetsUpdate();
	u15 = false;
end;
function UpdateEnrollLazy(p7)
	u16 = true;
	UpdateEnroll(p7);
end;
function ScaleScrolling()
	local v139 = 0 < #u2;
	local v140 = v139 and l__Daycare__4.Holder1Stage2 or l__Daycare__4.HolderStage1;
	local v141
	if v139 then
		v141 = 2;
	else
		v141 = 1;
	end;
	local v142 = v140:FindFirstChildOfClass("UIGridLayout");
	local v143 = v140:FindFirstChildOfClass("UIPadding");
	local v144 = v1.Functions.ResolutionScale();
	local v145
	if v144 <= 0.5 then
		v145 = 4 / v141;
	elseif v144 <= 1.1 then
		v145 = 5 / v141;
	else
		v145 = 6 / v141;
	end;
	local v146 = (v140.AbsoluteSize.X - v140.ScrollBarThickness - v143.PaddingLeft.Offset - v143.PaddingRight.Offset) / v145 - v142.CellPadding.X.Offset;
	v142.CellSize = UDim2.new(0, v146, 0, v146);
	v142:ApplyLayout();
	v140.CanvasSize = UDim2.new(0, v142.AbsoluteContentSize.X, 0, v142.AbsoluteContentSize.Y + 30);
	if v139 then
		local l__Holder2Stage2__147 = l__Daycare__4.Holder2Stage2;
		local v148 = l__Holder2Stage2__147:FindFirstChildOfClass("UIListLayout");
		local v149 = l__Holder2Stage2__147:FindFirstChildOfClass("UIPadding");
		v148:ApplyLayout();
		l__Holder2Stage2__147.CanvasSize = UDim2.new(0, 0, 0, v148.AbsoluteContentSize.Y + v149.PaddingBottom.Offset + v149.PaddingTop.Offset);
	end;
end;
v1.GUIFX.ButtonFX(l__Daycare__4.OpenEnrollMenu);
l__Daycare__4.EnrollStage12.Activated:Connect(function()
	if not u1 then
		u1 = true;
		if #u2 > 0 then
			local v150 = v1.Save.Get();
			if v150 and v1.Message.New("Put these pets in daycare? They cannot be taken out early!", true) then
				local v151, v152, v153 = v1.Network.Invoke("Daycare: Enroll", u2);
				if v151 then
					u2 = {};
					l__Daycare__4.PetsAndLoot.Visible = false;
					l__Daycare__4.Categories.Visible = false;
					l__Daycare__4.View.Visible = true;
					if v153 then
						if v1.Shared.IsHardcore then
							v150.DaycareHardcoreQueue = v153;
						else
							v150.DaycareQueue = v153;
						end;
					end;
					l__Daycare__4.Title.Text = "Daycare!";
					UpdateView();
					UpdateEnrollLazy(true);
				else
					v1.Message.New(v152 or "Something went wrong!");
				end;
			end;
		end;
		u1 = false;
	end;
end);
v1.GUIFX.ButtonFX(l__Daycare__4.ClaimAll);
l__Daycare__4.ClaimAll.Activated:Connect(function()
	if not u1 then
		u1 = true;
		local v154 = v1.Save.Get();
		if not v154 then
			u1 = false;
			v1.Message.New("Something went wrong! Try re-logging!");
			return;
		end;
		assert(v154);
		local v155, v156, v157, v158, v159 = v1.Network.Invoke("Daycare: Claim", nil);
		if not v155 then
			v1.Message.New(v156 or "Something went wrong!");
			u1 = false;
			return;
		end;
		assert(v157);
		assert(v158);
		if v159 then
			if v1.Shared.IsHardcore then
				v154.DaycareHardcoreQueue = v159;
			else
				v154.DaycareQueue = v159;
			end;
			UpdateView();
		end;
		l__Daycare__4.Title.Text = "Your Loot!";
		UpdateClaim(v157, v158);
		l__Daycare__4.Categories.Visible = false;
		l__Daycare__4.LootView.Visible = true;
		l__Daycare__4.PetsAndLoot.Visible = false;
		l__Daycare__4.View.Visible = false;
		u5 = false;
		l__Daycare__4.Categories.ViewPets.Frame.PetReady.Visible = false;
		u1 = false;
	end;
end);
v1.GUIFX.ButtonFX(l__Daycare__4.UpgradeSlots);
l__Daycare__4.UpgradeSlots.Activated:Connect(function()
	local v160, v161
	if not u1 then
		u1 = true;
		v160, v161 = v1.Network.Invoke("Attempt Buy +10 Daycare Slots");
		if v160 == true then
			v1.Shared.PromptPurchase(1378709263, true);
			u1 = false;
			return;
		end;
	else
		return;
	end;
	v1.Message.New(v161);
	u1 = false;
end);
v1.GUIFX.ButtonFX(l__Daycare__4.OpenEnrollMenu);
l__Daycare__4.OpenEnrollMenu.Activated:Connect(function()
	if not u1 then
		u1 = true;
		UpdateEnrollLazy();
		l__Daycare__4.Title.Text = "Daycare!";
		l__Daycare__4.LootView.Visible = false;
		l__Daycare__4.Categories.Visible = false;
		l__Daycare__4.PetsAndLoot.Visible = true;
		u1 = false;
	end;
end);
v1.GUIFX.ButtonFX(l__Daycare__4.OpenViewMenu);
l__Daycare__4.OpenViewMenu.Activated:Connect(function()
	if not u1 then
		u1 = true;
		UpdateView();
		l__Daycare__4.Title.Text = "Daycare!";
		l__Daycare__4.LootView.Visible = false;
		l__Daycare__4.Categories.Visible = false;
		l__Daycare__4.View.Visible = true;
		u1 = false;
	end;
end);
v1.GUIFX.ButtonFX(l__Daycare__4.Close);
l__Daycare__4.Close.Activated:Connect(function()
	if not u1 then
		u1 = true;
		l__Daycare__4.TitleRight.Visible = false;
		l__Daycare__4.LootView.Visible = false;
		l__Daycare__4.Categories.Visible = true;
		l__Daycare__4.PetsAndLoot.Visible = false;
		l__Daycare__4.View.Visible = false;
		u2 = {};
		l__Daycare__4.Gui.Enabled = false;
		if u8 then
			u8 = nil;
			v1.Signal.Fire("Open Egg", "Huge Machine Egg 1", { u8 });
		end;
		u1 = false;
	end;
end);
v1.Signal.Fired("Window Opened"):Connect(function(p8)
	if p8 == l__Daycare__4.Gui then
		l__Daycare__4.LootView.Visible = false;
		l__Daycare__4.Categories.Visible = true;
		l__Daycare__4.PetsAndLoot.Visible = false;
		l__Daycare__4.View.Visible = false;
		l__Daycare__4.Title.Text = "Daycare!";
		v1.Audio.Play("rbxassetid://7495293012", script, 1, 0.4);
	end;
end);
v1.Signal.Fired("Window Closed"):Connect(function(p9)
	if p9 == l__Daycare__4.Gui then
		Update();
		l__Daycare__4.LootView.Visible = false;
		l__Daycare__4.Categories.Visible = true;
		l__Daycare__4.PetsAndLoot.Visible = false;
		l__Daycare__4.View.Visible = false;
	end;
end);
v1.Signal.Fired("Resolution Changed"):Connect(function()
	if l__Daycare__4.Gui.Enabled then
		task.defer(function()
			ScaleScrolling();
		end);
	end;
end);
v1.Signal.Fired("Stat Changed"):Connect(function(p10)
	if p10 == "DaycareQueue" then
		UpdateView();
	end;
	if p10 == "DaycareTier" then
		Update();
		UpdateView();
	end;
end);
UpdateEnrollLazy();
UpdateView();
Update();
l__Daycare__4.LootView.Visible = false;
l__Daycare__4.Categories.Visible = true;
l__Daycare__4.PetsAndLoot.Visible = false;
l__Daycare__4.View.Visible = false;
