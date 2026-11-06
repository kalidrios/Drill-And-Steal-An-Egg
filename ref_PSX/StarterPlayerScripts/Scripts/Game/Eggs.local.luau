-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local Random_new_ret = Random.new();
local t_ID = m_Library.Directory.Gamepasses["Triple Egg Open"].ID;
local t_ID2 = m_Library.Directory.Gamepasses["Auto Hatch"].ID;
local t_IsHardcore = m_Library.Shared.IsHardcore;
local u1 = m_Library.Player.PlayerGui();
local u2 = nil;
local table1 = {};
local bool1 = false;
local table2 = {};
local table3 = nil;
local num1 = 1;
local num2 = 1;
function SetupEgg(p1) -- Line: 28
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
			[3] = table3
			[4] = bool1
			[5] = t_IsHardcore
			[6] = num2
			[7] = num1
			[8] = t_ID
			[9] = table1
			[10] = t_ID2
	--]]
	local Attribute = p1:GetAttribute("ID");
	local u3 = m_Library.Directory.Eggs[Attribute];
	local Center = p1:FindFirstChild("Center");
	local bool2 = false;
	local u4 = nil;
	local u5 = nil;
	local function Show() -- Line: 38
		--[[
			Upvalues:
				[1] = p1
				[2] = m_Library
				[3] = u3
		--]]
		local Attribute2 = p1:GetAttribute("Unlocked");
		local Clone_ret = m_Library.Assets.Billboards.EggInfo:Clone();
		local t_drops = u3.drops;
		local t_isGolden = u3.isGolden;
		local v20 = m_Library.Save.Get();
		if type(t_drops) == "string" then
			t_drops = m_Library.Directory.Eggs[t_drops].drops;
		end
		for key10, val10 in ipairs(t_drops) do
			local v29 = val10[1];
			local v30 = m_Library.Directory.Pets[v29];
			local t_rarity = v30.rarity;
			local v31 = val10[3];
			if t_rarity == "Secret" or v31 and not m_Library.Shared.IsHardcore then continue end
			local Clone_ret2 = m_Library.Assets.UI.EggInfo.Pet:Clone();
			Clone_ret2:SetAttribute("PetId", v29);
			local function CalculatePetChance() -- Line: 63
				--[[
					Upvalues:
						[1] = t_drops
						[2] = val10
				--]]
				local v40 = 0;
				for _, val14 in ipairs(t_drops) do
					v40 = v40 + val14[2];
				end
				return val10[2] / v40 * 100;
			end
			local function GetCollection()
				_string = "-"
				if t_isGolden then
					_string = _string .. "2"
				else
					_string = _string .. "1"
				end
				return v29.._string
			end
			local v32 = 0;
			for _, val13 in ipairs(t_drops) do
				v32 = v32 + val13[2];
			end
			local v33 = val10[2] / v32 * 100;
			Clone_ret2.Thumbnail.Image = t_isGolden and v30.goldenThumbnail or v30.thumbnail;
			Clone_ret2.LayoutOrder = 9999 - v33;
			if v20.AutoDelete[v30.rarity] then
				Clone_ret2.DeleteImage.Visible = true;
			else
				Clone_ret2.DeleteImage.Visible = false;
			end
			
			local colorVariants = v30.colorVariants 
			if colorVariants then
				task.defer(function()
					task.spawn(function()
						local index = 1
						while true do
							if not (Clone_ret and Clone_ret.Parent) then
								break
							end
							local colorData = colorVariants[index]
							if not colorData then
								index = 1
								colorData = colorVariants[index]
							end
							Clone_ret2.Thumbnail.ImageColor3 = colorData.Color
							index = index + 1
							wait(1)
						end
					end)
				end)
			end
			
			local CollectionString = GetCollection()
			if Attribute2 then
				if not table.find(v20.Collection, CollectionString) then
					Clone_ret2.Thumbnail.ImageColor3 = Color3.fromRGB(179, 179, 179);
				end
			end	
			if not Attribute2 then
				Clone_ret2.Thumbnail.ImageColor3 = Color3.new(0, 0, 0);
				Clone_ret2.Thumbnail.Chance.Text = "??";
				Clone_ret2.Thumbnail.Chance.TextColor3 = Color3.new(1, 1, 1);
			elseif t_rarity == "Legendary" or t_rarity == "Mythical" or t_rarity == "Event" or t_rarity == "Exclusive" or v33 <= 0.0099 then
				Clone_ret2.Thumbnail.Chance.Text = "??";
				m_Library.GUIFX.Rainbow(Clone_ret2.Thumbnail.Chance, "TextColor3");
			else
				local math_clamp_ret = math.clamp(math.pow(0.9315, v33) * 94.2467 / 100, 0, 1);
				local Lerp_ret = Color3.fromRGB(49, 255, 39):Lerp(Color3.fromRGB(255, 75, 39), math_clamp_ret);
				local Color3_toHSV_ret1, Color3_toHSV_ret2, Color3_toHSV_ret3 = Color3.toHSV(Lerp_ret);
				local Color3_fromHSV_ret = Color3.fromHSV(Color3_toHSV_ret1, Color3_toHSV_ret2, Color3_toHSV_ret3 * 2);
				Clone_ret2.Thumbnail.Chance.TextColor3 = Color3_fromHSV_ret;
				Clone_ret2.Thumbnail.Chance.Text = m_Library.Functions.FormatChance(v33 / 100);
			end
			if v30.titanic then
				Clone_ret2.TitanicCrown.Visible = true;
			end

			Clone_ret2.Thumbnail.Position = UDim2.new(0, 0, 1, 0);
			Clone_ret2.Thumbnail.ImageTransparency = 1;
			m_Library.Functions.Tween(Clone_ret2.Thumbnail, {
				Position = UDim2.new(0, 0, 0, 0),
				ImageTransparency = Attribute2 and 0 or 0.5
			}, {
				key10 / 9 / 3 + 0.45,
				Enum.EasingStyle.Quart,
				Enum.EasingDirection.Out
			});
			Clone_ret2.Parent = Clone_ret.Frame.Pets;
		end
		Clone_ret.Size = UDim2.new(0, 0, 0, 0);
		Clone_ret.StudsOffset = Vector3.new(0, 4, 0);
		m_Library.Functions.Tween(Clone_ret, {
			Size = UDim2.new(10, 0, 10, 0),
			StudsOffset = Vector3.new(0, 10, 0)
		}, {
			0.2,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.Out
		});
		local UIGridLayout = Clone_ret.Frame.Pets:FindFirstChild("UIGridLayout");
		UIGridLayout:ApplyLayout();
		Clone_ret.Parent = p1;
	end
	local function Hide() -- Line: 136
		--[[
			Upvalues:
				[1] = p1
				[2] = m_Library
		--]]
		local EggInfo = p1:FindFirstChild("EggInfo");
		if EggInfo then
			m_Library.Functions.Tween(EggInfo, {
				Size = UDim2.new(0, 0, 0, 0),
				StudsOffset = Vector3.new(0, 4, 0)
			}, {
				0.15,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.In
			}).Completed:Connect(function() -- Line: 140
				--[[
					Upvalues:
						[1] = EggInfo
				--]]
				EggInfo:Destroy();
			end);
		end
	end
	local function HideAutoInterface() -- Line: 150
		--[[
			Upvalues:
				[1] = u1
				[2] = Attribute
				[3] = m_Library
				[4] = table3
		--]]
		local FindFirstChild_ret = u1:FindFirstChild("__AUTOHATCH" .. Attribute);
		if FindFirstChild_ret then
			m_Library.Functions.Tween(FindFirstChild_ret, {
				Size = UDim2.new(0, 0, 0, 0),
				StudsOffset = Vector3.new(0, -2, 0)
			}, {
				0.15,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.In
			}).Completed:Connect(function() -- Line: 154
				--[[
					Upvalues:
						[1] = FindFirstChild_ret
						[2] = table3
						[3] = Attribute
						[4] = m_Library
				--]]
				FindFirstChild_ret:Destroy();
				if table3 and table3.eggId == Attribute and m_Library.Variables.OpeningEgg <= 0 then
					table3 = nil;
				end
			end);
		end
	end
	local function ShowAutoInterface() -- Line: 164
		--[[
			Upvalues:
				[1] = m_Library
				[2] = table3
				[3] = Attribute
				[4] = Center
				[5] = p1
				[6] = u1
				[7] = bool1
				[8] = HideAutoInterface
		--]]
		local Clone_ret3 = m_Library.Assets.Billboards.AutoHatch:Clone();
		table3 = {
			billboard = Clone_ret3,
			eggId = Attribute,
			root = Center
		};
		Clone_ret3.Size = UDim2.new(0, 0, 0, 0);
		Clone_ret3.StudsOffset = Vector3.new(0, -2, 0);
		m_Library.Functions.Tween(Clone_ret3, {
			Size = UDim2.new(10, 0, 5, 0),
			StudsOffset = Vector3.new(0, -6, 0)
		}, {
			0.15,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.Out
		});
		Clone_ret3.Name = "__AUTOHATCH" .. Attribute;
		Clone_ret3.Adornee = p1;
		Clone_ret3.Parent = u1;
		local t_Toggle = Clone_ret3.Frame.Toggle;
		m_Library.GUIFX.ButtonFX(t_Toggle);
		t_Toggle.Activated:Connect(function() -- Line: 180
			--[[
				Upvalues:
					[1] = bool1
					[2] = m_Library
					[3] = Attribute
			--]]
			if not bool1 then
				bool1 = true;
				m_Library.Audio.Play("rbxassetid://7004248320", script, 1, 0.5);
				ToggleAutoHatch(nil, Attribute);
				bool1 = false;
			end
		end);
		local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 191
			--[[
				Upvalues:
					[1] = Clone_ret3
					[2] = table3
					[3] = Attribute
					[4] = HideAutoInterface
					[5] = m_Library
					[6] = t_Toggle
			--]]
			while true do
				if Clone_ret3 and Clone_ret3.Parent then
					if not table3 or table3.eggId ~= Attribute then
						HideAutoInterface();
						return;
					end
					local t_AutoHatchEnabled = m_Library.Variables.AutoHatchEnabled;
					t_Toggle.Image = t_AutoHatchEnabled and "rbxassetid://7045637481" or "rbxassetid://7045637286";
					t_Toggle.HoverImage = t_AutoHatchEnabled and "rbxassetid://7045637564" or "rbxassetid://7045637411";
					t_Toggle.Label.Text = t_AutoHatchEnabled and "Turn Off" or "Turn On";
					m_Library.Heartbeat();
					continue;
				end
				return;
			end
		end);
		coroutine_wrap_ret();
	end
	local function Buy() -- Line: 211
		--[[
			Upvalues:
				[1] = m_Library
				[2] = t_IsHardcore
				[3] = u3
				[4] = num2
				[5] = num1
				[6] = t_ID
				[7] = Attribute
		--]]
		local v21 = m_Library.Save.Get();
		if not v21 then return end
		local v22 = (t_IsHardcore and u3.hardcoreCost or u3.cost) * (u3.isGolden and num2 or num1);
		local v23 = m_Library.Gamepasses.Owns(t_ID);
		local t_OwnsOctupleEggs = v21.OwnsOctupleEggs;
		local v24 = "Buy and open a " .. u3.displayName .. " for " .. m_Library.Functions.Commas(v22) .. " " .. u3.currency .. "?";
		--local v25 = t_OwnsOctupleEggs and m_Library.Message.New(v24, "Buy 1", "Buy 3", "Buy 8") or v23 and m_Library.Message.New(v24, "Buy 1", "Buy 3") or m_Library.Message.New(v24, true);
		local v25
		if t_OwnsOctupleEggs then
			v25 = m_Library.Message.New(v24, "Buy 1", "Buy 3", "Buy 8")
		elseif v23 then
			v25 = m_Library.Message.New(v24, "Buy 1", "Buy 3")
		else
			v25 = m_Library.Message.New(v24, true)
		end
		if v25 then
			local v34, v35 = m_Library.Network.Invoke("Buy Egg", Attribute, v25 == 2, v25 == 3);
			if not v34 then
				m_Library.Message.New(v35 or "Something went wrong. Try again!");
				return;
			end
			m_Library.Audio.Play("rbxassetid://7009857460", script);
		end
	end
	local function ShowButton() -- Line: 248
		--[[
			Upvalues:
				[1] = u5
				[2] = u4
				[3] = m_Library
				[4] = Center
				[5] = table1
				[6] = bool1
				[7] = Buy
		--]]
		u5, u4 = m_Library.Interact.Add(Center.CFrame.p + Vector3.new(0, -0.5, 0), {
			dist = 15,
			label = "Buy Box!"
		});
		table.insert(table1, u4);
		u5:Connect(function() -- Line: 254
			--[[
				Upvalues:
					[1] = bool1
					[2] = Buy
			--]]
			if not bool1 then
				bool1 = true;
				Buy();
				task.delay(0.5, function() -- Line: 258
					--[[
						Upvalues:
							[1] = bool1
					--]]
					bool1 = false;
				end);
			end
		end);
	end
	local function CancelButton() -- Line: 267
		--[[
			Upvalues:
				[1] = u4
		--]]
		if u4 then
			u4();
			u4 = nil;
		end
	end
	local coroutine_wrap_ret2 = coroutine.wrap(function() -- Line: 276
		--[[
			Upvalues:
				[1] = m_Library
				[2] = p1
				[3] = Center
				[4] = bool2
				[5] = Hide
				[6] = u4
				[7] = Show
				[8] = u1
				[9] = Attribute
				[10] = t_ID2
				[11] = table3
				[12] = ShowAutoInterface
				[13] = HideAutoInterface
				[14] = ShowButton
		--]]
		local _ = m_Library.Save.Get();
		while p1 and p1.Parent do
			local Attribute3 = p1:GetAttribute("Unlocked");
			local v36 = m_Library.Variables.OpeningEgg > 0;
			local v37 = m_Library.LocalPlayer:DistanceFromCharacter(Center.CFrame.p) <= 25;
			while true do
				if p1:GetAttribute("Enabled") ~= nil and p1:GetAttribute("Enabled") == false then
					if bool2 and (not v37 or v36) then
						bool2 = false;
						Hide();
					end
					if u4 then
						u4();
						u4 = nil;
					end
					m_Library.Heartbeat(5);
					break;
				end
				local EggInfo2 = p1:FindFirstChild("EggInfo");
				if not bool2 and v37 and not EggInfo2 and not v36 then
					bool2 = true;
					Show();
				elseif bool2 and (not v37 or v36) then
					bool2 = false;
					Hide();
				end
				local FindFirstChild_ret2 = u1:FindFirstChild("__AUTOHATCH" .. Attribute);
				if m_Library.Gamepasses.Owns(t_ID2) and Attribute3 then
					local v41 = not v36 and v37;
					if not FindFirstChild_ret2 and v41 then
						if table3 then
							if table3.eggId == Attribute then
								ShowAutoInterface();
								break;
							end
							if m_Library.LocalPlayer:DistanceFromCharacter(table3.root.CFrame.p) - 1 >= m_Library.LocalPlayer:DistanceFromCharacter(Center.CFrame.p) then
								if m_Library.Variables.AutoHatchEnabled and m_Library.Variables.AutoHatchEggId ~= Attribute then
									ToggleAutoHatch(false);
								end
								ShowAutoInterface();
							end
						else
							ShowAutoInterface();
						end
					elseif FindFirstChild_ret2 and not v41 then
						HideAutoInterface();
					elseif not v37 and m_Library.Variables.AutoHatchEggId == Attribute then
						ToggleAutoHatch(false);
					end
				end
				local v38 = u4 ~= nil;
				if not v36 and Attribute3 and not v38 then
					ShowButton();
				elseif (v36 or not Attribute3) and v38 and u4 then
					u4();
					u4 = nil;
				end
				m_Library.Heartbeat(5);
				break;
			end
		end
	end);
	coroutine_wrap_ret2();
