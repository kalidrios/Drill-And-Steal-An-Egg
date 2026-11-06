-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local DemonEventUIConfig = require(ReplicatedStorage.Shared.DemonEventUIConfig)
local Spring = require(script.Parent.Spring)
local Actors = require(script.Parent.Actors)
local Idle = require(script.Parent.Idle)
local Sprites = require(script.Parent.Sprites)
local UiPopOffset = require(script.Parent.Parent.UiPopOffset)
local v1 = {}

function v1.new(v2, v3) -- line 49 | captures: CollectionService, RunService, UserInputService, DemonEventUIConfig, Spring, Actors, Idle, Sprites, UiPopOffset
    local AmpScaleX, AmpScaleY
    if v3 then
        AmpScaleX = v3.AmpScaleX or 1
        AmpScaleY = v3.AmpScaleY or 1
    else
        AmpScaleX = 1
        AmpScaleY = 1
    end
    local v4 = {
        WING_LIFT = DemonEventUIConfig.WING_LIFT * AmpScaleY,
        CLOUD_AMP_MIN = DemonEventUIConfig.CLOUD_AMP_MIN * AmpScaleX,
        CLOUD_AMP_MAX = DemonEventUIConfig.CLOUD_AMP_MAX * AmpScaleX,
        FLARE_LIFT_MIN = DemonEventUIConfig.FLARE_LIFT_MIN * AmpScaleY,
        FLARE_LIFT_MAX = DemonEventUIConfig.FLARE_LIFT_MAX * AmpScaleY
    }
    local v5 = { __index = DemonEventUIConfig }
    local v6 = setmetatable(v4, v5)
    local v7 = Actors.new()
    local v8 = Idle.new()
    local v9 = Sprites.new()
    local v10 = Random.new()
    local v11 = {
        gui = v2,
        main = v2,
        T = v6,
        Spring = Spring,
        rng = v10,
        grids = {},
        Actors = v7
    }
    v11.touchOnly = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
    v7.init(v11)
    v9.init(v11)
    v8.init(v11)

    local function sideOf(v12) -- line 75
        if v12.Position.X.Scale < 0.5 then
            return -1
        end
        return 1
    end

    local v13 = {}
    for v14, v15 in v2:GetChildren() do
        if v15:IsA("GuiObject") then
            local Name = v15.Name
            local v16
            if Name == "DemonWing" then
                v16 = v7.makeActor(v15)
                v16.idle = v8.FLAP
                v16.sync = v15:GetAttribute("SpriteSync")
            elseif Name == "DemonGate" then
                v16 = v7.makeActor(v15)
                local setBob = v8.setBob
                local v17 = v10:NextNumber(2.4, 3)
                local v18 = 0.01 * AmpScaleY
                local v19 = v10:NextNumber(3, 4.5)
                local v20 = if v15.Position.X.Scale < 0.5 then -1 else 1
                setBob(v16, v17, v18, v19 * v20, v10:NextNumber(0, 6.283185307179586))
            elseif Name == "DemonTrident" then
                v16 = v7.makeActor(v15)
                local setBob = v8.setBob
                local v21 = v10:NextNumber(1.9, 2.4)
                local v22 = 0.016 * AmpScaleY
                local v23 = v10:NextNumber(5, 7)
                local v24 = if v15.Position.X.Scale < 0.5 then -1 else 1
                setBob(v16, v21, v22, v23 * v24, v10:NextNumber(0, 6.283185307179586))
            elseif Name == "DemonCloud" then
                v16 = v7.makeActor(v15)
                v16.idle = v8.CLOUD
                v16.amp = v10:NextNumber(v6.CLOUD_AMP_MIN, v6.CLOUD_AMP_MAX)
                v16.wander = Spring.new(0, v10:NextNumber(v6.CLOUD_F_MIN, v6.CLOUD_F_MAX), 1)
                v16.nextAt = 0
            elseif Name == "DemonFlame" then
                v16 = v7.makeActor(v15)
                v16.idle = v8.FLAME
                v16.iw = 6.283185307179586 / v10:NextNumber(0.7, 1.1)
                v16.iph = v10:NextNumber(0, 6.283185307179586)
                v16.nextAt = 0
            end
            if v16 then
                v16.fades = false
                table.insert(v13, v16)
                UiPopOffset.Manage(v15)
            end
        end
    end
    for v25, v26 in v2:GetDescendants() do
        if (CollectionService:HasTag(v26, DemonEventUIConfig.BOB_TAG) or CollectionService:HasTag(v26, DemonEventUIConfig.SPIN_TAG)) and v26:IsA("GuiObject") and not v7.map[v26] then
            local v27 = v7.makeActor(v26)
            v8.applyTags(v27, v26)
            v27.fades = false
            table.insert(v13, v27)
        end
    end
    local step = Spring.step
    local v28 = 0
    local v29
    local v30 = {}
    local v31 = true
    local v32 = 0

    local function onFrame(v33) -- line 136 | captures: v28, v32, v7, v8, v9, v13, step, DemonEventUIConfig, UiPopOffset
        v32 += v33
        if v32 < 0.03333333333333333 and not UiPopOffset.Active() then
            return
        end
        local v34 = v32
        local MAX_DT = DemonEventUIConfig.MAX_DT
        local v35 = math.min(v34, MAX_DT)
        v32 = 0
        v28 += v35
        for v36, v37 in v13 do
            if v37.idle ~= 0 then
                local v38 = v28
                if v37.idleAt <= v38 then
                    v8.update(v37, v35, v28, true)
                end
            end
            if v37.live then
                local v39 = step(v37.ox, v35)
                local v40 = step(v37.oy, v35) and v39
                local v41 = step(v37.rot, v35) and v40
                v37.live = not (step(v37.sc, v35) and v41)
            end
            local v42 = UiPopOffset.Get(v37.inst)
            if v37.popped and not v42 then
                v37.popped = false
                v37.wx = (1/0)
            end
            v7.writeActor(v37)
            if v42 then
                v37.popped = true
                v37.wx = (1/0)
                v37.inst.Position = UDim2.new(v37.hxS + v37.ox.x + v37.ix + v42.X.Scale, v37.hxO + v42.X.Offset, v37.hyS + v37.oy.x + v37.iy + v42.Y.Scale, v37.hyO + v42.Y.Offset)
            end
        end
        v9.step(v35)
    end

    local function start() -- line 179 | captures: v28, v29, v9, v13, onFrame, RunService
        if v29 then
            return
        end
        for v43, v44 in v13 do
            v44.idleAt = v28
        end
        v9.resetSync()
        v9.start()
        v29 = RunService.RenderStepped:Connect(onFrame)
    end

    local function stop() -- line 191 | captures: v29, v7, v9, v13
        if not v29 then
            return
        end
        v29:Disconnect()
        v29 = nil
        v9.stop()
        for v45, v46 in v13 do
            v7.toRest(v46)
        end
    end

    local function isShown() -- line 205 | captures: v2
        local v47 = v2
        while true do
            if v47 and (not v47:IsA("GuiObject") or v47.Visible) then
                if v47:IsA("LayerCollector") then
                    break
                end
                v47 = v47.Parent
                continue
            end
            return false
        end
        return v47.Enabled and v47:IsDescendantOf(game)
    end

    local function refresh() -- line 218 | captures: v28, v29, v31, v9, v13, onFrame, stop, isShown, RunService
        if not (v31 and isShown()) then
            stop()
        elseif not v29 then
            for v48, v49 in v13 do
                v49.idleAt = v28
            end
            v9.resetSync()
            v9.start()
            v29 = RunService.RenderStepped:Connect(onFrame)
        end
    end

    local watch

    local function watch_2() -- line 226 | captures: v28, v29, v31, v2, v9, v13, v30, onFrame, stop, isShown, refresh, watch, RunService
        local function v50(v51, ...)
            table.insert(v51, ...)
        end

        local function v52(v53, ...)
            table.insert(v53, ...)
        end

        local function v54(v55, ...)
            table.insert(v55, ...)
        end

        for v56, v57 in v30 do
            v57:Disconnect()
        end
        table.clear(v30)
        local v58 = v2
        while v58 do
            if v58:IsA("GuiObject") then
                v50(v30, v58:GetPropertyChangedSignal("Visible"):Connect(refresh))
            elseif v58:IsA("LayerCollector") then
                v52(v30, v58:GetPropertyChangedSignal("Enabled"):Connect(refresh))
                break
            end
            v58 = v58.Parent
        end
        v54(v30, v2.AncestryChanged:Connect(function() -- line 241 | captures: v28, v29, v31, v9, v13, onFrame, stop, isShown, watch, RunService
            watch()
            if not (v31 and isShown()) then
                stop()
            elseif not v29 then
                for v59, v60 in v13 do
                    v60.idleAt = v28
                end
                v9.resetSync()
                v9.start()
                v29 = RunService.RenderStepped:Connect(onFrame)
            end
        end))
    end

    watch = watch_2
    watch_2()
    if not (v31 and isShown()) then
        stop()
    elseif not v29 then
        for v61, v62 in v13 do
            v62.idleAt = v28
        end
        v9.resetSync()
        v9.start()
        v29 = RunService.RenderStepped:Connect(onFrame)
    end

    local function destroy() -- line 250 | captures: v31, v7, v13, v30, stop, UiPopOffset
        if not v31 then
            return
        end
        v31 = false
        stop()
        for v63, v64 in v30 do
            v64:Disconnect()
        end
        table.clear(v30)
        for v65, v66 in v13 do
            UiPopOffset.Unmanage(v66.inst)
        end
        v7.clear()
    end

    v2.Destroying:Once(destroy)
    return { Destroy = destroy }
end

return v1
