-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {
	green = "<font color=\"#5bff3e\">", 
	orange = "<font color=\"#ffbd37\">", 
	pink = "<font color=\"#ff81f9\">"
};
return {
	["Free Gifts"] = {
		title = "Free Gifts", 
		icon = "rbxassetid://9003556008", 
		sort = 6, 
		enabled = true, 
		xpMult = 2, 
		maxLvl = 99, 
		perks = { {
				level = 30, 
				desc = string.format("Free Gifts have very small extra luck to open a " .. v1.orange .. "%s</font>!", "Huge Brainrot")
			}, {
				level = 75, 
				desc = string.format("Free Gifts have a little more luck to open a " .. v1.orange .. "%s</font>!", "Huge Brainrot")
			}, {
				level = 99, 
				desc = string.format("Free Gifts have even better luck to open a " .. v1.orange .. "%s</font>!", "Huge Brainrot")
			} }
	}
};
