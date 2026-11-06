-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_Teleport = m_Library.GUI.Teleport;
local Teleport_ = m_Library.GUI.Main.Left.Tools:FindFirstChild("Teleport");
local t_ID = m_Library.Directory.Gamepasses.Teleport.ID;
local t_ID2 = m_Library.Directory.Gamepasses.VIP.ID;
local t_IsHardcore = m_Library.Shared.IsHardcore;
local bool1 = false;
local u1 = "Spawn";
local bool2 = false;
local t_Areas = m_Library.Directory.Areas;
local table1 = {};
local table2 = {};
for key1, val1 in pairs(t_Areas) do
	if val1.hidden then continue end
	table.insert(table1, key1);
end
table.sort(table1, function(p1, p2) -- Line: 41
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v1 = m_Library.Directory.Areas[p1];
	local v2 = m_Library.Directory.Areas[p2];
	local v3 = m_Library.Directory.Worlds[v1.world];
	local v4 = m_Library.Directory.Worlds[v2.world];
	local v5 = m_Library.Directory.Currency[v3.mainCurrency];
	local v6 = m_Library.Directory.Currency[v4.mainCurrency];
	if v3.worldOrder == v4.worldOrder then
		if v5.order == v6.order then
			if v1.isShop == v2.isShop then
				if v1.gate and v2.gate then
					return v1.gate.cost < v2.gate.cost;
				end
				return v1.mult < v2.mult;
			end
			return v1.isShop;
		end
		return v5.order < v6.order;
	end
	return v3.worldOrder < v4.worldOrder;
end);
for _, val2 in ipairs(table1) do
	local t_world = m_Library.Directory.Areas[val2].world;
	if table.find(table2, t_world) then continue end
	table.insert(table2, t_world);
end
function GetTeleportIcon(p3) -- Line: 75
	return ({
		MachineUpgrade = "rbxassetid://12520076522",
		MachineFuse = "rbxassetid://12520076797",
		MachineRainbow = "rbxassetid://12520076664",
		MachineEnchant = "rbxassetid://12520076963",
		MachineDarkMatter = "rbxassetid://12520077127",
		MachineServerBoosts = "rbxassetid://12523969236",
		Chest = "rbxassetid://12520085862",
		Teleport = "rbxassetid://12520085508"
	})[p3];
end
function ActuallyTeleport(p4, p5) -- Line: 89
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	if not m_Library.WorldCmds.CanDoAction() then
		return false, "Cannot perform actions right now";
	end
	if not m_Library.FFlags.Get(m_Library.FFlags.Keys.Teleporting) and not m_Library.FFlags.CanBypass() then
		return false, "Sorry this is disabled right now! Try back soon!";
	end
	local v7 = m_Library.Directory.Areas[p4];
	if not v7 then
		return false, "Unknown area!";
	end
	if not p5 and not m_Library.WorldCmds.HasAccess(v7.world) then
		return false, "You do not have access to this world!";
	end
	if not p5 and not m_Library.WorldCmds.HasArea(p4) then
		return false, "You do not have access to this area!";
	end
	if not p5 and not m_Library.WorldCmds.HasTeleport(p4) then
		return false, "You do not own the teleport to this area!";
	end
	if not p5 then
		if v7 == "Diamond Mine" then
			local collpaseTime = m_Library.Signal.Invoke("Get Diamond Mine Collpase Time")
			if collpaseTime then
				return false, "The Diamond Mine has collapsed! Reopening in " .. m_Library.Functions.FormatTime(collpaseTime)
			end
		end
	end
	if m_Library.WorldCmds.Get() ~= v7.world and not m_Library.WorldCmds.Load(v7.world) then
		return false, "World failed to load!";
	end
	local FindFirstChild_ret = m_Library.WorldCmds.GetMap().Teleports:FindFirstChild(p4);
	if not FindFirstChild_ret then
		return false, "No such teleport for area!";
	end
	assert(FindFirstChild_ret);
	local t_LocalPlayer = m_Library.LocalPlayer;
	local v8 = t_LocalPlayer.Character or t_LocalPlayer.CharacterAdded:Wait();
	local Humanoid = v8:WaitForChild("Humanoid");
	local HumanoidRootPart = v8:WaitForChild("HumanoidRootPart");
	m_Library.Signal.Fire("Teleporting");
	task.wait(0.25);
	local t_CFrame = FindFirstChild_ret.CFrame;
	v8:PivotTo(t_CFrame + t_CFrame.UpVector * (Humanoid.HipHeight + HumanoidRootPart.Size.Y / 2));
	m_Library.Audio.Play("rbxassetid://7009904957", script, 1, 0.4);
	m_Library.Network.Fire("Performed Teleport", p4);
	task.wait(0.25);
	return true;