end
function UpdateEgg(p2) -- Line: 352
	--[[
		Upvalues:
			[1] = m_Library
			[2] = Random_new_ret
			[3] = t_IsHardcore
			[4] = num2
			[5] = num1
	--]]
	local v1 = m_Library.Save.Get();
	if not v1 then return end
	local Attribute4 = p2:GetAttribute("ID");
	local v2 = m_Library.Directory.Eggs[Attribute4];
	if not v2 then
		m_Library.Print("Egg directory is missing for ID: " .. Attribute4, true);
		return;
	end
	local Center2 = p2:FindFirstChild("Center");
	local u12 = p2:FindFirstChild("Egg");
	local Attribute5 = p2:GetAttribute("Unlocked");
	local Attribute6 = p2:GetAttribute("CanAfford");
	if not p2:GetAttribute("Setup") then
		p2:SetAttribute("Setup", true);
		u12 = v2.model:Clone();
		for _, descendant3 in ipairs(u12:GetDescendants()) do
			if not descendant3:IsA("BasePart") then continue end
			descendant3.Anchored = false;
			m_Library.Functions.Weld(descendant3, u12);
		end
		u12.Name = "Egg";
		u12.Anchored = true;
		u12.CFrame = CFrame.new(Center2.CFrame.p);
		u12.Parent = p2;
		local coroutine_wrap_ret3 = coroutine.wrap(function() -- Line: 392
			--[[
				Upvalues:
					[1] = u12
					[2] = Random_new_ret
					[3] = p2
					[4] = m_Library
			--]]
			local t_CFrame = u12.CFrame;
			local NextNumber_ret = Random_new_ret:NextNumber(1, 10);
			local os_clock_ret = os.clock();
			local os_clock_ret2 = nil;
			while p2 and p2.Parent do
				if not os_clock_ret2 or os.clock() - os_clock_ret2 >= 2 then
					local DistanceFromCharacter_ret = m_Library.LocalPlayer:DistanceFromCharacter(u12.CFrame.p);
					if DistanceFromCharacter_ret >= 300 then
						wait((math.clamp(DistanceFromCharacter_ret / 600, 0.5, 3)));
					else
						os_clock_ret2 = os.clock();
					end
				end
				local v42 = os.clock() - os_clock_ret + NextNumber_ret;
				u12.CFrame = t_CFrame * CFrame.new(0, math.sin(v42 * 1) / 2, 0) * CFrame.Angles(0, v42, 0);
				m_Library.RenderStepped();
			end
		end);
		coroutine_wrap_ret3();
		SetupEgg(p2);
	end
	if p2:FindFirstChild("EggInfo") then
		local EggInfo3 = p2:FindFirstChild("EggInfo");
		local t_drops2 = v2.drops;
		local _ = v2.isGolden;
		if type(t_drops2) == "string" then
			local _ = m_Library.Directory.Eggs[t_drops2].drops;
		end
		if EggInfo3:FindFirstChild("Frame") and EggInfo3:FindFirstChild("Frame"):FindFirstChild("Pets") then
			local Pets = EggInfo3:FindFirstChild("Frame"):FindFirstChild("Pets");
			for _, child11 in ipairs(Pets:GetChildren()) do
				local Attribute7 = child11:GetAttribute("PetId");
				if not Attribute7 then continue end
				local v39 = m_Library.Directory.Pets[Attribute7];
				local _ = v39.rarity;
				if v1.AutoDelete[v39.rarity] then
					child11.DeleteImage.Visible = true;
					continue;
				end
				child11.DeleteImage.Visible = false;
			end
		end
	end
	local v3 = p2.PriceHUD:FindFirstChild("EggCost");
	if not v3 then
		v3 = m_Library.Assets.Billboards.EggCost:Clone();
		v3.Currency.Image = m_Library.Directory.Currency[v2.currency].Image;
		v3.Parent = p2.PriceHUD;
	end
	v3.Currency.Visible = Attribute5;
	if Attribute5 then
		local v10 = (t_IsHardcore and v2.hardcoreCost or v2.cost) * (v2.isGolden and num2 or num1);
		v3.Amount.Text = m_Library.Functions.NumberShorten(v10);
	else
		v3.Amount.Text = "Locked";
	end
	local v4 = Attribute5 and Attribute6 and (m_Library.Variables.OpeningEgg <= 0 and Attribute4 ~= "Kawaii Alley Egg" or false);
	local VendorBillboard = Center2:FindFirstChild("VendorBillboard");
	if not VendorBillboard and v4 then
		local Clone_ret4 = m_Library.Assets.Billboards.VendorBillboard:Clone();
		local Dir = m_Library.WorldCmds.GetDir();
		if Dir and Dir.display == "Doodle World" then
			Clone_ret4.TextLabel.Visible = false;
			Clone_ret4.DoodleDollar.Visible = true;
		end
		Clone_ret4.Parent = Center2;
	elseif not v4 and VendorBillboard then
		VendorBillboard:Destroy();
	end
	local v5 = p2:FindFirstChild("LOCK");
	if not Attribute5 then
		if not v5 then
			v5 = m_Library.Assets.Models.CapsuleLocks:FindFirstChild(v2.isGolden and "Golden Lock" or "Lock"):Clone();
			v5.CFrame = Center2.CFrame * CFrame.Angles(0, 3.141592653589793, 1.5707963267948966) + Vector3.new(0, 0.25, 0);
			v5.Name = "LOCK";
			v5.Parent = p2;
		end
		local SurfaceGui = v5:FindFirstChildOfClass("SurfaceGui");
		if v2.eggRequiredOpenAmount > 0 and v2.eggRequired ~= "" then
			local v26 = v2.eggRequiredOpenAmount - ((t_IsHardcore and v1.Hardcore.EggsOpened or v1.EggsOpened)[v2.eggRequired] or 0);
			SurfaceGui.Frame.Amount.Text = m_Library.Functions.Commas(v26);
		elseif SurfaceGui then
			SurfaceGui:Destroy();
		end
	elseif v5 then
		m_Library.WorldFX.ModelFlash(p2, 0.5);
		v5:Destroy();
	end
	local CachedProperty_ret = CachedProperty(u12, "TextureID");
	local CachedProperty_ret2 = CachedProperty(u12, "Color");
	u12.TextureID = Attribute5 and CachedProperty_ret or "";
	u12.Color = Attribute5 and CachedProperty_ret2 or Color3.new(0, 0, 0);
	if u12:FindFirstChildOfClass("ParticleEmitter") then
		u12:FindFirstChildOfClass("ParticleEmitter").Enabled = Attribute5;
	end
