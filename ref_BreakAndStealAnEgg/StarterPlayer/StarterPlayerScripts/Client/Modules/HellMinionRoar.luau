-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local HellBossConfig = require(ReplicatedStorage.Shared.HellBossConfig)
local v1 = {}
local MinionRoar = HellBossConfig.Sfx.MinionRoar
local LocalPlayer = Players.LocalPlayer

function v1.Pick(v2) -- line 35 | captures: MinionRoar, LocalPlayer
    local Animal
    local v3 = (-1/0)
    for v4, v5 in v2 do
        local v6 = MinionRoar.Animals[v5.Animal]
        if v6 and v5.Target == LocalPlayer and v3 < v6.Priority then
            Animal, v3 = v5.Animal, v6.Priority
        end
    end
    return Animal
end

function v1.Play(v7, v8) -- line 46 | captures: Debris, SoundService, TweenService, HellBossConfig, MinionRoar
    local v9 = MinionRoar.Animals[v7]
    if v9 then
        local Far = MinionRoar.Far
        local Near = MinionRoar.Near
        local v10 = (v9.Volume or MinionRoar.Volume) * HellBossConfig.SfxVolume
        local Sound = Instance.new("Sound")
        Sound.Name = ("MinionRoar_%*"):format(v7)
        Sound.SoundId = v9.SoundId
        Sound.PlaybackSpeed = v9.PlaybackSpeed or 1
        Sound.Volume = v10 * Far.Volume
        Sound.SoundGroup = v8
        local EqualizerSoundEffect = Instance.new("EqualizerSoundEffect")
        EqualizerSoundEffect.LowGain = 0
        EqualizerSoundEffect.MidGain = Far.MidGain
        EqualizerSoundEffect.HighGain = Far.HighGain
        EqualizerSoundEffect.Parent = Sound
        local ReverbSoundEffect = Instance.new("ReverbSoundEffect")
        ReverbSoundEffect.DecayTime = 2.5
        ReverbSoundEffect.DryLevel = 0
        ReverbSoundEffect.WetLevel = Far.ReverbWet
        ReverbSoundEffect.Parent = Sound
        Sound.Parent = SoundService
        Sound:Play()
        local v11 = TweenInfo.new(MinionRoar.Approach, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        TweenService:Create(Sound, v11, { Volume = v10 }):Play()
        TweenService:Create(EqualizerSoundEffect, v11, {
            MidGain = Near.MidGain,
            HighGain = Near.HighGain
        }):Play()
        TweenService:Create(ReverbSoundEffect, v11, { WetLevel = Near.ReverbWet }):Play()
        Sound.Ended:Once(function() -- line 82 | captures: Sound
            Sound:Destroy()
        end)
        Debris:AddItem(Sound, 15)
        return Sound
    end
    return nil
end

return v1