end
function Teleport(p6, p7) -- Line: 168
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.Asserts.string(p6);
	assert(m_Library.Directory.Areas[p6]);
	if m_Library.Variables.Teleporting then
		return false, "You are already teleporting!";
	end
	m_Library.Variables.Teleporting = true;
	local ActuallyTeleport_ret1, ActuallyTeleport_ret2 = ActuallyTeleport(p6, p7);
	m_Library.Variables.Teleporting = false;
	return ActuallyTeleport_ret1, ActuallyTeleport_ret2;
end
m_Library.Network.Invoked("Force Teleport").OnInvoke = function(p8) -- Line: 189
	return Teleport(p8, true);
end
function Purchase(p9) -- Line: 194
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v9 = m_Library.Message.New("It costs " .. m_Library.Functions.Commas(m_Library.Directory.Areas[p9].teleportPrice) .. " Diamonds to unlock this teleport. Are you sure?", true);
	if not v9 then return end
	local v10, v11 = m_Library.Network.Invoke("Buy Teleport Area", p9);
	if not v10 then
		m_Library.Message.New(v11 or "An error occurred.");
		return;
	end
	m_Library.Audio.Play("rbxassetid://7255664014", script);
end
function Clicked(p10) -- Line: 210
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	if m_Library.WorldCmds.HasTeleport(p10) then
		local Teleport_ret1, Teleport_ret2 = Teleport(p10);
		if not Teleport_ret1 then
			m_Library.Message.New(Teleport_ret2 or "An error occurred.");
		end
	else
		Purchase(p10);
	end
end
function ClickedWorld(p11) -- Line: 365
	--[[
		Upvalues:
			[1] = u1
			[2] = m_Library
			[3] = t_Teleport
	--]]
	if u1 ~= p11 then
		u1 = p11;
		t_Teleport.Gui.Frame.RightContainer.Holder.Category.Text = "~ " .. ((u1 == "Hardcore" or u1 == "Normal" or u1 == "Trading Plaza") and u1 .. " Teleports" or m_Library.Directory.Worlds[u1].display) .. " ~";
		UpdateAreas();
		t_Teleport.RightContainer.Holder.CanvasPosition = Vector2.new(0, 0);
	end
end
function RealmClicked(p12) -- Line: 382
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	if p12 == "Hardcore" then
		m_Library.Variables.LoadingWorld = true;
		local v21, v22 = m_Library.Network.Invoke("Toggle Hardcore Mode");
		if v21 then
			m_Library.GUIFX.Loading("Hardcore Mode");
			return;
		end
		m_Library.Variables.LoadingWorld = false;
		m_Library.Message.New(v22 or "Something went wrong.");
		return;
	end
	if p12 == "Normal" then
		m_Library.Variables.LoadingWorld = true;
		local v23, v24 = m_Library.Network.Invoke("Toggle Hardcore Mode");
		if v23 then
			m_Library.GUIFX.Loading("Normal Mode");
			return;
		end
		m_Library.Variables.LoadingWorld = false;
		m_Library.Message.New(v24 or "Something went wrong.");
		return;
	end
	if p12 == "Trading Plaza" then
		local u2 = false;
		pcall(function() -- Line: 403
			--[[
				Upvalues:
					[1] = u2
					[2] = m_Library
			--]]
			u2 = m_Library.VoiceChatService:IsVoiceEnabledForUserIdAsync(m_Library.LocalPlayer.UserId);
		end);
		m_Library.Signal.Fire("Show Trading Plaza Choice", u2);
	end
