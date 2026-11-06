-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Modules = Library:WaitForChild("Modules");
local m_Directory = require(Library.Directory);
local _ = require(Modules.Pets);
local table1 = {
	Name = function(p2, p3) -- Name (Line: 21)
		return ("%* %*!"):format(p2, p3);
	end,
	Prefix = "a",
	Color = Color3.fromRGB(122, 122, 122),
	Announce = false
};
local table2 = {
	Basic = table1,
	Rare = {
		Name = function(p4, p5) -- Name (Line: 30)
			return ("%* %*"):format(p4, p5);
		end,
		Prefix = "a",
		Color = Color3.fromRGB(75, 255, 90),
		Announce = false
	},
	Epic = {
		Name = function(p6, p7) -- Name (Line: 36)
			return ("%* %*"):format(p6, p7);
		end,
		Prefix = "an",
		Color = Color3.fromRGB(255, 234, 71),
		Announce = false
	},
	Legendary = {
		Name = function(p8, p9) -- Name (Line: 42)
			return ("%* %*"):format(p8, p9);
		end,
		Prefix = "a",
		Color = Color3.fromRGB(255, 69, 246),
		Announce = false
	},
	Mythical = {
		Name = function(p10, p11) -- Name (Line: 48)
			return ("%* %*"):format(p10:upper(), p11);
		end,
		Prefix = "a",
		Color = Color3.fromRGB(255, 140, 0),
		Announce = true
	},
	Secret = {
		Name = function(p12, p13) -- Name (Line: 54)
			return ("%* %*"):format(p12:upper(), p13);
		end,
		Prefix = "a",
		Color = Color3.fromRGB(34, 34, 34),
		Announce = true
	},
	Event = {
		Name = function(p14, p15) -- Name (Line: 60)
			return ("%* %*"):format(p14:upper(), p15);
		end,
		Prefix = "an",
		Color = Color3.fromRGB(213, 115, 255),
		Announce = true
	},
	Exclusive = {
		Name = function(p16, p17) -- Name (Line: 66)
			return ("%* %*"):format(p16:upper(), p17);
		end,
		Prefix = "an",
		Color = Color3.fromRGB(213, 115, 255),
		Announce = true
	}
};
return function(p1) -- Line: 74
	--[[
		Upvalues:
			[1] = m_Directory
			[2] = table2
			[3] = table1
	--]]
	local v1 = m_Directory.Pets[p1.id];
	local table3 = {};
	if p1.sh then
		table.insert(table3, "Shiny");
	end
	if p1.r then
		table.insert(table3, "Rainbow");
	elseif p1.g then
		table.insert(table3, "Golden");
	end
	local v2 = table.concat(table3, " ");
	if #table3 > 0 then
		v2 = v2 .. " ";
	end
	local v3 = v2 .. v1.name;
	local t_rarity = v1.rarity;
	local v4 = table2[t_rarity] or table1;
	local v5 = v4.Name(t_rarity, v3);
	local format_ret = ("%* %*"):format(v4.Prefix, v5);
	return v5, format_ret, v4.Color, v4.Announce;
end;
