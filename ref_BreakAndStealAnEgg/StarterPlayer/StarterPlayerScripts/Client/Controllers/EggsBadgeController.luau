-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MergeConfig = require(ReplicatedStorage.Shared.MergeConfig)
local HudBadge = require(script.Parent.HudBadge)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2
local v3 = {}

local function isOpenable(v4) -- line 34 | captures: LocalPlayer
    local Model = v4:IsA("Model")
    if Model then
        if v4:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
            Model = v4:GetAttribute("Ready") == true
        else
            Model = false
        end
    end
    return Model
end

local function refresh() -- line 40 | captures: v2, LocalPlayer, v3
    if not v2 then
        return
    end
    local v5 = 0
    for v6 in v3 do
        local Model = v6:IsA("Model")
        if Model then
            if v6:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
                Model = v6:GetAttribute("Ready") == true
            else
                Model = false
            end
        end
        if Model then
            v5 += 1
        end
    end
    v2.SetCount(v5)
end

local function unwatch(v7) -- line 53 | captures: v3, refresh
    local v8 = v3[v7]
    if not v8 then
        return
    end
    v3[v7] = nil
    for v9, v10 in v8 do
        v10:Disconnect()
    end
    refresh()
end

local function watch(v11) -- line 65 | captures: v3, refresh
    if not v3[v11] then
        v3[v11] = {
            v11:GetAttributeChangedSignal("Ready"):Connect(refresh),
            v11:GetAttributeChangedSignal("OwnerUserId"):Connect(refresh)
        }
        refresh()
    end
end

local function adopt(v12) -- line 78 | captures: v2, HudBadge, refresh
    local v13 = v12:WaitForChild("RightHUD", 10)
    local v14 = v13 and v13:FindFirstChild("Eggs")
    local v15 = v14 and v14:FindFirstChild("Notification")
    if v15 then
        local Inner = v15:FindFirstChild("Inner")
        local Attach = HudBadge.Attach
        local v16 = {}
        if not (Inner and Inner:IsA("UIStroke")) then
            v16.RingColor = nil
        else
            v16.RingColor = Inner.Color
        end
        v2 = Attach(v15, v16)
        refresh()
    else
        warn("[EggsBadgeController] missing RightHUD.Eggs.Notification")
        v2 = nil
    end
end

function v1.Start() -- line 96 | captures: CollectionService, MergeConfig, MainGui, unwatch, watch, adopt
    CollectionService:GetInstanceAddedSignal(MergeConfig.PlacedEggTag):Connect(watch)
    CollectionService:GetInstanceRemovedSignal(MergeConfig.PlacedEggTag):Connect(unwatch)
    for v17, v18 in CollectionService:GetTagged(MergeConfig.PlacedEggTag) do
        watch(v18)
    end
    MainGui.Observe(adopt)
end

return v1
