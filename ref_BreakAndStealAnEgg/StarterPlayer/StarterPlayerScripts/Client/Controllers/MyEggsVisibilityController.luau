-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MergeConfig = require(ReplicatedStorage.Shared.MergeConfig)
local LocalModelHider = require(script.Parent.Parent.Modules.LocalModelHider)
local SettingsState = require(script.Parent.Parent.Modules.SettingsState)
local v1 = {}
local PlacedEggTag = MergeConfig.PlacedEggTag
local LocalPlayer = Players.LocalPlayer

local function isMine(v2) -- line 31 | captures: LocalPlayer
    return v2:GetAttribute("OwnerUserId") == LocalPlayer.UserId
end

local function evaluate(v3) -- line 35 | captures: LocalModelHider, SettingsState, LocalPlayer
    if v3:GetAttribute("OwnerUserId") ~= LocalPlayer.UserId or SettingsState.Get("ViewMyEggs") == true then
        LocalModelHider.Show(v3)
    else
        LocalModelHider.Hide(v3)
    end
end

local function refresh() -- line 43 | captures: CollectionService, LocalModelHider, SettingsState, PlacedEggTag, LocalPlayer
    for v4, v5 in CollectionService:GetTagged(PlacedEggTag) do
        if v5:IsA("Model") then
            if v5:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
                if SettingsState.Get("ViewMyEggs") == true then
                    LocalModelHider.Show(v5)
                else
                    LocalModelHider.Hide(v5)
                end
            else
                LocalModelHider.Show(v5)
            end
        end
    end
end

function v1.Start() -- line 51 | captures: CollectionService, LocalModelHider, SettingsState, PlacedEggTag, LocalPlayer, refresh
    CollectionService:GetInstanceAddedSignal(PlacedEggTag):Connect(function(v6) -- line 52 | captures: LocalModelHider, SettingsState, LocalPlayer
        if not v6:IsA("Model") then
            return
        end
        if v6:GetAttribute("OwnerUserId") ~= LocalPlayer.UserId or SettingsState.Get("ViewMyEggs") == true then
            LocalModelHider.Show(v6)
        else
            LocalModelHider.Hide(v6)
        end
    end)
    CollectionService:GetInstanceRemovedSignal(PlacedEggTag):Connect(function(v7) -- line 57 | captures: LocalModelHider
        if v7:IsA("Model") then
            LocalModelHider.Show(v7)
        end
    end)
    SettingsState.Observe("ViewMyEggs", function() -- line 63 | captures: refresh
        refresh()
    end)
end

return v1
