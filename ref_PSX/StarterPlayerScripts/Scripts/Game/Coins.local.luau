-- https://github.com/kalidrios

local table1 = {
	normal = "rbxassetid://6958713639",
	good = "rbxassetid://6958713793",
	great = "rbxassetid://6958713747",
	special = "rbxassetid://6958713692",
	easteregg = "rbxassetid://9395255388",
	fruit = "rbxassetid://139453757467799"
};
local table2 = {
	coin = {
		"rbxassetid://6422233047",
		"rbxassetid://6422233117"
	},
	cardboard_coin = {
		"rbxassetid://12151937071",
		"rbxassetid://12151936879",
		"rbxassetid://12151936744"
	},
	chest = {
		"rbxassetid://6422233314",
		"rbxassetid://6422233259",
		"rbxassetid://6422233191"
	},
	cardboard_chest = {"rbxassetid://12151937223"},
	safe = {"rbxassetid://132566660399530"},
	vault = {"rbxassetid://6958718747"},
	special = {"rbxassetid://7029284027"},
	luckyblock = {"rbxassetid://11648888186"}
};
local _ = {
	[1] = "rbxassetid://7004964385",
	[2] = "rbxassetid://7004964341",
	[3] = "rbxassetid://7004964463"
};
local table3 = {
	"chest",
	"vault",
	"safe"
};
local table4 = {
	6485234572,
	6485234808,
	6485234993
};
local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local m_Areas = require(game.ReplicatedStorage.Library.Modules.Areas);
local Coins = m_Library.Things:WaitForChild("Coins");
local Random_new_ret = Random.new();
local _ = m_Library.Player.Camera();
local t_CoinGrabDistance = m_Library.Settings.CoinGrabDistance;
local _ = m_Library.Shared.IsHardcore;
local u1 = {};
local table5 = {};
local table6 = {};
local table7 = {
	[1] = "Default",
	[2] = "Mid",
	[3] = "Low",
	[4] = "Default"
};
function UpdateCoin(p1) -- Line: 59
	--[[
		Upvalues:
			[1] = u1
			[2] = Coins
			[3] = m_Library
			[4] = m_Areas
			[5] = table7
			[6] = table4
			[7] = table5
			[8] = t_CoinGrabDistance
			[9] = table3
			[10] = table2
	--]]
	debug.profilebegin("Coins.Updatecoin");
	local v1 = u1[p1];
	if not v1 then return end
	local FindFirstChild_ret = Coins:FindFirstChild(p1);
	if not FindFirstChild_ret then return end
	assert(typeof(p1) == "string");
	local v2 = FindFirstChild_ret:GetAttribute("Frame") + 1;
	local POS = FindFirstChild_ret:FindFirstChild("POS");
	local u2 = FindFirstChild_ret:FindFirstChild("Coin");
	local Pets = FindFirstChild_ret:FindFirstChild("Pets");
	local t_h = v1.h;
	local t_p = v1.p;
	local t_n = v1.n;
	local t_a = v1.a;
	local _ = v1.w;
	local t_pets = v1.pets;
	local _ = v1.r;
	local u3 = m_Library.Directory.Coins[t_n];
	local t_mh = v1.mh;
	FindFirstChild_ret:SetAttribute("Area", t_a);
	FindFirstChild_ret:SetAttribute("Health", t_h);
	FindFirstChild_ret:SetAttribute("Frame", v2);
	local Attribute = FindFirstChild_ret:GetAttribute("ModelStage");
	local t_modelHasStages = u3.modelHasStages;
	if t_modelHasStages and (FindFirstChild_ret:GetAttribute("HasLanded") or v2 == 1) then
		FindFirstChild_ret:SetAttribute("ModelStage", table7[m_Areas.ComputeCoinStage(u3, v1, t_h)]);
	elseif not FindFirstChild_ret:GetAttribute("HasLanded") or not t_modelHasStages then
		FindFirstChild_ret:SetAttribute("ModelStage", "Default");
	end
	local Attribute2 = FindFirstChild_ret:GetAttribute("ModelStage");
	if Attribute ~= Attribute2 then
		local v12 = u2 == nil;
		if not v12 then
			local _ = Attribute2 == "Low";
			m_Library.Audio.Play(table4, POS.CFrame.Position, 1, 0.66, 325);
			CoinDamageAnimation(p1, false);
		end
		if u2 then
			m_Library.Functions.AddDebris(u2, 0);
		end
		local v13 = table5[p1];
		if v13 then
			table5[p1] = nil;
			v13();
		end
		u2 = (Attribute2 == "Default" and u3.model or Attribute2 == "Mid" and u3.modelMidHealth or Attribute2 == "Low" and u3.modelLowHealth or false):Clone();
		u2.Name = "Coin";
		if t_n ~= "Ice Block" then
			u2.Color = Color3.new(1, 1, 1);
		end
		if v12 and t_n == "Massive Comet" then
			local v18 = m_Library.Functions.Scaler();
			v18(u2, 5);
		end
		if u3.textureID ~= "" and u3.textureID ~= nil then
			u2.TextureID = u3.textureID;
		end
		u2.CastShadow = false;
		u2.Anchored = true;
		u2.CollisionGroup = "Coins";
		local Pivot = u2:GetPivot();
		for _, child8 in ipairs(u2:GetChildren()) do
			if not child8:IsA("BasePart") then continue end
			local ToObjectSpace_ret2 = Pivot:ToObjectSpace(child8:GetPivot());
			child8:SetAttribute("RelativeCFrame", ToObjectSpace_ret2);
			child8.CastShadow = false;
			child8.Anchored = true;
			child8.CollisionGroup = "Coins";
		end
		local ToObjectSpace_ret = u2.CFrame:ToObjectSpace(u3.model.CFrame);
		u2.CFrame = POS.CFrame * ToObjectSpace_ret:Inverse();
		local Pivot2 = u2:GetPivot();
		for _, child9 in ipairs(u2:GetChildren()) do
			if not child9:IsA("BasePart") then continue end
			local Attribute3 = child9:GetAttribute("RelativeCFrame");
			if not Attribute3 then continue end
			child9:PivotTo(Pivot2:ToWorldSpace(Attribute3));
		end
		local ClickDetector = Instance.new("ClickDetector");
		ClickDetector.MaxActivationDistance = t_CoinGrabDistance;
		ClickDetector.CursorIcon = "rbxassetid://11901225868";
		ClickDetector.Parent = u2;
		if u2:GetAttribute("Comet") then
			u2.Position = t_p + Vector3.new(0, u2.Size.Y / 2 - u2.Size.Y / 3, 0);
			u2.Rotation = u3.model.Rotation;
			m_Library.Signal.Fire("Comets: Setup Breakable", p1, u2);
		elseif t_n == "Giant Rainbow Chest" then
			m_Library.Signal.Fire("Rainbow: Setup Breakable", p1, u2);
		elseif t_n == "Kawaii Alley Chest" then
			m_Library.Signal.Fire("Kawaii Alley: Setup Breakable", p1, u2);
		end
		u2.Parent = FindFirstChild_ret;
	end
	for _, val1 in ipairs(t_pets) do
		local FindFirstChild_ret4 = Pets:FindFirstChild(val1);
		if not FindFirstChild_ret4 then
			local v19, v20 = m_Library.PetCmds.Get(val1);
			if not v19 or not v20 then continue end
			local Folder = Instance.new("Folder");
			Folder.Name = val1;
			Folder:SetAttribute("Owner", v20.Name);
			Folder:SetAttribute("Dir", v19.id);
			Folder:SetAttribute("ID", v19.uid);
			Folder:SetAttribute("Tick", v2);
			Folder.Parent = Pets;
			continue;
		end
		FindFirstChild_ret4:SetAttribute("Tick", v2);
	end
	for _, child2 in ipairs(Pets:GetChildren()) do
		if child2:GetAttribute("Tick") == v2 then continue end
		m_Library.Functions.AddDebris(child2, 0);
	end
	local bool1 = false;
	for _, child3 in ipairs(Pets:GetChildren()) do
		if child3:GetAttribute("Owner") ~= m_Library.LocalPlayer.Name then continue end
		bool1 = true;
		break;
	end
	if not FindFirstChild_ret:GetAttribute("HasLanded") and not FindFirstChild_ret:GetAttribute("IsFalling") then
		FindFirstChild_ret:SetAttribute("IsFalling", true);
		local DistanceFromCharacter_ret = m_Library.LocalPlayer:DistanceFromCharacter(POS.CFrame.Position);
		local Attribute4 = u2:GetAttribute("InstantLand");
		if DistanceFromCharacter_ret <= 400 and not Attribute4 then
			local t_CFrame = POS.CFrame;
			local u8 = t_CFrame * CFrame.new(0, 60, 0);
			u2.CanCollide = false;
			u2.CFrame = u8;
			local Pivot3 = u2:GetPivot();
			for _, child13 in ipairs(u2:GetChildren()) do
				if not child13:IsA("BasePart") then continue end
				child13.CanCollide = false;
				local Attribute6 = child13:GetAttribute("RelativeCFrame");
				if not Attribute6 then continue end
				child13:PivotTo(Pivot3:ToWorldSpace(Attribute6));
			end
			local num1 = 0.9;
			local u9 = Enum.EasingStyle.Bounce;
			local t_Out = Enum.EasingDirection.Out;
			if m_Library.Functions.SearchArray(table3, u3.landSound) then
				num1 = 0.2;
				u9 = Enum.EasingStyle.Linear;
			end
			m_Library.Functions.RenderStepped(function(_, p25) -- Line: 300
				--[[
					Upvalues:
						[1] = m_Library
						[2] = u9
						[3] = t_Out
						[4] = u2
						[5] = u8
						[6] = t_CFrame
				--]]
				local v36 = m_Library.Functions.Easing(p25, u9, t_Out);
				u2.CFrame = u8:Lerp(t_CFrame, v36);
				local Pivot4 = u2:GetPivot();
				for _, child15 in ipairs(u2:GetChildren()) do
					if not child15:IsA("BasePart") then continue end
					local Attribute5 = child15:GetAttribute("RelativeCFrame");
					if not Attribute5 then continue end
					child15:PivotTo(Pivot4:ToWorldSpace(Attribute5));
				end
			end, num1, true);
			local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 319
				--[[
					Upvalues:
						[1] = u2
						[2] = t_CFrame
						[3] = table2
						[4] = u3
						[5] = m_Library
						[6] = FindFirstChild_ret
				--]]
				local v37 = false;
				while u2 and u2.Parent and not v37 do
					v37 = u2.Position.Y - u2.Size.Y / 2 - t_CFrame.Y <= 2;
					if v37 then
						if table2[u3.landSound] then
							local v40 = u3.landSound == "chest" and true or u3.landSound == "safe" and true or u3.landSound == "vault";
							m_Library.Audio.Play(table2[u3.landSound], u2.CFrame.Position, 1, v40 and 0.5 or 0.15, v40 and 600 or 300);
						end
						u2.CanCollide = true;
						for _, child16 in ipairs(u2:GetChildren()) do
							if not child16:IsA("BasePart") then continue end
							child16.CanCollide = true;
						end
						FindFirstChild_ret:SetAttribute("HasLanded", true);
						FindFirstChild_ret:SetAttribute("IsFalling", false);
						if u3.grinchPetId then
							local Grinch = FindFirstChild_ret:FindFirstChild("Coin"):FindFirstChild("Grinch");
							Grinch.Anchored = false;
							m_Library.Functions.Animation("7019175615", Grinch, 1);
						end
					end
					m_Library.Heartbeat(2);
				end
			end);
			coroutine_wrap_ret();
		else
			FindFirstChild_ret:SetAttribute("HasLanded", true);
			FindFirstChild_ret:SetAttribute("IsFalling", false);
		end
	end
	local HUD = POS:FindFirstChild("HUD");
	if #t_pets > 0 and bool1 then
		local math_clamp_ret = math.clamp(t_h / t_mh, 0, 1);
		local v17;
		if not HUD then
			v17 = m_Library.Assets.Billboards:WaitForChild("Progress"):Clone();
			v17.Name = "HUD";
			v17.StudsOffset = Vector3.new(0, u2.Size.Y / 2 + 3, 0);
			local math_clamp_ret2 = math.clamp(math.max(u2.Size.X, u2.Size.Z) / 4.5, 1, 12);
			local ProgressText = v17:FindFirstChild("ProgressText");
			if ProgressText then
				local UIStroke = ProgressText:FindFirstChildOfClass("UIStroke");
				if UIStroke then
					UIStroke.Thickness = UIStroke.Thickness + math_clamp_ret2 / 3.5;
				end
			end
			v17.Size = UDim2.new(v17.Size.X.Scale * math_clamp_ret2, v17.Size.X.Offset, v17.Size.Y.Scale * math_clamp_ret2, v17.Size.Y.Offset);
			v17.Parent = POS;
		else
			v17 = HUD;
		end
		local ProgressText2 = v17:FindFirstChild("ProgressText");
		if ProgressText2 then
			ProgressText2.Text = m_Library.Functions.NumberShorten(t_h, false);
		end
		v17.Adornee = u2;
		local Progress = v17:FindFirstChild("Progress");
		if Progress then
			local Health = Progress:FindFirstChild("Health");
			if Health then
				local udim2 = UDim2.new(math_clamp_ret, 0, 1, 0);
				if udim2.X.Scale == 1 then
					Health.Size = udim2;
				else
					m_Library.Functions.Tween(Health, {Size = udim2}, {
						0.125,
						"Expo",
						"Out"
					});
				end
				if t_modelHasStages then
					if math_clamp_ret <= 1 / 3 then
						Health.BackgroundColor3 = Color3.fromRGB(252, 75, 75);
					elseif math_clamp_ret <= 2 / 3 then
						Health.BackgroundColor3 = Color3.fromRGB(252, 140, 60);
					else
						Health.BackgroundColor3 = Color3.fromRGB(39, 233, 55);
					end
				end
			end
		end
		if not table5[p1] then
			table5[p1] = m_Library.WorldFX.QuestGlow(u2, 1, 0.85);
		end
		local t_b2 = v1.b;
		for key10, val10 in pairs(m_Areas.SPECIAL_BONUS_TYPES) do
			local v21 = t_b2 and m_Areas.CalcSpecialBonusMultiplier(t_b2, val10);
			local v22 = "SpecialBonusText" .. key10;
			local FindFirstChild_ret3 = v17:FindFirstChild(v22);
			if not v21 then
				if not FindFirstChild_ret3 then continue end
				m_Library.Functions.AddDebris(FindFirstChild_ret3, 0);
				continue;
			end
			local v34;
			if not FindFirstChild_ret3 then
				v34 = m_Library.Assets.Other:WaitForChild("Coin Special Bonuses"):WaitForChild(key10):Clone();
				v34.Name = v22;
				v34.Parent = v17;
			else
				v34 = FindFirstChild_ret3;
			end
			v34.Text = string.format("* %gx %s! *", v21, key10);
		end
	elseif HUD then
		m_Library.Functions.AddDebris(HUD, 0);
		local v23 = table5[p1];
		if v23 then
			v23();
			table5[p1] = nil;
		end
	end
	if u2 then
		local t_b = v1.b;
		for key11, val11 in pairs(m_Areas.SPECIAL_BONUS_TYPES) do
			local v24 = t_b and m_Areas.CalcSpecialBonusMultiplier(t_b, val11);
			local v25 = "SpecialBonusParticle" .. key11;
			local FindFirstChild_ret2 = u2:FindFirstChild(v25);
			if not v24 then
				if not FindFirstChild_ret2 then continue end
				m_Library.Functions.AddDebris(FindFirstChild_ret2, 0);
				continue;
			end
			local v35;
			if not FindFirstChild_ret2 then
				v35 = m_Library.Assets.Particles:WaitForChild("Coin Special Bonuses"):WaitForChild(key11):Clone();
				v35.Name = v25;
				v35:SetAttribute("OriginalRate", v35.Rate);
				v35.Parent = u2;
			else
				v35 = FindFirstChild_ret2;
			end
			v35.Rate = math.max(1, (math.ceil(v35:GetAttribute("OriginalRate") * v24 / 3)));
		end
	end
	debug.profileend();
