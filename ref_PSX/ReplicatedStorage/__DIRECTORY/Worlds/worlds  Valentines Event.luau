-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

return {
	["Valentines Event"] = {
		display = "Valentine's Event", 
		mainCurrency = "Valentine Hearts", 
		worldOrder = 0, 
		teleportImage = "rbxassetid://115124561425146", 
		disabled = true, 
		requiredArea = nil, 
		hardcoreOnly = false, 
		music = { "rbxassetid://82847320458601" }, 
		ambience = "rbxassetid://85516654667410", 
		ambienceVolume = 0.115, 
		spawns = {
			["Cozy Cove"] = {
				settings = {
					maxCoins = 10, 
					healthMult = 15, 
					area = "Cozy Cove", 
					respawnCooldown = false
				}, 
				coins = { { "Heart Pile", 7 }, { "Heart Present", 3 } }
			}, 
			["Cozy Cove Chest"] = {
				settings = {
					maxCoins = 1, 
					healthMult = 1, 
					area = "Cozy Cove", 
					respawnCooldown = true
				}, 
				coins = { { "Giant Valentines Chest", 100 } }
			}
		}
	}
};
