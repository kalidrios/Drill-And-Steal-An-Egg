-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local BinaryTransitionConfig = require(ReplicatedStorage.Shared.BinaryTransitionConfig)
local CameraFovController = require(script.Parent.Parent.Controllers.CameraFovController)
local v1 = { TransitionCovered = Instance.new("BindableEvent") }

v1.TransitionCovered.Name = "TransitionCovered"
v1.SceneReady = Instance.new("BindableEvent")
v1.SceneReady.Name = "SceneReady"
v1.Finished = Instance.new("BindableEvent")
v1.Finished.Name = "Finished"

local v2 = false

function v1.IsPlaying() -- line 84 | captures: v2
    return v2
end

local function lerp(v3, v4, v5) -- line 92
    return v3 + (v4 - v3) * v5
end

local function quantise(v6) -- line 96
    local v7 = math.clamp(v6, 0, 1) * 40 + 0.5
    return math.floor(v7) / 40
end

local function popEase(v8) -- line 101 | captures: BinaryTransitionConfig
    if v8 >= 1 then
        return 1
    end
    if v8 <= 0 then
        return 0
    end
    local POP_OVERSHOOT = BinaryTransitionConfig.POP_OVERSHOOT
    local v9 = POP_OVERSHOOT + 1
    local v10 = v8 - 1
    return 1 + v9 * v10 * v10 * v10 + POP_OVERSHOOT * v10 * v10
end

local function shrinkEase(v11) -- line 114
    local v12 = 1 - math.clamp(v11, 0, 1)
    return v12 * v12
end

local function easeInOutSine(v13) -- line 120
    local v14 = math.clamp(v13, 0, 1) * 3.141592653589793
    return 0.5 - math.cos(v14) * 0.5
end

local FIRE_PALETTE = BinaryTransitionConfig.FIRE_PALETTE

local function fireColor(v15) -- line 126 | captures: FIRE_PALETTE
    if v15 <= FIRE_PALETTE[1][1] then
        return FIRE_PALETTE[1][2]
    end
    local v16 = #FIRE_PALETTE
    for v17 = 2, v16 do
        local v18 = FIRE_PALETTE[v17]
        if v15 <= v18[1] then
            local v19 = FIRE_PALETTE[v17 - 1]
            return v19[2]:Lerp(v18[2], (v15 - v19[1]) / (v18[1] - v19[1]))
        end
    end
    return FIRE_PALETTE[#FIRE_PALETTE][2]
end

local function viewportSize(v20) -- line 148 | captures: Workspace
    local CurrentCamera = Workspace.CurrentCamera
    local v21
    if CurrentCamera then
        v21 = CurrentCamera.ViewportSize
    else
        v21 = Vector2.new(1372, 758)
    end
    if v20 then
        local AbsoluteSize = v20.AbsoluteSize
        local new = Vector2.new
        local X = v21.X
        local X_2 = AbsoluteSize.X
        local v22 = math.max(X, X_2)
        local Y = v21.Y
        local Y_2 = AbsoluteSize.Y
        v21 = new(v22, (math.max(Y, Y_2)))
    end
    return v21
end

local function tileSizeFor(v23) -- line 160 | captures: BinaryTransitionConfig
    local v24 = if v23.Y < BinaryTransitionConfig.SMALL_SCREEN_HEIGHT then BinaryTransitionConfig.SMALL_SCREEN_COLUMNS else BinaryTransitionConfig.COLUMNS
    local v25 = v23.X / v24
    local v26 = math.floor(v25)
    return (math.max(1, v26))
end

local v27 = BinaryTransitionConfig.EDGE_BLEED_COLUMNS or 0
local v28 = math.max(0, v27)

local function gridFor(v29) -- line 170 | captures: BinaryTransitionConfig, v28
    local v30 = if v29.Y < BinaryTransitionConfig.SMALL_SCREEN_HEIGHT then BinaryTransitionConfig.SMALL_SCREEN_COLUMNS else BinaryTransitionConfig.COLUMNS
    local v31 = v29.X / v30
    local v32 = math.floor(v31)
    local v33 = math.max(1, v32)
    local v34 = v29.X / v33
    local v35 = math.ceil(v34) + v28 * 2
    local v36 = v29.Y / v33
    return v33, v35, math.ceil(v36) + 1
end

local function randomSettledColor(v37) -- line 177 | captures: BinaryTransitionConfig
    local v38 = BinaryTransitionConfig.SETTLED_COLOR:Lerp(BinaryTransitionConfig.SETTLED_COLOR_ALT, v37:NextNumber())
    local v39 = v37:NextNumber(BinaryTransitionConfig.SETTLED_BRIGHTNESS_MIN, 1)
    return Color3.new(v38.R * v39, v38.G * v39, v38.B * v39)
end

local function randomDigit(v40) -- line 183
    if v40:NextNumber() < 0.5 then
        return "0"
    end
    return "1"
end

local function buildTile(v41, v42, v43, v44) -- line 187 | captures: BinaryTransitionConfig, fireColor
    local Frame = Instance.new("Frame")
    Frame.Name = ("Tile_%*_%*"):format(v43, v44)
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = fireColor(BinaryTransitionConfig.EDGE_GLOW_HEAT)
    Frame.BackgroundTransparency = 0
    Frame.BorderSizePixel = 0
    Frame.Visible = false
    Frame.ZIndex = 2
    if BinaryTransitionConfig.CORNER_RADIUS > 0 then
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, BinaryTransitionConfig.CORNER_RADIUS)
        UICorner.Parent = Frame
    end
    local UIStroke = Instance.new("UIStroke")
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = BinaryTransitionConfig.EDGE_STROKE_COLOR
    UIStroke.Thickness = BinaryTransitionConfig.EDGE_STROKE_THICKNESS
    UIStroke.Transparency = BinaryTransitionConfig.EDGE_STROKE_TRANSPARENCY
    UIStroke.Parent = Frame
    local UIScale = Instance.new("UIScale")
    UIScale.Scale = 0
    UIScale.Parent = Frame
    local TextLabel
    if BinaryTransitionConfig.SHOW_DIGITS then
        local TextLabel_2 = Instance.new("TextLabel")
        TextLabel_2.Name = "Digit"
        TextLabel_2.BackgroundTransparency = 1
        TextLabel_2.Size = UDim2.fromScale(1, 1)
        TextLabel_2.FontFace = BinaryTransitionConfig.FONT
        if v42:NextNumber() < 0.5 then
            TextLabel_2.Text = "0"
        else
            TextLabel_2.Text = "1"
        end
        TextLabel_2.TextColor3 = BinaryTransitionConfig.EDGE_TEXT_COLOR
        TextLabel_2.TextTransparency = 0
        TextLabel_2.TextXAlignment = Enum.TextXAlignment.Center
        TextLabel_2.TextYAlignment = Enum.TextYAlignment.Center
        TextLabel_2.Parent = Frame
        TextLabel = TextLabel_2
    end
    Frame.Parent = v41
    local v45 = {
        Appear = 0,
        CoolAt = 0,
        WhiteOffset = 0,
        RemoveOffset = 0,
        FlashUntil = (-1/0),
        ShownVisible = false,
        ShownScale = 0,
        ShownWhite = 1,
        ShownChar = 0,
        Leaving = false,
        Frame = Frame,
        Label = TextLabel,
        Stroke = UIStroke,
        Scale = UIScale,
        Column = v43,
        Row = v44
    }
    local v46 = BinaryTransitionConfig.SETTLED_COLOR:Lerp(BinaryTransitionConfig.SETTLED_COLOR_ALT, v42:NextNumber())
    local v47 = v42:NextNumber(BinaryTransitionConfig.SETTLED_BRIGHTNESS_MIN, 1)
    v45.Settled = Color3.new(v46.R * v47, v46.G * v47, v46.B * v47)
    local EDGE_GLOW_HEAT = BinaryTransitionConfig.EDGE_GLOW_HEAT
    local v48 = math.clamp(EDGE_GLOW_HEAT, 0, 1) * 40 + 0.5
    v45.ShownBackground = math.floor(v48) / 40
    return v45
