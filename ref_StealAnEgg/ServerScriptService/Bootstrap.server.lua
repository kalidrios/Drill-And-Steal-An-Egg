local ServerScriptService = game:GetService("ServerScriptService")
local function safeRequire(moduleScript)
	local ok, err = pcall(require, moduleScript)
	if not ok then warn("[Bootstrap] Failed to require " .. moduleScript:GetFullName() .. ": " .. tostring(err)) end
	return ok
end
warn("[Bootstrap] Starting server initialization...")
local library = ServerScriptService:WaitForChild("Library")
safeRequire(library:WaitForChild("Database"))
local controllers = ServerScriptService:WaitForChild("Controllers")
local order = {"PlotService", "SpeedService", "LeaderstatsService", "GamepassService", "TreadmillService", "TreadmillGamepassService", "SpeedBoostGamepassService", "ConsumableGamepassService", "GroupRewardService", "TreadmillGrindService", "TreadmillSpawnService", "EggService", "AreaEggService", "AssetService", "OfflineAssetsService", "IndexService", "FuseMachineService", "AmonetizationPurchaseService", "GuardTutorialService", "SettingsService", "StubService"}
for _, name in ipairs(order) do
	local module = controllers:FindFirstChild(name)
	if module then safeRequire(module) else warn("[Bootstrap] Missing controller: " .. name) end
end
warn("[Bootstrap] Server initialization complete.")