end
function UpdateGroup(p3) -- Line: 520
	local bool3 = false;
	for _, child1 in ipairs(p3.Eggs:GetChildren()) do
		if not child1:GetAttribute("ID") or not child1:GetAttribute("Unlocked") then continue end
		bool3 = true;
		break;
	end
	local PLATFORM = p3:FindFirstChild("PLATFORM");
	if PLATFORM then
		local Pad = PLATFORM:FindFirstChild("Pad");
		local CachedProperty_ret3 = CachedProperty(Pad, "Color");
		Pad.Color = bool3 and CachedProperty_ret3 or Color3.fromRGB(77, 77, 77);
		local _Unlocked = PLATFORM:FindFirstChild("_Unlocked");
		local CachedProperty_ret4 = CachedProperty(_Unlocked, "Color");
		_Unlocked.Color = bool3 and CachedProperty_ret4 or Color3.fromRGB(0, 0, 0);
		local t_TextLabel = PLATFORM:FindFirstChild("SectionName").SurfaceGui.TextLabel;
		local CachedProperty_ret5 = CachedProperty(t_TextLabel, "TextColor3");
		t_TextLabel.TextColor3 = bool3 and CachedProperty_ret5 or Color3.fromRGB(47, 47, 47);
		_Unlocked:FindFirstChildOfClass("SurfaceLight").Enabled = bool3;
	end
