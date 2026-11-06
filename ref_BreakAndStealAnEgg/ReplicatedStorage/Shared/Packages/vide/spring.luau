-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

if not game then
    script = nil
end
local Vector3_2 = game and Vector3 or (nil).Vector3
local throw = require(script.Parent.throw)
local graph = require(script.Parent.graph)
local create_node = graph.create_node
local create_source_node = graph.create_source_node
local assert_stable_scope = graph.assert_stable_scope
local evaluate_node = graph.evaluate_node
local update_descendants = graph.update_descendants
local push_child_to_scope = graph.push_child_to_scope

local function Vec3(v1, v2, v3) -- line 40 | captures: Vector3_2
    return Vector3_2.new(v1, v2, v3)
end

local v4 = Vector3_2.new(0, 0, 0)
local v5 = {}

function v5.number(v6) -- line 69 | captures: Vector3_2, v4
    return Vector3_2.new(v6, 0, 0), v4
end

function v5.CFrame(v7) -- line 73 | captures: Vec3
    return v7.Position, Vec3(v7:ToEulerAnglesXYZ())
end

function v5.Color3(v8) -- line 77 | captures: Vector3_2, v4
    local R = v8.R
    local G = v8.G
    local B = v8.B
    return Vector3_2.new(R, G, B), v4
end

function v5.UDim(v9) -- line 82 | captures: Vector3_2, v4
    local Scale = v9.Scale
    local Offset = v9.Offset
    return Vector3_2.new(Scale, Offset, 0), v4
end

function v5.UDim2(v10) -- line 86 | captures: Vector3_2, Vec3
    local Scale = v10.X.Scale
    local Offset = v10.X.Offset
    local Scale_2 = v10.Y.Scale
    return Vector3_2.new(Scale, Offset, Scale_2), Vec3(v10.Y.Offset, 0, 0)
end

function v5.Vector2(v11) -- line 90 | captures: Vector3_2, v4
    local X = v11.X
    local Y = v11.Y
    return Vector3_2.new(X, Y, 0), v4
end

function v5.Vector3(v12) -- line 94 | captures: v4
    return v12, v4
end

function v5.Rect(v13) -- line 98 | captures: Vector3_2, Vec3
    local X = v13.Min.X
    local Y = v13.Min.Y
    local X_2 = v13.Max.X
    return Vector3_2.new(X, Y, X_2), Vec3(v13.Max.Y, 0, 0)
end

local v14 = {
    number = function(v15, v16) -- line 104
        return v15.X
    end,
    CFrame = function(v17, v18) -- line 108
        return CFrame.new(v17) * CFrame.fromEulerAnglesXYZ(v18.X, v18.Y, v18.Z)
    end,
    Color3 = function(v19) -- line 112
        local new = Color3.new
        local X = v19.X
        local v20 = math.clamp(X, 0, 1)
        local Y = v19.Y
        local v21 = math.clamp(Y, 0, 1)
        local Z = v19.Z
        return new(v20, v21, (math.clamp(Z, 0, 1)))
    end,
    UDim = function(v22) -- line 116
        local new = UDim.new
        local X = v22.X
        local Y = v22.Y
        return new(X, (math.round(Y)))
    end,
    UDim2 = function(v23, v24) -- line 120
        local new = UDim2.new
        local X = v23.X
        local Y = v23.Y
        local v25 = math.round(Y)
        local Z = v23.Z
        local X_2 = v24.X
        return new(X, v25, Z, (math.round(X_2)))
    end,
    Vector2 = function(v26) -- line 124
        return Vector2.new(v26.X, v26.Y)
    end,
    Vector3 = function(v27) -- line 128
        return v27
    end,
    Rect = function(v28, v29) -- line 132
        return Rect.new(v28.X, v28.Y, v28.Z, v29.X)
    end
}
local v30 = {}

function v30.__index(v31, v32) -- line 138 | captures: throw
    throw((("cannot spring type %*"):format(v32)))
end

setmetatable(v5, v30)
setmetatable(v14, v30)
local v33 = {}
local v34 = { __mode = "v" }
setmetatable(v33, v34)

