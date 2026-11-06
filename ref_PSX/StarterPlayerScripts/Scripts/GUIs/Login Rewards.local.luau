-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not v1.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end;
local l__Inventory__2 = v1.Assets.UI.Inventory;
local v3 = Color3.fromRGB(31, 145, 165);
local v4 = v1.Shared.ChristmasLoginRewards2022;
function isDone()
	local v5 = v1.Save.Get(v1.LocalPlayer);
	if not v5 then
		warn("Couldn't update! No save");
		return false;
	end;
	assert(v5);
	local v6 = nil;
	for v10, v11 in pairs(v1.Shared.ChristmasLoginRewards2022) do
		if v6 then
			if v6 < v10 then
				v6 = v10;
			end;
		else
			v6 = v10;
		end;	
	end;
	if v6 then
		if v5.ChristmasLoginReward2022.Stage + 1 <= v6 then

		else
			return true;
		end;
	end;
	return false;
end;
function getCurrentDay()
	return DateTime.fromUnixTimestamp(workspace:GetServerTimeNow() - 25200):ToUniversalTime().Day;
end;
local u1 = nil;
local l__LoginRewards__2 = v1.GUI.LoginRewards;
local u3 = v1.Shared.ChristmasLoginRewards2022;
local u4 = false;
function Setup()
	local v12 = v1.Save.Get(v1.LocalPlayer);
	if not v12 then
		return;
	end;
	local v13 = v12.ChristmasLoginReward2022.Stage + 1;
	local l__LastClaim__14 = v12.ChristmasLoginReward2022.LastClaim;
	if not u1 then
		u1 = v1.Network.Invoke("Get Login Time");
		if not u1 then
			return;
		end;
	end;
	local l__BottomRewards__15 = l__LoginRewards__2.BottomRewards;
	local l__RewardTemplate__16 = l__LoginRewards__2.RewardTemplate;
	l__RewardTemplate__16.Visible = false;
	for v20, v21 in pairs(u3) do
		local v22 = l__RewardTemplate__16:Clone();
		v22.Name = v20;
		if not v21 then
			warn("Failed to lookup stage Stage:", v13);
		else
			local v23 = nil;
			local v24 = workspace:GetServerTimeNow() - u1;
			local v25 = v12.ChristmasLoginReward2022.Stage + 1;
			local v26 = v1.Shared.ChristmasLoginRewards2022[v20];
			local l__Title__27 = v22.Content.Title;
			v23 = v22.Content.RewardIcon.Image;
			if v26.Reward[1] == "Diamonds" then
				l__Title__27.Visible = true;
				v23.Visible = true;
				v23.Image = v1.Directory.Currency.Diamonds.ImageOutline;
				l__Title__27.AutoLocalize = false;
				l__Title__27.Text = v1.Functions.NumberShorten(v26.Reward[2], false);
			elseif v26.Reward[1] == "Gingerbread" then
				l__Title__27.Visible = true;
				v23.Visible = true;
				v23.Image = v1.Directory.Currency.Gingerbread.ImageOutline;
				l__Title__27.AutoLocalize = false;
				l__Title__27.Text = v1.Functions.NumberShorten(v26.Reward[2], false);
			elseif v26.Reward[1] == "Pet" then
				l__Title__27.Visible = true;
				v23.Visible = false;
				local v28 = v1.Directory.Pets[v26.Reward[2]];
				local v29 = v1.Assets.UI.Inventory.Pet:Clone();
				v29.Size = UDim2.new(1, 0, 0.9, 0);
				Instance.new("UIAspectRatioConstraint").Parent = v29;
				local v30
				if v28.name == "Christmas 2022 Stocking" then
					v30 = "Stocking Gift";
				else
					v30 = v28.name;
				end;
				l__Title__27.Text = v30;
				local v31 = nil;
				local v32 = v26.Reward[3];
				if v28.strengthMax then
					v31 = v28.strengthMax;
					if v26.Reward[3] then
						if v32.r then
							v31 = v28.strengthMax * v1.Shared.PetTypeMult.Rainbow;
							v32.s = v31;
						end;
						if v32.g then
							v31 = v28.strengthMax * v1.Shared.PetTypeMult.Golden;
							v32.s = v31;
						end;
					end;
				end;
				v1.PetUI.Create(v29, v26.Reward[2], v32 or {});
				if v28.strengthMax then
					v29.Level.Visible = true;
					v29.Level.AutoLocalize = false;
					v29.Level.Text = v1.Functions.NumberShorten(v31);
				end;
				v29.Parent = v22.Content.RewardIcon.PetHolder;
			elseif v26.Reward[1] == "Boosters" then
				l__Title__27.Visible = true;
				v23.Visible = true;
				l__Title__27.Text = "x" .. v26.Reward[2][2];
				v23.Image = "rbxassetid://104432957516372";
			elseif v26.Reward[1] == "Booth" then
				l__Title__27.Visible = true;
				v23.Visible = true;
				l__Title__27.Text = v26.Reward[2];
				local v33 = v1.Directory.Booths[v26.Reward[2]];
				if v33 then
					v23.Image = v33.Icon;
				end;
			end;
			v22.Visible = true;
			v22.Parent = l__BottomRewards__15;
			if v20 < v25 then
				v22.Blackout.Visible = false;
			elseif v25 < v20 then
				v22.Blackout.Visible = true;
				v22.Blackout.TextLabel.Visible = false;
			elseif v20 == v25 then
				v22.Blackout.Visible = false;
				if v12.ChristmasLoginReward2022.LastClaim == getCurrentDay() then
					v22.Blackout.Visible = true;
					v22.Blackout.TextLabel.Visible = true;
					v22.Blackout.TextLabel.Text = "Next Reward Tomorrow!";
				elseif v24 < v26.RequiredTime then
					v22.Blackout.Visible = true;
					v22.Blackout.TextLabel.Visible = true;
					v22.Blackout.TextLabel.Text = "Reward in: " .. v1.Functions.FormatTime(v26.RequiredTime - v24);
				end;
			end;
		end;	
	end;
	v1.GUIFX.ButtonFX(l__LoginRewards__2.Gui.Frame.pattern.Claim.ClaimButton);
	u4 = true;
