-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local BillboardAssets = require(script.Parent.BillboardAssets)
local EggRewards = require(script.Parent.EggRewards)
local RarityGradientFX = require(script.Parent.RarityGradientFX)
local VariantLabel = require(script.Parent.VariantLabel)
local v1 = {
    TemplateName = "EggInfoUi",
    AttachmentName = "EggOverhead",
    Clearance = 1,
    RefFootprint = 2.5,
    MinScale = 0.75,
    MaxScale = 2,
    TitanicMaxScale = 7,
    HatchExponent = 0.75,
    HatchMaxScale = 9
}

local function labelInRow(v2) -- line 85
    if v2:IsA("TextLabel") then
        return v2
    end
    return v2:FindFirstChildWhichIsA("TextLabel", true)
end

local function fillRow(v3, v4, v5, v6) -- line 94
    local v7 = v3:FindFirstChild(v4, true)
    if v7 then
        if v5 then
            local v8
            if v7:IsA("TextLabel") then
                v8 = v7
            else
                v8 = v7:FindFirstChildWhichIsA("TextLabel", true)
            end
            if v8 then
                v8.Text = v5
                if v6 then
                    v8.TextColor3 = v6
                end
            end
            if v7:IsA("GuiObject") then
                v7.Visible = true
            end
        elseif v7:IsA("GuiObject") then
            v7.Visible = false
        end
    end
end

local v9 = {}
local v10 = { __mode = "k" }
local v11 = setmetatable(v9, v10)

function v1.Anchor(v12) -- line 127 | captures: v1, v11
    local v13 = v11[v12]
    if v13 and v13.Parent then
        return v13
    end
    local v14 = v12:FindFirstChild(v1.AttachmentName)
    local v15
    if v14 and v14:IsA("Attachment") then
        v15 = v14
    else
        local Model = v12:FindFirstAncestorOfClass("Model")
        v15 = Model and Model:FindFirstChild(v1.AttachmentName, true)
    end
    if not (v15 and v15:IsA("Attachment")) then
        return nil
    end
    v11[v12] = v15
    return v15
end

function v1.Host(v16) -- line 147 | captures: v1
    local v17 = v1.Anchor(v16)
    if v17 then
        return v17
    end
    local Model = v16:FindFirstAncestorOfClass("Model")
    if not (Model and Model.PrimaryPart) then
        return v16
    end
    return Model.PrimaryPart
end

local v18 = {}
local v19 = { __mode = "kv" }
local v20 = setmetatable(v18, v19)

function v1.Find(v21) -- line 166 | captures: v1, v20
    local v22 = v20[v21]
    if v22 and v22.Parent then
        return v22
    end
    local v23 = v1.Anchor(v21)
    local v24
    if v23 then
        v24 = v23:FindFirstChild(v1.TemplateName)
    end
    if not (v24 and v24:IsA("BillboardGui")) then
        v24 = v21:FindFirstChild(v1.TemplateName)
    end
    local v25
    if v24 and v24:IsA("BillboardGui") then
        v25 = v24
    else
        local Model = v21:FindFirstAncestorOfClass("Model")
        Model = Model and Model.PrimaryPart
        if not Model or Model == v21 then
        else
            v25 = Model:FindFirstChild(v1.TemplateName)
        end
    end
    if not (v25 and v25:IsA("BillboardGui")) then
        return nil
    end
    v20[v21] = v25
    return v25
end

function v1.WaitFor(v26, v27) -- line 193 | captures: v1
    local v28 = os.clock() + (v27 or 10)
    local v29
    while true do
        if v26.Parent then
            v29 = v1.Find(v26)
            if v29 then
                break
            end
            if v28 <= os.clock() then
                return nil
            end
            task.wait(0.1)
            continue
        end
        return nil
    end
    return v29
end

function v1.Attach(v30) -- line 213 | captures: BillboardAssets, v1
    local v31 = v1.Host(v30)
    local v32 = v1.Find(v30)
    if v32 then
        if v32.Parent ~= v31 then
            v32.Parent = v31
        end
        v1.Scale(v30, v32)
        return v32
    end
    local v33 = BillboardAssets.Get(v1.TemplateName)
    if v33 then
        local v34 = v33:Clone()
        v34.Parent = v31
        v1.Scale(v30, v34)
        return v34
    end
    return nil
end

local function Footprint(v35) -- line 242
    local X = v35.Size.X
    local Z = v35.Size.Z
    return (math.min(X, Z))
end

v1.Footprint = Footprint

function v1.ScaleFor(v36, v37) -- line 248 | captures: v1
    local v38 = v36 / v1.RefFootprint
    local MinScale = v1.MinScale
    local v39 = v37 or v1.MaxScale
    return (math.clamp(v38, MinScale, v39))
