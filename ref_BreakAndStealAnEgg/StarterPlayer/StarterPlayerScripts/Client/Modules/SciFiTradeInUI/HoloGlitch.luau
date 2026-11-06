-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local UserInputService = game:GetService("UserInputService")
local v1 = {}

v1.__index = v1

local exp = math.exp
local cos = math.cos
local sin = math.sin
local sqrt = math.sqrt
local floor = math.floor
local abs = math.abs
local v2 = {
    Color3.fromRGB(8, 22, 70),
    Color3.fromRGB(18, 82, 210),
    Color3.fromRGB(36, 200, 255),
    Color3.fromRGB(190, 245, 255)
}

local function sibling(v3) -- line 92
    local v4 = script.Parent and script.Parent:FindFirstChild(v3)
    if v4 and v4:IsA("ModuleScript") then
        local v5, v6 = pcall(require, v4)
        return v5 and v6 or nil
    end
    return nil
end

local function isLow() -- line 101 | captures: UserInputService
    local v7 = script.Parent and script.Parent:FindFirstChild("Budget")
    local v8
    if not (v7 and v7:IsA("ModuleScript")) then
    else
        local v9
        v9, v8 = pcall(require, v7)
        if not v9 or not v8 then
            v8 = nil
        end
    end
    if v8 and v8.isLow then
        return v8.isLow()
    end
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

local function merge(v10, v11) -- line 109
    local v12 = table.clone(v10)
    if v11 then
        for v13, v14 in pairs(v11) do
            v12[v13] = v14
        end
    end
    return v12
end

local function ramp(v15, v16) -- line 119 | captures: floor
    local v17 = #v15
    if v17 == 1 then
        return v15[1]
    end
    local v18 = math.clamp(v16, 0, 1) * (v17 - 1)
    local v19 = floor(v18)
    local v20 = v17 - 2
    local v21 = math.min(v19, v20)
    return v15[v21 + 1]:Lerp(v15[v21 + 2], v18 - v21)
end

local function pop(v22, v23, v24) -- line 130 | captures: exp, cos, sin, sqrt
    local v25 = 1 - v24 * v24
    local v26 = v23 * sqrt(v25)
    local v27 = -v24 * v23 * v22
    local v28 = exp(v27)
    local v29 = v26 * v22
    local v30 = cos(v29)
    local v31 = 1 - v24 * v24
    local v32 = v24 / sqrt(v31)
    local v33 = v26 * v22
    return 1 - v28 * (v30 + v32 * sin(v33))
end

function v1.new(v34) -- line 135 | captures: v1, floor, v2
    local v35 = v34 and v34.host
    assert(v35, "HoloGlitch.new: host is required")
    local v36 = {}
    local v37 = setmetatable(v36, v1)
    v37.host = v34.host
    v37.count = v34.count or 16
    local countLow = v34.countLow
    if not countLow then
        local v38 = v37.count / 2
        local v39 = floor(v38)
        countLow = math.max(1, v39)
    end
    v37.countLow = countLow
    v37.scanlines = v34.scanlines or 4
    local scanlinesLow = v34.scanlinesLow
    if not scanlinesLow then
        local v40 = v37.scanlines / 2
        local v41 = floor(v40)
        scanlinesLow = math.max(1, v41)
    end
    v37.scanlinesLow = scanlinesLow
    v37.area = v34.area or { -0.06, -0.06, 1.06, 1.06 }
    v37.sizeRange = v34.size or { 0.04, 0.17 }
    v37.palette = v34.palette or v2
    v37.bright = v34.bright or 0.25
    v37.alpha = v34.alpha or { 0.3, 0.7 }
    v37.alphaBright = v34.alphaBright or { 0.08, 0.25 }
    v37.z = v34.z or 40
    local v42 = {
        spread = 0.32,
        popF = 6,
        popD = 0.45,
        share = 1,
        hold = { 0.1, 0.26 }
    }
    local open = v34.open
    local v43 = table.clone(v42)
    if open then
        for v44, v45 in pairs(open) do
            v43[v44] = v45
        end
    end
    v37.openCfg = v43
    local v46 = {
        spread = 0.1,
        popF = 11,
        popD = 0.7,
        share = 0.6,
        hold = { 0.03, 0.1 }
    }
    local close = v34.close
    local v47 = table.clone(v46)
    if close then
        for v48, v49 in pairs(close) do
            v47[v48] = v49
        end
    end
    v37.closeCfg = v47
    v37.collapseW = (v34.collapseF or 7) * 6.283185307179586
    v37.flickerHz = v34.flickerHz or 30
    v37.flicker = v34.flicker or 0.22
    v37.jitter = v34.jitter or 0.008
    v37.panelJitter = v34.panelJitter or 0.004
    v37.writeHost = v34.writeHost == true
    v37.manual = v34.manual == true
    v37.forceLow = v34.low
    v37.rng = v34.rng or Random.new()
    v37.live = 0
    v37.size = 0
    v37.built = false
    v37.jx = 0
    v37.jy = 0
    v37.jUntil = -1
    v37.jTick = -1
    v37.clock = 0
    v37.step_ = nil
    v37.container = nil
    v37.homePos = nil
    local v50 = {}
    local v51 = {}
    local v52 = {}
    local v53 = {}
    local v54 = {}
    local v55 = {}
    v37.I = {}
    v37.Kind = v50
    v37.On = v51
    v37.Shown = v52
    v37.T = v53
    v37.Life = v54
    v37.Hold = v55
    local v56 = {}
    local v57 = {}
    local v58 = {}
    local v59 = {}
    local v60 = {}
    local v61 = {}
    v37.W = {}
    v37.H = v56
    v37.X = v57
    v37.Y = v58
    v37.VY = v59
    v37.Base = v60
    v37.Tick = v61
    local v62 = {}
    local v63 = {}
    local v64 = {}
    local v65 = {}
    v37.PopW = {}
    v37.PopD = v62
    v37.WS = v63
    v37.WH = v64
    v37.Off = v65
    return v37
