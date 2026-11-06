-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local BackpackUiConfig = require(ReplicatedStorage.Shared.BackpackUiConfig)
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local RarityGradientFX = require(ReplicatedStorage.Shared.RarityGradientFX)
local RobuxShopConfig = require(ReplicatedStorage.Shared.RobuxShopConfig)
local v1 = {}
local v2 = {}
for v3, v4 in RobuxShopConfig.EggPack.Tiles do
    v2[v4] = true
end
local LocalPlayer = Players.LocalPlayer
local ScreenGui, v5, AnimalName, Rarity, Earnings, v6, v7, v8
local v9 = 0
local v10 = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

local function findLabel(v11, v12) -- line 72
    local v13 = v11:FindFirstChild(v12)
    if not (v13 and v13:IsA("TextLabel")) then
        return nil
    end
    return v13
end

local function ensureCard() -- line 78 | captures: ScreenGui, v5, AnimalName, Rarity, Earnings, StarterGui, BackpackUiConfig, LocalPlayer
    if v5 and v5.Parent and ScreenGui and ScreenGui.Parent then
        return v5
    end
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local v14 = StarterGui:FindFirstChild("Scatchel") or PlayerGui and PlayerGui:FindFirstChild("Scatchel")
    local v15 = v14 and v14:FindFirstChild(BackpackUiConfig.AnimalInfoName)
    if v15 and v15:IsA("GuiObject") and PlayerGui then
        local ScreenGui_2 = Instance.new("ScreenGui")
        ScreenGui_2.Name = "ShopAnimalInfo"
        ScreenGui_2.ResetOnSpawn = false
        ScreenGui_2.IgnoreGuiInset = v14.IgnoreGuiInset == true
        ScreenGui_2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui_2.DisplayOrder = 50
        local v16 = v15:Clone()
        v16.Visible = false
        for v17, v18 in v16:GetDescendants() do
            if v18:IsA("GuiObject") then
                v18.Active = false
            end
        end
        v16.Active = false
        v16.Parent = ScreenGui_2
        ScreenGui_2.Parent = PlayerGui
        local v19 = v16:FindFirstChild("List") or v16
        ScreenGui = ScreenGui_2
        v5 = v16
        local AnimalName_2 = v19:FindFirstChild("AnimalName")
        if not (AnimalName_2 and AnimalName_2:IsA("TextLabel")) then
            AnimalName_2 = nil
        end
        AnimalName = AnimalName_2
        local Rarity_2 = v19:FindFirstChild("Rarity")
        if not (Rarity_2 and Rarity_2:IsA("TextLabel")) then
            Rarity_2 = nil
        end
        Rarity = Rarity_2
        local Earnings_2 = v19:FindFirstChild("Earnings")
        if not (Earnings_2 and Earnings_2:IsA("TextLabel")) then
            Earnings_2 = nil
        end
        Earnings = Earnings_2
        return v16
    end
    warn((("[ShopAnimalInfo] no authored Scatchel.%* card to clone"):format(BackpackUiConfig.AnimalInfoName)))
    return nil
end

local function paintRarity(v20, v21) -- line 120 | captures: RarityGradientFX
    for v22, v23 in v20:GetChildren() do
        if v23:IsA("UIGradient") then
            RarityGradientFX.Detach(v23)
            v23:Destroy()
        end
    end
    v20.Text = v21 or ""
    v20.Visible = v21 ~= nil
    if v21 then
        RarityGradientFX.ApplyToLabel(v20, v21)
    end
end

local function stopFollowing() -- line 134 | captures: v8
    if v8 then
        v8:Disconnect()
        v8 = nil
    end
end

function v1.Hide() -- line 141 | captures: v5, Rarity, v6, v7, v8, v9, RarityGradientFX
    v6 = nil
    v7 = nil
    v9 += 1
    if v8 then
        v8:Disconnect()
        v8 = nil
    end
    if v5 then
        v5.Visible = false
    end
    if Rarity then
        for v24, v25 in Rarity:GetChildren() do
            if v25:IsA("UIGradient") then
                RarityGradientFX.Detach(v25)
            end
        end
    end
end

