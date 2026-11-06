--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do  game:GetService("RunService").Heartbeat:Wait()  end

--------|     Modules     |--------
local Analytics = {}
local Encrypt = require(script:WaitForChild("Encryption"))
local Authentication = require(script:WaitForChild("Authentication"))

--------|     Settings     |--------
-- the identifier of the database collection.  must be unique for each game, and must
-- be manually created on MongoDB Atlas once for each game
local MONGODB_COLLECTION_NAME = "psx"
local WRITE_ACTIONS_INTERVAL = 5*60 -- MUST be in-sync with Heroku

--------|     Source     |--------
local incrementCache = {}
local joinedPlayersSincePush = 0
local joinedPlayersSincePushLanguage = {}
local joinedPlayersSincePushDevice = {}
local newPlayersSincePush = 0
local newPlayersSincePushLanguage = {}
local newPlayersSincePushDevice = {}
local playerJoinedTimes = {}
local playerJoinedTimesLeft = {}
local lastWriteTime = tick()
local playerDevices = {}
local playerFramerates = {}
local playerLanguages = {}
local isStudio = _L.Services.RunService:IsStudio()


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local function languageKeyFromPlayer(player)
	return playerLanguages[player.Name] or nil
end

local function deviceKeyFromPlayer(player)
	return playerDevices[player.Name] or nil
end

function Analytics.BuildQueryString(queryParams)
	local queryString = "?"
	for k, v in pairs(queryParams) do
		queryString = queryString .. (
			_L.Services.HttpService:UrlEncode(k) ..
			"=" ..
			_L.Services.HttpService:UrlEncode(v) ..
			"&"
		)
	end
	return queryString:sub(1, queryString:len() - 1)
end

function Analytics.SendWriteRequest(queryParams, body, callback)
	
	body = _L.Services.HttpService:JSONEncode(body)
	
	local BASE_URL = "http://big-analytics.herokuapp.com/write/"
	
	queryParams["TS"] = math.floor(tick())
	queryParams["baseURL"] = BASE_URL
	queryParams["PBLC"] = Authentication.WRITE_KEY_PUBLIC
	
	--- Wrapped in a pcall just in case
	local response
	local success = pcall(function()
		local authString = Authentication.EncodeAuthenticationString(queryParams)
		response = _L.Services.HttpService:RequestAsync({
			Url = BASE_URL .. Analytics.BuildQueryString(queryParams),
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
				["Authorization"] = authString
			},
			Body = body  
		})
	end)
	
	if callback then
		callback(response)
	end
end

function Analytics.Increment(key, value)
	if type(key) ~= "string" then
		_L.Print("Increment key must be of type 'string', got type '" .. type(key) .. "'", true)
		return
	end
	if type(value) ~= "number" then
		_L.Print("Increment value must be of type 'number', got type '" .. type(value) .. "'", true)
		return
	end
	
	table.insert(incrementCache, {
		[key] = value
	})
end

function Analytics.IncrementWithLanguage(key, value, player)
	if not languageKeyFromPlayer(player) then
		return
	end
	local languageKey = key .. "_" .. languageKeyFromPlayer(player)
	Analytics.Increment(languageKey, value)
end

function Analytics.IncrementWithDevice(key, value, player)
	if not playerDevices[player.Name] then
		return
	end
	local deviceKey = key .. "_" .. playerDevices[player.Name]
	Analytics.Increment(deviceKey, value)
end

local deepcopy
function deepcopy(t)
	local copy = {}
	for k, v in pairs(t) do
		copy[k] = (type(v) == "table") and deepcopy(v) or v
	end
	return copy
end

-- merges the entire array of incrementKeys, so we don't
-- send all of the data to Heroku and flood it
local function mergeIncrementKeys(t)
	local merged = {}
	for _, keyset in ipairs(t) do
		for key, value in pairs(keyset) do
			if not merged[key] then
				merged[key] = 0
			end
			merged[key] = merged[key] + value
		end
	end
	return merged
end

