-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local v1 = {}

function v1.new() -- line 31 | captures: CollectionService
    local v2 = {}
    local T, gui, chainVisible, GRADIENT_TAG, SPRITE_VIS_EVERY
    local v3 = {
        Spin = 1,
        Scroll = 2,
        Rainbow = 3
    }
    local v4 = {}
    local v5 = {}
    local v6 = {}
    local v7 = {}
    local v8 = {}
    local v9 = {}
    local v10 = {}
    local v11 = 0
    local v12 = 0
    local v13 = 0
    local v14, v15
    local v16 = 64
    local v17
    local v18 = {
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

    local function wrapped(v19) -- line 62 | captures: v18
        local v20 = v19 % 1
        local v21 = #v18 - 1
        for v22 = 1, v21 do
            local v23 = v18[v22]
            local v24 = v18[v22 + 1]
            if v20 <= v24[1] then
                local v25 = v24[1] - v23[1]
                return v23[2]:Lerp(v24[2], v25 > 0 and (v20 - v23[1]) / v25 or 0)
            end
        end
        return v18[#v18][2]
    end

    function v2.warm() -- line 75 | captures: v16, v17, wrapped
        if v17 then
            return
        end
        v17 = table.create(v16)
        local v26 = table.create(20)
        local v27 = v16 - 1
        for v28 = 0, v27 do
            local v29 = v28 / v16
            for v30 = 0, 19 do
                local v31 = v30 / 19
                v26[v30 + 1] = ColorSequenceKeypoint.new(v31, wrapped(v31 * 0.5 - v29))
            end
            v17[v28 + 1] = ColorSequence.new(v26)
        end
    end

    local function hostOf(v32) -- line 93
        local Parent = v32.Parent
        while Parent do
            if Parent:IsA("GuiObject") then
                break
            end
            Parent = Parent.Parent
        end
        return Parent
    end

    local function add(v33) -- line 101 | captures: gui, chainVisible, v11, v2, v3, v4, v5, v6, v7, v8, v9, v10
        if not (v33:IsA("UIGradient") and v33:IsDescendantOf(gui)) then
            return
        end
        local v34 = v11
        for v35 = 1, v34 do
            if v4[v35] == v33 then
                return
            end
        end
        local v36 = v3[v33:GetAttribute("Mode")]
        local Parent = v33.Parent
        while Parent do
            if Parent:IsA("GuiObject") then
                break
            end
            Parent = Parent.Parent
        end
        local v37
        if v36 and Parent then
            if v36 == 3 then
                local Period = v33:GetAttribute("Period")
                v37 = 1 / (type(Period) == "number" and Period > 0 and Period or 2)
                v2.warm()
            else
                v37 = v33:GetAttribute("Speed")
                if type(v37) == "number" then
                    if not v37 then
                        if v36 == 1 then
                            v37 = 90
                        else
                            v37 = 0.5
                        end
                    end
                elseif v36 == 1 then
                    v37 = 90
                else
                    v37 = 0.5
                end
            end
        else
            return
        end
        v11 += 1
        local v38 = v11
        local v39 = v11
        local v40 = v11
        local v41 = v11
        v4[v38] = v33
        v5[v39] = Parent
        v6[v40] = v36
        v7[v41] = v37
        local v42 = v11
        local v43, v44
        if v36 == 1 then
            local Rotation = v33.Rotation
            if Rotation then
                v43 = Rotation
                v44 = true
            elseif v36 == 2 then
                local X = v33.Offset.X
                if X then
                    v43 = X
                    v44 = true
                else
                    v44 = false
                end
            else
                v44 = false
            end
        elseif v36 == 2 then
            local X = v33.Offset.X
            if X then
                v43 = X
                v44 = true
            else
                v44 = false
            end
        else
            v44 = false
        end
        if not v44 then
            v43 = 0
        end
        v8[v42] = v43
        v9[v11] = -1
        v10[v11] = chainVisible(Parent)
    end

    local function remove(v45) -- line 131 | captures: v11, v4, v5, v6, v7, v8, v9, v10
        local v46 = v11
        for v47 = 1, v46 do
            if v4[v47] == v45 then
                local v48 = v4[v11]
                local v49 = v5[v11]
                local v50 = v6[v11]
                local v51 = v7[v11]
                v4[v47] = v48
                v5[v47] = v49
                v6[v47] = v50
                v7[v47] = v51
                local v52 = v8[v11]
                local v53 = v9[v11]
                local v54 = v10[v11]
                v8[v47] = v52
                v9[v47] = v53
                v10[v47] = v54
                local v55 = v11
                local v56 = v11
                local v57 = v11
                local v58 = v11
                local v59 = v11
                local v60 = v11
                local v61 = v11
                v4[v55] = nil
                v5[v56] = nil
                v6[v57] = nil
                v7[v58] = nil
                v8[v59] = nil
                v9[v60] = nil
                v10[v61] = nil
                v11 -= 1
                return
            end
        end
    end

    function v2.step(v62) -- line 143 | captures: chainVisible, SPRITE_VIS_EVERY, v11, v12, v13, v16, v17, v4, v5, v6, v7, v8, v9, v10
        if v11 == 0 then
            return
        end
        v12 += v62
        v13 += v62
        local v63 = v13
        if SPRITE_VIS_EVERY <= v63 then
            v13 = 0
            local v64 = v11
            for v65 = 1, v64 do
                v10[v65] = chainVisible(v5[v65])
            end
        end
        local v66 = v11
        for v67 = 1, v66 do
            if v10[v67] then
                local v68 = v6[v67]
                if v68 == 3 then
                    local v69 = v12 * v7[v67] % 1 * v16
                    local v70 = math.floor(v69) % v16 + 1
                    if v70 ~= v9[v67] then
                        v9[v67] = v70
                        v4[v67].Color = v17[v70]
                    end
                elseif v68 == 1 then
                    local v71 = (v8[v67] + v12 * v7[v67]) % 360 * 10 + 0.5
                    local v72 = math.floor(v71) / 10
                    if v72 ~= v9[v67] then
                        v9[v67] = v72
                        v4[v67].Rotation = v72
                    end
                else
                    local v73 = ((v8[v67] + 1 + v12 * v7[v67]) % 2 - 1) * 1000 + 0.5
                    local v74 = math.floor(v73) / 1000
                    if v74 ~= v9[v67] then
                        v9[v67] = v74
                        v4[v67].Offset = Vector2.new(v74, 0)
                    end
                end
            end
        end
    end

    function v2.start() -- line 185 | captures: GRADIENT_TAG, v13, v14, v15, add, remove, CollectionService
        v14 = CollectionService:GetInstanceAddedSignal(GRADIENT_TAG):Connect(add)
        v15 = CollectionService:GetInstanceRemovedSignal(GRADIENT_TAG):Connect(remove)
        for v75, v76 in ipairs(CollectionService:GetTagged(GRADIENT_TAG)) do
            add(v76)
        end
        v13 = 0
    end

    function v2.stop() -- line 194 | captures: v11, v14, v15, v4, v5, v6, v7, v8, v9, v10
        if v14 then
            v14:Disconnect()
            v14 = nil
        end
        if v15 then
            v15:Disconnect()
            v15 = nil
        end
        local v77 = v11
        for v78 = 1, v77 do
            v4[v78] = nil
            v5[v78] = nil
            v6[v78] = nil
            v7[v78] = nil
            v8[v78] = nil
            v9[v78] = nil
            v10[v78] = nil
        end
        v11 = 0
    end

    function v2.hasRainbow() -- line 210 | captures: gui, GRADIENT_TAG, CollectionService
        for v79, v80 in ipairs(CollectionService:GetTagged(GRADIENT_TAG)) do
            if v80:GetAttribute("Mode") == "Rainbow" and v80:IsDescendantOf(gui) then
                return true
            end
        end
        return false
    end

    function v2.init(v81) -- line 219 | captures: T, gui, chainVisible, GRADIENT_TAG, SPRITE_VIS_EVERY, v16
        local T_2 = v81.T
        local gui_2 = v81.gui
        T = T_2
        gui = gui_2
        chainVisible = v81.Actors.chainVisible
        local GRADIENT_TAG_2 = T.GRADIENT_TAG
        local SPRITE_VIS_EVERY_2 = T.SPRITE_VIS_EVERY
        GRADIENT_TAG = GRADIENT_TAG_2
        SPRITE_VIS_EVERY = SPRITE_VIS_EVERY_2
        v16 = v81.touchOnly and T.RAINBOW_STEPS_LOW or T.RAINBOW_STEPS
    end

    return v2
end

return v1
