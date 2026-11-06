--------|     Setting     |--------

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do  game:GetService("RunService").Heartbeat:Wait()  end

--------|    Reference    |--------

--------|    Variables    |--------


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local bakeryLocationParts = {}

-- wait for MUTATE to init on the server
while not _L.Variables.UIDData do wait() end

-- initialize location parts
for i, v in ipairs(workspace["__THINGS"].LOCATIONS:GetChildren()) do
	table.insert(bakeryLocationParts, {
		locationPart = v;
		owner = nil;	
	})
end

-- provides a player with a Workspace location for the bakery
local function getValidBakeryLocation(newOwner)
	for i, v in ipairs(bakeryLocationParts) do
		if not v.owner then
			v.owner = newOwner
			return v.locationPart
		end
	end
	
	_L.Print("CRITICAL: Could not find valid bakery location for " .. newOwner.Name .. ". Their loading has been aborted", true)
	return nil
end

-- gets a locaiton part given a player
local function getBakeryLocationFromOwner(owner)
	for _, entry in ipairs(bakeryLocationParts) do
		if entry.owner == owner then
			return entry.locationPart
		end
	end
	return nil
end

-- frees up the player's Bakery location in Workspace
local function freeBakeryLocation(owner)
	for i, v in ipairs(bakeryLocationParts) do
		if v.owner == owner then
			v.owner = nil
		end
	end
end

