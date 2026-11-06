--------|     Setting     |--------
local fusingMasteryRate = 70
local goldMasteryRate = 15
local rainbowMasteryRate = 30  
local darkMatterMaseryRate = {convert = 300, redeem = 700} 
local enchantingMasteryRate = 35  
local daycareMaseryRate = 250 -- guessed ngl
local FuseDecrease = 1.35
local MachineDelay = 2.5

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Library")) _L.Load()

--------|    Reference    |--------

--------|    Variables    |--------
local RNG = Random.new()

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


function purchase(plr, cost)
	local s= _L.Saving.Get(plr)
	if s then s.Diamonds -= cost end
end


-- gold machine
_L.Network.Invoked("Use Golden Machine").OnInvoke = function(plyr, pets)
	if not _L.Shared.ValidateInteractable(plyr, "Gold Machine", 100) then
		return false, "You're too far from the machine!"
	end

	local save = _L.Saving.Get(plyr)
	if not save then
		return
	end

	local hc = false
	local petId = nil

	for i, v in pairs(pets) do
		local pet, owner = _L.Pets.Get(v)
		if not pet or not pet.uid then
			return
		end

		hc = pet.hc == true or false

		local dir = _L.Directory.Pets[pet.id]
		if not dir or ( dir.rarity == "Event" or dir.rarity == "Exclusive" ) then
			return
		end

		if pet.g or pet.r or pet.dm then
			return nil, "Pet is already golden??"
		end

		if not petId then
			petId = pet.id
		else
			if petId ~= pet.id then
				return
			end
		end	
	end

	if not petId then
		return
	end

	local machineOdds = hc and _L.Shared.GoldMachineOdds.Hardcore or _L.Shared.GoldMachineOdds.Normal
	if not machineOdds then
		return
	end

	local machineData = machineOdds[math.min(#pets, #machineOdds)]
	if not machineData then
		return
	end

	local machineCost = machineData.cost

	if machineCost > save.Diamonds then
		return false, "You need " .. _L.Functions.Commas(machineCost - save.Diamonds) .. " more Diamonds!"
	end

	if #save.Pets >= save.MaxSlots then
		return false, "You dont have enough inventory space!"
	end

	if #save.Pets - #pets <= 0 then
		return false, "You need at least one pet in your inventory!"
	end

	local shinyChance = 2
	local shinyAdding = 100 / #pets
	for i, v in pairs(pets) do
		local pet, owner = _L.Pets.Get(v)
		if not pet then
			return 
		end

		if pet.id ~= petId then
			return
		end

		if pet.sh then
			shinyChance = shinyChance + shinyAdding
		end

		_L.Pets.Delete(pet.uid)
	end
	
	purchase(plyr, machineCost)

	local machineChance = RNG:NextInteger(1, 100) <= machineData.chance

	coroutine.wrap(function()
		_L.Network.FireAll("Using Golden Machine", false, machineChance)
	end)()
	
	-- dramatic wait...
	task.wait(MachineDelay)

	local petDir = _L.Directory.Pets[petId]

	local masteryAdding = goldMasteryRate * #pets
	_L.Mastery.Progress(plyr, "Converting", masteryAdding)

	local isShiny = shinyChance >= RNG:NextNumber(75, 100)
	if machineChance then
		_L.Pets.Create(plyr, petId, {
			g = true,
			hc = hc == true or false,
			sh = isShiny == true or false
		})

		if machineData.chance == 13 then
			if petDir.rarity == "Legendary" then
				_L.Achievements.Add(plyr, "Golden Machine All In", 1)
			else
				_L.Achievements.Add(plyr, "Golden Machine Lucky", 1)
			end
		end	

		_L.Achievements.Add(plyr, "Golden Machine Success", 1)

		return true 
	else
		if machineData.chance == 88 then
			_L.Achievements.Add(plyr, "Golden Machine Unlucky", 1)
		end
		return false, "Failed 😢"
	end
end

-- rainbow machine
_L.Network.Invoked("Use Rainbow Machine").OnInvoke = function(plyr, pets)
	if not _L.Shared.ValidateInteractable(plyr, "Rainbow Machine", 100) then
		return false, "You're too far from the machine!"
	end

	local save = _L.Saving.Get(plyr)
	if not save then
		return
	end

	local hc = false
	local petId = nil

	for i, v in pairs(pets) do
		local pet, owner = _L.Pets.Get(v)
		if not pet or not pet.uid then
			return
		end

		hc = pet.hc == true or false

		local dir = _L.Directory.Pets[pet.id]
		if not dir or ( dir.rarity == "Event" or dir.rarity == "Exclusive" ) then
			return
		end

		if not pet.g or pet.r or pet.dm then
			return nil, "Pet is already rainbow??"
		end

		if not petId then
			petId = pet.id
		else
			if petId ~= pet.id then
				return
			end
		end	
	end

	if not petId then
		return
	end

	local machineOdds = hc and _L.Shared.RainbowMachineOdds.Hardcore or _L.Shared.RainbowMachineOdds.Normal
	if not machineOdds then
		return
	end

	local machineData = machineOdds[math.min(#pets, #machineOdds)]
	if not machineData then
		return
	end

	local machineCost = machineData.cost

	if machineCost > save.Diamonds then
		return false, "You need " .. _L.Functions.Commas(machineCost - save.Diamonds) .. " more Diamonds!"
	end

	if #save.Pets >= save.MaxSlots then
		return false, "You dont have enough inventory space!"
	end

	if #save.Pets - #pets <= 0 then
		return false, "You need at least one pet in your inventory!"
	end

	local shinyChance = 2
	local shinyAdding = 100 / #pets
	for i, v in pairs(pets) do
		local pet, owner = _L.Pets.Get(v)
		if not pet then
			return 
		end

		if pet.id ~= petId then
			return
		end

		if pet.sh then
			shinyChance = shinyChance + shinyAdding
		end

		_L.Pets.Delete(pet.uid)
	end
	
	purchase(plyr, machineCost)

	local machineChance = RNG:NextInteger(1, 100) <= machineData.chance

	coroutine.wrap(function()
		_L.Network.FireAll("Using Rainbow Machine", false, machineChance)
	end)()
	
	-- dramatic wait...
	task.wait(MachineDelay)

	local petDir = _L.Directory.Pets[petId]

	local isShiny = shinyChance >= RNG:NextNumber(75, 100)

	local masteryAdding = rainbowMasteryRate * #pets
	_L.Mastery.Progress(plyr, "Converting", masteryAdding)
	
	if machineChance then
		_L.Pets.Create(plyr, petId, {
			r = true,
			hc = hc == true or false,
			sh = isShiny == true or false
		})

		if machineData.chance == 13 then
			if petDir.rarity == "Legendary" then
				_L.Achievements.Add(plyr, "Rainbow Machine All In", 1)
			end
		end	

		_L.Achievements.Add(plyr, "Golden Machine Success", 1)

		return true 
	else
		return false, "Failed 😢"
	end
end

-- darkmatter machine
local osTable = {}
_L.Network.Invoked("Convert To Dark Matter").OnInvoke = function(plyr, pets)
	if not _L.Shared.ValidateInteractable(plyr, "Dark Matter Machine", 100) then
		return false, "You're too far from the machine!"
	end

	local save = _L.Saving.Get(plyr)
	if not save then
		return
	end

	if osTable[plyr] and os.clock() - osTable[plyr] < 2 then
		return false, "You're trying this too fast!"
	end

	osTable[plyr] = os.clock()

	local dmQueueLength = _L.Functions.DictionaryLength(save.DarkMatterQueue)
	local dmMaxSlots = save.DarkMatterSlots

	if dmQueueLength >= dmMaxSlots then
		return false, "You do not have enough space!"
	end

	local hc = false
	local petId = nil

	for i, v in pairs(pets) do
		local pet, owner = _L.Pets.Get(v)
		if not pet or not pet.uid then
			return
		end

		hc = pet.hc == true or false

		local dir = _L.Directory.Pets[pet.id]
		if not dir or ( dir.rarity == "Event" or dir.rarity == "Exclusive" ) then
			return
		end

		if not pet.r or pet.g or pet.dm then
			return nil, "Pet is already dm??"
		end

		if not petId then
			petId = pet.id
		else
			if petId ~= pet.id then
				return
			end
		end	
	end

	if not petId then
		return
	end

	local machineOdds = hc and _L.Shared.DarkMatterMachineSettings.Hardcore or _L.Shared.DarkMatterMachineSettings.Normal
	if not machineOdds then
		return
	end

	local machineData = machineOdds[math.min(#pets, #machineOdds)]
	if not machineData then
		return
	end

	local machineCost = machineData.cost

	if machineCost > save.Diamonds then
		return false, "You need " .. _L.Functions.Commas(machineCost - save.Diamonds) .. " more Diamonds!"
	end

	if #save.Pets >= save.MaxSlots then
		return false, "You dont have enough inventory space!"
	end

	if #save.Pets - #pets <= 0 then
		return false, "You need at least one pet in your inventory!"
	end

	local shinyChance = 2
	local shinyAdding = 100 / #pets
	for i, v in pairs(pets) do
		local pet, owner = _L.Pets.Get(v)
		if not pet then
			return 
		end

		if pet.id ~= petId then
			return
		end

		if pet.sh then
			shinyChance = shinyChance + shinyAdding
		end

		_L.Pets.Delete(pet.uid)
	end
	
	purchase(plyr, machineCost)
	
	coroutine.wrap(function()
		_L.Network.FireAll("Dark Matter Machine Used", false)
	end)()
	
	local petDir = _L.Directory.Pets[petId]
	local isShiny = shinyChance >= RNG:NextNumber(75, 100)
	local waitTime = machineData.waitTime

	if _L.Mastery.HasPerk(plyr, "Dark Matter", 3) then
		waitTime = waitTime - ( waitTime * 0.20 )
	elseif _L.Mastery.HasPerk(plyr, "Dark Matter", 2) then
		waitTime = waitTime - ( waitTime * 0.10 )
	elseif _L.Mastery.HasPerk(plyr, "Dark Matter", 1) then
		waitTime = waitTime - ( waitTime * 0.05 )
	end

	_L.Mastery.Progress(plyr,"Dark Matter",darkMatterMaseryRate.convert*#pets)

	save.DarkMatterQueue[dmQueueLength + 1] = {
		readyTime = os.time() + waitTime,
		petId = petId,
		hardcore = hc,
		shiny = isShiny
	}

	return true 
end

_L.Network.Invoked("Redeem Dark Matter Pet").OnInvoke = function(plyr, id)
	if not _L.Shared.ValidateInteractable(plyr, "Dark Matter Machine", 100) then
		return false, "You're too far from the machine!"
	end

	local save = _L.Saving.Get(plyr)
	if not save then
		return
	end

	local dmData = save.DarkMatterQueue[id]
	if not dmData then
		return nil, "???"
	end

	if #save.Pets + 1 > save.MaxSlots then
		return false, "Please clear up some inventory space!"
	end

	if not ( dmData.readyTime and os.time() >= dmData.readyTime ) then
		return false, "Pet isnt ready yet!"
	end

	_L.Pets.Create(plyr, dmData.petId, {
		dm = true,
		sh = dmData.shiny == true,
		hc = dmData.hardcore == true
	})

	save.DarkMatterQueue[id] = nil

	_L.Achievements.Add(plyr, "Create Dark Matter", 1)
	_L.Mastery.Progress(plyr, "Dark Matter", darkMatterMaseryRate.redeem)
	
	coroutine.wrap(function()
		_L.Network.FireAll("Dark Matter Machine Redeemed", false)
	end)()	

	return true
end

_L.Network.Invoked("Prompt Dark Matter Skip").OnInvoke = function(plyr, id)
	return false, "."
end

_L.Signal.Invoked("Instant Dark Matter Pet").OnInvoke = function()
	return false, "."
end

_L.Signal.Invoked("Get Dark Matter Pet From Product").OnInvoke = function()
	return nil
end

-- huge machine
_L.Network.Invoked("Buy Huge Machine").OnInvoke = function(plyr)
	local save = _L.Saving.Get(plyr)
	if not save then
		return
	end

	if save.OwnsHugeMachine then
		return
	end

	local cost = 10_000_000

	if save.Diamonds >= cost then
		purchase(plyr, cost)
		save.OwnsHugeMachine = true
		return true
	else
		return false, "You need " .. _L.Functions.Commas(cost - save.Diamonds) .. " more Diamonds!"
	end
end

local PRODUCTCACHE = {}
_L.Network.Invoked("Attempt Use Huge Machine").OnInvoke = function(plyr, pets)
	if not _L.Shared.ValidateInteractable(plyr, "Huge Machine", 100) then
		return false, "You're too far from the machine!"
	end

	if not _L.Pets.Get(pets[1]) then
		return nil
	end

	local save = _L.Saving.Get(plyr)
	if not save then
		return
	end

	local points = 0
	local isFree = false

	_G.ProcessPending(plyr, false)
	for i, v in pairs(pets) do
		local pet, owner = _L.Pets.Get(v)
		if not pet or owner ~= plyr then
			_G.ProcessPending(plyr, true)
			return
		end

		local dir = _L.Directory.Pets[pet.id]
		if not dir then
			_G.ProcessPending(plyr, true)
			return
		end

		local add = ( _L.Shared.ComputeHugeMachinePoints(pet, dir) or 0 )
		points = points + tonumber(add)
	end

	local tier = 0
	local dir = _L.Shared.HugeMachineUseProducts

	if points >= dir[1].pointsMin and points <= dir[1].pointsMax then
		tier = 1	
	end

	if points >= dir[2].pointsMin and points <= dir[2].pointsMax then
		tier = 2	
	end

	if points >= dir[3].pointsMin and points <= dir[3].pointsMax then
		tier = 3	
	end

	if tier == 0 then
		_G.ProcessPending(plyr, true)
		return false, "Insufficient points!"
	end

	isFree = tier == 3

	PRODUCTCACHE[plyr.UserId] = pets
	if not isFree then
		_G.ProcessPending(plyr, true)
		return true, nil, dir[tier].productId
	else
		for i, v in pairs(pets) do
			_L.Pets.Delete(v)
		end
		PRODUCTCACHE[plyr.UserId] = nil

		coroutine.wrap(function()
			_L.Network.FireAll("Using Huge Machine", plyr)
		end)()
		
		-- dramatic wait...
		task.wait(MachineDelay)

		_L.Pets.Create(plyr, "1019")
		_L.Network.Fire("Notification", plyr, "(x1) Huge Machine Egg added to inventory!", { color = Color3.fromRGB(221, 85, 255) })

		_G.ProcessPending(plyr, true)
		return true
	end
end

_L.Signal.Invoked("Huge Machine Redeem").OnInvoke = function(plyr, productId)
	print(plyr,productId,PRODUCTCACHE)
	local save = _L.Saving.Get(plyr)
	if not save then
		return
	end

	if not PRODUCTCACHE[plyr.UserId] then
		print('failed to get player cache')
		return  
	end

	for i, v in pairs(PRODUCTCACHE[plyr.UserId]) do
		_L.Pets.Delete(v)
	end
	PRODUCTCACHE[plyr.UserId] = nil

	coroutine.wrap(function()
		_L.Network.FireAll("Using Huge Machine", plyr)
	end)()
	
	-- dramatic wait...
	task.wait(MachineDelay)

	_L.Pets.Create(plyr, "1019")
	_L.Network.Fire("Notification", plyr, "(x1) Huge Machine Egg added to inventory!", { color = Color3.fromRGB(221, 85, 255) })

	return true
end

-- enchant machine
_L.Network.Invoked("Enchant Pets").OnInvoke = function(plyr, pets)
	local save = _L.Saving.Get(plyr)
	if not save then 
		return 
	end

	local DISCOUNT = 1
	if _L.Mastery.HasPerk(plyr, "Enchanting",3)then DISCOUNT = 0.80 end
	local cost = (_L.Shared.EnchantCost * #pets) * DISCOUNT

	if save.Diamonds < cost then
		return false, "You need " .. _L.Functions.Commas(cost - save.Diamonds) .. " more Diamonds!"
	end

	for i, v in ipairs(pets) do
		local pet, owner = _L.Pets.Get(v)
		if not pet.uid or owner ~= plyr then 
			return false, "error" 
		end

		local dir = _L.Directory.Pets[pet.id]
		if not dir then
			return false, "error" 
		end

		if dir.rarity == "Exclusive" or dir.rarity == "Event" or dir.rarity == "Mythical" or dir.rarity == "Secret" then
			return false, "error"
		end

		local powers = _L.Pets.RollPowers()
		if not powers then
			return false, "error"
		end

		pet.powers = powers
		
		coroutine.wrap(function()
			_L.Network.FireAll("Enchanted Pets", pet.uid, powers or {})
		end)()	
	end    

	purchase(plyr, cost)
	_L.Achievements.Add(plyr, "Enchanting", 1)
	_L.Mastery.Progress(plyr, "Enchanting", enchantingMasteryRate*#pets)
	return true
end

-- collection
_L.Network.Invoked("Redeem Pet Collection").OnInvoke = function(plyr)
	local save = _L.Saving.Get(plyr)
	if not save then
		return
	end

	if save.CollectionTier == #_L.Shared.PetCollectionTiers then    
		return false
	end

	local t = _L.Shared.PetCollectionTiers[save.CollectionTier + 1]
	if #save.Collection >= t then
		save.CollectionTier = save.CollectionTier + 1
		save.MaxEquipped = save.MaxEquipped + 1
		
		coroutine.wrap(function()
			_L.Network.FireAll("Chat Msg", plyr.Name.." increased their Pet Collection to Tier "..save.CollectionTier.."!", Color3.fromRGB(144, 213, 255))
		end)()
		return true
	end

	return nil
end

_L.Signal.Fired("Pet Added"):Connect(function(plyr, id)
	local save = _L.Saving.Get(plyr)
	if save then
		local pet, owner = _L.Pets.Get(id)
		if pet and pet.id and owner == plyr then
			local rar = pet.dm and "4" or pet.r and "3" or pet.g and "2" or "1"
			local string = pet.id .. "-" .. rar

			if _L.Functions.SearchArray(save.Collection, string) then
				return
			end

			table.insert(save.Collection, string)
		end
	end
end)

-- daycare

local function calculateRewards(type, petdata, reward)
	if type == "Currency" then
		local currencyData = { -- keep this in here or else duping currency :skull:
			["Diamonds"] = {
				Min = 19800,
				Max = 1960000
			},
			["Coins"] = {
				Min = 44000,
				Max = 4360000
			},
			["Fantasy Coins"] = {
				Min = 44000,
				Max = 4360000
			},
			["Tech Coins"] = {
				Min = 44000,
				Max = 4360000
			},
			["Rainbow Coins"] = {
				Min = 44000,
				Max = 4360000
			},
			["Cartoon Coins"] = {
				Min = 44000,
				Max = 4360000
			}
		}

		local packedData = currencyData[reward] or { Min = 1, Max = 1 }

		local l = math.ceil(math.log10(petdata.s))
		if not l or l == 0 then
			l = 1
		end
		l = l * 2.5

		packedData.Min = packedData.Min * l
		packedData.Max = packedData.Max * l

		local mult = petdata.dm and 1.25 or petdata.r and 1.175 or petdata.g and 1.1 or 1
		if petdata.sh then
			mult = mult + 0.045
		end

		packedData.Min = packedData.Min * mult
		packedData.Max = packedData.Max * mult

		return packedData
	elseif type == "Boosts" then
		local packedData = { 
			["Triple Coins"]   =    2,
			["Triple Damage"]  =    2,
			["Ultra Lucky"]    =    1,
			["Super Lucky"]    =    3
		}

		local l = math.ceil(math.log10(petdata.s))
		if not l or l == 0 then
			l = 1
		end
		l = l * 1.50

		packedData["Triple Coins"] = packedData["Triple Coins"] * l
		packedData["Triple Damage"] = packedData["Triple Damage"] * l
		packedData["Super Lucky"] = packedData["Super Lucky"] * l
		packedData["Ultra Lucky"] = packedData["Ultra Lucky"] * l


		local mult = petdata.dm and 1.25 or petdata.r and 1.175 or petdata.g and 1.1 or 1
		if petdata.sh then
			mult = mult + 0.045
		end

		packedData["Triple Coins"] = packedData["Triple Coins"] * mult
		packedData["Triple Damage"] = packedData["Triple Damage"] * mult
		packedData["Super Lucky"] = packedData["Super Lucky"] * mult
		packedData["Ultra Lucky"] = packedData["Ultra Lucky"] * mult

		return packedData
	end
end

local function getWorldsCurrency(plyr)
	local save = _L.Saving.Get(plyr)
	if not save then
		return "Coins"
	end

	local areasUnlocked = _L.Shared.IsHardcore and save.Hardcore.AreasUnlocked or save.AreasUnlocked

	if table.find(areasUnlocked, "Cat Kingdom") then
		return "Cartoon Coins"
	elseif table.find(areasUnlocked, "The Void") then
		return "Rainbow Conis"
	elseif table.find(areasUnlocked, "Ice Tech") then
		return "Tech Coins"
	elseif table.find(areasUnlocked, "Cave") then
		return "Fantasy Coins"
	else
		return "Coins"
	end
end

_L.Network.Invoked("Daycare: Compute Loot").OnInvoke = function(plyr, pets)
	local rewards = {}

	if not _L.Shared.ValidateInteractable(plyr, "Daycare", 100) then
		return false, "You're too far from the Daycare!"
	end

	local save = _L.Saving.Get(plyr)
	if not save then
		return -- ?????
	end

	local function packLoot(c)
		for i, v in pairs(pets) do
			if not _L.Shared.ValidateInteractable(plyr, "Daycare", 100) then
				return false, "You're too far from the Daycare!"
			end

			local pet, owner = _L.Pets.Get(v)
			if not pet or owner ~= plyr then
				return
			end

			if c == "Currency" then
				local mainCurr = getWorldsCurrency(plyr) or "Coins"            
				local calcuDmds = calculateRewards("Currency", pet, "Diamonds")
				local calcuWrldCurr = calculateRewards("Currency", pet, mainCurr) 

				if not rewards["diamonds"] then
					rewards["diamonds"] = { Min = calcuDmds.Min, Max = calcuDmds.Max, Data = "Diamonds", Category = "Currency" }
				else
					rewards["diamonds"].Min = rewards["diamonds"].Min + calcuDmds.Min
					rewards["diamonds"].Max = rewards["diamonds"].Max + calcuDmds.Max
				end

				if not rewards["mainCurr"] then
					rewards["mainCurr"] = { Min = calcuWrldCurr.Min,  Max = calcuWrldCurr.Max, Data = mainCurr, Category = "Currency" }
				else
					rewards["mainCurr"].Min = rewards["mainCurr"].Min + calcuWrldCurr.Min
					rewards["mainCurr"].Max = rewards["mainCurr"].Max + calcuWrldCurr.Max
				end
			elseif c == "Boost" then
				local packedCurr = calculateRewards("Boosts", pet, nil)   

				for i, v in ipairs({"Triple Coins", "Triple Damage", "Super Lucky", "Ultra Lucky"}) do
					if not rewards[v] then
						rewards[v] = { Min = packedCurr[v],  Max = packedCurr[v], Data = v, Category = "Boost" }
					else
						rewards[v].Min = rewards[v].Min + packedCurr[v]
						rewards[v].Max = rewards[v].Max + packedCurr[v]
					end
				end
			elseif c == "Pet" then
				rewards["pet-1"] = { Data = { id = "2076" }, Min = 0, Max = 0, Category = "Pet" }
				rewards["pet-2"] = { Data = { id = "1019" }, Min = 0, Max = 0, Category = "Pet" }
			end
		end
	end

	packLoot("Currency")
	packLoot("Boost")
	packLoot("Pet")

	local tbl = TableToArray(rewards)
	table.sort(tbl, function(i, v)
		return i.Max > v.Max
	end)

	return tbl 
end

_L.Network.Invoked("Daycare: Enroll").OnInvoke = function(plyr, pets)
	if not _L.Shared.ValidateInteractable(plyr, "Daycare", 100) then
		return false, "You're too far from the Daycare!"
	end

	local save = _L.Saving.Get(plyr)
	if not save then
		return
	end

	local queue = _L.Shared.IsHardcore and save.DaycareHardcoreQueue or save.DaycareQueue
	if not queue then
		return
	end

	if #save.Pets - #pets < 1 then
		return false, "You need atleast 1 pet in your inventory at all times!"
	end

	if #queue + #pets > 10 then
		return false, "no space"
	end

	for i, v in pairs(pets) do
		local pet, owner = _L.Pets.Get(v)
		if not pet or owner ~= plyr then
			return
		end

		table.insert(queue, {
			Pet = pet,
			CreationAge = _L.Shared.ComputeSaveAge(save), --os.time(),
			CreationTime = os.time(),
			id = _L.Functions.GenerateUID()
		})

		_L.Pets.Delete(pet.uid)
	end

	return true, nil, queue
end

local function computeLoot(plyr, pets)
	local rewards = {}

	local function packLoot(c)
		for i, pet in ipairs(pets) do
			if c == "Currency" then
				local mainCurr = getWorldsCurrency(plyr) or "Coins"            
				local calcuDmds = calculateRewards("Currency", pet, "Diamonds")
				local calcuWrldCurr = calculateRewards("Currency", pet, mainCurr) 

				if not rewards["diamonds"] then
					rewards["diamonds"] = { Min = calcuDmds.Min, Max = calcuDmds.Max, Data = "Diamonds", Category = "Currency" }
				else
					rewards["diamonds"].Min = rewards["diamonds"].Min + calcuDmds.Min
					rewards["diamonds"].Max = rewards["diamonds"].Max + calcuDmds.Max
				end

				if not rewards["mainCurr"] then
					rewards["mainCurr"] = { Min = calcuWrldCurr.Min,  Max = calcuWrldCurr.Max, Data = mainCurr, Category = "Currency" }
				else
					rewards["mainCurr"].Min = rewards["mainCurr"].Min + calcuWrldCurr.Min
					rewards["mainCurr"].Max = rewards["mainCurr"].Max + calcuWrldCurr.Max
				end
			elseif c == "Boost" then
				local packedCurr = calculateRewards("Boosts", pet, nil)   

				for i, v in ipairs({"Triple Coins", "Triple Damage", "Super Lucky", "Ultra Lucky"}) do
					if not rewards[v] then
						rewards[v] = { Min = packedCurr[v],  Max = packedCurr[v], Data = v, Category = "Boost" }
					else
						rewards[v].Min = rewards[v].Min + packedCurr[v]
						rewards[v].Max = rewards[v].Max + packedCurr[v]
					end
				end
			elseif c == "Pet" then
				rewards["pet-1"] = { Data = { id = "2076", v = 0.001 }, Min = 0, Max = 0, Category = "Pet" }
				rewards["pet-2"] = { Data = { id = "1019", v = 0.05 }, Min = 0, Max = 0, Category = "Pet" }
			end
		end
	end

	packLoot("Currency")
	packLoot("Boost")
	packLoot("Pet")

	return TableToArray(rewards)
end


_L.Network.Invoked("Daycare: Claim").OnInvoke = function(plyr, pet)
	if not _L.Shared.ValidateInteractable(plyr, "Daycare", 100) then
		return false, "You're too far from the Daycare!"
	end

	local save = _L.Saving.Get(plyr)
	if not save then
		return
	end

	local queue = _L.Shared.IsHardcore and save.DaycareHardcoreQueue or save.DaycareQueue
	if not queue then
		return
	end

	if not pet then
		-- CLAIM ALL --
		local recievingLoot = {}
		local pets = {}
		local fffff = {}
		local nopnonon = 0
		for i, data in pairs(queue) do
			local est = _L.Shared.DaycareComputeRemainingTime(save, data)
			if not ( est > 0 ) then

				local computedLoot = computeLoot(plyr, { data.Pet })
				if computedLoot == false then return false end

				for i, v in ipairs(computedLoot) do
					if v.Category ~= "Pet" then
						table.insert(recievingLoot, {
							Data = v.Data,
							Category = v.Category,
							Min = math.round(RNG:NextNumber(v.Min, v.Max))
						})
					else
						local rew = _L.Functions.Lottery({ {"Pet", v.Data.v}, {" ", 100 - v.Data.v} })
						if rew == "Pet" then
							table.insert(recievingLoot, {
								Data = v.Data,
								Category = "Pet"
							})
						end
					end
				end

				_L.Pets.Create(plyr, data.Pet.id, data.Pet)
				table.insert(pets, data.Pet)

				fffff[i] = true
			else
				nopnonon = nopnonon + 1
			end
		end

		if nopnonon == #queue then
			return false, "no pets to claim"
		end

		for i, v in pairs(fffff) do
			table.remove(queue, i)
			if queue[i] then
				queue[i] = nil
			end
		end

		local loot = {}
		for i, v in ipairs(recievingLoot) do
			local t = true
			for int, tbl in ipairs(loot) do
				if tbl and tbl.Data and v and v.Data and tbl.Data == v.Data then                    
					loot[int].Min = loot[int].Min + v.Min
					t = false
				end
			end
			if t then
				table.insert(loot, v)
			end
		end

		local CoinMult = 1
		if _L.Mastery.HasPerk(plyr, "Daycare", 3) then
			CoinMult = 1.35
		elseif _L.Mastery.HasPerk(plyr, "Daycare", 1) then
			CoinMult = 1.1
		end

		local DiamondMult = 1
		if _L.Mastery.HasPerk(plyr, "Daycare", 4) then
			DiamondMult = 1.5
		end

		local BoosterMult = 1
		if _L.Mastery.HasPerk(plyr, "Daycare", 2) then
			BoosterMult = 1.25
		end

		local rewards = {}
		for i, v in ipairs(loot) do
			if v.Category == "Currency" then
				local mult = v.Data == "Diamonds" and DiamondMult or CoinMult
				_L.Give.Currency(plyr, v.Min * mult, v.Data)
				table.insert(rewards, {v.Data, v.Min * mult})
			elseif v.Category == "Boost" then
				_L.Boosts.Give(plyr, v.Data, v.Min * BoosterMult)
				table.insert(rewards, {v.Data, v.Min * BoosterMult})
			elseif v.Category == "Pet" then
				_L.Pets.Create(plyr, v.Data.id)
				table.insert(rewards, {"HugePet", v.Data.id})
			end
		end

		_L.Network.Fire("Rewards Redeemed", plyr, rewards)

		_L.Mastery.Progress(plyr, "Daycare", daycareMaseryRate*#pets)

		return true, nil, pets, loot, queue
	else
		-- CLAIM ONE --

		local data = queue[pet]

		if _L.Shared.DaycareComputeRemainingTime(save, data) > 0 then
			return false, "You cannot claim this right now!"
		end

		local computedLoot = computeLoot(plyr, { data.Pet })
		if computedLoot == false then return false end
		local recievingLoot = {}

		for i, v in ipairs(computedLoot) do
			if v.Category ~= "Pet" then
				table.insert(recievingLoot, {
					Data = v.Data,
					Category = v.Category,
					Min = math.round(RNG:NextNumber(v.Min, v.Max))
				})
			else
				local rew = _L.Functions.Lottery({ {"Pet", v.Data.v}, {" ", 100 - v.Data.v} })
				if rew == "Pet" then
					table.insert(recievingLoot, {
						Data = v.Data,
						Category = "Pet"
					})
				end
			end
		end

		local CoinMult = 1
		if _L.Mastery.HasPerk(plyr, "Daycare", 3) then
			CoinMult = 1.35
		elseif _L.Mastery.HasPerk(plyr, "Daycare", 1) then
			CoinMult = 1.1
		end

		local DiamondMult = 1
		if _L.Mastery.HasPerk(plyr, "Daycare", 4) then
			DiamondMult = 1.5
		end

		local BoosterMult = 1
		if _L.Mastery.HasPerk(plyr, "Daycare", 2) then
			BoosterMult = 1.25
		end

		local rewards = {}
		for i, v in ipairs(recievingLoot) do
			if v.Category == "Currency" then
				local mult = v.Data == "Diamonds" and DiamondMult or CoinMult

				_L.Give.Currency(plyr, v.Min * mult, v.Data)
				table.insert(rewards, {v.Data, v.Min * mult})
			elseif v.Category == "Boost" then
				_L.Boosts.Give(plyr, v.Data, v.Min * BoosterMult)
				table.insert(rewards, {v.Data, v.Min * BoosterMult})
			elseif v.Category == "Pet" then
				_L.Pets.Create(plyr, v.Data.id)
				table.insert(rewards, {"HugePet", v.Data.id})
			end
		end

		_L.Pets.Create(plyr, data.Pet.id, data.Pet)

		table.remove(queue, pet)

		_L.Network.Fire("Rewards Redeemed", plyr, rewards)

		_L.Mastery.Progress(plyr, "Daycare", daycareMaseryRate)

		return true, nil, {data.Pet}, recievingLoot, queue
	end
end


_L.Signal.Fired("Player Added"):Connect(function(player)
	_G.HasLoaded(player)
	task.wait(2) -- like psx.
	local save = _L.Saving.Get(player)
	if not save then
		return
	end

	local queue = _L.Shared.IsHardcore and save.DaycareHardcoreQueue or save.DaycareQueue
	if not queue then
		return
	end
	
	--local CHECKEDCACHE = {}
	local checked = false
	local function Check()
		for i,v in ipairs(queue) do
			if not v.id then
				v.id = _L.Functions.GenerateUID()
			end
			
			--if CHECKEDCACHE[v.id] then
			--	return
			--end
			if checked then return end
			
			if _L.Shared.DaycareComputeRemainingTime(save, v) < 0  then
				_L.Network.Fire("Notification", player, "You have rewards ready in the Daycare! Go claim them!", { color = Color3.fromRGB(105, 255, 168) })
				--CHECKEDCACHE[v.id] = true
				checked = true
				break
			end
		end
	end
	
	Check()
end)


-- fuse machine
function blacklisted(petData, id)
	if petData.rarity == "Exclusive" or petData.rarity == "Mythical" or petData.rarity == "Event" or petData.rarity == "Secret" or petData.huge or petData.titanic or petData.isGift or not petData.strengthMin or petData.companionEnchantLevel then
		return true
	end

	local blacklistedIds = {}

	if table.find(blacklistedIds, id) then
		return true  
	end

	return false
end

function CheckIfGreater(old, new, allStrength)  
	-- check if normal stat is greater than golden than rainbow --

	allStrength = math.round(allStrength / FuseDecrease)

	local R = _L.Shared.PetTypeMult.Rainbow
	local G = _L.Shared.PetTypeMult.Golden
	if new * R >= old and allStrength > new * R then -- rb
		return true, false, true
	end

	if new * G >= old and allStrength > new * G then -- g
		return true, true, false
	end

	if new >= old and allStrength > new then
		return true, false, false
	end

	return false, false, false
end


function TableToArray(tbl, getIndex)
	local arr = {}
	for i, v in pairs(tbl) do
		if getIndex then v.index = i end
		table.insert(arr, v)
	end
	return arr
end	

_L.Network.Invoked("Fuse Pets").OnInvoke = function(plyr, pets)
	local save = _L.Saving.Get(plyr)
	if not save then
		return
	end

	local masteryAdd = fusingMasteryRate*#pets

	local reqPets = _L.Shared.FuseMinPets
	local maxPets = _L.Shared.FuseMaxPets
	local cost = _L.Shared.IsHardcore and _L.Shared.FuseHardcoreCost or _L.Shared.FusePetsCost
	if save.Diamonds < cost then 
		return false, "You need " .. _L.Functions.Commas(cost - save.Diamonds) .. " more Diamonds"
	end
	if #pets < reqPets or #pets > maxPets then
		return 
	end

	local allStrength = 0
	local hardcore = false
	for i, uid in ipairs(pets) do 
		local pet, owner = _L.Pets.Get(uid)
		if not pet or owner ~= plyr then
			return 
		end

		if pet.hc then
			hardcore = true
		end

		if hardcore and not pet.hc then
			return false, "Some of these pets arent hardcore!"
		end

		allStrength = allStrength + pet.s
	end

	local newestID = nil
	local newestStrength = 0
	local isTooPowerfull = false 
	local isGold = false
	local isRainbow = false

	local petsDir = _L.Directory.Pets

	local tbl = TableToArray(petsDir, true)
	table.sort(tbl, function(i, v)
		return (v.strengthMin or 0) > (i.strengthMin or 0)
	end) 

	for _, petData in ipairs(tbl) do
		if not blacklisted(petData, petData.index) then
			local isGreater, Golden, Rainbow = CheckIfGreater(newestStrength, petData.strengthMin, allStrength)
			if isGreater then
				newestID = petData.index
				isGold = Golden
				isRainbow = isRainbow
			end
		end
	end

	if not newestID then
		return false, "you have max pet"
	end

	for i, v in ipairs(pets) do
		_L.Pets.Delete(v, true)
	end

	purchase(plyr, cost)
	_L.Achievements.Add(plyr, "Fuse Pets", 1)
	if petsDir[newestID].rarity and petsDir[newestID].rarity == "Legendary" then
		_L.Achievements.Add(plyr, "Fuse Pets Legendary", 1)
	end
	local shiny = false
	local chance = 0
	if _L.Mastery.HasPerk(plyr, "Fusing", 3) then
		chance = 1
	elseif _L.Mastery.HasPerk(plyr, "Fusing", 2) then
		chance = 0.5
	elseif _L.Mastery.HasPerk(plyr, "Fusing", 1) then
		chance = 0.2
	end

	coroutine.wrap(function()
		_L.Network.FireAll("Using Fuse Pets Machine", plyr)
	end)()
	
	-- dramatic wait...
	task.wait(MachineDelay)

	local lot = _L.Functions.Lottery({{true, chance},{false,100-chance}})
	shiny = lot == true
	_L.Pets.Create(plyr, newestID, {g = isGold, r = isRainbow, sh = shiny, hc = hardcore})
	_L.Mastery.Progress(plyr, "Fusing", masteryAdd)

	return true
end

-- Evolve machine
_L.Network.Invoked("Attempt Use Evolve Machine").OnInvoke = function(plyr, pets)
	local save = _L.Saving.Get(plyr)
	if not save then
		return nil, "no save"
	end

	if type(pets) ~= 'table' then
		return false, "type not table?"
	end

	_G.ProcessPending(plyr, false)	
	local petsToCompute = {}
	for _, uid in ipairs(pets) do
		local pet, owner = _L.Pets.Get(uid)
		if not pet or owner~=plyr then
			_G.ProcessPending(plyr, true)	
			return nil,"?"
		end

		table.insert(petsToCompute,pet)
	end

	local computed = _L.Shared.ComputeEvolveMachinePets(petsToCompute)
	if not computed then
		_G.ProcessPending(plyr, true)	
		return nil, "no computed"
	end

	local lotteryTbl = {}
	for i, v in pairs(computed) do
		table.insert(lotteryTbl, {i, v})
	end

	local lotteryResult = _L.Functions.Lottery(lotteryTbl)
	local dir = _L.Directory.Pets[lotteryResult]
	if not dir then
		_G.ProcessPending(plyr, true)	
		return false, "No directory"
	end

	local shinyChance = 0
	local rainbowChance = 0

	for i, v in pairs(petsToCompute) do
		if _L.Directory.Pets[v.id].evolve==lotteryResult then
			if v.sh then
				shinyChance = shinyChance+ 20
			end
			if v.r then
				rainbowChance = rainbowChance+ 20
			end
		end
	end

	local isShiny = _L.Functions.Lottery({ {true,shinyChance}, {false,100-shinyChance} })
	local isRainbow = _L.Functions.Lottery({ {true,rainbowChance}, {false,100-rainbowChance} })

	for _, uid in ipairs(pets) do
		_L.Pets.Delete(uid)
	end

	coroutine.wrap(function()
		_L.Network.FireAll("Using Evolve Machine", true)
	end)()
	
	-- dramatic wait...
	task.wait(MachineDelay)

	_L.Eggs.Open(plyr, "Cracked Egg", 1, { { lotteryResult, 100 } }, { {sh = isShiny, r = isRainbow} }, true, true)

	_G.ProcessPending(plyr, true)	
	return true
end
--[[ Last synced 9/21/2025 04:47                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--