end;
local u5 = Color3.fromRGB(48, 221, 255);
local l__ClaimButton__6 = l__LoginRewards__2.Gui.Frame.pattern.Claim.ClaimButton;
function FastUpdate()
	local v34 = v1.Save.Get(v1.LocalPlayer);
	if not v34 then
		return;
	end;
	local l__BottomRewards__35 = l__LoginRewards__2.BottomRewards;
	for v40, v41 in pairs(u3) do
		local v39 = nil 
		v39 = l__BottomRewards__35:FindFirstChild(v40);
		local v42 = workspace:GetServerTimeNow() - u1;
		local v43 = v34.ChristmasLoginReward2022.Stage + 1;
		local v44 = v1.Shared.ChristmasLoginRewards2022[v43];
		if v40 < v43 then
			v39.Blackout.Visible = false;
			v39.UIStroke.Color = u5;
		elseif v43 < v40 then
			v39.Blackout.Visible = true;
			v39.Blackout.TextLabel.Visible = false;
		elseif v44 then
			if v40 == v43 then
				v39.Blackout.Visible = false;
				if v34.ChristmasLoginReward2022.LastClaim == getCurrentDay() then
					v39.Blackout.Visible = true;
					v39.Blackout.TextLabel.Visible = true;
					v39.Blackout.TextLabel.Text = "Next Reward Tomorrow!";
				elseif v42 < v44.RequiredTime then
					v39.Blackout.Visible = true;
					v39.Blackout.TextLabel.Visible = true;
					v39.Blackout.TextLabel.Text = "Reward in: " .. v1.Functions.FormatTime(v44.RequiredTime - v42);
				else
					v39.Blackout.Visible = true;
					v39.Blackout.TextLabel.Visible = true;
					v39.Blackout.TextLabel.Text = "Claim now!";
				end;
			end;
		end;	
	end;
	l__ClaimButton__6.ImageColor3 = CanClaimReward() and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
	if CanClaimReward() then
		if not l__ClaimButton__6:GetAttribute("Connected") then
			l__ClaimButton__6.Activated:Connect(function()
				if not CanClaimReward() then
					return;
				end;
				local v45, v46 = v1.Network.Invoke("Claim Reward");
				if not v45 then
					v1.Message.New(v46);
					return;
				end;
				u1 = workspace:GetServerTimeNow();
				v1.Audio.Play("rbxassetid://7000716242", script, 1, 1);
				FastUpdate();
			end);
			l__ClaimButton__6:SetAttribute("Connected", true);
		end;
	end;
	UpdateTree();
