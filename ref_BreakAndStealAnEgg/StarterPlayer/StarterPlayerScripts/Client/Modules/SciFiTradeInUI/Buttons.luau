-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}
local v2, T, rng, Spring, to, kick, makeActor, refresh
local v3 = true
local v4 = {}

local function hoverSprings(v5) -- line 20 | captures: T, Spring
    if not v5.hs then
        v5.hs = Spring.new(1, T.HOVER[1], T.HOVER[2])
        v5.hr = Spring.new(0, T.HOVER[1], T.HOVER[2])
    end
end

function v1.wire(v6) -- line 27 | captures: v2, T, rng, Spring, to, kick, makeActor, refresh, v3, v4
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

    local function juice(v16, v17, v18, v19) -- line 33 | captures: v6, v2, T, Spring, to, kick, makeActor, refresh
        if not v2.running then
            return
        end
        local v20 = makeActor(v6)
        if not v20.session then
            refresh(v20)
            v20.session = true
        end
        if not v20.hs then
            v20.hs = Spring.new(1, T.HOVER[1], T.HOVER[2])
            v20.hr = Spring.new(0, T.HOVER[1], T.HOVER[2])
        end
        to(v20.hs, v16, v17[1], v17[2])
        if v18 then
            to(v20.hr, v18, v17[1], v17[2])
        end
        if v19 then
            kick(v20.hs, v19)
        end
        v20.live = true
    end

    local v21 = {}
    if v3 then
        v7(v21, v6.MouseEnter:Connect(function() -- line 57 | captures: v15, juice, v2, T, rng
            v15 = true
            if v2.SFX then
                v2.SFX.play("hover")
            end
            juice(T.HOVER_SCALE, T.HOVER, rng:NextNumber(-T.HOVER_TILT, T.HOVER_TILT))
        end))
        v9(v21, v6.MouseLeave:Connect(function() -- line 64 | captures: v15, juice, T
            v15 = false
            juice(1, T.HOVER, 0)
        end))
    end
    v11(v21, v6.InputBegan:Connect(function(v22) -- line 69 | captures: v6, v2, T, Spring, to, makeActor, refresh
        local UserInputType = v22.UserInputType
        if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        if v2.SFX then
            v2.SFX.play(T.BUTTON_SFX[v6.Name] or "click")
        end
        local PRESS_SCALE = T.PRESS_SCALE
        local PRESS = T.PRESS
        local v23
        if v2.running then
            v23 = makeActor(v6)
            if not v23.session then
                refresh(v23)
                v23.session = true
            end
        else
            return
        end
        if not v23.hs then
            v23.hs = Spring.new(1, T.HOVER[1], T.HOVER[2])
            v23.hr = Spring.new(0, T.HOVER[1], T.HOVER[2])
        end
        to(v23.hs, PRESS_SCALE, PRESS[1], PRESS[2])
        v23.live = true
    end))
    v13(v21, v6.InputEnded:Connect(function(v24) -- line 78 | captures: v15, juice, T
        local UserInputType = v24.UserInputType
        if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        local v25 = v15 and T.HOVER_SCALE or 1
        local RELEASE = T.RELEASE
        juice(v25, RELEASE, 0, T.RELEASE_KICK)
    end))
    v4[v6] = v21
end

function v1.unwire(v26) -- line 87 | captures: v4
    local v27 = v4[v26]
    if v27 then
        for v28, v29 in ipairs(v27) do
            v29:Disconnect()
        end
        v4[v26] = nil
    end
end

function v1.unwireAll() -- line 97 | captures: v1, v4
    for v30 in pairs(v4) do
        v1.unwire(v30)
    end
end

function v1.init(v31) -- line 103 | captures: v2, T, rng, Spring, to, kick, makeActor, refresh, v3, v1
    v2 = v31
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
    v3 = not v2.touchOnly
    for v32, v33 in ipairs(v2.main:GetDescendants()) do
        if v33:IsA("GuiButton") then
            v1.wire(v33)
        end
    end
end

return v1
