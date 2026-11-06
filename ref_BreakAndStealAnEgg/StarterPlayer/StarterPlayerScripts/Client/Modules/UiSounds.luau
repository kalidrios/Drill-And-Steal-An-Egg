-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local v1 = {}
local v2 = 0
local v3

function v1.Play(v4) -- line 37 | captures: v3, Debris, SoundService
    if not (v3 and v3.Parent) then
        v3 = SoundService:FindFirstChild("UiSounds")
    end
    local v5 = v3 and v3:FindFirstChild(v4)
    if not (v5 and v5:IsA("Sound")) then
        return
    end
    local v6 = v5:Clone()
    v6.Parent = SoundService
    v6.Ended:Once(function() -- line 48 | captures: v6
        v6:Destroy()
    end)
    local TimeLength = v6.TimeLength
    Debris:AddItem(v6, math.max(TimeLength, 1) + 1)
    v6:Play()
end

function v1.Click() -- line 57 | captures: v1
    v1.Play("UiClick_2")
end

function v1.Hover() -- line 61 | captures: v2, v1
    local v7 = os.clock()
    if not (v7 - v2 < 0.05) then
        v2 = v7
        v1.Play("UiHover")
    end
end

return v1