local function convertStorableToUIDTable(player)
	
	local mySave = _L.Saving.Get(player)
	if not mySave then
		_L.Print("CRITICAL: couldn't get player " .. player.Name .. "'s save to convert to UID entry", true)
	end
	
	-- if the player hasn't completed the tutorial, give them the default bakery and reset 
	-- all of their stats (player can't purchase anything during tutorial)
	if not mySave.HasCompletedTutorial then
		mySave.Cash = _L.Settings.DefaultStats.Cash
		mySave.Bakery = _L.Functions.CloneTable(_L.Variables.DefaultBakery)
		mySave.Recipes = _L.Functions.CloneTable(_L.Settings.DefaultStats.Recipes)
	end
	
	local storedBakeryData = mySave.Bakery
	
	local UIDEntries = {
		CurrentDay = storedBakeryData.CurrentDay;
		CurrentRotation = storedBakeryData.CurrentRotation;
		Experience = storedBakeryData.Experience;
		Floor = {};
		Appliance = {};
		Furniture = {};
		Cook = {};
		Waiter = {};
		Customer = {}; -- does not persist.  always empty on init
	}
	
	-- each UID entry is a copy of the entry in datastorage, except that it
	-- is indexable by UID and also contains the UID as a field
	local function makeUIDEntry(entryContainer, data, className, floorLevel, tier)
		local UID = _L.Functions.GenerateUID()
		
		--local entryData = _L.Functions.CloneTable(data)
		local entryData = {}
		entryData.ID = data.ID
		entryData.XVoxel = data.X
		entryData.YVoxel = data.Y
		entryData.ZVoxel = data.Z
		entryData.Name = data.N or nil
		entryData.Experience = data.E or nil
		entryData.Tier = data.T or nil
		entryData.Orientation = data.O or nil
		entryData.Text = data.Text or nil
		entryData.Highscore = data.Highscore or nil
		entryData.Timestamp = data.Timestamp or nil
   		entryData.UID = UID
		entryData.FloorLevel = floorLevel
		entryData.ClassName = className
		
		entryContainer[UID] = entryData
	end
	
	local function checkForBiggerPlot()
		local save = _L.Saving.Get(player)
		if not save then
			return
		end
		-- owned and not yet registered?
		if _L.Gamepasses.Owns(player, _L.Directory.Gamepasses["BiggerPlots"].ID) then
			save.GamepassRegistry.BiggerPlots = true
			for _, floorEntry in ipairs(UIDEntries.Floor) do
				if floorEntry.SizeXVoxel == 14 then
					floorEntry.SizeXVoxel = 16
				end
				if floorEntry.SizeZVoxel == 14 then
					floorEntry.SizeZVoxel = 16
				end
				if floorEntry.FloorTransitionXVoxel == 13 then
					floorEntry.FloorTransitionXVoxel = 15
				end
				if floorEntry.FloorTransitionZVoxel == 13 then
					floorEntry.FloorTransitionZVoxel = 15
				end
			end
		end
	end
	
	
	-- populate UIDData with entries from datastorage
	for i, floor in ipairs(storedBakeryData.Floors) do
		
		-- store information about each floor
		UIDEntries.Floor[i] = {
			FloorLevel = i;
			FloorTransitionXVoxel = floor.TX;
			FloorTransitionZVoxel = floor.TZ;
			SizeXVoxel = floor.SX;
			SizeYVoxel = floor.SY;
			SizeZVoxel = floor.SZ;
		}
				
		for _, furniture in ipairs(floor.F) do
			makeUIDEntry(UIDEntries.Furniture, furniture, "Furniture", floor.FL)
		end
		
		for _, appliance in ipairs(floor.A) do
			makeUIDEntry(UIDEntries.Appliance, appliance, "Appliance", floor.FL)
		end
		
		for _, waiter in ipairs(floor.W) do
			makeUIDEntry(UIDEntries.Waiter, waiter, "Waiter", floor.FL)
		end
		
		for _, cook in ipairs(floor.C) do
			makeUIDEntry(UIDEntries.Cook, cook, "Cook", floor.FL)
		end
		
	end
	
	checkForBiggerPlot()
	
	return UIDEntries
	
end

local function convertUIDTableToStorable(player)
	local myUIDData = _L.Variables.UIDData[player.Name]
	if not myUIDData then
		_L.Print("CRITICAL: couldn't convert UID data for " .. player.Name .. " because Save doesn't exist", true)
		return nil
	end	
	
	local storableBakeryData = {}
	storableBakeryData.CurrentDay = myUIDData.CurrentDay
	storableBakeryData.CurrentRotation = myUIDData.CurrentRotation
	storableBakeryData.Experience = myUIDData.Experience
	storableBakeryData.Floors = {}
	
	-- initialize empty floors
	for i, floorData in ipairs(myUIDData.Floor) do
		storableBakeryData.Floors[i] = {
			FL = i;
			TX = floorData.FloorTransitionXVoxel;
			TZ = floorData.FloorTransitionZVoxel;	
			SX = floorData.SizeXVoxel;
			SY = floorData.SizeYVoxel;
			SZ = floorData.SizeZVoxel;
			F  = {};
			C  = {};
			W  = {};
			A  = {};
		}
	end
	
	local function makeFurnitureSave(uidData)
		return {
			ID = uidData.ID;
			X = uidData.XVoxel;
			Y = uidData.YVoxel;
			Z = uidData.ZVoxel;
			O = uidData.Orientation;
			Text = uidData.Text or "";
			Highscore = uidData.Highscore or {};
			Timestamp = uidData.Timestamp or nil;
		}
	end
	
	local function makeApplianceSave(uidData)
		return {
			ID = uidData.ID;
			X = uidData.XVoxel;
			Y = uidData.YVoxel;
			Z = uidData.ZVoxel;
			O = uidData.Orientation;
			CandyLevel = uidData.CandyLevel or nil;
		}
	end
	
	local function makeCookSave(uidData)
		return {
			ID = uidData.ID;
			X = uidData.XVoxel;
			Y = uidData.YVoxel;
			Z = uidData.ZVoxel;
			N = uidData.Name;
			E = uidData.Experience;
			T = uidData.Tier;	
		}
	end
	
	local function makeWaiterSave(uidData)
		return {
			ID = uidData.ID;
			X = uidData.XVoxel;
			Y = uidData.YVoxel;
			Z = uidData.ZVoxel;
			N = uidData.Name;
			E = uidData.Experience;	
			T = uidData.Tier;
		}
	end
	
	local function populateFloorUsingMakerFunction(entityUIDData, makerFunction)
		if not entityUIDData then
			return _L.Print("CRITICAL: No UID data for UID " .. entityUIDData, true)
		end

		if not storableBakeryData.Floors[entityUIDData.FloorLevel] then
			return _L.Print("CRITICAL: Invalid floor number #" .. tostring(entityUIDData.FloorLevel), true)
		end
		
		table.insert(storableBakeryData.Floors[entityUIDData.FloorLevel][entityUIDData.ClassName:sub(1, 1)], makerFunction(entityUIDData))
	end
	
	for UID, v in pairs(myUIDData.Furniture) do
		populateFloorUsingMakerFunction(v, makeFurnitureSave)
	end
	
	for UID, v in pairs(myUIDData.Cook) do
		populateFloorUsingMakerFunction(v, makeCookSave)
	end
	
	for UID, v in pairs(myUIDData.Waiter) do
		populateFloorUsingMakerFunction(v, makeWaiterSave)
	end
	
	for UID, v in pairs(myUIDData.Appliance) do
		populateFloorUsingMakerFunction(v, makeApplianceSave)
	end
	
	return storableBakeryData
end

local function waitForSave(player)
	local savedData = _L.Saving.Get(player)
	if not savedData then
		repeat
			_L.Print("Waiting for " .. player.Name .. "'s data to initalize their bakery...")
			savedData = _L.Saving.Get(player)
			wait()
		until savedData
	end
	return savedData
end

local function saveBakeryToFramework(player)
	
	-- LOTS of sanity checks for here.
	if not _L.Saving.Get(player) then
		_L.Print("saveBakeryToFramework CRITICAL: no save for " .. player.Name, true)
		return
	end
	
	if not _L.Variables.UIDData[player.Name] then
		_L.Print("saveBakeryToFramework CRITICAL: no UIDData for " .. player.Name, true)
		return
	end
	
	local storable = convertUIDTableToStorable(player)
	if not storable then
		_L.Print("saveBakeryToFramework CRITICAL: convertUIDTableToStorable failed", true)
		return
	end
	
	_L.Print("saveBakeryToFramework: " .. player.Name)
	--_L.Print("JSON printout:\n" .. _L.Services.HttpService:JSONEncode(storable))
	_L.Saving.Get(player).Bakery = storable
end
_L.Signal.Fired("SaveBakeryToFramework"):Connect(function(player)
	saveBakeryToFramework(player)
end)

-- bakery location parts have different orientations.  use the change in orientation
-- from the last save to rotate every entity accordingly
local function accountForBakeryRotation(UIDEntry, locationPart)
	
	local newRotation = locationPart.Orientation.Y
	local oldRotation = UIDEntry.CurrentRotation
	
	-- roblox is terrible
	if newRotation == -180 then
		_L.Print("This is weird..")
		newRotation = 180
	end
	
	local dimensionSize = UIDEntry.Floor[1].SizeXVoxel
	local delta = newRotation - oldRotation
	UIDEntry.CurrentRotation = newRotation
		
	local function reflectCoord(xVoxel, zVoxel)
		if delta == 0 then
			return xVoxel, zVoxel
		elseif math.abs(delta) == 180 then
			return dimensionSize - xVoxel + 1, dimensionSize - zVoxel + 1
		elseif delta == 90 then
			return dimensionSize - (dimensionSize - zVoxel + 1) + 1, dimensionSize - xVoxel + 1
		else
			return dimensionSize - zVoxel + 1, xVoxel
		end
	end
	local function reflectEntity(entity)
		entity.XVoxel, entity.ZVoxel = reflectCoord(entity.XVoxel, entity.ZVoxel)
		if entity.Orientation then
			entity.Orientation = (entity.Orientation + delta) % 360
		end
	end
		
	if delta == 0 then
		return
	end
	
	-- reflect all entities and floor teleport spot
	for _, furniture in pairs(UIDEntry.Furniture) do
		reflectEntity(furniture)
	end
	for _, appliance in pairs(UIDEntry.Appliance) do
		reflectEntity(appliance)
	end
	for _, waiter in pairs(UIDEntry.Waiter) do
		reflectEntity(waiter)
	end
	for _, cook in pairs(UIDEntry.Cook) do
		reflectEntity(cook)
	end
	for _, floor in pairs(UIDEntry.Floor) do
		floor.FloorTransitionXVoxel, floor.FloorTransitionZVoxel = reflectCoord(
			floor.FloorTransitionXVoxel, floor.FloorTransitionZVoxel
		)
	end
		
end

local function initializePlayerBakery(player)
	waitForSave(player)
	local bakeryLocationPart = getValidBakeryLocation(player)
	
	-- bakery theme
	local themeID = nil
	local save = _L.Saving.Get(player)
	if save then
		themeID = save.CurrentTheme
	end
	themeID = themeID or "1"
	
	if bakeryLocationPart then
		
		-- initialize a data entry in the UID table.  This is what the client networking
		-- events will interface with when the user wants to make changes
		_L.Variables.UIDData[player.Name] = convertStorableToUIDTable(player)
		
		accountForBakeryRotation(_L.Variables.UIDData[player.Name], bakeryLocationPart)
		
		-- tell the client to initialize on their side.  the client only deals with the UID table,
		-- never directly with the table that is stored in the DS
		_L.Network.Fire("InitBakeryData", player, _L.Variables.UIDData[player.Name], bakeryLocationPart, themeID, not _L.Saving.Get(player).HasCompletedTutorial)
		_L.Network.Fire("BakeryExperienceUpdated", player, _L.Variables.UIDData[player.Name].Experience)
		
		-- tell all other clients to initialze the position of the bakery
		-- ONLY send furiture for the initialization.
		local function cloneAndStrip(UIDData)
			local clonedData = _L.Functions.CloneTable(UIDData)
			clonedData.Cook = {}
			clonedData.Waiter = {}
			clonedData.Customer = {}
			clonedData.Furniture = {}
			clonedData.Appliance = {}
			return clonedData
		end
		local clonedPlayer = cloneAndStrip(_L.Variables.UIDData[player.Name])
		coroutine.wrap(function()
			for _, client in ipairs(game.Players:GetPlayers()) do
				if client == player then
					continue
				end
				if not client.Parent then
					continue
				end
				wait(1.5)
				_L.Network.Fire("Replication_InitializeBakeryWithFurniture", client, player, clonedPlayer, bakeryLocationPart, themeID)
				if _L.Variables.UIDData[client.Name] then
					local clonedClient = cloneAndStrip(_L.Variables.UIDData[client.Name])
					local clientSave = _L.Saving.Get(client)
					local clientThemeID = "1"
					if clientSave then
						clientThemeID = clientSave.CurrentTheme
					end
					_L.Network.Fire("Replication_InitializeBakeryWithFurniture", player, client, clonedClient, getBakeryLocationFromOwner(client), clientThemeID)
				end
			end
		end)()
		
		-- periodically update the UIDData to the framework
		coroutine.wrap(function()
			while wait(20) do
				if player.Parent == nil then
					break
				end
				saveBakeryToFramework(player)
			end
		end)()
	end
end

local didLoadPlayers = {}
_L.Network.Fired("InitializeMyBakery"):Connect(function(sender)
	
	if didLoadPlayers[sender.Name] then
		return
	end
	didLoadPlayers[sender.Name] = true
	
	initializePlayerBakery(sender)
	
	sender.CharacterAdded:Connect(function()
		local locationPart = getBakeryLocationFromOwner(sender)
		sender.Character:MoveTo(locationPart.Position + Vector3.new(0, 10, 0))
	end)
	local locationPart = getBakeryLocationFromOwner(sender)
	sender.Character:MoveTo(locationPart.Position + Vector3.new(0, 10, 0))
	
end)

_L.Signal.Invoked("GetPlayerFromLocationPart").OnInvoke = function(locationPart)
	for _, entry in ipairs(bakeryLocationParts) do
		if entry.locationPart == locationPart then
			return entry.owner
		end
	end
	return nil
end

game.Players.PlayerRemoving:Connect(function(player)
	saveBakeryToFramework(player)
	didLoadPlayers[player.Name] = nil
	freeBakeryLocation(player)
end)

local function attachOwnershipEvents()

	-- attach ownership events
	--[[
	game.Players.PlayerAdded:Connect(initializePlayerBakery)
	for i, v in ipairs(game.Players:GetPlayers()) do
		initializePlayerBakery(v)
	end
	]]
	
	-- attach deownership events
	--game.Players.PlayerRemoving:Connect(freeBakeryLocation)
	coroutine.wrap(function()
		-- scan for missing players, wipe data
		while wait(5) do
			for i, v in ipairs(bakeryLocationParts) do
				if v.owner and not game.Players:FindFirstChild(v.owner.Name) then
					v.owner = nil
				end
			end
			for playerName, data in pairs(_L.Variables.UIDData) do
				if not game.Players:FindFirstChild(playerName) then
					_L.Variables.UIDData[playerName] = nil
				end
			end
		end
	end)()
	
end

attachOwnershipEvents()