end
function AddCoin(p2) -- Line: 481
	--[[
		Upvalues:
			[1] = table6
			[2] = u1
			[3] = m_Library
			[4] = Coins
	--]]
	assert(typeof(p2) == "string");
	if table6[p2] then return end
	local v3 = u1[p2];
	if not v3 then
		m_Library.Print("Coin ID [bold]" .. p2 .. "[/bold] doesn't exist", true);
		return;
	end
	if Coins:FindFirstChild(p2) then
		m_Library.Print("Coin ID [bold]" .. p2 .. "[/bold] is already rendered", true);
		return;
	end
	debug.profilebegin("Coins.AddCoin");
	local t_h2 = v3.h;
	local t_p2 = v3.p;
	local t_r = v3.r;
	local t_n2 = v3.n;
	local _ = v3.w;
	local v4 = m_Library.Directory.Coins[t_n2];
	local Folder2 = Instance.new("Folder");
	Folder2.Name = p2;
	local POS2 = Instance.new("Part");
	POS2.Transparency = 1;
	POS2.Anchored = true;
	POS2.CanCollide = false;
	POS2.Size = Vector3.new();
	POS2.CFrame = CFrame.new(t_p2) * CFrame.Angles(0, t_r, 0) + Vector3.new(0, v4.model.Size.Y / 2, 0) - Vector3.new(0, 0.075, 0);
	POS2.Name = "POS";
	POS2.Parent = Folder2;
	Folder2:SetAttribute("ID", p2);
	Folder2:SetAttribute("Health", t_h2);
	Folder2:SetAttribute("Name", t_n2);
	Folder2:SetAttribute("ModelStage", "");
	Folder2:SetAttribute("IsFalling", false);
	Folder2:SetAttribute("HasLanded", false);
	Folder2:SetAttribute("Frame", 0);
	local Pets2 = Instance.new("Folder");
	Pets2.Name = "Pets";
	Pets2.Parent = Folder2;
	Folder2.Parent = Coins;
	UpdateCoin(p2);
	debug.profileend();
