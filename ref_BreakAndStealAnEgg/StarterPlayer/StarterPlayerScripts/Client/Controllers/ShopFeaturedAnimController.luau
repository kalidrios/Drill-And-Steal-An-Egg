-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ShopFeaturedAnimConfig = require(ReplicatedStorage.Shared.ShopFeaturedAnimConfig)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local GuiFade = require(script.Parent.Parent.Modules.GuiFade)
local Spring = require(script.Parent.Parent.Modules.DemonEventUI.Spring)
local UiFrames = require(script.Parent.UiFrames)
local v1 = {}
local step = Spring.step
local to = Spring.to
local snap = Spring.snap
local kick = Spring.kick
local sin = math.sin

local function resolve(v2, v3) -- line 82
    local v4 = v2
    for v5, v6 in v3 do
        v4 = v4 and v4:FindFirstChild(v6)
    end
    return v4
end

local function scaleOf(v7) -- line 90
    local UIScale = v7:FindFirstChildOfClass("UIScale")
    if UIScale then
        return UIScale
    end
    local UIScale_2 = Instance.new("UIScale")
    UIScale_2.Name = "ButtonTweenScale"
    UIScale_2.Parent = v7
    return UIScale_2
end

local function newActor(v8, v9, v10) -- line 101 | captures: ShopFeaturedAnimConfig, Spring
    local v11 = {
        Scale = 1,
        Fade = nil,
        InF = 3,
        InD = 0.5,
        InAt = 0,
        Pending = false,
        Live = false,
        Impact = false,
        Bob = nil,
        IdleAt = (1/0),
        Iy = 0,
        Ir = 0,
        Inst = v8
    }
    local UIScale = v8:FindFirstChildOfClass("UIScale")
    if not UIScale then
        UIScale = Instance.new("UIScale")
        UIScale.Name = "ButtonTweenScale"
        UIScale.Parent = v8
    end
    v11.ScaleObj = UIScale
    v11.Centre = v9
    v11.MovesPosition = v10
    v11.Pos = v8.Position
    v11.Rot = v8.Rotation
    v11.Anchor = v8.AnchorPoint
    v11.Size = v8.Size
    v11.Ox = Spring.new(0, 3, 1)
    v11.Oy = Spring.new(0, 3, 1)
    v11.R = Spring.new(0, 3, 1)
    v11.S = Spring.new(1, 3, 1)
    v11.A = Spring.new(0, ShopFeaturedAnimConfig.FadeSpeed, 1)
    return v11
end

local function readRest(v12) -- line 133
    local Inst = v12.Inst
    local UIScale = Inst:FindFirstChildOfClass("UIScale")
    if not UIScale then
        UIScale = Instance.new("UIScale")
        UIScale.Name = "ButtonTweenScale"
        UIScale.Parent = Inst
    end
    v12.ScaleObj = UIScale
    v12.Pos = Inst.Position
    v12.Rot = Inst.Rotation
    v12.Scale = v12.ScaleObj.Scale
    v12.Anchor = Inst.AnchorPoint
    v12.Size = Inst.Size
end

local function write(v13) -- line 143 | captures: GuiFade
    local x = v13.S.x
    if x < 0 then
        x = 0
    end
    v13.ScaleObj.Scale = v13.Scale * x
    v13.Inst.Rotation = v13.Rot + v13.R.x + v13.Ir
    if v13.MovesPosition then
        local Pos = v13.Pos
        local Size = v13.Size
        local v14, v15, v16, v17
        if v13.Centre then
            local v18 = 1 - x * v13.Scale
            local v19 = (0.5 - v13.Anchor.X) * v18
            local v20 = (0.5 - v13.Anchor.Y) * v18
            v14, v16, v15, v17 = v19 * Size.X.Scale, v20 * Size.Y.Scale, v19 * Size.X.Offset, v20 * Size.Y.Offset
        else
            v14 = 0
            v16 = 0
            v15 = 0
            v17 = 0
        end
        v13.Inst.Position = UDim2.new(Pos.X.Scale + v13.Ox.x + v14, Pos.X.Offset + v15, Pos.Y.Scale + v13.Oy.x + v13.Iy + v16, Pos.Y.Offset + v17)
    end
    if not v13.Fade then
        return
    end
    local Set = GuiFade.Set
    local Fade = v13.Fade
    local x_2 = v13.A.x
    Set(Fade, (math.clamp(x_2, 0, 1)))
end

local function toRest(v21) -- line 174 | captures: snap, write
    snap(v21.Ox, 0)
    snap(v21.Oy, 0)
    snap(v21.R, 0)
    snap(v21.S, 1)
    snap(v21.A, 0)
    v21.Iy = 0
    v21.Ir = 0
    v21.Pending = false
    v21.Live = false
    v21.IdleAt = (1/0)
    write(v21)
    v21.Fade = nil
end

