-- ServerScriptService.Controllers.PlotService
-- Assigns Workspace.Plots.<1..7> to players, keeps ReplicatedStorage.Network's
-- "Plots: *" remotes in sync (contract confirmed by reading Library.Types.Plots +
-- Library.Client.PlotCmds directly), and handles base upgrades.

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Database = require(game.ServerScriptService.Library.Database)

local Network = ReplicatedStorage:WaitForChild("Network")
local RequestStateRemote = Network:WaitForChild("Plots: RequestState")
local StateUpdateRemote = Network:WaitForChild("Plots: StateUpdate")
local RequestBaseUpgradeRemote = Network:WaitForChild("Plots: RequestBaseUpgrade")
local OnBaseUpgradedRemote = Network:WaitForChild("Plots: OnBaseUpgraded")
local RequestLobbyTeleportRemote = Network:WaitForChild("Plots: RequestLobbyTeleport")

local PlotsFolder = Workspace:WaitForChild("Plots")

local PLOT_IDS = { 1, 2, 3, 4, 5, 6, 7 }

-- Cost/MaxAssets per base level, copied literally from ReplicatedStorage.Directory.Bases
-- (that module errors on require() -- it looks for ServerStorage.Assets.Models.Bases.Main,
-- which doesn't exist in this rip; see memory).
local BASE_TIERS = {
	[0] = { Cost = 0, MaxAssets = 7 },
	[1] = { Cost = 1000, MaxAssets = 7 },
	[2] = { Cost = 1000000, MaxAssets = 9 },
	[3] = { Cost = 75000000, MaxAssets = 10 },
	[4] = { Cost = 500000000, MaxAssets = 11 },
	[5] = { Cost = 1000000000, MaxAssets = 12 },
	[6] = { Cost = 50000000000, MaxAssets = 13 },
	[7] = { Cost = 500000000000, MaxAssets = 14 },
	[8] = { Cost = 1000000000000, MaxAssets = 15 },
	[9] = { Cost = 25000000000000, MaxAssets = 16 },
	[10] = { Cost = 100000000000000, MaxAssets = 17 },
	[11] = { Cost = 500000000000000, MaxAssets = 18 },
}
local MAX_BASE_LEVEL = 11

local PlotService = {}

local ownerOf = {} -- [plotId] = player
local plotOf = {} -- [player] = plotId
local revision = 0

local function plotModel(plotId)
	local plot = PlotsFolder:FindFirstChild(tostring(plotId))
	if plot then
		return plot
	end
	for _, candidate in ipairs(PlotsFolder:GetChildren()) do
		if candidate:IsA("Model") and tonumber(candidate.Name) == plotId then
			return candidate
		end
	end
	return nil
end

local function snapshot()
	local owners = {}
	for plotId, player in pairs(ownerOf) do
		owners[tostring(plotId)] = player.UserId
	end
	return owners
end

local function broadcastSlot(plotId, userIdOrNil)
	revision += 1
	StateUpdateRemote:FireAllClients({
		Revision = revision,
		Slot = plotId,
		UserId = userIdOrNil,
	})
end

local function setPlotSignOwner(plotId, player)
	local plot = plotModel(plotId)
	if not plot then
		return
	end
	local sign = plot:FindFirstChild("PlotSign")
	local playerSign = sign and sign:FindFirstChild("PlayerPlotSign")
	if not playerSign then
		return
	end
	local frame = playerSign:FindFirstChild("Frame")
	if frame then
		local nameLabel = frame:FindFirstChild("PlayerName")
		local icon = frame:FindFirstChild("PlayerIcon")
		if nameLabel then
			nameLabel.Text = player.DisplayName
		end
		if icon then
			icon.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=48&h=48"
		end
	end
	playerSign.Enabled = true
end

local function clearPlotSignOwner(plotId)
	local plot = plotModel(plotId)
	if not plot then
		return
	end
	local sign = plot:FindFirstChild("PlotSign")
	local playerSign = sign and sign:FindFirstChild("PlayerPlotSign")
	if not playerSign then
		return
	end
	local frame = playerSign:FindFirstChild("Frame")
	if frame then
		local nameLabel = frame:FindFirstChild("PlayerName")
		local icon = frame:FindFirstChild("PlayerIcon")
		if nameLabel then
			nameLabel.Text = ""
		end
		if icon then
			icon.Image = ""
		end
	end
	playerSign.Enabled = false
end

local function teleportToSpawn(player, plotId)
	local plot = plotModel(plotId)
	local spawnPoint = plot and plot:FindFirstChild("SpawnPoint")
	if not spawnPoint then
		return
	end
	local character = player.Character
	local hrp = character and character:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.CFrame = spawnPoint.CFrame + Vector3.new(0, 5, 0)
	end
end

function PlotService.GetPlotId(player)
	return plotOf[player]
end

local function assignPlot(player)
	if plotOf[player] then
		return
	end
	local freeId = nil
	for _, plotId in ipairs(PLOT_IDS) do
		if not ownerOf[plotId] then
			freeId = plotId
			break
		end
	end
	if not freeId then
		warn("[PlotService] No free plot for " .. player.Name .. " (server full)")
		return
	end
	ownerOf[freeId] = player
	plotOf[player] = freeId
	setPlotSignOwner(freeId, player)
	broadcastSlot(freeId, player.UserId)

	local function onCharacterAdded(character)
		local humanoid = character:WaitForChild("Humanoid", 5)
		character:WaitForChild("HumanoidRootPart", 5)
		teleportToSpawn(player, freeId)
	end
	player.CharacterAdded:Connect(onCharacterAdded)
	if player.Character then
		onCharacterAdded(player.Character)
	end
end

local function freePlot(player)
	local plotId = plotOf[player]
	if not plotId then
		return
	end
	ownerOf[plotId] = nil
	plotOf[player] = nil
	clearPlotSignOwner(plotId)
	broadcastSlot(plotId, nil)
end

Database.OnLoaded(function(player)
	local ok, err = pcall(assignPlot, player)
	if not ok then
		warn("[PlotService] Failed to assign plot to " .. player.Name .. ": " .. tostring(err))
	end
end)

for _, player in ipairs(Players:GetPlayers()) do
	if Database.IsPlayerLoaded(player) then
		task.defer(assignPlot, player)
	end
end

Players.PlayerRemoving:Connect(function(player)
	freePlot(player)
end)

RequestStateRemote.OnServerInvoke = function(_player)
	return {
		Revision = revision,
		OwnersBySlot = snapshot(),
	}
end

RequestBaseUpgradeRemote.OnServerEvent:Connect(function(player)
	local profile = Database.Get(player)
	if not profile then
		return
	end
	local nextLevel = (profile.BaseUpgradeLevel or 0) + 1
	if nextLevel > MAX_BASE_LEVEL then
		return
	end
	local tier = BASE_TIERS[nextLevel]
	if not tier then
		return
	end
	if (profile.Money or 0) < tier.Cost then
		return
	end
	Database.SetAndBroadcast(player, {
		Money = profile.Money - tier.Cost,
		BaseUpgradeLevel = nextLevel,
	})
	OnBaseUpgradedRemote:FireClient(player)
end)

RequestLobbyTeleportRemote.OnServerEvent:Connect(function(player)
	local plotId = plotOf[player]
	if plotId then
		teleportToSpawn(player, plotId)
	end
end)

return PlotService
