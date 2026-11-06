-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local EggConfig = require(ReplicatedStorage.Shared.EggConfig)
local v1 = {}
local ViewCull = EggConfig.ViewCull
local v2

if ViewCull.DebugPreview then
    local DebugShrinkDegrees = ViewCull.DebugShrinkDegrees
    v2 = -math.rad(DebugShrinkDegrees)
else
    local MarginDegrees = ViewCull.MarginDegrees
    v2 = math.rad(MarginDegrees)
end
local v3 = if ViewCull.DebugPreview then 0 else ViewCull.CloseRadius * ViewCull.CloseRadius
local v4 = ViewCull.RadiusScale * 0.5

v1.RENDER_PRIORITY_AFTER = Enum.RenderPriority.Camera.Value + 2

local v5 = false
local v6 = CFrame.identity
local v7 = Vector3.new(0, 0, 0)
local v8 = 1
local v9 = 1
local v10 = 1
local v11 = 1
local v12 = v2

local function capture() -- line 53 | captures: v5, v6, v7, v8, v9, v10, v11, v12
    local CurrentCamera = workspace.CurrentCamera
    if CurrentCamera then
        local ViewportSize = CurrentCamera.ViewportSize
        if ViewportSize.X <= 0 or ViewportSize.Y <= 0 then
            v5 = false
        else
            v6 = CurrentCamera.CFrame
            v7 = v6.Position
            local FieldOfView = CurrentCamera.FieldOfView
            local v13 = math.rad(FieldOfView) * 0.5
            local v14 = math.tan(v13) * ViewportSize.X / ViewportSize.Y
            local v15 = math.atan(v14)
            local v16 = v13 + v12
            local v17 = math.clamp(v16, 0.017453292519943295, 1.5533430342749532)
            local v18 = v15 + v12
            local v19 = math.clamp(v18, 0.017453292519943295, 1.5533430342749532)
            local v20 = math.tan(v17)
            local v21 = math.tan(v19)
            v9 = v20
            v8 = v21
            local v22 = 1 / math.cos(v17)
            local v23 = 1 / math.cos(v19)
            v11 = v22
            v10 = v23
            v5 = true
        end
    else
        v5 = false
    end
end

if ViewCull.DebugPreview then
    warn("[EggViewFrustum] DebugPreview is ON \226\128\148 eggs/animals will visibly cull near the screen edges. Turn it off in EggConfig.ViewCull before publishing.")
end
capture()
RunService:BindToRenderStep("EggViewFrustum", Enum.RenderPriority.Camera.Value + 1, capture)
local v24 = v3

function v1.IsSphereVisible(v25, v26) -- line 87 | captures: v5, v6, v7, v8, v9, v10, v11, v24
    if v5 then
        local v27 = v25 - v7
        if v27:Dot(v27) <= v24 then
            return true
        end
        local v28 = v6:PointToObjectSpace(v25)
        local v29 = -v28.Z
        if v29 < -v26 then
            return false
        end
        local X = v28.X
        local v30 = math.abs(X)
        if v29 * v8 + v26 * v10 < v30 then
            return false
        end
        local Y = v28.Y
        local v31 = math.abs(Y)
        return not (v29 * v9 + v26 * v11 < v31)
    end
    return true
end

function v1.IsVisible(v32, v33) -- line 112 | captures: v1, v4
    return v1.IsSphereVisible(v32, v33.Magnitude * v4)
end

function v1.IsEggVisible(v34) -- line 117 | captures: v1, v4
    return v1.IsSphereVisible(v34.Position, v34.Size.Magnitude * v4)
end

return v1
