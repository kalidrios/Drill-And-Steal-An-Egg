local Library = game:GetService("ReplicatedStorage"):WaitForChild("Library")
local Signal = require(Library.Signal)
local Functions = require(Library.Functions)
local Network = require(game:GetService("ServerScriptService"):WaitForChild("Library").Network)

local Settings = require(script.Parent.Settings)
local Saving = require(script.Parent.Saving)
local Gamepasses = require(script.Parent.Gamepasses)
local Directory = require(Library.Directory)
local Pets = require(script.Parent.Pets)
local Shared = require(Library.Shared)
local Mastery = require(script.Parent.Mastery)
local Boosts = require(script.Parent.Boosts)
local Upgrades = require(script.Parent.Upgrades)
local Achievements = require(script.Parent.Achievements)
local Worlds = require(script.Parent.Worlds)
local ServerBoosts = require(script.Parent.ServerBoosts)
local Fruit = require(script.Parent.Fruit)
local Variables = require(game.ReplicatedStorage.Library.Variables)

local Eggs = {}
local luckyID = Directory.Gamepasses.Lucky.ID
local mythicalHunterID = Directory.Gamepasses["Mythical Hunter"].ID
local magicEggsID = Directory.Gamepasses["Magic Eggs"].ID
local RNG = Random.new()
local tripleHatchID = Directory.Gamepasses["Triple Egg Open"].ID
local u12 = {}
local rarityData = {
	["Basic"] =      {"Basic", "Rare", "Epic", "Legendary", "Mythical", "Secret", "Event", "Exclusive"},
	["Rare"] =       {"Rare", "Epic", "Legendary", "Mythical", "Secret", "Event", "Exclusive"},
	["Epic"] =       {"Epic", "Legendary", "Mythical", "Secret", "Event", "Exclusive"},
	["Legendary"] =  {"Legendary", "Mythical", "Secret", "Event", "Exclusive"},
	["Mythical"] =   {"Mythical", "Secret", "Event", "Exclusive"},
	["Secret"] =     {"Secret", "Event", "Exclusive"},
	["Event"] =      {"Event", "Exclusive"},
	["Exclusive"] =  {"Exclusive"}
}

function isOnlyExclusives(drops)
	local isExclusive = true
	for i, v in pairs(drops) do
		if not isExclusive then
			break
		end
		
		local petId, petChance = unpack(drops)
		local petDir = Directory.Pets[petId]
		if petDir then
			if petDir.rarity ~= "Exclusive" or petDir.rarity ~= "Event" then
				isExclusive = false
				break
			end
		end
	end
	
	return isExclusive
end