end

local function layout(v49) -- line 262 | captures: Workspace, BinaryTransitionConfig, v28
    local Gui = v49.Gui
    local CurrentCamera = Workspace.CurrentCamera
    local v50
    if CurrentCamera then
        v50 = CurrentCamera.ViewportSize
    else
        v50 = Vector2.new(1372, 758)
    end
    if Gui then
        local AbsoluteSize = Gui.AbsoluteSize
        local new = Vector2.new
        local X = v50.X
        local X_2 = AbsoluteSize.X
        local v51 = math.max(X, X_2)
        local Y = v50.Y
        local Y_2 = AbsoluteSize.Y
        v50 = new(v51, (math.max(Y, Y_2)))
    end
    local v52 = if v50.Y < BinaryTransitionConfig.SMALL_SCREEN_HEIGHT then BinaryTransitionConfig.SMALL_SCREEN_COLUMNS else BinaryTransitionConfig.COLUMNS
    local v53 = v50.X / v52
    local v54 = math.floor(v53)
    local v55 = math.max(1, v54)
    local X = v50.X
    local v56 = v49.Columns - v28 * 2
    local v57 = X / math.max(v56, 1)
    local v58 = math.ceil(v57)
    local v59 = v50.Y / v49.Rows
    local v60 = math.ceil(v59)
    local v61 = math.max(v55, v58, v60, 1)
    local v62 = v61 - BinaryTransitionConfig.TILE_GAP
    local v63 = math.max(1, v62)
    local v64 = v61 * BinaryTransitionConfig.TEXT_SIZE_RATIO
    local v65 = math.floor(v64)
    local v66 = math.max(1, v65)
    for v67, v68 in v49.Tiles do
        v68.Frame.Position = UDim2.fromOffset((v68.Column - v28) * v61 + v61 * 0.5, v68.Row * v61 + v61 * 0.5)
        v68.Frame.Size = UDim2.fromOffset(v63, v63)
        if v68.Label then
            v68.Label.TextSize = v66
        end
    end
