-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TutorialConfig = require(ReplicatedStorage.Shared.TutorialConfig)
local v1 = {}
local Arrow = TutorialConfig.Arrow
local Value = Enum.RenderPriority.Last.Value
local LocalPlayer = Players.LocalPlayer
local v2
local v3 = false

local function findArrow() -- line 51 | captures: LocalPlayer
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v4 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    local v5 = v4 and v4:FindFirstChild("Arrow")
    if v5 and v5:IsA("ImageLabel") and v4:IsA("ScreenGui") then
        return v5
    end
    return nil
end

local function step() -- line 61 | captures: v2, Arrow, findArrow
    local v6 = findArrow()
    if v6 then
        local v7 = v2 and v2()
        if v7 then
            local v8 = os.clock() * 2 * 3.141592653589793 / Arrow.BobTime
            local v9 = (math.sin(v8) * 0.5 + 0.5) * Arrow.BobDistance
            local v10 = Arrow.Gap + v6.AbsoluteSize.Y / 2 + v9
            local AbsolutePosition = v6.Parent.AbsolutePosition
            local v11 = if v7.pointUp then v7.y + v10 else v7.y - v10
            v6.AnchorPoint = Vector2.new(0.5, 0.5)
            if v7.pointUp then
                v6.Rotation = 0
            else
                v6.Rotation = 180
            end
            v6.ZIndex = Arrow.ZIndex
            v6.Position = UDim2.fromOffset(v7.x - AbsolutePosition.X, v11 - AbsolutePosition.Y)
            v6.Visible = true
        else
            v6.Visible = false
        end
    end
end

function v1.Show(v12) -- line 91 | captures: v2, v3, RunService, Value, step
    v2 = v12
    if not v3 then
        v3 = true
        RunService:BindToRenderStep("TutorialUiArrow", Value, step)
    end
end

function v1.Hide() -- line 99 | captures: v2, v3, RunService, findArrow
    v2 = nil
    if v3 then
        v3 = false
        RunService:UnbindFromRenderStep("TutorialUiArrow")
    end
    local v13 = findArrow()
    if v13 then
        v13.Visible = false
    end
end

return v1
