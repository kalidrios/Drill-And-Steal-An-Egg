-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {
	green = "<font color=\"#5bff3e\">", 
	orange = "<font color=\"#ffbd37\">", 
	pink = "<font color=\"#ff81f9\">"
};
return {
	Chests = {
		title = "Chests", 
		icon = "rbxassetid://8990634176", 
		sort = 14, 
		enabled = true, 
		xpMult = 1, 
		maxLvl = 99, 
		perks = { {
				level = 15, 
				desc = string.format("Chests reward " .. v1.green .. "%s</font> more!", "15%")
			}, {
				level = 35, 
				desc = string.format("Chests break " .. v1.green .. "%s</font> faster!", "25%")
			}, {
				level = 50, 
				desc = string.format("Chests drop more " .. v1.orange .. "%s</font>!", "lootbags")
			}, {
				level = 75, 
				desc = string.format("Chests reward " .. v1.green .. "%s</font> more!", "50%")
			}, {
				level = 99, 
				desc = string.format("Chests reward " .. v1.green .. "%s</font> more!", "100%")
			} }
	}
};
