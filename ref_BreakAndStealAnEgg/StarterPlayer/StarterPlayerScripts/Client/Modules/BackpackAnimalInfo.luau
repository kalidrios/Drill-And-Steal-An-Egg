-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local BackpackUiConfig = require(ReplicatedStorage.Shared.BackpackUiConfig)
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local RarityGradientFX = require(ReplicatedStorage.Shared.RarityGradientFX)
local WeightTag = require(ReplicatedStorage.Shared.WeightTag)
local BackpackSlotVisuals = require(script.Parent.BackpackSlotVisuals)
local v1 = {}
local v2, v3, AnimalName, Rarity, Earnings, Size, v4, TextColor3, v5, v6

local function findLabel(v7, v8) -- line 62
    local v9 = v7:FindFirstChild(v8)
    if not (v9 and v9:IsA("TextLabel")) then
        return nil
    end
    return v9
end

function v1.Init(v10) -- line 69 | captures: v2, v3, AnimalName, Rarity, Earnings, Size, v4, TextColor3, v6, BackpackUiConfig
    local v11 = v10:FindFirstChild(BackpackUiConfig.AnimalInfoName, true)
    if v11 and v11:IsA("GuiObject") then
        if v6 then
            v6:Disconnect()
            v6 = nil
        end
        local v12 = v11:FindFirstChild("List") or v11
        v2 = v11
        v3 = v11:FindFirstAncestorWhichIsA("ScreenGui")
        local AnimalName_2 = v12:FindFirstChild("AnimalName")
        if not (AnimalName_2 and AnimalName_2:IsA("TextLabel")) then
            AnimalName_2 = nil
        end
        AnimalName = AnimalName_2
        local Rarity_2 = v12:FindFirstChild("Rarity")
        if not (Rarity_2 and Rarity_2:IsA("TextLabel")) then
            Rarity_2 = nil
        end
        Rarity = Rarity_2
        local Earnings_2 = v12:FindFirstChild("Earnings")
        if not (Earnings_2 and Earnings_2:IsA("TextLabel")) then
            Earnings_2 = nil
        end
        Earnings = Earnings_2
        Size = v11.Size
        if Rarity then
            TextColor3 = Rarity.TextColor3
            local UIGradient = Rarity:FindFirstChildWhichIsA("UIGradient")
            if UIGradient then
                v4 = UIGradient:Clone()
            else
                v4 = nil
            end
        end
        v11.Visible = false
    else
        warn((("[BackpackAnimalInfo] no authored %* frame inside %*"):format(BackpackUiConfig.AnimalInfoName, (v10:GetFullName()))))
    end
end

local function paintRarity(v13, v14) -- line 99 | captures: v4, TextColor3, RarityGradientFX
    for v15, v16 in v13:GetChildren() do
        if v16:IsA("UIGradient") then
            RarityGradientFX.Detach(v16)
            v16:Destroy()
        end
    end
    if not (v14 and RarityGradientFX.ApplyToLabel(v13, v14)) then
        if TextColor3 then
            v13.TextColor3 = TextColor3
        end
        if v4 then
            v4:Clone().Parent = v13
        end
    end
end

local function rarityOf(v17) -- line 119 | captures: EggRewards
    local Rarity = v17:GetAttribute("Rarity")
    if typeof(Rarity) ~= "string" then
        local AnimalName = v17:GetAttribute("AnimalName")
        if typeof(AnimalName) == "string" then
            Rarity = EggRewards.RarityOf(AnimalName)
        else
            Rarity = nil
        end
    end
    if typeof(Rarity) == "string" then
        return Rarity
    end
    return nil
end

local function cashPerSecond(v18) -- line 130 | captures: EggRewards
    local AnimalName = v18:GetAttribute("AnimalName")
    if typeof(AnimalName) == "string" then
        return EggRewards.PlacedCashPerSecond(AnimalName, v18:GetAttribute("SizeMult"), v18:GetAttribute("Mutation"), v18:GetAttribute("WeightKg"), (v18:GetAttribute("Variant")))
    end
    return nil
end

local function scaled(v19, v20) -- line 144
    return UDim2.new(v19.X.Scale * v20, v19.X.Offset * v20, v19.Y.Scale * v20, v19.Y.Offset * v20)
end

local v21

