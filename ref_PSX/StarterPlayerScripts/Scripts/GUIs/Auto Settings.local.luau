-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_AutoSettings = m_Library.GUI.AutoSettings;
local AutoSettings = m_Library.GUI.Main.Left.Tools:FindFirstChild("AutoSettings");
local t_ID = m_Library.Directory.Gamepasses["Auto Hatch"].ID;
local bool1 = false;
function ToggleRarity(p1) -- Line: 20
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v1 = m_Library.Save.Get();
	if not v1 then return end
	assert(v1);
	m_Library.Audio.Play("rbxassetid://7004248320", script, 1, 0.5);
	local v2 = v1.AutoDelete[p1] == nil and true or not v1.AutoDelete[p1];
	local v3 = v1.AutoDelete[p1];
	v1.AutoDelete[p1] = v2;
	UpdateRaritys();
	local v4, _, v5 = m_Library.Network.Invoke("Toggle Auto Delete", p1);
	if v4 then
		v1.AutoDelete[p1] = v5;
		UpdateRaritys();
		return;
	end
	if v1.AutoDelete[p1] == v2 then
		v1.AutoDelete[p1] = v3;
		UpdateRaritys();
	end
end
function UpdateRaritys() -- Line: 52
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_AutoSettings
	--]]
	local v6 = m_Library.Save.Get();
	if not v6 then return end
	for _, child5 in ipairs(t_AutoSettings.Container:GetChildren()) do
		if not child5:GetAttribute("AutoDelete") then continue end
		local ImageButton = child5:FindFirstChildOfClass("ImageButton");
		if not ImageButton or not m_Library.Shared.PetRarityNumbers[ImageButton.Name] then continue end
		local v24 = v6.AutoDelete[ImageButton.Name];
		ImageButton.Image = v24 and "rbxassetid://7045637481" or "rbxassetid://7045637286";
		ImageButton.HoverImage = v24 and "rbxassetid://7045637564" or "rbxassetid://7045637411";
		ImageButton.Label.Text = v24 and "Delete" or "Keep";
	end
	local v7 = false;
	for _, val6 in pairs(v6.AutoDelete) do
		v7 = val6 or v7;
	end
	m_Library.Variables.AutoDeleteEnabled = v7;
end
for _, child1 in ipairs(t_AutoSettings.Container:GetChildren()) do
	if not child1:GetAttribute("AutoDelete") then continue end
	local ImageButton6 = child1:FindFirstChildOfClass("ImageButton");
	m_Library.GUIFX.ButtonFX(ImageButton6);
	ImageButton6.Activated:Connect(function() -- Line: 87
		--[[
			Upvalues:
				[1] = bool1
				[2] = ImageButton6
		--]]
		if not bool1 then
			bool1 = true;
			ToggleRarity(ImageButton6.Name);
			bool1 = false;
		end
	end);
end
function UpdateAutoHatch() -- Line: 101
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_ID
			[3] = t_AutoSettings
	--]]
	local v8 = m_Library.Gamepasses.Owns(t_ID);
	if not v8 then
		local v25, v26 = m_Library.Functions.GetPrice(t_ID);
		local t_Robux = t_AutoSettings.Container.Locked.PriceFrame.Buy.Robux;
		if v26 and v25 > 0 then
			t_Robux.Text = m_Library.Functions.Commas(v25);
		else
			t_Robux.Text = "???";
		end
	end
	t_AutoSettings.Container.Locked.Visible = not v8;
	for _, child7 in ipairs(t_AutoSettings.Container:GetChildren()) do
		if not child7:GetAttribute("AutoHatch") then continue end
		child7.Visible = v8;
	end
	local v9 = m_Library.Save.Get();
    if not v9 then return end
    if not v9.AutoHatchSettings then return end
	local t_StopOnFailure = v9.AutoHatchSettings.StopOnFailure;
	local t_TripleEggs = v9.AutoHatchSettings.TripleEggs;
	local t_OctupleEggs = v9.AutoHatchSettings.OctupleEggs;
	for _, child8 in ipairs(t_AutoSettings.Container:GetChildren()) do
		if not child8:GetAttribute("AutoHatch") then continue end
		local ImageButton2 = child8:FindFirstChildOfClass("ImageButton");
		local v27 = nil;
		if ImageButton2.Name == "StopOnFailure" then
			v27 = t_StopOnFailure;
		elseif ImageButton2.Name == "Enabled" then
			v27 = true;
		elseif ImageButton2.Name == "TripleEggs" then
			v27 = t_TripleEggs;
		elseif ImageButton2.Name == "OctupleEggs" then
			v27 = t_OctupleEggs;
		end
		ImageButton2.Label.Text = v27 and "On" or "Off";
		ImageButton2.Image = v27 and "rbxassetid://7045637286" or "rbxassetid://7045637481";
		ImageButton2.HoverImage = v27 and "rbxassetid://7045637411" or "rbxassetid://7045637564";
	end
	UpdateScrolling();
