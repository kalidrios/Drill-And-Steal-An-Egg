--[[
    UPDATE: huge nerf with diamond mine
--]]

local Library = game:GetService("ReplicatedStorage"):WaitForChild("Library")
local Signal = require(Library.Signal)
local Functions = require(Library.Functions)
local Network = require(game:GetService("ServerScriptService"):WaitForChild("Library").Network)

local Settings = require(script.Parent.Settings)
local Saving = require(script.Parent.Saving)
local Directory = require(Library.Directory)
local Pets = require(script.Parent.Pets)
local Shared = require(Library.Shared)
local Mastery = require(script.Parent.Mastery)
local Boosts = require(script.Parent.Boosts)
local CalculateReward = require(script.Parent.CalculateReward)
local Achievements = require(script.Parent.Achievements)
local Orbs = require(script.Parent.Orbs)

local u2 = {};
local u3 = Random.new();
local u4 = {}
u4 = {
	Claim = function(p1, p2, p3)
		local v1 = Saving.Get(p1);
		if not v1 then
			return;
		end;
		local v2 = u2[p2];
		if not v2 or not p3 or u2[p2].claimed then
			return;
		end;
		if p1 ~= v2.player or v1.World ~= v2.world then
			warn("Lootbag collection may be cheats (" .. p1.Name .. ")");
			return;
		end;
		u2[p2].claimed = true;
		local v3 = Directory.Lootbags[v2.type];
		local v4, v5, v6 = unpack(v2.reward);
		local v7 = u3:NextInteger(unpack(v3.orbs));
		if v4 == "Diamonds" or v4 == "Gingerbread" then
			local v8 = math.max(math.round(v5 / v7), 1);

			if Shared.IsHardcore then
				v8 = v8 / Shared.HardcorePetMult
			else
				v8 = v8
			end

			for v9 = 1, v7 do
				Orbs.Add(p1, p3, v4, v8, {
					BlastRadius = 1.5
				});
				Functions.Wait(u3:NextNumber(0, math.clamp(v9 / 250, 0.02, 0.05)));
			end;
		elseif v4 == "Coins" then
			local v10 = math.max(math.round(v5 / v7), 1);
			for v11 = 1, v7 do
				Orbs.Add(p1, p3, v6, v10, {
					BlastRadius = 1.5
				});
				Functions.Wait(u3:NextNumber(0, math.clamp(v11 / 250, 0.02, 0.05)));
			end;
		elseif v4 == "Boost" then
			Boosts.Give(p1, v6, v5);
		end;
		Achievements.Add(p1, "Lootbags", 1);
		Mastery.Progress(p1, "Lootbags", v3.masteryXP);
		u4.Remove(p2);
		return true;
	end
};
local l__Lootbags__5 = Directory.Lootbags;
local u6 = {};
local l__LootbagCoinsMult__7 = Settings.LootbagCoinsMult;
local l__LootbagDiamondsMult__8 = Settings.LootbagDiamondsMult;
local l__LootbagBoostDrops__9 = Settings.LootbagBoostDrops;
function u4.Add(p4, p5, p6, disableMagnet, disableDiamond)
	local v12 = nil;
	local v13 = Saving.Get(p4);
	if not v13 then
		return;
	end;
	local l__World__14 = Shared.IsHardcore and v13.Hardcore.World or v13.World;
	local v15 = {};
	for v16, v17 in pairs(l__Lootbags__5) do
		local v18 = v17.weight;
		if v18 > 0 and (v16 ~= "Mini Giftbox" or Mastery.HasPerk(p4, "Lootbags", 4)) or (v17.diamondMine and l__World__14=="Diamond Mine") then
			if Mastery.HasPerk(p4, "Lootbags", 2) and v17.isRare then
				v18 = v18 * 1.65;
			end;
			if l__World__14 == "Diamond Mine" and not disableDiamond then
				if v17.diamondMine == true then
					table.insert(v15, { v16, v18 });
				end	
			elseif not v17.diamondMine then
				table.insert(v15, { v16, v18 });
			end
		end;
	end;

	if l__World__14 == "Diamond Mine" then
		for i, v in ipairs(v15) do
			if v[2] == 0 then
				if v[1] == "Diamond Bag Tier 1" then
					v15[i][2] = 95
				elseif v[1] == "Diamond Bag Tier 2" then
					v15[i][2] = 75
				elseif v[1] == "Diamond Bag Tier 3" then
					v15[i][2] = 35
				elseif v[1] == "Diamond Bag Tier 4" then
					v15[i][2] = 10	
				elseif v[1] == "Diamond Bag Tier 5" then
					v15[i][2] = 1 
				end
			end
		end
	end

	local v19 = Functions.Lottery(v15);

	if not Directory.Lootbags[v19] then
		return false
	end
	local v20 = {};
	for v21, v22 in ipairs(Directory.Lootbags[v19].rewards) do
		table.insert(v20, { { v22[1], v22[3] }, v22[2] });
	end;
	local v23, v24 = unpack((Functions.Lottery(v20)));
	local v25 = 1;
	if Mastery.HasPerk(p4, "Lootbags", 1) and v23 == "Coins" then
		v25 = 1.25;
	elseif Mastery.HasPerk(p4, "Lootbags", 3) and v23 == "Diamonds" then
		v25 = 1.35;
	end;
	v12 = Pets.GetEquipped(p4, true);
	local v26 = 0;
	local v27 = nil;
	if v23 == "Coins" then
		local l__mainCurrency__28 = Directory.Worlds[l__World__14].mainCurrency;
		v26 = math.max(math.round(CalculateReward(p4, u6[p4].needed * 10 * 10 * 10, l__mainCurrency__28, v12) * (v24 * (l__LootbagCoinsMult__7 * v25)) * u3:NextNumber(0.8, 1.2)), 1);
		v27 = l__mainCurrency__28;
	elseif v23 == "Diamonds" then
		if l__World__14 == "Diamond Mine" then
			v26 = math.max(math.round(CalculateReward(p4, u6[p4].needed, "Diamonds", v12, {
				disableScaling = true
			}) * v24), 1)
		else
			v26 = math.max(math.round(CalculateReward(p4, u6[p4].needed, "Diamonds", v12, {
				disableScaling = true
			}) * (v24 * (l__LootbagDiamondsMult__8 * v25) * 10 * 10)), 1)
		end
	elseif v23 == "Boost" then
		v26 = 1 * v24;
		v27 = Functions.Lottery(l__LootbagBoostDrops__9);
	elseif v23 == "Gingerbread" then
		v26 = math.max(math.round(CalculateReward(p4, u6[p4].needed, "Gingerbread", v12, {}) * (v24 * l__LootbagCoinsMult__7 * 10 * 10)), 1);
	end;
	local a = 1
	if l__World__14 == "Diamond Mine" and not disableDiamond then
		a = math.random(1,4)
	end
	if a > 1 then
		for i = 1, a do

		end	
	else
		local v29 = Functions.GenerateUID();
		u2[v29] = {
			player = p4, 
			type = v19, 
			world = l__World__14, 
			reward = { v23, v26, v27 }, 
			position = p5, 
			claimed = false,
			disableMagnet = l__World__14 == "Diamond Mine" or false
		};
		Network.Fire("Spawn Lootbag", p4, v29, u2[v29]);
		return v29;
	end
	Signal.Fire("Hacker Portal Progress", p4, 2, 1);
