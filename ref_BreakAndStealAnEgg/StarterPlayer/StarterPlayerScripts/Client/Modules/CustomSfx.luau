-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local v1 = {}
local v2 = {}

local function getFolder(v3) -- line 34 | captures: SoundService, v2
    local v4 = v2[v3]
    if not (v4 and v4.Parent) then
        v4 = SoundService:FindFirstChild(v3)
        v2[v3] = v4
    end
    return v4
end

function v1.Play(v5, v6, v7, v8) -- line 43 | captures: Debris, SoundService, v2
    local v9 = v8 or "rransCustomSFX"
    local v10 = v2[v9]
    if not (v10 and v10.Parent) then
        v10 = SoundService:FindFirstChild(v9)
        v2[v9] = v10
    end
    local v11 = v10 and v10:FindFirstChild(v5)
    local v12
    if v11 and v11:IsA("Sound") then
        v12 = v11:Clone()
        if v6 then
            v12.Volume = v6
        end
    else
        return
    end
    if v7 then
        v12.PlaybackSpeed = v7
    end
    v12.Parent = SoundService
    local Ended = v12.Ended
    local v13 = v12
    Ended:Once(function() -- line 58 | captures: v13
        v13:Destroy()
    end)
    local v14 = v12.TimeLength / v12.PlaybackSpeed
    Debris:AddItem(v12, math.max(v14, 1) + 1)
    v12:Play()
end

function v1.PlayCue(v15) -- line 67 | captures: v1
    for v16, v17 in v15 do
        v1.Play(v17.Name, v17.Volume, v17.Speed, v17.Folder)
    end
end

return v1
