-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local v1 = {}
local T, rng, gui, chainVisible, SPRITE_TAG, SPRITE_VIS_EVERY
local v2 = {}
local v3 = {}

v1.syncGroups = v2

local v4 = {}
local v5 = {}
local v6 = {}
local v7 = {}
local v8 = {}
local v9 = {}
local v10 = {}
local v11 = {}
local v12 = {}
local v13 = 0
local v14 = 0
local v15 = {}
local v16, v17

function v1.offsetsFor(v18, v19, v20) -- line 44 | captures: v15
    local function v21(v22, ...)
        table.insert(v22, ...)
    end

    local X = v18.X
    local v23 = math.floor(X)
    local v24 = math.max(1, v23)
    local Y = v18.Y
    local v25 = math.floor(Y)
    local v26 = math.max(1, v25)
    local X_2 = v19.X
    local Y_2 = v19.Y
    local v27 = if v20 then "m" else ""
    local v28 = v24 .. "x" .. v26 .. "@" .. X_2 .. "x" .. Y_2 .. v27
    local v29 = v15[v28]
    if not v29 then
        v29 = table.create(v24 * v26)
        local v30 = v26 - 1
        for v31 = 0, v30 do
            local v32 = v24 - 1
            for v33 = 0, v32 do
                local v34 = v20 and v24 - 1 - v33 or v33
                v21(v29, Vector2.new(v19.X * v34, v19.Y * v31))
            end
        end
        v15[v28] = v29
    end
    return v29
end

local offsetsFor = v1.offsetsFor

local function addSprite(v35) -- line 63 | captures: rng, gui, chainVisible, v13, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, offsetsFor
    if not ((v35:IsA("ImageLabel") or v35:IsA("ImageButton")) and v35:IsDescendantOf(gui)) then
        return
    end
    local v36 = v13
    for v37 = 1, v36 do
        if v4[v37] == v35 then
            return
        end
    end
    local Cells = v35:GetAttribute("Cells")
    local FPS = v35:GetAttribute("FPS")
    local ImageRectSize = v35.ImageRectSize
    local offsetsFor_2, v38, v39
    if typeof(Cells) == "Vector2" and type(FPS) == "number" then
        if FPS <= 0 or ImageRectSize.X <= 0 or ImageRectSize.Y <= 0 then
            v39 = true
        else
            offsetsFor_2 = offsetsFor
            v38 = v35:GetAttribute("MirrorCells") == true
            v39 = false
        end
    else
        v39 = true
    end
    if v39 then
        return
    end
    local v40 = offsetsFor_2(Cells, ImageRectSize, v38)
    local Frames = v35:GetAttribute("Frames")
    local v41, v42
    if type(Frames) == "number" and Frames >= 1 then
        local v43 = math.floor(Frames)
        local v44 = #v40
        local v45 = math.min(v43, v44)
        if v45 then
            v41 = v45
            v42 = true
        else
            v42 = false
        end
    else
        v42 = false
    end
    if not v42 then
        v41 = #v40
    end
    v13 += 1
    v4[v13] = v35
    v5[v13] = v40
    v6[v13] = v41
    v7[v13] = FPS
    v8[v13] = rng:NextNumber() * v41 / FPS
    local SpriteSync = v35:GetAttribute("SpriteSync")
    local v46
    if type(SpriteSync) == "string" then
        if SpriteSync == "" then
            v46 = false
        else
            v46 = v2[SpriteSync]
            if not v46 then
                v46 = {
                    t = 0,
                    period = v41 / FPS
                }
                v2[SpriteSync] = v46
                table.insert(v3, v46)
            end
        end
    else
        v46 = false
    end
    v11[v13] = v46
    v12[v13] = v35.ImageRectOffset
    v9[v13] = -1
    v10[v13] = chainVisible(v35)
end

