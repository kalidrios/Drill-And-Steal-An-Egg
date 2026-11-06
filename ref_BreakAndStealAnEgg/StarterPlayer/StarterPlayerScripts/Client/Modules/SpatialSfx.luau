-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = {}
local v3 = {}

function v1.IsMe(v4) -- line 58 | captures: LocalPlayer
    if typeof(v4) == "number" then
        return v4 == LocalPlayer.UserId
    end
    return false
end

function v1.Find(v5, v6) -- line 62 | captures: SoundService, v2
    local v7 = v2[v5]
    if not (v7 and v7.Parent) then
        v7 = SoundService:FindFirstChild(v5)
        v2[v5] = v7
    end
    local v8 = v7 and v7:FindFirstChild(v6)
    if v8 and v8:IsA("Sound") then
        return v8
    end
    return nil
end

local function emitterPosition(v9) -- line 75
    if typeof(v9) == "Vector3" then
        return v9
    end
    if v9:IsA("BasePart") then
        return v9.Position
    end
    if v9:IsA("Attachment") then
        return v9.WorldPosition
    end
    return nil
end

local function makeSound(v10, v11, v12) -- line 88 | captures: SoundService, Workspace, v1, v3
    local v13 = v1.Find(v10, v11)
    if v13 then
        local v14 = v12.Range or 80
        local Attachment, Attachment_2
        if v12.Mine then
        else
            local At = v12.At
            if At ~= nil and (typeof(At) ~= "Instance" or At.Parent ~= nil) then
                local CurrentCamera = Workspace.CurrentCamera
                local v15
                if typeof(At) == "Vector3" then
                    v15 = At
                elseif At:IsA("BasePart") then
                    v15 = At.Position
                elseif At:IsA("Attachment") then
                    v15 = At.WorldPosition
                end
                if CurrentCamera and v15 and v14 < (CurrentCamera.CFrame.Position - v15).Magnitude then
                    return nil, nil
                end
                if typeof(At) == "Vector3" then
                    Attachment = Instance.new("Attachment")
                    Attachment.Name = "SpatialSfx"
                    Attachment.WorldPosition = At
                    Attachment.Parent = Workspace.Terrain
                    Attachment_2 = Attachment
                else
                    Attachment = At
                    Attachment_2 = nil
                end
            else
                return nil, nil
            end
        end
        local v16 = v13:Clone()
        if v12.Volume then
            v16.Volume = v12.Volume
        end
        if v12.PlaybackSpeed then
            v16.PlaybackSpeed = v12.PlaybackSpeed
        end
        if Attachment then
            v16.RollOffMode = v12.RollOffMode or Enum.RollOffMode.LinearSquare
            local MinRange = v12.MinRange
            if not MinRange then
                local v17 = v14 / 2
                MinRange = math.min(10, v17)
            end
            v16.RollOffMinDistance = MinRange
            v16.RollOffMaxDistance = v14
            v16.Parent = Attachment
        else
            v16.Parent = SoundService
        end
        return v16, Attachment_2
    end
    local v18 = ("%*.%*"):format(v10, v11)
    if v12.WarnIfMissing ~= false and not v3[v18] then
        v3[v18] = true
        warn((("[SpatialSfx] SoundService.%* missing \226\128\148 silent"):format(v18)))
    end
    return nil, nil
end

function v1.Play(v19, v20, v21) -- line 145 | captures: Debris, makeSound
    local v22, v23 = makeSound(v19, v20, v21 or {})
    if v22 then
        local v24 = v23 or v22
        v22.Ended:Once(function() -- line 151 | captures: v24
            v24:Destroy()
        end)

        local function scheduleCleanup() -- line 159 | captures: v22, v24, Debris
            local PlaybackSpeed = v22.PlaybackSpeed
            local v25 = math.max(PlaybackSpeed, 0.05)
            Debris:AddItem(v24, v22.TimeLength / v25 + 1)
        end

        if not (v22.IsLoaded and v22.TimeLength > 0) then
            local v26 = v22.Loaded:Once(scheduleCleanup)
            task.delay(30, function() -- line 168 | captures: v22, v24, v26
                if not v22.IsLoaded then
                    v26:Disconnect()
                    v24:Destroy()
                end
            end)
        else
            local PlaybackSpeed = v22.PlaybackSpeed
            local v27 = math.max(PlaybackSpeed, 0.05)
            Debris:AddItem(v24, v22.TimeLength / v27 + 1)
        end
        v22:Play()
        return v22
    end
    return nil
end

function v1.PlayLooped(v28, v29, v30) -- line 182 | captures: Debris, TweenService, makeSound
    local v31 = v30 or {}
    local v32, v33 = makeSound(v28, v29, v31)
    if v32 then
        local v34 = v33 or v32
        v32.Looped = true
        v32:Play()
        local v35 = false
        return function() -- line 193 | captures: v35, v31, v32, v34, Debris, TweenService
            if v35 then
                return
            end
            v35 = true
            local v36 = v31.FadeOut or 0
            if not (v36 > 0 and v32.Parent) then
                v34:Destroy()
            else
                TweenService:Create(v32, TweenInfo.new(v36, Enum.EasingStyle.Linear), { Volume = 0 }):Play()
                Debris:AddItem(v34, v36 + 0.1)
            end
        end
    end
    return function() -- line 186
    end
end

return v1