local function updatePosition() -- line 159 | captures: ScreenGui, v5, v6, v7, GuiService, UserInputService, BackpackUiConfig, v1, v10
    local v26 = v5
    local ScreenGui_2 = ScreenGui
    local v27 = v6
    if v26 and ScreenGui_2 and v27 and not (not v27.Parent or not v27.Visible or v7 and not v7.Visible) then
        local v28
        if ScreenGui_2.IgnoreGuiInset then
            v28 = Vector2.zero
        else
            v28 = GuiService:GetGuiInset()
        end
        local AbsoluteSize = ScreenGui_2.AbsoluteSize
        local AbsoluteSize_2 = v26.AbsoluteSize
        local AnimalInfoCursorGap = BackpackUiConfig.AnimalInfoCursorGap
        local v29, X, v30
        if v10 then
            local ScreenGui = v27:FindFirstAncestorWhichIsA("ScreenGui")
            local zero
            if ScreenGui then
                if ScreenGui.IgnoreGuiInset then
                    zero = Vector2.zero
                else
                    zero = GuiService:GetGuiInset()
                end
            else
                zero = Vector2.zero
            end
            local v31 = v27.AbsolutePosition + zero - v28
            v29 = v31.X + v27.AbsoluteSize.X
            X = v31.X
            v30 = v31.Y + v27.AbsoluteSize.Y / 2
        else
            local v32 = UserInputService:GetMouseLocation() - v28
            v29 = v32.X
            X = v32.X
            v30 = v32.Y
        end
        local v33 = v29 + AnimalInfoCursorGap
        local v34 = v33 + AbsoluteSize_2.X
        if AbsoluteSize.X < v34 then
            v33 = X - AnimalInfoCursorGap - AbsoluteSize_2.X
        end
        local v35 = AbsoluteSize.X - AbsoluteSize_2.X
        local v36 = math.max(v35, 0)
        local v37 = math.clamp(v33, 0, v36)
        local v38 = v30 - AbsoluteSize_2.Y / 2
        local v39 = AbsoluteSize.Y - AbsoluteSize_2.Y
        local v40 = math.max(v39, 0)
        local v41 = math.clamp(v38, 0, v40)
        v26.AnchorPoint = Vector2.zero
        v26.Position = UDim2.fromOffset(v37, v41)
    else
        v1.Hide()
    end
end

local function show(v42, v43, v44) -- line 200 | captures: AnimalName, Rarity, Earnings, v6, v7, v8, RunService, BackpackUiConfig, EggRewards, FormatNumber, v2, ensureCard, paintRarity, updatePosition
    local v45 = ensureCard()
    if not v45 then
        return
    end
    if AnimalName then
        AnimalName.Text = EggRewards.DisplayName(v43)
    end
    if Rarity then
        paintRarity(Rarity, EggRewards.RarityOf(v43))
    end
    if not (Earnings and v2[v43]) then
        if Earnings then
            local v46 = EggRewards.CashPerSecond(v43)
            local Earnings_2 = Earnings
            if v46 and v46 > 0 then
                Earnings_2.Text = string.format(BackpackUiConfig.AnimalInfoEarningsFormat, FormatNumber.Short(v46))
            else
                Earnings_2.Text = ""
            end
            local Earnings_3 = Earnings
            if v46 == nil then
                Earnings_3.Visible = false
            else
                Earnings_3.Visible = v46 > 0
            end
        end
    else
        Earnings.Text = ""
        Earnings.Visible = false
    end
    v6 = v42
    v7 = v44
    updatePosition()
    if v6 == v42 then
        v8 = v8 or RunService.RenderStepped:Connect(updatePosition)
        v45.Visible = true
    end
end

function v1.Bind(v47, v48, v49, v50) -- line 237 | captures: v6, v9, v1, v10, show
    local function v51(v52, ...)
        table.insert(v52, ...)
    end

    local function v53(v54, ...)
        table.insert(v54, ...)
    end

    local function v55(v56, ...)
        table.insert(v56, ...)
    end

    local v57 = {}
    if v10 then
        if v47:IsA("GuiButton") then
            local Activated = v47.Activated
            v51(v57, Activated:Connect(function() -- line 241 | captures: v47, v48, v49, v6, v9, v1, show
                if v6 == v47 then
                    v1.Hide()
                else
                    show(v47, v48, v49)
                    v9 += 1
                    local v58 = v9
                    task.delay(2.5, function() -- line 249 | captures: v58, v9, v1
                        if v9 == v58 then
                            v1.Hide()
                        end
                    end)
                end
            end))
        end
    else
        local v59 = { v47 }
        for v60, v61 in v50 or {} do
            table.insert(v59, v61)
        end
        local v62 = {}
        for v63, v64 in v59 do
            local MouseEnter = v64.MouseEnter
            local v65 = v64
            v53(v57, MouseEnter:Connect(function() -- line 264 | captures: v47, v48, v49, v62, v65, v6, show
                if v6 == v47 then
                    v62[v65] = true
                else
                    table.clear(v62)
                    v62[v65] = true
                    show(v47, v48, v49)
                end
            end))
            local MouseLeave = v64.MouseLeave
            v55(v57, MouseLeave:Connect(function() -- line 275 | captures: v47, v62, v65, v6, v1
                v62[v65] = nil
                task.defer(function() -- line 279 | captures: v47, v62, v6, v1
                    if next(v62) == nil and v6 == v47 then
                        v1.Hide()
                    end
                end)
            end))
        end
    end
    return function() -- line 287 | captures: v47, v57, v6, v1
        for v66, v67 in v57 do
            v67:Disconnect()
        end
        table.clear(v57)
        if v6 == v47 then
            v1.Hide()
        end
    end
end

return v1