end

function v1._low(v66) -- line 178 | captures: isLow
    if v66.forceLow == nil then
        return isLow()
    end
    return v66.forceLow
end

local function prebuild(v67) -- line 185
    if v67.built then
        return
    end
    v67.built = true
    local countLow, scanlinesLow
    if v67:_low() then
        countLow = v67.countLow or v67.count
        scanlinesLow = v67.scanlinesLow or v67.scanlines
    else
        countLow = v67.count
        scanlinesLow = v67.scanlines
    end
    local Frame = Instance.new("Frame")
    Frame.Name = "HoloGlitch"
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.ZIndex = v67.z
    Frame.Visible = false
    Frame.Active = false
    local v68 = countLow + scanlinesLow
    for v69 = 1, v68 do
        local Frame_2 = Instance.new("Frame")
        Frame_2.Name = "Rect"
        Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame_2.BorderSizePixel = 0
        Frame_2.BackgroundTransparency = 1
        Frame_2.ZIndex = v67.z
        Frame_2.Visible = false
        Frame_2.Active = false
        Frame_2.Size = UDim2.fromScale(0, 0)
        Frame_2.Parent = Frame
        v67.I[v69] = Frame_2
        local Kind = v67.Kind
        if countLow < v69 then
            Kind[v69] = 4
        else
            Kind[v69] = 1
        end
        local On = v67.On
        local Shown = v67.Shown
        local T = v67.T
        local Life = v67.Life
        local Hold = v67.Hold
        On[v69] = false
        Shown[v69] = false
        T[v69] = 0
        Life[v69] = 0
        Hold[v69] = 0
        local W = v67.W
        local H = v67.H
        local X = v67.X
        local Y = v67.Y
        local VY = v67.VY
        local Base = v67.Base
        local Tick = v67.Tick
        W[v69] = 0
        H[v69] = 0
        X[v69] = 0
        Y[v69] = 0
        VY[v69] = 0
        Base[v69] = 0
        Tick[v69] = -1
        local PopW = v67.PopW
        local PopD = v67.PopD
        local WS = v67.WS
        local WH = v67.WH
        local Off = v67.Off
        PopW[v69] = 0
        PopD[v69] = 0.5
        WS[v69] = -1
        WH[v69] = -1
        Off[v69] = false
    end
    v67.size = countLow + scanlinesLow
    v67.nRect = countLow
    local UIAspectRatioConstraint = v67.host:FindFirstChildOfClass("UIAspectRatioConstraint")
    if UIAspectRatioConstraint then
        v67.invAspect = 1 / UIAspectRatioConstraint.AspectRatio
    else
        local AbsoluteSize = v67.host.AbsoluteSize
        v67.invAspect = AbsoluteSize.X > 0 and AbsoluteSize.Y > 0 and AbsoluteSize.Y / AbsoluteSize.X or 1
    end
    Frame.Parent = v67.host
    v67.container = Frame
