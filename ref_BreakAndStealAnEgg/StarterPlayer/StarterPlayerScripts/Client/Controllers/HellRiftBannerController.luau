-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HellEventConfig = require(ReplicatedStorage.Shared.HellEventConfig)
local HellLoadout = require(ReplicatedStorage.Shared.HellLoadout)
local Modules = script.Parent.Parent.Modules
local MainGui = require(Modules.MainGui)
local MessageBanner = require(Modules.MessageBanner)
local SpatialSfx = require(Modules.SpatialSfx)
local SpriteSheet = require(Modules.SpriteSheet)
local LocalPlayer = Players.LocalPlayer
local v1 = {}
local RiftBanner = HellEventConfig.RiftBanner
local v2 = {}
local v3

local function onResolve(v4) -- line 45 | captures: SpriteSheet, RiftBanner, v2
    local function v5(v6, ...)
        table.insert(v6, ...)
    end

    for v7, v8 in v2 do
        v8()
    end
    table.clear(v2)
    if RiftBanner.Flame then
        for v9, v10 in v4:GetDescendants() do
            if v10.Name == RiftBanner.Flame and (v10:IsA("ImageLabel") or v10:IsA("ImageButton")) then
                v5(v2, SpriteSheet.Play(v10))
            end
        end
    end
end

local v11 = RiftBanner and
MessageBanner.new({
    Name = RiftBanner.Name,
    Order = RiftBanner.Order,
    Hold = RiftBanner.Hold,
    OnResolve = onResolve
})

local function playCue() -- line 67 | captures: SpatialSfx, RiftBanner
    for v12, v13 in RiftBanner.Sfx or {} do
        SpatialSfx.Play(v13.Folder, v13.Name, {
            Mine = true,
            Volume = v13.Volume,
            PlaybackSpeed = v13.Speed
        })
    end
end

local function onChargeChanged() -- line 77 | captures: v3, Workspace, HellEventConfig, HellLoadout, LocalPlayer, playCue, v11
    local v14 = Workspace:GetAttribute(HellEventConfig.PortalChargeAttribute)
    if type(v14) == "number" and v14 ~= v3 then
        v3 = v14
        if not HellLoadout.InHell(LocalPlayer) then
            local v15 = Workspace:GetServerTimeNow() - v14
            if not (HellEventConfig.PortalCharge.Duration < v15) then
                v11:Show(function() -- line 90 | captures: playCue
                    playCue()
                end)
            end
        end
    end
end

function v1.Start() -- line 95 | captures: v3, Workspace, HellEventConfig, MainGui, onChargeChanged, v11
    if not v11 then
        return
    end
    MainGui.Observe(function() -- line 101 | captures: v11
        v11:Resolve()
    end)
    v3 = Workspace:GetAttribute(HellEventConfig.PortalChargeAttribute)
    Workspace:GetAttributeChangedSignal(HellEventConfig.PortalChargeAttribute):Connect(function() -- line 108 | captures: onChargeChanged
        task.spawn(onChargeChanged)
    end)
end

return v1