local function bind(v22) -- line 188 | captures: RunService, ShopFeaturedAnimConfig, GuiFade, UiFrames, step, to, snap, kick, sin, newActor, write, toRest
    local v23 = v22
    for v24, v25 in ShopFeaturedAnimConfig.ShopPath do
        v23 = v23 and v23:FindFirstChild(v25)
    end
    local v26 = v22
    for v27, v28 in ShopFeaturedAnimConfig.CardPath do
        v26 = v26 and v26:FindFirstChild(v28)
    end
    if v23 and v23:IsA("GuiObject") and v26 and v26:IsA("GuiObject") then
        local v29 = true
        local v30 = false
        local v31 = 0
        local v32 = (1/0)
        local v33
        local v34 = newActor(v26, true, true)
        local v35 = {}
        local v36 = {}
        local v37 = {}
        local v38 = {}
        for v39, v40 in ShopFeaturedAnimConfig.Parts do
            local v41 = v26:FindFirstChild(v40.Name)
            if v41 and v41:IsA("GuiObject") then
                local v42 = newActor(v41, true, true)
                local v43 = v40.Spring[1]
                local v44 = v40.Spring[2]
                v42.InF = v43
                v42.InD = v44
                v42.Impact = v40.Impact == true
                v42.Bob = v40.Idle and v40.Idle.Bob or nil
                table.insert(v35, v42)
                v36[v41] = v40
            else
                warn((("[ShopFeaturedAnimController] card part missing: %*"):format(v40.Name)))
            end
        end
        local Tiles = ShopFeaturedAnimConfig.Tiles
        local v45 = v26:FindFirstChild(Tiles.Container)

        local function collectTiles() -- line 228 | captures: Tiles, v45
            local v46 = {}
            if v45 then
                for v47, v48 in v45:GetChildren() do
                    if v48:IsA("GuiObject") and v48.Visible and string.match(v48.Name, Tiles.Pattern) then
                        table.insert(v46, v48)
                    end
                end
                table.sort(v46, function(v49, v50) -- line 238
                    return v49.AbsolutePosition.X < v50.AbsolutePosition.X
                end)
            end
            return v46
        end

        local function eachActor(v51) -- line 244 | captures: v34, v35, v37
            v51(v34)
            for v52, v53 in v35 do
                v51(v53)
            end
            for v54, v55 in v37 do
                v51(v55)
            end
        end

        local v56 = 0

        local function stepActor(v57) -- line 258 | captures: v31, v56, ShopFeaturedAnimConfig, step, to, sin, write
            local v58 = v56
            if v57.Pending then
                local v59 = v31
                if v57.InAt <= v59 then
                    v57.Pending = false
                    to(v57.Ox, 0, v57.InF, v57.InD)
                    to(v57.Oy, 0, v57.InF, v57.InD)
                    to(v57.R, 0, v57.InF, v57.InD)
                    to(v57.S, 1, v57.InF, v57.InD)
                    to(v57.A, 0, ShopFeaturedAnimConfig.FadeSpeed, 1)
                    v57.IdleAt = v31 + 0.35
                    v57.Live = true
                end
            end
            local Bob = v57.Bob
            local v60
            if Bob then
                local v61 = v31
                if v57.IdleAt <= v61 then
                    local v62 = (v31 - v57.IdleAt) / ShopFeaturedAnimConfig.IdleRamp
                    local v63 = math.clamp(v62, 0, 1)
                    local v64 = v63 * v63 * (3 - v63 * 2)
                    local v65 = (v31 - v57.IdleAt) * 6.283185307179586 / Bob.Period + 3.141592653589793
                    v57.Iy = sin(v65) * Bob.AmpY * v64
                    local v66 = v65 - 0.9
                    v57.Ir = sin(v66) * Bob.AmpR * v64
                    v60 = true
                else
                    v60 = false
                end
            else
                v60 = false
            end
            if v57.Live then
                local v67 = step(v57.Ox, v58)
                local v68 = step(v57.Oy, v58) and v67
                local v69 = step(v57.R, v58) and v68
                local v70 = step(v57.S, v58) and v69
                v57.Live = not (step(v57.A, v58) and v70)
                write(v57)
            elseif v60 then
                write(v57)
            end
        end

        local function onFrame(v71) -- line 296 | captures: v31, v32, v56, v34, eachActor, stepActor, ShopFeaturedAnimConfig, kick
            local v72 = if v71 > 0.05 then 0.05 else v71
            v31 += v72
            v56 = v72
            local v73 = v31
            if v32 <= v73 then
                v32 = (1/0)
                kick(v34.S, ShopFeaturedAnimConfig.ImpactKick)
                v34.Live = true
            end
            eachActor(stepActor)
        end

        local function stopLoop() -- line 312 | captures: v33
            if v33 then
                v33:Disconnect()
                v33 = nil
            end
        end

        local function park(v74, v75, v76, v77) -- line 319 | captures: v31, ShopFeaturedAnimConfig, GuiFade, snap, write
            local Inst = v74.Inst
            local UIScale = Inst:FindFirstChildOfClass("UIScale")
            if not UIScale then
                UIScale = Instance.new("UIScale")
                UIScale.Name = "ButtonTweenScale"
                UIScale.Parent = Inst
            end
            v74.ScaleObj = UIScale
            v74.Pos = Inst.Position
            v74.Rot = Inst.Rotation
            v74.Scale = v74.ScaleObj.Scale
            v74.Anchor = Inst.AnchorPoint
            v74.Size = Inst.Size
            if v77 then
                v74.Fade = GuiFade.Capture(v74.Inst)
            else
                v74.Fade = nil
            end
            snap(v74.Ox, v75.X or 0)
            snap(v74.Oy, v75.Y or 0)
            snap(v74.R, v75.Rot or 0)
            snap(v74.S, v75.Scale or 1)
            local A = v74.A
            local v78 = if v77 then 1 else 0
            snap(A, v78)
            v74.Iy = 0
            v74.Ir = 0
            v74.InAt = v31 + v76 * ShopFeaturedAnimConfig.TimeScale
            v74.Pending = true
            v74.Live = false
            v74.IdleAt = (1/0)
            write(v74)
        end

        local function finish() -- line 335 | captures: v30, v32, v33, eachActor, toRest
            if v33 then
                v33:Disconnect()
                v33 = nil
            end
            v32 = (1/0)
            eachActor(toRest)
            v30 = false
        end

        local function play() -- line 342 | captures: v30, v31, v32, v33, v34, v35, v36, v37, v38, Tiles, v45, collectTiles, eachActor, onFrame, park, RunService, ShopFeaturedAnimConfig, snap, newActor, toRest
            if v30 then
                if v33 then
                    v33:Disconnect()
                    v33 = nil
                end
                v32 = (1/0)
                eachActor(toRest)
                v30 = false
            end
            v30 = true
            v31 = 0
            local Inst = v34.Inst
            local UIScale = Inst:FindFirstChildOfClass("UIScale")
            if not UIScale then
                UIScale = Instance.new("UIScale")
                UIScale.Name = "ButtonTweenScale"
                UIScale.Parent = Inst
            end
            v34.ScaleObj = UIScale
            v34.Pos = Inst.Position
            v34.Rot = Inst.Rotation
            v34.Scale = v34.ScaleObj.Scale
            v34.Anchor = Inst.AnchorPoint
            v34.Size = Inst.Size
            local v79 = ShopFeaturedAnimConfig.CardSpring[1]
            local v80 = ShopFeaturedAnimConfig.CardSpring[2]
            v34.InF = v79
            v34.InD = v80
            snap(v34.S, 1)
            local S = v34.S
            local S_2 = v34.S
            local v81 = ShopFeaturedAnimConfig.CardSpring[1]
            local v82 = ShopFeaturedAnimConfig.CardSpring[2]
            S.f = v81
            S_2.d = v82
            v32 = (1/0)
            for v83, v84 in v35 do
                local v85 = v36[v84.Inst]
                park(v84, v85.From, v85.At, v85.Fade == true)
                if v84.Impact then
                    v32 = (v85.At + ShopFeaturedAnimConfig.ImpactAfter) * ShopFeaturedAnimConfig.TimeScale
                end
            end
            for v86, v87 in v37 do
                toRest(v87)
            end
            table.clear(v37)
            for v88, v89 in collectTiles() do
                local v90 = v38[v89]
                if not (v90 and v90.Inst.Parent == v45) then
                    v90 = newActor(v89, false, false)
                    local v91 = Tiles.Spring[1]
                    local v92 = Tiles.Spring[2]
                    v90.InF = v91
                    v90.InD = v92
                    v38[v89] = v90
                end
                park(v90, { Scale = Tiles.FromScale }, Tiles.At + (v88 - 1) * Tiles.Step, false)
                table.insert(v37, v90)
            end
            if v33 then
                v33:Disconnect()
                v33 = nil
            end
            v33 = RunService.RenderStepped:Connect(onFrame)
        end

        UiFrames.Observe(v23, function(v93) -- line 384 | captures: v29, v30, v32, v33, eachActor, play, toRest
            if v29 then
                if v93 then
                    play()
                elseif v30 then
                    if v33 then
                        v33:Disconnect()
                        v33 = nil
                    end
                    v32 = (1/0)
                    eachActor(toRest)
                    v30 = false
                end
            end
        end)
        v22.Destroying:Once(function() -- line 395 | captures: v29, v33, v35, v37, v38
            v29 = false
            if v33 then
                v33:Disconnect()
                v33 = nil
            end
            table.clear(v37)
            table.clear(v38)
            table.clear(v35)
        end)
    else
        warn((("[ShopFeaturedAnimController] missing MainGUI.%*"):format((table.concat(ShopFeaturedAnimConfig.CardPath, ".")))))
    end
end

function v1.Start() -- line 404 | captures: MainGui, bind
    MainGui.Observe(bind)
end

return v1
