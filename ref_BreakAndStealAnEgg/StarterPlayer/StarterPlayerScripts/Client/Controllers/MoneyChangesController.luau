-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local TextBoundsWatch = require(script.Parent.Parent.Modules.TextBoundsWatch)
local LocalPlayer = Players.LocalPlayer
local v1 = {}
local v2 = 0
local v3 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v4 = TweenInfo.new(0.5)
local v5 = TweenInfo.new(0.75)
local v6, CashPopups, v7, Amount, v8
local v9 = false
local v10 = 0

local function computeStackX() -- line 86 | captures: v6, CashPopups, Amount
    local v11 = v6
    local CashPopups_2 = CashPopups
    local Amount_2 = Amount
    if v11 and CashPopups_2 and Amount_2 then
        local v12 = Amount_2.AbsolutePosition.X - v11.AbsolutePosition.X + Amount_2.TextBounds.X + v11.AbsoluteSize.Y * 0.25 + 0.5
        return (math.floor(v12))
    end
    return nil
end

local function applyStackX(v13) -- line 99 | captures: CashPopups, v8
    local CashPopups_2 = CashPopups
    if CashPopups_2 then
        v8 = v13
        CashPopups_2.Position = UDim2.new(0, v13, CashPopups_2.Position.Y.Scale, CashPopups_2.Position.Y.Offset)
    end
end

local trySettleShrink

local function trySettleShrink_2() -- line 110 | captures: v6, CashPopups, Amount, v8, v9, v10, trySettleShrink
    local v14 = os.clock() - v10
    if v14 < 0.4 then
        task.delay(0.4 - v14, trySettleShrink)
    else
        v9 = false
        local v15 = v6
        local CashPopups_2 = CashPopups
        local Amount_2 = Amount
        local v16
        if v15 and CashPopups_2 and Amount_2 then
            local v17 = Amount_2.AbsolutePosition.X - v15.AbsolutePosition.X + Amount_2.TextBounds.X + v15.AbsoluteSize.Y * 0.25 + 0.5
            v16 = math.floor(v17)
        end
        if v16 and v8 and v16 < v8 then
            local CashPopups_2 = CashPopups
            if not CashPopups_2 then
                return
            end
            v8 = v16
            CashPopups_2.Position = UDim2.new(0, v16, CashPopups_2.Position.Y.Scale, CashPopups_2.Position.Y.Offset)
        end
    end
end

trySettleShrink = trySettleShrink_2

local function updateStackX() -- line 123 | captures: v6, CashPopups, Amount, v8, v9, v10, trySettleShrink_2
    local v18 = v6
    local CashPopups_2 = CashPopups
    local Amount_2 = Amount
    local v19
    if v18 and CashPopups_2 and Amount_2 then
        local v20 = Amount_2.AbsolutePosition.X - v18.AbsolutePosition.X + Amount_2.TextBounds.X + v18.AbsoluteSize.Y * 0.25 + 0.5
        v19 = math.floor(v20)
    end
    if not v19 then
        return
    end
    v10 = os.clock()
    if not (v8 == nil or v8 < v19) then
        if v19 < v8 and not v9 then
            v9 = true
            task.delay(0.4, trySettleShrink_2)
        end
    else
        local CashPopups_2 = CashPopups
        if CashPopups_2 then
            v8 = v19
            CashPopups_2.Position = UDim2.new(0, v19, CashPopups_2.Position.Y.Scale, CashPopups_2.Position.Y.Offset)
        end
    end
end

