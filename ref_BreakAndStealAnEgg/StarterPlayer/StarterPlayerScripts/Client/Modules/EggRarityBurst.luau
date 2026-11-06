-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local SettingsState = require(script.Parent.SettingsState)
local v1 = {}
local v2 = Color3.new(1, 1, 1)
local v3 = { Mythic = "Mythical" }
local v4 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v5 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0.55)
local v6 = Random.new()

local function sampleColorSequence(v7, v8) -- line 82
    local Keypoints = v7.Keypoints
    if v8 <= Keypoints[1].Time then
        return Keypoints[1].Value
    end
    local v9 = #Keypoints
    for v10 = 2, v9 do
        local v11 = Keypoints[v10]
        if v8 <= v11.Time then
            local v12 = Keypoints[v10 - 1]
            local v13 = v11.Time - v12.Time
            local v14 = if v13 > 0 then (v8 - v12.Time) / v13 else 1
            return v12.Value:Lerp(v11.Value, v14)
        end
    end
    return Keypoints[#Keypoints].Value
end

local function rollStarColor(v15) -- line 101 | captures: v6, sampleColorSequence
    local v16, v17, v18 = sampleColorSequence(v15.Color, v6:NextNumber()):ToHSV()
    return Color3.fromHSV(v16, v17, (math.max(v18, 0.75)))
end

function v1.Play(v19) -- line 107 | captures: Debris, Players, TweenService, EggRewards, SettingsState, v2, v3, v4, v5, v6, sampleColorSequence
    if SettingsState.Get("ScreenFFX") ~= true then
        return
    end
    local PlayerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
    local v20 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    local v21 = v20 and v20:FindFirstChild("EggRarityHatch")
    local Rarities, v22
    if v21 and v21:IsA("ImageLabel") then
        Rarities = v21:FindFirstChild("Rarities")
        v22 = v19 and v3[v19] or v19
    else
        return
    end
    local v23
    if not Rarities or not v22 then
    else
        v23 = Rarities:FindFirstChild(v22)
    end
    if not (v23 and v23:IsA("UIGradient")) then
        v23 = nil
    end
    local v24 = not v23 and v19 and EggRewards.RarityColors[v19] or v2
    local v25 = v21:Clone()
    v25.Name = "EggRarityBurstFX"
    v25.ImageColor3 = v24
    v25.ImageTransparency = 1
    v25.Visible = true
    local Rarities_2 = v25:FindFirstChild("Rarities")
    if Rarities_2 then
        Rarities_2:Destroy()
    end
    if v23 then
        local v26 = v23:Clone()
        v26.Enabled = true
        v26.Parent = v25
    end
    local Star = v25:FindFirstChild("Star")
    if not (Star and Star:IsA("ImageLabel")) then
        Star = nil
    else
        Star.Visible = false
    end
    v25.Parent = v20
    local v27 = TweenService:Create(v25, v4, { ImageTransparency = 0 })
    v27.Completed:Once(function() -- line 167 | captures: v25, TweenService, v5
        if v25.Parent then
            TweenService:Create(v25, v5, { ImageTransparency = 1 }):Play()
        end
    end)
    v27:Play()
    local v28 = v4.Time + v5.DelayTime + v5.Time
    if Star and Star:IsA("ImageLabel") then
        local Size = Star.Size
        for v29 = 1, 12 do
            local v30 = Star:Clone()
            v30.Visible = true
            if v23 then
                local v31, v32, v33 = sampleColorSequence(v23.Color, v6:NextNumber()):ToHSV()
                v30.ImageColor3 = Color3.fromHSV(v31, v32, (math.max(v33, 0.75)))
            else
                v30.ImageColor3 = v24
            end
            v30.AnchorPoint = Vector2.new(0.5, 0.5)
            local v34 = v6:NextNumber(0.5, 1.6)
            v30.Size = UDim2.new(Size.X.Scale * v34, Size.X.Offset * v34, Size.Y.Scale * v34, Size.Y.Offset * v34)
            local v35 = v6:NextNumber(0.08, 0.92)
            local v36 = v6:NextNumber(0.08, 0.92)
            v30.Position = UDim2.fromScale(v35, v36)
            v30.Rotation = v6:NextNumber(0, 360)
            local v37 = v6:NextNumber(0.9, 1.8)
            v28 = math.max(v28, v37)
            v30.Parent = v25
            local v38 = v6:NextNumber(-180, 180)
            TweenService:Create(v30, TweenInfo.new(v37, Enum.EasingStyle.Linear), { Rotation = v30.Rotation + v38 * v37 }):Play()
            TweenService:Create(v30, TweenInfo.new(v37, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = UDim2.fromScale(v35 + v6:NextNumber(-0.12, 0.12), v36 + v6:NextNumber(-0.12, 0.12)) }):Play()
            TweenService:Create(v30, TweenInfo.new(v37, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { ImageTransparency = 1 }):Play()
        end
    end
    Debris:AddItem(v25, v28 + 0.2)
end

return v1