end;
function CanClaimReward()
	local v47 = v1.Save.Get(v1.LocalPlayer);
	if not v47 then
		return false;
	end;
	if not u1 then
		return false;
	end;
	local v48 = nil;
	for v52, v53 in pairs(u3) do
		local v54 = workspace:GetServerTimeNow() - u1;
		local v55 = v47.ChristmasLoginReward2022.Stage + 1;
		local v56 = v1.Shared.ChristmasLoginRewards2022[v55];
		if v56 then
			if not (v52 < v55) then
				if not (v55 < v52) then
					if v52 == v55 then
						if v47.ChristmasLoginReward2022.LastClaim ~= getCurrentDay() then
							if v56.RequiredTime <= v54 then
								return true;
							end;
							v48 = v56.RequiredTime - v54;
						end;
					end;
				end;
			end;
		end;	
	end;
	return false, v48;
end;
function UpdateTree()
	local v57 = v1.WorldCmds.GetMap();
	if v57:FindFirstChild("Interactive") then
		local v58 = v57.Interactive:FindFirstChild("ChristmasTreeLoginRewards");
		if v58 then
			local v59, v60 = CanClaimReward();
			if v59 then
				local l__Pad__61 = v58:FindFirstChild("Pad");
				if l__Pad__61 then
					local l__BillboardGui__62 = l__Pad__61:FindFirstChild("BillboardGui");
					if l__BillboardGui__62 then
						local l__Timer__63 = l__BillboardGui__62:FindFirstChild("Timer");
						if l__Timer__63 then
							l__Timer__63.Text = "Now!";
						end;
					end;
				end;
				local l__Chest__64 = v58:FindFirstChild("Chest");
				if l__Chest__64 then
					local l__Particles__65 = l__Chest__64:FindFirstChild("Particles");
					if l__Particles__65 then
						for v66, v67 in ipairs(l__Particles__65:GetChildren()) do
							v67.Enabled = true;						
						end;
						return;
					end;
				end;
			else
				local l__Pad__69 = v58:FindFirstChild("Pad");
				if l__Pad__69 then
					local l__BillboardGui__70 = l__Pad__69:FindFirstChild("BillboardGui");
					if l__BillboardGui__70 then
						local l__Timer__71 = l__BillboardGui__70:FindFirstChild("Timer");
						if l__Timer__71 then
							if v60 then
								l__Timer__71.Text = v1.Functions.FormatTime(v60);
							elseif isDone() then
								l__Timer__71.Text = "All rewards claimed!";
							else
								l__Timer__71.Text = "Claim again tomorrow!";
							end;
						end;
					end;
				end;
				local l__Chest__72 = v58:FindFirstChild("Chest");
				if l__Chest__72 then
					local l__Particles__73 = l__Chest__72:FindFirstChild("Particles");
					if l__Particles__73 then
						for v74, v75 in ipairs(l__Particles__73:GetChildren()) do
							v75.Enabled = false;						
						end;
					end;
				end;
			end;
		end;
	end;
end;
v1.Signal.Fired("World Changed"):Connect(function()
	UpdateTree();
end);
v1.Signal.Fired("Stat Changed"):Connect(function(p1)
	if p1 == "ChristmasLoginReward2022" then
		FastUpdate();
	end;
end);
v1.GUIFX.ButtonFX(l__LoginRewards__2.Close);
local u7 = false;
l__LoginRewards__2.Close.Activated:Connect(function()
	if not u7 then
		u7 = true;
		l__LoginRewards__2.Gui.Enabled = false;
		u7 = false;
	end;
end);
Setup();
local u8 = 0;
v1.RunService.Heartbeat:Connect(function(p2)
	u8 = u8 + p2;
	if u8 >= 0.25 then
		u8 = 0;
		FastUpdate();
	end;
end);
