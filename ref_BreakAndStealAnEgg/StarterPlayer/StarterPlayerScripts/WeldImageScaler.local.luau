-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local v1 = Vector2.new(1920, 1080)
local v2 = workspace.CurrentCamera
local v3

local function getScale() -- line 31 | captures: v2, v1
    local v4 = v2
    if v4 then
        local ViewportSize = v4.ViewportSize
        local v5 = ViewportSize.X / v1.X
        local v6 = ViewportSize.Y / v1.Y
        local v7 = math.min(v5, v6)
        return (math.clamp(v7, 0.5, 2.5))
    end
    return 1
end

local function isTarget(v8) -- line 40
    return v8:IsA("ImageLabel") and v8.Name == "Weld"
end

local function applyToLabel(v9, v10) -- line 44
    local OriginalOffsetX = v9:GetAttribute("OriginalOffsetX")
    local OriginalOffsetY = v9:GetAttribute("OriginalOffsetY")
    if OriginalOffsetX == nil or OriginalOffsetY == nil then
        OriginalOffsetX = v9.Size.X.Offset
        OriginalOffsetY = v9.Size.Y.Offset
        v9:SetAttribute("OriginalOffsetX", OriginalOffsetX)
        v9:SetAttribute("OriginalOffsetY", OriginalOffsetY)
    end
    local new = UDim2.new
    local Scale = v9.Size.X.Scale
    local v11 = OriginalOffsetX * v10
    local v12 = math.round(v11)
    local Scale_2 = v9.Size.Y.Scale
    local v13 = OriginalOffsetY * v10
    v9.Size = new(Scale, v12, Scale_2, (math.round(v13)))
end

local function applyAll() -- line 62 | captures: v2, PlayerGui, v1, applyToLabel
    local v14 = v2
    local v15
    if v14 then
        local ViewportSize = v14.ViewportSize
        local v16 = ViewportSize.X / v1.X
        local v17 = ViewportSize.Y / v1.Y
        local v18 = math.min(v16, v17)
        v15 = math.clamp(v18, 0.5, 2.5)
    else
        v15 = 1
    end
    for v19, v20 in ipairs(PlayerGui:GetDescendants()) do
        if v20:IsA("ImageLabel") and v20.Name == "Weld" then
            applyToLabel(v20, v15)
        end
    end
end

local function bindCamera(v21) -- line 71 | captures: v2, v3, applyAll
    if v3 then
        v3:Disconnect()
        v3 = nil
    end
    v2 = v21
    if v2 then
        v3 = v2:GetPropertyChangedSignal("ViewportSize"):Connect(applyAll)
    end
    applyAll()
end

local CurrentCamera = workspace.CurrentCamera

if v3 then
    v3:Disconnect()
    v3 = nil
end
v2 = CurrentCamera

if v2 then
    v3 = v2:GetPropertyChangedSignal("ViewportSize"):Connect(applyAll)
end
applyAll()
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line 86 | captures: v2, v3, applyAll
    local CurrentCamera = workspace.CurrentCamera
    if v3 then
        v3:Disconnect()
        v3 = nil
    end
    v2 = CurrentCamera
    if v2 then
        v3 = v2:GetPropertyChangedSignal("ViewportSize"):Connect(applyAll)
    end
    applyAll()
end)
PlayerGui.DescendantAdded:Connect(function(v22) -- line 91 | captures: v2, v1, applyToLabel
    if v22:IsA("ImageLabel") and v22.Name == "Weld" then
        task.defer(function() -- line 94 | captures: v22, v2, v1, applyToLabel
            if not v22.Parent then
                return
            end
            local v23 = v2
            local v24
            if v23 then
                local ViewportSize = v23.ViewportSize
                local v25 = ViewportSize.X / v1.X
                local v26 = ViewportSize.Y / v1.Y
                local v27 = math.min(v25, v26)
                v24 = math.clamp(v27, 0.5, 2.5)
            else
                v24 = 1
            end
            applyToLabel(v22, v24)
        end)
    end
end)
applyAll()