end
function RemoveCoin(p3, p4, p5) -- Line: 546
	--[[
		Upvalues:
			[1] = Coins
			[2] = table6
			[3] = u1
			[4] = m_Areas
			[5] = m_Library
			[6] = table4
			[7] = table1
			[8] = Random_new_ret
	--]]
	assert(typeof(p3) == "string");
	debug.profilebegin("Coins.RemoveCoin");
	local FindFirstChild_ret5 = Coins:FindFirstChild(p3);
	if FindFirstChild_ret5 then
		table6[p3] = true;
		local v14 = u1[p3];
		if v14 and not p4 then
			local v26 = 1;
			local v27 = 1;
			local v28 = 1;
			local t_b3 = v14.b;
			if t_b3 then
				for _, val14 in pairs(m_Areas.SPECIAL_BONUS_TYPES) do
					local v38 = m_Areas.CalcSpecialBonusMultiplier(t_b3, val14);
					if not v38 then continue end
					local v39 = math.log(v38) * 0.333691 + 0.81863;
					v26 = v26 * v39;
					v27 = v27 * v39;
				end
			end
			local v29 = m_Library.Directory.Coins[v14.n];
			if v29.breakSoundMultiplier then
				v28 = v28 * v29.breakSoundMultiplier;
			end
			local POS3 = FindFirstChild_ret5:FindFirstChild("POS");
			if POS3 then
				local t_Position = POS3.CFrame.Position;
				m_Library.Audio.Play(table4, t_Position, 1.2, v26 * 0.66, 325);
				m_Library.Audio.Play(table1[v29.breakSound], t_Position, Random_new_ret:NextNumber(0.95, 1.05), v26 * 0.75 * v28, 325);
			end
			CoinDamageAnimation(p3, true);
		end
		if p5 and p5 > 0 then
			local u10 = m_Library.Functions.Transparency();
			local v30 = m_Library.Functions.RenderStepped(function(_, p26) -- Line: 608
				--[[
					Upvalues:
						[1] = u10
						[2] = FindFirstChild_ret5
				--]]
				u10(FindFirstChild_ret5, 1, p26);
			end, p5, true);
			v30:Then(function() -- Line: 610
				--[[
					Upvalues:
						[1] = m_Library
						[2] = FindFirstChild_ret5
				--]]
				m_Library.Functions.AddDebris(FindFirstChild_ret5, 0);
			end);
		else
			m_Library.Functions.AddDebris(FindFirstChild_ret5, 0);
		end
	end
	u1[p3] = nil;
	debug.profileend();
