-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HellBossConfig = require(ReplicatedStorage.Shared.HellBossConfig)
local HellEssenceConfig = require(ReplicatedStorage.Shared.HellEssenceConfig)
local HellEventConfig = require(ReplicatedStorage.Shared.HellEventConfig)
local HellSummonConfig = require(ReplicatedStorage.Shared.HellSummonConfig)
local Modules = script.Parent.Parent.Modules
local LightningBolt = require(Modules.LightningBolt)
local SfxBudget = require(Modules.SfxBudget)
local SpatialSfx = require(Modules.SpatialSfx)
local VFXBurst = require(Modules.VFXBurst)
local v1 = {}
local Folder

local function effects() -- line 32 | captures: Folder, Workspace
    if Folder and Folder.Parent then
        return Folder
    end
    local Folder_2 = Instance.new("Folder")
    Folder_2.Name = "HellEssenceFX"
    Folder_2.Parent = Workspace
    Folder = Folder_2
    return Folder_2
end

local function nearestOrb(v2) -- line 44 | captures: Workspace, HellBossConfig, HellEventConfig, HellSummonConfig
    local v3 = Workspace:FindFirstChild(HellEventConfig.MapName)
    local v4 = v3 and v3:FindFirstChild(HellBossConfig.Shields.Folder)
    if v4 then
        local Position
        local v5 = (1/0)
        for v6, v7 in v4:GetChildren() do
            local v8 = v7:FindFirstChild(HellSummonConfig.Pylons.Orb, true)
            local Position_2
            if v8 and v8:IsA("BasePart") then
                Position_2 = v8.Position
            elseif v7:IsA("Model") then
                Position_2 = v7:GetPivot().Position
            end
            if Position_2 then
                local Magnitude = (Position_2 - v2).Magnitude
                if Magnitude < v5 then
                    Position = Position_2
                    v5 = Magnitude
                end
            end
        end
        return Position
    end
    return nil
end

local function playSfx(v9, v10) -- line 66 | captures: HellBossConfig, SpatialSfx
    local v11 = SpatialSfx.Play(v9.Folder, v9.Name, {
        At = v10,
        Range = v9.Range,
        MinRange = v9.MinRange,
        RollOffMode = Enum.RollOffMode.Linear,
        Volume = v9.Volume,
        PlaybackSpeed = v9.PlaybackSpeed
    })
    local v12, v13
    if v11 then
        if v11.SoundGroup then
            v13 = true
        else
            local v14 = SpatialSfx.Find(HellBossConfig.Sfx.Folder, HellBossConfig.Sfx.Slam.Name)
            v12 = v14 and v14.SoundGroup or nil
            v13 = false
        end
    else
        v13 = true
    end
    if not v13 then
        v11.SoundGroup = v12
    end
    return v11
end

local function onBroken(v15) -- line 82 | captures: Folder, Workspace, HellBossConfig, HellEssenceConfig, LightningBolt, SfxBudget, VFXBurst, nearestOrb, playSfx
    local Position = v15.Position
    local Burst = HellEssenceConfig.Burst
    VFXBurst.Play(HellBossConfig.Visuals.BlastName, CFrame.new(Position), Burst.Scale, Burst.Color)
    local BreakSoundEvery = HellEssenceConfig.Drain.BreakSoundEvery
    local Break = HellEssenceConfig.Sfx.Break
    if Break and SfxBudget.Ready("EssenceBreak", BreakSoundEvery) then
        playSfx(Break, Position)
    end
    local v16 = nearestOrb(Position)
    if not v16 then
        return
    end
    local Strike = LightningBolt.Strike
    local Zap = HellEssenceConfig.Zap
    local Folder_2
    if Folder and Folder.Parent then
        Folder_2 = Folder
    else
        Folder_2 = Instance.new("Folder")
        Folder_2.Name = "HellEssenceFX"
        Folder_2.Parent = Workspace
        Folder = Folder_2
    end
    Strike(Position, v16, Zap, Folder_2)
    if SfxBudget.Ready("EssenceBreakZap", BreakSoundEvery) then
        playSfx(HellEssenceConfig.Sfx.Zap, v16)
    end
end

local function drain(v17) -- line 104 | captures: Folder, Workspace, HellEssenceConfig, LightningBolt, SfxBudget, nearestOrb, playSfx
    local Drain = HellEssenceConfig.Drain
    local v18 = nearestOrb(v17.Position)
    if not v18 then
        return
    end

    local function eggPoint() -- line 110 | captures: v17
        return v17.Position
    end

    local v19 = table.clone(HellEssenceConfig.Sfx.Zap)
    v19.Volume = Drain.ZapVolume
    while true do
        local Strike, Zap, Folder_2, v20
        if v17.Parent and v17:GetAttribute("Hatching") then
            if v17:GetAttribute("Broken") then
                v20 = true
            else
                Strike = LightningBolt.Strike
                Zap = HellEssenceConfig.Zap
                if Folder and Folder.Parent then
                    Folder_2 = Folder
                else
                    Folder_2 = Instance.new("Folder")
                    Folder_2.Name = "HellEssenceFX"
                    Folder_2.Parent = Workspace
                    Folder = Folder_2
                end
                v20 = false
            end
        else
            v20 = true
        end
        if v20 then
            break
        end
        Strike(eggPoint, v18, Zap, Folder_2)
        if SfxBudget.Ready("EssenceDrainZap", Drain.ZapSoundEvery) then
            playSfx(v19, v18)
        end
        task.wait(Drain.StrikeEvery.Min + math.random() * (Drain.StrikeEvery.Max - Drain.StrikeEvery.Min))
    end
end

local function watch(v21) -- line 127 | captures: HellEssenceConfig, onBroken, drain
    if not v21:IsA("BasePart") or v21:GetAttribute("Broken") then
        return
    end
    local v22 = false

    local function startDrain() -- line 135 | captures: v22, v21, HellEssenceConfig, drain
        if v22 or not HellEssenceConfig.Drain.Enabled or not v21:GetAttribute("Hatching") then
            return
        end
        v22 = true
        task.spawn(drain, v21)
    end

    local v23 = v21:GetAttributeChangedSignal("Hatching"):Connect(startDrain)
    if not v22 and HellEssenceConfig.Drain.Enabled and v21:GetAttribute("Hatching") then
        v22 = true
        task.spawn(drain, v21)
    end
    local v24
    v24 = v21:GetAttributeChangedSignal("Broken"):Connect(function() -- line 145 | captures: v24, v21, v23, onBroken
        if not v21:GetAttribute("Broken") then
            return
        end
        v24:Disconnect()
        v23:Disconnect()
        onBroken(v21)
    end)
    v21.Destroying:Once(function() -- line 154 | captures: v24, v23
        v24:Disconnect()
        v23:Disconnect()
    end)
end

function v1.Start() -- line 160 | captures: CollectionService, HellEssenceConfig, watch
    for v25, v26 in CollectionService:GetTagged(HellEssenceConfig.EggTag) do
        watch(v26)
    end
    CollectionService:GetInstanceAddedSignal(HellEssenceConfig.EggTag):Connect(watch)
end

return v1
