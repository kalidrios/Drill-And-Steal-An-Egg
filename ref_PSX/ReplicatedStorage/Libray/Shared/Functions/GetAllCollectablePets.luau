-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local m_Directory = require(ReplicatedStorage:WaitForChild("Library").Directory);
local m_PetInEgg = require(script.Parent.PetInEgg);
local u1 = nil;
return function() -- Line: 22
	--[[
		Upvalues:
			[1] = u1
			[2] = m_Directory
			[3] = m_PetInEgg
	--]]
	local v1 = u1;
	if v1 then
		return v1;
	end
	local table1 = {};
	for key1, val1 in pairs(m_Directory.Pets) do
		if val1.hidden or val1.isGift or val1.rarity ~= "Exclusive" and val1.rarity ~= "Event" and not m_PetInEgg(key1) and not val1.isVanity then continue end
		for index1 = 1, (val1.rarity == "Exclusive" or val1.rarity == "Event") and 1 or 4 do
			table.insert(table1, {
				petId = key1,
				isGolden = index1 == 2,
				isRainbow = index1 == 3,
				isDarkMatter = index1 == 4
			});
		end
	end
	u1 = table1;
	return table1;
end;
