-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {
	green = "<font color=\"#5bff3e\">", 
	orange = "<font color=\"#ffbd37\">", 
	pink = "<font color=\"#ff81f9\">"
};
return {
	Boosts = {
		title = "Boosts", 
		icon = "rbxassetid://8997529686", 
		sort = 5, 
		enabled = true, 
		xpMult = 1, 
		maxLvl = 99, 
		perks = { {
				level = 30, 
				desc = string.format("" .. v1.pink .. "%s</font> boost lasts " .. v1.green .. "%s</font> longer!", "Triple Damage", "25%")
			}, {
				level = 50, 
				desc = string.format("" .. v1.pink .. "%s</font> boost lasts " .. v1.green .. "%s</font> longer!", "Triple Coins", "25%")
			}, {
				level = 75, 
				desc = string.format("All boosts last " .. v1.green .. "%s</font> longer!", "25%")
			}, {
				level = 99, 
				desc = string.format("All boosts last " .. v1.green .. "%s</font> longer!", "50%")
			} }
	}
};
