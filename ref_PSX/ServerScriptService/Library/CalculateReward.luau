local Library = game:GetService("ReplicatedStorage"):WaitForChild("Library")
local Settings = require(script.Parent.Settings)
local Saving = require(script.Parent.Saving)
local Directory = require(Library.Directory)
local Pets = require(script.Parent.Pets)
local Give = require(script.Parent.Give)
local Shared = require(Library.Shared)
local Mastery = require(script.Parent.Mastery)
local Boosts = require(script.Parent.Boosts)
local Upgrades = require(script.Parent.Upgrades)
local ServerBoosts = require(script.Parent.ServerBoosts)

local RNG = Random.new();

return function(player, p2, p3, p4, p5)
	local v2 = Saving.Get(player);
	if not v2 then
		return;
	end;
	p5 = p5 or {};
	if p3 == "Diamonds" then
		p5.disableScaling = true;
	end;
	if p3 == "Best" then
		if v2["Cartoon Coins"] ~= 0 then
			p3 = "Cartoon Coins";
		elseif v2["Rainbow Coins"] ~= 0 then
			p3 = "Rainbow Coins";
		elseif v2["Tech Coins"] ~= 0 then
			p3 = "Tech Coins";
		elseif v2["Fantasy Coins"] ~= 0 then
			p3 = "Fantasy Coins";
		else
			p3 = "Coins";
		end;
	end;
	
	local v3 = {};
	for v4, v5 in ipairs(p4) do
		local v6, v7 = Pets.Get(v5);
		if v6 and v7 and v7 == player then
			v3[v5] = v6;
		end;
	end;
	
	local v12
	if not p5.avgPetLevel then
		local v8 = 0;
		local v9 = 0;
		for v10, v11 in pairs(v3) do
			v8 = v8 + v11.s;
			v9 = v9 + 1;
		end;
		v12 = v8 / v9;
		if v12 ~= v12 then
			v12 = 0;
		end;
	else
		v12 = p5.avgPetLevel;
	end;
	
    local v13
    if ServerBoosts.IsActive(player, "Triple Coins") and Boosts.Has(player, "Triple Coins") then
        v13 = 6;
    elseif ServerBoosts.IsActive(player, "Triple Coins") then
        v13 = 3
	elseif Boosts.Has(player, "Triple Coins") then
		v13 = 3;
	else
		v13 = 1;
    end;
	
	local v14
	if Settings.DoubleCoinsEvent then
		v14 = 2;
	else
		v14 = 1;
    end;
    
    local dir = Directory.Fruits["Pear"]
    local m = require(script.Parent.Fruit).Get(player, dir) or 0
	local EE=require(script.Parent.Fruit).GetBonus(player, dir)--dir.Bonus(m)
    if tonumber(EE) and EE < 1 and EE > 0 then
        EE = EE + 1
    end

    local dir2 = Directory.Fruits["Orange"]
    local m2 = require(script.Parent.Fruit).Get(player, dir2) or 0
	local EE2=require(script.Parent.Fruit).GetBonus(player, dir2)--dir.Bonus(m2)
    if tonumber(EE2) and EE2 < 1 and EE2 > 0 then
        EE2 = EE2 + 1
    end
    if p3 ~= "Diamonds" then
        if m >= 1 then
            v14 = v14 + ( EE2 or 0 )
        end
    else
        if m2 >= 1 then
            v14 = v14 + ( EE or 0 )
        end
    end
    
	local v15 = math.clamp(v2.FriendsBoost, 1, 10);
	local v16 = Upgrades.Get(player, "Halloween More Candy");
	local u3 = 1 + 0.15 * Upgrades.Get(player, "Halloween More Diamonds") + 0.15 * Upgrades.Get(player, "More Diamonds");
	local u4 = 1;
	
	(function()
		local v17 = 0;
		for v18, v19 in pairs(v3) do
			local v20, v21 = Shared.HasPower(v19, "Diamonds");
			if v20 then
				v17 = v17 + (Shared.GetPowerDir("Diamonds", v21).value - 1);
			end;
		end;
		u3 = u3 + math.min(v17, 5);
	end)();
	
	(function()
		if p5.coinModelName and p5.coinModelName == "Present" then
			local v22 = 0;
			for v23, v24 in pairs(v3) do
				local v25, v26 = Shared.HasPower(v24, "Presents");
				if v25 then
					v22 = v22 + (Shared.GetPowerDir("Presents", v26).value - 1);
				end;
			end;
			u4 = u4 + v22;
		end;
	end)();
	
	(function()
		if p3 == "Coins" or p3 == "Fantasy Coins" or p3 == "Tech Coins" or p3 == "Rainbow Coins" or p3 == "Cartoon Coins" then
			local v27 = 0;
			for v28, v29 in pairs(v3) do
				local v30, v31 = Shared.HasPower(v29, p3);
				if v30 then
					v27 = v27 + (Shared.GetPowerDir(p3, v31).value - 1);
				end;
			end;
			u4 = u4 + v27;
		end;
	end)();
	
	(function()
		local v32 = 0;
		for v33, v34 in pairs(v3) do
			local v35, v36 = Shared.HasPower(v34, "Royalty");
			if v35 then
				v32 = v32 + 1;
			end;
		end;
		u3 = u3 + math.min(v32, 5);
	end)();
	
	(function()
		if p5.coinModelName and string.find(p5.coinModelName, "Chest") then
			if Mastery.HasPerk(player, "Chests", 5) then
				u4 = u4 * 2;
				return;
			end;
			if Mastery.HasPerk(player, "Chests", 4) then
				u4 = u4 * 1.5;
				return;
			end;
			if Mastery.HasPerk(player, "Chests", 2) then
				u4 = u4 * 1.25;
				return;
			end;
			if Mastery.HasPerk(player, "Chests", 1) then
				u4 = u4 * 1.15;
			end;
		end;
	end)();
	
	(function()
		if p5.coinModelName and (p5.coinModelName == "Coins" or p5.coinModelName == "Tiny Coins" or p5.coinModelName == "Large Coins") then
			if Mastery.HasPerk(player, "Coin Piles", 5) then
				u4 = u4 * 3;
				return;
			end;
			if Mastery.HasPerk(player, "Coin Piles", 4) then
				u4 = u4 * 2;
				return;
			end;
			if Mastery.HasPerk(player, "Coin Piles", 2) then
				u4 = u4 * 1.5;
				return;
			end;
			if Mastery.HasPerk(player, "Coin Piles", 1) then
				u4 = u4 * 1.25;
			end;
		end;
	end)();
	
	(function()
		if p5.coinModelName and p5.coinModelName == "Present" then
			if Mastery.HasPerk(player, "Presents", 5) then
				u4 = u4 * 2;
				return;
			end;
			if Mastery.HasPerk(player, "Presents", 4) then
				u4 = u4 * 1.6;
				return;
			end;
			if Mastery.HasPerk(player, "Presents", 2) then
				u4 = u4 * 1.35;
				return;
			end;
			if Mastery.HasPerk(player, "Presents", 1) then
				u4 = u4 * 1.15;
			end;
		end;
	end)();
	
	(function()
		if p5.coinModelName and p5.coinModelName == "Crate" then
			if Mastery.HasPerk(player, "Crates", 5) then
				u4 = u4 * 2.25;
				return;
			end;
			if Mastery.HasPerk(player, "Crates", 4) then
				u4 = u4 * 1.75;
				return;
			end;
			if Mastery.HasPerk(player, "Crates", 2) then
				u4 = u4 * 1.4;
				return;
			end;
			if Mastery.HasPerk(player, "Crates", 1) then
				u4 = u4 * 1.25;
			end;
		end;
	end)();
	
	(function()
		if p5.coinModelName and (p5.coinModelName == "Safe" or p5.coinModelName == "Vault") then
			if Mastery.HasPerk(player, "VaultsAndSafes", 5) then
				u4 = u4 * 2;
				return;
			end;
			if Mastery.HasPerk(player, "VaultsAndSafes", 4) then
				u4 = u4 * 1.6;
				return;
			end;
			if Mastery.HasPerk(player, "VaultsAndSafes", 2) then
				u4 = u4 * 1.35;
				return;
			end;
			if Mastery.HasPerk(player, "VaultsAndSafes", 1) then
				u4 = u4 * 1.15;
			end;
		end;
	end)();
	
	(function()
		if p5.coinModelName and string.find(p5.coinModelName, "Diamonds") then
			if Mastery.HasPerk(player, "Diamond Piles", 4) then
				u4 = u4 * 3;
				return;
			end;
			if Mastery.HasPerk(player, "Diamond Piles", 3) then
				u4 = u4 * 2;
				return;
			end;
			if Mastery.HasPerk(player, "Diamond Piles", 2) then
				u4 = u4 * 1.5;
				return;
			end;
			if Mastery.HasPerk(player, "Diamond Piles", 1) then
				u4 = u4 * 1.2;
			end;
		end;
	end)();
	
	local v37
	if not p5.disableScaling then
		local hardcoreDecrease = Shared.IsHardcore and 10000000000000 or 1
		v37 = math.max(math.round((p2 ^ 0.75 * math.max(math.sqrt(math.max(v12/hardcoreDecrease, 1)), 1)) ^ 0.6), 1);
		local v38 = Directory.Currency[p3].Multiplier or 1
		if v38 then
			v37 = v37 * v38;
		end;
	else
		v37 = RNG:NextInteger(3, 5);
	end;
	
	local v39 = math.max(math.round(v37), 1);
	if p5.coinInfo then
		local v40 = Directory.Coins[p5.coinInfo.name];
		local v41 = p5.coinInfo.breakType == "Break" and v40.orbsBreak or v40.orbsRandom;
		if p3 ~= "Diamonds" then
			if not p5.disableScaling then
				v39 = v39 * (Directory.Areas[p5.coinInfo.area].mult * (v40.totalMult + v41.rewardMult));
			else
				v39 = v39 * (v40.totalMult + v41.rewardMult);
			end;
		else
			v39 = v39 * v40.diamondsMult;
		end;
	end;
	
	if p3 == "Diamonds" then
		v39 = v39 * u3;
	elseif p3 == "Halloween Candy" then
		v39 = v39 ^ 0.45 * Settings.HalloweenCandyMult * (4 + 0.4 * v16);
	elseif p3 == "Gingerbread" then
		v39 = v39 ^ 0.45 * Settings.GingerbreadMult;
	elseif p3 == "Coins" or p3 == "Fantasy Coins" or p3 == "Tech Coins" or p3 == "Rainbow Coins" or p3 == "Cartoon Coins" then
		v39 = v39 * u4;
	end;
	
	if p3 ~= "Diamonds" then
		v39 = v39 * v13 * v14 * v15;
	end;
	
	if v39 ~= v39 then
		v39 = 1;
	end
		
	return math.max(math.round(v39), 1);
end;