local function performIncrementPush()
	
	local mergedKeys = mergeIncrementKeys(incrementCache)
	incrementCache = {}
	
	local joinedPlayerSessions = joinedPlayersSincePush
	joinedPlayersSincePush = 0
	
	local newPlayerSessions = newPlayersSincePush
	newPlayersSincePush = 0
	
	local query = {
		writeType = "INCREMENT";
		SID = game.JobId;
		COL = MONGODB_COLLECTION_NAME;
	}
	
	local body = {
		incrementKeys = mergedKeys;
	}
		
	-- count concurrent players
	local plrs = game.Players:GetPlayers()
	mergedKeys.PC = #plrs
	for i, v in ipairs(plrs) do
		if v then
			local languageID = languageKeyFromPlayer(v)
			local deviceID   = deviceKeyFromPlayer(v)
			
			-- count concurrent players by language
			if languageID then
				local languageKeyPC = string.format("PC_%s", languageID)
				if not mergedKeys[languageKeyPC] then
					mergedKeys[languageKeyPC] = 0
				end
				mergedKeys[languageKeyPC] = mergedKeys[languageKeyPC] + 1
			end
			
			-- count concurrent players by device			
			if deviceID then
				local deviceKeyPC = string.format("PC_%s", deviceID)	
				if not mergedKeys[deviceKeyPC] then
					mergedKeys[deviceKeyPC] = 0
				end
				mergedKeys[deviceKeyPC] = mergedKeys[deviceKeyPC] + 1
			end
		end
	end
	
	-- count sessions, also by language & device
	mergedKeys.SES = joinedPlayerSessions
	for key, value in pairs(joinedPlayersSincePushLanguage) do
		mergedKeys["SES_" .. key] = value
	end
	for key, value in pairs(joinedPlayersSincePushDevice) do
		mergedKeys["SES_" .. key] = value
	end
	joinedPlayersSincePushLanguage = {}
	joinedPlayersSincePushDevice = {}
	
	-- count new players, also by language & device
	mergedKeys.NEW = newPlayerSessions
	for key, value in pairs(newPlayersSincePushLanguage) do
		mergedKeys["NEW_" .. key] = value
	end
	for key, value in pairs(newPlayersSincePushDevice) do
		mergedKeys["NEW_" .. key] = value
	end
	newPlayersSincePushLanguage = {}
	newPlayersSincePushDevice = {}
	
	-- count total time played (in minutes), also by language & device
	mergedKeys.SUMTIME = 0
	for playerName, timeJoined in pairs(playerJoinedTimes) do
		local player = game.Players:FindFirstChild(playerName)
		if player then
			local timeEntry = math.min((tick() - timeJoined)/60, WRITE_ACTIONS_INTERVAL/60)
			mergedKeys.SUMTIME = mergedKeys.SUMTIME + timeEntry
			if playerLanguages[playerName] then
				local languageKey = string.format("SUMTIME_%s", languageKeyFromPlayer(player))
				if not mergedKeys[languageKey] then
					mergedKeys[languageKey] = 0
				end
				mergedKeys[languageKey] = mergedKeys[languageKey] + timeEntry
			end
			if playerDevices[playerName] then
				local deviceKey = string.format("SUMTIME_%s", deviceKeyFromPlayer(player))
				if not mergedKeys[deviceKey] then
					mergedKeys[deviceKey] = 0
				end
				mergedKeys[deviceKey] = mergedKeys[deviceKey] + timeEntry
			end
		end
	end
	
	-- calculate performance for each user, then take an average that represets
	-- the server average framerate
	local framerateKeyCount = {}
	mergedKeys.PER = 0
	for playerName, framerate in pairs(playerFramerates) do
		mergedKeys.PER = mergedKeys.PER + framerate
		local player = game.Players:FindFirstChild(playerName)
		if player then
			local languageID = languageKeyFromPlayer(player)
			if languageID then
				local languageKey = string.format("PER_%s", languageKeyFromPlayer(player))
				if not mergedKeys[languageKey] then
					mergedKeys[languageKey] = 0
				end
				if not framerateKeyCount[languageKey] then
					framerateKeyCount[languageKey] = 0
				end
				mergedKeys[languageKey] = mergedKeys[languageKey] + framerate
				framerateKeyCount[languageKey] = framerateKeyCount[languageKey] + 1
			end
			local deviceID = deviceKeyFromPlayer(player)
			if deviceID then
				local deviceKey = string.format("PER_%s", deviceID)
				if not mergedKeys[deviceKey] then
					mergedKeys[deviceKey] = 0
				end
				if not framerateKeyCount[deviceKey] then
					framerateKeyCount[deviceKey] = 0
				end
				mergedKeys[deviceKey] = mergedKeys[deviceKey] + framerate
				framerateKeyCount[deviceKey] = framerateKeyCount[deviceKey] + 1
			end
		end
	end
	-- take averages for each performance key
	local divisor = #game.Players:GetPlayers() > 0 and #game.Players:GetPlayers() or 1
	mergedKeys.PER = mergedKeys.PER / divisor
	for key, value in pairs(mergedKeys) do
		if key:find("PER") and key ~= "PER" then
			mergedKeys[key] = mergedKeys[key] / framerateKeyCount[key]
		end
	end
	
	-- players that left the game have an extra entry with
	-- their final contributing time (note: they've been removed
	-- from playerJoinedTimes, and thus have not yet been
	-- accounted for)
	for _, entry in ipairs(playerJoinedTimesLeft) do
		local timeEntry = math.floor(entry.finalTimeEntry)
		mergedKeys.SUMTIME = mergedKeys.SUMTIME + timeEntry
		if entry.languageID then
			local languageKey = string.format("SUMTIME_%s", entry.languageID)
			if not mergedKeys[languageKey] then
				mergedKeys[languageKey] = 0
			end
			mergedKeys[languageKey] = mergedKeys[languageKey] + timeEntry
		end
		if entry.deviceID then
			local deviceKey = string.format("SUMTIME_%s", entry.deviceID)
			if not mergedKeys[deviceKey] then
				mergedKeys[deviceKey] = 0
			end
			mergedKeys[deviceKey] = mergedKeys[deviceKey] + timeEntry
		end
	end
	playerJoinedTimesLeft = {}
	lastWriteTime = tick()

	Analytics.SendWriteRequest(query, body, function(response)
		_L.Print("Sent analytics to server. Got response code: " .. response.StatusCode)
	end)