end
function ToggleAutoHatchSetting(p2) -- Line: 152
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v10 = m_Library.Save.Get();
	if not v10 then return end
	assert(v10);
	m_Library.Audio.Play("rbxassetid://7004248320", script, 1, 0.5);
    local v11 = m_Library.Functions.DeepCopyUnsafe(v10.AutoHatchSettings);
	if not v10.AutoHatchSettings[p2] then
		v10.AutoHatchSettings[p2] = false;
	end
	v10.AutoHatchSettings[p2] = not v10.AutoHatchSettings[p2];
	if p2 == "OctupleEggs" and v10.AutoHatchSettings[p2] then
		v10.AutoHatchSettings.TripleEggs = false;
	end
	if p2 == "TripleEggs" and v10.AutoHatchSettings[p2] then
		v10.AutoHatchSettings.OctupleEggs = false;
	end
	local v12 = m_Library.Functions.DeepCopyUnsafe(v10.AutoHatchSettings);
	UpdateAutoHatch();
	UpdateAlwaysKeep();
	local v13, _, v14 = m_Library.Network.Invoke("Toggle Auto Hatch Setting", p2);
	if v13 then
		v10.AutoHatchSettings = v14;
		UpdateAutoHatch();
		UpdateAlwaysKeep();
		return;
	end
	if m_Library.Functions.DeepEqualsUnsafe(v10.AutoHatchSettings, v12) then
		v10.AutoHatchSettings = v11;
		UpdateAutoHatch();
		UpdateAlwaysKeep();
	end
end
local t_Buy = t_AutoSettings.Container.Locked.PriceFrame.Buy;
m_Library.GUIFX.ButtonFX(t_Buy);
t_Buy.Activated:Connect(function() -- Line: 200
	--[[
		Upvalues:
			[1] = bool1
			[2] = m_Library
			[3] = t_ID
	--]]
	if not bool1 then
		bool1 = true;
		m_Library.Shared.PromptPurchase(t_ID);
		bool1 = false;
	end
end);
for _, child2 in ipairs(t_AutoSettings.Container:GetChildren()) do
	if not child2:GetAttribute("AutoHatch") then continue end
	local ImageButton5 = child2:FindFirstChildOfClass("ImageButton");
	m_Library.GUIFX.ButtonFX(ImageButton5);
	ImageButton5.Activated:Connect(function() -- Line: 217
		--[[
			Upvalues:
				[1] = bool1
				[2] = ImageButton5
		--]]
		if not bool1 then
			bool1 = true;
			ToggleAutoHatchSetting(ImageButton5.Name);
			bool1 = false;
		end
	end);
end
function UpdateAlwaysKeep() -- Line: 230
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_AutoSettings
	--]]
	local v15 = m_Library.Save.Get();
    if not v15 then return end
    if not v15.AutoHatchSettings then return end
	local v16 = v15.AutoHatchSettings.AlwaysKeep;
	if not v16 then
		local table1 = {
			GoldPets = "Exclusive",
			RainbowPets = "Exclusive",
			ShinyPets = "Exclusive"
		};
		v16 = table1;
	end
	for _, child9 in ipairs(t_AutoSettings.Container:GetChildren()) do
		if not child9:GetAttribute("AlwaysKeep") then continue end
		local ImageButton3 = child9:FindFirstChildOfClass("ImageButton");
		if not ImageButton3 then continue end
		ImageButton3.Label.Text = v16[ImageButton3.Name] or "Basic";
	end
end
local table2 = {};
for key3, val3 in pairs(m_Library.Shared.PetRarityNumbers) do
	table2[val3] = key3;
