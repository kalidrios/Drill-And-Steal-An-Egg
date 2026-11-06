-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GamepadConfig = require(ReplicatedStorage.Shared.GamepadConfig)
local HellLoadout = require(ReplicatedStorage.Shared.HellLoadout)
local BackpackController = require(script.Parent.BackpackController)
local v1 = {}
local LocalPlayer = Players.LocalPlayer

local function isInventoryOpen() -- line 33 | captures: BackpackController
    return BackpackController.IsOpen()
end

local function ownedTools() -- line 38 | captures: LocalPlayer
    local v2 = {}
    for v3, v4 in {
            LocalPlayer.Character,
            LocalPlayer:FindFirstChildOfClass("Backpack")
        } do
        if v4 then
            for v5, v6 in v4:GetChildren() do
                if v6:IsA("Tool") then
                    table.insert(v2, v6)
                end
            end
        end
    end
    return v2
end

local function hotbarTools() -- line 54 | captures: BackpackController, ownedTools
    if BackpackController.IsReady() then
        return BackpackController.GetHotbarTools()
    end
    return (ownedTools())
end

local function cycle(v7) -- line 61 | captures: HellLoadout, BackpackController, LocalPlayer, ownedTools
    local Character = LocalPlayer.Character
    local v8 = Character and Character:FindFirstChildOfClass("Humanoid")
    local v9, v10, v11, v12, v13
    if v8 then
        if v8.Health <= 0 then
            v13 = true
        else
            v9 = {}
            if BackpackController.IsReady() then
                v10, v11, v12 = BackpackController.GetHotbarTools()
            else
                v10, v11, v12 = ownedTools()
            end
            v13 = false
        end
    else
        v13 = true
    end
    if v13 then
        return
    end
    for v14, v15 in v10, v11, v12 do
        if HellLoadout.CanEquip(LocalPlayer, v15) then
            table.insert(v9, v15)
        end
    end
    if #v9 == 0 then
        return
    end
    local v16 = 0
    for v17, v18 in v9 do
        if v18.Parent == Character then
            v16 = v17
            break
        end
        v16 = 0
    end
    local v19 = (v16 + v7) % (#v9 + 1)
    if v19 == 0 then
        v8:UnequipTools()
    else
        v8:EquipTool(v9[v19])
    end
end

local function onAction(v20, v21, v22) -- line 96 | captures: GamepadConfig, BackpackController, cycle
    if v21 == Enum.UserInputState.Begin then
        if BackpackController.IsOpen() then
            return Enum.ContextActionResult.Pass
        end
        if v22.KeyCode == GamepadConfig.HotbarNextButton then
            cycle(1)
        else
            cycle(-1)
        end
        return Enum.ContextActionResult.Sink
    end
    return Enum.ContextActionResult.Pass
end

function v1.Start() -- line 112 | captures: ContextActionService, GamepadConfig, onAction
    ContextActionService:BindActionAtPriority("GamepadHotbarCycle", onAction, false, Enum.ContextActionPriority.High.Value, GamepadConfig.HotbarPreviousButton, GamepadConfig.HotbarNextButton)
end

return v1