local function updatePosition() -- line 164 | captures: v2, v3, v21, GuiService, UserInputService, BackpackUiConfig
    local v22 = v2
    local v23 = v3
    if v22 and v23 then
        if v22.Parent then
            local v24
            if v23.IgnoreGuiInset then
                v24 = Vector2.zero
            else
                v24 = GuiService:GetGuiInset()
            end
            local v25 = UserInputService:GetMouseLocation() - v24
            local AbsoluteSize = v23.AbsoluteSize
            local AbsoluteSize_2 = v22.AbsoluteSize
            local AnimalInfoCursorGap = BackpackUiConfig.AnimalInfoCursorGap
            local v26 = v25.X + AnimalInfoCursorGap
            local v27 = v26 + AbsoluteSize_2.X
            if AbsoluteSize.X < v27 then
                v26 = v25.X - AnimalInfoCursorGap - AbsoluteSize_2.X
            end
            local v28 = AbsoluteSize.X - AbsoluteSize_2.X
            local v29 = math.max(v28, 0)
            local v30 = math.clamp(v26, 0, v29)
            local v31 = v25.Y - AbsoluteSize_2.Y / 2
            local v32 = AbsoluteSize.Y - AbsoluteSize_2.Y
            local v33 = math.max(v32, 0)
            local v34 = math.clamp(v31, 0, v33)
            v22.AnchorPoint = Vector2.zero
            v22.Position = UDim2.fromOffset(v30, v34)
        else
            v21()
        end
    end
end

function v21() -- line 193 | captures: v6
    if v6 then
        v6:Disconnect()
        v6 = nil
    end
end

local function startFollowing() -- line 200 | captures: v6, RunService, updatePosition
    if not v6 then
        updatePosition()
        v6 = RunService.RenderStepped:Connect(updatePosition)
    end
end

function v1.Show(v35) -- line 209 | captures: v2, AnimalName, Rarity, Earnings, Size, v5, v6, RunService, BackpackUiConfig, FormatNumber, WeightTag, BackpackSlotVisuals, v1, paintRarity, rarityOf, cashPerSecond, updatePosition
    local v36 = v2
    if v36 then
        if v35 and (BackpackSlotVisuals.IsPet(v35) or BackpackSlotVisuals.IsEgg(v35)) then
            local v37 = BackpackSlotVisuals.IsEgg(v35)
            local WeightKg = v35:GetAttribute("WeightKg")
            local v38 = typeof(WeightKg) == "number"
            local v39 = BackpackSlotVisuals.DisplayName(v35)
            if AnimalName then
                local AnimalName_2 = AnimalName
                if v37 then
                    AnimalName_2.Text = v39
                elseif v38 then
                    AnimalName_2.Text = string.format(BackpackUiConfig.AnimalInfoNameFormat, v39, WeightTag.FormatKg(WeightKg))
                else
                    AnimalName_2.Text = v39
                end
            end
            if Rarity then
                if v37 then
                    local Rarity_2 = Rarity
                    if v38 then
                        Rarity_2.Text = string.format(BackpackUiConfig.WeightFormat, WeightTag.FormatKg(WeightKg))
                    else
                        Rarity_2.Text = ""
                    end
                    Rarity.Visible = v38
                    paintRarity(Rarity, nil)
                else
                    local v40 = rarityOf(v35)
                    Rarity.Text = v40 or ""
                    Rarity.Visible = v40 ~= nil
                    paintRarity(Rarity, v40)
                end
            end
            if Earnings then
                local v41
                if v37 then
                else
                    v41 = cashPerSecond(v35)
                end
                local Earnings_2 = Earnings
                if v41 then
                    Earnings_2.Text = string.format(BackpackUiConfig.AnimalInfoEarningsFormat, FormatNumber.Short(v41))
                else
                    Earnings_2.Text = ""
                end
                Earnings.Visible = v41 ~= nil
            end
            if Size then
                local v42 = Size
                if v37 then
                    local AnimalInfoEggScale = BackpackUiConfig.AnimalInfoEggScale
                    v42 = UDim2.new(v42.X.Scale * AnimalInfoEggScale, v42.X.Offset * AnimalInfoEggScale, v42.Y.Scale * AnimalInfoEggScale, v42.Y.Offset * AnimalInfoEggScale)
                end
                v36.Size = v42
            end
            v5 = v35
            if not v6 then
                updatePosition()
                v6 = RunService.RenderStepped:Connect(updatePosition)
            end
            v36.Visible = true
        else
            v1.Hide()
        end
    end
end

function v1.Refresh(v43) -- line 270 | captures: v5, v1
    if v5 == v43 then
        v1.Show(v43)
    end
end

function v1.Hide(v44) -- line 279 | captures: v2, v5, v21
    if v44 and v5 ~= v44 then
        return
    end
    v5 = nil
    v21()
    if v2 then
        v2.Visible = false
    end
end

return v1