end

local function startAnalyticsBackground()
	
	if isStudio then
		return
	end
	
	-- main Heroku-writing thread
	coroutine.wrap(function()
		-- CRUCIAL - when we restart servers, we don't want them to be all on
		-- a similar clock cycle.  so wait this random interval to create offsets.
		-- we want the push times as uniformly-distributed as possible
		wait(math.random(WRITE_ACTIONS_INTERVAL))
		while true do
			wait(WRITE_ACTIONS_INTERVAL)
			pcall(function() performIncrementPush() end)
		end
	end)()
	
	-- update player languages every 30 seconds
	coroutine.wrap(function() 
		while wait(30) do
			for _, player in ipairs(game.Players:GetPlayers()) do
				pcall(function()
					coroutine.wrap(function()
						playerLanguages[player.Name] = _L.Network.Invoke("GetPlayerLanguage", player)
					end)()
				end)
			end
		end
	end)()
	
	-- update player devices every two minutes
	coroutine.wrap(function()
		while wait(120) do
			for _, player in ipairs(game.Players:GetPlayers()) do
				coroutine.wrap(function()
					pcall(function()
						playerDevices[player.Name] = _L.Network.Invoke("GetPlayerPlatform", player)
					end)
				end)()
			end
		end
	end)()
	
	-- update player framerates every 10 seconds (MUST be less than
	-- WRITE_ACTIONS_INTERVAL, or else we will get initial values
	-- of zero, which is bad!!!!)  basically, keep this value small
	-- so that we always have a relatively up-to-date framerate when
	-- we push to Heroku
	coroutine.wrap(function()
		while wait(10) do
			for _, player in ipairs(game.Players:GetPlayers()) do
				coroutine.wrap(function()
					pcall(function()
						playerFramerates[player.Name] = _L.Network.Invoke("GetPlayerFramerate", player)
					end)
				end)()
			end
		end
	end)()
	
	local function tallyNewSession(player)
		-- entry in table for accumulated time spent playing
		playerJoinedTimes[player.Name] = math.floor(tick())
		
		-- when the player joins, get their platform.  it   
		-- is later updated every two minutes (controller 
		-- plugged in / disconnected, etc)
		-- wait for client _L to load
		local deviceGetStart = tick()
		wait(2)
		repeat
			wait(5)
			pcall(function()
				playerDevices[player.Name] = _L.Network.Invoke("GetPlayerPlatform", player)
			end)
		until playerDevices[player.Name] or (tick() - deviceGetStart) > 60
		
		pcall(function()
			playerLanguages[player.Name] = _L.Network.Invoke("GetPlayerLanguage", player)
		end)
		
		if not player or not playerDevices[player.Name] or not playerLanguages[player.Name] then
			_L.Print("failed to get device and/or language for player " .. player.Name)
			_L.Print("device: " .. (playerDevices[player.Name] or "nil"))
			_L.Print("language: " .. (playerLanguages[player.Name] or "nil"))
			return
		end
		
		-- tally individual session, with both language and device
		joinedPlayersSincePush = joinedPlayersSincePush + 1
		local languageKey = languageKeyFromPlayer(player)
		if not joinedPlayersSincePushLanguage[languageKey] then
			joinedPlayersSincePushLanguage[languageKey] = 0
		end
		joinedPlayersSincePushLanguage[languageKey] = joinedPlayersSincePushLanguage[languageKey] + 1
		local deviceKey = deviceKeyFromPlayer(player)
		if not joinedPlayersSincePushDevice[deviceKey] then
			joinedPlayersSincePushDevice[deviceKey] = 0
		end
		joinedPlayersSincePushDevice[deviceKey] = joinedPlayersSincePushDevice[deviceKey] + 1
		
		-- tally new player (if necessary) with both language and device
		local save = _L.Saving.Get(player)
		if save and (not save.HasPlayedBefore) then
			newPlayersSincePush = newPlayersSincePush + 1
			if not newPlayersSincePushLanguage[languageKey] then
				newPlayersSincePushLanguage[languageKey] = 0
			end
			newPlayersSincePushLanguage[languageKey] = newPlayersSincePushLanguage[languageKey] + 1
			local deviceKey = deviceKeyFromPlayer(player)
			if not newPlayersSincePushDevice[deviceKey] then
				newPlayersSincePushDevice[deviceKey] = 0
			end
			newPlayersSincePushDevice[deviceKey] = newPlayersSincePushDevice[deviceKey] + 1
			save.HasPlayedBefore = true
		end
	end
	
	local function cleanupTallyInformation(player)
		table.insert(playerJoinedTimesLeft, {
			languageID = languageKeyFromPlayer(player),
			deviceID = deviceKeyFromPlayer(player),
			finalTimeEntry = math.floor(tick() - lastWriteTime)/60
		})
		playerJoinedTimes[player.Name] = nil
		playerDevices[player.Name] = nil
		playerFramerates[player.Name] = nil
		playerLanguages[player.Name] = nil
	end
	
	-- hook enter/leave events for analytics
	for _, player in ipairs(game.Players:GetPlayers()) do
		coroutine.wrap(function() tallyNewSession(player) end)()
	end
	game.Players.PlayerAdded:Connect(tallyNewSession)
	game.Players.PlayerRemoving:Connect(cleanupTallyInformation)
end

startAnalyticsBackground()


--------|     _L Events     |--------
_L.Signal.Fired("Analytics_Increment"):Connect(Analytics.Increment)
_L.Signal.Fired("Analytics_IncrementWithLanguage"):Connect(Analytics.IncrementWithLanguage)
_L.Signal.Fired("Analytics_IncrementWithDevice"):Connect(Analytics.IncrementWithDevice)
