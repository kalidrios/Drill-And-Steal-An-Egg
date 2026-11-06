-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlacedAnimalBounds = require(ReplicatedStorage.Shared.PlacedAnimalBounds)
local v1 = {
    HalfSpanAttribute = "PlacedHalfSpan",
    Candidates = 14,
    Gap = 1.5
}

function v1.HalfSpanOf(v2) -- line 54 | captures: PlacedAnimalBounds, v1
    local v3 = v2:GetAttribute(v1.HalfSpanAttribute)
    if not (typeof(v3) == "number" and v3 >= 0) then
        return PlacedAnimalBounds.HalfSpan(v2)
    end
    return v3
end

function v1.Occupants(v4, v5) -- line 64 | captures: v1
    local v6 = {}
    if v4 then
        for v7, v8 in v4:GetChildren() do
            if v8:IsA("Model") and v8 ~= v5 then
                local PrimaryPart = v8.PrimaryPart
                local v9 = if PrimaryPart then PrimaryPart.Position else v8:GetPivot().Position
                local v10 = {
                    Position = v9,
                    HalfSpan = v1.HalfSpanOf(v8)
                }
                table.insert(v6, v10)
            end
        end
    end
    return v6
end

local function Clearance(v11, v12, v13) -- line 85
    if v13 then
        local v14 = (1/0)
        for v15, v16 in v13 do
            local v17 = v11.X - v16.Position.X
            local v18 = v11.Z - v16.Position.Z
            local v19 = v17 * v17 + v18 * v18
            local v20 = math.sqrt(v19) - (v12 + v16.HalfSpan)
            if v20 < v14 then
                v14 = v20
            end
        end
        return v14
    end
    return (1/0)
end

v1.Clearance = Clearance

function v1.Point(v21, v22, v23, v24, v25) -- line 110 | captures: PlacedAnimalBounds, v1
    local v26 = v22 or 0
    local v27 = v25 or v26
    local v28 = if not (v23 and #v23 > 0) then 1 else v1.Candidates
    local v29
    local v30 = (-1/0)
    for v31 = 1, v28 do
        local v32 = PlacedAnimalBounds.RandomPoint(v21, v27, v24)
        local v33 = v1.Clearance(v32, v26, v23)
        if v30 < v33 then
            v29 = v32
            v30 = v33
        end
        if v1.Gap <= v30 then
            break
        end
    end
    return v29 or PlacedAnimalBounds.RandomPoint(v21, v27, v24)
end

return v1
