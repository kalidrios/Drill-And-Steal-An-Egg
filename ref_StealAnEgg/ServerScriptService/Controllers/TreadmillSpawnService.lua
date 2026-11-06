-- ServerScriptService.Controllers.TreadmillSpawnService
-- Spawns the actual visual treadmill model on each player's plot server-side.
-- The original client-side render pipeline (StarterPlayerScripts.Game.Plots.TreadmillStaticController)
-- has silent failures in this rip that leave the treadmill model missing even though the
-- upgrade sign and grind service both work. This module bypasses that: whenever a player
-- with BaseUpgradeLevel > 0 owns a plot, we clone the correct treadmill Tool for their
-- TreadmillUpgradeLevel and pivot it onto the plot's TreadmillBottom part. Rebuilds on
-- upgrade. Cleans up on leave. Visible to every player, which is fine because everyone
-- can already see each other's plots.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local ServerScriptService = game:GetService("ServerScriptService")

local Database = require(ServerScriptService.Library.Database)
local PlotService = require(ServerScriptService.Controllers.PlotService)
local Treadmills = require(ReplicatedStorage.Directory.Treadmills)
local TreadmillUtil = require(ReplicatedStorage.Library.Util.TreadmillUtil)

local TreadmillModels = ReplicatedStorage.Assets.Models.Treadmills
local PlotsFolder = Workspace:WaitForChild("Plots")

local TreadmillSpawnService = {}

-- Container the spawned treadmills live in. Kept out of the plot itself so the plot's
-- own child-list stays untouched (PlotService and the ripped client scripts iterate it).
local spawnedFolder = Workspace:FindFirstChild("__ServerTreadmillRenders")
if not spawnedFolder then
	spawnedFolder = Instance.new("Folder")
	spawnedFolder.Name = "__ServerTreadmillRenders"
	spawnedFolder.Parent = Workspace
end

local activeByPlot = {} -- [plotId] = { model = Tool, treadmillId = string }

local function destroySpawn(plotId)
	local entry = activeByPlot[plotId]
	if not entry then return end
	activeByPlot[plotId] = nil
	if entry.model and entry.model.Parent then
		entry.model:Destroy()
	end
end

local function findTreadmillBottom(plotId)
	local plot = PlotsFolder:FindFirstChild(tostring(plotId))
	if not plot then return nil end
	local bottom = plot:FindFirstChild("TreadmillBottom")
	if bottom and bottom:IsA("BasePart") then return bottom end
	return nil
end

local function buildTreadmill(plotId, treadmillId)
	local template = TreadmillModels:FindFirstChild(treadmillId)
	if not template then
		warn("[TreadmillSpawnService] No model for treadmill '" .. tostring(treadmillId) .. "'")
		return nil
	end

	local bottom = findTreadmillBottom(plotId)
	if not bottom then
		warn("[TreadmillSpawnService] Plot " .. tostring(plotId) .. " has no TreadmillBottom")
		return nil
	end

	local clone = template:Clone()
	clone.Name = "ServerTreadmill_" .. tostring(plotId)

	-- Anchor every part so it doesn't fall; disable collision so players walk over it (they
	-- run on the invisible TreadmillBottom trigger, not on the visual mesh); disable touch
	-- so we don't accidentally trigger the Grind service off the visual pieces. Kill any
	-- BaseScripts baked into the Tool so its old client logic doesn't run twice.
	for _, desc in ipairs(clone:GetDescendants()) do
		if desc:IsA("BasePart") then
			desc.Anchored = true
			desc.CanCollide = false
			desc.CanTouch = false
			desc.CanQuery = true
		elseif desc:IsA("BaseScript") then
			desc:Destroy()
		end
	end

	clone.Parent = spawnedFolder

	-- Pivot the model so its Root part sits grounded on the TreadmillBottom, matching how
	-- the client controller placed it. Uses the same utility so the alignment matches.
	local root = clone:FindFirstChild("Root")
	if root and root:IsA("BasePart") then
		local ok, target = pcall(TreadmillUtil.ResolveGroundedToolRootCFrameAtLocation, bottom, clone)
		if ok and target then
			local pivot = clone:GetPivot()
			local rootToPivot = pivot:ToObjectSpace(root.CFrame)
			clone:PivotTo(target * rootToPivot:Inverse())
		else
			-- Fallback: put the model directly above the bottom part.
			clone:PivotTo(bottom.CFrame * CFrame.new(0, 3, 0))
		end
	else
		clone:PivotTo(bottom.CFrame * CFrame.new(0, 3, 0))
	end

	return clone
end

local function refreshForPlayer(player)
	if not player or not player.Parent then return end
	local plotId = PlotService.GetPlotId(player)
	if not plotId then return end

	local profile = Database.Get(player)
	if not profile then return end

	local baseLevel = tonumber(profile.BaseUpgradeLevel) or 0
	if baseLevel <= 0 then
		destroySpawn(plotId)
		return
	end

	local upgradeLevel = math.max(1, math.floor(tonumber(profile.TreadmillUpgradeLevel) or 1))
	local config = Treadmills.GetByUpgradeLevel(upgradeLevel)
	if not config then
		warn("[TreadmillSpawnService] No treadmill config for level " .. tostring(upgradeLevel))
		destroySpawn(plotId)
		return
	end

	local existing = activeByPlot[plotId]
	if existing and existing.treadmillId == config._id and existing.model and existing.model.Parent then
		return -- already up to date
	end

	destroySpawn(plotId)

	local model = buildTreadmill(plotId, config._id)
	if model then
		activeByPlot[plotId] = { model = model, treadmillId = config._id }
	end
end

local function refreshForPlot(plotId)
	if not plotId then return end
	for _, player in ipairs(Players:GetPlayers()) do
		if PlotService.GetPlotId(player) == plotId then
			refreshForPlayer(player)
			return
		end
	end
	destroySpawn(plotId)
end

-- Initial spawn as each player's data finishes loading.
Database.OnLoaded(function(player)
	task.defer(function()
		-- Wait a moment for PlotService to assign the plot (both are triggered by OnLoaded,
		-- but PlotService is registered first in Bootstrap so we usually land after it).
		for _ = 1, 30 do
			if PlotService.GetPlotId(player) then break end
			task.wait(0.1)
		end
		refreshForPlayer(player)
	end)
end)

-- Rebuild when upgrades change.
Database.OnFieldChanged("TreadmillUpgradeLevel", function(player)
	task.defer(refreshForPlayer, player)
end)
Database.OnFieldChanged("BaseUpgradeLevel", function(player)
	task.defer(refreshForPlayer, player)
end)

Players.PlayerRemoving:Connect(function(player)
	local plotId = PlotService.GetPlotId(player)
	if plotId then destroySpawn(plotId) end
end)

-- Retry pass in case any player's plot assignment happened before this module loaded.
task.defer(function()
	task.wait(1)
	for _, player in ipairs(Players:GetPlayers()) do
		if Database.IsPlayerLoaded(player) then
			refreshForPlayer(player)
		end
	end
end)

return TreadmillSpawnService