function Eggs.Open(plr, egg, amountOpening, customDrops, customPetData, giftEggId, isAnimation)
	--giftEggId = typeof(giftEggId) == "string" and giftEggId or giftEggId == true and "Cracked Egg" or nil
	if giftEggId == true then
		giftEggId = "Cracked Egg"
	end
	egg = egg and egg or customDrops and "Cracked Egg" or nil
	
	local save = Saving.Get(plr)
	if not save then
		return
	end
	
	local eggDir = Directory.Eggs[egg]
	local isGolden = eggDir.isGolden
	local eggDrops = eggDir.drops
	if type(eggDrops) == "string" then
		eggDrops = Directory.Eggs[eggDrops].drops
	end	
	
	local isExclusiveEgg = isOnlyExclusives(eggDrops)

	if not isExclusiveEgg then
		if Shared.IsHardcore and save.Hardcore.World == "Dog" or save.World == "Dog" then
			table.insert(eggDrops, {"623", 0.0001})
		end
		table.insert(eggDrops, {"6969", 0.001})
	end	

	for i, v in pairs(eggDrops) do
		if v[3] == true and Shared.IsHardcore then
			table.insert(eggDrops, v)
		end
	end

	local drops = Functions.CloneTable(customDrops and customDrops or eggDrops)
	local ownsMythicalHunter = Gamepasses.Owns(plr, mythicalHunterID)
	local ownsMagicEggs = Gamepasses.Owns(plr, magicEggsID)
	local legendaryPetsMult = Upgrades.Get(plr, "Halloween Legendary Pets")
	local mythicalPetsMult = Upgrades.Get(plr, "Halloween Mythical Pets")
    local masteryEggPerk = isGolden and "Golden Eggs" or "Eggs" 
	local fruitDir = Directory.Fruits["Banana"]
	local banana = Fruit.Get(plr, Directory.Fruits["Banana"])
	local bonus = Fruit.GetBonus(plr, fruitDir)
	if tonumber(bonus) and (bonus < 1 and bonus > 0) then
		bonus = bonus + 1
	end
	
	local boostOdds = 0
	if Boosts.Has(plr, "Super Lucky") then
		boostOdds = boostOdds + Settings.SuperLuckyMult or 0
	end
	if Boosts.Has(plr, "Ultra Lucky") then
		boostOdds = boostOdds + Settings.UltraLuckyMult or 0
	end
	if Gamepasses.Owns(plr, luckyID) then
		boostOdds = boostOdds + Settings.LuckyPassMult or 0
	end
	if ServerBoosts.IsActive(plr, "Super Lucky") then
		boostOdds = boostOdds + Settings.SuperLuckyMult or 0
	end
	if ServerBoosts.IsActive(plr, "Insane Luck") then
		boostOdds = boostOdds + 25
	end
	if banana >= 1 then
		boostOdds = boostOdds + (bonus or 0)
	end

	local function increaseOdds(odds)
		local overallChance = 0
		for key, drop in pairs(drops) do
			local petId, petChance = unpack(drop)
			overallChance = overallChance + petChance
		end
		for key, drop in pairs(drops) do
			local petId, petChance = unpack(drop)
			if petChance / overallChance <= 0.05 then
				local dropData = drops[key]
				dropData[2] = dropData[2] * odds
			end
		end
	end
	
	local function increaseRarityOdds(rarity, odds)
		for key, drop in pairs(drops) do
			local petId, petChance = unpack(drop)
			if Directory.Pets[petId].rarity == rarity then
				local dropData = drops[key]
				dropData[2] = dropData[2] * odds
			end
		end
	end
	
	local function addBoostedOdds()
		if boostOdds > 0 then
			increaseOdds(boostOdds)
		end
		if ownsMythicalHunter then
			increaseRarityOdds("Mythical", Settings.MythicalHunterMult)
		end
		if legendaryPetsMult > 0 then
			increaseRarityOdds("Legendary", 1 + legendaryPetsMult * 0.2)
		end
		if mythicalPetsMult > 0 then
			increaseRarityOdds("Mythical", 1 + mythicalPetsMult * 0.2)
		end
		if Mastery.HasPerk(plr, masteryEggPerk, 3) then
			increaseOdds(2)
			return
		end
		if Mastery.HasPerk(plr, masteryEggPerk, 1) then
			increaseOdds(1.33)
		end
	end
	
	if not isExclusiveEgg and not eggDir.disableBoostedOdds then
		addBoostedOdds()
	end
	
	local function hatchPet()
		local petHatched, v1, v2, key = Functions.Lottery(unpack(drops))
		local petDir = Directory.Pets[petHatched]
		if not petDir then
			warn("Pet does not exist (" .. petHatched .. " from egg " .. egg .. ")")
			return false
		end
		
		local golden = false
		local rainbow = false
		local shiny = false
		local canBeGold = false
		local canBeRainbow = false
		local goldHatchOdds = eggDir.goldenChance and eggDir.goldenChance or Settings.MagicEggsChances.Golden
		local rainbowHatchOdds = eggDir.rainbowChance and eggDir.rainbowChance or Settings.MagicEggsChances.Rainbow
		local shinyHatchOdds = Settings.MagicEggsChances.Shiny
		
		if Mastery.HasPerk(plr, masteryEggPerk, 5) then
			if isGolden then
				canBeRainbow = true
				rainbowHatchOdds = rainbowHatchOdds * 1.2
			else
				canBeGold = true
				goldHatchOdds = goldHatchOdds * 1.2
			end
		end
		
		if ownsMagicEggs then
			canBeRainbow = true
			canBeGold = true
		end
		
		if canBeGold or canBeRainbow then
			local chance = RNG:NextNumber() * 100
			if chance <= rainbowHatchOdds and canBeRainbow then
				rainbow = true
			elseif chance <= goldHatchOdds and canBeGold then
				golden = true
			end
		end
		
		if not rainbow and isGolden and RNG:NextNumber(0, 100) <= Settings.GoldenEggChance then
			golden = true
		end
		
		if RNG:NextNumber(0, 100) <= shinyHatchOdds then
			shiny = true
		end
		
		--if isExclusiveEgg and not  then
		--	golden = false
		--	rainbow = false
		--end
		
		local petData = {}
		if rainbow then
			petData.r = true
		elseif golden then
			petData.g = true
		end
		if shiny then
			petData.sh = true
		end
		
		if customPetData then
			local ce = customPetData[key]
			if ce then
				for k, v in pairs(ce) do
					petData[k] = true
				end
			end
		end
		
		if Shared.IsHardcore and eggDir.hardcoreEnabled then
			if petDir.rarity ~= "Event" and petDir.rarity ~= "Exclusive" then
				petData.hc = true
			else
				petData.hc = false
			end
		end
		
		local uid, returnedPetData = Pets.Create(plr, petHatched, petData, nil, nil, nil, true)
		if not uid then
			return false
		end
		
		Signal.Fire("Hatched Pet", plr, egg, returnedPetData)
		
		local rarity = petDir.rarity
		coroutine.wrap(function()
			Functions.Wait(3)
			if not isAnimation then
				RareHatchChatMessage(uid, petData)
			end	
			if petDir.titanic then
				Achievements.Add(plr, "Titanic Pets", 1)
			end
			if rarity == "Rare" then
				Achievements.Add(plr, "Rare Pets", 1)
				return
			end
			if rarity == "Epic" then
				Achievements.Add(plr, "Epic Pets", 1)
				return
			end
			if rarity == "Legendary" then
				Achievements.Add(plr, "Legendary Pets", 1)
				return
			end
			if rarity == "Mythical" then
				Achievements.Add(plr, "Mythical Pets", 1)
				return
			end
			if rarity == "Secret" then
				Achievements.Add(plr, "Secret Pets", 1)
				return
			end
			if rarity == "Exclusive" then
				Achievements.Add(plr, "Exclusive Pets", 1)
			end
		end)()
		return returnedPetData, key
	end
	
	local plrPosition = plr.Character.HumanoidRootPart.Position
	
	local chances = {}
	local hatchedPets = {}
	local positionData = {}
	for index = 1, amountOpening do
		local hatchedPetData, key = hatchPet()
		if hatchedPetData then
			local petId, petChance = unpack(drops[key])
			chances[index] = petChance
			table.insert(hatchedPets, hatchedPetData)
			table.insert(positionData, plrPosition + Vector3.new(0, math.rad(index), 0))
		end
	end

	local autoDeleteEnabled = Network.Invoke("Auto Delete Enabled", plr)
	coroutine.wrap(function()
		task.delay(3.5, function()
			if autoDeleteEnabled then
				local toDelete = {}
				local save = Saving.Get(plr) 
				if save and save.AutoDelete then
					for _, pet in ipairs(hatchedPets) do
						local dir = Directory.Pets[pet.id]
						local rarity = dir.rarity
						local alwaysKeepSettings = save.AutoHatchSettings.AlwaysKeep

						local function allowDelete()
							local delete = true

							if pet.sh then
								local set = rarityData[alwaysKeepSettings.ShinyPets]
								if set then
									if table.find(set, rarity) then
										delete = false
									end
								end
							end

							if pet.r then
								local set = rarityData[alwaysKeepSettings.RainbowPets]
								if set then
									if table.find(set, rarity) then
										delete = false
									end
								end
							end

							if pet.g then
								local set = rarityData[alwaysKeepSettings.GoldPets]
								if set then
									if table.find(set, rarity) then
										delete = false
									end
								end
							end

							return delete
						end

						if save.AutoDelete[rarity] then
							local allowDelete = allowDelete()
							if allowDelete then
								table.insert(toDelete, pet.uid)
							end
						end
					end
				end

				if #toDelete > 0 then
					local success, response = Signal.Invoke("Delete Several Pets", plr, toDelete)
					if not success then
						Network.Fire("Message", "Error:  " .. response)
					end
				end
			end
		end)
	end)()
	
	if isAnimation then
		local positions = Network.Invoke("Exclusive Eggs: Compute Positions", plr, amountOpening, positionData)
		Network.FireAll("Exclusive Eggs: Animation", plr, plrPosition, giftEggId, hatchedPets, positions, chances)
	else	
		Network.Fire("Open Egg", plr, egg, hatchedPets)
	end	
	
	if giftEggId ~= "Cracked Egg" then
		local giftDir = Directory.Pets[giftEggId]
		if giftDir and giftDir.isGift then
			if giftDir.giftCallback then
				giftDir.giftCallback(plr, nil)
			end
		end
	end
	
	return true
