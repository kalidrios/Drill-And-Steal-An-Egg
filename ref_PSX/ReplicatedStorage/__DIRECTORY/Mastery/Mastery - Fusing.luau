-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {
	green = "<font color=\"#5bff3e\">", 
	orange = "<font color=\"#ffbd37\">", 
	pink = "<font color=\"#ff81f9\">"
};
return {
	Fusing = {
		title = "Fusing", 
		icon = "rbxassetid://9003571910", 
		sort = 41, 
		enabled = false, 
		xpMult = 2, 
		maxLvl = 99, 
		perks = { {
				level = 30, 
				desc = string.format("Fusing has " .. v1.green .. "%s</font> chance to make a shiny!", "0.2%")
			}, {
				level = 75, 
				desc = string.format("Fusing has " .. v1.orange .. "%s</font> chance to make a shiny!", "0.5%")
			}, {
				level = 99, 
				desc = string.format("Fusing has " .. v1.pink .. "%s</font> chance to make a shiny!", "1%")
			} }
	}
};