end
function UpdateAllEggs() -- Line: 549
	local AllEggs = GetAllEggs();
	if AllEggs then
		for _, val4 in ipairs(AllEggs) do
			UpdateEgg(val4);
		end
	end
end
function UpdateAllGroups() -- Line: 559
	local AllGroups = GetAllGroups();
	if AllGroups then
		for _, val5 in ipairs(AllGroups) do
			UpdateGroup(val5);
		end
	end
end
function GetAllEggs() -- Line: 572
	--[[
		Upvalues:
			[1] = u2
	--]]
	if not u2 then return end
	local table4 = {};
	local Eggs = u2:FindFirstChild("Eggs");
	if Eggs then
		for _, child6 in ipairs(Eggs:GetChildren()) do
			if child6.ClassName ~= "Folder" or not child6:FindFirstChild("Eggs") then continue end
			for _, child12 in ipairs(child6.Eggs:GetChildren()) do
				if not child12:GetAttribute("ID") then continue end
				table.insert(table4, child12);
			end
		end
	end
	return table4;
end
function GetAllGroups() -- Line: 594
	--[[
		Upvalues:
			[1] = u2
	--]]
	if not u2 then return end
	local table5 = {};
	local Eggs2 = u2:FindFirstChild("Eggs");
	if Eggs2 then
		for _, child7 in ipairs(Eggs2:GetChildren()) do
			if child7.ClassName ~= "Folder" or not child7:FindFirstChild("Eggs") then continue end
			table.insert(table5, child7);
		end
	end
	return table5;