end

local function scheduleCover(v69, v70) -- line 288 | captures: BinaryTransitionConfig
    local Rows = v69.Rows
    local v71 = {}
    local v72 = {}
    local Columns = v69.Columns
    local v73 = 0
    for v74 = 1, Columns do
        v71[v74] = v70:NextNumber(0, BinaryTransitionConfig.DELAY_MAX)
        v72[v74] = v70:NextNumber(BinaryTransitionConfig.SPEED_MIN, BinaryTransitionConfig.SPEED_MAX)
        local v75 = v71[v74] + (Rows - 1) * v72[v74]
        v73 = math.max(v73, v75)
    end
    local v76 = if v73 > 0 then (BinaryTransitionConfig.COVER_TIME - BinaryTransitionConfig.POP_TIME) / v73 else 1
    local Columns_2 = v69.Columns
    for v77 = 1, Columns_2 do
        local v78 = v69.ByColumn[v77]
        local v79 = v71[v77] * v76
        local v80 = v72[v77] * v76
        for v81 = 1, Rows do
            v78[v81].Appear = v79 + (v81 - 1) * v80
        end
        local v82 = v70:NextInteger(BinaryTransitionConfig.SPARK_ROWS_MIN, BinaryTransitionConfig.SPARK_ROWS_MAX)
        if v70:NextNumber() < BinaryTransitionConfig.SPARK_CHANCE then
            local v83 = Rows - 1
            if v82 + 2 <= v83 then
                local v84 = v70:NextInteger(v82 + 2, Rows - 1)
                v78[v84].Appear = v78[v84 - v82].Appear + v80 * v70:NextNumber(0.2, 0.8)
            end
        end
        for v85 = 1, Rows do
            local v86 = v78[v85]
            local v87 = v78[v85 + 1]
            if v87 then
                local v88 = v86.Appear + BinaryTransitionConfig.POP_TIME
                local Appear = v87.Appear
                v86.CoolAt = math.max(v88, Appear)
            else
                local Appear = v86.Appear
                local v89 = v86.Appear + v80
                local v90 = BinaryTransitionConfig.COVER_TIME - BinaryTransitionConfig.SETTLE_TIME
                local v91 = math.min(v89, v90)
                v86.CoolAt = math.max(Appear, v91)
            end
        end
    end
end

local function scheduleReveal(v92, v93) -- line 332 | captures: BinaryTransitionConfig
    local Rows = v92.Rows
    local Columns = v92.Columns
    local v94 = 0
    for v95 = 1, Columns do
        local v96 = v92.ByColumn[v95]
        local v97 = v93:NextNumber(0, BinaryTransitionConfig.REVEAL_DELAY_MAX)
        local v98 = v93:NextNumber(BinaryTransitionConfig.REVEAL_SPEED_MIN, BinaryTransitionConfig.REVEAL_SPEED_MAX)
        for v99 = 1, Rows do
            local v100 = v97 + (v99 - 1) * v98
            if Rows - BinaryTransitionConfig.STRAGGLER_ROWS < v99 then
                v100 += v93:NextNumber(0, BinaryTransitionConfig.STRAGGLER_JITTER)
            end
            v96[v99].RemoveOffset = v100
            v94 = math.max(v94, v100)
        end
    end
    local v101 = if v94 > 0 then (BinaryTransitionConfig.REVEAL_TIME - BinaryTransitionConfig.SHRINK_TIME) / v94 else 1
    local Columns_2 = v92.Columns
    for v102 = 1, Columns_2 do
        local v103 = v92.ByColumn[v102]
        for v104 = 1, Rows do
            local v105 = v103[v104]
            v105.RemoveOffset *= v101
        end
        for v106 = 1, Rows do
            local v107 = v103[v106]
            local v108 = v103[v106 - 1]
            local v109 = v107.RemoveOffset - BinaryTransitionConfig.REVEAL_EDGE_LEAD
            if v108 then
                local RemoveOffset = v108.RemoveOffset
                v109 = math.min(RemoveOffset, v109)
            end
            v107.WhiteOffset = math.max(0, v109)
        end
    end
end

local function fuelAt(v110) -- line 373 | captures: BinaryTransitionConfig
    if v110.Covered then
        local v111 = (v110.Time - v110.CoveredAt) / BinaryTransitionConfig.FIRE_IGNITE_TIME
        local v112 = math.clamp(v111, 0, 1)
        if v110.RevealStart then
            local v113 = (v110.Time - v110.RevealStart) / BinaryTransitionConfig.FIRE_DIE_TIME
            v112 *= 1 - math.clamp(v113, 0, 1)
        end
        return v112
    end
    return 0
end

