-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimalRenders = require(ReplicatedStorage.Shared.AnimalRenders)
local DemonEventConfig = require(ReplicatedStorage.Shared.DemonEventConfig)
local DemonEventUIConfig = require(ReplicatedStorage.Shared.DemonEventUIConfig)
local EggTypeConfig = require(ReplicatedStorage.Shared.EggTypeConfig)
local v1 = {}

local function formatPercent(v2) -- line 35
    local v3 = v2 * 1000
    local v4 = math.round(v3) / 1000
    return string.format("%g%%", v4)
end

local function poolOdds(v5) -- line 41 | captures: EggTypeConfig
    local v6 = EggTypeConfig.Get(v5)
    local v7 = v6 and v6.HatchPool
    if v7 then
        local HatchWeights = v6.HatchWeights
        local v8 = 0
        for v9, v10 in v7 do
            local v11
            if HatchWeights then
                local v12 = HatchWeights[v10] or 1
                v11 = math.max(v12, 0)
            else
                v11 = 1
            end
            v8 += v11
        end
        local v13 = {}
        for v14, v15 in v7 do
            local v16
            if HatchWeights then
                local v17 = HatchWeights[v15] or 1
                v16 = math.max(v17, 0)
            else
                v16 = 1
            end
            local v18 = { Name = v15 }
            if v8 > 0 then
                v18.Percent = v16 / v8 * 100
            else
                v18.Percent = 0
            end
            table.insert(v13, v18)
        end
        return v13
    end
    return {}
end

local function slotsOf(v19) -- line 61
    local v20 = {}
    for v21, v22 in v19:GetChildren() do
        if v22:IsA("Frame") then
            table.insert(v20, v22)
        end
    end
    table.sort(v20, function(v23, v24) -- line 68
        if v23.LayoutOrder == v24.LayoutOrder then
            return v23.Name < v24.Name
        end
        return v23.LayoutOrder < v24.LayoutOrder
    end)
    return v20
end

local function fitRow(v25, v26) -- line 78
    local UIListLayout = v25:FindFirstChildOfClass("UIListLayout")
    local v27 = if UIListLayout then UIListLayout.Padding.Scale else 0
    local v28 = 0
    local v29 = 0
    for v30, v31 in v26 do
        if v31.Visible then
            v28 += v31.Size.X.Scale
            v29 += 1
        end
    end
    local v32 = v29 - 1
    local v33 = 1 - v27 * math.max(v32, 0)
    if not (v28 <= v33 or v28 <= 0) then
        local v34 = v33 / v28
        for v35, v36 in v26 do
            local Size = v36.Size
            v36.Size = UDim2.new(Size.X.Scale * v34, Size.X.Offset, Size.Y.Scale * v34, Size.Y.Offset)
        end
    end
end

function v1.fill(v37) -- line 100 | captures: AnimalRenders, DemonEventConfig, DemonEventUIConfig, poolOdds, slotsOf, fitRow
    local v38 = v37:WaitForChild("Main", 10)
    local v39 = v38 and v38:FindFirstChild("EggTab")
    local v40 = v39 and v39:FindFirstChild("ItemList")
    local v41 = DemonEventConfig.Eggs[DemonEventConfig.EggTabOffer]
    if not v40 or not v41 then
        return
    end
    local v42 = poolOdds(v41.EggType)
    local v43 = slotsOf(v40)
    if #v42 == 0 or #v43 == 0 then
        return
    end
    local v44 = v43[1]
    while #v43 < #v42 do
        local v45 = v44:Clone()
        local v46 = #v43 + 1
        v45.Name = tostring(v46)
        v45.Parent = v40
        table.insert(v43, 1, v45)
    end
    local v47 = #v43 - #v42
    for v48, v49 in v43 do
        v49.LayoutOrder = v48
        local v50 = v42[v48 - v47]
        v49.Visible = v50 ~= nil
        if v50 then
            local Icon = v49:FindFirstChild("Icon")
            if Icon and (Icon:IsA("ImageLabel") or Icon:IsA("ImageButton")) then
                AnimalRenders.Apply(Icon, v50.Name)
                for v51, v52 in Icon:GetDescendants() do
                    if v52:IsA("ImageLabel") or v52:IsA("ImageButton") then
                        AnimalRenders.Apply(v52, v50.Name)
                    end
                end
            end
            v49:SetAttribute(DemonEventUIConfig.ANIMAL_ATTRIBUTE, v50.Name)
            v49:SetAttribute(DemonEventUIConfig.CHANCE_ATTRIBUTE, v50.Percent)
            local Amount = v49:FindFirstChild("Amount")
            if Amount and Amount:IsA("TextLabel") then
                local v53 = v50.Percent * 1000
                local v54 = math.round(v53) / 1000
                Amount.Text = string.format("%g%%", v54)
            end
        else
            v49:SetAttribute(DemonEventUIConfig.ANIMAL_ATTRIBUTE, nil)
            v49:SetAttribute(DemonEventUIConfig.CHANCE_ATTRIBUTE, nil)
        end
    end
    fitRow(v40, v43)
end

return v1
