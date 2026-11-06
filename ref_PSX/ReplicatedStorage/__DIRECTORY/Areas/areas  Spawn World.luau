return { 
	Shop = {
		id = 3, 
		name = "Mercatello", 
		world = "Spawn", 
		mult = 1, 
		isShop = true, 
		teleportPrice = 25000, 
		hidden = false
	}, 
	Spawn = {
		id = 4, 
		name = "Spawn", 
		world = "Spawn", 
		mult = 1, 
		isShop = false, 
		teleportPrice = 25000, 
		hidden = true
	}, 
	VIP = {
		id = 5, 
		name = "VIP", 
		world = "Spawn", 
		mult = 1, 
		isShop = false, 
		isVIP = true, 
		teleportPrice = 5000, 
		hidden = false
	}, 
	Town = {
		id = 6, 
		name = "Piazzara", 
		world = "Spawn", 
		mult = 1, 
		luckyMult = 0.125, 
		luckyOrder = 1, 
		gate = {
			cost = 0, 
			currency = "Coins"
		}, 
		isShop = false, 
		teleportPrice = 6000, 
		hidden = false
	}, 
	Forest = {
		id = 7, 
		name = "Boscarello", 
		world = "Spawn", 
		mult = 2, 
		luckyMult = 0.25, 
		luckyOrder = 2, 
		gate = {
			cost = 10000, 
			currency = "Coins"
		}, 
		isShop = false, 
		tpIcon = "MachineUpgrade", 
		teleportPrice = 7500, 
		hidden = false
	}, 
	Beach = {
		id = 8, 
		name = "Spiaggina", 
		world = "Spawn", 
		mult = 3.5, 
		luckyMult = 0.375, 
		luckyOrder = 3, 
		gate = {
			cost = 75000, 
			currency = "Coins"
		}, 
		isShop = false, 
		tpIcon = "MachineFuse", 
		teleportPrice = 10000, 
		hidden = false
	}, 
	Mine = {
		id = 9, 
		name = "Minarella", 
		world = "Spawn", 
		mult = 5, 
		luckyMult = 0.5, 
		luckyOrder = 4, 
		gate = {
			cost = 750000, 
			currency = "Coins"
		}, 
		isShop = false, 
		tpIcon = "MachineRainbow", 
		teleportPrice = 12500, 
		hidden = false
	}, 
	Winter = {
		id = 10, 
		name = "Freddolato", 
		world = "Spawn", 
		mult = 6.5, 
		luckyMult = 1, 
		luckyOrder = 5, 
		gate = {
			cost = 100000, 
			currency = "Coins"
		}, 
		isShop = false, 
		teleportPrice = 12500, 
		hidden = false
	}, 
	Glacier = {
		id = 11, 
		name = "Gelattico", 
		world = "Spawn", 
		mult = 8.25, 
		luckyMult = 1.5, 
		luckyOrder = 6, 
		gate = {
			cost = 15000000, 
			currency = "Coins"
		}, 
		isShop = false, 
		teleportPrice = 12500, 
		hidden = false
	}, 
	Desert = {
		id = 12, 
		name = "Sabbione", 
		world = "Spawn", 
		mult = 10, 
		luckyMult = 2, 
		luckyOrder = 7, 
		gate = {
			cost = 200000, 
			currency = "Coins"
		}, 
		isShop = false, 
		teleportPrice = 12500, 
		hidden = false
	}, 
	Volcano = {
		id = 13, 
		name = "Lavotto", 
		world = "Spawn", 
		mult = 11.5, 
		luckyMult = 3, 
		luckyOrder = 8, 
		gate = {
			cost = 5000000, 
			currency = "Coins"
		}, 
		isShop = false, 
		tpIcon = "Chest", 
		teleportPrice = 25000, 
		hidden = false
	}, 
	Cave = {
		id = 14, 
		name = "Cave (Free UGC)", 
		world = "Spawn", 
		mult = 1, 
		gate = {
			cost = 250000000, 
			currency = "Coins"
		}, 
		isShop = false, 
		tpIcon = "Teleport", 
		teleportPrice = 20000, 
		hidden = false
	}, 
	["Ice Tech"] = {
		id = 15, 
		name = "Tech Entry", 
		world = "Spawn", 
		mult = 1, 
		gate = {
			cost = 500000000, 
			currency = "Coins"
		}, 
		isShop = false, 
		tpIcon = "Chest", 
		teleportPrice = 50000, 
		hidden = false
	}
};--[[return {
	Shop = {
		id = 3, 
		name = "Shop",
		displayName = "Mercatello",
		world = "Spawn", 
		mult = 1, 
		isShop = true, 
		teleportPrice = 25000, 
		hidden = false
	}, 
	Spawn = {
		id = 4, 
		name = "Spawn", 
		world = "Spawn", 
		mult = 1, 
		isShop = false, 
		teleportPrice = 25000, 
		hidden = true
	}, 
	VIP = {
		id = 5, 
		name = "VIP", 
		world = "Spawn", 
		mult = 1, 
		isShop = false, 
		isVIP = true, 
		teleportPrice = 5000, 
		hidden = false
	}, 
	Town = {
		id = 6, 
		name = "Twon",
		displayNamer = "Piazzara",
		world = "Spawn", 
		mult = 1, 
		luckyMult = 0.125, 
		luckyOrder = 1, 
		gate = {
			cost = 0, 
			currency = "Coins"
		}, 
		isShop = false, 
		teleportPrice = 6000, 
		hidden = false
	}, 
	Forest = {
		id = 7, 
		name = "Forest", 
		displayName = "Boscarello",
		world = "Spawn", 
		mult = 2, 
		luckyMult = 0.25, 
		luckyOrder = 2, 
		gate = {
			cost = 50000, 
			currency = "Coins"
		}, 
		isShop = false, 
		tpIcon = "MachineUpgrade", 
		teleportPrice = 7500, 
		hidden = false
	}, 
	Beach = {
		id = 8, 
		name = "Spiaggina",
		displayName = "",
		world = "Spawn", 
		mult = 3.5, 
		luckyMult = 0.375, 
		luckyOrder = 3, 
		gate = {
			cost = 75000, 
			currency = "Coins"
		}, 
		isShop = false, 
		tpIcon = "MachineFuse", 
		teleportPrice = 10000, 
		hidden = false
	}, 
	Mine = {
		id = 9, 
		name = "Minarella", 
		displayName = "",
		world = "Spawn", 
		mult = 5, 
		luckyMult = 0.5, 
		luckyOrder = 4, 
		gate = {
			cost = 400000, 
			currency = "Coins"
		}, 
		isShop = false, 
		tpIcon = "MachineRainbow", 
		teleportPrice = 12500, 
		hidden = false
	}, 
	Winter = {
		id = 10, 
		name = "Freddolato", 
		displayName = "",
		world = "Spawn", 
		mult = 6.5, 
		luckyMult = 1, 
		luckyOrder = 5, 
		gate = {
			cost = 1250000, 
			currency = "Coins"
		}, 
		isShop = false, 
		teleportPrice = 12500, 
		hidden = false
	}, 
	Glacier = {
		id = 11, 
		name = "Gelattico", 
		displayName = "",
		world = "Spawn", 
		mult = 8.25, 
		luckyMult = 1.5, 
		luckyOrder = 6, 
		gate = {
			cost = 5500000, 
			currency = "Coins"
		}, 
		isShop = false, 
		teleportPrice = 12500, 
		hidden = false
	}, 
	Desert = {
		id = 12, 
		name = "Sabbione", 
		displayName = "",
		world = "Spawn", 
		mult = 10, 
		luckyMult = 2, 
		luckyOrder = 7, 
		gate = {
			cost = 16500000, 
			currency = "Coins"
		}, 
		isShop = false, 
		teleportPrice = 12500, 
		hidden = false
	}, 
	Volcano = {
		id = 13, 
		name = "Lavotto", 
		displayName = "",
		world = "Spawn", 
		mult = 11.5, 
		luckyMult = 3, 
		luckyOrder = 8, 
		gate = {
			cost = 50000000, 
			currency = "Coins"
		}, 
		isShop = false, 
		tpIcon = "Chest", 
		teleportPrice = 25000, 
		hidden = false
	}, 
	Cave = {
		id = 14, 
		name = "Cave", 
		world = "Spawn", 
		mult = 1, 
		gate = {
			cost = 250000000, 
			currency = "Coins"
		}, 
		isShop = false, 
		tpIcon = "Teleport", 
		teleportPrice = 20000, 
		hidden = false
	}
};
]]