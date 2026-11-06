-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local HellEventConfig = require(ReplicatedStorage.Shared.HellEventConfig)
local MusicBus = require(ReplicatedStorage.Shared.MusicBus)
local SettingsConfig = require(ReplicatedStorage.Shared.SettingsConfig)
local SettingsState = require(script.Parent.Parent.Modules.SettingsState)
local v1 = {}

function v1.Start() -- line 45 | captures: Players, SoundService, Workspace, HellEventConfig, MusicBus, SettingsConfig, SettingsState
    local v2 = MusicBus.MusicGroup()
    if v2 then
        local v3 = MusicBus.AuthoredVolume()
        SettingsState.Observe("MusicVolume", function(v4) -- line 52 | captures: v2, v3
            if type(v4) == "number" then
                v2.Volume = v4 * v3
            end
        end)
    end
    local v5 = {}
    for v6, v7 in SettingsConfig.SfxGroupNames do
        local v8 = SoundService:FindFirstChild(v7)
        if v8 and v8:IsA("SoundGroup") then
            local v9 = {
                group = v8,
                authored = v8.Volume
            }
            table.insert(v5, v9)
        else
            warn((("[SoundSettingsController] SoundService.%* SoundGroup missing"):format(v7)))
        end
    end
    local v10 = SoundService:FindFirstChild(SettingsConfig.SfxRouteGroupName)
    local v11 = v10
    if not (v10 and v10:IsA("SoundGroup")) then
        v10 = Instance.new("SoundGroup")
        v11 = v10
        v10.Name = SettingsConfig.SfxRouteGroupName
        v10.Volume = 1
        v10.Parent = SoundService
    end
    local v12 = {
        authored = 1,
        group = v10
    }
    table.insert(v5, v12)
    local LocalPlayer = Players.LocalPlayer
    local v13 = 1

    local function applySfx() -- line 88 | captures: v13, v5, LocalPlayer, HellEventConfig, SettingsConfig
        local v14 = v13
        if v14 <= 0 and LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true then
            v14 = SettingsConfig.HellMutedSfxVolume
        end
        for v15, v16 in v5 do
            v16.group.Volume = v14 * v16.authored
        end
    end

    SettingsState.Observe("SfxVolume", function(v17) -- line 97 | captures: v13, v5, LocalPlayer, HellEventConfig, SettingsConfig
        if type(v17) ~= "number" then
            return
        end
        v13 = v17
        local v18 = v13
        if v18 <= 0 and LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true then
            v18 = SettingsConfig.HellMutedSfxVolume
        end
        for v19, v20 in v5 do
            v20.group.Volume = v18 * v20.authored
        end
    end)
    LocalPlayer:GetAttributeChangedSignal(HellEventConfig.PlayerAttribute):Connect(applySfx)

    local function route(v21) -- line 109 | captures: v11, v2
        if v21:IsA("Sound") and not (v2 and v21:IsDescendantOf(v2)) and v21.SoundGroup == nil then
            v21.SoundGroup = v11
        end
    end

    for v22, v23 in { SoundService, Workspace } do
        for v24, v25 in v23:GetDescendants() do
            if v25:IsA("Sound") then
                if v2 then
                    if not v25:IsDescendantOf(v2) and v25.SoundGroup == nil then
                        v25.SoundGroup = v11
                    end
                elseif v25.SoundGroup == nil then
                    v25.SoundGroup = v11
                end
            end
        end
        v23.DescendantAdded:Connect(route)
    end
end

return v1
