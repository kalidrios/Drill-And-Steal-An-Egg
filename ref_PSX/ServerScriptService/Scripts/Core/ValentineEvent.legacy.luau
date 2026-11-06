--[[
    Valentine's Day Event - Heart Pile Meteor Spawner
    Spawns Heart Pile coins randomly across all areas in the Spawn world,
    similar to the Comet system. Announces in chat when spawning.
    
    By: @pggondim     
--]]

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do game:GetService("RunService").Heartbeat:Wait() end

--------|    Variables    |--------
local Settings = _L.Settings
local SpawnAreas = { "Town", "Forest", "Beach", "Mine", "Winter", "Glacier", "Desert", "Volcano" }
local SPAWN_INTERVAL_MIN = 300  -- 5 minutes
local SPAWN_INTERVAL_MAX = 600  -- 10 minutes

--------------------------------------------------------------------------------------------------------


--------|  Cozy Cove Gate  |--------
local EGG_NAME = "Valentines Egg"
local EGG_REQUIRED = 100

_L.Network.Invoked("Unlock Cozy Cove").OnInvoke = function(plyr)
	local save = _L.Saving.Get(plyr)
	if not save then
		return false, "Failed to get save."
	end

	if _L.Worlds.HasArea(plyr, "Cozy Cove") then
		return true -- Already unlocked
	end

	local eggsOpened = (_L.Shared.IsHardcore and save.Hardcore.EggsOpened or save.EggsOpened)[EGG_NAME] or 0
	if eggsOpened < EGG_REQUIRED then
		return false, "You need to open " .. (EGG_REQUIRED - eggsOpened) .. " more Valentines Boxes to unlock Cozy Cove!"
	end

	_L.Worlds.GiveArea(plyr, "Cozy Cove")
	return true
end

-- Only run Heart Pile spawner if ValentineEvent is enabled
if not Settings.ValentineEvent then return end

-- Wait for server to fully initialize
task.wait(15)

print("[ValentineEvent] Heart Pile meteor spawner started!")

while true do
    local waitTime = math.random(SPAWN_INTERVAL_MIN, SPAWN_INTERVAL_MAX)
    task.wait(waitTime)
    
    -- Pick a random area to spawn the Heart Pile
    local areaName = SpawnAreas[math.random(1, #SpawnAreas)]
    
    -- Get the area display name from the Directory
    local areaDir = _L.Directory.Areas[areaName]
    local displayName = areaDir and areaDir.name or areaName
    
    -- Announce in chat to all players (pink/valentine color)
    local valentineColor = Color3.fromRGB(255, 105, 140)
    _L.Network.FireAll("Valentine: Heart Pile Incoming", areaName, displayName)
    
    -- Wait a few seconds for the announcement to be seen
    task.wait(5)
    
    -- Spawn the Heart Pile as a coin in the selected area
    local success, err = pcall(function()
        _L.Coins.Create("Spawn", areaName, "Heart Pile")
    end)
    
    if success then
        print("[ValentineEvent] Heart Pile spawned in " .. areaName)
    else
        warn("[ValentineEvent] Failed to spawn Heart Pile in " .. areaName .. ": " .. tostring(err))
    end
end
