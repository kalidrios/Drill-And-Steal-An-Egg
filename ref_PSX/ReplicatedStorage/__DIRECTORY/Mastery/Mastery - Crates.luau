-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {
	green = "<font color=\"#5bff3e\">", 
	orange = "<font color=\"#ffbd37\">", 
	pink = "<font color=\"#ff81f9\">"
};
return {
	Crates = {
		title = "Crates", 
		icon = "rbxassetid://137787746575830", 
		sort = 11, 
		enabled = true, 
		xpMult = 1, 
		maxLvl = 99, 
		perks = { {
				level = 15, 
				desc = string.format("Crates reward " .. v1.green .. "%s</font> more!", "25%")
			}, {
				level = 35, 
				desc = string.format("Crates break " .. v1.green .. "%s</font> faster!", "40%")
			}, {
				level = 50, 
				desc = string.format("Crates drop more " .. v1.orange .. "%s</font>!", "lootbags")
			}, {
				level = 75, 
				desc = string.format("Crates reward " .. v1.green .. "%s</font> more!", "75%")
			}, {
				level = 99, 
				desc = string.format("Crates reward " .. v1.green .. "%s</font> more!", "125%")
			} }
	}
};