end
function Setup() -- Line: 411
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Teleport
			[3] = u1
			[4] = bool2
			[5] = table2
			[6] = bool1
			[7] = t_IsHardcore
			[8] = table1
			[9] = t_ID2
	--]]
	if m_Library.Shared.IsTradingPlaza then
		if not t_Teleport.Holder:FindFirstChild("TeleportsDisabled") then
			script.TeleportsDisabled:Clone().Parent = t_Teleport.Frame;
			t_Teleport.LeftContainer.Visible = false;
			t_Teleport.RightContainer.Visible = false;
			t_Teleport.UnlockAll.Visible = false;
		end
		return;
	end
	local v12 = m_Library.Save.Get();
	if not v12 then return end
	assert(v12);
	t_Teleport.Gui.Frame.RightContainer.Holder.Category.Text = "~ " .. m_Library.Directory.Worlds[u1].display .. " ~";
	local t_Holder = t_Teleport.Gui.Frame.LeftContainer.Holder;
	local t_WorldTemplate = t_Holder.WorldTemplate;
	local v13 = 1;
	if not bool2 then
		for _, val5 in ipairs(table2) do
			if val5 == "Diamond Mine" then continue end
			local v30 = m_Library.Directory.Worlds[val5];
			local FindFirstChild_ret2 = t_Holder:FindFirstChild(val5);
			if not FindFirstChild_ret2 then
				local Clone_ret = t_WorldTemplate:Clone();
				Clone_ret.ImageLabel.Image = v30.teleportImage or "rbxassetid://12405479224";
				Clone_ret.Visible = true;
				Clone_ret.Parent = t_Holder;
				Clone_ret.Name = val5;
				Clone_ret.Title.Text = v30.display;
				Clone_ret.LayoutOrder = v13;
				v13 = v13 + 1;
				m_Library.GUIFX.ButtonFX(Clone_ret);
				Clone_ret.Activated:Connect(function() -- Line: 453
					--[[
						Upvalues:
							[1] = bool1
							[2] = val5
					--]]
					if not bool1 then
						bool1 = true;
						ClickedWorld(val5);
						bool1 = false;
					end
				end);
			end
			bool2 = true;
		end
		t_Holder.CategoryRealms.LayoutOrder = v13;
		v13 = v13 + 1;
	end
	if not t_Holder:FindFirstChild("Diamond Mine") then
		local v25 = m_Library.Directory.Worlds["Diamond Mine"];
		local Clone_ret2 = t_WorldTemplate:Clone();
		Clone_ret2.Parent = t_Holder;
		Clone_ret2.Visible = false;
		Clone_ret2.Name = "Diamond Mine";
		Clone_ret2.Title.Text = "Diamond Mine";
		Clone_ret2.ImageLabel.Image = v25.teleportImage or "rbxassetid://12405479224";
		Clone_ret2.LayoutOrder = v13;
		m_Library.GUIFX.ButtonFX(Clone_ret2);
		Clone_ret2.Activated:Connect(function() -- Line: 481
			--[[
				Upvalues:
					[1] = bool1
			--]]
			if not bool1 then
				bool1 = true;
				ClickedWorld("Diamond Mine");
				bool1 = false;
			end
		end);
		v13 = v13 + 1;
	end
	if v12.HardcoreUnlocked and not t_IsHardcore then
		if not t_Holder:FindFirstChild("Hardcore") then
			local Clone_ret5 = t_WorldTemplate:Clone();
			Clone_ret5.Parent = t_Holder;
			Clone_ret5.Visible = false;
			Clone_ret5.Name = "Hardcore";
			Clone_ret5.Title.Text = "Hardcore Mode";
			Clone_ret5.LayoutOrder = v13;
			Clone_ret5.ImageLabel.Image = "rbxassetid://12447471006";
			m_Library.GUIFX.ButtonFX(Clone_ret5);
			Clone_ret5.Activated:Connect(function() -- Line: 503
				--[[
					Upvalues:
						[1] = bool1
				--]]
				if not bool1 then
					bool1 = true;
					ClickedWorld("Hardcore");
					bool1 = false;
				end
			end);
			v13 = v13 + 1;
		end
	elseif t_IsHardcore and not t_Holder:FindFirstChild("Normal") then
		local Clone_ret4 = t_WorldTemplate:Clone();
		Clone_ret4.Parent = t_Holder;
		Clone_ret4.Visible = true;
		Clone_ret4.Name = "Normal";
		Clone_ret4.Title.Text = "Normal Mode";
		Clone_ret4.LayoutOrder = v13;
		Clone_ret4.ImageLabel.Image = "rbxassetid://12447471006";
		m_Library.GUIFX.ButtonFX(Clone_ret4);
		Clone_ret4.Activated:Connect(function() -- Line: 524
			--[[
				Upvalues:
					[1] = bool1
			--]]
			if not bool1 then
				bool1 = true;
				ClickedWorld("Normal");
				bool1 = false;
			end
		end);
		v13 = v13 + 1;
	end
	if v12.OwnsTradingPlaza and not t_Holder:FindFirstChild("Trading Plaza") then
		local Clone_ret3 = t_WorldTemplate:Clone();
		Clone_ret3.Parent = t_Holder;
		Clone_ret3.Visible = false;
		Clone_ret3.Name = "Trading Plaza";
		Clone_ret3.Title.Text = "Trading Plaza";
		Clone_ret3.LayoutOrder = v13;
		Clone_ret3.ImageLabel.Image = "rbxassetid://12447471127";
		m_Library.GUIFX.ButtonFX(Clone_ret3);
		Clone_ret3.Activated:Connect(function() -- Line: 547
			--[[
				Upvalues:
					[1] = bool1
			--]]
			if not bool1 then
				bool1 = true;
				ClickedWorld("Trading Plaza");
				bool1 = false;
			end
		end);
		local _ = v13 + 1;
	end
	Scrolling(t_Teleport.Gui.Frame.LeftContainer.Holder);
	local t_Holder2 = t_Teleport.Gui.Frame.RightContainer.Holder;
	for _, child3 in ipairs(t_Holder2:GetChildren()) do
		if not child3:GetAttribute("World") or child3:GetAttribute("World") == u1 then continue end
		child3:Destroy();
	end
	local _ = t_Holder2.AreaTemplate;
	local v14 = 1;
	if u1 ~= "Hardcore" and u1 ~= "Trading Plaza" then
		for _, val6 in ipairs(table1) do
			local v31 = m_Library.Directory.Areas[val6];
			if v31.world ~= u1 or val6 == "VIP" and not m_Library.Gamepasses.Owns(t_ID2) then continue end
			local v32 = t_Holder2:FindFirstChild(val6);
			if not v32 then
				v32 = m_Library.Assets.UI.Teleport.Area:Clone();
				v32.LayoutOrder = v14;
				if val6 == "Easter" then
					v32.LayoutOrder = 0;
				end
				v14 = v14 + 1;
				v32.Name = val6;
				v32.Parent = t_Holder2;
				v32:SetAttribute("World", v31.world);
				m_Library.GUIFX.ButtonFX(v32);
				v32.Activated:Connect(function() -- Line: 595
					--[[
						Upvalues:
							[1] = bool1
							[2] = m_Library
							[3] = val6
					--]]
					if not bool1 and m_Library.WorldCmds.HasArea(val6) then
						bool1 = true;
						Clicked(val6);
						bool1 = false;
					end
				end);
			end
			local v33 = m_Library.WorldCmds.HasArea(val6);
			local v34 = m_Library.WorldCmds.HasTeleport(val6);
			local v35 = GetTeleportIcon(v31.tpIcon) or v31.isShop and "rbxassetid://7255478767" or "rbxassetid://6708234702";
			v32.ImageColor3 = v33 and Color3.new(1, 1, 1) or Color3.fromRGB(120, 120, 120);
			v32.Title.Text = v33 and v31.name or "???";
			v32.Image = (not v33 or v34) and "rbxassetid://7045637286" or "rbxassetid://7045637286";
			v32.HoverImage = (not v33 or v34) and "rbxassetid://7045637411" or "rbxassetid://7045637411";
			if not v33 then
				v32.Icon.Image = "rbxassetid://7255478600";
				continue;
			end
			if not v34 then
				v32.Icon.Image = "rbxassetid://7255478657";
				continue;
			end
			if not v34 or not v33 then continue end
			v32.Icon.Image = v35;
		end
	else
		local v26 = t_Holder2:FindFirstChild(u1);
		if not v26 then
			v26 = m_Library.Assets.UI.Teleport.Area:Clone();
			v26.LayoutOrder = v14;
			local _ = v14 + 1;
			v26.Name = u1;
			v26.Parent = t_Holder2;
			v26:SetAttribute("World", u1);
			m_Library.GUIFX.ButtonFX(v26);
			v26.Activated:Connect(function() -- Line: 632
				--[[
					Upvalues:
						[1] = bool1
						[2] = u1
				--]]
				if not bool1 then
					bool1 = true;
					RealmClicked(u1);
					bool1 = false;
				end
			end);
		end
		local v27 = u1 == "Hardcore" and v12.HardcoreUnlocked or v12.OwnsTradingPlaza;
		local v28 = u1 == "Hardcore" and v12.HardcoreUnlocked or v12.OwnsTradingPlaza;
		v26.ImageColor3 = v27 and Color3.new(1, 1, 1) or Color3.fromRGB(120, 120, 120);
		v26.Title.Text = u1;
		v26.Image = (not v27 or v28) and "rbxassetid://7045637286" or "rbxassetid://7045637286";
		v26.HoverImage = (not v27 or v28) and "rbxassetid://7045637411" or "rbxassetid://7045637411";
		if not v27 then
			v26.Icon.Image = "rbxassetid://7255478600";
		elseif not v28 then
			v26.Icon.Image = "rbxassetid://7255478657";
		elseif v28 and v27 then
			v26.Icon.Image = "rbxassetid://6708234702";
		end
	end
	Scrolling(t_Holder2);
