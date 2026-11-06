-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local RewardFlashController = require(script.Parent.RewardFlashController)
local v1 = {}
local v2 = (-1/0)
local v3 = (-1/0)
local v4

local function getTemplate() -- line 57 | captures: v4, SoundService
    if not (v4 and v4.Parent) then
        v4 = SoundService:FindFirstChild("rransCustomSFX")
    end
    local v5 = v4 and v4:FindFirstChild("Success")
    if v5 and v5:IsA("Sound") then
        return v5
    end
    return nil
end

local function preloadSting() -- line 75 | captures: v4, ContentProvider, SoundService
    if not (v4 and v4.Parent) then
        v4 = SoundService:FindFirstChild("rransCustomSFX")
    end
    local v6 = v4 and v4:FindFirstChild("Success")
    if not (v6 and v6:IsA("Sound")) then
        v6 = nil
    end
    if v6 then
        pcall(ContentProvider.PreloadAsync, ContentProvider, { v6 })
    end
end

local function playSound() -- line 85 | captures: v4, Debris, SoundService
    if not (v4 and v4.Parent) then
        v4 = SoundService:FindFirstChild("rransCustomSFX")
    end
    local v7 = v4 and v4:FindFirstChild("Success")
    if not (v7 and v7:IsA("Sound")) then
        v7 = nil
    end
    if not v7 then
        return
    end
    local v8 = v7:Clone()
    v8.Parent = SoundService
    v8.Ended:Once(function() -- line 93 | captures: v8
        v8:Destroy()
    end)
    local TimeLength = v8.TimeLength
    Debris:AddItem(v8, math.max(TimeLength, 1) + 1)
    v8:Play()
end

function v1.PlaySting() -- line 109 | captures: v2, v3, playSound
    local v9 = os.clock()
    if v9 - v2 < 1.5 or v9 - v3 < 0.2 then
        return false
    end
    v3 = v9
    playSound()
    return true
end

function v1.PlayBank() -- line 121 | captures: v2, v3, RewardFlashController, playSound
    local v10 = os.clock()
    if v10 - v2 < 1.5 then
        return false
    end
    v2 = v10
    RewardFlashController.Play()
    v3 = v10
    playSound()
    return true
end

function v1.Stop() -- line 136 | captures: v2, v3, RewardFlashController
    v2 = (-1/0)
    v3 = (-1/0)
    RewardFlashController.Stop()
end

function v1.Start() -- line 144 | captures: v4, ContentProvider, SoundService
    if not (v4 and v4.Parent) then
        v4 = SoundService:FindFirstChild("rransCustomSFX")
    end
    local v11 = v4 and v4:FindFirstChild("Success")
    if not (v11 and v11:IsA("Sound")) then
        v11 = nil
    end
    if v11 then
        pcall(ContentProvider.PreloadAsync, ContentProvider, { v11 })
    end
end

return v1