end
function UpdateAffordability() -- Line: 615
	--[[
		Upvalues:
			[1] = m_Library
			[2] = num2
			[3] = num1
	--]]
	local v6 = m_Library.Save.Get();
	if not v6 then return end
	local AllEggs2 = GetAllEggs();
	if AllEggs2 then
		for _, val8 in ipairs(AllEggs2) do
			local v27 = m_Library.Directory.Eggs[val8:GetAttribute("ID")];
			local t_currency = v27.currency;
			local v28 = math.round(v27.cost * (v27.isGolden and num2 or num1)) <= v6[t_currency];
			val8:SetAttribute("CanAfford", v28);
		end
	end
end
function UpdateUnlocked() -- Line: 638
	local AllEggs3 = GetAllEggs();
	if AllEggs3 then
		for _, val9 in ipairs(AllEggs3) do
			local Attribute8 = val9:GetAttribute("ID");
			local IsEggUnlocked_ret = IsEggUnlocked(Attribute8);
			val9:SetAttribute("Unlocked", IsEggUnlocked_ret);
		end
	end
end
function IsEggUnlocked(p4) -- Line: 650
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_IsHardcore
	--]]
	local _ = m_Library.WorldCmds.GetDir();
	local v7 = m_Library.Directory.Eggs[p4];
	local v8 = m_Library.Save.Get();
	if v7.areaRequired then
		local v11 = m_Library.WorldCmds.HasArea(v7.area);
		if not v11 then
			return false;
		end
	end
	if v7.eggRequired ~= "" and v7.eggRequired ~= p4 then
		local IsEggUnlocked_ret2 = IsEggUnlocked(v7.eggRequired);
		if not IsEggUnlocked_ret2 then
			return false;
		end
	end
	if v7.eggRequiredOpenAmount > 0 and v7.eggRequired ~= "" then
		local v12 = (t_IsHardcore and v8.Hardcore.EggsOpened or v8.EggsOpened)[v7.eggRequired];
		if not v12 or v12 < v7.eggRequiredOpenAmount then
			return false;
		end
	end
	if p4 == "Dominus Egg" then
		if t_IsHardcore and not v8.Hardcore.OwnsDominusGate then
			return false;
		end
		if not t_IsHardcore and not v8.OwnsDominusGate then
			return false;
		end
	end
	if p4 == "Hacker Egg" or p4 == "Hacker Golden Egg" then
		if t_IsHardcore and not v8.Hardcore.OwnsHackerGate then
			return false;
		end
		if not t_IsHardcore and not v8.OwnsHackerGate then
			return false;
		end
	end
	return true;
