-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local v1 = { "MainGUI", "TutorialGUI" }
local v2 = Vector2.new(1920, 1080)
local TouchEnabled = UserInputService.TouchEnabled
local v3 = workspace.CurrentCamera
local v4

local function isTargetGui(v5) -- line 48 | captures: v1
    if #v1 == 0 then
        return true
    end
    for v6, v7 in ipairs(v1) do
        if v5.Name == v7 then
            return true
        end
    end
    return false
end

local function getScale() -- line 60 | captures: v3, v2
    local v8 = v3
    if v8 then
        local ViewportSize = v8.ViewportSize
        local v9 = ViewportSize.X / v2.X
        local v10 = ViewportSize.Y / v2.Y
        local v11 = math.min(v9, v10)
        return math.clamp(v11, 0.01, 500) * 1.5
    end
    return 1
end

local v12 = { "Sizing", "SizingMode", "ThicknessSizing" }

local function isScaledSizeStroke(v13) -- line 77 | captures: v12
    for v14, v15 in ipairs(v12) do
        local v16 = v15
        local v17, v18 = pcall(function() -- line 79 | captures: v13, v16
            local v19 = v13[v16]
            return (tostring(v19))
        end)
        if v17 and v18 ~= nil then
            return string.find(v18, "ScaledSize", 1, true) ~= nil
        end
    end
    return false
end

local function applyToStroke(v20, v21) -- line 89 | captures: TouchEnabled, isScaledSizeStroke
    if v20:GetAttribute("NoStrokeScale") ~= true then
        if isScaledSizeStroke(v20) then
            local OriginalThickness = v20:GetAttribute("OriginalThickness")
            if TouchEnabled then
                if typeof(OriginalThickness) ~= "number" then
                    OriginalThickness = v20.Thickness
                    v20:SetAttribute("OriginalThickness", OriginalThickness)
                end
                v20.Thickness = OriginalThickness * 1.75
            elseif typeof(OriginalThickness) == "number" then
                v20.Thickness = OriginalThickness
                v20:SetAttribute("OriginalThickness", nil)
            end
        else
            local OriginalThickness = v20:GetAttribute("OriginalThickness")
            if OriginalThickness == nil then
                OriginalThickness = v20.Thickness
                v20:SetAttribute("OriginalThickness", OriginalThickness)
            end
            v20.Thickness = OriginalThickness * v21
        end
    end
end

local function applyToGui(v22, v23) -- line 122 | captures: applyToStroke
    for v24, v25 in ipairs(v22:GetDescendants()) do
        if v25:IsA("UIStroke") then
            applyToStroke(v25, v23)
        end
    end
end

local function applyAll() -- line 130 | captures: v3, PlayerGui, v1, v2, applyToGui
    local v26 = v3
    local v27
    if v26 then
        local ViewportSize = v26.ViewportSize
        local v28 = ViewportSize.X / v2.X
        local v29 = ViewportSize.Y / v2.Y
        local v30 = math.min(v28, v29)
        v27 = math.clamp(v30, 0.01, 500) * 1.5
    else
        v27 = 1
    end
    for v31, v32 in ipairs(PlayerGui:GetChildren()) do
        if v32:IsA("ScreenGui") then
            local v33
            if #v1 == 0 then
                v33 = true
            else
                v33 = false
                for v34, v35 in ipairs(v1) do
                    if v32.Name == v35 then
                        v33 = true
                        break
                    end
                    v33 = false
                end
            end
            if v33 then
                applyToGui(v32, v27)
            end
        end
    end
end

local function bindCamera(v36) -- line 139 | captures: v3, v4, applyAll
    if v4 then
        v4:Disconnect()
        v4 = nil
    end
    v3 = v36
    if v3 then
        v4 = v3:GetPropertyChangedSignal("ViewportSize"):Connect(applyAll)
    end
    applyAll()
end

local CurrentCamera = workspace.CurrentCamera

if v4 then
    v4:Disconnect()
    v4 = nil
end
v3 = CurrentCamera

if v3 then
    v4 = v3:GetPropertyChangedSignal("ViewportSize"):Connect(applyAll)
end
applyAll()
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line 154 | captures: v3, v4, applyAll
    local CurrentCamera = workspace.CurrentCamera
    if v4 then
        v4:Disconnect()
        v4 = nil
    end
    v3 = CurrentCamera
    if v3 then
        v4 = v3:GetPropertyChangedSignal("ViewportSize"):Connect(applyAll)
    end
    applyAll()
end)
PlayerGui.DescendantAdded:Connect(function(v37) -- line 159 | captures: v3, v1, v2, applyToStroke
    if v37:IsA("UIStroke") then
        local ScreenGui = v37:FindFirstAncestorOfClass("ScreenGui")
        if ScreenGui then
            local v38
            if #v1 == 0 then
                v38 = true
            else
                local v39 = false
                for v40, v41 in ipairs(v1) do
                    if ScreenGui.Name == v41 then
                        v38 = true
                        v39 = true
                        break
                    end
                end
                if not v39 then
                    v38 = false
                end
            end
            if v38 then
                task.defer(function() -- line 164 | captures: v37, v3, v2, applyToStroke
                    if not v37.Parent then
                        return
                    end
                    local v42 = v3
                    local v43
                    if v42 then
                        local ViewportSize = v42.ViewportSize
                        local v44 = ViewportSize.X / v2.X
                        local v45 = ViewportSize.Y / v2.Y
                        local v46 = math.min(v44, v45)
                        v43 = math.clamp(v46, 0.01, 500) * 1.5
                    else
                        v43 = 1
                    end
                    applyToStroke(v37, v43)
                end)
            end
        end
    end
end)
applyAll()
