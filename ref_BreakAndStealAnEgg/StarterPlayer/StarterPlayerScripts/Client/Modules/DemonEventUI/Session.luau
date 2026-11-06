-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local DemonEventUIConfig = require(ReplicatedStorage.Shared.DemonEventUIConfig)
local Spring = require(script.Parent.Spring)
local Actors = require(script.Parent.Actors)
local Idle = require(script.Parent.Idle)
local Sprites = require(script.Parent.Sprites)
local ShopCards = require(script.Parent.ShopCards)
local Choreography = require(script.Parent.Choreography)
local TapBurst = require(script.Parent.TapBurst)
local OpeningParticleBurst = require(script.Parent.OpeningParticleBurst)
local Buttons = require(script.Parent.Buttons)
local EggItems = require(script.Parent.EggItems)
local Tabs = require(script.Parent.Tabs)
local GradientLoop = require(script.Parent.GradientLoop)
local Warmup = require(script.Parent.Warmup)
local v1 = {}

function v1.new(v2) -- line 89 | captures: RunService, UserInputService, DemonEventUIConfig, Spring, Actors, Idle, Sprites, ShopCards, Choreography, TapBurst, OpeningParticleBurst, Buttons, EggItems, Tabs, GradientLoop, Warmup
    local function v3(v4, ...)
        table.insert(v4, ...)
    end

    local function v5(v6, ...)
        table.insert(v6, ...)
    end

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

    local function v15(v16, ...)
        table.insert(v16, ...)
    end

    local v17 = Actors.new()
    local v18 = Idle.new()
    local v19 = Sprites.new()
    local v20 = ShopCards.new()
    local v21 = Choreography.new()
    local v22 = TapBurst.new()
    local v23 = OpeningParticleBurst.new()
    local v24 = Buttons.new()
    local v25 = EggItems.new()
    local v26 = Tabs.new()
    local v27 = GradientLoop.new()
    local v28 = Warmup.new()
    local Main = v2:WaitForChild("Main")
    local BG = Main:WaitForChild("BG")
    local Close = Main:FindFirstChild("Close")
    local v29 = {
        DemonWing = {},
        DemonGate = {},
        DemonTrident = {},
        DemonFlame = {},
        DemonCloud = {}
    }
    local v30 = {}
    for v31, v32 in ipairs(Main:GetChildren()) do
        if v32:IsA("GuiObject") then
            local v33 = v29[v32.Name]
            if v33 then
                table.insert(v33, v32)
            elseif v32:IsA("TextLabel") then
                table.insert(v30, v32)
            end
        end
    end
    local v34 = {}
    for v35, v36 in ipairs(Main:GetDescendants()) do
        if v36:IsA("UIGridLayout") and v36.Parent:IsA("GuiObject") then
            local Parent = v36.Parent
            table.insert(v34, Parent)
        end
    end
    local v37 = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
    local v38 = {
        gui = v2,
        main = Main,
        BG = BG,
        T = DemonEventUIConfig,
        Spring = Spring,
        rng = Random.new(),
        touchOnly = v37,
        wings = v29.DemonWing,
        gates = v29.DemonGate,
        tridents = v29.DemonTrident,
        flames = v29.DemonFlame,
        clouds = v29.DemonCloud,
        titles = v30,
        grids = v34,
        CloseButton = Close,
        CurrencyHolder = Main:FindFirstChild("CurrencyHolder"),
        Detail = Main:FindFirstChild("Detail"),
        ShopTab = Main:FindFirstChild("ShopTab"),
        EggTab = Main:FindFirstChild("EggTab"),
        Actors = v17,
        Sprites = v19,
        Idle = v18,
        ShopCards = v20,
        EggItems = v25,
        Tabs = v26,
        GradientLoop = v27,
        OpeningParticleBurst = v23,
        TapBurst = v22,
        lowEnd = false,
        clock = 0,
        isOpen = false,
        closing = false,
        running = false
    }
    v17.init(v38)
    v19.init(v38)
    v18.init(v38)
    v20.init(v38)
    v25.init(v38)
    v26.init(v38)
    v27.init(v38)
    v21.init(v38)
    v26.bind(v21)
    v22.init(v38)
    v23.init(v38)
    v24.init(v38)
    local step = Spring.step
    local kick = Spring.kick
    local goIn = v17.goIn
    local goOut = v17.goOut
    local writeActor = v17.writeActor
    local forceWrite = v17.forceWrite
    local toRest = v17.toRest
    local list = v17.list
    local map = v17.map
    local update = v18.update
    local step_2 = v19.step
    local step_3 = v22.step
    local state = v22.state
    local step_4 = v23.step
    local state_2 = v23.state
    local step_5 = v26.step
    local step_6 = v27.step
    local panel = v21.panel
    local MAX_DT = DemonEventUIConfig.MAX_DT
    local v39 = if v37 then 2 else 1
    local v40 = 0
    local v41 = true
    local v42 = (1/0)
    local v43
    local v44 = true
    local v45

    local function onFrame(v46) -- line 194 | captures: v39, v40, v42, v45, v17, v38, step, kick, goIn, goOut, writeActor, forceWrite, list, update, step_2, step_3, state, step_4, state_2, step_5, step_6, panel, MAX_DT, DemonEventUIConfig
        local v47 = if MAX_DT < v46 then MAX_DT else v46
        local v48 = v38.clock + v47
        v38.clock = v48
        local isOpen = v38.isOpen
        v40 = 1 - v40
        if v42 <= v48 then
            v42 = (1/0)
            kick(panel.sc, DemonEventUIConfig.IMPACT_KICK)
            panel.live = true
        end
        local count = v17.count
        for v49 = 1, count do
            local v50 = list[v49]
            local pend = v50.pend
            if pend ~= 0 and v50.pendAt <= v48 then
                v50.pend = 0
                if pend == 1 then
                    goIn(v50, v48)
                else
                    goOut(v50)
                end
            end
            local v51 = if v50.idle == 0 then false else v50.idleAt <= v48
            if v51 then
                update(v50, v47, v48, isOpen)
            end
            if v50.live then
                local v52 = step(v50.ox, v47)
                local v53 = step(v50.oy, v47) and v52
                local v54 = step(v50.rot, v47) and v53
                local v55 = step(v50.sc, v47) and v54
                local v56 = step(v50.a, v47) and v55
                if v50.hs then
                    local v57 = step(v50.hs, v47) and v56
                    v56 = step(v50.hr, v47) and v57
                    if v50.ld then
                        v56 = step(v50.ld, v47) and v56
                    end
                end
                v50.live = not v56
                if v56 then
                    forceWrite(v50)
                else
                    writeActor(v50)
                end
            elseif v51 and (v39 == 1 or v50.sync or v49 % 2 == v40) then
                writeActor(v50)
            end
        end
        step_2(v47)
        step_5(v47, v48)
        step_6(v47)
        if state.live > 0 then
            step_3(v47)
        end
        if state_2.live > 0 then
            step_4(v47)
        end
        if v38.closing and panel.pend == 0 and panel.a.t == 1 then
            local x = panel.a.x
            if DemonEventUIConfig.CLOSE_DONE_ALPHA <= x then
                v45()
            end
        end
    end

    local function isShown() -- line 270 | captures: v44, v2
        return v44 and v2.Enabled and v2.Parent ~= nil
    end

    local function startLoop() -- line 274 | captures: v43, v44, v2, v19, v22, v27, v38, onFrame, RunService
        if v43 then
            return
        end
        if not (v44 and v2.Enabled and v2.Parent ~= nil) then
            return
        end
        v43 = RunService.RenderStepped:Connect(onFrame)
        v38.running = true
        v19.start()
        v27.start()
        v22.start()
    end

    local function stopLoop() -- line 285 | captures: v43, v19, v22, v23, v27, v38
        if v43 then
            v43:Disconnect()
            v43 = nil
        end
        v38.running = false
        v19.stop()
        v27.stop()
        v22.stop()
        v23.hideAll()
    end

    function v45() -- line 299 | captures: v41, v42, v43, v17, v19, v21, v22, v23, v26, v27, Main, v38, toRest, list
        v38.isOpen = false
        v38.closing = false
        v41 = true
        v42 = (1/0)
        if v43 then
            v43:Disconnect()
            v43 = nil
        end
        v38.running = false
        v19.stop()
        v27.stop()
        v22.stop()
        v23.hideAll()
        Main.Visible = false
        local count = v17.count
        for v58 = 1, count do
            local v59 = list[v58]
            if v59.session then
                toRest(v59)
            end
        end
        v21.clearOpen()
        v26.onClosed()
    end

    local function playOpen() -- line 321 | captures: v41, v42, v43, v44, v2, v19, v21, v22, v23, v26, v27, Main, v38, onFrame, RunService, DemonEventUIConfig
        local v60 = v41
        v38.isOpen = true
        v38.closing = false
        v41 = false
        Main.Visible = true
        if v60 then
            v26.reset()
            local clock = v38.clock
            v21.prepareOpen(clock)
            local impactDelay = v21.impactDelay
            v42 = impactDelay and clock + impactDelay * DemonEventUIConfig.TIME_SCALE or (1/0)
            v19.resetSync()
            v23.play()
        else
            v21.reopen(v38.clock)
        end
        v2.Enabled = true
        if v43 then
            return
        end
        if not (v44 and v2.Enabled and v2.Parent ~= nil) then
            return
        end
        v43 = RunService.RenderStepped:Connect(onFrame)
        v38.running = true
        v19.start()
        v27.start()
        v22.start()
    end

    local function playClose() -- line 352 | captures: v41, v42, v43, v44, v45, v2, v19, v21, v22, v23, v27, v38, onFrame, RunService
        v38.isOpen = false
        v38.closing = true
        v41 = false
        v42 = (1/0)
        v23.hideAll()
        if v44 and v2.Enabled and v2.Parent ~= nil then
            v21.queueClose(v38.clock)
            if not v43 and v44 and v2.Enabled and v2.Parent ~= nil then
                v43 = RunService.RenderStepped:Connect(onFrame)
                v38.running = true
                v19.start()
                v27.start()
                v22.start()
            end
        else
            v45()
        end
    end

    local function setOpen(v61) -- line 369 | captures: v41, v42, v43, v44, v45, v2, v19, v21, v22, v23, v27, v38, onFrame, playOpen, RunService
        if v44 and v61 ~= v38.isOpen then
            if v61 then
                playOpen()
            else
                v38.isOpen = false
                v38.closing = true
                v41 = false
                v42 = (1/0)
                v23.hideAll()
                if v44 and v2.Enabled and v2.Parent ~= nil then
                    v21.queueClose(v38.clock)
                    if not v43 and v44 and v2.Enabled and v2.Parent ~= nil then
                        v43 = RunService.RenderStepped:Connect(onFrame)
                        v38.running = true
                        v19.start()
                        v27.start()
                        v22.start()
                    end
                else
                    v45()
                end
            end
        end
    end

    local v62 = {}
    local Open
    if Close and Close:IsA("GuiButton") then
        Open = Close.Activated
        v3(v62, Open:Connect(function() -- line 385 | captures: v2, v38
            if v38.isOpen then
                v2:SetAttribute("Open", false)
            end
        end))
    end
    Open = v2:GetAttributeChangedSignal("Open")
    v5(v62, Open:Connect(function() -- line 392 | captures: v41, v42, v43, v44, v45, v2, v19, v21, v22, v23, v27, v38, onFrame, playOpen, RunService
        local v63 = v2:GetAttribute("Open") == true
        if not v44 then
            return
        end
        if v63 == v38.isOpen then
            return
        end
        if v63 then
            playOpen()
        else
            v38.isOpen = false
            v38.closing = true
            v41 = false
            v42 = (1/0)
            v23.hideAll()
            if v44 and v2.Enabled and v2.Parent ~= nil then
                v21.queueClose(v38.clock)
                if not v43 and v44 and v2.Enabled and v2.Parent ~= nil then
                    v43 = RunService.RenderStepped:Connect(onFrame)
                    v38.running = true
                    v19.start()
                    v27.start()
                    v22.start()
                end
            else
                v45()
            end
        end
    end))
    Open = Main.DescendantAdded
    v7(v62, Open:Connect(function(v64) -- line 397 | captures: v20, v24, v25, Main
        if v64:IsA("GuiButton") then
            v24.wire(v64)
        end
        if v64:IsA("GuiObject") then
            v20.forgetCardOf(v64, Main)
            v25.forgetItemOf(v64, Main)
        end
    end))
    Open = Main.DescendantRemoving
    v9(v62, Open:Connect(function(v65) -- line 409 | captures: v17, v20, v21, v24, v25, Main, toRest, map
        local v66 = map[v65]
        local v67
        if v66 then
            if v65 == Main then
                v67 = true
            else
                if v66.session then
                    toRest(v66)
                end
                v67 = false
            end
        else
            v67 = true
        end
        if not v67 then
            v17.removeActor(v65)
            v21.dropActor(v66)
        end
        v24.unwire(v65)
        v20.forgetItem(v65)
        v25.forgetItem(v65)
    end))

    local function onShownChanged() -- line 428 | captures: v43, v44, v45, v2, v19, v22, v23, v27, v38, onFrame, RunService
        if v44 and v2.Enabled and v2.Parent ~= nil then
            local v68, v69
            if v38.isOpen or v38.closing then
                if v43 then
                    v69 = true
                else
                    v68 = v44 and v2.Enabled and v2.Parent ~= nil
                    v69 = false
                end
            else
                v69 = true
            end
            if not v69 and v68 then
                v43 = RunService.RenderStepped:Connect(onFrame)
                v38.running = true
                v19.start()
                v27.start()
                v22.start()
            end
        elseif v38.closing then
            v45()
        else
            if v43 then
                v43:Disconnect()
                v43 = nil
            end
            v38.running = false
            v19.stop()
            v27.stop()
            v22.stop()
            v23.hideAll()
        end
    end

    local function onMainVisibleChanged() -- line 443 | captures: v44, v45, v2, Main, v38, playOpen
        if Main.Visible then
            if not (v38.isOpen or v38.closing) then
                if v44 and v38.isOpen ~= true then
                    playOpen()
                end
                v2:SetAttribute("Open", true)
            end
        elseif v38.isOpen or v38.closing then
            v45()
            v2:SetAttribute("Open", false)
        end
    end

    Main.Visible = false
    if v2:GetAttribute("Open") == true then
        playOpen()
    elseif v2:GetAttribute("Open") == nil then
        v2:SetAttribute("Open", false)
    end
    v11(v62, v2:GetPropertyChangedSignal("Enabled"):Connect(onShownChanged))
    v13(v62, v2.AncestryChanged:Connect(onShownChanged))
    v15(v62, Main:GetPropertyChangedSignal("Visible"):Connect(onMainVisibleChanged))
    Open = v28.start
    local v70 = {}

    function v70.atRest() -- line 473 | captures: v41, v38
        return v41 and not v38.isOpen and not v38.closing
    end

    function v70.lowEnd() -- line 476 | captures: v39
        v39 = 2
    end

    Open(v38, v70)

    local function teardown() -- line 482 | captures: v43, v44, v17, v19, v21, v22, v23, v24, v26, v27, v28, v38, v62
        if not v44 then
            return
        end
        v44 = false
        v28.destroy()
        if v43 then
            v43:Disconnect()
            v43 = nil
        end
        v38.running = false
        v19.stop()
        v27.stop()
        v22.stop()
        v23.hideAll()
        for v71, v72 in ipairs(v62) do
            v72:Disconnect()
        end
        table.clear(v62)
        v24.unwireAll()
        v26.destroy()
        v17.clear()
        v21.clear()
        v23.destroy()
    end

    v2.Destroying:Once(teardown)
    local v73 = { Gui = v2 }

    function v73.SetOpen(v74) -- line 503 | captures: v44, v2
        if v44 then
            local v75 = v74 == true
            v2:SetAttribute("Open", v75)
        end
    end

    function v73.IsOpen() -- line 508 | captures: v44, v38
        return v44 and v38.isOpen
    end

    function v73.IsAlive() -- line 511 | captures: v44
        return v44
    end

    v73.Destroy = teardown
    return v73
end

return v1