end

v1.prebuild = prebuild

function v1._arm(v70, v71, v72, v73) -- line 231 | captures: floor
    local rng = v70.rng
    local v74 = v70.Kind[v71]
    local v75
    if v74 == 4 then
        v75 = v74
    else
        local v76 = rng:NextNumber()
        local v77
        if v76 < 0.4 then
            v77 = 1
        elseif v76 < 0.7 then
            v77 = 2
        else
            v77 = 3
        end
        v70.Kind[v71] = v77
        v75 = v77
    end
    local v78 = rng:NextNumber(v70.sizeRange[1], v70.sizeRange[2])
    local v79
    if v75 == 1 then
        v79 = v78 * rng:NextNumber(0.55, 0.85)
        v78 = v79
    elseif v75 == 2 then
        v79 = v78 * rng:NextNumber(0.18, 0.35)
    elseif v75 == 3 then
        v79, v78 = v78 * rng:NextNumber(1.2, 2.2), v78 * rng:NextNumber(0.12, 0.3)
    else
        v79, v78 = rng:NextNumber(1.05, 1.3) / v70.invAspect, rng:NextNumber(0.004, 0.012)
    end
    local area = v70.area
    local W = v70.W
    local H = v70.H
    W[v71] = v79
    H[v71] = v78
    if v75 == 4 then
        v70.X[v71] = 0.5 + rng:NextNumber(-0.03, 0.03)
        v70.Y[v71] = rng:NextNumber(area[2], area[4])
        local VY = v70.VY
        local v80 = rng:NextNumber(0.25, 0.7)
        local v81 = if rng:NextNumber() < 0.5 then -1 else 1
        VY[v71] = v80 * v81
    else
        v70.X[v71] = rng:NextNumber(area[1], area[3])
        v70.Y[v71] = rng:NextNumber(area[2], area[4])
        v70.VY[v71] = 0
    end
    local v82 = if v75 == 4 then false else rng:NextNumber() < v70.bright
    local v83 = v82 and rng:NextNumber(0.72, 1) or rng:NextNumber(0, 0.85)
    local v84 = v70.I[v71]
    local palette = v70.palette
    local v85 = #palette
    if v85 == 1 then
        v84.BackgroundColor3 = palette[1]
    else
        local v86 = math.clamp(v83, 0, 1) * (v85 - 1)
        local v87 = floor(v86)
        local v88 = v85 - 2
        local v89 = math.min(v87, v88)
        v84.BackgroundColor3 = palette[v89 + 1]:Lerp(palette[v89 + 2], v86 - v89)
    end
    local alphaBright = v82 and v70.alphaBright or v70.alpha
    v70.Base[v71] = rng:NextNumber(alphaBright[1], alphaBright[2])
    v70.PopW[v71] = v72.popF * 6.283185307179586 * rng:NextNumber(0.85, 1.2)
    v70.PopD[v71] = v72.popD
    local v90 = rng:NextNumber(v72.hold[1], v72.hold[2])
    v70.Hold[v71] = v90
    v70.Life[v71] = v90 + 7.4 / v70.collapseW
    v70.T[v71] = -(v73 + rng:NextNumber(0, v72.spread))
    v70.Tick[v71] = -1
    local WS = v70.WS
    local WH = v70.WH
    WS[v71] = -1
    WH[v71] = -1
    v70.Off[v71] = false
    if not v70.On[v71] then
        v70.live += 1
    end
    v70.On[v71] = true
end