end
function CoinDamageAnimation(p6, p7) -- Line: 624
	--[[
		Upvalues:
			[1] = Coins
			[2] = u1
			[3] = m_Areas
			[4] = m_Library
			[5] = Random_new_ret
	--]]
	local FindFirstChild_ret6 = Coins:FindFirstChild(p6);
	if not FindFirstChild_ret6 then return end
	local POS4 = FindFirstChild_ret6:FindFirstChild("POS");
	if not POS4 then return end
	local Coin = FindFirstChild_ret6:FindFirstChild("Coin");
	if not Coin then return end
	local v5 = u1[p6];
	if not v5 then
		warn("WHY?");
		return;
	end
	debug.profilebegin("Coins.CoinDamageAnimation");
	local v6 = 1;
	local u4 = 1;
	local t_b4 = v5.b;
	if t_b4 then
		for _, val12 in pairs(m_Areas.SPECIAL_BONUS_TYPES) do
			local v31 = m_Areas.CalcSpecialBonusMultiplier(t_b4, val12);
			if not v31 then continue end
			local v32 = math.log(v31) * 0.333691 + 0.81863;
			v6 = v6 * v32;
			u4 = u4 * v32;
		end
	end
	local function _(p23) -- Anonymous function at line 661
		--[[
			Upvalues:
				[1] = u4
		--]]
		return math.ceil(p23 * u4);
	end
	local function _(p24) -- Anonymous function at line 662
		--[[
			Upvalues:
				[1] = u4
		--]]
		return p24 * u4;
	end
	local t_CFrame2 = POS4.CFrame;
	local v7, v8 = m_Library.Functions.CreateParticleHost(t_CFrame2);
	local math_max_ret = math.max((Coin.Size.Magnitude / 20) ^ 0.9, 1);
	local Children = m_Library.Assets.Particles:FindFirstChild(p7 and "Coin Explode" or "Coin Damage"):GetChildren();
	for _, val4 in ipairs(Children) do
		local Clone_ret2 = val4:Clone();
		m_Library.Functions.ScaleParticle(Clone_ret2, math_max_ret);
		Clone_ret2.Parent = v8;
		if Clone_ret2.Name == "Sparkles" then
			Clone_ret2:Emit((math.ceil(u4 * 15)));
			continue;
		end
		Clone_ret2:Emit((math.ceil(u4 * 2)));
	end
	local num2 = 25;
	local num3 = 25;
	local num4 = 40;
	local math_ceil_ret = math.ceil(u4 * 10);
	local math_ceil_ret2 = math.ceil(num2 * u4);
	local math_ceil_ret3 = math.ceil(num3 * u4);
	local math_ceil_ret4 = math.ceil(num4 * u4);
	local Clone_ret = m_Library.Assets.Particles:FindFirstChild("New Coin Particle"):Clone();
	Clone_ret.Parent = v8;
	Clone_ret:Emit(Random_new_ret:NextInteger(math_ceil_ret, math_ceil_ret2));
	if p7 then
		local v15 = u4 * 120;
		Clone_ret.Rate = v15;
		Clone_ret.Enabled = true;
		task.delay(Random_new_ret:NextInteger(math_ceil_ret3, math_ceil_ret4) / v15, function() -- Line: 705
			--[[
				Upvalues:
					[1] = Clone_ret
			--]]
			Clone_ret.Enabled = false;
		end);
	end
	m_Library.Functions.AddDebris(v7, 5);
	debug.profileend();
