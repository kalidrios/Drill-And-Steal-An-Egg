-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local TweenService = game:GetService("TweenService")
local v1 = {}
local v2 = Vector2.new(0.5, 0.5)
local v3 = TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v4 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v5 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v6 = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In)

v1.OutroTime = v5.Time + v6.Time

local function anchorToCenter(v7) -- line 56 | captures: v2
    local AnchorPoint = v7.AnchorPoint
    if AnchorPoint == v2 then
        return
    end
    local v8 = 0.5 - AnchorPoint.X
    local v9 = 0.5 - AnchorPoint.Y
    local Size = v7.Size
    v7.AnchorPoint = v2
    v7.Position += UDim2.new(Size.X.Scale * v8, Size.X.Offset * v8, Size.Y.Scale * v9, Size.Y.Offset * v9)
end

function v1.Prepare(v10) -- line 70 | captures: anchorToCenter
    local ItemDisplay = v10:FindFirstChild("ItemDisplay")
    if not (ItemDisplay and ItemDisplay:IsA("GuiObject")) then
        ItemDisplay = v10
    end
    if ItemDisplay ~= v10 then
        anchorToCenter(ItemDisplay)
    end
    if ItemDisplay:IsA("GuiButton") then
        ItemDisplay:SetAttribute("NoButtonTween", true)
    end
    for v11, v12 in ItemDisplay:GetChildren() do
        if v12:IsA("UIScale") then
            v12:Destroy()
        end
    end
    local UIScale = Instance.new("UIScale")
    UIScale.Scale = 0
    UIScale.Parent = ItemDisplay
    local Amount = ItemDisplay:FindFirstChild("Amount")
    local UIScale_2
    if Amount and Amount:IsA("GuiObject") then
        anchorToCenter(Amount)
        for v13, v14 in Amount:GetChildren() do
            if v14:IsA("UIScale") then
                v14:Destroy()
            end
        end
        UIScale_2 = Instance.new("UIScale")
        UIScale_2.Scale = 0.4
        UIScale_2.Parent = Amount
    end
    return {
        Card = v10,
        Scale = UIScale,
        AmountScale = UIScale_2
    }
end

function v1.PlayIntro(v15, v16) -- line 121 | captures: TweenService, v3, v4
    local v17 = TweenService:Create(v15.Scale, v3, { Scale = 1 })
    v17:Play()
    local AmountScale = v15.AmountScale
    if AmountScale then
        task.delay(0.1, function() -- line 127 | captures: AmountScale, TweenService, v4
            if AmountScale.Parent then
                TweenService:Create(AmountScale, v4, { Scale = 1 }):Play()
            end
        end)
    end
    if v16 then
        v17.Completed:Once(function(v18) -- line 135 | captures: v16
            if v18 == Enum.PlaybackState.Completed then
                v16()
            end
        end)
    end
end

function v1.PlayOutro(v19) -- line 146 | captures: TweenService, v5, v6
    TweenService:Create(v19.Scale, v5, { Scale = 1.1 }):Play()
    task.delay(v5.Time, function() -- line 148 | captures: v19, TweenService, v6
        if v19.Scale.Parent then
            TweenService:Create(v19.Scale, v6, { Scale = 0 }):Play()
        end
    end)
end

function v1.OrderLeftToRight(v20) -- line 157
    local v21 = table.clone(v20)
    table.sort(v21, function(v22, v23) -- line 159
        local AbsolutePosition = v22.Card.AbsolutePosition
        local AbsolutePosition_2 = v23.Card.AbsolutePosition
        local v24 = AbsolutePosition.Y - AbsolutePosition_2.Y
        if math.abs(v24) > 2 then
            return AbsolutePosition.Y < AbsolutePosition_2.Y
        end
        return AbsolutePosition.X < AbsolutePosition_2.X
    end)
    return v21
end

return v1
