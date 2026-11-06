-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {
	green = "<font color=\"#5bff3e\">", 
	orange = "<font color=\"#ffbd37\">", 
	pink = "<font color=\"#ff81f9\">"
};
return {
	["Dark Matter"] = {
		title = "Dark Matter", 
		icon = "rbxassetid://9003568230", 
		sort = 44, 
		enabled = false, 
		xpMult = 2, 
		maxLvl = 99, 
		perks = { {
				level = 30, 
				desc = string.format("Conversion time is " .. v1.green .. "%s</font> faster!", "5%")
			}, {
				level = 75, 
				desc = string.format("Conversion time is " .. v1.green .. "%s</font> faster!", "10%")
			}, {
				level = 99, 
				desc = string.format("Conversion time is " .. v1.green .. "%s</font> faster!", "20%")
			} }
	}
};