local function fireStep(v114) -- line 388 | captures: BinaryTransitionConfig
    local Heat = v114.Heat
    local Rng = v114.Rng
    local Columns = v114.Columns
    local Rows = v114.Rows
    local v115
    if v114.Covered then
        local v116 = (v114.Time - v114.CoveredAt) / BinaryTransitionConfig.FIRE_IGNITE_TIME
        v115 = math.clamp(v116, 0, 1)
        if v114.RevealStart then
            local v117 = (v114.Time - v114.RevealStart) / BinaryTransitionConfig.FIRE_DIE_TIME
            v115 *= 1 - math.clamp(v117, 0, 1)
        end
    else
        v115 = 0
    end
    local FIRE_WIND = BinaryTransitionConfig.FIRE_WIND
    local v118 = if FIRE_WIND > 0 then 1 else -1
    for v119 = 1, Columns do
        Heat[v119][Rows] = v115 * Rng:NextNumber(BinaryTransitionConfig.FIRE_FUEL_MIN, 1)
    end
    local v120 = Rows - 1
    for v121 = 1, v120 do
        for v122 = 1, Columns do
            local v123 = Rng:NextInteger(-1, 1)
            if FIRE_WIND ~= 0 and Rng:NextNumber() < math.abs(FIRE_WIND) then
                v123 = v118
            end
            local v124 = v122 + v123
            local v125 = Heat[math.clamp(v124, 1, Columns)]
            local v126 = Heat[v122][v121 + 1] - Rng:NextNumber(0, BinaryTransitionConfig.FIRE_DECAY_MAX)
            v125[v121] = math.max(0, v126)
        end
    end
end

local function advanceFire(v127, v128) -- line 411 | captures: BinaryTransitionConfig, fireStep
    if v127.Covered then
        v127.FireClock += v128
        while true do
            local FireClock = v127.FireClock
            if BinaryTransitionConfig.FIRE_STEP <= FireClock then
                v127.FireClock -= BinaryTransitionConfig.FIRE_STEP
                fireStep(v127)
                continue
            end
            break
        end
    end
end

local function cloneSound(v129, v130, v131, v132) -- line 426
    local v133 = v129 and v129:FindFirstChild(v130)
    if v133 and v133:IsA("Sound") then
        local v134 = v133:Clone()
        v134.Looped = false
        v134.PlayOnRemove = false
        v134.Volume = v131
        v134.Parent = v132
        return v134
    end
    return nil
end

local function buildSounds(v135, v136) -- line 439 | captures: SoundService, BinaryTransitionConfig
    local v137 = SoundService:FindFirstChild(BinaryTransitionConfig.SFX_FOLDER)
    v135.Ticks = {}
    local TICK_POOL = BinaryTransitionConfig.TICK_POOL
    for v138 = 1, TICK_POOL do
        local TICK_SOUND = BinaryTransitionConfig.TICK_SOUND
        local TICK_VOLUME = BinaryTransitionConfig.TICK_VOLUME
        local v139 = v137 and v137:FindFirstChild(TICK_SOUND)
        local v140
        if not (v139 and v139:IsA("Sound")) then
        else
            v140 = v139:Clone()
            v140.Looped = false
            v140.PlayOnRemove = false
            v140.Volume = TICK_VOLUME
            v140.Parent = v136
        end
        if not v140 then
            break
        end
        local Ticks = v135.Ticks
        table.insert(Ticks, v140)
    end
    local WHOOSH_SOUND = BinaryTransitionConfig.WHOOSH_SOUND
    local WHOOSH_VOLUME = BinaryTransitionConfig.WHOOSH_VOLUME
    local v141 = v137 and v137:FindFirstChild(WHOOSH_SOUND)
    local v142
    if not (v141 and v141:IsA("Sound")) then
    else
        v142 = v141:Clone()
        v142.Looped = false
        v142.PlayOnRemove = false
        v142.Volume = WHOOSH_VOLUME
        v142.Parent = v136
    end
    v135.Whoosh = v142
    if v135.Whoosh then
        v135.Whoosh.PlaybackSpeed = BinaryTransitionConfig.WHOOSH_PITCH
    end
    if BinaryTransitionConfig.IGNITE_SOUND_ID == "" then
        return
    end
    local Sound = Instance.new("Sound")
    Sound.Name = "Ignite"
    Sound.SoundId = BinaryTransitionConfig.IGNITE_SOUND_ID
    Sound.Volume = BinaryTransitionConfig.IGNITE_VOLUME
    Sound.PlaybackSpeed = BinaryTransitionConfig.IGNITE_PITCH
    if v135.Whoosh then
        Sound.SoundGroup = v135.Whoosh.SoundGroup
    else
        Sound.SoundGroup = nil
    end
    Sound.Parent = v136
    v135.Ignite = Sound
end

local function playTick(v143) -- line 469 | captures: BinaryTransitionConfig
    local Ticks = v143.Ticks
    if #Ticks == 0 or v143.Time - v143.LastTick < 1 / BinaryTransitionConfig.TICK_MAX_PER_SECOND then
        return
    end
    v143.LastTick = v143.Time
    v143.TickIndex = v143.TickIndex % #Ticks + 1
    local v144 = Ticks[v143.TickIndex]
    v144.PlaybackSpeed = v143.Rng:NextNumber(BinaryTransitionConfig.TICK_PITCH_MIN, BinaryTransitionConfig.TICK_PITCH_MAX)
    v144.TimePosition = 0
    v144:Play()
