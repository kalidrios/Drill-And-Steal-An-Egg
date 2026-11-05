--!strict
--[[
	PlotServer.luau
	Serviço de gerenciamento de plots do servidor (Velvet Framework).
	Atribui plots exclusivos para jogadores, atualiza as placas com foto/nome,
	teleporta para o spawn do plot e replica o estado aos clientes.
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local PlotServer = {}
local Network: any = nil
local Library: any = nil

local ownerOf: { [number]: Player } = {}
local plotOf: { [Player]: number } = {}
local revision: number = 0

local PLOT_IDS = { 1, 2, 3, 4, 5, 6 }

local function getPlotsFolder(): Folder?
	local map = Workspace:FindFirstChild("Map")
	if map then
		local lobby = map:FindFirstChild("Lobby")
		if lobby then
			local plots = lobby:FindFirstChild("Plots")
			if plots and plots:IsA("Folder") then
				return plots
			end
		end
	end
	
	-- Fallback caso esteja direto no Workspace
	local directPlots = Workspace:FindFirstChild("Plots")
	if directPlots and directPlots:IsA("Folder") then
		return directPlots
	end
	
	return nil
end

local function getPlotModel(plotId: number): Model?
	local plotsFolder = getPlotsFolder()
	if not plotsFolder then return nil end
	
	local found = plotsFolder:FindFirstChild(tostring(plotId))
	if found and (found:IsA("Model") or found:IsA("Folder")) then
		return found :: any
	end
	
	for _, child in ipairs(plotsFolder:GetChildren()) do
		if tonumber(child.Name) == plotId then
			return child :: any
		end
	end
	return nil
end

local function getPlotSpawn(plot: Instance): BasePart?
	local directSpawn = plot:FindFirstChild("Spawn") or plot:FindFirstChild("SpawnPoint")
	if directSpawn and directSpawn:IsA("BasePart") then
		return directSpawn
	end
	
	local toUpdate = plot:FindFirstChild("ToUpdate")
	if toUpdate then
		local nestedSpawn = toUpdate:FindFirstChild("Spawn") or toUpdate:FindFirstChild("SpawnPoint")
		if nestedSpawn and nestedSpawn:IsA("BasePart") then
			return nestedSpawn
		end
		for _, child in ipairs(toUpdate:GetChildren()) do
			if child:IsA("BasePart") and string.find(string.lower(child.Name), "spawn") then
				return child
			end
		end
	end
	
	return nil
end

local function snapshot(): { [string]: number }
	local owners = {}
	for plotId, player in pairs(ownerOf) do
		owners[tostring(plotId)] = player.UserId
	end
	return owners
end

local function broadcastSlot(plotId: number, userIdOrNil: number?)
	revision += 1
	if Network then
		Network.Fire("Plots_StateUpdate", {
			Revision = revision,
			Slot = plotId,
			UserId = userIdOrNil,
		})
	end
end

local function setPlotSignOwner(plotId: number, player: Player)
	local plot = getPlotModel(plotId)
	if not plot then return end
	
	local sign = plot:FindFirstChild("PlotSign")
	local playerSign = sign and sign:FindFirstChild("PlayerPlotSign")
	if not playerSign or not playerSign:IsA("BillboardGui") then return end
	
	local frame = playerSign:FindFirstChild("Frame")
	if frame then
		local nameLabel = frame:FindFirstChild("PlayerName")
		local icon = frame:FindFirstChild("PlayerIcon")
		if nameLabel and nameLabel:IsA("TextLabel") then
			nameLabel.Text = player.DisplayName
		end
		if icon and icon:IsA("ImageLabel") then
			icon.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"
		end
	end
	playerSign.Enabled = true
end

local function clearPlotSignOwner(plotId: number)
	local plot = getPlotModel(plotId)
	if not plot then return end
	
	local sign = plot:FindFirstChild("PlotSign")
	local playerSign = sign and sign:FindFirstChild("PlayerPlotSign")
	if not playerSign or not playerSign:IsA("BillboardGui") then return end
	
	local frame = playerSign:FindFirstChild("Frame")
	if frame then
		local nameLabel = frame:FindFirstChild("PlayerName")
		local icon = frame:FindFirstChild("PlayerIcon")
		if nameLabel and nameLabel:IsA("TextLabel") then
			nameLabel.Text = "Available"
		end
		if icon and icon:IsA("ImageLabel") then
			icon.Image = ""
		end
	end
	playerSign.Enabled = false
end

local function teleportToSpawn(player: Player, plotId: number)
	local plot = getPlotModel(plotId)
	if not plot then return end
	
	local spawnPart = getPlotSpawn(plot)
	if not spawnPart then return end
	
	local character = player.Character
	local hrp = character and character:FindFirstChild("HumanoidRootPart")
	if hrp and hrp:IsA("BasePart") then
		hrp.CFrame = spawnPart.CFrame + Vector3.new(0, 4, 0)
	end
end

function PlotServer.GetPlotId(player: Player): number?
	return plotOf[player]
end

function PlotServer.GetPlotOwner(plotId: number): Player?
	return ownerOf[plotId]
end

function PlotServer.AssignPlot(player: Player)
	if plotOf[player] then
		return
	end
	
	local freeId: number? = nil
	for _, id in ipairs(PLOT_IDS) do
		if not ownerOf[id] then
			freeId = id
			break
		end
	end
	
	if not freeId then
		warn("[PlotServer] Nenhum plot livre para " .. player.Name .. " (servidor lotado)")
		return
	end
	
	ownerOf[freeId] = player
	plotOf[player] = freeId
	player:SetAttribute("PlotId", freeId)
	
	local plot = getPlotModel(freeId)
	if plot then
		plot:SetAttribute("OwnerUserId", player.UserId)
	end
	
	setPlotSignOwner(freeId, player)
	broadcastSlot(freeId, player.UserId)
	
	print(string.format("[PlotServer] Plot %d atribuído com sucesso para %s (%d)", freeId, player.Name, player.UserId))
	
	task.defer(function()
		teleportToSpawn(player, freeId)
	end)
end

function PlotServer.FreePlot(player: Player)
	local plotId = plotOf[player]
	if not plotId then return end
	
	local plot = getPlotModel(plotId)
	if plot then
		plot:SetAttribute("OwnerUserId", nil)
	end
	
	ownerOf[plotId] = nil
	plotOf[player] = nil
	player:SetAttribute("PlotId", nil)
	
	clearPlotSignOwner(plotId)
	broadcastSlot(plotId, nil)
	print(string.format("[PlotServer] Plot %d liberado após saída de %s", plotId, player.Name))
end

function PlotServer.Start(frameworkLibrary: any)
	Library = frameworkLibrary
	Network = Library.Network
	
	-- Configurar Remotes
	if Network then
		local reqFunc = Network.Invoked("Plots_RequestState")
		if reqFunc then
			reqFunc.OnServerInvoke = function(_player: Player)
				return {
					Revision = revision,
					OwnersBySlot = snapshot(),
				}
			end
		end
		
		Network.Fired("Plots_RequestTeleport"):Connect(function(player: Player)
			local plotId = plotOf[player]
			if plotId then
				teleportToSpawn(player, plotId)
			end
		end)
	end
	
	-- Conectar Spawn do Personagem
	local function hookCharacter(player: Player)
		player.CharacterAdded:Connect(function(character)
			character:WaitForChild("HumanoidRootPart", 10)
			local plotId = plotOf[player]
			if plotId then
				teleportToSpawn(player, plotId)
			end
		end)
	end
	
	-- Atribuir Plots para quem já estiver no jogo
	for _, player in ipairs(Players:GetPlayers()) do
		hookCharacter(player)
		PlotServer.AssignPlot(player)
	end
	
	-- Atribuir ao entrar
	Players.PlayerAdded:Connect(function(player: Player)
		hookCharacter(player)
		PlotServer.AssignPlot(player)
	end)
	
	-- Liberar ao sair
	Players.PlayerRemoving:Connect(function(player: Player)
		PlotServer.FreePlot(player)
	end)
	
	print("[PlotServer] Serviço de Plots iniciado com sucesso!")
end

return PlotServer
