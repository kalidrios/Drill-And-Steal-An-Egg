--!strict
--[[
    WildEggService.luau
    Spawna ovos nas áreas de cavernas (Cave1 a Cave5) em Spawn.Front e Spawn.Special.
    Quando o jogador interage, ele segura o ovo (carregando).
    Se o jogador apertar a tecla "P" (ou atravessar a safe-zone trigger), o ovo é entregue
    para o inventário do jogador (EggInventory + Tool na mochila).
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local WildEggService = {}
local Library: any = nil
local Network: any = nil

local AreaSpawns = require(ReplicatedStorage:WaitForChild("Directory"):WaitForChild("Areas"):WaitForChild("AreaSpawns"))
local EggsDirectory = ReplicatedStorage:WaitForChild("Directory"):WaitForChild("Eggs")

local carrying: { [Player]: { eggName: string, wildModel: Model? } } = {}
local activeEggsInWorld: { [string]: Model } = {}
local totalSpawnedPerCave: { [string]: number } = {}

-- Cria um container limpo no workspace para os ovos selvagens
local function getWildFolder(): Folder
    local folder = workspace:FindFirstChild("WildEggs")
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = "WildEggs"
        folder.Parent = workspace
    end
    return folder :: Folder
end

-- Escolhe um ovo aleatório baseado nas chances de AreaSpawns
local function pickEggForArea(areaKey: string): string
    local areaData = AreaSpawns[areaKey]
    if not areaData or not areaData.eggs or #areaData.eggs == 0 then
        return "Chicken Egg"
    end
    
    local totalWeight = 0
    for _, entry in ipairs(areaData.eggs) do
        totalWeight += (entry[2] or 1)
    end
    
    local roll = math.random() * totalWeight
    local current = 0
    for _, entry in ipairs(areaData.eggs) do
        current += (entry[2] or 1)
        if roll <= current then
            return entry[1]
        end
    end
    return areaData.eggs[1][1]
end

-- Gera uma posição aleatória sobre a superfície de um Part
local function getRandomPointOnPart(part: BasePart): Vector3
    local size = part.Size
    local rx = (math.random() - 0.5) * (size.X - 2)
    local rz = (math.random() - 0.5) * (size.Z - 2)
    local topY = size.Y / 2
    return part.CFrame:PointToWorldSpace(Vector3.new(rx, topY + 1.2, rz))
end

-- Spawna um ovo específico em um ponto do mundo
local function spawnWildEgg(caveName: string, spawnPart: BasePart, eggName: string): Model?
    local eggFolder = EggsDirectory:FindFirstChild(eggName)
    if not eggFolder then return nil end
    
    local eggModelTemplate = eggFolder:FindFirstChild("Egg")
    if not eggModelTemplate then return nil end
    
    local eggUid = "Wild_" .. HttpService:GenerateGUID(false):sub(1, 8)
    local model = Instance.new("Model")
    model.Name = eggName
    model:SetAttribute("WildUid", eggUid)
    model:SetAttribute("EggName", eggName)
    model:SetAttribute("CaveName", caveName)
    
    local cloneEgg = eggModelTemplate:Clone()
    cloneEgg.Name = "EggMesh"
    if cloneEgg:IsA("BasePart") then
        cloneEgg.Anchored = true
        cloneEgg.CanCollide = false
    end
    cloneEgg.Parent = model
    
    -- Se for um BasePart único, cria PrimaryPart
    if cloneEgg:IsA("BasePart") then
        model.PrimaryPart = cloneEgg
    elseif cloneEgg:IsA("Model") and cloneEgg.PrimaryPart then
        model.PrimaryPart = cloneEgg.PrimaryPart
    else
        local primary = cloneEgg:FindFirstChildWhichIsA("BasePart")
        if primary then model.PrimaryPart = primary end
    end
    
    local targetPos = getRandomPointOnPart(spawnPart)
    model:PivotTo(CFrame.new(targetPos) * CFrame.Angles(0, math.rad(math.random(0, 360)), 0))
    
    -- Prompt para roubar/pegar o ovo
    local prompt = Instance.new("ProximityPrompt")
    prompt.ActionText = "Pegar Ovo"
    prompt.ObjectText = eggName
    prompt.HoldDuration = 0.5
    prompt.MaxActivationDistance = 10
    prompt.RequiresLineOfSight = false
    prompt.Parent = model.PrimaryPart or model
    
    prompt.Triggered:Connect(function(player: Player)
        WildEggService.PickUpEgg(player, model)
    end)
    
    model.Parent = getWildFolder()
    activeEggsInWorld[eggUid] = model
    totalSpawnedPerCave[caveName] = (totalSpawnedPerCave[caveName] or 0) + 1
    
    return model
end

-- Jogador pega o ovo selvagem (passa a carregar nas mãos)
function WildEggService.PickUpEgg(player: Player, eggModel: Model)
    if carrying[player] then
        return -- Já está carregando um ovo
    end
    
    local eggName = eggModel:GetAttribute("EggName") or eggModel.Name
    local eggUid = eggModel:GetAttribute("WildUid")
    local caveName = eggModel:GetAttribute("CaveName") or "Cave1"
    
    if eggUid and activeEggsInWorld[eggUid] then
        activeEggsInWorld[eggUid] = nil
        totalSpawnedPerCave[caveName] = math.max(0, (totalSpawnedPerCave[caveName] or 1) - 1)
        eggModel:Destroy()
    else
        return
    end
    
    -- Anexa o ovo visualmente às mãos/costas do personagem
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    local visualModel: Model? = nil
    
    if character and hrp then
        local eggFolder = EggsDirectory:FindFirstChild(eggName)
        local template = eggFolder and eggFolder:FindFirstChild("Egg")
        if template then
            visualModel = Instance.new("Model")
            visualModel.Name = "CarriedEgg"
            local meshClone = template:Clone()
            meshClone.Name = "Mesh"
            if meshClone:IsA("BasePart") then
                meshClone.CanCollide = false
                meshClone.Anchored = false
                meshClone.CFrame = hrp.CFrame * CFrame.new(0, 0.5, -1.5)
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = hrp
                weld.Part1 = meshClone
                weld.Parent = meshClone
            end
            meshClone.Parent = visualModel
            visualModel.Parent = character
        end
    end
    
    carrying[player] = {
        eggName = eggName,
        wildModel = visualModel,
    }
    
    player:SetAttribute("Carrying", eggName)
    print(string.format("[WildEggService] %s pegou %s!", player.Name, eggName))
    
    -- Agenda respawn na caverna após 20 segundos
    task.delay(20, function()
        WildEggService.CheckRespawn(caveName)
    end)
end

-- Deposita o ovo carregado no inventário do jogador (Safe Zone Trigger ou atalho P)
function WildEggService.DepositToInventory(player: Player)
    local carryData = carrying[player]
    if not carryData then
        return false
    end
    
    local eggName = carryData.eggName
    if carryData.wildModel then
        carryData.wildModel:Destroy()
    end
    carrying[player] = nil
    player:SetAttribute("Carrying", nil)
    
    -- Chama o PlotEggService para registrar o ovo no perfil do jogador
    local PlotEggService = Library and Library.PlotEggService or require(game:GetService('ServerScriptService').Library.PlotEggService)
    if PlotEggService and PlotEggService.AddEggToInventory then
        local uid = PlotEggService.AddEggToInventory(player, eggName)
        print(string.format("[WildEggService] Ovo %s entregue com sucesso no inventário de %s (UID: %s)", eggName, player.Name, tostring(uid)))
        return true
    else
        warn("[WildEggService] PlotEggService não encontrado para adicionar o ovo")
        return false
    end
end

-- Teleporta de volta para o plot (para testes com a tecla P)
function WildEggService.HandleTestKeyP(player: Player)
    -- Se estiver carregando ovo, deposita com sucesso
    if carrying[player] then
        WildEggService.DepositToInventory(player)
    end
    
    -- Teleporta para o spawn do lobby/plot
    local PlotServer = Library and Library.PlotServer or require(game:GetService('ServerScriptService').Library.PlotServer)
    if PlotServer then
        local plotId = PlotServer.GetPlotId(player)
        if plotId and Network then
            Network.Fire("Plots_RequestTeleport", player)
        end
    end
end

-- Verifica e repõe ovos na caverna
function WildEggService.CheckRespawn(caveName: string)
    local caveIndex = tonumber(caveName:match("%d+")) or 1
    local areaKey = "Area_" .. tostring(caveIndex)
    local areaConfig = AreaSpawns[areaKey]
    local maxLimit = areaConfig and areaConfig.settings and areaConfig.settings.maxEggs or 15
    local current = totalSpawnedPerCave[caveName] or 0
    
    if current < maxLimit then
        local caveModel = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Cave") and workspace.Map.Cave:FindFirstChild(caveName)
        local spawnFolder = caveModel and caveModel:FindFirstChild("Spawn")
        if spawnFolder then
            local front = spawnFolder:FindFirstChild("Front") :: BasePart?
            local special = spawnFolder:FindFirstChild("Special") :: BasePart?
            local targetPart = front
            if special and math.random() <= 0.3 then
                targetPart = special
            end
            if targetPart then
                local chosenEgg = pickEggForArea(areaKey)
                spawnWildEgg(caveName, targetPart, chosenEgg)
            end
        end
    end
end

-- Processa a entrada do jogador na SafeZone da caverna (toca na parte "Line")
local function setupSafeZones()
    local cavesFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Cave")
    if not cavesFolder then return end

    local debounceList: { [Player]: number } = {}

    local function bindSafeZoneLine(linePart: BasePart)
        linePart.Touched:Connect(function(hit)
            local character = hit.Parent
            local player = character and Players:GetPlayerFromCharacter(character)
            if not player then return end

            local now = os.clock()
            if debounceList[player] and (now - debounceList[player]) < 2 then
                return
            end
            debounceList[player] = now

            print(string.format("[WildEggService] %s tocou na SafeZone Line!", player.Name))

            -- 1. Se estiver carregando um ovo, entrega para o inventário do jogador (e remove das costas)
            if carrying[player] then
                WildEggService.DepositToInventory(player)
            end

            -- 2. Teleporta o jogador para o Spawn do Plot dele
            local PlotServer = Library and Library.PlotServer or (function()
                local sss = game:GetService("ServerScriptService")
                local lib = sss:FindFirstChild("Library")
                local mod = lib and lib:FindFirstChild("PlotServer")
                return mod and require(mod)
            end)()

            if PlotServer and PlotServer.TeleportToSpawn then
                local plotId = PlotServer.GetPlotId(player)
                if plotId then
                    PlotServer.TeleportToSpawn(player, plotId)
                end
            elseif Network then
                Network.Fire("Plots_RequestTeleport", player)
            end

            -- 3. Reseta / fecha todas as paredes de cavernas para o jogador (igual ao Surface em ref_MinePerClick)
            local StageServer = Library and Library.StageServer or (function()
                local sss = game:GetService("ServerScriptService")
                local lib = sss:FindFirstChild("Library")
                local mod = lib and lib:FindFirstChild("StageServer")
                return mod and require(mod)
            end)()

            if StageServer and StageServer.ResetAllWalls then
                StageServer.ResetAllWalls(player)
                print(string.format("[WildEggService] Paredes das cavernas fechadas para %s", player.Name))
            end
        end)
    end

    for _, cave in ipairs(cavesFolder:GetChildren()) do
        local safeZoneFolder = cave:FindFirstChild("SafeZone") or cave:FindFirstChild("SafaZone")
        if safeZoneFolder then
            local line = safeZoneFolder:FindFirstChild("Line") :: BasePart?
            if line and line:IsA("BasePart") then
                bindSafeZoneLine(line)
            end
        end
    end
end

function WildEggService.Start(frameworkLibrary: any)
    Library = frameworkLibrary
    Network = Library.Network
    
    -- Configura os gatilhos das SafeZones nas cavernas
    task.defer(function()
        task.wait(1.5)
        setupSafeZones()
    end)
    
    -- Registra evento de rede para o atalho de teste P (e futuro Safe-Zone trigger)
    if Network then
        Network.Fired("Eggs_TestDeposit"):Connect(function(player: Player)
            WildEggService.HandleTestKeyP(player)
        end)
    end
    
    -- Spawna ovos iniciais nas cavernas
    task.defer(function()
        task.wait(2)
        local cavesFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Cave")
        if not cavesFolder then return end
        
        for _, cave in ipairs(cavesFolder:GetChildren()) do
            local spawnFolder = cave:FindFirstChild("Spawn")
            if spawnFolder then
                local front = spawnFolder:FindFirstChild("Front") :: BasePart?
                local special = spawnFolder:FindFirstChild("Special") :: BasePart?
                local caveName = cave.Name
                local caveIndex = tonumber(caveName:match("%d+")) or 1
                local areaKey = "Area_" .. tostring(caveIndex)
                
                -- Spawna 5 ovos iniciais no Front
                if front then
                    for _ = 1, 5 do
                        local eggName = pickEggForArea(areaKey)
                        spawnWildEgg(caveName, front, eggName)
                    end
                end
                
                -- Spawna 3 ovos iniciais no Special
                if special then
                    for _ = 1, 3 do
                        local eggName = pickEggForArea(areaKey)
                        spawnWildEgg(caveName, special, eggName)
                    end
                end
            end
        end
        print("[WildEggService] Ovos iniciais spawnados nas cavernas com sucesso!")
    end)
    
    -- Limpa estado caso o jogador saia
    Players.PlayerRemoving:Connect(function(player: Player)
        local data = carrying[player]
        if data and data.wildModel then
            data.wildModel:Destroy()
        end
        carrying[player] = nil
    end)
end

return WildEggService