end;
function u4.Remove(p7, p8)
	if u2[p8] then
		u2[p8] = nil;
		Network.Fire("Remove Lootbag", p7, p8);
	end;
end;
function u4.Progress(p9, p10, p11)
	--warn(p9, p10, p11)
	if not u6[p9] then
		UpdateProgressThreshold(p9);
	end;
	local u10 = u6[p9];
	local u11 = p10;
	coroutine.wrap(function()
		for v30 = 0, 20, 1 do
			local test = (u10.needed <= u10.progress + u11)
			if not test then
				break
			end
			u11 = u11 - math.min(u11, u10.needed - u10.progress);
			u10.progress = 0;

			if Mastery.HasPerk(p9, "Lootbags", 5) and u3:NextNumber() <= 0.1 then
				u4.Add(p9, p11);
			end;
			u4.Add(p9, p11);

			if Settings.ChristmasEvent then
				if u3:NextNumber() <= 0.045 then
					Functions.Wait(u3:NextNumber(0, 0.06));
					u4.Add(p9, p11, "Christmas Gift");
				elseif u3:NextNumber() <= 0.4 then
					Functions.Wait(u3:NextNumber(0, 0.06));
					u4.Add(p9, p11, "Christmas Bag");
				end;
			end;

			--print("------------------------")
			UpdateProgressThreshold(p9);
			--print("------------------------")
			Functions.Wait(u3:NextNumber(0, math.min(v30 / 20, 0.15)));
		end
		u10.progress = u10.progress + u11;
	end)();
end;
local l__LootbagProgressDeviation__12 = Settings.LootbagProgressDeviation;
function UpdateProgressThreshold(p12)    
	local v31 = nil;
	local v32 = Pets.GetEquipped(game.Players:GetPlayerByUserId(p12.UserId));
	if not v32 then
		return;
	end;
	local v33 = 0;
	for v37, v38 in ipairs(v32) do
		local stat = Shared.ComputePetStrength(v38)
		if Shared.IsHardcore then
			stat = stat / Shared.HardcorePetMult
		end

		v33 = v33 + stat;	
	end;
	if #v32 < 3 then
		v33 = v33 * (4 - #v32);
	end;
	v31 = v33 * 3 * Settings.LootbagProgressMult * u3:NextNumber(unpack(l__LootbagProgressDeviation__12)) + 30000;
	local save = Saving.Get(game.Players:GetPlayerByUserId(p12.UserId))
	if not save then
		return
	end
	if save.World   == "Diamond Mine" or save.Hardcore.World == "Diamond Mine" then
		v31 = v31 + 10000 -- BAHHAHAHHAH
	end
	if not u6[p12] then
		u6[p12] = {
			needed = v31, 
			progress = 0
		};
		return;
	end;

	u6[p12].needed = v31;
	if v31 <= u6[p12].progress then
		u6[p12].progress = 0;
	end;
end;
function ClearProgress(p13)
	if not u6[p13] then
		u6[p13] = nil;
	end;
end;
game.Players.PlayerRemoving:Connect(function(p14)
	ClearProgress(p14);
end);
Network.Fired("Collect Lootbag"):Connect(function(p15, p16, p17)
	u4.Claim(p15, p16, p17);
end);
Signal.Fired("Player Added"):Connect(function(p18)
	UpdateProgressThreshold(p18);
end);
Signal.Fired("Pet Equipped"):Connect(function(p19, p20)
	UpdateProgressThreshold(p20);
end);
Signal.Fired("Pet Unequipped"):Connect(function(p21, p22)
	UpdateProgressThreshold(p22);
end);
return u4;
