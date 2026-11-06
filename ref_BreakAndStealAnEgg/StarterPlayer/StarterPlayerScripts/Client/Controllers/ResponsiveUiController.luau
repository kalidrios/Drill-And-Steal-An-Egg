-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local ResponsiveUiConfig = require(ReplicatedStorage.Shared.ResponsiveUiConfig)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {}
local v2 = {}
local v3

local function viewportSize() -- line 56 | captures: Workspace, ResponsiveUiConfig
    local CurrentCamera = Workspace.CurrentCamera
    local v4 = CurrentCamera and CurrentCamera.ViewportSize
    if v4 and not (v4.X < 2) and not (v4.Y < 2) then
        return v4
    end
    return ResponsiveUiConfig.ReferenceViewport
end

local function growthFor(v5) -- line 69 | captures: ResponsiveUiConfig
    local v6 = ResponsiveUiConfig.ReferenceViewport.Y / v5.Y
    if v6 <= 1 then
        return 1
    end
    local v7 = v6 ^ ResponsiveUiConfig.SmallScreenCompensation
    local MaxGrowth = ResponsiveUiConfig.MaxGrowth
    return (math.min(v7, MaxGrowth))
end

local function applySize(v8, v9) -- line 81 | captures: ResponsiveUiConfig
    local v10 = ResponsiveUiConfig.ReferenceViewport.Y / v9.Y
    local v11
    if v10 <= 1 then
        v11 = 1
    else
        local v12 = v10 ^ ResponsiveUiConfig.SmallScreenCompensation
        local MaxGrowth = ResponsiveUiConfig.MaxGrowth
        v11 = math.min(v12, MaxGrowth)
    end
    local authoredSize = v8.authoredSize
    local MaxScreenFraction = ResponsiveUiConfig.MaxScreenFraction
    local new = UDim2.new
    local v13 = authoredSize.X.Scale * v11
    local X = MaxScreenFraction.X
    local v14 = math.min(v13, X)
    local v15 = authoredSize.X.Offset * v11
    local v16 = authoredSize.Y.Scale * v11
    local Y = MaxScreenFraction.Y
    local v17 = new(v14, v15, math.min(v16, Y), authoredSize.Y.Offset * v11)
    if v8.window.Size ~= v17 then
        v8.window.Size = v17
    end
end

local function applyAll() -- line 98 | captures: Workspace, ResponsiveUiConfig, v2, applySize
    local CurrentCamera = Workspace.CurrentCamera
    local v18 = CurrentCamera and CurrentCamera.ViewportSize
    if not v18 or v18.X < 2 or v18.Y < 2 then
        v18 = ResponsiveUiConfig.ReferenceViewport
    end
    for v19, v20 in v2 do
        applySize(v20, v18)
    end
end

local function register(v21) -- line 109 | captures: v2
    local v22 = {
        window = v21,
        authoredSize = v21.Size
    }
    table.insert(v2, v22)
end

local function watchViewport() -- line 120 | captures: v3, Workspace, ResponsiveUiConfig, v2, applySize, applyAll
    if v3 then
        v3:Disconnect()
    end
    local CurrentCamera = Workspace.CurrentCamera
    if CurrentCamera then
        v3 = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(applyAll)
    end
    local CurrentCamera_2 = Workspace.CurrentCamera
    local v23 = CurrentCamera_2 and CurrentCamera_2.ViewportSize
    if not v23 or v23.X < 2 or v23.Y < 2 then
        v23 = ResponsiveUiConfig.ReferenceViewport
    end
    for v24, v25 in v2 do
        applySize(v25, v23)
    end
end

function v1.Start() -- line 133 | captures: v3, Workspace, ResponsiveUiConfig, MainGui, v2, applySize, applyAll, watchViewport
    if v3 then
        v3:Disconnect()
    end
    local CurrentCamera = Workspace.CurrentCamera
    if CurrentCamera then
        v3 = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(applyAll)
    end
    local CurrentCamera_2 = Workspace.CurrentCamera
    local v26 = CurrentCamera_2 and CurrentCamera_2.ViewportSize
    if not v26 or v26.X < 2 or v26.Y < 2 then
        v26 = ResponsiveUiConfig.ReferenceViewport
    end
    for v27, v28 in v2 do
        applySize(v28, v26)
    end
    Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(watchViewport)
    MainGui.Observe(function(v29) -- line 143 | captures: Workspace, ResponsiveUiConfig, v2, applySize
        local Frames = v29:FindFirstChild("Frames")
        if not Frames then
            return
        end
        table.clear(v2)
        for v30, v31 in ResponsiveUiConfig.Windows do
            local v32 = Frames:FindFirstChild(v31)
            if v32 and v32:IsA("GuiObject") then
                local v33 = {
                    window = v32,
                    authoredSize = v32.Size
                }
                table.insert(v2, v33)
            end
        end
        local CurrentCamera = Workspace.CurrentCamera
        local v34 = CurrentCamera and CurrentCamera.ViewportSize
        if not v34 or v34.X < 2 or v34.Y < 2 then
            v34 = ResponsiveUiConfig.ReferenceViewport
        end
        for v35, v36 in v2 do
            applySize(v36, v34)
        end
    end)
end

return v1
