--!strict
--[[
    PlotEggService.luau
    Gerencia o ciclo de vida completo dos ovos do jogador:
    1. Entrada no Inventário (EggInventory) e criação da Tool compatível com Toolbar.luau
    2. Colocação no Plot do jogador (validação de PetArea, PenCapacity)
    3. Crescimento físico no plot (escala gradativa até tamanho normal)
    4. Chocagem ao atingir maturidade: sorteia animal diretamente do módulo do egg via HatchService!
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local PlotEggService = {}
local Library: any = nil
local Network: any = nil

local function getSaving()
    if Library and Library.Saving then return Library.Saving end
    local sss = game:GetService("ServerScriptService")
    local sssLib = sss:FindFirstChild("Library")
    local mod = sssLib and sssLib:FindFirstChild("Saving")
    if mod and mod:IsA("ModuleScript") then
        return require(mod)
    end
    return nil
end

local function getHatchService()
    if Library and Library.HatchService then return Library.HatchService end
    local sss = game:GetService("ServerScriptService")
    local sssLib = sss:FindFirstChild("Library")
    local mod = sssLib and sssLib:FindFirstChild("HatchService")
    if mod and mod:IsA("ModuleScript") then
        return require(mod)
    end
    return nil
end

local function getPlotServer()
    if Library and Library.PlotServer then return Library.PlotServer end
    local sss = game:GetService("ServerScriptService")
    local sssLib = sss:FindFirstChild("Library")
    local mod = sssLib and sssLib:FindFirstChild("PlotServer")
    if mod and mod:IsA("ModuleScript") then
        return require(mod)
    end
    return nil
end

local EggsDirectory = ReplicatedStorage:WaitForChild("Directory"):WaitForChild("Eggs")
local DefaultStats = require(ReplicatedStorage:WaitForChild("Directory"):WaitForChild("Saving"):WaitForChild("DefaultStats"))

-- Rastreamento de ovos instanciados nos plots: plotId -> { [uid]: Model }
local placedEggModels: { [number]: { [string]: Model } } = {}

-- Cria uma pasta para os ovos nos plots caso não exista
local function getPlacedFolder(): Folder
    local folder = workspace:FindFirstChild("PlacedEggs")
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = "PlacedEggs"
        folder.Parent = workspace
    end
    return folder :: Folder
end

-- Gera uma Tool na mochila do jogador representando o ovo (compatível com a Toolbar.luau)
-- Gera uma Tool na mochila do jogador representando o Pet chocado (compatível com Toolbar.luau)
function PlotEggService.GrantPetTool(player: Player, uid: string, petData: any): Tool?
    local petName = petData.Name or "Animal"
    local variant = petData.Variant or "Normal"
    
    -- Destrói Tool duplicada se já existir
    for _, container in ipairs({ player.Character, player:FindFirstChild("Backpack") }) do
        if container then
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") and item:GetAttribute("UID") == uid then
                    item:Destroy()
                end
            end
        end
    end
    
    local tool = Instance.new("Tool")
    tool.Name = petName
    tool.RequiresHandle = true
    tool.CanBeDropped = false
    tool:SetAttribute("UID", uid)
    tool:SetAttribute("PetName", petName)
    tool:SetAttribute("Variant", variant)
    tool:SetAttribute("WeightKg", petData.WeightKg or 1)
    tool:SetAttribute("CoinsPerSecond", petData.CoinsPerSecond or 1)
    tool:SetAttribute("IsPet", true)
    
    if petData.Thumbnail then
        tool.TextureId = petData.Thumbnail
    end
    
    -- Busca o modelo 3D do animal em Directory.Animals
    local animalsFolder = ReplicatedStorage:WaitForChild("Directory"):WaitForChild("Animals")
    local normalFolder = animalsFolder:FindFirstChild("Normal")
    local animalFolder = (normalFolder and normalFolder:FindFirstChild(petName)) or animalsFolder:FindFirstChild(petName)
    local targetModel = animalFolder and (animalFolder:FindFirstChild(variant) or animalFolder:FindFirstChild("Normal"))
    
    local handlePart: BasePart? = nil
    if targetModel then
        local clone = targetModel:Clone()
        local mesh = clone:FindFirstChildWhichIsA("MeshPart", true) or clone:FindFirstChildWhichIsA("BasePart", true)
        if mesh then
            mesh.Name = "Handle"
            mesh.CanCollide = false
            mesh.Anchored = false
            handlePart = mesh
        end
    end
    
    if not handlePart then
        handlePart = Instance.new("Part")
        handlePart.Name = "Handle"
        handlePart.Size = Vector3.new(1.5, 1.5, 1.5)
        handlePart.Transparency = 1
        handlePart.CanCollide = false
        handlePart.Anchored = false
    end
    handlePart.Parent = tool
    
    local backpack = player:FindFirstChild("Backpack") or player:WaitForChild("Backpack", 5)
    if backpack then
        tool.Parent = backpack
    end
    return tool
end

function PlotEggService.GrantEggTool(player: Player, uid: string, eggName: string): Tool?
    local eggFolder = EggsDirectory:FindFirstChild(eggName)
    if not eggFolder then return nil end
    
    local template = eggFolder:FindFirstChild("Egg")
    if not template then return nil end
    
    -- Destrói Tool duplicada se já existir
    for _, container in ipairs({ player.Character, player:FindFirstChild("Backpack") }) do
        if container then
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") and item:GetAttribute("UID") == uid then
                    item:Destroy()
                end
            end
        end
    end
    
    local tool = Instance.new("Tool")
    tool.Name = eggName
    tool.RequiresHandle = true
    tool.CanBeDropped = false
    tool:SetAttribute("UID", uid)
    tool:SetAttribute("EggName", eggName)
    tool:SetAttribute("IsEgg", true)
    
    -- Busca dados do ovo para definir ícone na toolbar
    local eggModule = eggFolder:FindFirstChildWhichIsA("ModuleScript")
    if eggModule then
        local ok, data = pcall(require, eggModule)
        if ok and data and data.thumbnail then
            tool.TextureId = data.thumbnail
        end
    end
    
    local handle = template:Clone()
    handle.Name = "Handle"
    if handle:IsA("BasePart") then
        handle.CanCollide = false
        handle.Anchored = false
    else
        local primary = handle:FindFirstChildWhichIsA("BasePart")
        if primary then
            primary.Name = "Handle"
            handle = primary
            handle.CanCollide = false
            handle.Anchored = false
        end
    end
    handle.Parent = tool
    
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        tool.Parent = backpack
    end
    
    return tool
end

-- Remove a Tool do ovo da mão/mochila do jogador
local function destroyEggTool(player: Player, uid: string)
    for _, container in ipairs({ player.Character, player:FindFirstChild("Backpack") }) do
        if container then
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") and item:GetAttribute("UID") == uid then
                    item:Destroy()
                end
            end
        end
    end
end

-- Adiciona um ovo ao perfil salvo do jogador e entrega a Tool
function PlotEggService.AddEggToInventory(player: Player, eggName: string): string?
    local Saving = getSaving()
    local profileData = Saving and Saving.Get(player)
    
    if not profileData and RunService:IsStudio() then
        local start = os.clock()
        while not profileData and (os.clock() - start) < 5 do
            task.wait(0.2)
            profileData = Saving and Saving.Get(player)
        end
    end
    
    if not profileData then return nil end
    
    profileData.EggInventory = profileData.EggInventory or {}
    
    local uid = "Egg_" .. HttpService:GenerateGUID(false):sub(1, 8)
    profileData.EggInventory[uid] = {
        EggType = eggName,
        CollectedAt = os.time(),
        Placement = nil,
    }
    
    PlotEggService.GrantEggTool(player, uid, eggName)
    
    -- Notifica o cliente via sincronização do Saving
    Saving.SyncPlayerStats(player, false)
    return uid
end

-- Obtém o FloorRanch1 do plot
local function getPlotFloor(plotId: number): BasePart?
    local map = workspace:FindFirstChild("Map")
    local lobby = map and map:FindFirstChild("Lobby")
    local plots = (lobby and lobby:FindFirstChild("Plots")) or workspace:FindFirstChild("Plots")
    if not plots then return nil end
    
    local plotModel = plots:FindFirstChild(tostring(plotId))
    if not plotModel then return nil end
    
    local toUpdate = plotModel:FindFirstChild("ToUpdate")
    local floor = (toUpdate and toUpdate:FindFirstChild("FloorRanch1")) or plotModel:FindFirstChild("FloorRanch1")
    if floor and floor:IsA("BasePart") then
        return floor
    end
    return nil
end

-- Calcula e ajusta a posição para que o ovo fique perfeitamente pousado sobre a superfície do chão
local function getSurfacePlacementCFrame(plotId: number, rawPos: Vector3, eggTemplate: Instance, scale: number): CFrame
    local floor = getPlotFloor(plotId)
    local floorTopY = (floor and (floor.Position.Y + (floor.Size.Y * 0.5))) or rawPos.Y
    
    local templateHeight = 6.0
    if eggTemplate:IsA("BasePart") then
        templateHeight = eggTemplate.Size.Y
    elseif eggTemplate:IsA("Model") then
        templateHeight = eggTemplate:GetExtentsSize().Y
    end
    
    -- Metade da altura atual do ovo para que a base toque perfeitamente o chão
    local eggHalfHeight = (templateHeight * scale) * 0.5
    local finalY = floorTopY + eggHalfHeight
    
    return CFrame.new(rawPos.X, finalY, rawPos.Z)
end

-- Instancia o modelo 3D do ovo crescendo no cercado do plot (Padrão fiel ref_StealAnEgg)
local function renderPlacedEgg(plotId: number, player: Player, uid: string, eggData: any)
    placedEggModels[plotId] = placedEggModels[plotId] or {}
    if placedEggModels[plotId][uid] then
        placedEggModels[plotId][uid]:Destroy()
    end
    
    local eggName = eggData.EggType
    local eggFolder = EggsDirectory:FindFirstChild(eggName)
    local template = eggFolder and eggFolder:FindFirstChild("Egg")
    if not template then return end
    
    local model = Instance.new("Model")
    model.Name = eggName .. "_" .. uid
    model:SetAttribute("UID", uid)
    model:SetAttribute("PlotId", plotId)
    model:SetAttribute("OwnerUserId", player.UserId)
    
    local mesh = template:Clone()
    mesh.Name = "EggMesh"
    if mesh:IsA("BasePart") then
        mesh.Anchored = true
        mesh.CanCollide = true
    end
    mesh.Parent = model
    
    if mesh:IsA("BasePart") then
        model.PrimaryPart = mesh
    else
        local p = mesh:FindFirstChildWhichIsA("BasePart")
        if p then model.PrimaryPart = p end
    end
    
    local pos = eggData.Placement.Position
    local rawPos = Vector3.new(pos[1], pos[2], pos[3])
    
    -- Escala inicial de crescimento (0.35)
    local initialScale = 0.35
    model:ScaleTo(initialScale)
    
    -- Posiciona com base no topo do chão (FloorRanch1) para nunca afundar
    local surfaceCFrame = getSurfacePlacementCFrame(plotId, rawPos, template, initialScale)
    model:PivotTo(surfaceCFrame)
    
    -- Prompt para chocar quando estiver maduro
    local prompt = Instance.new("ProximityPrompt")
    prompt.ActionText = "Chocar Animal"
    prompt.ObjectText = eggName
    prompt.HoldDuration = 0.8
    prompt.MaxActivationDistance = 12
    prompt.RequiresLineOfSight = false
    prompt.Enabled = false -- Será habilitado quando Ready = true
    prompt.Parent = model.PrimaryPart or model
    
    prompt.Triggered:Connect(function(triggeringPlayer: Player)
        if triggeringPlayer == player then
            PlotEggService.HatchPlacedEgg(player, uid)
        end
    end)
    
    model.Parent = getPlacedFolder()
    placedEggModels[plotId][uid] = model
end

-- Posiciona o ovo no plot com validação rigorosa de limites da base (Padrão ref_StealAnEgg)
function PlotEggService.PlaceEgg(player: Player, uid: string, targetPos: Vector3): (boolean, string?)
    local PlotServer = getPlotServer()
    local Saving = getSaving()
    local profileData = Saving and Saving.Get(player)
    
    -- Fallback defensivo no Studio enquanto o ProfileStore abre sessão
    if not profileData and RunService:IsStudio() then
        local start = os.clock()
        while not profileData and (os.clock() - start) < 4 do
            task.wait(0.2)
            profileData = Saving and Saving.Get(player)
        end
    end
    
    if not profileData or not profileData.EggInventory then
        return false, "Perfil não carregado"
    end
    
    local eggData = profileData.EggInventory[uid]
    if not eggData then
        return false, "Ovo não encontrado"
    end
    
    if eggData.Placement ~= nil then
        return false, "Ovo já está no plot"
    end
    
    local plotId = PlotServer and PlotServer.GetPlotId(player)
    if not plotId then
        return false, "Você precisa de um plot no lobby"
    end
    
    -- 1. Validação estrita: o ovo DEVE ser colocado dentro da base (FloorRanch1 do seu plot)
    local floor = getPlotFloor(plotId)
    if not floor then
        return false, "Base não encontrada"
    end
    
    local floorPos = floor.Position
    local halfSize = floor.Size * 0.5
    local minX = floorPos.X - halfSize.X
    local maxX = floorPos.X + halfSize.X
    local minZ = floorPos.Z - halfSize.Z
    local maxZ = floorPos.Z + halfSize.Z
    
    -- Margem interna de segurança de 1 stud para não colocar na cerca
    local margin = 1.0
    if targetPos.X < (minX + margin) or targetPos.X > (maxX - margin) or
       targetPos.Z < (minZ + margin) or targetPos.Z > (maxZ - margin) then
        return false, "Você só pode colocar o ovo dentro do cercado da sua base!"
    end
    
    -- 2. Limite de capacidade do cercado
    local placedCount = 0
    for _, item in pairs(profileData.EggInventory) do
        if item.Placement ~= nil then
            placedCount += 1
        end
    end
    
    local capacity = profileData.PenCapacity or DefaultStats.Template.PenCapacity
    if placedCount >= capacity then
        return false, "Seu cercado está cheio! Limite: " .. tostring(capacity)
    end
    
    -- Registra o placement
    local growthDuration = 30
    eggData.Placement = {
        Position = { targetPos.X, targetPos.Y, targetPos.Z },
        PlacedAt = os.time(),
        GrowthDuration = growthDuration,
        Ready = false,
    }
    
    -- Remove ferramenta da mão/mochila
    destroyEggTool(player, uid)
    
    -- Renderiza no plot
    renderPlacedEgg(plotId, player, uid, eggData)
    
    -- Sincroniza dados
    Saving.SyncPlayerStats(player, false)
    print(string.format("[PlotEggService] %s colocou %s na base (Plot %d) na superfície", player.Name, eggData.EggType, plotId))
    return true
end

-- Choca o ovo colocado no plot e gera o pet do módulo do ovo
function PlotEggService.HatchPlacedEgg(player: Player, uid: string): (boolean, string?)
    local Saving = getSaving()
    local HatchService = getHatchService()
    local PlotServer = getPlotServer()
    local profileData = Saving and Saving.Get(player)
    
    if not profileData or not profileData.EggInventory then
        return false, "Perfil indisponível"
    end
    
    local eggData = profileData.EggInventory[uid]
    if not eggData or not eggData.Placement then
        return false, "Ovo não está colocado"
    end
    
    local elapsed = os.time() - (eggData.Placement.PlacedAt or 0)
    local duration = eggData.Placement.GrowthDuration or 30
    if elapsed < duration and not eggData.Placement.Ready then
        return false, "O ovo ainda está crescendo!"
    end
    
    local eggName = eggData.EggType
    local eggFolder = EggsDirectory:FindFirstChild(eggName)
    local eggModule = eggFolder and eggFolder:FindFirstChildWhichIsA("ModuleScript")
    local eggConfig = eggModule and require(eggModule)
    
    if not eggConfig then
        return false, "Configuração do ovo não encontrada"
    end
    
    -- Sorteia o animal usando as probabilidades existentes no módulo do Egg via HatchService!
    local hatchResult = HatchService and HatchService.HatchEgg(eggConfig, 1.0)
    if not hatchResult then
        return false, "Falha ao chocar animal"
    end
    
    -- Remove o ovo do EggInventory
    profileData.EggInventory[uid] = nil
    
    -- Adiciona o animal sorteado em InventoryPets (salvo de forma estruturada no ProfileStore)
    profileData.InventoryPets = profileData.InventoryPets or {}
    local petUid = "Pet_" .. HttpService:GenerateGUID(false):sub(1, 8)
    local petData = {
        Uid = petUid,
        Name = hatchResult.petName,
        Variant = hatchResult.variant,
        WeightKg = hatchResult.weightKg,
        CoinsPerSecond = hatchResult.coinsPerSecond,
        Rarity = hatchResult.rarity,
        Thumbnail = hatchResult.thumbnail,
        HatchedAt = os.time(),
    }
    
    if type(profileData.InventoryPets) == "table" then
        table.insert(profileData.InventoryPets, petData)
    else
        profileData.InventoryPets = { petData }
    end
    
    -- Gera a Tool do animal no inventário/mochila do jogador (compatível com a Toolbar)
    PlotEggService.GrantPetTool(player, petUid, petData)
    
    -- Remove modelo 3D do ovo do plot
    local plotId = PlotServer and PlotServer.GetPlotId(player)
    if plotId and placedEggModels[plotId] and placedEggModels[plotId][uid] then
        local eggModel = placedEggModels[plotId][uid]
        
        -- Efeito de poof / fumaça caso exista
        local vfx = ReplicatedStorage:FindFirstChild("Assets") and ReplicatedStorage.Assets:FindFirstChild("VFX")
        local eggPoof = vfx and vfx:FindFirstChild("EggPoof")
        if eggPoof and eggModel.PrimaryPart then
            local pClone = eggPoof:Clone()
            pClone.CFrame = eggModel.PrimaryPart.CFrame
            pClone.Parent = workspace
            task.delay(2, function() pClone:Destroy() end)
        end
        
        eggModel:Destroy()
        placedEggModels[plotId][uid] = nil
    end
    
    -- Toca o evento de notificação e som de hatch
    if Network then
        Network.Fire("PlayEggHatch", player, {
            PetName = hatchResult.petName,
            Variant = hatchResult.variant,
            Rarity = hatchResult.rarity,
            Thumbnail = hatchResult.thumbnail,
        })
    end
    
    Saving.SyncPlayerStats(player, false)
    print(string.format("[PlotEggService] SUCESSO: %s chocou %s e ganhou um %s (%s, %.1f Kg)!", player.Name, eggName, hatchResult.petName, hatchResult.variant, hatchResult.weightKg))
    return true
end

function PlotEggService.Start(frameworkLibrary: any)
    Library = frameworkLibrary
    Network = Library.Network
    
    -- Registra Remotes no Network
    if Network then
        local placeFunc = Network.Invoked("Eggs_RequestPlace")
        if placeFunc then
            placeFunc.OnServerInvoke = function(player: Player, uid: string, targetPos: Vector3)
                return PlotEggService.PlaceEgg(player, uid, targetPos)
            end
        end
        
        local hatchFunc = Network.Invoked("Eggs_RequestHatch")
        if hatchFunc then
            hatchFunc.OnServerInvoke = function(player: Player, uid: string)
                return PlotEggService.HatchPlacedEgg(player, uid)
            end
        end
    end
    
    -- Restaura ovos na mochila ao spawnar o personagem
    Players.PlayerAdded:Connect(function(player: Player)
        player.CharacterAdded:Connect(function()
            task.wait(1)
            local Saving = getSaving()
            local profile = Saving and Saving.Get(player)
            if profile then
                if profile.EggInventory then
                    for uid, eggData in pairs(profile.EggInventory) do
                        if eggData.Placement == nil then
                            PlotEggService.GrantEggTool(player, uid, eggData.EggType)
                        end
                    end
                end
                if profile.InventoryPets then
                    for _, petData in ipairs(profile.InventoryPets) do
                        PlotEggService.GrantPetTool(player, petData.Uid, petData)
                    end
                end
            end
        end)
    end)
    
    -- Loop de crescimento físico dos ovos nos plots (executa a cada 1 segundo)
    task.spawn(function()
        while true do
            task.wait(1)
            local now = os.time()
            for plotId, models in pairs(placedEggModels) do
                for uid, model in pairs(models) do
                    local ownerUserId = model:GetAttribute("OwnerUserId")
                    local player = ownerUserId and Players:GetPlayerByUserId(ownerUserId)
                    local Saving = getSaving()
                    local profile = player and Saving and Saving.Get(player)
                    local eggData = profile and profile.EggInventory and profile.EggInventory[uid]
                    
                    if eggData and eggData.Placement then
                        local placedAt = eggData.Placement.PlacedAt or now
                        local duration = eggData.Placement.GrowthDuration or 30
                        local elapsed = now - placedAt
                        local progress = math.clamp(elapsed / duration, 0, 1)
                        
                        -- Escala o ovo suavemente de 0.35 até 1.0 e reajusta o Pivot para ficar na superfície
                        local targetScale = 0.35 + (0.65 * progress)
                        model:ScaleTo(targetScale)
                        
                        local rawPos = Vector3.new(eggData.Placement.Position[1], eggData.Placement.Position[2], eggData.Placement.Position[3])
                        local eggTemplate = EggsDirectory:FindFirstChild(eggData.EggType)
                        local templatePart = eggTemplate and eggTemplate:FindFirstChild("Egg")
                        if templatePart then
                            local surfaceCFrame = getSurfacePlacementCFrame(plotId, rawPos, templatePart, targetScale)
                            model:PivotTo(surfaceCFrame)
                        end
                        
                        -- Quando atinge 100%, libera o ProximityPrompt
                        if progress >= 1 then
                            eggData.Placement.Ready = true
                            local prompt = model:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt and not prompt.Enabled then
                                prompt.Enabled = true
                            end
                        end
                    end
                end
            end
        end
    end)
    
    print("[PlotEggService] Serviço de Ovos e Plots iniciado com sucesso!")
end

return PlotEggService