end
function UpdateRealms() -- Line: 659
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Teleport
			[3] = t_IsHardcore
			[4] = table2
			[5] = bool1
	--]]
	local v15 = m_Library.Save.Get();
	if not v15 then return end
	assert(v15);
	local t_Holder3 = t_Teleport.Gui.Frame.LeftContainer.Holder;
	local t_WorldTemplate2 = t_Holder3.WorldTemplate;
	if v15.HardcoreUnlocked and not t_IsHardcore then
		if not t_Holder3:FindFirstChild("Hardcore") then
			local Clone_ret8 = t_WorldTemplate2:Clone();
			Clone_ret8.Parent = t_Holder3;
			Clone_ret8.Visible = true;
			Clone_ret8.Name = "Hardcore";
			Clone_ret8.Title.Text = "Hardcore Mode";
			Clone_ret8.ImageLabel.Image = "rbxassetid://12447471006";
			Clone_ret8.LayoutOrder = #table2 + 2;
			m_Library.GUIFX.ButtonFX(Clone_ret8);
			Clone_ret8.Activated:Connect(function() -- Line: 681
				--[[
					Upvalues:
						[1] = bool1
				--]]
				if not bool1 then
					bool1 = true;
					ClickedWorld("Hardcore");
					bool1 = false;
				end
			end);
		end
	elseif t_IsHardcore and not t_Holder3:FindFirstChild("Normal") then
		local Clone_ret7 = t_WorldTemplate2:Clone();
		Clone_ret7.Parent = t_Holder3;
		Clone_ret7.Visible = true;
		Clone_ret7.Name = "Normal";
		Clone_ret7.Title.Text = "Normal Mode";
		Clone_ret7.ImageLabel.Image = "rbxassetid://12447471006";
		Clone_ret7.LayoutOrder = #table2 + 2;
		m_Library.GUIFX.ButtonFX(Clone_ret7);
		Clone_ret7.Activated:Connect(function() -- Line: 701
			--[[
				Upvalues:
					[1] = bool1
			--]]
			if not bool1 then
				bool1 = true;
				ClickedWorld("Normal");
				bool1 = false;
			end
		end);
	end
	if v15.OwnsTradingPlaza and not t_Holder3:FindFirstChild("Trading Plaza") then
		local Clone_ret6 = t_WorldTemplate2:Clone();
		Clone_ret6.Parent = t_Holder3;
		Clone_ret6.Visible = true;
		Clone_ret6.Name = "Trading Plaza";
		Clone_ret6.Title.Text = "Trading Plaza";
		Clone_ret6.ImageLabel.Image = "rbxassetid://12447471127";
		Clone_ret6.LayoutOrder = #table2 + 3;
		m_Library.GUIFX.ButtonFX(Clone_ret6);
		Clone_ret6.Activated:Connect(function() -- Line: 723
			--[[
				Upvalues:
					[1] = bool1
			--]]
			if not bool1 then
				bool1 = true;
				ClickedWorld("Trading Plaza");
				bool1 = false;
			end
		end);
	end
