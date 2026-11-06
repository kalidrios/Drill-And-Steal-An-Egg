local Library = game:GetService("ReplicatedStorage"):WaitForChild("Library")
local Signal = require(Library.Signal)
local Functions = require(Library.Functions)
local Datastore = require(script.Parent.Datastore)
local Network = require(game:GetService("ServerScriptService"):WaitForChild("Library").Network)

local Settings = require(script.Parent.Settings)
local Saving = require(script.Parent.Saving)
local RunService = game:GetService("RunService")
local Heartbeat = function(p1)  
	for index1 = 1, p1 or 1 do
		RunService.Heartbeat:Wait();
	end
end
local Directory = require(Library.Directory)
local Pets = require(script.Parent.Pets)
local Shared = require(Library.Shared)
local Mastery = require(script.Parent.Mastery)
local Boosts = require(script.Parent.Boosts)
local Upgrades = require(script.Parent.Upgrades)
local Orbs = require(script.Parent.Orbs)
local CalculateReward = require(script.Parent.CalculateReward)
local Achievements = require(script.Parent.Achievements)
local LootBags = require(script.Parent.LootBags)
local Eggs = require(script.Parent.Eggs)
local Worlds = require(script.Parent.Worlds)
local Ranks = require(script.Parent.Ranks)
local ServerBoosts = require(script.Parent.ServerBoosts)
local Give = require(script.Parent.Give)
local RNG = Random.new()

local diamondMineMastery = 75

