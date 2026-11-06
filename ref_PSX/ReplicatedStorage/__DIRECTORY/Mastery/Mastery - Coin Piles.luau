-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {
	green = "<font color=\"#5bff3e\">", 
	orange = "<font color=\"#ffbd37\">", 
	pink = "<font color=\"#ff81f9\">"
};
return {
	["Coin Piles"] = {
		title = "Coin Piles", 
		icon = "rbxassetid://99731494904294", 
		sort = 10, 
		enabled = true, 
		xpMult = 1, 
		maxLvl = 99, 
		perks = { {
				level = 15, 
				desc = string.format("Coin Piles reward " .. v1.green .. "%s</font> more!", "25%")
			}, {
				level = 35, 
				desc = string.format("Coin Piles break " .. v1.green .. "%s</font> faster!", "50%")
			}, {
				level = 50, 
				desc = string.format("Coin Piles drop more " .. v1.orange .. "%s</font>!", "lootbags")
			}, {
				level = 75, 
				desc = string.format("Coin Piles reward " .. v1.green .. "%s</font> more!", "100%")
			}, {
				level = 99, 
				desc = string.format("Coin Piles reward " .. v1.green .. "%s</font> more!", "200%")
			} }
	}
};
