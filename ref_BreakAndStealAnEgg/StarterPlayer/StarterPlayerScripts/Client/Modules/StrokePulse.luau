-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local v1 = {}
local v2 = TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

function v1.Spawn(v3, v4) -- line 48 | captures: Debris, TweenService, v2
    local v5 = v4 or {}
    local v6 = v5.Tween or v2
    local v7 = v5.EndScale or 1.45
    local Frame = Instance.new("Frame")
    Frame.Name = "StrokePulse"
    Frame.BackgroundTransparency = 1
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.ZIndex = v3.ZIndex
    local v8 = v5.Corner or v3:FindFirstChildOfClass("UICorner")
    if v8 then
        v8:Clone().Parent = Frame
    end
    local v9 = v5.BaseStroke or v3:FindFirstChild("Outer")
    local v10
    if not (v9 and v9:IsA("UIStroke")) then
        v10 = Instance.new("UIStroke")
    else
        v10 = v9:Clone()
    end
    v10.Name = "Stroke"
    v10.Color = v5.Color or Color3.new(1, 1, 1)
    v10.Thickness = v5.Thickness or 3
    v10.Transparency = 0
    v10.Enabled = true
    v10.Parent = Frame
    Frame.Parent = v3
    TweenService:Create(Frame, v6, { Size = UDim2.fromScale(v7, v7) }):Play()
    TweenService:Create(v10, v6, { Transparency = 1 }):Play()
    Debris:AddItem(Frame, v6.Time + 0.1)
end

return v1
