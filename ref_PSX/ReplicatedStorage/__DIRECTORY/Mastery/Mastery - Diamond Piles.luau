-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {
	green = "<font color=\"#5bff3e\">", 
	orange = "<font color=\"#ffbd37\">", 
	pink = "<font color=\"#ff81f9\">"
};
return {
	["Diamond Piles"] = {
		title = "Diamond Piles", 
		icon = "rbxassetid://8990639527", 
		sort = 15, 
		enabled = true, 
		xpMult = 1, 
		maxLvl = 99, 
		perks = { {
				level = 25, 
				desc = string.format("Diamond Piles reward " .. v1.green .. "%s</font> more!", "20%")
			}, {
				level = 50, 
				desc = string.format("Diamond Piles break " .. v1.green .. "%s</font> faster!", "50%")
			}, {
				level = 75, 
				desc = string.format("Diamond Piles reward " .. v1.green .. "%s</font> more!", "100%")
			}, {
				level = 99, 
				desc = string.format("Diamond Piles reward " .. v1.green .. "%s</font> more!", "200%")
			} }
	}
};