local function spring(v35, v36, v37) -- line 151 | captures: throw, create_node, create_source_node, assert_stable_scope, evaluate_node, push_child_to_scope, v4, v5, v33
    local v38 = assert_stable_scope()
    local v39 = 6.283185307179586 / (v36 or 1)
    local v40 = v37 or 1
    local v41 = v39 ^ 2
    local v42 = v40 * (2 * v39)
    if v42 > 240 then
        throw("spring damping too high, consider reducing damping or increasing period")
    end
    local v43 = {
        source_value = false,
        k = v41,
        c = v42,
        x0_123 = v4,
        x1_123 = v4,
        v_123 = v4,
        x0_456 = v4,
        x1_456 = v4,
        v_456 = v4
    }
    local v44 = create_source_node(false)

    local function updater_effect() -- line 186 | captures: v35, v43, v44, v5, v33
        local v45 = v35()
        local v46, v47 = v5[typeof(v45)](v45)
        v43.x1_123 = v46
        v43.x1_456 = v47
        v43.source_value = v45
        v33[v43] = v44
        return v45
    end

    local v48 = create_node(v38, updater_effect, false)
    evaluate_node(v48)
    local x1_123 = v43.x1_123
    local x1_456 = v43.x1_456
    v43.x0_123 = x1_123
    v43.x0_456 = x1_456
    v44.cache = v43.source_value
    return function(...) -- line 204 | captures: v43, v44, push_child_to_scope, v4, v5, v33
        if select("#", ...) == 0 then
            push_child_to_scope(v44)
            return v44.cache
        end
        local v49 = ...
        local v50, v51 = v5[typeof(v49)](v49)
        v43.x0_123 = v50
        v43.x0_456 = v51
        v43.v_123 = v4
        v43.v_456 = v4
        v33[v43] = v44
        v44.cache = v49
        return v49
    end
end

local function step_springs(v52) -- line 228 | captures: v33
    for v53 in next, v33 do
        local k = v53.k
        local c = v53.c
        local x0_123 = v53.x0_123
        local x1_123 = v53.x1_123
        local v_123 = v53.v_123
        local x0_456 = v53.x0_456
        local x1_456 = v53.x1_456
        local v_456 = v53.v_456
        local v54 = x0_123 - x1_123
        local v55 = x0_456 - x1_456
        local v56 = v54 * -k
        local v57 = v55 * -k
        local v58 = v_123 * -c
        local v59 = v_456 * -c
        local v60 = (v56 + v58) * v52
        local v61 = (v57 + v59) * v52
        local v62 = v_123 + v60
        local v63 = v_456 + v61
        local v64 = x0_123 + v62 * v52
        local v65 = x0_456 + v63 * v52
        v53.x0_123 = v64
        v53.x0_456 = v65
        v53.v_123 = v62
        v53.v_456 = v63
    end
end

local v66 = {}

local function update_spring_sources() -- line 268 | captures: update_descendants, v14, v33, v66
    for v67, v68 in next, v33 do
        local x0_123 = v67.x0_123
        local x1_123 = v67.x1_123
        local v_123 = v67.v_123
        local x0_456 = v67.x0_456
        local x1_456 = v67.x1_456
        local v_456 = v67.v_456
        local v69 = x0_123 - x1_123
        local v70 = x0_456 - x1_456
        if (v_123 + v_456 + v69 + v70).Magnitude < 0.0001 then
            table.insert(v66, v67)
            v68.cache = v67.source_value
        else
            local source_value = v67.source_value
            v68.cache = v14[typeof(source_value)](x0_123, x0_456)
        end
        update_descendants(v68)
    end
    for v71, v72 in next, v66 do
        v33[v72] = nil
    end
    table.clear(v66)
end

return function() -- line 298 | captures: spring, step_springs, update_spring_sources
    local v73 = 0
    return spring,
        function(v74) -- line 301 | captures: v73, step_springs, update_spring_sources
            v73 += v74
            while v73 > 0.008333333333333333 do
                v73 -= 0.008333333333333333
                step_springs(0.008333333333333333)
            end
            update_spring_sources()
        end
end
