-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {
	green = "<font color=\"#5bff3e\">", 
	orange = "<font color=\"#ffbd37\">", 
	pink = "<font color=\"#ff81f9\">"
};
return {
	["Diamond Mine"] = {
		title = "Diamond Mine", 
		icon = "rbxassetid://13210223917", 
		sort = -1, 
		enabled = false, 
		xpMult = 1, 
		maxLvl = 99, 
		perks = { {
				level = 15, 
				desc = string.format(v1.green .. "%s</font> Diamond Mine drops!", "+20%")
			}, {
				level = 35, 
				desc = string.format(v1.green .. "%s</font> Diamond Mine pet damage!", "+40%")
			}, {
				level = 50, 
				desc = string.format(v1.green .. "%s</font> Diamond Mine drops!", "+40%")
			}, {
				level = 75, 
				desc = string.format(v1.orange .. "%s</font> Diamond Mine pet damage!", "+100%")
			}, {
				level = 99, 
				desc = string.format(v1.pink .. "%s</font> Diamond Mine drops!", "+80%")
			} }
	}
};
