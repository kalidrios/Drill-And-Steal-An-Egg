-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {
	green = "<font color=\"#5bff3e\">", 
	orange = "<font color=\"#ffbd37\">", 
	pink = "<font color=\"#ff81f9\">"
};
return {
	Presents = {
		title = "Presents", 
		icon = "rbxassetid://99008022324413", 
		sort = 12, 
		enabled = true, 
		xpMult = 1, 
		maxLvl = 99, 
		perks = { {
				level = 15, 
				desc = string.format("Presents reward " .. v1.green .. "%s</font> more!", "15%")
			}, {
				level = 35, 
				desc = string.format("Presents break " .. v1.green .. "%s</font> faster!", "35%")
			}, {
				level = 50, 
				desc = string.format("Presents drop more " .. v1.orange .. "%s</font>!", "lootbags")
			}, {
				level = 75, 
				desc = string.format("Presents reward " .. v1.green .. "%s</font> more!", "60%")
			}, {
				level = 99, 
				desc = string.format("Presents reward " .. v1.green .. "%s</font> more!", "100%")
			} }
	}
};
