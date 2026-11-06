-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {
	green = "<font color=\"#5bff3e\">", 
	orange = "<font color=\"#ffbd37\">", 
	pink = "<font color=\"#ff81f9\">"
};
return {
	Lootbags = {
		title = "Lootbags", 
		icon = "rbxassetid://74150429809256", 
		sort = 7, 
		enabled = true, 
		xpMult = 1, 
		maxLvl = 99, 
		perks = { {
				level = 15, 
				desc = string.format("Lootbags reward " .. v1.green .. "%s</font> more coins!", "25%")
			}, {
				level = 35, 
				desc = string.format("Better lootbags appear more often!")
			}, {
				level = 50, 
				desc = string.format("Lootbags reward " .. v1.green .. "%s</font> more diamonds!", "35%")
			}, {
				level = 75, 
				desc = string.format("Unlock " .. v1.orange .. "%s</font>!", "Mini Gifts")
			}, {
				level = 99, 
				desc = string.format("Chance to drop " .. v1.pink .. "%s</font> lootbags!", "double")
			} }
	}
};