end
function UpdateMasteryPerks() -- Line: 705
	--[[
		Upvalues:
			[1] = m_Library
			[2] = num1
			[3] = num2
	--]]
	local v9 = m_Library.Save.Get();
	if v9 then
		local t_Eggs = m_Library.Directory.Mastery.Eggs;
		local v13 = m_Library.Directory.Mastery["Golden Eggs"];
		local v14 = v9.Mastery.Eggs or 0;
		local v15 = v9.Mastery["Golden Eggs"] or 0;
		local v16 = m_Library.Shared.MasteryXPToLevel(v14);
		local v17 = m_Library.Shared.MasteryXPToLevel(v15);
		local v18 = num1;
		local v19 = num2;
		if t_Eggs.perks[4].level <= v16 then
			num1 = 0.8;
		elseif t_Eggs.perks[2].level <= v16 then
			num1 = 0.9;
		end
		if v13.perks[4].level <= v17 then
			num2 = 0.85;
		elseif v13.perks[2].level <= v17 then
			num2 = 0.95;
		end
		if v18 ~= num1 or v19 ~= num2 then
			UpdateAffordability();
			UpdateAllEggs();
		end
	end
end
UpdateMasteryPerks();
function CachedProperty(p5, p6) -- Line: 736
	--[[
		Upvalues:
			[1] = table2
	--]]
	if not table2[p5] then
		table2[p5] = {};
	end
	if not table2[p5][p6] then
		table2[p5][p6] = p5[p6];
	end
	return table2[p5][p6];