local function removeSprite(v47) -- line 105 | captures: v13, v4, v5, v6, v7, v8, v9, v10, v11, v12
    local v48 = v13
    for v49 = 1, v48 do
        if v4[v49] == v47 then
            local v50 = v4[v13]
            local v51 = v5[v13]
            local v52 = v6[v13]
            v4[v49] = v50
            v5[v49] = v51
            v6[v49] = v52
            local v53 = v7[v13]
            local v54 = v8[v13]
            local v55 = v9[v13]
            local v56 = v10[v13]
            v7[v49] = v53
            v8[v49] = v54
            v9[v49] = v55
            v10[v49] = v56
            v11[v49] = v11[v13]
            v12[v49] = v12[v13]
            v12[v13] = nil
            local v57 = v13
            local v58 = v13
            local v59 = v13
            local v60 = v13
            local v61 = v13
            local v62 = v13
            local v63 = v13
            local v64 = v13
            v4[v57] = nil
            v5[v58] = nil
            v6[v59] = nil
            v7[v60] = nil
            v8[v61] = nil
            v9[v62] = nil
            v10[v63] = nil
            v11[v64] = nil
            v13 -= 1
            return
        end
    end
end

local function clearSprites() -- line 121 | captures: v13, v4, v5, v6, v7, v8, v9, v10, v11, v12
    local v65 = v13
    for v66 = 1, v65 do
        if v9[v66] ~= -1 and v4[v66].Parent then
            v4[v66].ImageRectOffset = v12[v66]
        end
        v12[v66] = nil
        v4[v66] = nil
        v5[v66] = nil
        v6[v66] = nil
        v7[v66] = nil
        v8[v66] = nil
        v9[v66] = nil
        v10[v66] = nil
        v11[v66] = nil
    end
    v13 = 0
end

function v1.step(v67) -- line 134 | captures: chainVisible, SPRITE_VIS_EVERY, v13, v14, v3, v4, v5, v6, v7, v8, v9, v10, v11
    v14 += v67
    local v68 = v14
    if SPRITE_VIS_EVERY <= v68 then
        v14 = 0
        local v69 = v13
        for v70 = 1, v69 do
            v10[v70] = chainVisible(v4[v70])
        end
    end
    local v71 = #v3
    for v72 = 1, v71 do
        local v73 = v3[v72]
        local v74 = v73.t + v67
        if v73.period <= v74 then
            local period = v73.period
            local v75 = v74 / v73.period
            v74 -= period * math.floor(v75)
        end
        v73.t = v74
    end
    local v76 = v13
    for v77 = 1, v76 do
        if v10[v77] then
            local v78 = v7[v77]
            local v79 = v6[v77]
            local v80 = v11[v77]
            local v81 = if v80 then v80.t else v8[v77] + v67
            local v82 = v79 / v78
            local v83
            if v82 <= v81 then
                local v84 = v81 / v82
                v83 = v81 - v82 * math.floor(v84)
            else
                v83 = v81
            end
            v8[v77] = v83
            local v85 = v83 * v78
            local v86 = math.floor(v85) + 1
            if v79 < v86 then
                v86 = v79
            end
            if v86 ~= v9[v77] then
                v9[v77] = v86
                v4[v77].ImageRectOffset = v5[v77][v86]
            end
        end
    end
end

function v1.resetSync() -- line 182 | captures: v2, v3
    table.clear(v2)
    table.clear(v3)
end

function v1.start() -- line 189 | captures: SPRITE_TAG, v14, v16, v17, CollectionService, addSprite, removeSprite
    v16 = CollectionService:GetInstanceAddedSignal(SPRITE_TAG):Connect(addSprite)
    v17 = CollectionService:GetInstanceRemovedSignal(SPRITE_TAG):Connect(removeSprite)
    for v87, v88 in ipairs(CollectionService:GetTagged(SPRITE_TAG)) do
        addSprite(v88)
    end
    v14 = 0
end

function v1.stop() -- line 198 | captures: v16, v17, clearSprites
    if v16 then
        v16:Disconnect()
        v16 = nil
    end
    if v17 then
        v17:Disconnect()
        v17 = nil
    end
    clearSprites()
end

function v1.init(v89) -- line 210 | captures: T, rng, gui, chainVisible, SPRITE_TAG, SPRITE_VIS_EVERY, v2
    local T_2 = v89.T
    local rng_2 = v89.rng
    local gui_2 = v89.gui
    T = T_2
    rng = rng_2
    gui = gui_2
    chainVisible = v89.Actors.chainVisible
    local SPRITE_TAG_2 = T.SPRITE_TAG
    local SPRITE_VIS_EVERY_2 = T.SPRITE_VIS_EVERY
    SPRITE_TAG = SPRITE_TAG_2
    SPRITE_VIS_EVERY = SPRITE_VIS_EVERY_2
    v89.syncGroups = v2
end

return v1
