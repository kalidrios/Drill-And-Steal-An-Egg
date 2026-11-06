-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local OfflineRewardConfig = require(ReplicatedStorage.Shared.OfflineRewardConfig)
local SafeZoneQuery = require(ReplicatedStorage.Shared.SafeZoneQuery)
local TutorialConfig = require(ReplicatedStorage.Shared.TutorialConfig)
local LocalCharacter = require(script.Parent.Parent.Modules.LocalCharacter)
local OwnBase = require(script.Parent.OwnBase)
local v1 = {}
local v2 = { "Word1", "Amount", "Word2" }
local LocalPlayer = Players.LocalPlayer
local OfflineEarningsDisplay, Amount, Word1, Word2
local v3 = "You earn"
local v4 = 0
local v5
local v6 = true

local function placedRate() -- line 81 | captures: EggRewards, OwnBase
    local v7 = OwnBase.Get()
    local v8 = v7 and v7:FindFirstChild("PlacedAnimals")
    if v8 then
        local v9 = 0
        for v10, v11 in v8:GetChildren() do
            local AnimalName = v11:GetAttribute("AnimalName")
            if typeof(AnimalName) == "string" then
                local v12 = v11:GetAttribute("SizeMult") or 1
                local Mutation = v11:GetAttribute("Mutation")
                local Variant = v11:GetAttribute("Variant")
                local WeightKg = v11:GetAttribute("WeightKg")
                local PlacedCashPerSecond = EggRewards.PlacedCashPerSecond
                if typeof(WeightKg) ~= "number" then
                    WeightKg = 1
                end
                v9 += PlacedCashPerSecond(AnimalName, v12, Mutation, WeightKg, Variant)
            end
        end
        return v9
    end
    return 0
end

local function updateAmount() -- line 103 | captures: Amount, v4, v5, v6, FormatNumber, OfflineRewardConfig, placedRate
    v6 = false
    if not Amount then
        return
    end
    local MaxOfflineSeconds = OfflineRewardConfig.MaxOfflineSeconds
    local v13 = math.min(86400, MaxOfflineSeconds)
    local v14 = placedRate() * OfflineRewardConfig.OfflineRateMultiplier * v13
    local v15 = math.floor(v14)
    v4 = v15
    v5 = nil
    Amount.Text = ("$%*"):format((FormatNumber.Short(v15)))
end

local function resolveDisplay() -- line 121 | captures: OfflineEarningsDisplay, Amount, Word1, Word2, v3, v5, v6, v2, LocalPlayer
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v16 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    if v16 then
        if OfflineEarningsDisplay and OfflineEarningsDisplay.Parent == v16 then
            return OfflineEarningsDisplay
        end
        local OfflineEarningsDisplay_2 = v16:FindFirstChild("OfflineEarningsDisplay")
        if not (OfflineEarningsDisplay_2 and OfflineEarningsDisplay_2:IsA("Frame")) then
            return nil
        end
        OfflineEarningsDisplay_2.Visible = false
        for v17, v18 in v2 do
            local v19 = OfflineEarningsDisplay_2:FindFirstChild(v18)
            if v19 and v19:IsA("TextLabel") then
                v19.Visible = true
                if v18 == "Word2" then
                    v19.Text = "/Day Offline \240\159\152\136"
                end
            end
        end
        local Amount_2 = OfflineEarningsDisplay_2:FindFirstChild("Amount")
        if not (Amount_2 and Amount_2:IsA("TextLabel")) then
            Amount_2 = nil
        end
        Amount = Amount_2
        local Word1_2 = OfflineEarningsDisplay_2:FindFirstChild("Word1")
        if not (Word1_2 and Word1_2:IsA("TextLabel")) then
            Word1_2 = nil
        end
        Word1 = Word1_2
        local Word2_2 = OfflineEarningsDisplay_2:FindFirstChild("Word2")
        if not (Word2_2 and Word2_2:IsA("TextLabel")) then
            Word2_2 = nil
        end
        Word2 = Word2_2
        if Word1 then
            v3 = Word1.Text
        end
        OfflineEarningsDisplay = OfflineEarningsDisplay_2
        v6 = true
        v5 = nil
        return OfflineEarningsDisplay_2
    end
    return nil
end

local function applyMode(v20) -- line 165 | captures: Amount, Word1, Word2, v3, v4, v5
    if v5 == v20 then
        return
    end
    v5 = v20
    local v21 = v20 == "reminder"
    local v22 = v4 > 0
    if Word1 then
        local Word1_2 = Word1
        if v21 then
            if v22 then
                Word1_2.Text = "Your Pets Earn Cash Offline:"
            else
                Word1_2.Text = "Your Pets Earn Cash Offline \240\159\152\136"
            end
        else
            Word1_2.Text = v3
        end
    end
    if Word2 then
        local Word2_2 = Word2
        if v21 then
            Word2_2.Text = "/Day \240\159\152\136"
        else
            Word2_2.Text = "/Day Offline \240\159\152\136"
        end
    end
    local v23 = not v21 or v22
    if Amount then
        Amount.Visible = v23
    end
    if Word2 then
        Word2.Visible = v23
    end