end
function UpdateAreas() -- Line: 734
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Teleport
			[3] = u1
			[4] = table1
			[5] = t_ID2
			[6] = bool1
	--]]
	local v16 = m_Library.Save.Get();
	if not v16 then return end
	assert(v16);
	local t_Holder4 = t_Teleport.Gui.Frame.RightContainer.Holder;
	for _, child4 in ipairs(t_Holder4:GetChildren()) do
		if not child4:GetAttribute("World") or child4:GetAttribute("World") == u1 then continue end
		child4:Destroy();
	end
	local _ = t_Holder4.AreaTemplate;
	local v17 = 1;
	if u1 ~= "Hardcore" and u1 ~= "Trading Plaza" and u1 ~= "Normal" then
		for _, val7 in ipairs(table1) do
			local v36 = m_Library.Directory.Areas[val7];
			if v36.world ~= u1 or val7 == "VIP" and not m_Library.Gamepasses.Owns(t_ID2) then continue end
			local v37 = t_Holder4:FindFirstChild(val7);
			if not v37 then
				v37 = m_Library.Assets.UI.Teleport.Area:Clone();
				v37.LayoutOrder = v17;
				if val7 == "Easter" then
					v37.LayoutOrder = 0;
				end
				v17 = v17 + 1;
				v37.Name = val7;
				v37.Parent = t_Holder4;
				v37:SetAttribute("World", v36.world);
				m_Library.GUIFX.ButtonFX(v37);
				v37.Activated:Connect(function() -- Line: 773
					--[[
						Upvalues:
							[1] = bool1
							[2] = m_Library
							[3] = val7
					--]]
					if not bool1 and m_Library.WorldCmds.HasArea(val7) then
						bool1 = true;
						Clicked(val7);
						bool1 = false;
					end
				end);
			end
			local v38 = m_Library.WorldCmds.HasArea(val7);
			local v39 = m_Library.WorldCmds.HasTeleport(val7);
			local v40 = GetTeleportIcon(v36.tpIcon) or v36.isShop and "rbxassetid://7255478767" or "rbxassetid://6708234702";
			v37.ImageColor3 = v38 and Color3.new(1, 1, 1) or Color3.fromRGB(120, 120, 120);
			v37.Title.Text = v38 and v36.name or "???";
			v37.Image = (not v38 or v39) and "rbxassetid://7045637286" or "rbxassetid://7045637286";
			v37.HoverImage = (not v38 or v39) and "rbxassetid://7045637411" or "rbxassetid://7045637411";
			if not v38 then
				v37.Icon.Image = "rbxassetid://7255478600";
				continue;
			end
			if not v39 then
				v37.Icon.Image = "rbxassetid://7255478657";
				continue;
			end
			if not v39 or not v38 then continue end
			v37.Icon.Image = v40;
		end
	else
		local v29 = t_Holder4:FindFirstChild(u1);
		if not v29 then
			v29 = m_Library.Assets.UI.Teleport.Area:Clone();
			v29.LayoutOrder = v17;
			local _ = v17 + 1;
			v29.Name = u1;
			v29.Parent = t_Holder4;
			v29:SetAttribute("World", u1);
			m_Library.GUIFX.ButtonFX(v29);
			v29.Activated:Connect(function() -- Line: 810
				--[[
					Upvalues:
						[1] = bool1
						[2] = u1
				--]]
				if not bool1 then
					bool1 = true;
					RealmClicked(u1);
					bool1 = false;
				end
			end);
		end
		local t_HardcoreUnlocked = nil;
		local t_HardcoreUnlocked2 = nil;
		if u1 == "Hardcore" or u1 == "Normal" then
			t_HardcoreUnlocked = v16.HardcoreUnlocked;
			t_HardcoreUnlocked2 = v16.HardcoreUnlocked;
		elseif u1 == "Trading Plaza" then
			t_HardcoreUnlocked = v16.HardcoreUnlocked;
			t_HardcoreUnlocked2 = v16.HardcoreUnlocked;
		end
		v29.ImageColor3 = t_HardcoreUnlocked and Color3.new(1, 1, 1) or Color3.fromRGB(120, 120, 120);
		v29.Title.Text = u1;
		v29.Image = (not t_HardcoreUnlocked or t_HardcoreUnlocked2) and "rbxassetid://7045637286" or "rbxassetid://7045637286";
		v29.HoverImage = (not t_HardcoreUnlocked or t_HardcoreUnlocked2) and "rbxassetid://7045637411" or "rbxassetid://7045637411";
		if not t_HardcoreUnlocked then
			v29.Icon.Image = "rbxassetid://7255478600";
		elseif not t_HardcoreUnlocked2 then
			v29.Icon.Image = "rbxassetid://7255478657";
		elseif t_HardcoreUnlocked2 and t_HardcoreUnlocked then
			v29.Icon.Image = "rbxassetid://6708234702";
		end
	end
	Scrolling(t_Holder4);