function v1.play(v91, v92, v93) -- line 287 | captures: floor
    v91:prebuild()
    if v91.size == 0 then
        return
    end
    local v94 = v93 or 0
    local closeCfg = v92 == "close" and v91.closeCfg or v91.openCfg
    local nRect = v91.nRect
    local v95 = nRect * (closeCfg.share or 1) + 0.5
    local v96 = floor(v95)
    local v97 = math.max(1, v96)
    for v98 = 1, nRect do
        if v98 <= v97 then
            v91:_arm(v98, closeCfg, v94)
        end
    end
    local v99 = nRect + 1
    local size = v91.size
    for v100 = v99, size do
        v91:_arm(v100, closeCfg, v94)
    end
    v91.jUntil = v91.clock + v94 + closeCfg.spread + closeCfg.hold[2]
    v91.jStart = v91.clock + v94
    v91.container.Visible = true
    if v91.manual or v91.step_ then
        return
    end
    local v101 = script.Parent and script.Parent:FindFirstChild("Ticker")
    local v102
    if not (v101 and v101:IsA("ModuleScript")) then
    else
        local v103
        v103, v102 = pcall(require, v101)
        if not v103 or not v102 then
            v102 = nil
        end
    end
    if v102 then
        local whileVisible = v102.whileVisible
        local host = v91.host

        local function v104(v105) -- line 311 | captures: v91
            v91:step(v105)
        end

        v91.step_ = whileVisible(host, v104, nil, function() -- line 313 | captures: v91
            v91:hideAll()
        end)
    end
end

local function _hide(v106, v107) -- line 320
    v106.On[v107] = false
    if v106.Shown[v107] then
        v106.Shown[v107] = false
        v106.I[v107].Visible = false
    end
end

v1._hide = _hide

function v1.step(v108, v109) -- line 329 | captures: exp, cos, sin, sqrt, floor, abs
    if v108.live == 0 then
        return false
    end
    local v110 = if v109 > 0.05 then 0.05 else v109
    local v111 = v108.clock + v110
    v108.clock = v111
    local rng = v108.rng
    local flickerHz = v108.flickerHz
    local invAspect = v108.invAspect
    local collapseW = v108.collapseW
    local v112 = v108.live
    local I = v108.I
    local On = v108.On
    local Shown = v108.Shown
    local T = v108.T
    local Life = v108.Life
    local Hold = v108.Hold
    local size = v108.size
    for v113 = 1, size do
        if On[v113] then
            local v114 = T[v113] + v110
            T[v113] = v114
            if v114 >= 0 then
                local v115 = I[v113]
                if Life[v113] <= v114 then
                    v108:_hide(v113)
                    v112 -= 1
                else
                    local v116 = v108.PopW[v113]
                    local v117 = v108.PopD[v113]
                    local v118 = 1 - v117 * v117
                    local v119 = v116 * sqrt(v118)
                    local v120 = -v117 * v116 * v114
                    local v121 = exp(v120)
                    local v122 = v119 * v114
                    local v123 = cos(v122)
                    local v124 = 1 - v117 * v117
                    local v125 = v117 / sqrt(v124)
                    local v126 = v119 * v114
                    local v127 = 1 - v121 * (v123 + v125 * sin(v126))
                    if v127 < 0 then
                        v127 = 0
                    end
                    local v128 = v114 - Hold[v113]
                    local v129, v130
                    if v128 > 0 then
                        local v131 = collapseW * v128
                        local v132 = -v131 * 1.6
                        local v133 = exp(v132) * (1 + v131 * 1.6)
                        local v134 = -v131 * 0.7
                        v129, v130 = v127 * (exp(v134) * (1 + v131 * 0.7)), v127 * v133
                    else
                        v129 = v127
                        v130 = v127
                    end
                    local v135 = v108.Kind[v113]
                    local v136 = v114 * flickerHz
                    local v137 = floor(v136)
                    local v138 = v137 ~= v108.Tick[v113]
                    if v138 then
                        v108.Tick[v113] = v137
                        local v139 = rng:NextNumber() < v108.flicker
                        if v139 == v108.Off[v113] and Shown[v113] then
                            if not v139 then
                                v115.BackgroundTransparency = v108.Base[v113] + rng:NextNumber(-0.08, 0.08)
                            end
                        else
                            v108.Off[v113] = v139
                            if v139 then
                                v115.BackgroundTransparency = 1
                            else
                                v115.BackgroundTransparency = v108.Base[v113] + rng:NextNumber(-0.08, 0.08)
                            end
                        end
                    end
                    if not Shown[v113] then
                        Shown[v113] = true
                        v115.Visible = true
                    end
                    local v140 = v108.X[v113]
                    local v141 = v108.Y[v113]
                    if v135 == 4 then
                        local v142 = v141 + v108.VY[v113] * v114
                        local v143 = v138 and rng:NextNumber(-1, 1) * v108.jitter * invAspect or 0
                        v115.Position = UDim2.fromScale(v140 + v143, v142)
                    elseif v138 then
                        local jitter = v108.jitter
                        v115.Position = UDim2.fromScale(v140 + rng:NextNumber(-jitter, jitter) * invAspect, v141 + rng:NextNumber(-jitter, jitter))
                    end
                    local v144 = v108.W[v113] * invAspect * v129
                    local v145 = v108.H[v113] * v130
                    local v146 = v144 - v108.WS[v113]
                    local v147 = abs(v146) > 0.0005
                    local v148
                    if not v147 then
                        local v149 = v145 - v108.WH[v113]
                        v148 = abs(v149) > 0.0005
                    end
                    if v147 or v148 then
                        local WS = v108.WS
                        local WH = v108.WH
                        WS[v113] = v144
                        WH[v113] = v145
                        v115.Size = UDim2.fromScale(v144, v145)
                    end
                end
            end
        end
    end
    v108.live = v112
    if not (v108.jStart <= v111 and v111 < v108.jUntil) then
        if not (v108.jx == 0 and v108.jy == 0) then
            v108.jx = 0
            v108.jy = 0
            v108:_writeHost()
        end
    else
        local v150 = v111 * flickerHz * 0.5
        local v151 = floor(v150)
        if v151 ~= v108.jTick then
            v108.jTick = v151
            local panelJitter = v108.panelJitter
            local v152 = rng:NextNumber(-panelJitter, panelJitter)
            local v153 = rng:NextNumber(-panelJitter, panelJitter) * 0.5
            v108.jx = v152
            v108.jy = v153
            v108:_writeHost()
        end
    end
    if v112 == 0 then
        v108:_sleep()
    end
    return v112 > 0
