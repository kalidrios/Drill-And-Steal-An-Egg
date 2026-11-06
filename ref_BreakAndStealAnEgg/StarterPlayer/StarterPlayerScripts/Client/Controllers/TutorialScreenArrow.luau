-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TutorialConfig = require(ReplicatedStorage.Shared.TutorialConfig)
local v1 = {}
local ScreenArrow = TutorialConfig.ScreenArrow
local Value = Enum.RenderPriority.Last.Value
local LocalPlayer = Players.LocalPlayer
local v2, v3
local v4 = false
local v5

local function getMainGui() -- line 45 | captures: LocalPlayer
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v6 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    if v6 and v6:IsA("ScreenGui") then
        return v6
    end
    return nil
end

local function ensureArrow() -- line 56 | captures: v5, ScreenArrow, LocalPlayer
    if v5 and v5.Parent then
        return v5
    end
    v5 = nil
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v7 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    if not (v7 and v7:IsA("ScreenGui")) then
        v7 = nil
    end
    local v8 = v7 and v7:FindFirstChild("Arrow")
    if v8 and v8:IsA("ImageLabel") then
        local v9 = v8:Clone()
        v9.Name = "ScreenArrow"
        v9.Visible = false
        v9.AnchorPoint = Vector2.new(0.5, 0.5)
        v9.ZIndex = ScreenArrow.ZIndex
        v9.Parent = v7
        v5 = v9
        return v9
    end
    return nil
end

local function hideArrow() -- line 78 | captures: v5
    if v5 and v5.Parent then
        v5.Visible = false
    end
end

local function step() -- line 84 | captures: v2, v3, v5, ScreenArrow, LocalPlayer, ensureArrow
    local v10 = v2 and v2()
    local CurrentCamera = workspace.CurrentCamera
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v11 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    if not (v11 and v11:IsA("ScreenGui")) then
        v11 = nil
    end
    if v10 and CurrentCamera and v11 then
        local v12 = ensureArrow()
        if v12 then
            local v13, v14
            if v3 then
                v13, v14 = v3(v10)
            else
                local HoverHeight = ScreenArrow.HoverHeight
                v13 = v10 + Vector3.new(0, HoverHeight, 0)
            end
            local v15, v16 = CurrentCamera:WorldToScreenPoint(v13)
            if v16 then
                local v17 = os.clock() * 2 * 3.141592653589793 / ScreenArrow.BobTime
                local v18 = (math.sin(v17) * 0.5 + 0.5) * ScreenArrow.BobDistance
                local AbsolutePosition = v11.AbsolutePosition
                local v19 = ScreenArrow.Gap + v12.AbsoluteSize.Y / 2 + v18 + (v14 or 0)
                v12.Rotation = 180
                v12.Position = UDim2.fromOffset(v15.X - AbsolutePosition.X, v15.Y - AbsolutePosition.Y - v19)
                v12.Visible = true
            elseif v5 and v5.Parent then
                v5.Visible = false
            end
        end
    elseif v5 and v5.Parent then
        v5.Visible = false
    end
end

function v1.Show(v20, v21) -- line 132 | captures: v2, v3, v4, RunService, Value, step
    v2 = v20
    v3 = v21
    if not v4 then
        v4 = true
        RunService:BindToRenderStep("TutorialScreenArrow", Value, step)
    end
end

function v1.Hide() -- line 141 | captures: v2, v3, v4, v5, RunService
    v2 = nil
    v3 = nil
    if v4 then
        v4 = false
        RunService:UnbindFromRenderStep("TutorialScreenArrow")
    end
    if v5 then
        v5:Destroy()
        v5 = nil
    end
end

return v1