end

function v1.MaxScaleFor(v40) -- line 254 | captures: v1
    if v40:GetAttribute("Titanic") then
        return v1.TitanicMaxScale
    end
    return v1.MaxScale
end

function v1.GrowScale(v41, v42, v43) -- line 262 | captures: v1
    local v44 = math.max(v42, 0.001) ^ v1.HatchExponent
    local v45 = v1.ScaleFor(v41, v43) * v44
    local HatchMaxScale = v1.HatchMaxScale
    return (math.min(v45, HatchMaxScale))
end

local Size

function v1.ApplyScale(v46, v47, v48) -- line 281 | captures: Size, BillboardAssets, v1
    local Size_2 = Size
    local Size_3
    if Size_2 == nil then
        local v49 = BillboardAssets.Find(v1.TemplateName)
        local Size_2
        if v49 then
            Size_2 = v49.Size
            Size = Size_2
        else
            Size_2 = v46.Size
        end
        Size_3 = Size_2
    else
        Size_3 = Size_2
    end
    v46.Size = UDim2.new(Size_3.X.Scale * v47, Size_3.X.Offset * v47, Size_3.Y.Scale * v47, Size_3.Y.Offset * v47)
    local v50
    if v48 then
        local v51 = v1.Anchor(v48)
        local Parent, v52
        if v51 then
            Parent = v51.Parent
            if Parent and Parent:IsA("BasePart") then
                v52 = v51.Position.Y
            else
                Parent = v48
                v52 = 0
            end
        else
            Parent = v1.Host(v48)
            if not Parent:IsA("BasePart") then
                Parent = v48
            end
            v52 = 0
        end
        local v53 = Size_3.Y.Scale * v47
        v50 = Parent.Size.Y / 2 - v52 + v1.Clearance - (v46.SizeOffset.Y - 0.5) * v53
    else
        v50 = 0
    end
    local v54 = Vector3.new(0, v50, 0)
    if v46.StudsOffset ~= Vector3.new(0, 0, 0) then
        v46.StudsOffset = Vector3.new(0, 0, 0)
    end
    if v46.StudsOffsetWorldSpace ~= v54 then
        v46.StudsOffsetWorldSpace = v54
    end
    if v46.ExtentsOffset ~= Vector3.new(0, 0, 0) then
        v46.ExtentsOffset = Vector3.new(0, 0, 0)
    end
    if v46.ExtentsOffsetWorldSpace ~= Vector3.new(0, 0, 0) then
        v46.ExtentsOffsetWorldSpace = Vector3.new(0, 0, 0)
    end
end

function v1.Scale(v55, v56) -- line 344 | captures: v1
    v1.ApplyScale(v56, v1.ScaleFor(v1.Footprint(v55), v1.MaxScaleFor(v55)), v55)
end

function v1.Fill(v57, v58) -- line 351 | captures: EggRewards, RarityGradientFX, VariantLabel, v1, fillRow
    local v59 = v1.Attach(v57)
    if v59 then
        fillRow(v59, "Name", v58.Name)
        local Rarity = v58.Rarity
        local v60 = v58.Rarity and EggRewards.RarityColors[v58.Rarity] or nil
        fillRow(v59, "Rarity", Rarity, v60)
        if v58.Rarity then
            local v61 = v59:FindFirstChild("Rarity", true)
            if v61 and not v61:IsA("TextLabel") then
                v61 = v61:FindFirstChildWhichIsA("TextLabel", true)
            end
            if v61 then
                RarityGradientFX.ApplyToLabel(v61, v58.Rarity)
            end
        end
        local v62 = v59:FindFirstChild("Weight", true)
        if v62 and v62:IsA("GuiObject") then
            v62.Visible = false
        end
        local v63 = v59:FindFirstChild("Traits", true)
        if v63 and v63:IsA("GuiObject") then
            v63.Visible = false
        end
        VariantLabel.Fill(v59, v58.Trait)
        local v64 = v59:FindFirstChild("LuckMultiList", true)
        if v64 and v64:IsA("GuiObject") then
            v64.Visible = false
        end
        if v58.LuckText then
            local v65 = v59:FindFirstChild("LuckMulti", true)
            if v65 and v65:IsA("TextLabel") then
                v65.Text = v58.LuckText
            end
        end
        v1.Scale(v57, v59)
        return v59
    end
    return nil
end

local function FormatTimer(v66) -- line 401
    local v67 = math.ceil(v66)
    local v68 = math.max(v67, 0)
    if v68 >= 60 then
        return (("%*:%*"):format(v68 // 60, (string.format("%02d", v68 % 60))))
    end
    return (("%*s"):format(v68))
end

v1.FormatTimer = FormatTimer
return v1
