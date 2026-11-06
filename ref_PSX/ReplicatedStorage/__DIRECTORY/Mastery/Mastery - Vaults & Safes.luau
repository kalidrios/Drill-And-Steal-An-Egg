-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {
	green = "<font color=\"#5bff3e\">", 
	orange = "<font color=\"#ffbd37\">", 
	pink = "<font color=\"#ff81f9\">"
};
return {
	VaultsAndSafes = {
		title = "Vaults & Safes", 
		icon = "rbxassetid://8990634777", 
		sort = 13, 
		enabled = true, 
		xpMult = 1, 
		maxLvl = 99, 
		perks = { {
				level = 15, 
				desc = string.format("Vaults & Safes reward " .. v1.green .. "%s</font> more!", "15%")
			}, {
				level = 35, 
				desc = string.format("Vaults & Safes break " .. v1.green .. "%s</font> faster!", "35%")
			}, {
				level = 50, 
				desc = string.format("Vaults & Safes drop more " .. v1.orange .. "%s</font>!", "lootbags")
			}, {
				level = 75, 
				desc = string.format("Vaults & Safes reward " .. v1.green .. "%s</font> more!", "60%")
			}, {
				level = 99, 
				desc = string.format("Vaults & Safes reward " .. v1.green .. "%s</font> more!", "100%")
			} }
	}
};