local v1 = {};
local l____WORLDS__2 = game.ServerStorage:WaitForChild("__WORLDS");
local u3 = {};
local u4 = Random.new();
local u5 = 1;
local u6 = {};
function v1.Create(p1, p2, p3, manual, ID)
	local worldDir =  Directory.Worlds[p1]
	local v2 = worldDir.spawns[p2];
	local l__settings__3 = v2.settings;
	local u7 = 0;
	local l__MAP__8 = l____WORLDS__2:FindFirstChild(p1):FindFirstChild("MAP");
	local l__area__9 = l__settings__3.area;
	local function u10(p4)
		u7 = u7 + 1;
		if u7 > 100 then
			warn("Coin spacing algo timeout");
			return true;
		end;
		for v4, v5 in pairs(u3[p1][p2]) do
			local l__Size__6 = Directory.Coins[v5.n].model.Size;
			if (p4 - v5.p).Magnitude - math.max(l__Size__6.X, l__Size__6.Z) / 2 < 10 then
				return false;
			end;
		end;
		return true;
	end;
	
	local Spawns = l__MAP__8:FindFirstChild("Spawns"):FindFirstChild(p2)
	if not Spawns then
		return 
	end
	
	local v10 = Spawns:GetChildren();
	local v11 = nil;
	local v12 = nil;
	local v13 = nil;
	local v14 = nil;
	local v15 = 0;
	while not v11 do
		v15 = v15 + 1;
		if v15 >= 100 then
			warn("Failed to calc position for new coin " .. l__area__9);
			return;
		end;
		v12 = v10[u4:NextInteger(1, #v10)];
		local l__Size__16 = v12.Size;
		v14 = math.floor(u4:NextNumber() * 1000) / 1000;
		v13 = v12.CFrame.p + Vector3.new(u4:NextNumber(-l__Size__16.X + 5, l__Size__16.X - 5), l__Size__16.Y, u4:NextNumber(-l__Size__16.Z + 5, l__Size__16.Z - 5)) / 2;
		if u10(v13) then
			v11 = true;
		end;		
	end;
	local v7 = v12
	local v8=v13
	local v9=v14
	if not v2 then
		warn("Coin spawn '" .. v7.Name .. "' is missing");
		return;
	end;
	local v17 = {};
	local v18 = 0;
	for v19, v20 in pairs(u3[p1][p2]) do
		if v20.h > 0 then
			v18 = v18 + 1;
			if not v17[v20.n] then
				v17[v20.n] = 1;
			else
				local l__n__21 = v20.n;
				v17[l__n__21] = v17[l__n__21] + 1;
			end;
		end;
	end;
	
	if l__settings__3.manualSpawn and not manual then
		return nil
	end
	
	local v22 = Functions.CloneTable(v2.coins);
	for v23, v24 in ipairs(v22) do
		local v25 = v24[1];
		if v17[v25] then
			v24[2] = v24[2] * math.max(1 - (v17[v25] / v18 + 0.33), 0.065);
		end;
	end;
	if not p3 then
		p3 = Functions.Lottery(unpack(v22));
	end;
	
	coroutine.wrap(function()
		if worldDir.luckyBlockEnabled and Settings.luckyBlockEvent then
			local randomLuckyBlock = {
				{"None", 85};
				{"Purple Lucky Block", 30};
				{"Orange Lucky Block", 10};
				{"Red Lucky Block", 3};
				{"Rainbow Lucky Block", 0.5};
			}
			local luckyBlock = Functions.Lottery(randomLuckyBlock)
			if luckyBlock and luckyBlock ~= "None" then
				if not string.match(p2, "Chest") then
					p3 = luckyBlock
				end	
			end
		end
	end)()
	
	local v27 = Directory.Coins[p3];
	if not v27 then
		warn(tostring(p3) .. " directory does not exist");
		return;
	end;
	local v28 = v27.health;
	if v27.scaleHealth then
		v28 = v28 * (l__settings__3.healthMult or 1);
    end;
    
    local hasMult = RNG:NextInteger(1,15)
    local specialMult = nil
    
	if hasMult == 15 then
        local lot = Functions.Lottery({ 
            {  3, 85 }, 
            {  5, 35 }, 
            { 10,  4 },
            { 25,  3.5 }, 
            { 50,  1.25 },
            --{ 75,  0.50 },
            { 100, 0.15 } 
        }) 
        
        if lot then
            lot = tonumber(lot)

            specialMult = {
                l = { {
                    t = v27.currencyType == "Diamonds" and 2 or 1,
                    m = lot
                } }
            }
            
    
        end
    end
    
	u3[p1][p2][tostring(u5)] = {
		n = p3, 
		p = Vector3.new(math.round(v8.X * 100) / 100, v8.Y, math.round(v8.Z * 100) / 100), 
		r = v9, 
		h = v28, 
		mh = v28, 
		w = p1, 
		a = l__area__9, 
		pets = {}, 
		petsFarming = {}, 
        d = false,
		b = specialMult,
		id = tostring(u5)
    };
    
	u6[tostring(u5)] = {};
	u5 = u5 + 1;
	return u5, Vector3.new(math.round(v8.X * 100) / 100, v8.Y, math.round(v8.Z * 100) / 100);
end;
function v1.CreateComet(p1, p2, p3, ID, pos)
	local v2 = Directory.Worlds[p1].spawns[p2];
	local l__settings__3 = v2.settings;
	local u7 = 0;
	local l__MAP__8 = l____WORLDS__2:FindFirstChild(p1):FindFirstChild("MAP");
	local l__area__9 = l__settings__3.area;
	local function u10(p4)
		u7 = u7 + 1;
		if u7 > 100 then
			warn("Coin spacing algo timeout");
			return true;
		end;
		for v4, v5 in pairs(u3[p1][p2]) do
			local l__Size__6 = Directory.Coins[v5.n].model.Size;
			if (p4 - v5.p).Magnitude - math.max(l__Size__6.X, l__Size__6.Z) / 2 < 10 then
				return false;
			end;
		end;
		return true;
	end;

	local Spawns = l__MAP__8:FindFirstChild("Spawns"):FindFirstChild(p2)
	if not Spawns then
		return 
	end

	local v10 = Spawns:GetChildren();
	local v11 = nil;
	local v12 = nil;
	local v13 = nil;
	local v14 = nil;
	local v15 = 0;
	while not v11 do
		v15 = v15 + 1;
		if v15 >= 100 then
			warn("Failed to calc position for new coin " .. l__area__9);
			return;
		end;
		v12 = v10[u4:NextInteger(1, #v10)];
		local l__Size__16 = v12.Size;
		v14 = math.floor(u4:NextNumber() * 1000) / 1000;
		v13 = v12.CFrame.p + Vector3.new(u4:NextNumber(-l__Size__16.X + 5, l__Size__16.X - 5), l__Size__16.Y, u4:NextNumber(-l__Size__16.Z + 5, l__Size__16.Z - 5)) / 2;
		if u10(v13) then
			v11 = true;
		end;		
	end;
	local v7 = v12
	local v8=v13
	local v9=v14
	if not v2 then
		warn("Coin spawn '" .. v7.Name .. "' is missing");
		return;
	end;
	local v17 = {};
	local v18 = 0;
	for v19, v20 in pairs(u3[p1][p2]) do
		if v20.h > 0 then
			v18 = v18 + 1;
			if not v17[v20.n] then
				v17[v20.n] = 1;
			else
				local l__n__21 = v20.n;
				v17[l__n__21] = v17[l__n__21] + 1;
			end;
		end;
	end;

	local v22 = Functions.CloneTable(v2.coins);
	for v23, v24 in ipairs(v22) do
		local v25 = v24[1];
		if v17[v25] then
			v24[2] = v24[2] * math.max(1 - (v17[v25] / v18 + 0.33), 0.065);
		end;
	end;
	if not p3 then
		p3 = Functions.Lottery(unpack(v22));
	end;

	local v27 = Directory.Coins[p3];
	if not v27 then
		warn(tostring(p3) .. " directory does not exist");
		return;
	end;
	local v28 = v27.health;
	if v27.scaleHealth then
		v28 = v28 * (l__settings__3.healthMult or 1);
	end;


	u3[p1][p2][tostring(ID)] = {
		n = p3, 
		p = pos, 
		r = v9, 
		h = v28, 
		mh = v28, 
		w = p1, 
		a = l__area__9, 
		pets = {}, 
		petsFarming = {}, 
		d = false,
		b = nil,
		id = ID
	};

	u6[tostring(ID)] = {};
	u5 = u5 + 1;
	return ID 
end;
function v1.GenID()
	u5 = u5 + 1;
	return u5
end;
function v1.GenPos(p1, p2, p3)
	local v2 = Directory.Worlds[p1].spawns[p2];
	local l__settings__3 = v2.settings;
	local u7 = 0;
	local l__MAP__8 = l____WORLDS__2:FindFirstChild(p1):FindFirstChild("MAP");
	local l__area__9 = l__settings__3.area;
	local function u10(p4)
		u7 = u7 + 1;
		if u7 > 100 then
			warn("Coin spacing algo timeout");
			return true;
		end;
		for v4, v5 in pairs(u3[p1][p2]) do
			local l__Size__6 = Directory.Coins[v5.n].model.Size;
			if (p4 - v5.p).Magnitude - math.max(l__Size__6.X, l__Size__6.Z) / 2 < 10 then
				return false;
			end;
		end;
		return true;
	end;

	local Spawns = l__MAP__8:FindFirstChild("Spawns"):FindFirstChild(p2)
	if not Spawns then
		return 
	end

	local v10 = Spawns:GetChildren();
	local v11 = nil;
	local v12 = nil;
	local v13 = nil;
	local v14 = nil;
	local v15 = 0;
	while not v11 do
		v15 = v15 + 1;
		if v15 >= 100 then
			warn("Failed to calc position for new coin " .. l__area__9);
			return;
		end;
		v12 = v10[u4:NextInteger(1, #v10)];
		local l__Size__16 = v12.Size;
		v14 = math.floor(u4:NextNumber() * 1000) / 1000;
		v13 = v12.CFrame.p + Vector3.new(u4:NextNumber(-l__Size__16.X + 5, l__Size__16.X - 5), l__Size__16.Y, u4:NextNumber(-l__Size__16.Z + 5, l__Size__16.Z - 5)) / 2;
		if u10(v13) then
			v11 = true;
		end;		
	end;
	local v8=v13

	return Vector3.new(math.round(v8.X * 100) / 100, v8.Y, math.round(v8.Z * 100) / 100);
end;
local x11 = {};
local times = {};
function v1.Remove(p5)
	p5 = tostring(p5);
	for v29, v30 in pairs(u3) do
		for v31, v32 in pairs(v30) do
			if v32[p5] then
				v1.NetworkEvent(p5, "Remove");
				if u6[p5] then
					u6[p5] = nil;
				end;
				if x11[p5] then
					x11[p5] = nil;
				end;
				v32[p5] = nil;
				if Directory.Worlds[v29].spawns[v31].settings.respawnCooldown then
					times[v31] = os.clock();
				end;
				return;
			end;
		end;
	end;
end;
function v1.Destroyed(p6)
	local v33 = v1.Get(p6);
	if not v33 then
		return;
	end;
	if v33.d then
		return;
	end;
	v33.d = true;
	local v34 = {};
	for v35, v36 in ipairs(v33.pets) do
		local v37, v38 = Pets.Get(v36);
		if v37 and v38 and not v34[v38] then
			v34[v38] = true;
		end;
	end;
	for v39, v40 in pairs(v34) do
		v1.Rewards(p6, v39);
	end;
	v1.Remove(p6);
end;
function v1.Damage(p7, p8)
	p7 = tostring(p7);
	local v41, v42 = Pets.Get(p8);
	if not v41 then
		return;
	end;
	local v43 = v1.Get(p7);
	if not v43 then
		return;
	end;
	if not Functions.SearchArray(v43.pets, p8) then
		warn("Pet is not allowed to farm coin -- " .. p7);
		return;
	end;
	local PET, OWNER = Pets.Get(p8)
	local v44 = Shared.ComputePetStrength(PET)  --Shared.ComputePetStrength(p8);

	if Shared.IsHardcore then
		v44 = v44 / Shared.HardcorePetMult
	else
		v44 = v44
	end
	local v45 = u6[p7];
	local l__h__46 = v43.h;
	local v47 = u4:NextNumber() <= 0.2;
	local v48 = v47 and v44 * 3 or v44;
	if not v48 then
		warn("Failed to calculate pet damage");
		return;
	end;
	if not v45[v42.Name] then
		v45[v42.Name] = {};
	end;
	if not v45[v42.Name][p8] then
		v45[v42.Name][p8] = { 0, 0 };
	end;
	local dmg = v48 <= v43.h and v48 or v48 - v43.h;
	local cmodel = Directory.Coins[v43.n];
	(function()
		local v49, v50 = Shared.HasPower(v41, "Strength");
		if v49 then
			dmg = dmg * Shared.GetPowerDir("Strength", v50).value;
		end;
	end)();
	(function()
		local v51 = 1;
		for v52, v53 in pairs(v45) do
			for v54, v55 in pairs(v53) do
				local v56 = Pets.Get(v54);
				if v56 then
					local v57, v58 = Shared.HasPower(v56, "Teamwork");
					if v57 then
						v51 = v51 + (Shared.GetPowerDir("Teamwork", v58).value - 1);
					end;
				end;
			end;
		end;
		dmg = dmg * v51;
	end)();
	(function()
		if string.find(cmodel.model.Name, "Chest") then
			local v59, v60 = Shared.HasPower(v41, "Chests");
			if v59 then
				dmg = dmg * Shared.GetPowerDir("Chests", v60).value;
			end;
		end;
	end)();
	(function()
		local v61, v62 = Shared.HasPower(v41, "Royalty");
		if v61 then
			local v63 = Shared.GetPowerDir("Royalty", v62);
			dmg = dmg * 2;
		end;
	end)();
	(function()
		if Boosts.Has(v42, "Triple Damage") then
			dmg = dmg * 3;
        end;
        if ServerBoosts.IsActive(v42, "Triple Damage")  then
            dmg = dmg * 3;
		end;
		if ServerBoosts.IsActive(v42, "Super Breaker")  then
			dmg = dmg * 25;
		end;
        local dir = Directory.Fruits["Apple"]
        local m = require(script.Parent.Fruit).Get(v42, dir) or 0
		local EE=require(script.Parent.Fruit).GetBonus(v42, dir)--dir.Bonus(m)
        if tonumber(EE) and EE < 1 then
            EE = EE + 1
        end
        
        if m >= 1 then
            dmg = dmg * ( EE or 1 ) 
        end    
	end)();
	dmg = math.min(dmg, math.round(v43.mh / 3 + 0.5));
	dmg = math.max(math.round(dmg), 0);
	local v64 = v45[v42.Name][p8];
	v64[1] = v64[1] + (dmg <= v43.h and dmg or v43.h);
	local v65 = v45[v42.Name][p8];
	v65[2] = v65[2] + (v48 <= v43.h and v48 or v43.h);
	v43.h = math.max(v43.h - dmg, 0);
	v1.NetworkEvent(p7, "Health");
	v1.NetworkEvent(p7, "Special Bonus");
	v1.NetworkEvent(p7, "Damage", dmg, v47, v42);
	if v43.h > 0 then
		v1.Rewards(p7, v42);
	end;
	Ranks.Progress(v42, v48);
	--[[if Directory.Worlds[Saving.Get(OWNER).World]=="Diamond Mine" then
		
	end]]--
    LootBags.Progress(v42, v48 / 45, v43.p, {
        blastRadius = math.clamp((cmodel.model.Size.Magnitude / 20) ^ 0.9, 1, 8)
    }, v43.n);
	if v43.h <= 0 then
		v1.Destroyed(p7);
	end;
end;
function v1.Get(p9)
	p9 = tostring(p9);
	for v66, v67 in pairs(u3) do
		for v68, v69 in pairs(v67) do
			if v69[p9] then
				return v69[p9];
			end;
		end;
	end;
end;
local plyrcoindat2 = {};
local function cfunc(p10, p11)
	local v70 = nil;
	local v71 = nil;
	local v72 = u6[p10][p11.Name];
	if not v72 then
		return;
	end;
	local v73 = 0;
	local v74 = 0;
	local v75 = {};
	for v76, v77 in pairs(v72) do
		local v78, v79 = Pets.Get(v76);
		if v78 and v79 == p11 then
			v73 = v73 + v77[1];
			v74 = v74 + v77[2];
			table.insert(v75, v78.s);
		end;
	end;
	table.sort(v75, function(p12, p13)
		return p13 < p12;
	end);
	v71 = 0;
	v70 = 0;
	for v80 = 1, math.min(#v75, 4) do
		v70 = v70 + 1;
		v71 = v71 + v75[v80];
	end;
	return v73, v70, v71 / v70, v74; -- DEBUG : v73, local v82 / v81, v74
end;
function v1.Rewards(p14, p15)
	local v83 = nil;
	local v84 = nil;
	local v85 = nil;
	p14 = tostring(p14);
	local v86 = Saving.Get(p15, false);
	if not v86 then
		return;
	end;
	local v87 = v1.Get(p14);
	if not v87 then
		return;
	end;
	local v88 = u6[p14];
	if not v88 or not v88[p15.Name] then
		return;
	end;
	if v86.World ~= v87.w then
		return;
	end;
	if not x11[p14] then
		x11[p14] = {};
	end;
	local v89 = x11[p14];
	local l__n__90 = v87.n;
	local v91 = Directory.Coins[l__n__90];
	local l__a__92 = v87.a;
	local v93 = Directory.Areas[l__a__92];
	v83 = v87.h;
	local v94 = math.clamp((v91.model.Size.Magnitude / 20) ^ 0.9, 1, 8);
	local v95 = Upgrades.Get(p15, "More Diamonds");
	local v96 = 1;
	if v91.modelHasStages then
		local v97 = v83 / v87.mh;
		if v97 <= 0 then
			v96 = 4;
		elseif v97 <= 0.33 then
			v96 = 3;
		elseif v97 <= 0.66 then
			v96 = 2;
		else
			v96 = 1;
		end;
	elseif v83 <= 0 then
		v96 = 4;
	end;
	local v98 = v96 == 4;
	if v98 then
		if plyrcoindat2[p15] then
			plyrcoindat2[p15] = plyrcoindat2[p15] + 1;
		else
			plyrcoindat2[p15] = 1;
		end;
	end;
	local v99 = nil;
	local v100 = nil;
	local v101 = nil;
	v85, v99, v100, v101 = cfunc(p14, p15);
	v84 = function()
		return u4:NextNumber(5, 8) / v91.orbsRandom.speedMult / math.clamp(v99 / 2, 1, 3);
	end;
	local v102 = v89[p15];
	if not v102 then
		v89[p15] = {
			stage = v96, 
			incr = {
				lastTick = os.clock(), 
				lastTickGoal = v84(), 
				lastDamage = v85
			}
		};
		return;
	end;
	local rewardchance = Settings.BonusRewardChance;
	(function()
		local v103 = 0;
		for v104, v105 in pairs(v87.pets) do
			local v106 = Pets.Get(v105);
			if v106 then
				local v107, v108 = Shared.HasPower(v106, "Charm");
				if v107 then
					v103 = v103 + (Shared.GetPowerDir("Charm", v108).value - 1);
				end;
			end;
		end;
		rewardchance = rewardchance + v103;
	end)();
	local l__currencyType__18 = v91.currencyType;
	local l__p__19 = v87.p;
	local l__Name__20 = v91.model.Name;
    if v102.stage ~= v96 and v96 > 1 then
          
		(function()
			local l__orbsBreak__109 = v91.orbsBreak;
			v102.stage = v96;
			local v110 = {
				name = l__n__90, 
				area = l__a__92, 
				breakType = "Break"
			};
			local v111 = CalculateReward(p15, v85 / 8, l__currencyType__18, v87.pets, {
				coinInfo = v110, 
				avgPetLevel = v100
			});
			local v112 = CalculateReward(p15, v85 / 8, "Diamonds", v87.pets, {
				coinInfo = v110, 
				avgPetLevel = v100, 
				disableScaling = true
			});
			local v113 = 1 + v96 / 8;
			local v114 = u4:NextInteger(3 * v113 * l__orbsBreak__109.amountMult, 5 * v113 * l__orbsBreak__109.amountMult);
			local u20 = math.max(math.round(v111 / v114 ^ 0.75), 1);
			
			local mult = v87.b and v87.b.l[1].m or 1
			local multiply = 1
			
			if mult >= 50 then
				local lol = mult / 2
				mult = lol
				multiply = lol
			end
			
			u20 = u20 * multiply
			
            coroutine.wrap(function()
                for i = 1, v87.b and mult or 1 do
                    for v115 = 1, v114 do
                        Orbs.Add(p15, l__p__19, l__currencyType__18, u20, {
                            BlastRadius = v94
                        });
                        Functions.Wait(u4:NextNumber(0, math.min(v115 / 250, 0.075)));
                    end;
                end
			end)();
			coroutine.wrap(function()
                Orbs.Add(p15, l__p__19, "Diamonds", v112, {
                    BlastRadius = v94
                });
            end)();
            --[[coroutine.wrap(function()
                local v116 = u4:NextInteger(3, 10);
                local v117 = math.max(math.round(CalculateReward(p15, v85 / 8, "Easter Coins", v87.pets, {
                    coinInfo = v110, 
                    avgPetLevel = v100
                }) / v116 ^ 0.75), 1);
                for v118 = 1, v116 do
                    Orbs.Add(p15, l__p__19, "Easter Coins", v117, {
                        BlastRadius = v94
                    });
                    Functions.Wait(u4:NextNumber(0, math.min(v118 / 30, 0.075)));
                end;
            end)();]]--
            if v98 then
                if u4:NextNumber() <= rewardchance then
                    local v119 = u4:NextInteger(20, 30);
					local u22 = math.max(math.round(v112 * u4:NextNumber(0.7, 1)), 1);
					local u23 = math.max(math.round(u20 / v119 ^ 0.7), 1);
					coroutine.wrap(function()
						Orbs.Add(p15, l__p__19, "Diamonds", u22);
						for v120 = 1, v119 do
							Orbs.Add(p15, l__p__19, l__currencyType__18, u23);
							Functions.Wait(u4:NextNumber(0, math.min(v120 / 250, 0.075)));
						end;
					end)();
					coroutine.wrap(function()
						Network.Fire("Coin Bonus", p15, l__p__19);
					end)();
				end;
				if v85 / v87.mh >= 0.1 then
					Achievements.Add(p15, "Mine Coins", 1);
					if l__Name__20 == "Large Coins" or l__Name__20 == "Tiny Coins" or l__Name__20 == "Coins" then
						local v121
						if l__Name__20 == "Large Coins" then
							v121 = 100;
						elseif l__Name__20 == "Coins" then
							v121 = 75;
						else
							v121 = false;
							if l__Name__20 == "Tiny Coins" then
								v121 = 50;
							end;
						end;
						Mastery.Progress(p15, "Coin Piles", v121);
					elseif l__Name__20 == "Present" then
						Mastery.Progress(p15, "Presents", 125);
						Achievements.Add(p15, "Presents", 1);
					elseif l__Name__20 == "Crate" then
						Mastery.Progress(p15, "Crates", 75);
						Achievements.Add(p15, "Crates", 1);
					elseif l__Name__20 == "Vault" then
						Mastery.Progress(p15, "VaultsAndSafes", 150);
						Achievements.Add(p15, "Vaults", 1);
					elseif l__Name__20 == "Safe" then
						Mastery.Progress(p15, "VaultsAndSafes", 75);
						Achievements.Add(p15, "Safes", 1);
					elseif l__Name__20 == "Diamonds" or l__Name__20 == "Tiny Diamonds" then
						Mastery.Progress(p15, "Diamond Piles", 125);
					elseif string.find(l__Name__20, "Chest") then
						Mastery.Progress(p15, "Chests", 75);
						Achievements.Add(p15, "Chests", 1);
						if l__Name__20 == "Magma Chest" then
							Achievements.Add(p15, "Magma Chest", 1);
						elseif l__Name__20 == "Grand Heaven Chest" then
							Achievements.Add(p15, "Grand Heaven Chest", 1);
						elseif l__Name__20 == "Giant Tech Chest" then
							Achievements.Add(p15, "Giant Tech Chest", 1);
						elseif l__Name__20 == "Giant Steampunk Chest" then
							Achievements.Add(p15, "Giant Steampunk Chest", 1);
						elseif l__Name__20 == "Giant Hacker Chest" then
							Signal.Fire("Hacker Portal Progress", p15, 1, 1);
						end;
					end;
				end;
				
				coroutine.wrap(function()
					local save = Saving.Get(p15)
					if save then
						local world = Shared.IsHardcore and save.Hardcore.World or save.World
						if world == "Diamond Mine" then
							Mastery.Progress(p15, "Diamond Mine", diamondMineMastery)
						end
					end
				end)()
				
				coroutine.wrap(function()
					if l__Name__20 == "Massive Comet" then
						Signal.Fire("Comets: Broken",p15, v87.id, true)
					elseif l__Name__20 == "Mini Comet" then
						Signal.Fire("Comets: Broken",p15, v87.id, false)
					end
				end)()
				
				-- normal 50
				-- rainbow 250
				
                coroutine.wrap(function()
                    if l__Name__20 == "Apple" then            
                        local save = Saving.Get(p15)
                        if not save then
                            return
                        end

                        local fruitData = save.Fruits["Apple"] or nil
                        if not fruitData then
                            fruitData = {
                                Amount = 0,
                                LastUpdated = Shared.ComputeSaveAge(save)
                            }
                        end
                        
                        local amount = fruitData.Amount + 1
                        fruitData.Amount = amount
                        
                        Network.Fire("Update Fruit", p15, "Apple", fruitData)
						Signal.Fire("Update: Fruit", p15, "Apple", fruitData)
						
						Mastery.Progress(p15, "Fruits", 50)
                    end
                    if l__Name__20 == "Banana" then            
                        local save = Saving.Get(p15)
                        if not save then
                            return
                        end

                        local fruitData = save.Fruits["Banana"] or nil
                        if not fruitData then
                            fruitData = {
                                Amount = 0,
                                LastUpdated = Shared.ComputeSaveAge(save)
                            }
                        end

                        local amount = fruitData.Amount + 1
                        fruitData.Amount = amount

                        Network.Fire("Update Fruit", p15, "Banana", fruitData)
						Signal.Fire("Update: Fruit", p15, "Banana", fruitData)
						
						Mastery.Progress(p15, "Fruits", 50)
                    end
                    if l__Name__20 == "Pear" then            
                        local save = Saving.Get(p15)
                        if not save then
                            return
                        end

                        local fruitData = save.Fruits["Pear"] or nil
                        if not fruitData then
                            fruitData = {
                                Amount = 0,
                                LastUpdated = Shared.ComputeSaveAge(save)
                            }
                        end

                        local amount = fruitData.Amount + 1
                        fruitData.Amount = amount
                        
                        Network.Fire("Update Fruit", p15, "Pear", fruitData)
						Signal.Fire("Update: Fruit", p15, "Pear", fruitData)
						
						Mastery.Progress(p15, "Fruits", 50)
                    end
                    if l__Name__20 == "Orange" then            
                        local save = Saving.Get(p15)
                        if not save then
                            return
                        end

                        local fruitData = save.Fruits["Orange"] or nil
                        if not fruitData then
                            fruitData = {
                                Amount = 0,
                                LastUpdated = Shared.ComputeSaveAge(save)
                            }
                        end

                        local amount = fruitData.Amount + 1
                        fruitData.Amount = amount

                        Network.Fire("Update Fruit", p15, "Orange", fruitData)
						Signal.Fire("Update: Fruit", p15, "Orange", fruitData)
						
						Mastery.Progress(p15, "Fruits", 50)
                    end
                    if l__Name__20 == "Pineapple" then            
                        local save = Saving.Get(p15)
                        if not save then
                            return
                        end

                        local fruitData = save.Fruits["Pineapple"] or nil
                        if not fruitData then
                            fruitData = {
                                Amount = 0,
                                LastUpdated = Shared.ComputeSaveAge(save)
                            }
                        end

                        local amount = fruitData.Amount + 1
                        fruitData.Amount = amount
                        
                        Network.Fire("Update Fruit", p15, "Pineapple", fruitData)
						Signal.Fire("Update: Fruit", p15, "Pineapple", fruitData)
						
						Mastery.Progress(p15, "Fruits", 50)
                    end
                    if l__Name__20 == "Rainbow Fruit" then
                        for i, v in pairs(Directory.Fruits) do
                            if i == "Rainbow" then continue end
                            local save = Saving.Get(p15)
                            if not save then
                                return
                            end

                            local fruitData = save.Fruits[i] or nil
                            if not fruitData then
                                fruitData = {
                                    Amount = 0,
                                    LastUpdated = Shared.ComputeSaveAge(save)
                                }
                            end

                            local amount = fruitData.Amount + 1
                            fruitData.Amount = amount

                            Network.Fire("Update Fruit", p15, i, fruitData)
							Signal.Fire("Update: Fruit", p15, i, fruitData)
						end
						Mastery.Progress(p15, "Fruits", 250)
                    end
				end)()
				
				--[[
				;{ 
				{ { "Small Currency", 0.06666666666666667 }, 30 }, 
				{ { "Med Currency", 0.3333333333333333 }, 25 }, 
				{ { "Big Currency", 1 }, 6.25 }, 
				{ { "Random Zone Egg" }, 70 }, 
				{ { "Small Diamonds", 0.06666666666666667 }, 25 }, 
				{ { "Med Diamonds", 0.3333333333333333 }, 12.5 }, 
				{ { "Big Diamonds", 1 }, 3.125 }, 
				{ { "Small Boosters", 1 }, 20 }, 
				{ { "Med Boosters", 5 }, 5 }, 
				{ { "Big Boosters", 15 }, 1.25 },
				{ { "Open Egg", "Lucky Egg" }, 20 } 
				;} 
				
				]]
				
				local function calculateCurrency(quan, factor)
					local m = RNG:NextNumber(9999999, 9999999999)
					--if quan == "Big" then
					--	return m * factor
					--elseif quan == "Med" then
					--	return m * factor
					--end
					return m * factor
				end
				
				local function calculateDiamonds(quan, factor)
					local m = RNG:NextNumber(99999, 99999999)
					--if quan == "Big" then
					--	return m * factor
					--elseif quan == "Med" then
					--	return m * factor
					--end
					return m * factor
				end
				
				local function calculateBoost(quan, factor)
					local boostOdds = {
						["Triple Coins"] = 75;
						["Triple Damage"] = 50;
						["Super Lucky"] = 95;
						["Ultra Lucky"] = 15;
					}
					
					local boost = Functions.Lottery(boostOdds)
					return boost, factor
				end
				
				local function getWorldEggs(world)
					local areas = {}
					local eggs = {}
					for k, v in pairs(Directory.Areas) do
						if v.world == world then
							table.insert(areas, k)
						end
					end
					for k, v in pairs(Directory.Eggs) do
						if table.find(areas, v.area) then
							table.insert(eggs, {k, 100})
						end
					end
					return eggs
				end
				
				coroutine.wrap(function() 
					local save = Saving.Get(p15)
					if save then
						local world = (Shared.IsHardcore and save.Hardcore or save).World
						
						if v91.luckyBlockRewards then
							local rewards = Functions.Lottery(v91.luckyBlockRewards)
							if rewards then
								local reward, arg = unpack(rewards)
								local quan, type, e = unpack(string.split(reward, " "))
								
								local notificationRewards = {} 
								if type == "Currency" then
									local amount = calculateCurrency(quan, arg)
									local mainCurrency 
									if amount then
										local worldDir = Directory.Worlds[world]
										if worldDir then
											mainCurrency = worldDir.mainCurrency
											if mainCurrency then
												Give.Currency(p15, amount, mainCurrency)
												table.insert(notificationRewards, {worldDir.mainCurrency, amount})
											end
										end
									end
									local rarity = quan == "Small" and "Epic" or quan == "Med" and "Legendary" or quan == "Large" and "Mythical" or "???"
									Network.Fire("Notification", p15, "You got a "..string.lower(mainCurrency).." "..rarity.." drop!", {
										color = Color3.fromRGB(255, 255, 255), 
									})
								elseif type == "Diamonds" then
									local amount = calculateDiamonds(quan, arg)
									if amount then
										Give.Currency(p15, amount, "Diamonds")
										table.insert(notificationRewards, {"Diamonds", amount})
									end
									local rarity = quan == "Small" and "Epic" or quan == "Med" and "Legendary" or quan == "Large" and "Mythical" or "???"
									Network.Fire("Notification", p15, "You got a "..rarity.." Diamonds drop!", {
										color = Color3.fromRGB(255, 255, 255), 
									})
								elseif type == "Boosters" then
									local boost, amount = calculateBoost(quan, arg)
									if boost then
										Boosts.Give(p15, boost, amount)
										table.insert(notificationRewards, {boost, amount})
									end
									
								elseif quan == "Random" then
									if type == "Zone" then
										if e == "Egg" then
											local eggs = getWorldEggs(world)
											if eggs then
												local egg = Functions.Lottery(eggs)
												if egg then
													Eggs.Open(p15, egg, 1, nil, nil, egg, true)
												end
											end
										end
									end	
								elseif quan == "Open" then
									if type == "Egg" then 
										if Directory.Eggs[arg] then
											Eggs.Open(p15, arg, 1, nil, nil, arg, true)
										end	
									end
								end
								
								coroutine.wrap(function()
									Network.Fire("Rewards Redeemed", p15, notificationRewards)
								end)()
							end
						end
					end
				end)()
				
				if v91.eggReward then
					Eggs.Open(p15, v91.eggReward, v91.eggamount);
				end;
				
				Signal.Fire("Mined Coin", p15);
			end;
		end)();

		local v122 = v101;
		if string.find(l__Name__20, "Chest") and Mastery.HasPerk(p15, "Chests", 3) then
			v122 = v122 * 2.5;
		elseif l__Name__20 == "Crate" and Mastery.HasPerk(p15, "Crates", 3) then
			v122 = v122 * 2.5;
		elseif l__Name__20 == "Present" and Mastery.HasPerk(p15, "Presents", 3) then
			v122 = v122 * 2.5;
		elseif (l__Name__20 == "Coins" or l__Name__20 == "Tiny Coins" or l__Name__20 == "Large Coins") and Mastery.HasPerk(p15, "Coin Piles", 3) then
			v122 = v122 * 2.5;
		elseif (l__Name__20 == "Vault" or l__Name__20 == "Safe") and Mastery.HasPerk(p15, "VaultsAndSafes", 3) then
			v122 = v122 * 2.5;
		elseif string.find(l__Name__20, "Diamonds") and Mastery.HasPerk(p15, "Diamond Piles", 3) then
			v122 = v122 * 2.5;
		end;
        LootBags.Progress(p15, v122, l__p__19, {
            blastRadius = v94
        }, v87.n);
	end;
    
	if v102.incr.lastTickGoal <= os.clock() - v102.incr.lastTick then
		(function()
			v102.incr.lastTick = os.clock();
			v102.incr.lastTickGoal = v84();
			local v122 = math.max(v85 - v102.incr.lastDamage, 0);
			v102.incr.lastDamage = v85;
			if v122 > 0 then
				local v123 = {
					name = l__n__90, 
					area = l__a__92, 
					breakType = "Random"
				};
				local v124 = CalculateReward(p15, v122 / 2, "Diamonds", v87.pets, {
					coinInfo = v123, 
					avgPetLevel = v100, 
					disableScaling = true
				} );
				local v125 = u4:NextInteger(1, math.max(v99, 3) * v91.orbsRandom.amountMult);
				local u23 = math.max(math.round(CalculateReward(p15, v122 / 2, l__currencyType__18, v87.pets, {
					coinInfo = v123, 
					avgPetLevel = v100
				} ) / v125 ^ 0.75), 1);
				coroutine.wrap(function()
					for v126 = 1, v125 do
						Orbs.Add(p15, l__p__19, l__currencyType__18, u23, {
							BlastRadius = v94
						});
						Functions.Wait(u4:NextNumber(0, math.min(v126 / 250, 0.075)));
					end;
				end)();
				coroutine.wrap(function()
					if u4:NextNumber() < 0.125 + v95 * 0.05 then
						Orbs.Add(p15, l__p__19, "Diamonds", v124, {
							BlastRadius = v94
						});
					end;
				end)();
                --[[coroutine.wrap(function()
                    local Rand = u4:NextInteger(1, 3)
                    local Calc = CalculateReward(p15, v122 / 10, "Easter Coins", v87.pets, {
                        coinInfo = v123, 
                        avgPetLevel = v100, 
                        disableScaling = true
                    })
                    for v129 = 1, Rand do
                        Orbs.Add(p15, l__p__19, "Easter Coins", Calc, {
                            BlastRadius = v94
                        });
                        Functions.Wait(u4:NextNumber(0, math.min(v129 / 290, 0.075)));
                    end
                end)()]]--
			end;
		end)();
	end;
end;
function v1.Farm(p16, p17, p18)
	if not Saving.Get(p18, false) then
		return;
	end;
	local v130, v131 = Pets.Get(p17);
	if not v130 then
		return;
	end;
	if not v131 or p18 and v131 ~= p18 then
		return;
	end;
	local v132 = v1.Get(p16);
	if not v132 then
		return;
	end;
	if not Functions.SearchArray(v132.pets, p17) then
		return;
	end;
	if Functions.SearchArray(v132.petsFarming, p17) then
		return;
	end;
	table.insert(v132.petsFarming, p17);
	local u24 = v130;
	local u25 = v131;
	-- DEBUG
	coroutine.wrap(function()
		while (function()
				return v1.Get(p16) and (Functions.SearchArray(v132.pets, p17) and (Functions.SearchArray(v132.petsFarming, p17) and v132.h > 0));
			end)() and (function()
				local v133, v134 = Pets.Get(p17);
				u24 = v133;
				u25 = v134;
				return u24 and (u25 and Pets.IsEquipped(p18, u24.uid)) --u24.e);
			end)() do
			v1.Damage(p16, p17);
			wait(0.5);		
		end;
	end)()
end;
function v1.Join(p19, p20, p21)
	if not Pets then
		return
	end
	if not Saving.Get(p21, false) then
		return;
	end;
	local v135, v136 = Pets.Get(p20);
	if not v135 then
		warn("Failed to get pet id -- " .. p20);
	end;
	if not v136 or p21 and v136 ~= p21 then
		return;
	end;
	local v137 = v1.Get(p19);
	if not v137 then
		return;
	end;
	local v138 = Directory.Coins[v137.n];
	local v139 = #v137.pets;
	if not Worlds.HasArea(v136, v137.a)then
		return;
	end;
	if Functions.SearchArray(v137.pets, p20) then
		return;
	end;
	for v140, v141 in pairs(u3) do
		for v142, v143 in pairs(v141) do
			for v144, v145 in pairs(v143) do
				if Functions.SearchArray(v145.pets, p20) and not v1.Leave(v144, p20, p21) then
					return;
				end;
			end;
		end;
	end;
	table.insert(v137.pets, p20);
	v1.NetworkEvent(p19, "Pets");
	return true;
end;
function v1.Leave(p22, p23, p24)
	if not Saving.Get(p24, false) then
		return;
	end;
	local v146, v147 = Pets.Get(p23);
	if not v146 then
		return;
	end;
	if not v147 or p24 and v147 ~= p24 then
		return;
	end;
	local v148 = v1.Get(p22);
	if not v148 then
		return;
	end;
	for v149, v150 in ipairs(v148.pets) do
		if v150 == p23 then
			table.remove(v148.pets, v149);
			break;
		end;
	end;
	for v151, v152 in ipairs(v148.petsFarming) do
		if v152 == p23 then
			table.remove(v148.petsFarming, v151);
			break;
		end;
	end;
	v1.NetworkEvent(p22, "Pets");
	return true;
end;
function v1.Update()
    for v153, v154 in ipairs(l____WORLDS__2:GetChildren()) do
        local l__Name__155 = v154.Name;
        if Directory.Worlds[l__Name__155] then
            local l__spawns__156 = Directory.Worlds[l__Name__155].spawns;
            if l__spawns__156 and not u3[l__Name__155] then
                u3[l__Name__155] = {};
                for v157, v158 in pairs(l__spawns__156) do
                    u3[l__Name__155][v157] = {};
                end;
            end;
        end
    end;
    for v159, v160 in pairs(u3) do
		if not Shared.IsTradingPlaza or v159 == "Trading Plaza" then
			local v161 = Directory.Worlds[v159];
			for v165, v166 in pairs(v160) do
				local v167 = times[v165];
				local l__maxCoins__168 = v161.spawns[v165].settings.maxCoins;
				local v169 = Functions.DictionaryLength(v166);
				if v169 < l__maxCoins__168 and (not v167 or not (os.clock() - v167 < 10)) then
					for v170 = 1, l__maxCoins__168 - v169 do
						v1.Create(v159, v165);
						Heartbeat();
					end;
				end;
			end
		end;
	end;
end;
function v1.NetworkEvent(p25, p26, ...)
	local v171 = { ... };
	local v172 = v1.Get(p25);
	if v172 and v172.w then
		for v173, v174 in ipairs((Worlds.GetNetworkList(v172.w))) do
			coroutine.wrap(function()
				if p26 == "Pets" then
					Network.Fire("Update Coin Pets", v174, p25, v172.pets);
					return;
				end;
				if p26 == "Health" then
					Network.Fire("Update Coin Health", v174, p25, v172.h);
					return;
				end;
				if p26 == "Remove" then
					Network.Fire("Remove Coin", v174, p25);
					return;
				end;
				if p26 == "Damage" then
					local v175, v176, v177 = unpack(v171);
					Network.Fire("Damage Coin", v174, p25, v175, v176, v177);
				end;
				if p26 == "Special Bonus" then
					return;
				end;
			end)();
		end;
	end
end;
Network.Invoked("Join Coin").OnInvoke = function(p27, p28, p29)
	if type(p29) ~= "table" then
		return v1.Join(p28, p29);
	end;
	local v178 = {};
	for v179, v180 in ipairs(p29) do
		v178[v180] = v1.Join(p28, v180, p27);
	end;
	return v178;
end;
Network.Invoked("Leave Coin").OnInvoke = function(p30, p31, p32)
	if type(p32) ~= "table" then
		return v1.Leave(p31, p32);
	end;
	local v181 = {};
	for v182, v183 in ipairs(p32) do
		v181[v183] = v1.Leave(p31, v183, p30);
	end;
	return v181;
end;
Network.Fired("Farm Coin"):Connect(function(p33, p34, p35)
	--print('aaa',p34,p35,p33)
	v1.Farm(p34, p35, p33);
end);
Network.Invoked("Get Coins").OnInvoke = function(p36)
	local v184 = Saving.Get(p36, false);
	if not v184 then
		return;
	end;
	local l__World__185 = v184.World;
	local v186 = {};
	if u3[l__World__185] then
		for v187, v188 in pairs(u3[l__World__185]) do
			for v189, v190 in pairs(v188) do
				v186[v189] = v190;
			end;
		end;
	end;

	return v186;
end;
Network.Invoked("Coins: Get Test").OnInvoke = function(p1,p6)
	local v184 = Saving.Get(p1, false);
	if not v184 then
		return;
	end;

	local l__World__185 = v184.World;
	local v186 = {};
	if u3[l__World__185] then
		for v187, v188 in pairs(u3[l__World__185]) do
			for v189, v190 in pairs(v188) do
				v186[v189] = v190;
			end;
		end;
	end;

	return v186[p6];
end
local function u26(p37)
	for v191, v192 in pairs(u3) do
		for v193, v194 in pairs(v192) do
			for v195, v196 in pairs(v194) do
				if Functions.SearchArray(v196.pets, p37) then
					local v197 = v1.Leave(v195, p37);
					return;
				end;
			end;
		end;
	end;
end;
Signal.Fired("Pet Unequipped"):Connect(function(p38, p39)
	u26(p38);
end);
Signal.Fired("Pet Deleted"):Connect(function(p40, p41)
	u26(p40);
end);
coroutine.wrap(function()
	while true do
		v1.Update();
		wait(1);	
	end;
end)();
-- DEBUG
function GarbageCleanup()
	local v198 = 0;
	for v202, v203 in pairs(u3) do
		for v207, v208 in pairs(v203) do
			for v212, v213 in pairs(v208) do
				local v214 = #v213.pets - -1;
				for i = 1, #v213.pets do
					if (v198 + 1) % 25 == 0 then
						Heartbeat();
					end;
					local v215 = v213.pets[v214];
					local v216, v217 = Pets.Get(v215);
					local v218 = Saving.Get(v217, false);
					if v216 then
						if v217 then
							if Pets.IsEquipped(v217,v216.uid) then --v216.e then
								if v218 then
									if v218.World ~= v202 then
										table.remove(v213.pets, v214);
										for v222, v223 in ipairs(v213.petsFarming) do
											if v223 == v215 then
												table.remove(v213.petsFarming, v222);
												break;
											end;
										end
									end;
								else
									table.remove(v213.pets, v214);
									for v222, v223 in ipairs(v213.petsFarming) do
										if v223 == v215 then
											table.remove(v213.petsFarming, v222);
											break;
										end;
									end
								end;
							else
								table.remove(v213.pets, v214);
								for v222, v223 in ipairs(v213.petsFarming) do
									if v223 == v215 then
										table.remove(v213.petsFarming, v222);
										break;
									end;
								end
							end;
						else
							table.remove(v213.pets, v214);
							for v222, v223 in ipairs(v213.petsFarming) do
								if v223 == v215 then
									table.remove(v213.petsFarming, v222);
									break;
								end;
							end
						end;
					else
						table.remove(v213.pets, v214);
						for v222, v223 in ipairs(v213.petsFarming) do
							if v223 == v215 then
								table.remove(v213.petsFarming, v222);
								break;
							end;
						end
					end;
				end
			end			
		end
		---
	end
end;
game.Players.PlayerRemoving:Connect(function(p42)
	GarbageCleanup();
end);
coroutine.wrap(function()
	while true do
		GarbageCleanup();
		wait(1);	
	end;
end)();
function LogCheater(p43)
	Datastore.Update("Autofarm_" .. Settings.StatsVersion, "V1", function(p44)
		if not p44 then
			p44 = {};
		end;
		if not Functions.SearchArray(p44, p43.Name) then
			table.insert(p44, p43.Name);
		end;
		return p44;
	end);
end;
local u27 = {};
coroutine.wrap(function()
	local function u28(p45)
		if u27[p45] then
			u27[p45] = u27[p45] + 1;
		else
			u27[p45] = 1;
		end;
		if u27[p45] >= 3 then
			p45:Kick();
		end;
	end;
	coroutine.wrap(function()
		while true do
			wait(1);
			for v224, v225 in pairs(plyrcoindat2) do
				if v225 >= 12 then
					u28(v224);
				end;
			end;
			plyrcoindat2 = {};		
		end;
	end)();
	coroutine.wrap(function()
		while true do
			wait(60);
			u27 = {};		
		end;
	end)();
	game.Players.PlayerRemoving:Connect(function(p46)
		u27[p46] = nil;
		plyrcoindat2[p46] = nil;
	end);
end)();
return v1;