end

local function playOnce(v145) -- line 482
    if v145 then
        v145.TimePosition = 0
        v145:Play()
    end
end

local function paintDigit(v146, v147, v148) -- line 495 | captures: BinaryTransitionConfig
    v146.ShownWhite = v147
    v146.ShownChar = v148
    local Frame = v146.Frame
    if v147 > 0 then
        Frame.ZIndex = 2
    else
        Frame.ZIndex = 1
    end
    local Label = v146.Label
    if Label then
        local v149 = v146.Settled:Lerp(BinaryTransitionConfig.EDGE_TEXT_COLOR, v147)
        local v150 = v148 * (1 - v147)
        if v150 > 0 then
            v149 = v149:Lerp(BinaryTransitionConfig.FIRE_DIGIT_COLOR, v150)
        end
        Label.TextColor3 = v149
        local SETTLED_TEXT_TRANSPARENCY = BinaryTransitionConfig.SETTLED_TEXT_TRANSPARENCY
        local v151 = math.max(v147, v150)
        Label.TextTransparency = SETTLED_TEXT_TRANSPARENCY + (0 - SETTLED_TEXT_TRANSPARENCY) * v151
    end
    if v147 <= 0 then
        v146.Stroke.Enabled = false
    else
        v146.Stroke.Enabled = true
        v146.Stroke.Transparency = (BinaryTransitionConfig.EDGE_STROKE_TRANSPARENCY - 1) * v147 + 1
    end
end

