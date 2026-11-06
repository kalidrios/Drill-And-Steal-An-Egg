-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimalRenders = require(ReplicatedStorage.Shared.AnimalRenders)
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local EggTypeConfig = require(ReplicatedStorage.Shared.EggTypeConfig)
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local FuseMachineConfig = require(ReplicatedStorage.Shared.FuseMachineConfig)
local RarityGradientFX = require(ReplicatedStorage.Shared.RarityGradientFX)
local v1 = {}
local v2 = {
    Alpha = 0.55,
    Target = Color3.new(0, 0, 0)
}

local function paintRim(v3, v4) -- line 42 | captures: EggRewards, RarityGradientFX
    local UIGradient
    for v5, v6 in v3:GetChildren() do
        if v6:IsA("UIGradient") then
            if UIGradient then
                RarityGradientFX.Detach(v6)
                v6:Destroy()
            else
                UIGradient = v6
            end
        end
    end
    if not UIGradient then
        UIGradient = Instance.new("UIGradient")
        UIGradient.Name = "RarityGradient"
        UIGradient.Parent = v3
    end
    UIGradient.Enabled = true
    UIGradient.Offset = Vector2.zero
    UIGradient.Transparency = NumberSequence.new(0)
    v3.Color = Color3.new(1, 1, 1)
    if RarityGradientFX.Attach(UIGradient, v4) then
        return
    end
    UIGradient.Enabled = false
    v3.Color = EggRewards.RarityColors[v4] or Color3.new(1, 1, 1)
end

local function setText(v7, v8, v9) -- line 71
    local v10 = v7:FindFirstChild(v8)
    if not (v10 and v10:IsA("TextLabel")) then
        return nil
    end
    v10.Text = v9
    return v10
end

local function rowsOf(v11) -- line 80
    local v12 = {}
    for v13, v14 in v11:GetChildren() do
        if v14:IsA("GuiObject") then
            table.insert(v12, v14)
        end
    end
    table.sort(v12, function(v15, v16) -- line 87
        if v15.LayoutOrder == v16.LayoutOrder then
            return v15.Name < v16.Name
        end
        return v15.LayoutOrder < v16.LayoutOrder
    end)
    return v12
end

local function paintRow(v17, v18, v19) -- line 96 | captures: AnimalRenders, EggRewards, EggTypeConfig, FormatNumber, RarityGradientFX, v2, paintRim
    local v20 = EggRewards.RarityOf(v18) or "Common"
    local v21 = EggRewards.RarityColors[v20] or Color3.new(1, 1, 1)
    v17:SetAttribute("Rarity", v20)
    v17:SetAttribute("AnimalName", v18)
    local v22 = EggRewards.DisplayName(v18)
    local PetName = v17:FindFirstChild("PetName")
    if PetName and PetName:IsA("TextLabel") then
        PetName.Text = v22
    end
    local v23 = EggTypeConfig.FormatChance(v19)
    local Amount = v17:FindFirstChild("Amount")
    if Amount and Amount:IsA("TextLabel") then
        Amount.Text = v23
    end
    local v24 = ("$%*/s"):format((FormatNumber.Short(EggRewards.CashPerSecond(v18))))
    local Cash = v17:FindFirstChild("Cash")
    if Cash and Cash:IsA("TextLabel") then
        Cash.Text = v24
    end
    local RarityText = v17:FindFirstChild("RarityText")
    if not (RarityText and RarityText:IsA("TextLabel")) then
        RarityText = nil
    else
        RarityText.Text = v20
    end
    if RarityText then
        RarityGradientFX.ApplyToLabel(RarityText, v20)
    end
    local RarityFill = v17:FindFirstChild("RarityFill")
    if RarityFill and RarityFill:IsA("UIGradient") then
        RarityGradientFX.Attach(RarityFill, v20, v2)
    end
    local RarityEdge = v17:FindFirstChild("RarityEdge")
    if RarityEdge and RarityEdge:IsA("UIStroke") then
        paintRim(RarityEdge, v20)
    end
    local IconTile = v17:FindFirstChild("IconTile")
    if not IconTile then
        return
    end
    local Icon = IconTile:FindFirstChild("Icon")
    if Icon and (Icon:IsA("ImageLabel") or Icon:IsA("ImageButton")) then
        AnimalRenders.Apply(Icon, v18)
    end
    local Glow = IconTile:FindFirstChild("Glow")
    if Glow and Glow:IsA("ImageLabel") then
        Glow.ImageColor3 = v21
    end
    local UIStroke = IconTile:FindFirstChildOfClass("UIStroke")
    if UIStroke then
        paintRim(UIStroke, v20)
    end
end

function v1.Fill(v25) -- line 137 | captures: EggTypeConfig, FuseMachineConfig, rowsOf, paintRow
    local EggChancesHolder = v25:FindFirstChild("EggChancesHolder")
    local v26 = EggChancesHolder and EggChancesHolder:FindFirstChild("RewardHolder")
    local v27 = EggTypeConfig.Get(FuseMachineConfig.EggType)
    local v28 = v27 and v27.HatchPool
    if not v26 or not v28 then
        warn("[FuseMachineChances] Chances list or egg HatchPool missing")
    else
        local v29 = EggTypeConfig.HatchOdds(FuseMachineConfig.EggType)
        for v30, v31 in rowsOf(v26) do
            local v32 = v28[v30]
            v31.Visible = v32 ~= nil
            if v32 then
                paintRow(v31, v32, v29[v32] or 0)
            end
        end
    end
end

return v1
