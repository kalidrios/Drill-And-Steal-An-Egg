-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Modules = Library:WaitForChild("Modules");
local m_Directory = require(Library.Directory);
local _ = require(Modules.Pets);

local table2 = {
	Basic = {
		Message = function(p3, p4, p5)  
			return ("%* oppened a %* %*!"):format(p3, p4, p5);
		end,
		Color = Color3.fromRGB(122, 122, 122),
		Announce = false
	},
	Rare = {
		Message = function(p6, p7, p8) 
			return ("%* oppened a %* %*!"):format(p6, p7, p8);
		end,
		Color = Color3.fromRGB(75, 255, 90),
		Announce = false
	},
	Epic = {
		Message = function(p9, p10, p11)  
			return ("%* oppened an %* %*!"):format(p9, p10, p11);
		end,
		Color = Color3.fromRGB(255, 234, 71),
		Announce = false
	},
	Legendary = {
		Message = function(p12, p13, p14)
			return ("%* oppened a %* %*!"):format(p12, p13, p14);
		end,
		Color = Color3.fromRGB(255, 69, 246),
		Announce = false
	},
	Mythical = {
		Message = function(p15, p16, p17)  
			return ("WOW! %* oppened a %* %*!"):format(p15, p16:upper(), p17);
		end,
		Color = Color3.fromRGB(255, 140, 0),
		Announce = true
	},
	Secret = {
		Message = function(p18, p19, p20) 
			return ("OMG! %* oppened a %* %*!"):format(p18, p19:upper(), p20);
		end,
		Color = Color3.fromRGB(34, 34, 34),
		Announce = true
	},
	Event = {
		Message = function(p21, p22, p23)  
			return ("Nice! %* oppened an %* %*!"):format(p21, p22:upper(), p23);
		end,
		Color = Color3.fromRGB(213, 115, 255),
		Announce = true
	},
	Exclusive = {
		Message = function(p24, p25, p26)  
			return ("%* oppened an %* %*! CONGRATS!"):format(p24, p25:upper(), p26);
		end,
		Color = Color3.fromRGB(213, 115, 255),
		Announce = true
	}
};
return function(p1, p2) 
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
	local t_DisplayName = p2.DisplayName;
	local t_rarity = v1.rarity;
	local v4 = table2[t_rarity] or table2["Basic"];
	return v4.Message(t_DisplayName, t_rarity, v3), v4.Color, v4.Announce;
end;

 