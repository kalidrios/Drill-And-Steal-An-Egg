-- ServerScriptService.Controllers.SettingsService
-- Handles "Settings: Request Update" (RemoteFunction). Contract confirmed by reading
-- ReplicatedStorage.Library.Client.SettingsCmds.Set in full: client sends (key: string,
-- value: boolean) and expects (ok: boolean, updatedSettingsMap: table?) back -- when the
-- second value is a table, SettingsCmds re-syncs its whole local cache from it instead of
-- optimistically patching just the one key.
--
-- BUG FIX (user report: the Settings GUI buttons -- Music, Trading, Hide Other Pets, Disable
-- Videos -- didn't do anything when clicked). Root cause: StubService explicitly FAILed this
-- remote ("Settings / Robux products -- not built", see that module's HANDLERS table) and no
-- real handler ever replaced it, so every SettingsCmds.Set() call failed silently. Settings
-- are already fully modeled everywhere else -- Variables.SettingsInfo defines the valid keys/
-- defaults, DefaultStats/Database/SchemaFields already persist a profile.Settings table, and
-- the client-side consumers (ActiveAssetsController's HideOtherPets, TreadmillUI's
-- DisableVideos) are fully wired to react the moment the value changes -- only this remote
-- was missing.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Database = require(game.ServerScriptService.Library.Database)
local Variables = require(ReplicatedStorage.Library.Shared.Variables)

local Network = ReplicatedStorage:WaitForChild("Network")
local RequestUpdateRemote = Network:WaitForChild("Settings: Request Update")

local SettingsInfo = Variables.SettingsInfo

local SettingsService = {}

RequestUpdateRemote.OnServerInvoke = function(player, key, value)
	if typeof(key) ~= "string" or not SettingsInfo[key] then
		return false, "Unknown setting"
	end
	if typeof(value) ~= "boolean" then
		return false, "Invalid value"
	end

	local profile = Database.Get(player)
	if not profile then
		return false, "Profile not loaded"
	end

	profile.Settings = profile.Settings or {}
	profile.Settings[key] = value
	Database.Set(player, { Settings = profile.Settings })

	return true, profile.Settings
end

return SettingsService