end
function PetDamageAnimation(p8, _, p9, _) -- Line: 753
	--[[
		Upvalues:
			[1] = Coins
			[2] = Random_new_ret
			[3] = m_Library
	--]]
	debug.profilebegin("Coins.PetDamageAnimation");
	local FindFirstChild_ret7 = Coins:FindFirstChild(p8);
	if FindFirstChild_ret7 and p9 == true then
		local Coin2 = FindFirstChild_ret7:FindFirstChild("Coin");
		if Coin2 then
			local v33 = Coin2.Size / 2;
			local Attachment = Instance.new("Attachment");
			Attachment.Position = Vector3.new(Random_new_ret:NextNumber(-v33.X, v33.X), Random_new_ret:NextNumber(-v33.Y, v33.Y), Random_new_ret:NextNumber(-v33.Z, v33.Z));
			local Clone_ret3 = m_Library.Assets.Particles:FindFirstChild("Pet Damage"):Clone();
			Clone_ret3.ZOffset = math.max(v33.X, v33.Z);
			Clone_ret3.Parent = Attachment;
			Clone_ret3:Emit(1);
			Attachment.Parent = Coin2;
			m_Library.Functions.AddDebris(Attachment, 1);
		end
	end
	debug.profileend();
end
function UpdateComets() -- Line: 793
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
			[3] = Coins
	--]]
	local v9 = m_Library.WorldCmds.Get();
	for key5, val5 in pairs(u1) do
		if Coins:FindFirstChild(key5) then continue end
		local t_h3 = val5.h;
		if val5.n ~= "Massive Comet" and val5.n ~= "Mini Comet" and val5.n ~= "Giant Rainbow Chest" and val5.n ~= "Kawaii Alley Chest" or t_h3 <= 0 or v9 ~= val5.w then continue end
		AddCoin(key5);
	end
