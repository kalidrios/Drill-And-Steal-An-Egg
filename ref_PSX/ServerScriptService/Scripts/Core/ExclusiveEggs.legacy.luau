--[[              
           By: @pggondim     
--]]


--------|     Setting     |--------

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do  game:GetService("RunService").Heartbeat:Wait()  end

--------|    Reference    |--------

--------|    Variables    |--------
local RNG = Random.new()

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

function OpenExclusive(plr, uid, amountOpening, positionData)
	local save = _L.Saving.Get(plr)
	if not save then
		return nil
	end

	local pet, owner = _L.Pets.Get(uid)
	if not pet or owner ~= plr then
		return nil
	end

	local petDir = _L.Directory.Pets[pet.id]
	if not petDir then
		return nil
	end

	if not petDir.isGift then
		return false, "This isnt a gift...."
	end

	local giftEggId = petDir.giftEggId
	if not giftEggId then
		return nil, "No egg id?"
	end

	local giftsOpening = {}
	for key, savedPet in pairs(save.Pets) do
		if savedPet.id == pet.id then
			table.insert(giftsOpening, savedPet.uid)
			if #giftsOpening == amountOpening then
				break
			end
		end
	end

	if #giftsOpening < amountOpening then
		return nil, "You dont have enough gifts..."
	end


	for i, giftuid in ipairs(giftsOpening) do
		pcall(function()
			_L.Pets.Delete(giftuid, true)
		end)
	end


	return _L.Eggs.Open(plr, giftEggId, amountOpening, nil, nil, giftEggId, true)
end


_L.Network.Invoked("Exclusive Eggs: Open").OnInvoke = function(...)
	return OpenExclusive(...)
end

--_L.Network.Invoked("Exclusive Eggs: Open").OnInvoke = function(player, petUID, amountOpening, positionData)
--       Test Remote Output: p1: BuildIntoGCames p2: id28D9EC52B9E84CB1A67FA571B01DF057 p3: 8 p4: {}      --
--	petUID              =      tostring(petUID)
--	amountOpening       =      tonumber(amountOpening)
--	
--	local save = _L.Saving.Get(player, true)
--	
--	local petData = _L.Pets.Get(petUID) --
--	
--	local petDir = _L.Directory.Pets[petData.id]
--	if (not petDir) or (not petDir.isGift) then
--		warn("excleggs | server | pet error:   ", petData.id, petDir, petDir.isGift)
--	end
--	
--	local eggDir = _L.Directory.Eggs[petDir.giftEggId]
--	if (not eggDir) then
--		warn("excleggs | server | egg error:   ", petDir.giftEggId, eggDir)
--	end
--	
--	local petsOpening = {}
--	for i, pet in pairs(save.Pets) do
--		if pet.id == petData.id then
--			table.insert(petsOpening, pet.uid)
--			if #petsOpening == amountOpening then
--				break
--			end
--		end
--	end
--	
--	-- debug --
--	if #petsOpening < amountOpening or #petsOpening ~= amountOpening then return nil, ("??? -"..(#petsOpening < amountOpening)..(#petsOpening ~= amountOpening)) end
--	-- debug --
--	
--	for i, petUID in ipairs(petsOpening) do
--		_L.Pets.Delete(tostring(petUID), true)
--	end
--	
--	local pos = player.Character.HumanoidRootPart.Position
--	
--	local chancesThing    = {}
--	local hatchingPets    = {}
--	local positionsThing  = {}
--	
--	for i = 1, amountOpening do
--		local lotteryChance = _L.Functions.Lottery(unpack(eggDir.drops))
--		
--		local petDir2 = _L.Directory.Pets[lotteryChance]
--		if not petDir2 then
--			warn("Pet does not exist (" .. lotteryChance .. " from egg " .. petDir.giftEggId .. ")")
--			return false
--		end
--				
--		local isGold     = false
--		local isRainbow  = false
--		local isShiny    = false
--
--		local chance = RNG:NextNumber() * 100
--		if chance <= _L.Settings.MagicEggsChances.Rainbow then
--			isRainbow = true			
--		elseif chance <= _L.Settings.MagicEggsChances.Golden then
--			isGold = true
--		end
--		
--		local shinyChance = RNG:NextNumber() * 100
--		if shinyChance <= _L.Settings.MagicEggsChances.Shiny then
--			isShiny = true
--		end
--		
--		local uid, data = _L.Pets.Create(player, lotteryChance, {r = isRainbow, g = isGold, sh = isShiny}, nil, nil, nil, true)
--		if not uid then
--			return false
--		end
--		
--		table.insert(hatchingPets, data)
--		table.insert(positionsThing, pos + Vector3.new(0, math.rad(i), 0)) -- 
--		
--		local chancesTest = 0 -- ????
--		if isShiny then
--			chancesTest += 0.045
--		end if isGold then
--			chancesTest += 0.0225
--		end if isRainbow then
--			chancesTest += 0.455
--		end
--		
--		table.insert(chancesThing, chancesTest)
--	end
--	
--	local positions = _L.Network.Invoke("Exclusive Eggs: Compute Positions", player, amountOpening, positionsThing)
--		
--	_L.Network.FireAll("Exclusive Eggs: Animation", player, pos, petDir.giftEggId, hatchingPets, positions, chancesThing)
--	if petDir.giftCallback then
--		petDir.giftCallback(player)
--	end
--	
--	return true
--end

