-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

return {
    new = function() -- new | line 24
        local v1 = {}
        local v2, T, rng, Spring, to, kick, makeActor, refresh, layerOwner
        local v3 = true
        local v4 = {}

        local function hoverSprings(v5) -- line 33 | captures: T, Spring
            if not v5.hs then
                v5.hs = Spring.new(1, T.HOVER[1], T.HOVER[2])
                v5.hr = Spring.new(0, T.HOVER[1], T.HOVER[2])
            end
            if v5.layer and not v5.ld then
                v5.ld = Spring.new(1, T.HOVER[1], T.HOVER[2])
            end
        end

        function v1.wire(v6) -- line 43 | captures: v2, T, rng, to, kick, makeActor, refresh, layerOwner, v3, v4, hoverSprings
            local function v7(v8, ...)
                table.insert(v8, ...)
            end

            local function v9(v10, ...)
                table.insert(v10, ...)
            end

            local function v11(v12, ...)
                table.insert(v12, ...)
            end

            local function v13(v14, ...)
                table.insert(v14, ...)
            end

            if v4[v6] then
                return
            end
            local v15 = false
            local v16 = layerOwner(v6) or v6

            local function juice(v17, v18, v19, v20, v21) -- line 51 | captures: v16, v2, to, kick, makeActor, refresh, hoverSprings
                if not v2.running then
                    return
                end
                local v22 = makeActor(v16)
                if not v22.session then
                    refresh(v22)
                    v22.session = true
                end
                hoverSprings(v22)
                to(v22.hs, v17, v18[1], v18[2])
                if v19 then
                    to(v22.hr, v19, v18[1], v18[2])
                end
                if v20 then
                    kick(v22.hs, v20)
                end
                if v21 and v22.ld then
                    to(v22.ld, v21, v18[1], v18[2])
                end
                v22.live = true
            end

            local v23 = {}
            if v3 then
                v7(v23, v6.MouseEnter:Connect(function() -- line 78 | captures: v15, juice, T, rng
                    v15 = true
                    juice(T.HOVER_SCALE, T.HOVER, rng:NextNumber(-T.HOVER_TILT, T.HOVER_TILT), nil, T.LAYER_HOVER_DEPTH)
                end))
                v9(v23, v6.MouseLeave:Connect(function() -- line 82 | captures: v15, juice, T
                    v15 = false
                    juice(1, T.HOVER, 0, nil, 1)
                end))
            end
            v11(v23, v6.InputBegan:Connect(function(v24) -- line 87 | captures: juice, T
                local UserInputType = v24.UserInputType
                if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch then
                    juice(T.PRESS_SCALE, T.PRESS, nil, nil, T.LAYER_PRESS_DEPTH)
                end
            end))
            v13(v23, v6.InputEnded:Connect(function(v25) -- line 93 | captures: v15, juice, T
                local UserInputType = v25.UserInputType
                if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch then
                    return
                end
                local v26 = v15 and T.HOVER_SCALE or 1
                local RELEASE = T.RELEASE
                local RELEASE_KICK = T.RELEASE_KICK
                local LAYER_HOVER_DEPTH = v15 and T.LAYER_HOVER_DEPTH or 1
                juice(v26, RELEASE, 0, RELEASE_KICK, LAYER_HOVER_DEPTH)
            end))
            v4[v6] = v23
        end

        function v1.unwire(v27) -- line 102 | captures: v4
            local v28 = v4[v27]
            if v28 then
                for v29, v30 in ipairs(v28) do
                    v30:Disconnect()
                end
                v4[v27] = nil
            end
        end

        function v1.unwireAll() -- line 112 | captures: v1, v4
            for v31 in pairs(v4) do
                v1.unwire(v31)
            end
        end

        function v1.init(v32) -- line 118 | captures: v2, T, rng, Spring, to, kick, makeActor, refresh, layerOwner, v3, v1
            v2 = v32
            local T_2 = v2.T
            local rng_2 = v2.rng
            local Spring_2 = v2.Spring
            T = T_2
            rng = rng_2
            Spring = Spring_2
            local to_2 = Spring.to
            local kick_2 = Spring.kick
            to = to_2
            kick = kick_2
            local makeActor_2 = v2.Actors.makeActor
            local refresh_2 = v2.Actors.refresh
            makeActor = makeActor_2
            refresh = refresh_2
            layerOwner = v2.EggItems.layerOwner
            v3 = not v2.touchOnly
            for v33, v34 in ipairs(v2.main:GetDescendants()) do
                if v34:IsA("GuiButton") then
                    v1.wire(v34)
                end
            end
        end

        return v1
    end
}