end
function Reset() -- Line: 747
	--[[
		Upvalues:
			[1] = table2
			[2] = table1
	--]]
	table2 = {};
	for _, val2 in ipairs(table1) do
		val2();
	end
	table1 = {};
end
function WorldLoaded() -- Line: 758
	Reset();
	UpdateUnlocked();
	UpdateAffordability();
	UpdateAllEggs();
	UpdateAllGroups();
end
function ToggleAutoHatch(p7, p8) -- Line: 769
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.Variables.AutoHatchEggId = p8;
	if p7 ~= nil then
		m_Library.Variables.AutoHatchEnabled = p7;
		return;
	end
	m_Library.Variables.AutoHatchEnabled = not m_Library.Variables.AutoHatchEnabled;
end
m_Library.Signal.Fired("Auto Delete Settings Changed"):Connect(function(_) -- Line: 781
end);
m_Library.Signal.Fired("World Changed"):Connect(function(_, p9) -- Line: 785
	--[[
		Upvalues:
			[1] = u2
	--]]
	u2 = p9;
	WorldLoaded();
end);
m_Library.Signal.Fired("Stat Changed"):Connect(function(p10) -- Line: 791
	if p10 == "AreasUnlocked" or p10 == "EggsOpened" or p10 == "OwnsDominusGate" or p10 == "OwnsHackerGate" or p10 == "Hardcore" then
		UpdateUnlocked();
		UpdateAllEggs();
		UpdateAllGroups();
		return;
	end
	if string.find(p10, "Coins") or p10 == "Diamonds" then
		UpdateAffordability();
		return;
	end
	if p10 == "Mastery" then
		UpdateMasteryPerks();
	end
end);
m_Library.Signal.Invoked("Can Continue Auto").OnInvoke = function() -- Line: 805
	--[[
		Upvalues:
			[1] = table3
			[2] = m_Library
	--]]
	if not table3 then
		return false;
	end
	if m_Library.LocalPlayer:DistanceFromCharacter(table3.root.CFrame.p) <= 12 then
		return true;
	end
	return false;
end
while true do
	if u2 and not m_Library.Variables.LoadingWorld then
		UpdateAllEggs();
	end
	wait(1);
end