end
function UpdateCoins() -- Line: 808
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
			[3] = Coins
	--]]
	debug.profilebegin("Coins.UpdateCoins");
	local v10 = m_Library.WorldCmds.Get();
	for key6, val6 in pairs(u1) do
		if Coins:FindFirstChild(key6) or val6.h <= 0 or v10 ~= val6.w then continue end
		debug.profileend();
		m_Library.Functions.Wait(0.03);
		debug.profilebegin("Coins.UpdateCoins");
		AddCoin(key6);
	end
	for _, child7 in ipairs(Coins:GetChildren()) do
		local t_Name = child7.Name;
		local v16 = u1[t_Name];
		if v16 and v10 == v16.w then continue end
		RemoveCoin(t_Name);
	end
	debug.profileend();
end
function InvokeCoins() -- Line: 837
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
	--]]
	local v11 = m_Library.Network.Invoke("Get Coins");
	if v11 then
		u1 = v11;
		return;
	end
	m_Library.Print("Coins returned as nil", true);
end
local coroutine_wrap_ret2 = coroutine.wrap(function() -- Line: 851
	--[[
		Upvalues:
			[1] = m_Library
			[2] = Coins
	--]]
	wait(1);
	if m_Library.Variables.Mobile then return end
	local u5 = m_Library.Player.Mouse();
	local u6 = nil;
	local u7 = nil;
	game:GetService("RunService").RenderStepped:Connect(function(_) -- Line: 862
		--[[
			Upvalues:
				[1] = u5
				[2] = Coins
				[3] = u6
				[4] = u7
				[5] = m_Library
		--]]
		debug.profilebegin("Coins.Mouse");
		local t_Target = u5.Target;
		if t_Target and t_Target:IsDescendantOf(Coins) and t_Target.Parent and t_Target.Parent:GetAttribute("ID") and not t_Target:GetAttribute("PreventClick") then
			if u6 ~= t_Target then
				if u7 then
					u7();
				end
				local t_Parent = t_Target.Parent;
				if t_Parent then
					u7 = m_Library.WorldFX.QuestGlow(t_Parent, 1.5, 0.5, true);
				end
			end
			u6 = t_Target;
		else
			u6 = nil;
			if u7 then
				u7();
			end
		end
		debug.profileend();
	end);
end);
coroutine_wrap_ret2();
m_Library.Network.Fired("Update Coin Pets"):Connect(function(p10, p11) -- Line: 892
	--[[
		Upvalues:
			[1] = u1
	--]]
	if u1[p10] then
		u1[p10].pets = p11;
		UpdateCoin(p10);
	end
end);
m_Library.Network.Fired("Update Coin Health"):Connect(function(p12, p13) -- Line: 900
	--[[
		Upvalues:
			[1] = u1
	--]]
	if u1[p12] then
		u1[p12].h = p13;
		UpdateCoin(p12);
	end
end);
m_Library.Network.Fired("Update Coin Special Bonus"):Connect(function(p14, p15) -- Line: 908
	--[[
		Upvalues:
			[1] = u1
	--]]
	if u1[p14] then
		u1[p14].b = p15;
		UpdateCoin(p14);
	end
end);
m_Library.Network.Fired("Remove Coin"):Connect(function(p16, p17, p18) -- Line: 916
	--[[
		Upvalues:
			[1] = u1
	--]]
	if u1[p16] then
		RemoveCoin(p16, p17, p18);
	end
end);
m_Library.Network.Fired("Damage Coin"):Connect(function(p19, p20, p21, p22) -- Line: 923
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
	--]]
	p22 = p22 or m_Library.LocalPlayer;
	if u1[p19] then
		if p22 ~= m_Library.LocalPlayer then return end
		PetDamageAnimation(p19, p20, p21, p22);
	end
end);
while true do
	if not m_Library.WorldCmds.HasLoaded() or not m_Library.LocalPlayer:FindFirstChild("__LOADED") then
		m_Library.RenderStepped();
		continue;
	end
	pcall(function() -- Line: 942
		InvokeCoins();
		UpdateComets();
		UpdateCoins();
	end);
	wait(2);
end
