-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local NotificationConfig = require(ReplicatedStorage.Shared.NotificationConfig)
local v1 = {}
local Waypoint = NotificationConfig.Waypoint
local Value = Enum.RenderPriority.Last.Value
local LocalPlayer = Players.LocalPlayer
local v2, v3
local v4 = false
local v5

local function getMainGui() -- line 57 | captures: LocalPlayer
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v6 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    if v6 and v6:IsA("ScreenGui") then
        return v6
    end
    return nil
end

local function ensureIcon() -- line 68 | captures: v5, Waypoint, LocalPlayer
    if v5 and v5.Parent then
        return v5
    end
    v5 = nil
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v7 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    if not (v7 and v7:IsA("ScreenGui")) then
        v7 = nil
    end
    local v8 = v7 and v7:FindFirstChild(Waypoint.TemplateName)
    if v8 and v8:IsA("ImageLabel") then
        local v9 = v8:Clone()
        v9.Name = "ActiveWaypoint"
        v9.Visible = false
        v9.AnchorPoint = Vector2.new(0.5, 0.5)
        v9.Parent = v7
        v5 = v9
        return v9
    end
    return nil
end

local function hideIcon() -- line 89 | captures: v5
    if v5 and v5.Parent then
        v5.Visible = false
    end
end

local function step() -- line 95 | captures: v2, v5, Waypoint, LocalPlayer, ensureIcon
    local v10 = v2 and v2()
    local CurrentCamera = workspace.CurrentCamera
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v11 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    if not (v11 and v11:IsA("ScreenGui")) then
        v11 = nil
    end
    if v10 and CurrentCamera and v11 then
        local v12 = ensureIcon()
        if v12 then
            local v13 = os.clock() * 2 * 3.141592653589793 / Waypoint.BobTime
            local v14 = (math.sin(v13) * 0.5 + 0.5) * Waypoint.BobDistance
            local HoverHeight = Waypoint.HoverHeight
            local v15, v16 = CurrentCamera:WorldToScreenPoint(v10 + Vector3.new(0, HoverHeight, 0))
            if v16 then
                local AbsolutePosition = v11.AbsolutePosition
                local v17 = Waypoint.Gap + v12.AbsoluteSize.Y / 2 + v14
                v12.Position = UDim2.fromOffset(v15.X - AbsolutePosition.X, v15.Y - AbsolutePosition.Y - v17)
            else
                local v18 = CurrentCamera.CFrame:PointToObjectSpace(v10)
                local v19 = Vector2.new(v18.X, -v18.Y)
                if v19.Magnitude < 0.001 then
                    v19 = Vector2.new(0, 1)
                end
                local Unit = v19.Unit
                local AbsoluteSize = v11.AbsoluteSize
                local v20 = AbsoluteSize / 2
                local v21 = AbsoluteSize.X / 2 - Waypoint.EdgeMargin
                local v22 = math.max(v21, 0)
                local v23 = AbsoluteSize.Y / 2 - Waypoint.EdgeMargin
                local v24 = math.max(v23, 0)
                local X = Unit.X
                local v25
                if math.abs(X) > 0.000001 then
                    local X = Unit.X
                    v25 = v22 / math.abs(X)
                else
                    v25 = (1/0)
                end
                local Y = Unit.Y
                local v26
                if math.abs(Y) > 0.000001 then
                    local Y = Unit.Y
                    v26 = v24 / math.abs(Y)
                else
                    v26 = (1/0)
                end
                local v27 = math.min(v25, v26) - v14
                local v28 = v20 + Unit * math.max(v27, 0)
                v12.Position = UDim2.fromOffset(v28.X, v28.Y)
            end
            v12.Visible = true
        end
    elseif v5 and v5.Parent then
        v5.Visible = false
    end
end

function v1.Show(v29, v30) -- line 154 | captures: v2, v3, v4, RunService, Value, step
    v2 = v29
    v3 = v30
    if not v4 then
        v4 = true
        RunService:BindToRenderStep("NotificationWaypoint", Value, step)
    end
end

function v1.Hide(v31) -- line 163 | captures: v2, v3, v4, v5, RunService
    if v31 ~= nil and v31 ~= v3 then
        return
    end
    v2 = nil
    v3 = nil
    if v4 then
        v4 = false
        RunService:UnbindFromRenderStep("NotificationWaypoint")
    end
    if v5 then
        v5:Destroy()
        v5 = nil
    end
end

return v1
