local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local LootService -- lazy

local TimerBoardService = {}

-- Durations in seconds
local DURATIONS = {
	Legendary = 600,  -- 10m
	Mythic = 600,     -- 10m
	Secret = 1800,    -- 30m
	Godly = 3600      -- 60m
}

-- Spawn positions under the respective headers
local SPAWN_POSITIONS = {
	Legendary = Vector3.new(-23.1, -1.5, 72.0),
	Mythic = Vector3.new(-5.9, -1.5, 72.0),
	Secret = Vector3.new(11.3, -1.5, 72.0),
	Godly = Vector3.new(28.5, -1.5, 72.0)
}

local function FormatTime(seconds)
	local minutes = math.floor(seconds / 60)
	local secs = seconds % 60
	if minutes > 0 then
		return string.format("%dm %ds", minutes, secs)
	else
		return string.format("%ds", secs)
	end
end

function TimerBoardService.Start(self)
	LootService = require(ServerScriptService.Server.Services.LootService)

	local board = workspace:WaitForChild("Map", 5)
		and workspace.Map:WaitForChild("Timerboard", 5)
		and workspace.Map.Timerboard:WaitForChild("TimerBoard", 5)

	if not board then
		warn("[TimerBoardService]: TimerBoard model not found on the map!")
		return
	end

	local display = board:WaitForChild("Display", 5)
	local surfaceGui = display and display:WaitForChild("SurfaceGui", 5)
	if not surfaceGui then
		warn("[TimerBoardService]: SurfaceGui not found under Display!")
		return
	end

	-- Initialize active timers
	local activeTimers = {
		Legendary = DURATIONS.Legendary,
		Mythic = DURATIONS.Mythic,
		Secret = DURATIONS.Secret,
		Godly = DURATIONS.Godly
	}

	-- Update loop
	task.spawn(function()
		while true do
			task.wait(1)
			for rarity, timeRemaining in pairs(activeTimers) do
				timeRemaining -= 1
				if timeRemaining <= 0 then
					-- Reset timer
					timeRemaining = DURATIONS[rarity]
					
					-- Spawn rare artifact
					pcall(function()
						LootService.SpawnGlobalLoot(rarity, SPAWN_POSITIONS[rarity])
						print("[TimerBoardService]: Spawned public " .. rarity .. " artifact")
					end)
				end
				activeTimers[rarity] = timeRemaining

				-- Update Text Label on board
				local frame = surfaceGui:FindFirstChild(rarity)
				local title = frame and frame:FindFirstChild("Title")
				if title then
					title.Text = string.format("%s Spawning in: %s", rarity, FormatTime(timeRemaining))
				end
			end
		end
	end)

	print("[TimerBoardService]: Started")
end

return TimerBoardService