--[[_L.Signal.Fired("Exclusive Eggs: Open From Egg"):Connect(function(player, petId, serial, data)
    local save = _L.Saving.Get(player, true)

    local petDir = _L.Directory.Pets[petId]
    if (not petDir) then
        warn("excleggs | server | pet error:   ", petId, petDir)
    end

    local eggDir = _L.Directory.Eggs[petDir.giftEggId]
    if (not eggDir) then
        warn("excleggs | server | egg error:   ", petDir.giftEggId, eggDir)
    end

    local pos = player.Character.HumanoidRootPart.Position

    local chancesThing    = {}
    local hatchingPets    = {}
    local positionsThing  = {}

    local petDir2 = _L.Directory.Pets[petId]
    if not petDir2 then
        warn("Pet does not exist (" .. petId .. " from egg " .. petDir.giftEggId .. ")")
        return
    end

    local isGold     = false
    local isRainbow  = false
    local isShiny    = false

    local chance = RNG:NextNumber() * 100
    if chance <= _L.Settings.MagicEggsChances.Rainbow then
        isRainbow = true			
    elseif chance <= _L.Settings.MagicEggsChances.Golden then
        isGold = true
    end

    local shinyChance = RNG:NextNumber() * 100
    if shinyChance <= _L.Settings.MagicEggsChances.Shiny then
        isShiny = true
    end
    
	local merchDat = serial ~= nil and {
		["serial"] = serial,
		["user"] = player.UserId
	} or nil
	local d = data and data or {r = isRainbow, g = isGold, sh = isShiny, merchData = merchDat}
	
    local uid, petD = _L.Pets.Create(player, petId, d, nil, nil, nil, true)
    if not uid then
        return
    end

	table.insert(hatchingPets, petD)
    table.insert(positionsThing, pos + Vector3.new(0, math.rad(1), 0)) -- 

    local chancesTest = 0 -- ????
    if isShiny then
        chancesTest += 0.045
    end if isGold then
        chancesTest += 0.0225
    end if isRainbow then
        chancesTest += 0.455
    end

    table.insert(chancesThing, chancesTest)

    local positions = _L.Network.Invoke("Exclusive Eggs: Compute Positions", player, 1, positionsThing)

    _L.Network.FireAll("Exclusive Eggs: Animation", player, pos, "Cracked Egg", hatchingPets, positions, chancesThing)
end)

_L.Signal.Fired("Exclusive Eggs: Open Egg"):Connect(function(player, eggId, amountOpening)
	amountOpening = amountOpening or 1
	
	local save = _L.Saving.Get(player, true)

	local eggDir = _L.Directory.Eggs[eggId]
	if (not eggDir) then
		warn("excleggs | server | egg error:   ", eggId, eggDir)
	end

	local pos = player.Character.HumanoidRootPart.Position

	local chancesThing    = {}
	local hatchingPets    = {}
	local positionsThing  = {}

	for i = 1, amountOpening do
		local lotteryChance = _L.Functions.Lottery(unpack(eggDir.drops))

		local petDir2 = _L.Directory.Pets[lotteryChance]
		if not petDir2 then
			warn("Pet does not exist (" .. lotteryChance .. " from egg " .. eggId .. ")")
			return false
		end

		local isGold     = false
		local isRainbow  = false
		local isShiny    = false

		local chance = RNG:NextNumber() * 100
		if chance <= _L.Settings.MagicEggsChances.Rainbow then
			isRainbow = true			
		elseif chance <= _L.Settings.MagicEggsChances.Golden then
			isGold = true
		end

		local shinyChance = RNG:NextNumber() * 100
		if shinyChance <= _L.Settings.MagicEggsChances.Shiny then
			isShiny = true
		end

		local uid, data = _L.Pets.Create(player, lotteryChance, {r = isRainbow, g = isGold, sh = isShiny}, nil, nil, nil, true)
		if not uid then
			return false
		end

		table.insert(hatchingPets, data)
		table.insert(positionsThing, pos + Vector3.new(0, math.rad(i), 0)) -- 

		local chancesTest = 0 -- ????
		if isShiny then
			chancesTest += 0.045
		end if isGold then
			chancesTest += 0.0225
		end if isRainbow then
			chancesTest += 0.455
		end

		table.insert(chancesThing, chancesTest)
	end

	local positions = _L.Network.Invoke("Exclusive Eggs: Compute Positions", player, amountOpening, positionsThing)

	_L.Network.FireAll("Exclusive Eggs: Animation", player, pos, eggId, hatchingPets, positions, chancesThing)

	return true
end)]]--
--[[ Last synced 9/21/2025 04:49                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--