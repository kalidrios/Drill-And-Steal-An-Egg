-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local v1 = {}
local T, gui, chainVisible, GRADIENT_TAG, SPRITE_VIS_EVERY
local v2 = {
    Spin = 1,
    Scroll = 2,
    Rainbow = 3,
    Sweep = 4
}
local sin = math.sin
local v3 = {}
local v4 = {}
local v5 = {}
local v6 = {}
local v7 = {}
local v8 = {}
local v9 = {}
local v10 = {}
local v11 = {}
local v12 = 0
local v13 = 0
local v14 = 0
local v15, v16
local v17 = 64
local v18
local v19 = {
    {
        0,
        Color3.fromRGB(255, 0, 0)
    },
    {
        0.125,
        Color3.fromRGB(255, 127, 0)
    },
    {
        0.25,
        Color3.fromRGB(255, 255, 0)
    },
    {
        0.375,
        Color3.fromRGB(0, 255, 0)
    },
    {
        0.5,
        Color3.fromRGB(0, 255, 255)
    },
    {
        0.625,
        Color3.fromRGB(17, 0, 255)
    },
    {
        0.75,
        Color3.fromRGB(149, 0, 255)
    },
    {
        0.875,
        Color3.fromRGB(255, 0, 255)
    },
    {
        1,
        Color3.fromRGB(255, 0, 0)
    }
}

