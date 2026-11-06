-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local ZonesConfig = require(ReplicatedStorage.Shared.ZonesConfig)
local v1 = {}
local v2, v3, Position, v4

local function ensurePanel(v5) -- line 57 | captures: v2, v3, Position
    if v5 ~= v2 then
        v2 = v5
        v3 = nil
        Position = nil
    end
    if v3 and v3.Parent == v5 then
        return v3
    end
    local RecommendedSpeed = v5:FindFirstChild("RecommendedSpeed")
    if not (RecommendedSpeed and RecommendedSpeed:IsA("CanvasGroup")) then
        return nil
    end
    RecommendedSpeed.Visible = false
    local v6 = RecommendedSpeed:Clone()
    v6.Name = "ActiveRecommendedSpeed"
    v6.Visible = false
    v6.GroupTransparency = 0
    v6.Parent = v5
    v3 = v6
    Position = v6.Position
    return v6
end

local function cancelActiveTween() -- line 88 | captures: v4
    if v4 then
        v4:Cancel()
        v4 = nil
    end
end

local function getRequiredPower(v7) -- line 98 | captures: ZonesConfig
    local v8 = ZonesConfig.Get(v7)
    local v9 = v8 and v8.RequiredPower
    if v9 and v9 > 0 then
        return v9
    end
    return nil
end

local function setAmount(v10, v11) -- line 109 | captures: FormatNumber
    local Texts = v10:FindFirstChild("Texts")
    local v12 = Texts and Texts:FindFirstChild("Amount")
    if v12 and v12:IsA("TextLabel") then
        v12.Text = ("%* Speed"):format((FormatNumber.Short(v11)))
    end
end

function v1.Show(v13, v14) -- line 120 | captures: Position, v4, FormatNumber, ZonesConfig, ensurePanel
    local v15 = ensurePanel(v13)
    local Position_2 = Position
    if v15 and Position_2 then
        if v4 then
            v4:Cancel()
            v4 = nil
        end
    else
        return false
    end
    local v16 = ZonesConfig.Get(v14)
    local v17 = v16 and v16.RequiredPower
    if not (v17 and v17 > 0) then
        v17 = nil
    end
    local v18
    if v17 then
        local Texts = v15:FindFirstChild("Texts")
        v18 = Texts and Texts:FindFirstChild("Amount")
    else
        v15.Visible = false
        return false
    end
    if v18 and v18:IsA("TextLabel") then
        v18.Text = ("%* Speed"):format((FormatNumber.Short(v17)))
    end
    v15.Position = Position_2
    v15.GroupTransparency = 0
    v15.Visible = true
    return true
end

function v1.Hide(v19) -- line 143 | captures: v3, Position, v4, TweenService
    local v20 = v3
    local Position_2 = Position
    if v20 and Position_2 and v20.Parent and v20.Visible then
        if v4 then
            v4:Cancel()
            v4 = nil
        end
    else
        return
    end
    local v21 = UDim2.new(Position_2.X.Scale, Position_2.X.Offset, Position_2.Y.Scale - 0.9, Position_2.Y.Offset)
    local v22 = TweenService:Create(v20, v19, {
        GroupTransparency = 1,
        Position = v21
    })
    v4 = v22
    v22:Play()
end

function v1.HideNow() -- line 162 | captures: v3, Position, v4
    if v4 then
        v4:Cancel()
        v4 = nil
    end
    local v23 = v3
    if not (v23 and v23.Parent) then
        return
    end
    v23.Visible = false
    v23.GroupTransparency = 0
    if Position then
        v23.Position = Position
    end
end

return v1
