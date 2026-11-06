-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {
	green = "<font color=\"#5bff3e\">", 
	orange = "<font color=\"#ffbd37\">", 
	pink = "<font color=\"#ff81f9\">"
};
return {
	["Golden Eggs"] = {
		title = "Golden Boxes", 
		icon = "rbxassetid://130459608039028", 
		sort = 1, 
		enabled = true, 
		xpMult = 1, 
		maxLvl = 99, 
		perks = { {
				level = 15, 
				desc = "Better luck!"
			}, {
				level = 35, 
				desc = string.format("" .. v1.green .. "%s</font> cheaper golden boxes!", "5%")
			}, {
				level = 50, 
				desc = "Even better luck!"
			}, {
				level = 75, 
				desc = string.format("" .. v1.green .. "%s</font> cheaper golden boxes!", "15%")
			}, {
				level = 99, 
				desc = string.format("Chance to open " .. v1.orange .. "%s</font>!", "Rainbow Braints")
			} }
	}
};
