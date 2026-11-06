-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {
	green = "<font color=\"#5bff3e\">", 
	orange = "<font color=\"#ffbd37\">", 
	pink = "<font color=\"#ff81f9\">"
};
return {
	Enchanting = {
		title = "Enchanting", 
		icon = "rbxassetid://9003576350", 
		sort = 43, 
		enabled = false, 
		xpMult = 1, 
		maxLvl = 99, 
		perks = { {
				level = 35, 
				desc = string.format("" .. v1.pink .. "%s</font> Enchantments are more common!", "Unique")
			}, {
				level = 75, 
				desc = string.format("" .. v1.pink .. "%s</font> Enchantments are even more common!", "Unique")
			}, {
				level = 99, 
				desc = string.format("Enchantments cost " .. v1.green .. "%s</font> less!", "25%")
			} }
	}
};
