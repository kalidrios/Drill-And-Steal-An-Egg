-- https://github.com/kalidrios

local table1 = {
	Coins = 1,
	Diamonds = 2,
	Damage = 3
};
local table2 = {};
for key1, val1 in pairs(table1) do
	table2[val1] = key1;
end
local table3 = {
	"Diamond Bag Tier 1",
	"Diamond Bag Tier 2",
	"Diamond Bag Tier 3",
	"Diamond Bag Tier 4",
	"Diamond Bag Tier 5"
};
local table4 = {
	MAX_COIN_STAGE = 4,
	SPECIAL_BONUS_TYPES = table1,
	SPECIAL_BONUS_TYPE_NAMES = table2,
	DIAMOND_BAG_TIERS = table3
};
function table4.ComputeCoinStage(p1, p2, p3) -- Line: 178
	--[[
		Upvalues:
			[1] = table4
	--]]
	local v1 = 1;
	if p1.modelHasStages then
		p3 = math.clamp(p3, 0, p2.mh);
		local math_clamp_ret = math.clamp(math.floor((1 - p3 / p2.mh) * (table4.MAX_COIN_STAGE - 1)) + 1, 1, table4.MAX_COIN_STAGE);
		return math_clamp_ret;
	end
	if p3 <= 0 then
		v1 = table4.MAX_COIN_STAGE;
	end
	return v1;
end
function table4.CalcSpecialBonusMultiplier(b, rewType)  
	local v2 = 0;
    local bool1 = false;
    
    for _, val2 in ipairs(b.l) do
        if val2.t ~= rewType then
            continue
        end
        
        v2 = v2 + val2.m;
        
		bool1 = true;
    end
    
	if bool1 then
		return v2;
    end
    
	return nil;
end
function table4.CalcSpecialBonusCurrencyMultiplier(p6, p7) -- Line: 213
	--[[
		Upvalues:
			[1] = table4
			[2] = table1
	--]]
	return table4.CalcSpecialBonusMultiplier(p6, p7 == "Diamonds" and table1.Diamonds or table1.Coins);
end
return table4;
