-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SciFiTradeInUIConfig = require(ReplicatedStorage.Shared.SciFiTradeInUIConfig)
local Spring = require(script.Parent.Spring)
local Actors = require(script.Parent.Actors)
local Idle = require(script.Parent.Idle)
local Sprites = require(script.Parent.Sprites)
local Rows = require(script.Parent.Rows)
local Choreography = require(script.Parent.Choreography)
local GradientLoop = require(script.Parent.GradientLoop)
local Rigs = require(script.Parent.Rigs)
local UFOs = require(script.Parent.UFOs)
local Orbit = require(script.Parent.Orbit)
local BurstSheet = require(script.Parent.BurstSheet)
local HoloGlitch = require(script.Parent.HoloGlitch)
local Buttons = require(script.Parent.Buttons)
local Juice = require(script.Parent.Juice)
local Warmup = require(script.Parent.Warmup)
local v1 = {}
local v2 = {
    TubeDEcor = true,
    EnergyTube = true,
    BlackHole = true,
    Radar = true
}

function v1.new(v3) -- line 97 | captures: RunService, UserInputService, SciFiTradeInUIConfig, Spring, Actors, Idle, Sprites, Rows, Choreography, GradientLoop, Rigs, UFOs, Orbit, BurstSheet, HoloGlitch, Buttons, Juice, Warmup, v2
    local function v4(v5, ...)
        table.insert(v5, ...)
    end

    local function v6(v7, ...)
        table.insert(v7, ...)
    end

    local function v8(v9, ...)
        table.insert(v9, ...)
    end

    local function v10(v11, ...)
        table.insert(v11, ...)
    end

    local function v12(v13, ...)
        table.insert(v13, ...)
    end

    local function v14(v15, ...)
        table.insert(v15, ...)
    end

    local SciFiTradeInMain = v3:WaitForChild("SciFiTradeInMain")
    local Header = SciFiTradeInMain:FindFirstChild("Header")
    local EggChancesHolder = SciFiTradeInMain:FindFirstChild("EggChancesHolder")
    local SacrificeInputs = SciFiTradeInMain:FindFirstChild("SacrificeInputs")
    local SacrificeOutput = SciFiTradeInMain:FindFirstChild("SacrificeOutput")
    local DesignBars = SciFiTradeInMain:FindFirstChild("DesignBars")
    local v16 = {}
    local v17 = {}
    local v18 = {}
    for v19, v20 in ipairs(SciFiTradeInMain:GetChildren()) do
        if v20:IsA("GuiObject") and v2[v20.Name] then
            table.insert(v16, v20)
        end
    end
    if SacrificeInputs then
        for v21, v22 in ipairs(SacrificeInputs:GetChildren()) do
            if v22:IsA("GuiObject") and v22.Name:match("^Input%d") then
                table.insert(v17, v22)
            end
        end
    end
    if DesignBars then
        for v23, v24 in ipairs({ "LeftBar", "MiddleBar", "RightBar" }) do
            local v25 = DesignBars:FindFirstChild(v24)
            if v25 then
                table.insert(v18, v25)
            end
        end
    end
    local v26 = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
    local v27 = {
        gui = v3,
        main = SciFiTradeInMain,
        T = SciFiTradeInUIConfig,
        Spring = Spring,
        rng = Random.new(),
        touchOnly = v26,
        grids = {},
        decor = v16,
        inputs = v17,
        bars = v18,
        Header = Header
    }
    v27.Title = Header and Header:FindFirstChild("Title")
    v27.Chances = EggChancesHolder
    v27.ChancesTitle = EggChancesHolder and EggChancesHolder:FindFirstChild("Title")
    v27.Output = SacrificeOutput and SacrificeOutput:FindFirstChild("Output")
    v27.Sacrifice = SciFiTradeInMain:FindFirstChild("Sacrifice")
    v27.CloseButton = SciFiTradeInMain:FindFirstChild("Close")
    v27.EnergyBall = SciFiTradeInMain:FindFirstChild("EnergyBall")
    v27.OpeningBurst = SciFiTradeInMain:FindFirstChild("OpeningBurst")
    v27.Sattelite = SciFiTradeInMain:FindFirstChild("Sattelite")
    v27.UFOBig = SciFiTradeInMain:FindFirstChild("UFOBig")
    v27.UFOSmall = SciFiTradeInMain:FindFirstChild("UFOSmall")
    v27.AbductionBeam = SciFiTradeInMain:FindFirstChild("AbductionBeam")
    v27.Actors = Actors
    v27.Sprites = Sprites
    v27.Idle = Idle
    v27.Rows = Rows
    v27.GradientLoop = GradientLoop
    v27.Rigs = Rigs
    v27.Juice = Juice
    v27.lowEnd = false
    v27.clock = 0
    v27.isOpen = false
    v27.closing = false
    v27.running = false
    local v28 = table.clone(SciFiTradeInUIConfig.GLITCH)
    v28.host = SciFiTradeInMain
    v28.manual = true
    v28.low = v26
    v28.rng = v27.rng
    local v29 = HoloGlitch.new(v28)
    v27.glitch = v29

    function v27.buildGlitch() -- line 166 | captures: v27, v26, v29
        v29.forceLow = v26 or v27.lowEnd
        v29:prebuild()
    end

    Actors.init(v27)
    Sprites.init(v27)
    Idle.init(v27)
    Rows.init(v27)
    GradientLoop.init(v27)
    Choreography.init(v27)
    UFOs.init(v27)
    Orbit.init(v27)
    BurstSheet.init(v27)
    Buttons.init(v27)
    Juice.init(v27)
    UFOs.onBeam = Juice.onBeam
    local step = Spring.step
    local kick = Spring.kick
    local goIn = Actors.goIn
    local goOut = Actors.goOut
    local writeActor = Actors.writeActor
    local forceWrite = Actors.forceWrite
    local toRest = Actors.toRest
    local list = Actors.list
    local map = Actors.map
    local update = Idle.update
    local step_2 = Sprites.step
    local step_3 = GradientLoop.step
    local step_4 = UFOs.step
    local step_5 = Orbit.step
    local step_6 = BurstSheet.step
    local state = BurstSheet.state
    local step_7 = Juice.step
    local panel = Choreography.panel
    local MAX_DT = SciFiTradeInUIConfig.MAX_DT
    local v30 = SciFiTradeInUIConfig.IDLE_STRIDE
    local v31 = 0
    local v32 = true
    local v33 = (1/0)
    local v34 = 0
    local v35 = 0
    local v36
    local v37 = true
    local v38

    local function onFrame(v39) -- line 208 | captures: v30, v31, v33, v34, v35, v38, v27, v29, step, kick, goIn, goOut, writeActor, forceWrite, list, update, step_2, step_3, step_4, step_5, step_6, state, step_7, panel, MAX_DT, SciFiTradeInUIConfig, Actors
        local v40 = if MAX_DT < v39 then MAX_DT else v39
        local v41 = v27.clock + v40
        v27.clock = v41
        local isOpen = v27.isOpen
        v31 = 1 - v31
        if v33 <= v41 then
            v33 = (1/0)
            kick(panel.sc, SciFiTradeInUIConfig.IMPACT_KICK)
            panel.live = true
        end
        local v42, v43, v44
        if v29.live > 0 then
            v29:step(v40)
            local v45, v46 = v29:offset()
            v42 = v45 * v34
            v43 = v46 * v35
            if v42 == panel.ix then
                v44 = v43 == panel.iy
            else
                v44 = false
            end
        else
            v44 = true
        end
        if not v44 then
            panel.ix = v42
            panel.iy = v43
            panel.live = true
        end
        local count = Actors.count
        for v47 = 1, count do
            local v48 = list[v47]
            local pend = v48.pend
            if pend ~= 0 and v48.pendAt <= v41 then
                v48.pend = 0
                if pend == 1 then
                    goIn(v48, v41)
                else
                    goOut(v48)
                end
            end
            local v49 = if v48.idle == 0 then false else v48.idleAt <= v41
            if v49 then
                update(v48, v40, v41, isOpen)
            end
            if v48.live then
                local v50 = step(v48.ox, v40)
                local v51 = step(v48.oy, v40) and v50
                local v52 = step(v48.rot, v40) and v51
                local v53 = step(v48.sc, v40) and v52
                local v54 = step(v48.a, v40) and v53
                if v48.hs then
                    local v55 = step(v48.hs, v40) and v54
                    v54 = step(v48.hr, v40) and v55
                end
                local v56 = if v48 == panel and v29.live > 0 then false else v54
                v48.live = not v56
                if v56 then
                    forceWrite(v48)
                else
                    writeActor(v48)
                end
            elseif v49 and (v30 == 1 or v47 % 2 == v31) then
                writeActor(v48)
            end
        end
        local ws = panel.ws
        step_4(v40, v41, ws)
        step_5(v40, v41, ws)
        step_2(v40)
        step_3(v40)
        if state.live > 0 then
            step_6(v40)
        end
        step_7(v40, v41)
        if v27.closing and panel.pend == 0 and panel.a.t == 1 then
            local x = panel.a.x
            if SciFiTradeInUIConfig.CLOSE_DONE_ALPHA <= x then
                v38()
            end
        end
    end

    local function isShown() -- line 292 | captures: v37, v3
        return v37 and v3.Enabled and v3.Parent ~= nil
    end

    local function startLoop() -- line 296 | captures: v36, v37, v3, v27, onFrame, RunService, Sprites, GradientLoop, Juice
        if v36 then
            return
        end
        if not (v37 and v3.Enabled and v3.Parent ~= nil) then
            return
        end
        v36 = RunService.RenderStepped:Connect(onFrame)
        v27.running = true
        Sprites.start()
        GradientLoop.start()
        Juice.start()
    end

    local function stopLoop() -- line 307 | captures: v36, v27, v29, forceWrite, panel, Sprites, GradientLoop, BurstSheet, Juice
        if v36 then
            v36:Disconnect()
            v36 = nil
        end
        v27.running = false
        Sprites.stop()
        GradientLoop.stop()
        BurstSheet.hideAll()
        v29:hideAll()
        if not (panel.ix == 0 and panel.iy == 0) then
            panel.ix = 0
            panel.iy = 0
            forceWrite(panel)
        end
        Juice.stop()
    end

    function v38() -- line 326 | captures: v32, v33, SciFiTradeInMain, v27, toRest, list, stopLoop, Actors, Choreography, UFOs, Orbit
        v27.isOpen = false
        v27.closing = false
        v32 = true
        v33 = (1/0)
        stopLoop()
        SciFiTradeInMain.Visible = false
        local count = Actors.count
        for v57 = 1, count do
            local v58 = list[v57]
            if v58.session then
                toRest(v58)
            end
        end
        UFOs.toRest()
        Orbit.toRest()
        Choreography.clearOpen()
    end

    local function playOpen() -- line 345 | captures: v32, v33, v34, v35, v36, v37, v3, SciFiTradeInMain, v27, v29, panel, onFrame, RunService, SciFiTradeInUIConfig, Sprites, Choreography, GradientLoop, UFOs, Orbit, BurstSheet, Juice
        local v59 = v32
        v27.isOpen = true
        v27.closing = false
        v32 = false
        SciFiTradeInMain.Visible = true
        if v59 then
            local clock = v27.clock
            Choreography.prepareOpen(clock)
            local impactDelay = Choreography.impactDelay
            v33 = impactDelay and clock + impactDelay * SciFiTradeInUIConfig.TIME_SCALE or (1/0)
            local AbsoluteSize = v3.AbsoluteSize
            local Y = SciFiTradeInMain.AbsoluteSize.Y
            v34 = AbsoluteSize.X > 0 and Y / AbsoluteSize.X or 0
            v35 = AbsoluteSize.Y > 0 and Y / AbsoluteSize.Y or 0
            Sprites.resetSync()
            local ws = panel.ws
            UFOs.prepareOpen(clock, ws)
            Orbit.prepareOpen(clock, ws)
            BurstSheet.play(SciFiTradeInUIConfig.BURST_AT * SciFiTradeInUIConfig.TIME_SCALE)
            v27.buildGlitch()
            v29:play("open", SciFiTradeInUIConfig.GLITCH_OPEN_AT * SciFiTradeInUIConfig.TIME_SCALE)
        else
            Choreography.reopen(v27.clock)
            UFOs.onReopen()
            Orbit.onReopen()
        end
        v3.Enabled = true
        if not v36 and v37 and v3.Enabled and v3.Parent ~= nil then
            v36 = RunService.RenderStepped:Connect(onFrame)
            v27.running = true
            Sprites.start()
            GradientLoop.start()
            Juice.start()
        end
        Juice.onOpen(v59)
    end

    local function playClose() -- line 379 | captures: v32, v33, v36, v37, v38, v3, v27, v29, onFrame, RunService, SciFiTradeInUIConfig, Sprites, Choreography, GradientLoop, UFOs, Orbit, BurstSheet, Juice
        v27.isOpen = false
        v27.closing = true
        v32 = false
        v33 = (1/0)
        BurstSheet.hideAll()
        UFOs.onClose()
        Orbit.onClose()
        Juice.onClose()
        if v37 and v3.Enabled and v3.Parent ~= nil then
            v27.buildGlitch()
            v29:play("close", SciFiTradeInUIConfig.GLITCH_CLOSE_AT * SciFiTradeInUIConfig.TIME_SCALE)
            Choreography.queueClose(v27.clock)
            if not v36 and v37 and v3.Enabled and v3.Parent ~= nil then
                v36 = RunService.RenderStepped:Connect(onFrame)
                v27.running = true
                Sprites.start()
                GradientLoop.start()
                Juice.start()
            end
        else
            v38()
        end
    end

    local function setOpen(v60) -- line 400 | captures: v37, v27, playOpen, playClose
        if v37 and v60 ~= v27.isOpen then
            if v60 then
                playOpen()
            else
                playClose()
            end
        end
    end

    local v61 = {}
    local v62 = {}

    local function wireClose(v63) -- line 420 | captures: v3, v27, v62
        if v63.Name == "Close" and v63:IsA("GuiButton") and not v62[v63] then
            v62[v63] = v63.Activated:Connect(function() -- line 424 | captures: v3, v27
                if v27.isOpen then
                    v3:SetAttribute("Open", false)
                end
            end)
        end
    end

    local function unwireClose(v64) -- line 430 | captures: v62
        local v65 = v62[v64]
        if v65 then
            v65:Disconnect()
            v62[v64] = nil
        end
    end

    for v66, v67 in ipairs(SciFiTradeInMain:GetDescendants()) do
        wireClose(v67)
    end
    local Open = v3:GetAttributeChangedSignal("Open")
    v4(v61, Open:Connect(function() -- line 441 | captures: v37, v3, v27, playOpen, playClose
        local v68 = v3:GetAttribute("Open") == true
        if not v37 then
            return
        end
        if v68 == v27.isOpen then
            return
        end
        if v68 then
            playOpen()
        else
            playClose()
        end
    end))
    local DescendantAdded = SciFiTradeInMain.DescendantAdded
    v6(v61, DescendantAdded:Connect(function(v69) -- line 446 | captures: SciFiTradeInMain, wireClose, Rows, Buttons
        if v69:IsA("GuiButton") then
            Buttons.wire(v69)
            wireClose(v69)
        end
        if v69:IsA("GuiObject") then
            Rows.forgetItemOf(v69, SciFiTradeInMain)
        end
    end))
    local DescendantRemoving = SciFiTradeInMain.DescendantRemoving
    v8(v61, DescendantRemoving:Connect(function(v70) -- line 456 | captures: SciFiTradeInMain, toRest, map, v62, Actors, Rows, Choreography, Buttons
        local v71 = map[v70]
        local v72
        if v71 then
            if v70 == SciFiTradeInMain then
                v72 = true
            else
                if v71.session then
                    toRest(v71)
                end
                v72 = false
            end
        else
            v72 = true
        end
        if not v72 then
            Actors.removeActor(v70)
            Choreography.dropActor(v71)
        end
        Buttons.unwire(v70)
        local v73 = v62[v70]
        if v73 then
            v73:Disconnect()
            v62[v70] = nil
        end
        Rows.forgetItem(v70)
    end))

    local function onShownChanged() -- line 472 | captures: v36, v37, v38, v3, v27, onFrame, stopLoop, RunService, Sprites, GradientLoop, Juice
        if v37 and v3.Enabled and v3.Parent ~= nil then
            local v74, v75
            if v27.isOpen or v27.closing then
                if v36 then
                    v75 = true
                else
                    v74 = v37 and v3.Enabled and v3.Parent ~= nil
                    v75 = false
                end
            else
                v75 = true
            end
            if not v75 and v74 then
                v36 = RunService.RenderStepped:Connect(onFrame)
                v27.running = true
                Sprites.start()
                GradientLoop.start()
                Juice.start()
            end
        elseif v27.closing then
            v38()
        else
            stopLoop()
        end
    end

    local function onMainVisibleChanged() -- line 484 | captures: v37, v38, v3, SciFiTradeInMain, v27, playOpen
        if SciFiTradeInMain.Visible then
            if not (v27.isOpen or v27.closing) then
                if v37 and v27.isOpen ~= true then
                    playOpen()
                end
                v3:SetAttribute("Open", true)
            end
        elseif v27.isOpen or v27.closing then
            v38()
            v3:SetAttribute("Open", false)
        end
    end

    SciFiTradeInMain.Visible = false
    if v3:GetAttribute("Open") == true then
        playOpen()
    elseif v3:GetAttribute("Open") == nil then
        v3:SetAttribute("Open", false)
    end
    v10(v61, v3:GetPropertyChangedSignal("Enabled"):Connect(onShownChanged))
    v12(v61, v3.AncestryChanged:Connect(onShownChanged))
    v14(v61, SciFiTradeInMain:GetPropertyChangedSignal("Visible"):Connect(onMainVisibleChanged))
    local start = Warmup.start
    local v76 = {}

    function v76.atRest() -- line 509 | captures: v32, v27
        return v32 and not v27.isOpen and not v27.closing
    end

    function v76.lowEnd() -- line 512 | captures: v30, UFOs, Orbit
        v30 = 2
        UFOs.setLow(true)
        Orbit.setLow(true)
    end

    start(v27, v76)

    local function teardown() -- line 520 | captures: v37, v29, stopLoop, v61, v62, Actors, Choreography, UFOs, Orbit, Buttons, Juice, Warmup
        if not v37 then
            return
        end
        v37 = false
        Warmup.destroy()
        stopLoop()
        for v77, v78 in ipairs(v61) do
            v78:Disconnect()
        end
        table.clear(v61)
        for v79 in pairs(v62) do
            local v80 = v62[v79]
            if v80 then
                v80:Disconnect()
                v62[v79] = nil
            end
        end
        Buttons.unwireAll()
        UFOs.toRest()
        Orbit.toRest()
        Actors.clear()
        Choreography.clear()
        v29:destroy()
        Juice.destroy()
    end

    v3.Destroying:Once(teardown)
    local v81 = { Gui = v3 }

    function v81.SetOpen(v82) -- line 546 | captures: v37, v3
        if v37 then
            local v83 = v82 == true
            v3:SetAttribute("Open", v83)
        end
    end

    function v81.IsOpen() -- line 551 | captures: v37, v27
        return v37 and v27.isOpen
    end

    function v81.IsAlive() -- line 554 | captures: v37
        return v37
    end

    v81.Destroy = teardown
    return v81
end

return v1
