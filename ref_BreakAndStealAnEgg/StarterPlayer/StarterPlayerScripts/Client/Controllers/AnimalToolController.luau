-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local AnimalPlaceVFXController = require(script.Parent.AnimalPlaceVFXController)
local AnimalPlacementConfig = require(ReplicatedStorage.Shared.AnimalPlacementConfig)
local GamepadConfig = require(ReplicatedStorage.Shared.GamepadConfig)
local OwnBase = require(script.Parent.OwnBase)
local PlaceClickRay = require(script.Parent.Parent.Modules.PlaceClickRay)
local PlotUpgradeConfig = require(ReplicatedStorage.Shared.PlotUpgradeConfig)
local SafeZoneQuery = require(ReplicatedStorage.Shared.SafeZoneQuery)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = {}
local Get = OwnBase.Get
local IsPositionInPart = SafeZoneQuery.IsPositionInPart

local function canPlaceAt(v3) -- line 56 | captures: AnimalPlacementConfig, PlotUpgradeConfig, LocalPlayer, Get, IsPositionInPart
    local v4 = Get()
    if v4 then
        local v5 = v4:FindFirstChild("Hitbox")
        if v5 and v5:IsA("BasePart") then
            if v4:GetAttribute("RestoringPets") then
                return false
            end
            local v6
            if IsPositionInPart(v5, v3) then
                local Character = LocalPlayer.Character
                v6 = Character and Character:FindFirstChild("HumanoidRootPart")
            else
                return false
            end
            if not (v6 and v6:IsA("BasePart")) then
                return false
            end
            local v7 = v3 - v6.Position
            local X = v7.X
            local Z = v7.Z
            local Magnitude = Vector3.new(X, 0, Z).Magnitude
            if AnimalPlacementConfig.MaxPlaceDistance < Magnitude then
                return false
            end
            local v8 = v4:GetAttribute("AnimalsPlaced") or 0
            local v9 = v4:GetAttribute("PlotLevel") or PlotUpgradeConfig.DefaultLevel
            return v8 < (v4:GetAttribute("MaxAnimals") or PlotUpgradeConfig.Capacity(v9))
        end
    end
    return false
end

v1.CanPlaceAt = canPlaceAt

local function hideToolLocally(v10) -- line 98
    local v11 = {}
    local v12 = {}
    local v13 = {}
    for v14, v15 in v10:GetDescendants() do
        if v15:IsA("BasePart") then
            if v15.Name == "Handle" then
                if v15:IsA("Decal") or v15:IsA("Texture") then
                    v15.LocalTransparencyModifier = 1
                    table.insert(v12, v15)
                elseif v15:IsA("BillboardGui") and v15.Enabled then
                    v15.Enabled = false
                    table.insert(v13, v15)
                end
            else
                v15.LocalTransparencyModifier = 1
                table.insert(v11, v15)
            end
        elseif v15:IsA("Decal") or v15:IsA("Texture") then
            v15.LocalTransparencyModifier = 1
            table.insert(v12, v15)
        elseif v15:IsA("BillboardGui") and v15.Enabled then
            v15.Enabled = false
            table.insert(v13, v15)
        end
    end
    return function() -- line 114 | captures: v11, v12, v13
        for v16, v17 in v11 do
            v17.LocalTransparencyModifier = 0
        end
        for v18, v19 in v12 do
            v19.LocalTransparencyModifier = 0
        end
        for v20, v21 in v13 do
            v21.Enabled = true
        end
    end
end

local v22 = {}
local v23 = 0
local v24 = {}

function v1.PlaceAt(v25, v26) -- line 147 | captures: v23, ReplicatedStorage, AnimalPlaceVFXController, canPlaceAt, hideToolLocally, v22, v24
    if v22[v25] then
        return false
    end
    local PlaceAnimalRemote = ReplicatedStorage:FindFirstChild("PlaceAnimalRemote")
    if not (PlaceAnimalRemote and PlaceAnimalRemote:IsA("RemoteEvent")) then
        return false
    end
    v23 += 1
    local v27 = v23
    PlaceAnimalRemote:FireServer(v25, v26, v27)
    if canPlaceAt(v26) then
        v22[v25] = hideToolLocally(v25)
        v24[v25] = v27
        AnimalPlaceVFXController.PredictPlacement(v26)
        task.delay(2, function() -- line 172 | captures: v25, v27, v22, v24
            if v24[v25] ~= v27 then
                return
            end
            local v28 = v22[v25]
            v22[v25] = nil
            v24[v25] = nil
            if v28 and v25.Parent ~= nil then
                v28()
            end
        end)
    end
    return true
end

local function onPlaceRejected(v29, v30) -- line 192 | captures: AnimalPlaceVFXController, LocalPlayer, v22, v24
    if typeof(v29) == "Instance" and v29:IsA("Tool") and v30 == v24[v29] then
        local v31 = v22[v29]
        if v31 then
            v22[v29] = nil
            v24[v29] = nil
            AnimalPlaceVFXController.CancelPrediction()
            if v29.Parent ~= nil then
                v31()
                local Character = LocalPlayer.Character
                if v29.Parent ~= Character then
                    local v32 = Character and Character:FindFirstChildOfClass("Humanoid")
                    if v32 and v32.Health > 0 and v29.Parent == LocalPlayer:FindFirstChild("Backpack") then
                        v32:EquipTool(v29)
                    end
                end
            end
        end
    end
end

function v1.GetHeldTool() -- line 223 | captures: CollectionService, LocalPlayer
    local Character = LocalPlayer.Character
    if Character then
        for v33, v34 in Character:GetChildren() do
            if v34:IsA("Tool") and CollectionService:HasTag(v34, "AnimalTool") then
                return v34
            end
        end
    end
    return nil
end

local function hookTool(v35) -- line 236 | captures: UserInputService, GamepadConfig, PlaceClickRay, v1, v2, v22, v24
    if not v35:IsA("Tool") or v2[v35] then
        return
    end
    v2[v35] = true
    v35.Activated:Connect(function() -- line 242 | captures: v35, UserInputService, GamepadConfig, PlaceClickRay, v1
        if not GamepadConfig.IsGamepadInput(UserInputService:GetLastInputType()) then
            local v36 = PlaceClickRay.Get()
            if v36 then
                v1.PlaceAt(v35, v36)
            end
        end
    end)
    v35.Destroying:Connect(function() -- line 255 | captures: v35, v2, v22, v24
        v2[v35] = nil
        v22[v35] = nil
        v24[v35] = nil
    end)
end

function v1.Start() -- line 262 | captures: CollectionService, ReplicatedStorage, onPlaceRejected, hookTool
    for v37, v38 in CollectionService:GetTagged("AnimalTool") do
        hookTool(v38)
    end
    CollectionService:GetInstanceAddedSignal("AnimalTool"):Connect(hookTool)
    task.spawn(function() -- line 270 | captures: ReplicatedStorage, onPlaceRejected
        local v39 = ReplicatedStorage:WaitForChild("PlaceAnimalRemote", 30)
        if v39 and v39:IsA("RemoteEvent") then
            v39.OnClientEvent:Connect(onPlaceRejected)
        end
    end)
end

return v1
