-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local _ = require(Library:WaitForChild("Modules").Daycare);
local m_PetOrderBest = require(script.Parent.PetOrderBest);
local table1 = {
	"Diamonds",
	"Valentine Hearts",
	"Clover Coins",
	"Easter Coins",
	"Gingerbread",
	"Halloween Candy",
	"Cartoon Coins",
	"Fantasy Coins",
	"Tech Coins",
	"Rainbow Coins",
	"Coins"
};
local table2 = {};
for key1, val1 in ipairs(table1) do
	table2[val1] = key1;
end
local table3 = {
	"Triple Damage",
	"Triple Coins",
	"Ultra Lucky",
	"Super Lucky"
};
local table4 = {};
for key2, val2 in ipairs(table3) do
	table4[val2] = key2;
end
local table5 = {
	"Currency",
	"Boost",
	"Pet"
};
local table6 = {};
for key3, val3 in ipairs(table5) do
	table6[val3] = key3;
end
local table7 = {
	Currency = function(p3, p4) -- Line: 61
		--[[
			Upvalues:
				[1] = table2
		--]]
		local v3 = table2[p3.Data];
		local v4 = table2[p4.Data];
		if v3 < v4 then
			return -1;
		end
		if v4 < v3 then
			return 1;
		end
		return 0;
	end,
	Boost = function(p5, p6) -- Line: 67
		--[[
			Upvalues:
				[1] = table4
		--]]
		local v5 = table4[p5.Data];
		local v6 = table4[p6.Data];
		if v5 < v6 then
			return -1;
		end
		if v6 < v5 then
			return 1;
		end
		return 0;
	end,
	Pet = function(p7, p8) -- Line: 73
		--[[
			Upvalues:
				[1] = m_PetOrderBest
		--]]
		return m_PetOrderBest(p7.Data, p8.Data);
	end
};
return function(p1, p2) -- Line: 79
	--[[
		Upvalues:
			[1] = table6
			[2] = table7
	--]]
	local v1 = table6[p1.Category];
	local v2 = table6[p2.Category];
	if v1 < v2 then
		return -1;
	end
	if v2 < v1 then
		return 1;
	end
	return table7[p1.Category](p1, p2);
end;
