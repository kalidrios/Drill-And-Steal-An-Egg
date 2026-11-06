-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Workspace = game:GetService("Workspace")
local AnimalEggCenters = require(script.Parent.AnimalEggCenters)
local v1 = {}
local v2 = {
    Grid = 17,
    ShellThicknessFrac = 0.6,
    BodyCenterAttribute = "BodyCenter",
    ProbeCFrame = CFrame.new(0, 5000, 0)
}

v1.Config = v2

local v3 = {}
local v4 = { __mode = "k" }
local v5 = setmetatable(v3, v4)

local function measure(v6) -- line 42 | captures: Workspace, v2
    local v7 = v6:Clone()
    for v8, v9 in v7:GetChildren() do
        v9:Destroy()
    end
    v7.Anchored = true
    v7.CanCollide = false
    v7.CanTouch = false
    v7.CanQuery = true
    v7.CFrame = v2.ProbeCFrame
    v7.Parent = Workspace
    local v10 = RaycastParams.new()
    v10.FilterType = Enum.RaycastFilterType.Include
    v10.FilterDescendantsInstances = { v7 }
    local ProbeCFrame = v2.ProbeCFrame
    local Size = v7.Size
    local Grid = v2.Grid
    local v11 = {}
    local v12 = 0
    local v13 = pcall(function() -- line 63 | captures: v12, v10, ProbeCFrame, Size, Grid, v11, Workspace
        local v14 = Grid - 1
        for v15 = 0, v14 do
            local v16 = Grid - 1
            for v17 = 0, v16 do
                local v18 = (v15 / (Grid - 1) - 0.5) * Size.X * 0.999
                local v19 = (v17 / (Grid - 1) - 0.5) * Size.Z * 0.999
                local v20 = Size.Y / 2 + 1
                local v21 = ProbeCFrame:PointToWorldSpace((Vector3.new(v18, v20, v19)))
                local v22 = -(Size.Y + 2)
                local v23 = Workspace:Raycast(v21, Vector3.new(0, v22, 0), v10)
                if v23 then
                    local v24 = -Size.Y / 2 - 1
                    local v25 = ProbeCFrame:PointToWorldSpace((Vector3.new(v18, v24, v19)))
                    local v26 = Size.Y + 2
                    local v27 = Workspace:Raycast(v25, Vector3.new(0, v26, 0), v10)
                    local v28 = v23.Position.Y - ProbeCFrame.Y
                    local v29 = if v27 then v27.Position.Y - ProbeCFrame.Y else -Size.Y / 2
                    local v30 = v28 - v29
                    local v31 = math.max(v30, 0)
                    if v31 > 0 then
                        local v32 = Vector3.new(v18, v31, v19)
                        table.insert(v11, v32)
                        local v33 = v12
                        v12 = math.max(v33, v31)
                    end
                end
            end
        end
    end)
    v7:Destroy()
    if not v13 or v12 <= 0 then
        return (Vector3.new(0, 0, 0))
    end
    local ShellThicknessFrac = v2.ShellThicknessFrac
    local v34 = v12 * ShellThicknessFrac
    local v35 = 0
    local v36 = 0
    local v37 = 0
    for v38, v39 in v11 do
        if v34 <= v39.Y then
            v35, v36, v37 = v35 + v39.Y, v36 + v39.X * v39.Y, v37 + v39.Z * v39.Y
        end
    end
    if v35 <= 0 then
        return (Vector3.new(0, 0, 0))
    end
    local v40 = v36 / v35 / Size.X
    local v41 = v37 / v35 / Size.Z
    return (Vector3.new(v40, 0, v41))
end

v1.Measure = measure

function v1.GetBodyCenter(v42) -- line 115 | captures: AnimalEggCenters, v2, v5, measure
    local v43 = v5[v42]
    if v43 then
        return v43
    end
    local v44 = v42:GetAttribute(v2.BodyCenterAttribute)
    if typeof(v44) ~= "Vector3" then
        v44 = AnimalEggCenters[v42.Name] or measure(v42)
    end
    v5[v42] = v44
    return v44
end

return v1