local function wrapped(v20) -- line 63 | captures: v19
    local v21 = v20 % 1
    local v22 = #v19 - 1
    for v23 = 1, v22 do
        local v24 = v19[v23]
        local v25 = v19[v23 + 1]
        if v21 <= v25[1] then
            local v26 = v25[1] - v24[1]
            return v24[2]:Lerp(v25[2], v26 > 0 and (v21 - v24[1]) / v26 or 0)
        end
    end
    return v19[#v19][2]
end

function v1.warm() -- line 76 | captures: v17, v18, wrapped
    if v18 then
        return
    end
    v18 = table.create(v17)
    local v27 = table.create(20)
    local v28 = v17 - 1
    for v29 = 0, v28 do
        local v30 = v29 / v17
        for v31 = 0, 19 do
            local v32 = v31 / 19
            v27[v31 + 1] = ColorSequenceKeypoint.new(v32, wrapped(v32 * 0.5 - v30))
        end
        v18[v29 + 1] = ColorSequence.new(v27)
    end
end

local function hostOf(v33) -- line 94
    local Parent = v33.Parent
    while Parent do
        if Parent:IsA("GuiObject") then
            break
        end
        Parent = Parent.Parent
    end
    return Parent
end

local function add(v34) -- line 102 | captures: gui, chainVisible, v12, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11
    if not (v34:IsA("UIGradient") and v34:IsDescendantOf(gui)) then
        return
    end
    local v35 = v12
    for v36 = 1, v35 do
        if v3[v36] == v34 then
            return
        end
    end
    local v37 = v2[v34:GetAttribute("Mode")]
    local Parent = v34.Parent
    while Parent do
        if Parent:IsA("GuiObject") then
            break
        end
        Parent = Parent.Parent
    end
    local v38
    if v37 and Parent then
        if v37 == 3 then
            local Period = v34:GetAttribute("Period")
            v38 = 1 / (type(Period) == "number" and Period > 0 and Period or 2)
            v1.warm()
        elseif v37 == 4 then
            local Period = v34:GetAttribute("Period")
            v38 = 6.283185307179586 / (type(Period) == "number" and Period > 0 and Period or 6)
        else
            v38 = v34:GetAttribute("Speed")
            if type(v38) == "number" then
                if not v38 then
                    if v37 == 1 then
                        v38 = 90
                    else
                        v38 = 0.5
                    end
                end
            elseif v37 == 1 then
                v38 = 90
            else
                v38 = 0.5
            end
        end
    else
        return
    end
    v12 += 1
    local v39 = v12
    local v40 = v12
    local v41 = v12
    local v42 = v12
    v3[v39] = v34
    v4[v40] = Parent
    v5[v41] = v37
    v6[v42] = v38
    local v43 = v12
    local v44, v45
    if v37 == 1 then
        local Rotation = v34.Rotation
        if Rotation then
            v44 = Rotation
            v45 = true
        elseif v37 == 2 or v37 == 4 then
            local X = v34.Offset.X
            if X then
                v44 = X
                v45 = true
            else
                v45 = false
            end
        else
            v45 = false
        end
    elseif v37 == 2 or v37 == 4 then
        local X = v34.Offset.X
        if X then
            v44 = X
            v45 = true
        else
            v45 = false
        end
    else
        v45 = false
    end
    if not v45 then
        v44 = 0
    end
    v7[v43] = v44
    local Amp = v34:GetAttribute("Amp")
    local v46 = v12
    if v37 == 4 then
        if type(Amp) ~= "number" or not Amp then
            Amp = 0.5
        end
    else
        Amp = 0
    end
    v11[v46] = Amp
    v8[v12] = -1
    local v47 = v12
    local Color = v37 == 3 and v34.Color or false
    v10[v47] = Color
    v9[v12] = chainVisible(Parent)
end

local function remove(v48) -- line 138 | captures: v12, v3, v4, v5, v6, v7, v8, v9, v10, v11
    local v49 = v12
    for v50 = 1, v49 do
        if v3[v50] == v48 then
            local v51 = v3[v12]
            local v52 = v4[v12]
            local v53 = v5[v12]
            local v54 = v6[v12]
            v3[v50] = v51
            v4[v50] = v52
            v5[v50] = v53
            v6[v50] = v54
            local v55 = v7[v12]
            local v56 = v8[v12]
            local v57 = v9[v12]
            local v58 = v10[v12]
            v7[v50] = v55
            v8[v50] = v56
            v9[v50] = v57
            v10[v50] = v58
            v11[v50] = v11[v12]
            local v59 = v12
            local v60 = v12
            v10[v59] = nil
            v11[v60] = nil
            local v61 = v12
            local v62 = v12
            local v63 = v12
            local v64 = v12
            local v65 = v12
            local v66 = v12
            local v67 = v12
            v3[v61] = nil
            v4[v62] = nil
            v5[v63] = nil
            v6[v64] = nil
            v7[v65] = nil
            v8[v66] = nil
            v9[v67] = nil
            v12 -= 1
            return
        end
    end
end

local v68 = 0

function v1.step(v69) -- line 154 | captures: T, chainVisible, SPRITE_VIS_EVERY, v12, v13, v14, v17, v18, v68, sin, v3, v4, v5, v6, v7, v8, v9, v11
    if v12 ~= 0 then
        v68 += v69
        if not (v68 < 1 / T.GRADIENT_HZ) then
            local v70 = v68
            v68 = 0
            v13 += v70
            v14 += v70
            local v71 = v14
            if SPRITE_VIS_EVERY <= v71 then
                v14 = 0
                local v72 = v12
                for v73 = 1, v72 do
                    v9[v73] = chainVisible(v4[v73])
                end
            end
            local v74 = v12
            for v75 = 1, v74 do
                if v9[v75] then
                    local v76 = v5[v75]
                    if v76 == 3 then
                        local v77 = v13 * v6[v75] % 1 * v17
                        local v78 = math.floor(v77) % v17 + 1
                        if v78 ~= v8[v75] then
                            v8[v75] = v78
                            v3[v75].Color = v18[v78]
                        end
                    elseif v76 == 1 then
                        local v79 = (v7[v75] + v13 * v6[v75]) % 360 * 10 + 0.5
                        local v80 = math.floor(v79) / 10
                        if v80 ~= v8[v75] then
                            v8[v75] = v80
                            v3[v75].Rotation = v80
                        end
                    elseif v76 == 4 then
                        local v81 = v7[v75]
                        local v82 = v11[v75]
                        local v83 = v13 * v6[v75]
                        local v84 = (v81 + v82 * sin(v83)) * 1000 + 0.5
                        local v85 = math.floor(v84) / 1000
                        if v85 ~= v8[v75] then
                            v8[v75] = v85
                            v3[v75].Offset = Vector2.new(v85, 0)
                        end
                    else
                        local v86 = ((v7[v75] + 1 + v13 * v6[v75]) % 2 - 1) * 1000 + 0.5
                        local v87 = math.floor(v86) / 1000
                        if v87 ~= v8[v75] then
                            v8[v75] = v87
                            v3[v75].Offset = Vector2.new(v87, 0)
                        end
                    end
                end
            end
        end
    end
end

function v1.start() -- line 211 | captures: GRADIENT_TAG, v13, v14, v15, v16, CollectionService, add, remove
    v15 = CollectionService:GetInstanceAddedSignal(GRADIENT_TAG):Connect(add)
    v16 = CollectionService:GetInstanceRemovedSignal(GRADIENT_TAG):Connect(remove)
    for v88, v89 in ipairs(CollectionService:GetTagged(GRADIENT_TAG)) do
        add(v89)
    end
    v14 = 0
    v13 = 0
end

function v1.stop() -- line 221 | captures: v12, v15, v16, v3, v4, v5, v6, v7, v8, v9, v10, v11
    if v15 then
        v15:Disconnect()
        v15 = nil
    end
    if v16 then
        v16:Disconnect()
        v16 = nil
    end
    local v90 = v12
    for v91 = 1, v90 do
        if v8[v91] ~= -1 and v3[v91].Parent then
            local v92 = v5[v91]
            if v92 == 1 then
                v3[v91].Rotation = v7[v91]
            elseif v92 == 2 or v92 == 4 then
                v3[v91].Offset = Vector2.new(v7[v91], v3[v91].Offset.Y)
            elseif v10[v91] then
                v3[v91].Color = v10[v91]
            end
        end
        v3[v91] = nil
        v4[v91] = nil
        v5[v91] = nil
        v6[v91] = nil
        v7[v91] = nil
        v8[v91] = nil
        v9[v91] = nil
        v10[v91] = nil
        v11[v91] = nil
    end
    v12 = 0
end

function v1.hasRainbow() -- line 249 | captures: gui, GRADIENT_TAG, CollectionService
    for v93, v94 in ipairs(CollectionService:GetTagged(GRADIENT_TAG)) do
        if v94:GetAttribute("Mode") == "Rainbow" and v94:IsDescendantOf(gui) then
            return true
        end
    end
    return false
end

function v1.init(v95) -- line 258 | captures: T, gui, chainVisible, GRADIENT_TAG, SPRITE_VIS_EVERY, v17
    local T_2 = v95.T
    local gui_2 = v95.gui
    T = T_2
    gui = gui_2
    chainVisible = v95.Actors.chainVisible
    local GRADIENT_TAG_2 = T.GRADIENT_TAG
    local SPRITE_VIS_EVERY_2 = T.SPRITE_VIS_EVERY
    GRADIENT_TAG = GRADIENT_TAG_2
    SPRITE_VIS_EVERY = SPRITE_VIS_EVERY_2
    v17 = v95.touchOnly and T.RAINBOW_STEPS_LOW or T.RAINBOW_STEPS
end

return v1