end

function Eggs.Buy(p7, p8, p9, octuple)
	local v42 = Saving.Get(p7)
	local v43 = Directory.Eggs[p8]
	if not v42 or not v43 then
		return false
	end
	local v44
	if octuple then
		v44 = 8
	elseif p9 then
		v44 = 3
	else
		v44 = 1
	end
	local cost = Shared.IsHardcore and v43.hardcoreCost and v43.hardcoreCost or v43.cost
	local v45 = cost * v44
	local l__currency__46 = v43.currency
	local l__area__47 = v43.area
	local l__areaRequired__48 = v43.areaRequired
	local l__areaEggsRequired__49 = v43.areaEggsRequired
	if not v43.hatchable or v43.disabled then
		return false
	end

	local cur = Shared.IsHardcore and v42.HardcoreCurrency[l__currency__46] or v42[l__currency__46]

	local v50 
	if v43.isGolden then
		v50 = "Golden Eggs"
	else
		v50 = "Eggs"
	end
	if Mastery.HasPerk(p7, v50, 4) then
		local v51
		if v43.isGolden then
			v51 = 0.85
		else
			v51 = 0.8
		end
		v45 = v45 * v51
	elseif Mastery.HasPerk(p7, v50, 2) then
		local v52
		if v43.isGolden then
			v52 = 0.95
		else
			v52 = 0.9
		end
		v45 = v45 * v52
	end
	local v53 = math.round(v45)
	if not Gamepasses.Owns(p7, tripleHatchID) and p9 then
		return false, "You do not own Triple Eggs Gamepass"
	end
	if not v42.OwnsOctupleEggs and octuple then
		return false, "You do not own Octuple Eggs Gamepass"
	end
	local v54, v55 = Eggs.IsUnlocked(p7, p8)
	if not v54 then
		return false, v55
	end
	if cur < v53 then
		return false, "You need " .. Functions.Commas(v53 - cur) .. " more " .. l__currency__46 .. " to buy this egg!"
	end
	if v42.MaxSlots <= #v42.Pets + (v44 - 1) then
		return false, "Your inventory is full!"
	end
	if u12[p7] then
		return false, "You are doing this too quickly!"
	end
	coroutine.wrap(function()
		u12[p7] = true
		Functions.Wait(0.75)
		u12[p7] = nil
	end)()
	if not Eggs.Open(p7, p8, v44) then
		return
	end

	if Shared.IsHardcore then
		v42.HardcoreCurrency[l__currency__46] = v42.HardcoreCurrency[l__currency__46] - v53
	else
		v42[l__currency__46] = v42[l__currency__46] - v53
	end

	if not v42.EggsOpened[p8] then
		v42.EggsOpened[p8] = 0
	end
	local l__EggsOpened__56 = v42.EggsOpened
	l__EggsOpened__56[p8] = l__EggsOpened__56[p8] + v44
	Achievements.Add(p7, "Open Eggs", v44)
	if v43.isGolden then
		Mastery.Progress(p7, "Golden Eggs", v44 * 75)
	else
		Mastery.Progress(p7, "Eggs", v44 * 75)
	end
	return true