end
function Scrolling(p13) -- Line: 842
	local UIListLayout = p13:FindFirstChildOfClass("UIListLayout");
	local UIPadding = p13:FindFirstChildOfClass("UIPadding");
	UIListLayout:ApplyLayout();
	p13.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + UIPadding.PaddingBottom.Offset + UIPadding.PaddingTop.Offset);
end
function UpdateBottom() -- Line: 853
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_ID
			[3] = t_Teleport
	--]]
	local v18 = m_Library.Gamepasses.Owns(t_ID);
	t_Teleport.UnlockAll.Visible = not v18;
	t_Teleport.RightContainer.Size = UDim2.new(0.6, 32, v18 and 1 or 0.85, v18 and 20 or 0);
	Scrolling(t_Teleport.Gui.Frame.RightContainer.Holder);
end
m_Library.GUIFX.ButtonFX(Teleport_);
m_Library.GUIFX.Tooltip(Teleport_, "Teleport");
Teleport_.Activated:Connect(function() -- Line: 866
	--[[
		Upvalues:
			[1] = bool1
			[2] = m_Library
			[3] = t_Teleport
	--]]
	if not bool1 then
		bool1 = true;
		if m_Library.Shared.IsTradingPlaza then
			local u3 = false;
			pcall(function() -- Line: 873
				--[[
					Upvalues:
						[1] = u3
						[2] = m_Library
				--]]
				u3 = m_Library.VoiceChatService:IsVoiceEnabledForUserIdAsync(m_Library.LocalPlayer.UserId);
			end);
			m_Library.Signal.Fire("Show Trading Plaza Choice", u3);
		else
			t_Teleport.Gui.Enabled = not t_Teleport.Gui.Enabled;
		end
		bool1 = false;
	end
end);
m_Library.GUIFX.ButtonFX(t_Teleport.Close);
t_Teleport.Close.Activated:Connect(function() -- Line: 887
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_Teleport
	--]]
	if not bool1 then
		bool1 = true;
		t_Teleport.Gui.Enabled = false;
		bool1 = false;
	end
