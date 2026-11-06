-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local BillboardAssets = require(script.Parent.BillboardAssets)
local EggRewards = require(script.Parent.EggRewards)
local FormatNumber = require(script.Parent.FormatNumber)
local RarityGradientFX = require(script.Parent.RarityGradientFX)
local VariantLabel = require(script.Parent.VariantLabel)
local v1 = {
    TemplateName = "AnimalOverhead",
    AttachmentName = "AnimalOverheadAttachment",
    HeightAboveHead = 0.25,
    MinScale = 0.85,
    MaxScale = 2.2,
    TimerLowSeconds = 10,
    TimerLowColor = Color3.fromRGB(255, 80, 80)
}

local function getTemplate() -- line 40 | captures: BillboardAssets, v1
    return BillboardAssets.Get(v1.TemplateName)
end

local function labelInRow(v2) -- line 47
    if v2:IsA("TextLabel") then
        return v2
    end
    return (v2:FindFirstChildWhichIsA("TextLabel", true))
end

local function fillRow(v3, v4, v5, v6) -- line 58
    local v7 = v3:FindFirstChild(v4, true)
    if v7 then
        if v5 then
            if not v7:IsA("TextLabel") then
                v7 = v7:FindFirstChildWhichIsA("TextLabel", true)
            end
            if v7 then
                v7.Text = v5
                if v6 then
                    v7.TextColor3 = v6
                end
            end
        elseif v7:IsA("GuiObject") then
            v7.Visible = false
        end
    end
end

local v8 = {}
local v9 = { __mode = "k" }
local v10 = setmetatable(v8, v9)

local function resolveTimerRefs(v11) -- line 85 | captures: v1, v10
    local v12 = v10[v11]
    if v12 and v12.Billboard.Parent then
        return v12
    end
    local v13 = v11.PrimaryPart or v11:FindFirstChildWhichIsA("BasePart", true)
    local v14 = v13 and v13:FindFirstChild(v1.AttachmentName)
    local v15 = v14 and v14:FindFirstChildWhichIsA("BillboardGui")
    if v15 then
        local v16 = v15:FindFirstChild("SelfDestructTimer", true)
        local v17 = { Billboard = v15 }
        if not (v16 and v16:IsA("GuiObject")) then
            v17.Row = nil
        else
            v17.Row = v16
        end
        if v16 then
            if not v16:IsA("TextLabel") then
                v16 = v16:FindFirstChildWhichIsA("TextLabel", true)
            end
        else
            v16 = nil
        end
        v17.Label = v16
        v10[v11] = v17
        return v17
    end
    return nil
end