end

local function _writeHost(v154) -- line 423
    if not v154.writeHost then
        return
    end
    local host = v154.host
    if not v154.homePos then
        v154.homePos = host.Position
    end
    local homePos = v154.homePos
    local Parent = host.Parent
    local v155, v156
    if Parent and Parent:IsA("GuiBase2d") then
        local AbsoluteSize = Parent.AbsoluteSize
        if AbsoluteSize then
            v155 = AbsoluteSize
            v156 = true
        else
            v156 = false
        end
    else
        v156 = false
    end
    if not v156 then
        v155 = Vector2.one
    end
    local Y = host.AbsoluteSize.Y
    local new = UDim2.new
    local Scale = homePos.X.Scale
    local v157 = v154.jx * Y
    local X = v155.X
    local v158 = Scale + v157 / math.max(X, 1)
    local Offset = homePos.X.Offset
    local Scale_2 = homePos.Y.Scale
    local v159 = v154.jy * Y
    local Y_2 = v155.Y
    host.Position = new(v158, Offset, Scale_2 + v159 / math.max(Y_2, 1), homePos.Y.Offset)
    if v154.jx == 0 and v154.jy == 0 then
        host.Position = homePos
        v154.homePos = nil
    end
end

v1._writeHost = _writeHost

local function _sleep(v160) -- line 442
    if v160.step_ then
        v160.step_:Stop()
        v160.step_ = nil
    end
    if v160.container then
        v160.container.Visible = false
    end
    if not (v160.jx == 0 and v160.jy == 0) then
        v160.jx = 0
        v160.jy = 0
        v160:_writeHost()
    end
    v160.jUntil = -1
end

v1._sleep = _sleep

local function offset(v161) -- line 458
    return v161.jx, v161.jy
end

v1.offset = offset

local function isLive(v162) -- line 462
    return v162.live > 0
end

v1.isLive = isLive

local function hideAll(v163) -- line 467
    local size = v163.size
    for v164 = 1, size do
        if v163.On[v164] or v163.Shown[v164] then
            v163:_hide(v164)
        end
    end
    v163.live = 0
    v163:_sleep()
end

v1.hideAll = hideAll

local function destroy(v165) -- line 477
    v165:hideAll()
    if v165.container then
        v165.container:Destroy()
        v165.container = nil
    end
    table.clear(v165.I)
    v165.size = 0
    v165.built = false
end

v1.destroy = destroy
return v1
