-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {
	green = "<font color=\"#5bff3e\">", 
	orange = "<font color=\"#ffbd37\">", 
	pink = "<font color=\"#ff81f9\">"
};
return {
	Fruits = {
		title = "Fruits", 
		icon = "rbxassetid://13280523436", 
		sort = -1, 
		enabled = false, 
		xpMult = 1, 
		maxLvl = 99, 
		perks = { {
				level = 35, 
				desc = string.format("Fruits last " .. v1.green .. "%s</font> longer!", "20%")
			}, {
				level = 75, 
				desc = string.format("Fruits last " .. v1.green .. "%s</font> longer!", "50%")
			}, {
				level = 99, 
				desc = string.format("Fruits give " .. v1.green .. "%s</font> more multipliers!", "30%")
			} }
	}
};