end

local v24 = {}

local function markDirty() -- line 197 | captures: v6
    task.defer(function() -- line 198 | captures: v6
        v6 = true
    end)
end

local function watchBase(v25) -- line 203 | captures: v6, v24, markDirty
    local function v26(v27, ...)
        table.insert(v27, ...)
    end

    local function v28(v29, ...)
        table.insert(v29, ...)
    end

    local function v30(v31, ...)
        table.insert(v31, ...)
    end

    for v32, v33 in v24 do
        v33:Disconnect()
    end
    table.clear(v24)
    v6 = true

    local function hookFolder(v34) -- line 210 | captures: v6, v24, markDirty
        local function v35(v36, ...)
            table.insert(v36, ...)
        end

        local function v37(v38, ...)
            table.insert(v38, ...)
        end

        v35(v24, v34.ChildAdded:Connect(markDirty))
        v37(v24, v34.ChildRemoved:Connect(markDirty))
        v6 = true
    end

    local PlacedAnimals = v25:FindFirstChild("PlacedAnimals")
    if PlacedAnimals then
        v26(v24, PlacedAnimals.ChildAdded:Connect(markDirty))
        v28(v24, PlacedAnimals.ChildRemoved:Connect(markDirty))
        v6 = true
    else
        v30(v24, v25.ChildAdded:Connect(function(v39) -- line 223 | captures: v6, v24, markDirty
            local function v40(v41, ...)
                table.insert(v41, ...)
            end

            local function v42(v43, ...)
                table.insert(v43, ...)
            end

            if v39.Name ~= "PlacedAnimals" then
                return
            end
            v40(v24, v39.ChildAdded:Connect(markDirty))
            v42(v24, v39.ChildRemoved:Connect(markDirty))
            v6 = true
        end))
    end
end

local IsPositionInPart = SafeZoneQuery.IsPositionInPart

function v1.Start() -- line 235 | captures: Amount, Word1, Word2, v3, v4, v5, v6, GuiService, RunService, FormatNumber, OfflineRewardConfig, TutorialConfig, LocalCharacter, OwnBase, LocalPlayer, placedRate, resolveDisplay, watchBase, IsPositionInPart
    OwnBase.Observe(watchBase)
    RunService.Heartbeat:Connect(function() -- line 241 | captures: Amount, Word1, Word2, v3, v4, v5, v6, GuiService, FormatNumber, OfflineRewardConfig, TutorialConfig, LocalCharacter, OwnBase, LocalPlayer, placedRate, resolveDisplay, IsPositionInPart
        local v44 = resolveDisplay()
        if not v44 then
            return
        end
        local v45 = LocalPlayer:GetAttribute(TutorialConfig.StageAttribute) ~= nil
        local v46 = not v45 and GuiService.MenuIsOpen
        local v47 = LocalCharacter.GetPosition()
        local v48 = OwnBase.Hitbox()
        local v49
        if v46 then
            v49 = v46
        else
            v49 = not v45
            if v49 then
                if v47 == nil or v48 == nil then
                    v49 = false
                else
                    v49 = IsPositionInPart(v48, v47)
                end
            end
        end
        if v49 then
            if v6 then
                v6 = false
                if Amount then
                    local MaxOfflineSeconds = OfflineRewardConfig.MaxOfflineSeconds
                    local v50 = math.min(86400, MaxOfflineSeconds)
                    local v51 = placedRate() * OfflineRewardConfig.OfflineRateMultiplier * v50
                    local v52 = math.floor(v51)
                    v4 = v52
                    v5 = nil
                    Amount.Text = ("$%*"):format((FormatNumber.Short(v52)))
                end
            end
            local v53 = if v46 then "reminder" else "plot"
            if v5 ~= v53 then
                v5 = v53
                local v54 = v53 == "reminder"
                local v55 = v4 > 0
                if Word1 then
                    local Word1_2 = Word1
                    if v54 then
                        if v55 then
                            Word1_2.Text = "Your Pets Earn Cash Offline:"
                        else
                            Word1_2.Text = "Your Pets Earn Cash Offline \240\159\152\136"
                        end
                    else
                        Word1_2.Text = v3
                    end
                end
                if Word2 then
                    local Word2_2 = Word2
                    if v54 then
                        Word2_2.Text = "/Day \240\159\152\136"
                    else
                        Word2_2.Text = "/Day Offline \240\159\152\136"
                    end
                end
                local v56 = not v54 or v55
                if Amount then
                    Amount.Visible = v56
                end
                if Word2 then
                    Word2.Visible = v56
                end
            end
        end
        if v44.Visible ~= v49 then
            v44.Visible = v49
        end
    end)
end

return v1