local function flicker(v152, v153) -- line 523 | captures: BinaryTransitionConfig
    v152.FlickerClock += v153
    while true do
        local FlickerClock = v152.FlickerClock
        if BinaryTransitionConfig.FLICKER_INTERVAL <= FlickerClock then
            v152.FlickerClock -= BinaryTransitionConfig.FLICKER_INTERVAL
            local Tiles = v152.Tiles
            local Rng = v152.Rng
            local v154 = #Tiles * BinaryTransitionConfig.FLICKER_FRACTION + 0.5
            local v155 = math.floor(v154)
            local v156 = math.max(1, v155)
            for v157 = 1, v156 do
                local v158 = Tiles[Rng:NextInteger(1, #Tiles)]
                local Label = v158.Label
                if Label then
                    local Text = Label.Text
                    if Rng:NextNumber() < BinaryTransitionConfig.DEVIL_DIGIT_CHANCE then
                        Label.Text = BinaryTransitionConfig.DEVIL_DIGIT
                    elseif Text == "0" then
                        Label.Text = "1"
                    elseif Text == "1" or Rng:NextNumber() < 0.5 then
                        Label.Text = "0"
                    else
                        Label.Text = "1"
                    end
                end
                v158.FlashUntil = v152.Time + BinaryTransitionConfig.FLICKER_FLASH_TIME
            end
            continue
        end
        break
    end
end

local function render(v159) -- line 553 | captures: BinaryTransitionConfig, fireColor, playTick, paintDigit
    local Time = v159.Time
    local RevealStart = v159.RevealStart
    local Heat = v159.Heat
    local v160 = 0
    for v161, v162 in v159.Tiles do
        local v163, v164, v165, v166
        if RevealStart then
            if RevealStart + v162.RemoveOffset <= Time then
                local v167 = (Time - RevealStart - v162.RemoveOffset) / BinaryTransitionConfig.SHRINK_TIME
                if v167 < 1 then
                    local v168 = 1 - math.clamp(v167, 0, 1)
                    v165, v163, v164, v166 = true, v168 * v168, 1, BinaryTransitionConfig.EMBER_HEAT
                else
                    v165 = false
                    v163 = 0
                    v164 = 0
                    v166 = 0
                end
                if not v162.Leaving then
                    v162.Leaving = true
                    playTick(v159)
                end
            else
                if RevealStart + v162.WhiteOffset <= Time then
                    v165 = true
                    v163 = 1
                    v164 = 1
                elseif v162.Appear <= Time then
                    local v169 = (Time - v162.Appear) / BinaryTransitionConfig.POP_TIME
                    if v169 >= 1 then
                        v163 = 1
                    elseif v169 <= 0 then
                        v163 = 0
                    else
                        local POP_OVERSHOOT = BinaryTransitionConfig.POP_OVERSHOOT
                        local v170 = POP_OVERSHOOT + 1
                        local v171 = v169 - 1
                        v163 = 1 + v170 * v171 * v171 * v171 + POP_OVERSHOOT * v171 * v171
                    end
                    if Time < v162.CoolAt then
                        v164 = 1
                    else
                        local v172 = (Time - v162.CoolAt) / BinaryTransitionConfig.SETTLE_TIME
                        v164 = 1 - math.clamp(v172, 0, 1)
                    end
                    if Time < v162.FlashUntil then
                        v164 = 1
                    end
                    v165 = true
                else
                    v165 = false
                    v163 = 0
                    v164 = 0
                end
                v166 = 0
            end
        else
            if v162.Appear <= Time then
                local v173 = (Time - v162.Appear) / BinaryTransitionConfig.POP_TIME
                if v173 >= 1 then
                    v163 = 1
                elseif v173 <= 0 then
                    v163 = 0
                else
                    local POP_OVERSHOOT = BinaryTransitionConfig.POP_OVERSHOOT
                    local v174 = POP_OVERSHOOT + 1
                    local v175 = v173 - 1
                    v163 = 1 + v174 * v175 * v175 * v175 + POP_OVERSHOOT * v175 * v175
                end
                if Time < v162.CoolAt then
                    v164 = 1
                else
                    local v176 = (Time - v162.CoolAt) / BinaryTransitionConfig.SETTLE_TIME
                    v164 = 1 - math.clamp(v176, 0, 1)
                end
                if Time < v162.FlashUntil then
                    v164 = 1
                end
                v165 = true
            else
                v165 = false
                v163 = 0
                v164 = 0
            end
            v166 = 0
        end
        if v165 ~= v162.ShownVisible then
            v162.ShownVisible = v165
            v162.Frame.Visible = v165
            if v165 and not RevealStart then
                playTick(v159)
            end
        end
        if v165 then
            v160 += 1
            local v177 = v163 - v162.ShownScale
            if math.abs(v177) > 0.001 then
                v162.ShownScale = v163
                v162.Scale.Scale = v163
            end
            local v178 = Heat[v162.Column + 1][v162.Row + 1]
            local v179 = v178 * BinaryTransitionConfig.FIRE_DIGIT_CHAR
            local v180 = math.clamp(v179, 0, 1) * 40 + 0.5
            local v181 = math.floor(v180) / 40
            local v182 = v164 - v162.ShownWhite
            if math.abs(v182) > 0.001 or v181 ~= v162.ShownChar then
                paintDigit(v162, v164, v181)
            end
            local v183 = v164 * BinaryTransitionConfig.EDGE_GLOW_HEAT
            local v184 = math.max(v178, v183, v166)
            local v185 = math.clamp(v184, 0, 1) * 40 + 0.5
            local v186 = math.floor(v185) / 40
            if v186 ~= v162.ShownBackground then
                v162.ShownBackground = v186
                v162.Frame.BackgroundColor3 = fireColor(v186)
            end
        end
    end
    return v160
end

local v187

local function stopFovReturn() -- line 629 | captures: v187
    if v187 then
        v187:Disconnect()
        v187 = nil
    end
end

local function startFovReturn(v188) -- line 637 | captures: v187, RunService, TweenService, BinaryTransitionConfig, CameraFovController
    if v187 then
        v187:Disconnect()
        v187 = nil
    end
    local v189 = os.clock()
    v187 = RunService.RenderStepped:Connect(function() -- line 640 | captures: v188, v189, v187, TweenService, BinaryTransitionConfig, CameraFovController
        local v190 = (os.clock() - v189) / BinaryTransitionConfig.FOV_OUT_TIME
        if v190 >= 1 then
            if v187 then
                v187:Disconnect()
                v187 = nil
            end
            CameraFovController.Clear("BinaryTransition")
        else
            local v191 = TweenService:GetValue(v190, BinaryTransitionConfig.FOV_OUT_STYLE, Enum.EasingDirection.Out)
            CameraFovController.Set("BinaryTransition", v188 * (1 - v191))
        end
    end)
end

local function runOnCovered(v192) -- line 652
    if v192 then
        local v193, v194 = pcall(v192)
        if not v193 then
            warn((("[BinaryTransition] onCovered errored: %*"):format(v194)))
        end
    end
end

function v1.Play(v195, v196) -- line 665 | captures: v2, v187, Lighting, Players, RunService, TweenService, Workspace, BinaryTransitionConfig, CameraFovController, v1, v28, buildTile, layout, scheduleCover, scheduleReveal, advanceFire, buildSounds, flicker, render, runOnCovered
    local function v197(v198, ...)
        table.insert(v198, ...)
    end

    local function v199(v200, ...)
        table.insert(v200, ...)
    end

    local function v201(v202, ...)
        table.insert(v202, ...)
    end

    local function v203(v204, ...)
        table.insert(v204, ...)
    end

    local v205 = v196 or BinaryTransitionConfig.HOLD_TIME
    if v2 then
        if v195 then
            local v206, v207 = pcall(v195)
            if not v206 then
                warn((("[BinaryTransition] onCovered errored: %*"):format(v207)))
            end
        end
    else
        v2 = true
        local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
        local v208 = Random.new()
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "BinaryTransition"
        ScreenGui.IgnoreGuiInset = true
        ScreenGui.ScreenInsets = Enum.ScreenInsets.None
        ScreenGui.ResetOnSpawn = false
        ScreenGui.DisplayOrder = BinaryTransitionConfig.DISPLAY_ORDER
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.Parent = PlayerGui
        local CurrentCamera = Workspace.CurrentCamera
        local v209
        if CurrentCamera then
            v209 = CurrentCamera.ViewportSize
        else
            v209 = Vector2.new(1372, 758)
        end
        if ScreenGui then
            local AbsoluteSize = ScreenGui.AbsoluteSize
            local new = Vector2.new
            local X = v209.X
            local X_2 = AbsoluteSize.X
            local v210 = math.max(X, X_2)
            local Y = v209.Y
            local Y_2 = AbsoluteSize.Y
            v209 = new(v210, (math.max(Y, Y_2)))
        end
        local v211 = if v209.Y < BinaryTransitionConfig.SMALL_SCREEN_HEIGHT then BinaryTransitionConfig.SMALL_SCREEN_COLUMNS else BinaryTransitionConfig.COLUMNS
        local v212 = v209.X / v211
        local v213 = math.floor(v212)
        local v214 = math.max(1, v213)
        local v215 = v209.X / v214
        local v216 = math.ceil(v215) + v28 * 2
        local v217 = v209.Y / v214
        local v218 = math.ceil(v217) + 1
        local v219 = {
            Time = 0,
            Covered = false,
            CoveredAt = 0,
            Ready = false,
            RevealStart = nil,
            FlickerClock = 0,
            FireClock = 0,
            LastTick = (-1/0),
            TickIndex = 0,
            Whoosh = nil,
            Ignite = nil,
            Gui = ScreenGui,
            Rng = v208,
            Columns = v216,
            Rows = v218,
            Tiles = {},
            ByColumn = {},
            Heat = {},
            Ticks = {}
        }
        for v220 = 1, v216 do
            local v221 = {}
            local v222 = table.create(v218, 0)
            v219.ByColumn[v220] = v221
            v219.Heat[v220] = v222
            for v223 = 1, v218 do
                local v224 = buildTile(ScreenGui, v208, v220 - 1, v223 - 1)
                v221[v223] = v224
                local Tiles = v219.Tiles
                table.insert(Tiles, v224)
            end
        end
        scheduleCover(v219, v208)
        scheduleReveal(v219, v208)
        layout(v219)
        buildSounds(v219, ScreenGui)
        local CurrentCamera_2 = Workspace.CurrentCamera
        local BlurEffect
        if BinaryTransitionConfig.BLUR_MAX > 0 then
            local BlurEffect_2 = Instance.new("BlurEffect")
            BlurEffect = BlurEffect_2
            BlurEffect_2.Name = "BinaryTransitionBlur"
            BlurEffect_2.Size = 0
            BlurEffect_2.Parent = Lighting
        end
        if v187 then
            v187:Disconnect()
            v187 = nil
        end
        local v225
        if BinaryTransitionConfig.CAMERA_FOV_TARGET == nil then
            v225 = 0
        else
            local CAMERA_FOV_TARGET = BinaryTransitionConfig.CAMERA_FOV_TARGET
            v225 = math.max(CAMERA_FOV_TARGET, 1) - CameraFovController.GetOriginal()
        end
        local v226 = 0
        local v227 = false

        local function clearCinematics() -- line 761 | captures: BlurEffect, v227, CameraFovController
            if BlurEffect then
                BlurEffect:Destroy()
                BlurEffect = nil
            end
            if not v227 then
                CameraFovController.Clear("BinaryTransition")
            end
        end

        local v228 = v225

        local function stepCinematics(v229) -- line 772 | captures: BlurEffect, v226, v227, v219, v228, v187, RunService, TweenService, BinaryTransitionConfig, CameraFovController
            if BlurEffect then
                local v230
                if v219.RevealStart then
                    local v231 = (v229 - v219.RevealStart) / BinaryTransitionConfig.REVEAL_TIME
                    v230 = 1 - math.clamp(v231, 0, 1)
                else
                    local v232 = v229 / BinaryTransitionConfig.BLUR_IN_TIME
                    v230 = math.clamp(v232, 0, 1)
                end
                local BlurEffect_2 = BlurEffect
                local BLUR_MAX = BinaryTransitionConfig.BLUR_MAX
                local v233 = math.clamp(v230, 0, 1) * 3.141592653589793
                BlurEffect_2.Size = BLUR_MAX * (0.5 - math.cos(v233) * 0.5)
            end
            if not (v228 == 0 or v227) then
                if v219.RevealStart then
                    v227 = true
                    local v234 = v226
                    if v187 then
                        v187:Disconnect()
                        v187 = nil
                    end
                    local v235 = os.clock()
                    v187 = RunService.RenderStepped:Connect(function() -- line 640 | captures: v234, v235, v187, TweenService, BinaryTransitionConfig, CameraFovController
                        local v236 = (os.clock() - v235) / BinaryTransitionConfig.FOV_OUT_TIME
                        if v236 >= 1 then
                            if v187 then
                                v187:Disconnect()
                                v187 = nil
                            end
                            CameraFovController.Clear("BinaryTransition")
                        else
                            local v237 = TweenService:GetValue(v236, BinaryTransitionConfig.FOV_OUT_STYLE, Enum.EasingDirection.Out)
                            CameraFovController.Set("BinaryTransition", v234 * (1 - v237))
                        end
                    end)
                else
                    local v238 = v229 / BinaryTransitionConfig.FOV_IN_TIME
                    local v239 = math.clamp(v238, 0, 1)
                    v226 = v228 * TweenService:GetValue(v239, BinaryTransitionConfig.FOV_IN_STYLE, Enum.EasingDirection.In)
                    CameraFovController.Set("BinaryTransition", v226)
                end
            end
        end

        local v240 = coroutine.running()
        local v241 = {}
        local v242 = false

        local function finish() -- line 797 | captures: BlurEffect, v227, v242, ScreenGui, v240, v241, v2, CameraFovController, v1
            if v242 then
                return
            end
            v242 = true
            for v243, v244 in v241 do
                v244:Disconnect()
            end
            if BlurEffect then
                BlurEffect:Destroy()
                BlurEffect = nil
            end
            if not v227 then
                CameraFovController.Clear("BinaryTransition")
            end
            ScreenGui:Destroy()
            v2 = false
            v1.Finished:Fire()
            task.spawn(v240)
        end

        local function onCoveredReached() -- line 812 | captures: v195, v219, v1
            v219.Covered = true
            v219.CoveredAt = v219.Time
            local Ignite = v219.Ignite
            if Ignite then
                Ignite.TimePosition = 0
                Ignite:Play()
            end
            task.spawn(function() -- line 816 | captures: v195, v219, v1
                if v195 then
                    local v245, v246 = pcall(v195)
                    if not v245 then
                        warn((("[BinaryTransition] onCovered errored: %*"):format(v246)))
                    end
                end
                v219.Ready = true
                v1.SceneReady:Fire()
            end)
            v1.TransitionCovered:Fire()
        end

        local function step(v247) -- line 824 | captures: v195, v219, stepCinematics, finish, v205, BinaryTransitionConfig, v1, advanceFire, flicker, render
            v219.Time += v247
            local Time = v219.Time
            local v248
            if v219.Covered then
                v248 = true
            elseif BinaryTransitionConfig.COVER_TIME <= Time then
                v219.Covered = true
                v219.CoveredAt = v219.Time
                local Ignite = v219.Ignite
                if Ignite then
                    Ignite.TimePosition = 0
                    Ignite:Play()
                end
                v248 = false
            else
                v248 = true
            end
            if not v248 then
                task.spawn(function() -- line 816 | captures: v195, v219, v1
                    if v195 then
                        local v249, v250 = pcall(v195)
                        if not v249 then
                            warn((("[BinaryTransition] onCovered errored: %*"):format(v250)))
                        end
                    end
                    v219.Ready = true
                    v1.SceneReady:Fire()
                end)
                v1.TransitionCovered:Fire()
            end
            local v251, v252, v253
            if v219.Covered then
                if v219.RevealStart then
                    v253 = true
                else
                    v251 = Time - v219.CoveredAt
                    v252 = v219.Ready or BinaryTransitionConfig.SCENE_READY_TIMEOUT <= v251
                    v253 = false
                end
            else
                v253 = true
            end
            if not v253 then
                if not (v252 and v205 <= v251) then
                    flicker(v219, v247)
                else
                    v219.RevealStart = Time
                    local Whoosh = v219.Whoosh
                    if Whoosh then
                        Whoosh.TimePosition = 0
                        Whoosh:Play()
                    end
                end
            end
            advanceFire(v219, v247)
            stepCinematics(Time)
            local v254 = render(v219)
            if v219.RevealStart and v254 == 0 and v219.RevealStart + BinaryTransitionConfig.SHRINK_TIME <= Time then
                finish()
            end
        end

        local Event = v1.SceneReady.Event
        v197(v241, Event:Connect(function() -- line 854 | captures: v219
            if v219.Covered then
                v219.Ready = true
            end
        end))
        if CurrentCamera_2 then
            local ViewportSize = CurrentCamera_2:GetPropertyChangedSignal("ViewportSize")
            v199(v241, ViewportSize:Connect(function() -- line 864 | captures: v219, layout
                layout(v219)
            end))
        end
        local AbsoluteSize = ScreenGui:GetPropertyChangedSignal("AbsoluteSize")
        v201(v241, AbsoluteSize:Connect(function() -- line 871 | captures: v219, layout
            layout(v219)
        end))
        local RenderStepped = RunService.RenderStepped
        v203(v241, RenderStepped:Connect(function(v255) -- line 878 | captures: v195, v219, finish, step, runOnCovered
            local v256, v257 = pcall(step, v255)
            if v256 then
                return
            end
            warn((("[BinaryTransition] %*"):format(v257)))
            if not v219.Covered then
                task.spawn(runOnCovered, v195)
            end
            finish()
        end))
        local Whoosh = v219.Whoosh
        if Whoosh then
            Whoosh.TimePosition = 0
            Whoosh:Play()
        end
        coroutine.yield()
    end
end

return v1
