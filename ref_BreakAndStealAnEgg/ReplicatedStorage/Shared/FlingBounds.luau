-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ZonesConfig = require(script.Parent.ZonesConfig)
local SafeZoneQuery = require(script.Parent.SafeZoneQuery)
local v1 = {}

local function maxWorldX(v2) -- line 37
    local CFrame = v2.CFrame
    local Size = v2.Size
    local X = CFrame.RightVector.X
    local v3 = math.abs(X) * Size.X * 0.5
    local X_2 = CFrame.UpVector.X
    local v4 = v3 + math.abs(X_2) * Size.Y * 0.5
    local X_3 = CFrame.LookVector.X
    local v5 = v4 + math.abs(X_3) * Size.Z * 0.5
    return CFrame.Position.X + v5
end

function v1.LandingLimitX() -- line 47 | captures: ZonesConfig, SafeZoneQuery, maxWorldX
    local v6 = SafeZoneQuery.GetSafeParts()
    if #v6 == 0 then
        return nil
    end
    local v7 = (-1/0)
    for v8, v9 in v6 do
        local v10 = maxWorldX(v9)
        v7 = math.max(v7, v10)
    end
    return v7 - ZonesConfig.Guard.FlingLandingInset
end

local v11 = RaycastParams.new()

v11.FilterType = Enum.RaycastFilterType.Exclude
v11.RespectCanCollide = true

local function hasGroundAt(v12) -- line 74 | captures: v11
    return workspace:Raycast(v12 + Vector3.new(0, 50, 0), Vector3.new(0, -450, 0), v11) ~= nil
end

function v1.MaxCarryFrom(v13, v14) -- line 96 | captures: v1, v11
    local v15 = Vector3.new(1, 0, 0)
    local v16 = v14 or v15
    local v17 = v1.LandingLimitX()
    local v18
    if v17 == nil then
        v18 = (1/0)
    elseif v16.X > 0.01 then
        local v19 = v17 - v13.X
        v18 = math.max(v19, 0) / v16.X
    else
        v18 = (1/0)
    end
    local v20 = math.min(v18, 700)
    for v21 = 1, 6 do
        if v20 <= 0 then
            return 0
        end
        local v22 = v13 + v16 * v20
        if workspace:Raycast(v22 + Vector3.new(0, 50, 0), Vector3.new(0, -450, 0), v11) ~= nil then
            return v20
        end
        v20 *= 0.6
    end
    return 0
end

return v1