end
function ToggleAlwaysKeepSetting(p3) -- Line: 269
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table2
	--]]
	local v17 = m_Library.Save.Get();
	if not v17 then return end
	assert(v17);
	m_Library.Audio.Play("rbxassetid://7004248320", script, 1, 0.5);
	local v18 = m_Library.Functions.DeepCopyUnsafe(v17.AutoHatchSettings);
	if not v17.AutoHatchSettings.AlwaysKeep then
		v17.AutoHatchSettings.AlwaysKeep = {
			GoldPets = "Exclusive",
			RainbowPets = "Exclusive",
			ShinyPets = "Exclusive"
		};
	end
	local v19 = m_Library.Shared.PetRarityNumbers[v17.AutoHatchSettings.AlwaysKeep[p3]];
	if v19 < 8 then
		v19 = v19 + 1;
	elseif v19 == 8 then
		v19 = 1;
	end
	local v20 = table2[v19];
	v17.AutoHatchSettings.AlwaysKeep[p3] = v20;
	local v21 = m_Library.Functions.DeepCopyUnsafe(v17.AutoHatchSettings);
	UpdateAutoHatch();
	UpdateAlwaysKeep();
	local v22, _, v23 = m_Library.Network.Invoke("Toggle Always Keep Setting", p3);
	if v22 then
		v17.AutoHatchSettings = v23;
		UpdateAutoHatch();
		UpdateAlwaysKeep();
		return;
	end
    if m_Library.Functions.DeepEqualsUnsafe(v17.AutoHatchSettings, v21) then
		v17.AutoHatchSettings = v18;
		UpdateAutoHatch();
		UpdateAlwaysKeep();
	end
end
for _, child4 in ipairs(t_AutoSettings.Container:GetChildren()) do
	if not child4:GetAttribute("AlwaysKeep") then continue end
	local ImageButton4 = child4:FindFirstChildOfClass("ImageButton");
	m_Library.GUIFX.ButtonFX(ImageButton4);
	ImageButton4.Activated:Connect(function() -- Line: 327
		--[[
			Upvalues:
				[1] = bool1
				[2] = ImageButton4
		--]]
		if not bool1 then
			bool1 = true;
			ToggleAlwaysKeepSetting(ImageButton4.Name);
			bool1 = false;
		end
	end);
end
function UpdateSideButton() -- Line: 340
	--[[
		Upvalues:
			[1] = m_Library
			[2] = AutoSettings
	--]]
	AutoSettings.BackgroundColor3 = m_Library.Variables.AutoDeleteEnabled and Color3.fromRGB(103, 255, 103) or Color3.fromRGB(39, 233, 55);
end
function UpdateScrolling() -- Line: 346
	--[[
		Upvalues:
			[1] = t_AutoSettings
	--]]
	local t_Container = t_AutoSettings.Gui.Frame.Container;
	local UIListLayout = t_Container:FindFirstChildOfClass("UIListLayout");
	local UIPadding = t_Container:FindFirstChildOfClass("UIPadding");
	t_Container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset);
end
m_Library.GUIFX.ButtonFX(t_AutoSettings.Close);
t_AutoSettings.Close.Activated:Connect(function() -- Line: 355
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_AutoSettings
	--]]
	if not bool1 then
		bool1 = true;
		t_AutoSettings.Gui.Enabled = false;
		bool1 = false;
	end
end);
m_Library.GUIFX.ButtonFX(AutoSettings);
m_Library.GUIFX.Tooltip(AutoSettings, "Auto-Settings");
AutoSettings.Activated:Connect(function() -- Line: 366
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_AutoSettings
	--]]
	if not bool1 then
		bool1 = true;
		t_AutoSettings.Gui.Enabled = not t_AutoSettings.Gui.Enabled;
		bool1 = false;
	end
end);
UpdateRaritys();
UpdateSideButton();
UpdateAutoHatch();
UpdateAlwaysKeep();
m_Library.Signal.Fired("Stat Changed"):Connect(function(p4) -- Line: 383
	if p4 == "AutoDelete" then
		UpdateRaritys();
		UpdateSideButton();
		return;
	end
	if p4 == "Gamepasses" or p4 == "AutoHatchSettings" then
		UpdateAutoHatch();
		UpdateAlwaysKeep();
	end
end);