end

function Eggs.IsUnlocked(p10, p11)
	local v57 = nil
	local v58 = Saving.Get(p10)
	v57 = Directory.Eggs[p11]
	if not v58 or not v57 then
		return false
	end
	local l__area__59 = v57.area
	local l__eggRequired__60 = v57.eggRequired
	local l__eggRequiredOpenAmount__61 = v57.eggRequiredOpenAmount
	if v57.areaRequired and not Worlds.HasArea(p10, l__area__59) then
		return false, "You must have the " .. l__area__59 .. " Area unlocked."
	end
	if l__eggRequired__60 and l__eggRequired__60 ~= "" and l__eggRequired__60 ~= p11 and not Eggs.IsUnlocked(p10, l__eggRequired__60) then
		return false, "You must have the " .. Directory.Eggs[l__eggRequired__60].displayName .. " unlocked."
	end
	if l__eggRequiredOpenAmount__61 and l__eggRequiredOpenAmount__61 > 0 and l__eggRequired__60 and l__eggRequired__60 ~= "" then
		local v62 = v58.EggsOpened[l__eggRequired__60]
		if not v62 or v62 < l__eggRequiredOpenAmount__61 then
			return false, "You need to open " .. l__eggRequiredOpenAmount__61 - v62 .. " more " .. Directory.Eggs[l__eggRequired__60].displayName .. "."
		end
	end
	return true
end

local messaging = game:GetService("MessagingService")
function RareHatchChatMessage(uid, extraData)
	local pet, owner = Pets.Get(uid)
	if not pet or not pet.id or not owner then
		return
	end

	local msg, color, announce = Shared.HatchMessage(pet, owner)

	if announce then
		if pet.rarity == "Exclusive" and Directory.Pets[pet.id].titanic then
			messaging:PublishAsync("Titanic Opened", {msg = msg, color = color, hatchedby = owner.Name})
		end

		Network.FireAll("Chat Msg", msg, color)
	end    
end

messaging:SubscribeAsync("Titanic Opened", function(data)
	if data then		
		local chatd = data.Data
		if game.Players:FindFirstChild(chatd.hatchedby) then return end
		Network.FireAll("Chat Msg", '[🌎Global] '..chatd.msg, chatd.color)
	end
end)

Network.Invoked("Buy Egg").OnInvoke = function(p14, p15, p16, octuple)
	if not Shared.ValidateEgg(p14, p15, 100) then
		return false, "You're too far from the egg!"
	end

	return Eggs.Buy(p14, p15, p16, octuple)
end

return Eggs