local function formatTimer(v18) -- line 107
    local v19 = math.ceil(v18)
    local v20 = math.max(v19, 0)
    if v20 >= 60 then
        return (("%*:%*"):format(v20 // 60, (string.format("%02d", v20 % 60))))
    end
    return (("%*s"):format(v20))
end

function v1.UpdateTimer(v21, v22) -- line 118 | captures: v1, resolveTimerRefs
    local v23 = resolveTimerRefs(v21)
    if not v23 then
        return
    end
    local Row = v23.Row
    if Row and not Row.Visible then
        Row.Visible = true
    end
    local Label = v23.Label
    if not Label then
        return
    end
    local AuthoredTimerColor = Label:GetAttribute("AuthoredTimerColor")
    if AuthoredTimerColor == nil then
        AuthoredTimerColor = Label.TextColor3
        Label:SetAttribute("AuthoredTimerColor", AuthoredTimerColor)
    end
    local v24 = math.ceil(v22)
    local v25 = math.max(v24, 0)
    local v26
    if v25 >= 60 then
        v26 = ("%*:%*"):format(v25 // 60, (string.format("%02d", v25 % 60)))
    else
        v26 = ("%*s"):format(v25)
    end
    if Label.Text ~= v26 then
        Label.Text = v26
    end
    if v22 <= v1.TimerLowSeconds then
        AuthoredTimerColor = v1.TimerLowColor
    end
    if Label.TextColor3 ~= AuthoredTimerColor then
        Label.TextColor3 = AuthoredTimerColor
    end
end

function v1.Attach(v27, v28) -- line 149 | captures: BillboardAssets, EggRewards, FormatNumber, RarityGradientFX, VariantLabel, v1
    local v29 = v27.PrimaryPart or v27:FindFirstChildWhichIsA("BasePart", true)
    if v29 and v27.Parent then
        local v30 = BillboardAssets.Get(v1.TemplateName)
        local v31
        if v30 then
            v31 = v29:FindFirstChild(v1.AttachmentName)
            if v31 then
                if not v31:IsA("Attachment") then
                    v31 = Instance.new("Attachment")
                    v31.Name = v1.AttachmentName
                    v31.Parent = v29
                    local v32, v33 = v27:GetBoundingBox()
                    local Position = v32.Position
                    local v34 = v33.Y / 2 + v1.HeightAboveHead
                    v31.WorldPosition = Position + Vector3.new(0, v34, 0)
                end
            else
                v31 = Instance.new("Attachment")
                v31.Name = v1.AttachmentName
                v31.Parent = v29
                local v35, v36 = v27:GetBoundingBox()
                local Position = v35.Position
                local v37 = v36.Y / 2 + v1.HeightAboveHead
                v31.WorldPosition = Position + Vector3.new(0, v37, 0)
            end
        else
            return nil
        end
        local BillboardGui = v31:FindFirstChildWhichIsA("BillboardGui")
        if BillboardGui then
            BillboardGui:Destroy()
        end
        local v38 = v30:Clone()
        if v28.CashPerSecond then
            local v39 = ("$%*/s"):format((FormatNumber.Short(v28.CashPerSecond)))
            local v40 = v38:FindFirstChild("CashPerSecond", true)
            if v40 then
                if v39 then
                    local v41
                    if v40:IsA("TextLabel") then
                        v41 = v40
                    else
                        v41 = v40:FindFirstChildWhichIsA("TextLabel", true)
                    end
                    if v41 then
                        v41.Text = v39
                    end
                elseif v40:IsA("GuiObject") then
                    v40.Visible = false
                end
            end
        else
            local v42 = v38:FindFirstChild("CashPerSecond", true)
            if v42 and v42:IsA("GuiObject") then
                v42.Visible = false
            end
        end
        local Rarity = v28.Rarity
        local v43 = v28.Rarity and EggRewards.RarityColors[v28.Rarity] or nil
        local v44 = v38:FindFirstChild("Rarity", true)
        if v44 then
            if Rarity then
                local v45
                if v44:IsA("TextLabel") then
                    v45 = v44
                else
                    v45 = v44:FindFirstChildWhichIsA("TextLabel", true)
                end
                if v45 then
                    v45.Text = Rarity
                    if v43 then
                        v45.TextColor3 = v43
                    end
                end
            elseif v44:IsA("GuiObject") then
                v44.Visible = false
            end
        end
        if v28.Rarity then
            local v46 = v38:FindFirstChild("Rarity", true)
            if v46 and not v46:IsA("TextLabel") then
                v46 = v46:FindFirstChildWhichIsA("TextLabel", true)
            end
            if v46 then
                RarityGradientFX.ApplyToLabel(v46, v28.Rarity)
            end
        end
        local v47 = v38:FindFirstChild("Traits", true)
        if v47 and v47:IsA("GuiObject") then
            v47.Visible = false
        end
        VariantLabel.Fill(v38, v28.Variant, v28.Mutation)
        local v48, v49
        if v28.DespawnSeconds then
            local DespawnSeconds = v28.DespawnSeconds
            local v50 = math.ceil(DespawnSeconds)
            local v51 = math.max(v50, 0)
            local v52
            if v51 >= 60 then
                v52 = ("%*:%*"):format(v51 // 60, (string.format("%02d", v51 % 60)))
            else
                v52 = ("%*s"):format(v51)
            end
            if v52 then
                v48 = v52
                v49 = true
            else
                v49 = false
            end
        else
            v49 = false
        end
        if not v49 then
            v48 = nil
        end
        local v53 = v38:FindFirstChild("SelfDestructTimer", true)
        if v53 then
            if v48 then
                local v54
                if v53:IsA("TextLabel") then
                    v54 = v53
                else
                    v54 = v53:FindFirstChildWhichIsA("TextLabel", true)
                end
                if v54 then
                    v54.Text = v48
                end
            elseif v53:IsA("GuiObject") then
                v53.Visible = false
            end
        end
        local v55 = v28.SizeMult or 1
        local MinScale = v1.MinScale
        local MaxScale = v1.MaxScale
        local v56 = math.clamp(v55, MinScale, MaxScale)
        v38.Size = UDim2.new(v38.Size.X.Scale * v56, v38.Size.X.Offset * v56, v38.Size.Y.Scale * v56, v38.Size.Y.Offset * v56)
        v38.SizeOffset = Vector2.new(0, 0.5)
        v38.Enabled = true
        v38.Parent = v31
        return v38
    end
    return nil
end

return v1
