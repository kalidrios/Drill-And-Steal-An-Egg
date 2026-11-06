-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {
	green = "<font color=\"#5bff3e\">", 
	orange = "<font color=\"#ffbd37\">", 
	pink = "<font color=\"#ff81f9\">"
};
return {
	Daycare = {
		title = "Daycare", 
		icon = "rbxassetid://13210223994", 
		sort = -1, 
		enabled = false, 
		xpMult = 1, 
		maxLvl = 99, 
		perks = { {
				level = 15, 
				desc = string.format("Daycare earns " .. v1.green .. "%s</font> more coins!", "10%")
			}, {
				level = 35, 
				desc = string.format("Daycare earns " .. v1.green .. "%s</font> more boosters!", "25%")
			}, {
				level = 50, 
				desc = string.format("Daycare earns " .. v1.orange .. "%s</font> more coins!", "35%")
			}, {
				level = 75, 
				desc = string.format("Daycare earns " .. v1.orange .. "%s</font> more diamonds!", "50%")
			}, {
				level = 99, 
				desc = string.format("Daycare has better luck to get a " .. v1.pink .. "%s</font>!", "Huge Pet")
			} }
	}
};