local function resolveUI() -- line 147 | captures: v2, v6, CashPopups, v7, Amount, v8, MainGui, TextBoundsWatch, updateStackX
    local v21 = MainGui.Wait():WaitForChild("Currencies", 10)
    local v22 = v21 and v21:WaitForChild("Cash", 10)
    if v22 and v22:IsA("Frame") then
        local CashPopups_2 = v22:FindFirstChild("CashPopups")
        local v23 = CashPopups_2 and CashPopups_2:FindFirstChild("MoneyChange")
        if CashPopups_2 and CashPopups_2:IsA("Frame") and v23 and v23:IsA("TextLabel") then
            v6 = v22
            CashPopups = CashPopups_2
            v7 = v23
            local v24 = v22:FindFirstChild("Amount") and v22.Amount:FindFirstChild("Outer") or v23:FindFirstChild("Outer")
            if v24 and v24:IsA("UIStroke") then
                v2 = v24.Transparency
            end
            local Amount_2 = v22:FindFirstChild("Amount")
            if Amount_2 and Amount_2:IsA("TextLabel") then
                Amount = Amount_2
                v8 = nil
                TextBoundsWatch.Watch(Amount_2, updateStackX)
                v22:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateStackX)
            end
            return true
        end
        warn("[MoneyChangesController] Cash.CashPopups frame/template missing")
        return false
    end
    warn("[MoneyChangesController] Currencies.Cash frame missing")
    return false
end

local function ensureUI() -- line 198 | captures: v6, LocalPlayer, resolveUI
    if not (v6 ~= nil and v6:IsDescendantOf(LocalPlayer)) then
        return (resolveUI())
    end
    return true
end

local function spawnChange(v25) -- line 209 | captures: v2, CashPopups, v7, Debris, TweenService, FormatNumber, v3, v4, v5
    local CashPopups_2 = CashPopups
    local v26 = v7
    local v27, v28
    if CashPopups_2 and v26 then
        if v25 == 0 then
            v28 = true
        else
            v27 = v25 < 0
            v28 = false
        end
    else
        v28 = true
    end
    if v28 then
        return
    end
    local v29 = v26:Clone()
    v29.Visible = true
    local Outer = v29:FindFirstChild("Outer")
    local UIScale = v29:FindFirstChildOfClass("UIScale")
    local More = v29:FindFirstChild("More")
    local Less = v29:FindFirstChild("Less")
    local v30 = if v27 then "-" else "+"
    local Short = FormatNumber.Short
    local v31 = math.abs(v25)
    v29.Text = ("%*$%*"):format(v30, (Short((math.round(v31)))))
    if More then
        More.Enabled = not v27
    end
    if Less then
        Less.Enabled = v27
    end
    v29.TextTransparency = 1
    if Outer then
        Outer.Transparency = 1
    end
    if UIScale then
        UIScale.Scale = 0
    end
    v29.Parent = CashPopups_2
    TweenService:Create(v29, v4, { TextTransparency = 0 }):Play()
    if Outer then
        TweenService:Create(Outer, v4, { Transparency = v2 }):Play()
    end
    if UIScale then
        TweenService:Create(UIScale, v3, { Scale = 1 }):Play()
    end
    task.delay(1, function() -- line 250 | captures: v29, Outer, Debris, TweenService, v5
        if v29.Parent == nil then
            return
        end
        TweenService:Create(v29, v5, { TextTransparency = 1 }):Play()
        if Outer then
            TweenService:Create(Outer, v5, { Transparency = 1 }):Play()
        end
        Debris:AddItem(v29, 0.75)
    end)
end

function v1.Start() -- line 266 | captures: v6, LocalPlayer, resolveUI, spawnChange
    if resolveUI() then
        local v32 = LocalPlayer:GetAttribute("Cash")
        LocalPlayer:GetAttributeChangedSignal("Cash"):Connect(function() -- line 276 | captures: v32, v6, LocalPlayer, resolveUI, spawnChange
            local Cash = LocalPlayer:GetAttribute("Cash")
            if typeof(Cash) ~= "number" then
                return
            end
            local v33 = v32
            v32 = Cash
            if v33 ~= nil then
                local v34 = Cash - v33
                if v34 ~= 0 then
                    local v35
                    if v6 == nil then
                        v35 = resolveUI()
                    elseif v6:IsDescendantOf(LocalPlayer) then
                        v35 = true
                    else
                        v35 = resolveUI()
                    end
                    if v35 then
                        spawnChange(v34)
                    end
                end
            end
        end)
    end
end

return v1
