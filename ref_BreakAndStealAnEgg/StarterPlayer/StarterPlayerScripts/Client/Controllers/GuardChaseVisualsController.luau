-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local v1 = {}
local v2 = Color3.fromRGB(255, 0, 0)
local v3 = Color3.fromRGB(255, 255, 255)
local v4 = {}

local function stopVisuals(v5) -- line 36 | captures: v4
    local v6 = v4[v5]
    if not v6 then
        return
    end
    v4[v5] = nil
    v6.Tween:Cancel()
    v6.Highlight:Destroy()
    local Exclamation = v6.Exclamation
    if Exclamation and Exclamation.Parent then
        Exclamation.Visible = false
    end
    for v7, v8 in v6.HiddenElements do
        if v7.Parent then
            v7.Visible = v8
        end
    end
end

local function startVisuals(v9) -- line 56 | captures: TweenService, v2, v3, v4
    if v4[v9] then
        return
    end
    local Highlight = Instance.new("Highlight")
    Highlight.Adornee = v9
    Highlight.FillColor = v2
    Highlight.FillTransparency = 1
    Highlight.OutlineColor = v3
    Highlight.OutlineTransparency = 0
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.Enabled = true
    Highlight.Parent = v9
    local v10 = TweenService:Create(Highlight, TweenInfo.new(0.75, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true), { FillTransparency = 0.2 })
    v10.Completed:Connect(function() -- line 79 | captures: Highlight
        Highlight:Destroy()
    end)
    v10:Play()
    local v11 = {}
    local v12 = v9:FindFirstChild("GuardOverhead", true)
    local v13
    if v12 then
        local v14
        for v15, v16 in v12:GetChildren() do
            if v16:IsA("GuiObject") then
                if v16.Name == "ExclamationMark" then
                    v16.Visible = true
                    v14 = v16
                else
                    v11[v16] = v16.Visible
                    v16.Visible = false
                end
            end
            v13 = v14
        end
    end
    v4[v9] = {
        Highlight = Highlight,
        Tween = v10,
        Exclamation = v13,
        HiddenElements = v11
    }
end

local function update(v17) -- line 115 | captures: stopVisuals, startVisuals
    local ChaseState = v17:GetAttribute("ChaseState")
    if ChaseState == "WindUp" then
        stopVisuals(v17)
        startVisuals(v17)
    elseif ChaseState == "Chasing" then
        startVisuals(v17)
    else
        stopVisuals(v17)
    end
end

local v18 = {}

local function trackGuard(v19) -- line 133 | captures: stopVisuals, startVisuals, v18
    if not v19:IsA("Model") or v18[v19] then
        return
    end
    local ChaseState = v19:GetAttributeChangedSignal("ChaseState")
    v18[v19] = ChaseState:Connect(function() -- line 137 | captures: v19, stopVisuals, startVisuals
        local ChaseState = v19:GetAttribute("ChaseState")
        if ChaseState == "WindUp" then
            stopVisuals(v19)
            startVisuals(v19)
        elseif ChaseState == "Chasing" then
            startVisuals(v19)
        else
            stopVisuals(v19)
        end
    end)
    local ChaseState_2 = v19:GetAttribute("ChaseState")
    if ChaseState_2 == "WindUp" then
        stopVisuals(v19)
        startVisuals(v19)
    elseif ChaseState_2 == "Chasing" then
        startVisuals(v19)
    else
        stopVisuals(v19)
    end
end

function v1.Start() -- line 143 | captures: CollectionService, stopVisuals, v18, trackGuard
    for v20, v21 in CollectionService:GetTagged("ZoneGuard") do
        trackGuard(v21)
    end
    CollectionService:GetInstanceAddedSignal("ZoneGuard"):Connect(trackGuard)
    CollectionService:GetInstanceRemovedSignal("ZoneGuard"):Connect(function(v22) -- line 148 | captures: stopVisuals, v18
        if not v22:IsA("Model") then
            return
        end
        local v23 = v18[v22]
        if v23 then
            v23:Disconnect()
            v18[v22] = nil
        end
        stopVisuals(v22)
    end)
end

return v1
