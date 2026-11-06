-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimalPlacementConfig = require(ReplicatedStorage.Shared.AnimalPlacementConfig)
local GamepadConfig = require(ReplicatedStorage.Shared.GamepadConfig)
local AnimalToolController = require(script.Parent.AnimalToolController)
local OwnBase = require(script.Parent.OwnBase)
local UiFrames = require(script.Parent.UiFrames)
local v1 = {}
local LocalPlayer = Players.LocalPlayer

local function findPlaceSpot() -- line 42 | captures: AnimalPlacementConfig, GamepadConfig, OwnBase, LocalPlayer
    local v2 = OwnBase.Get()
    local v3 = v2 and v2:FindFirstChild("Hitbox")
    local v4
    if v3 and v3:IsA("BasePart") then
        local Character = LocalPlayer.Character
        v4 = Character and Character:FindFirstChild("HumanoidRootPart")
    else
        return nil
    end
    if not (v4 and v4:IsA("BasePart")) then
        return nil
    end
    local v5 = v3.CFrame:PointToObjectSpace(v4.Position)
    local v6 = v3.Size * 0.5
    local v7 = v6.X - GamepadConfig.PlaceEdgeInset
    local v8 = math.max(v7, 0)
    local v9 = v6.Z - GamepadConfig.PlaceEdgeInset
    local v10 = math.max(v9, 0)
    local CFrame = v3.CFrame
    local X = v5.X
    local v11 = -v8
    local v12 = math.clamp(X, v11, v8)
    local Z = v5.Z
    local v13 = -v10
    local v14 = math.clamp(Z, v13, v10)
    local v15 = CFrame:PointToWorldSpace((Vector3.new(v12, 0, v14)))
    local v16 = v15 - v4.Position
    local X_2 = v16.X
    local Z_2 = v16.Z
    local Magnitude = Vector3.new(X_2, 0, Z_2).Magnitude
    local X_3 = v5.X
    local v17 = math.abs(X_3) - v6.X
    local v18 = math.max(v17, 0)
    local Z_3 = v5.Z
    local v19 = math.abs(Z_3) - v6.Z
    local v20 = math.max(v19, 0)
    local v21 = v18 * v18 + v20 * v20
    local v22 = math.sqrt(v21)
    if GamepadConfig.PlaceReach < v22 then
        return nil
    end
    if AnimalPlacementConfig.MaxPlaceDistance < Magnitude then
        return nil
    end
    return v15
end

local function onAction(v23, v24, v25) -- line 81 | captures: GuiService, AnimalToolController, UiFrames, findPlaceSpot
    if v24 == Enum.UserInputState.Begin and GuiService.SelectedObject == nil and UiFrames.GetOpen() == nil then
        local v26 = AnimalToolController.GetHeldTool()
        if v26 then
            local v27 = findPlaceSpot()
            if v27 then
                AnimalToolController.PlaceAt(v26, v27)
                return Enum.ContextActionResult.Sink
            end
        end
    end
    return Enum.ContextActionResult.Pass
end

function v1.Start() -- line 103 | captures: ContextActionService, GamepadConfig, onAction
    local v28 = Enum.ContextActionPriority.High.Value + 1
    local PlaceButtons = GamepadConfig.PlaceButtons
    ContextActionService:BindActionAtPriority("GamepadPlaceAnimal", onAction, false, v28, table.unpack(PlaceButtons))
end

return v1
