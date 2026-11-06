-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local v1 = {}

function v1.new() -- line 32 | captures: CollectionService
    local v2 = {}
    local T, rng, gui, chainVisible, SPRITE_TAG, SPRITE_VIS_EVERY
    local v3 = {}
    local v4 = {}
    v2.syncGroups = v3
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

    function v2.offsetsFor(v18, v19, v20) -- line 51 | captures: v15
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

    local offsetsFor = v2.offsetsFor

    local function addSprite(v35) -- line 70 | captures: rng, gui, chainVisible, v13, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, offsetsFor
        if not ((v35:IsA("ImageLabel") or v35:IsA("ImageButton")) and v35:IsDescendantOf(gui)) then
            return
        end
        local v36 = v13
        for v37 = 1, v36 do
            if v5[v37] == v35 then
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
        v13 += 1
        v5[v13] = v35
        v6[v13] = v40
        v7[v13] = #v40
        v8[v13] = FPS
        v9[v13] = rng:NextNumber() * #v40 / FPS
        local SpriteSync = v35:GetAttribute("SpriteSync")
        local v41
        if type(SpriteSync) == "string" then
            if SpriteSync == "" then
                v41 = false
            else
                v41 = v3[SpriteSync]
                if not v41 then
                    v41 = {
                        t = 0,
                        period = #v40 / FPS
                    }
                    v3[SpriteSync] = v41
                    table.insert(v4, v41)
                end
            end
        else
            v41 = false
        end
        v12[v13] = v41
        v10[v13] = -1
        v11[v13] = chainVisible(v35)
    end

    local function removeSprite(v42) -- line 109 | captures: v13, v5, v6, v7, v8, v9, v10, v11, v12
        local v43 = v13
        for v44 = 1, v43 do
            if v5[v44] == v42 then
                local v45 = v5[v13]
                local v46 = v6[v13]
                local v47 = v7[v13]
                v5[v44] = v45
                v6[v44] = v46
                v7[v44] = v47
                local v48 = v8[v13]
                local v49 = v9[v13]
                local v50 = v10[v13]
                local v51 = v11[v13]
                v8[v44] = v48
                v9[v44] = v49
                v10[v44] = v50
                v11[v44] = v51
                v12[v44] = v12[v13]
                local v52 = v13
                local v53 = v13
                local v54 = v13
                local v55 = v13
                local v56 = v13
                local v57 = v13
                local v58 = v13
                local v59 = v13
                v5[v52] = nil
                v6[v53] = nil
                v7[v54] = nil
                v8[v55] = nil
                v9[v56] = nil
                v10[v57] = nil
                v11[v58] = nil
                v12[v59] = nil
                v13 -= 1
                return
            end
        end
    end

    local function clearSprites() -- line 123 | captures: v13, v5, v6, v7, v8, v9, v10, v11, v12
        local v60 = v13
        for v61 = 1, v60 do
            v5[v61] = nil
            v6[v61] = nil
            v7[v61] = nil
            v8[v61] = nil
            v9[v61] = nil
            v10[v61] = nil
            v11[v61] = nil
            v12[v61] = nil
        end
        v13 = 0
    end

    function v2.step(v62) -- line 131 | captures: chainVisible, SPRITE_VIS_EVERY, v13, v14, v4, v5, v6, v7, v8, v9, v10, v11, v12
        v14 += v62
        local v63 = v14
        if SPRITE_VIS_EVERY <= v63 then
            v14 = 0
            local v64 = v13
            for v65 = 1, v64 do
                v11[v65] = chainVisible(v5[v65])
            end
        end
        local v66 = #v4
        for v67 = 1, v66 do
            local v68 = v4[v67]
            local v69 = v68.t + v62
            if v68.period <= v69 then
                local period = v68.period
                local v70 = v69 / v68.period
                v69 -= period * math.floor(v70)
            end
            v68.t = v69
        end
        local v71 = v13
        for v72 = 1, v71 do
            if v11[v72] then
                local v73 = v8[v72]
                local v74 = v7[v72]
                local v75 = v12[v72]
                local v76 = if v75 then v75.t else v9[v72] + v62
                local v77 = v74 / v73
                local v78
                if v77 <= v76 then
                    local v79 = v76 / v77
                    v78 = v76 - v77 * math.floor(v79)
                else
                    v78 = v76
                end
                v9[v72] = v78
                local v80 = v78 * v73
                local v81 = math.floor(v80) + 1
                if v74 < v81 then
                    v81 = v74
                end
                if v81 ~= v10[v72] then
                    v10[v72] = v81
                    v5[v72].ImageRectOffset = v6[v72][v81]
                end
            end
        end
    end

    function v2.resetSync() -- line 179 | captures: v3, v4
        table.clear(v3)
        table.clear(v4)
    end

    function v2.start() -- line 186 | captures: SPRITE_TAG, v14, v16, v17, addSprite, removeSprite, CollectionService
        v16 = CollectionService:GetInstanceAddedSignal(SPRITE_TAG):Connect(addSprite)
        v17 = CollectionService:GetInstanceRemovedSignal(SPRITE_TAG):Connect(removeSprite)
        for v82, v83 in ipairs(CollectionService:GetTagged(SPRITE_TAG)) do
            addSprite(v83)
        end
        v14 = 0
    end

    function v2.stop() -- line 195 | captures: v16, v17, clearSprites
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

    function v2.init(v84) -- line 207 | captures: T, rng, gui, chainVisible, SPRITE_TAG, SPRITE_VIS_EVERY, v3
        local T_2 = v84.T
        local rng_2 = v84.rng
        local gui_2 = v84.gui
        T = T_2
        rng = rng_2
        gui = gui_2
        chainVisible = v84.Actors.chainVisible
        local SPRITE_TAG_2 = T.SPRITE_TAG
        local SPRITE_VIS_EVERY_2 = T.SPRITE_VIS_EVERY
        SPRITE_TAG = SPRITE_TAG_2
        SPRITE_VIS_EVERY = SPRITE_VIS_EVERY_2
        v84.syncGroups = v3
    end

    return v2
end

return v1