end);
m_Library.GUIFX.ButtonFX(t_Teleport.UnlockAll.Buy);
t_Teleport.UnlockAll.Buy.Robux.Text = "???";
task.spawn(function() -- Line: 898
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_ID
			[3] = t_Teleport
	--]]
	local v19, v20 = m_Library.Functions.GetPrice(t_ID);
	if v20 then
		t_Teleport.UnlockAll.Buy.Robux.Text = m_Library.Functions.Commas(v19);
	end
end);
t_Teleport.UnlockAll.Buy.Activated:Connect(function() -- Line: 904
	--[[
		Upvalues:
			[1] = bool1
			[2] = m_Library
			[3] = t_ID
	--]]
	if not bool1 then
		bool1 = true;
		m_Library.Shared.PromptPurchase(t_ID, false);
		bool1 = false;
	end
end);
Setup();
if m_Library.Shared.IsTradingPlaza then return end
UpdateBottom();
m_Library.Signal.Fired("Stat Changed"):Connect(function(p14) -- Line: 925
	if p14 == "AreasUnlocked" or p14 == "TeleportsUnlocked" or p14 == "Gamepasses" then
		UpdateBottom();
		UpdateAreas();
		return;
	end
	if p14 == "Hardcore" or p14 == "OwnsTradingPlaza" then
		UpdateRealms();
		UpdateAreas();
	end
end);
m_Library.Signal.Fired("Resolution Changed"):Connect(function() -- Line: 936
	--[[
		Upvalues:
			[1] = t_Teleport
	--]]
	task.defer(function() -- Line: 937
		--[[
			Upvalues:
				[1] = t_Teleport
		--]]
		Scrolling(t_Teleport.Gui.Frame.LeftContainer.Holder);
		Scrolling(t_Teleport.Gui.Frame.RightContainer.Holder);
	end);
end);
local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 944
	--[[
		Upvalues:
			[1] = t_Teleport
			[2] = m_Library
	--]]
	while true do
		if t_Teleport.Gui.Enabled then
			Scrolling(t_Teleport.Gui.Frame.LeftContainer.Holder);
			Scrolling(t_Teleport.Gui.Frame.RightContainer.Holder);
		end
		m_Library.Heartbeat(30);
	end
end);
coroutine_wrap_ret();
