-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local bool1 = false;
local table1 = {};
local u1 = nil;
local u2 = nil;
local u3 = nil;
function SetupScavengerEgg(p1) -- Line: 8
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u2
			[3] = u1
			[4] = table1
			[5] = bool1
			[6] = u3
	--]]
	local v1 = m_Library.Save.Get();
	if not v1 then return end
	if v1.ScavengerEggsCollected and v1.ScavengerEggsCollected[tostring(u2)] and table.find(v1.ScavengerEggsCollected[tostring(u2)], p1.Name) then
		DisableScavengerEgg(p1);
		return;
	end
	local t_Name = p1.Name;
	if not u1 or not table.find(u1, t_Name) then
		DisableScavengerEgg(p1);
		return;
	end
	local bool2 = false;
	local v2, v3 = m_Library.Interact.Add(p1.Egg.CFrame.p, {
		label = "Collect",
		dist = 20
	});
	table.insert(table1, v3);
	v2:Connect(function() -- Line: 30
		--[[
			Upvalues:
				[1] = bool1
				[2] = m_Library
				[3] = p1
				[4] = table1
		--]]
		if not bool1 then
			bool1 = true;
			if not m_Library.FFlags.Get(m_Library.FFlags.Keys.ScavengerClaim) then
				m_Library.Message.New("Sorry, this is disabled right now! Try back soon!");
				bool1 = false;
				return;
			end
			local v6, v7 = m_Library.Network.Invoke("Claim Scavenger Item", p1.Name);
			if v6 ~= true then
				m_Library.Message.New(v7 or "Something went wrong!");
				bool1 = false;
				return;
			end
			p1:Destroy();
			for _, val8 in ipairs(table1) do
				val8();
			end
			table1 = {};
			bool1 = false;
		end
	end);
	EnableScavengerEgg(p1);
	local function Show() -- Line: 62
		--[[
			Upvalues:
				[1] = m_Library
				[2] = u3
				[3] = p1
		--]]
		local v4 = m_Library.Directory.Eggs[u3];
		local Clone_ret = m_Library.Assets.Billboards.EggInfo:Clone();
		local t_drops = v4.drops;
		local t_isGolden = v4.isGolden;
		local v5 = m_Library.Save.Get();
		if type(t_drops) == "string" then
			t_drops = m_Library.Directory.Eggs[t_drops].drops;
		end
		for key7, val7 in ipairs(t_drops) do
			local v8 = val7[1];
			local v9 = m_Library.Directory.Pets[v8];
			local t_rarity = v9.rarity;
			local v10 = val7[3];
			if t_rarity == "Secret" or v10 and not m_Library.Shared.IsHardcore then continue end
			local Clone_ret2 = m_Library.Assets.UI.EggInfo.Pet:Clone();
			Clone_ret2:SetAttribute("PetId", v8);
			local function CalculatePetChance() -- Line: 87
				--[[
					Upvalues:
						[1] = t_drops
						[2] = val7
				--]]
				local v15 = 0;
				for _, val10 in ipairs(t_drops) do
					v15 = v15 + val10[2];
				end
				return val7[2] / v15 * 100;
			end
			local v11 = 0;
			for _, val9 in ipairs(t_drops) do
				v11 = v11 + val9[2];
			end
			local v12 = val7[2] / v11 * 100;
			Clone_ret2.Thumbnail.Image = t_isGolden and v9.goldenThumbnail or v9.thumbnail;
			Clone_ret2.LayoutOrder = 9999 - v12;
			if v5.AutoDelete[v9.rarity] then
				Clone_ret2.DeleteImage.Visible = true;
			else
				Clone_ret2.DeleteImage.Visible = false;
			end
			if t_rarity == "Legendary" or t_rarity == "Mythical" or t_rarity == "Event" or t_rarity == "Exclusive" or v12 <= 0.0099 then
				Clone_ret2.Thumbnail.Chance.Text = "??";
				m_Library.GUIFX.Rainbow(Clone_ret2.Thumbnail.Chance, "TextColor3");
			else
				local math_clamp_ret = math.clamp(math.pow(0.9315, v12) * 94.2467 / 100, 0, 1);
				local Lerp_ret = Color3.fromRGB(49, 255, 39):Lerp(Color3.fromRGB(255, 75, 39), math_clamp_ret);
				local Color3_toHSV_ret1, Color3_toHSV_ret2, Color3_toHSV_ret3 = Color3.toHSV(Lerp_ret);
				local Color3_fromHSV_ret = Color3.fromHSV(Color3_toHSV_ret1, Color3_toHSV_ret2, Color3_toHSV_ret3 * 2);
				Clone_ret2.Thumbnail.Chance.TextColor3 = Color3_fromHSV_ret;
				Clone_ret2.Thumbnail.Chance.Text = m_Library.Functions.FormatChance(v12 / 100);
			end
			if v9.titanic then
				Clone_ret2.TitanicCrown.Visible = true;
			end
			Clone_ret2.Thumbnail.Position = UDim2.new(0, 0, 1, 0);
			Clone_ret2.Thumbnail.ImageTransparency = 1;
			m_Library.Functions.Tween(Clone_ret2.Thumbnail, {
				Position = UDim2.new(0, 0, 0, 0),
				ImageTransparency = 0
			}, {
				key7 / 9 / 3 + 0.45,
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
		Clone_ret.Parent = p1.Egg;
	end
	local function Hide() -- Line: 148
		--[[
			Upvalues:
				[1] = p1
				[2] = m_Library
		--]]
		local EggInfo = p1.Egg:FindFirstChild("EggInfo");
		if EggInfo then
			m_Library.Functions.Tween(EggInfo, {
				Size = UDim2.new(0, 0, 0, 0),
				StudsOffset = Vector3.new(0, 4, 0)
			}, {
				0.15,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.In
			}).Completed:Connect(function() -- Line: 152
				--[[
					Upvalues:
						[1] = EggInfo
				--]]
				EggInfo:Destroy();
			end);
		end
	end
	local t_Egg = p1.Egg;
	local Random_new_ret = Random.new();
	local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 163
		--[[
			Upvalues:
				[1] = t_Egg
				[2] = Random_new_ret
				[3] = m_Library
		--]]
		local t_CFrame = t_Egg.CFrame;
		local NextNumber_ret = Random_new_ret:NextNumber(1, 10);
		local os_clock_ret = os.clock();
		local os_clock_ret2 = nil;
		while t_Egg and t_Egg.Parent do
			if not os_clock_ret2 or os.clock() - os_clock_ret2 >= 2 then
				local DistanceFromCharacter_ret = m_Library.LocalPlayer:DistanceFromCharacter(t_Egg.CFrame.p);
				if DistanceFromCharacter_ret >= 300 then
					wait((math.clamp(DistanceFromCharacter_ret / 600, 0.5, 3)));
				else
					os_clock_ret2 = os.clock();
				end
			end
			local v13 = os.clock() - os_clock_ret + NextNumber_ret;
			t_Egg.CFrame = t_CFrame * CFrame.new(0, math.sin(v13 * 1) / 2, 0) * CFrame.Angles(0, v13, 0);
			m_Library.RenderStepped();
		end
	end);
	coroutine_wrap_ret();
	local coroutine_wrap_ret2 = coroutine.wrap(function() -- Line: 188
		--[[
			Upvalues:
				[1] = m_Library
				[2] = p1
				[3] = bool2
				[4] = Show
				[5] = Hide
		--]]
		local _ = m_Library.Save.Get();
		while p1 and p1:FindFirstChild("Egg") do
			local v14 = (p1.Egg and m_Library.LocalPlayer:DistanceFromCharacter(p1.Egg.CFrame.p) or 999) <= 20;
			local _ = p1.Egg:FindFirstChild("EggInfo");
			if v14 and not bool2 then
				bool2 = true;
				Show();
			elseif bool2 and not v14 then
				bool2 = false;
				Hide();
			end
			m_Library.Heartbeat(5);
		end
	end);
	coroutine_wrap_ret2();
end
function DisableScavengerEgg(p2) -- Line: 210
	for _, descendant1 in ipairs(p2:GetDescendants()) do
		if descendant1:isA("ParticleEmitter") then
			descendant1.Enabled = false;
		end
		if descendant1:isA("SurfaceLight") then
			descendant1.Enabled = false;
		end
		if not descendant1:isA("BasePart") then continue end
		descendant1.Transparency = 1;
		descendant1.CanCollide = false;
	end
	p2.DescendantAdded:Connect(function(descendant) -- Line: 224
		if descendant:isA("ParticleEmitter") then
			descendant.Enabled = false;
		end
		if descendant:isA("SurfaceLight") then
			descendant.Enabled = false;
		end
		if descendant:isA("BasePart") then
			descendant.Transparency = 1;
			descendant.CanCollide = false;
		end
	end);
end
function EnableScavengerEgg(p3) -- Line: 238
	for _, descendant2 in ipairs(p3:GetDescendants()) do
		if descendant2:isA("ParticleEmitter") then
			descendant2.Enabled = true;
		end
		if descendant2:isA("SurfaceLight") then
			descendant2.Enabled = true;
		end
		if not descendant2:isA("BasePart") then continue end
		descendant2.Transparency = 0;
		descendant2.CanCollide = true;
	end
	p3.DescendantAdded:Connect(function(descendant2_0) -- Line: 252
		if descendant2_0:isA("ParticleEmitter") then
			descendant2_0.Enabled = true;
		end
		if descendant2_0:isA("SurfaceLight") then
			descendant2_0.Enabled = true;
		end
		if descendant2_0:isA("BasePart") then
			descendant2_0.Transparency = 0;
			descendant2_0.CanCollide = true;
		end
	end);
end
function ClearWorld() -- Line: 266
	--[[
		Upvalues:
			[1] = table1
			[2] = m_Library
	--]]
	for _, val3 in ipairs(table1) do
		val3();
	end
	table1 = {};
	local Map = m_Library.WorldCmds.GetMap();
	local Scavenger = Map:WaitForChild("Scavenger");
	for _, child4 in ipairs(Scavenger:GetChildren()) do
		DisableScavengerEgg(child4);
	end
	Scavenger.ChildAdded:Connect(function(child) -- Line: 279
		DisableScavengerEgg(child);
	end);
end
function LoadWorld() -- Line: 284
	--[[
		Upvalues:
			[1] = u1
			[2] = u2
			[3] = u3
			[4] = m_Library
			[5] = table1
	--]]
	if not u1 then
		u1, u2, u3 = m_Library.Network.Invoke("Get Scavenger Event Info");
		if not u1 or not u2 then return end
	end
	if not m_Library.Network.Invoke("Scavenger Hunt Active") then
		ClearWorld();
		return;
	end
	for _, val5 in ipairs(table1) do
		val5();
	end
	table1 = {};
	local Map2 = m_Library.WorldCmds.GetMap();
	local Scavenger2 = Map2:WaitForChild("Scavenger");
	for _, child6 in ipairs(Scavenger2:GetChildren()) do
		SetupScavengerEgg(child6);
	end
	Scavenger2.ChildAdded:Connect(function(child2) -- Line: 308
		SetupScavengerEgg(child2);
	end);
end
m_Library.Signal.Fired("World Changed"):Connect(LoadWorld);
m_Library.Network.Fired("Scavenger Hunt Started"):Connect(LoadWorld);
m_Library.Network.Fired("Scavenger Hunt Ended"):Connect(ClearWorld);
m_Library.Network.Fired("Scavenger Event Ready"):Connect(function(p4, p5, p6) -- Line: 321
	--[[
		Upvalues:
			[1] = u1
			[2] = u2
			[3] = u3
	--]]
	u1 = p4;
	u2 = p5;
	u3 = p6;
	LoadWorld();
end);
