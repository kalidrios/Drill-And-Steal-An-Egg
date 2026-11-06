-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

return {
	Converting = {
		title = "Converting", 
		icon = "rbxassetid://9003575074", 
		sort = 40, 
		enabled = true, 
		xpMult = 1, 
		maxLvl = 99, 
		perks = { {
				level = 99, 
				desc = string.format("Unlock " .. ({
					green = "<font color=\"#5bff3e\">", 
					orange = "<font color=\"#ffbd37\">", 
					pink = "<font color=\"#ff81f9\">"
				}).orange .. "%s</font>!", "Steampunk Hoverboard")
			} }
	}
};
