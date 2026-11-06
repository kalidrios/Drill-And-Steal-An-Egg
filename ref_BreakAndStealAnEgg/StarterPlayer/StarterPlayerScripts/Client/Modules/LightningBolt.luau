-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local v1 = {}
local v2 = {
    Width = 0.7,
    GlowWidth = 2.2,
    OuterWidth = nil,
    GlowTransparency = 0.45,
    OuterTransparency = 0.86,
    Taper = 0.55,
    Thickness = 0.4,
    Depth = 4,
    Jag = 0.11,
    Branches = 2,
    BranchLength = 0.28,
    Interval = 0.06,
    Leader = 0.07,
    Life = 0.55,
    FadeTime = 0.25,
    LightBrightness = 0,
    LightRange = 60,
    Color = Color3.fromRGB(255, 255, 255),
    GlowColor = Color3.fromRGB(255, 225, 160),
    OuterColor = Color3.fromRGB(255, 130, 35),
    LightColor = Color3.fromRGB(255, 210, 150)
}
local v3 = {
    { 0, 1 },
    { 0.045, 0.22 },
    { 0.075, 1 },
    { 0.13, 0.4 },
    { 0.165, 0.85 },
    { 0.23, 0.55 }
}
local v4 = Random.new()

local function option(v5, v6) -- line 97 | captures: v2
    local v7 = v5 and v5[v6]
    if v7 == nil then
        return v2[v6]
    end
    return v7
end

local function outerWidth(v8) -- line 105 | captures: v2
    local v9 = v8 and v8.OuterWidth
    if v9 == nil then
        v9 = v2.OuterWidth
    end
    if v9 then
        return v9
    end
    local v10 = v8 and v8.GlowWidth
    if v10 == nil then
        v10 = v2.GlowWidth
    end
    return v10 * 2.4
end

local function resolve(v11) -- line 109
    if type(v11) == "function" then
        return v11()
    end
    return v11
end

local function perpendicular(v12) -- line 116 | captures: v4
    local function v13(v14, v15, ...)
        return (Vector3.new(v14, v15, ...))
    end

    local Unit = v12.Unit
    local v16 = v13(v4:NextNumber(-1, 1), v4:NextNumber(-1, 1), v4:NextNumber(-1, 1))
    local v17 = v16 - Unit * v16:Dot(Unit)
    local v18
    if v17.Magnitude < 0.001 then
        local Y = Unit.Y
        local v19
        if math.abs(Y) < 0.9 then
            v19 = Vector3.new(0, 1, 0)
        else
            v19 = Vector3.new(1, 0, 0)
        end
        v18 = Unit:Cross(v19)
    else
        v18 = v17
    end
    return v18.Unit
end

local function jagged(v20, v21, v22, v23) -- line 127 | captures: v4, perpendicular
    local v24, v25 = { v20, v21 }, (v21 - v20).Magnitude * v23
    for v26 = 1, v22 do
        local v27 = { v24[1] }
        local v28 = #v24 - 1
        for v29 = 1, v28 do
            local v30 = v24[v29]
            local v31 = v24[v29 + 1]
            local v32 = v31 - v30
            local v33 = (v30 + v31) / 2
            if v32.Magnitude > 0.001 then
                v33 += perpendicular(v32) * (v4:NextNumber(-1, 1) * v25)
            end
            table.insert(v27, v33)
            table.insert(v27, v31)
        end
        v24, v25 = v27, v25 * 0.55
    end
    return v24
end

local function newHolder(v34) -- line 150
    local Part = Instance.new("Part")
    Part.Name = "Holder"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.10000000149011612, 0.10000000149011612, 0.10000000149011612)
    Part.CFrame = CFrame.identity
    Part.Parent = v34
    return Part
end

local v35 = { Brightness = 3 }

function v35.Width(v36) -- line 173 | captures: v2
    local v37 = v36 and v36.Width
    if v37 == nil then
        return v2.Width
    end
    return v37
end

function v35.Color(v38) -- line 176 | captures: v2
    local v39 = v38 and v38.Color
    if v39 == nil then
        return v2.Color
    end
    return v39
end

function v35.Transparency() -- line 179
    return 0
end

local v40 = { Brightness = 1.2 }

function v40.Width(v41) -- line 185 | captures: v2
    local v42 = v41 and v41.GlowWidth
    if v42 == nil then
        return v2.GlowWidth
    end
    return v42
end

function v40.Color(v43) -- line 188 | captures: v2
    local v44 = v43 and v43.GlowColor
    if v44 == nil then
        return v2.GlowColor
    end
    return v44
end

function v40.Transparency(v45) -- line 191 | captures: v2
    local v46 = v45 and v45.GlowTransparency
    if v46 == nil then
        return v2.GlowTransparency
    end
    return v46
end

local v47 = { Brightness = 0.7 }

function v47.Width(v48) -- line 197 | captures: v2
    local v49 = v48 and v48.GlowWidth
    if v49 == nil then
        v49 = v2.GlowWidth
    end
    local v50 = v48 and v48.OuterWidth
    if v50 == nil then
        v50 = v2.OuterWidth
    end
    local v51
    if v50 then
        v51 = v50
    else
        local v52 = v48 and v48.GlowWidth
        if v52 == nil then
            v52 = v2.GlowWidth
        end
        v51 = v52 * 2.4
    end
    return (v49 + v51) / 2
end

function v47.Color(v53) -- line 200 | captures: v2
    local v54 = v53 and v53.GlowColor
    if v54 == nil then
        v54 = v2.GlowColor
    end
    local v55 = v53 and v53.OuterColor
    if v55 == nil then
        v55 = v2.OuterColor
    end
    return v54:Lerp(v55, 0.5)
end

function v47.Transparency(v56) -- line 203 | captures: v2
    local v57 = v56 and v56.GlowTransparency
    if v57 == nil then
        v57 = v2.GlowTransparency
    end
    local v58 = v56 and v56.OuterTransparency
    if v58 == nil then
        v58 = v2.OuterTransparency
    end
    return (v57 + v58) / 2
end

local v59 = { Brightness = 0.5 }

function v59.Width(v60) -- line 209 | captures: v2
    local v61 = v60 and v60.OuterWidth
    if v61 == nil then
        v61 = v2.OuterWidth
    end
    if v61 then
        return v61
    end
    local v62 = v60 and v60.GlowWidth
    if v62 == nil then
        v62 = v2.GlowWidth
    end
    return v62 * 2.4
end

function v59.Color(v63) -- line 212 | captures: v2
    local v64 = v63 and v63.OuterColor
    if v64 == nil then
        return v2.OuterColor
    end
    return v64
end

function v59.Transparency(v65) -- line 215 | captures: v2
    local v66 = v65 and v65.OuterTransparency
    if v66 == nil then
        return v2.OuterTransparency
    end
    return v66
end

local v67 = { v35, v40, v47, v59 }

local function newBeam(v68, v69, v70, v71, v72) -- line 228
    local Beam = Instance.new("Beam")
    Beam.Attachment0 = v68
    Beam.Attachment1 = v69
    Beam.FaceCamera = true
    Beam.Segments = 1
    Beam.LightEmission = 1
    Beam.LightInfluence = 0
    Beam.Brightness = v71
    Beam.Color = ColorSequence.new(v70)
    Beam.Width0 = 0
    Beam.Width1 = 0
    Beam.Parent = v72
    return Beam
end

local function newLine(v73, v74, v75, v76) -- line 244 | captures: v67
    local v77 = {
        Attachments = {},
        Layers = {}
    }
    local v78 = v73 + 1
    for v79 = 1, v78 do
        local Attachment = Instance.new("Attachment")
        Attachment.Parent = v75
        v77.Attachments[v79] = Attachment
    end
    for v80 = 1, v76 do
        local v81 = v67[v80]
        local v82 = {}
        for v83 = 1, v73 do
            local v84 = v77.Attachments[v83]
            local v85 = v77.Attachments[v83 + 1]
            local v86 = v81.Color(v74)
            local Brightness = v81.Brightness
            local Beam = Instance.new("Beam")
            Beam.Attachment0 = v84
            Beam.Attachment1 = v85
            Beam.FaceCamera = true
            Beam.Segments = 1
            Beam.LightEmission = 1
            Beam.LightInfluence = 0
            Beam.Brightness = Brightness
            Beam.Color = ColorSequence.new(v86)
            Beam.Width0 = 0
            Beam.Width1 = 0
            Beam.Parent = v75
            v82[v83] = Beam
        end
        local Layers = v77.Layers
        local v87 = {
            Spec = v81,
            Beams = v82
        }
        table.insert(Layers, v87)
    end
    return v77
end

local function thicknessWalk(v88, v89) -- line 263 | captures: v2, v4
    local v90 = v89 and v89.Thickness
    if v90 == nil then
        v90 = v2.Thickness
    end
    local v91 = {}
    local v92 = v4:NextNumber(v90, 1)
    for v93 = 1, v88 do
        local v94 = v92 + v4:NextNumber(-0.35, 0.35) * (1 - v90)
        v92 = math.clamp(v94, v90, 1)
        v91[v93] = v92
    end
    return v91
end

local function layLine(v95, v96, v97, v98, v99, v100, v101) -- line 277
    local Attachments = v95.Attachments
    local v102 = #Attachments - 1
    local v103
    if v100 then
        local v104 = v102 * v100 + 0.5
        v103 = math.floor(v104)
    else
        v103 = v102
    end
    for v105, v106 in Attachments do
        v106.Position = v96[v105] or v96[#v96]
    end
    for v107, v108 in v95.Layers do
        local v109 = v108.Spec.Width(v98) * v97
        for v110, v111 in v108.Beams do
            local v112 = 1 - (1 - v99) * ((v110 - 1) / v102)
            local v113 = 1 - (1 - v99) * (v110 / v102)
            if v101 then
                v112, v113 = v112 * (v101[v110] or 1), v113 * (v101[v110 + 1] or 1)
            end
            v111.Enabled = v110 <= v103
            v111.Width0 = v109 * v112
            v111.Width1 = v109 * v113
        end
    end
end

local function setLineAlpha(v114, v115, v116) -- line 300
    local v117 = 1 - math.clamp(v116, 0, 1)
    for v118, v119 in v114.Layers do
        local v120 = v119.Spec.Transparency(v115)
        local v121 = NumberSequence.new(v120 + (1 - v120) * v117)
        for v122, v123 in v119.Beams do
            v123.Transparency = v121
        end
    end
end

local function newBolt(v124, v125) -- line 324 | captures: Workspace, v2, v67, newLine
    local Folder = Instance.new("Folder")
    Folder.Name = "Lightning"
    Folder.Parent = v125 or Workspace
    local Part = Instance.new("Part")
    Part.Name = "Holder"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.10000000149011612, 0.10000000149011612, 0.10000000149011612)
    Part.CFrame = CFrame.identity
    Part.Parent = Folder
    local v126 = v124 and v124.Depth
    if v126 == nil then
        v126 = v2.Depth
    end
    local v127 = {
        Light = nil,
        LightAttachment = nil,
        WidthScale = 1,
        Folder = Folder,
        Style = v124,
        Holder = Part,
        Main = newLine(2 ^ v126, v124, Part, #v67),
        Forks = {},
        Points = {},
        Thickness = {}
    }
    local v128 = v124 and v124.Branches
    if v128 == nil then
        v128 = v2.Branches
    end
    for v129 = 1, v128 do
        local Forks = v127.Forks
        local v130 = v126 - 2
        Forks[v129] = newLine(2 ^ math.max(v130, 1), v124, Part, 2)
    end
    local v131 = v124 and v124.LightBrightness
    if v131 == nil then
        v131 = v2.LightBrightness
    end
    if v131 > 0 then
        local Attachment = Instance.new("Attachment")
        Attachment.Parent = Part
        local PointLight = Instance.new("PointLight")
        PointLight.Brightness = v131
        local v132 = v124 and v124.LightRange
        if v132 == nil then
            v132 = v2.LightRange
        end
        PointLight.Range = v132
        local v133 = v124 and v124.LightColor
        if v133 == nil then
            v133 = v2.LightColor
        end
        PointLight.Color = v133
        PointLight.Shadows = false
        PointLight.Parent = Attachment
        v127.Light = PointLight
        v127.LightAttachment = Attachment
    end
    return v127
end

local function newChannel(v134, v135, v136) -- line 362 | captures: v2, jagged, thicknessWalk
    local Style = v134.Style
    local v137 = Style and Style.Depth
    if v137 == nil then
        v137 = v2.Depth
    end
    local Style_2 = v134.Style
    local v138 = Style_2 and Style_2.Jag
    if v138 == nil then
        v138 = v2.Jag
    end
    v134.Points = jagged(v135, v136, v137, v138)
    v134.Thickness = thicknessWalk(#v134.Points, v134.Style)
    if v134.LightAttachment then
        v134.LightAttachment.Position = v136
    end
end

local function newForks(v139) -- line 371 | captures: v2, v4, perpendicular, jagged, thicknessWalk, layLine
    local Style = v139.Style
    local Points = v139.Points
    local v140 = Points[1]
    local v141 = Points[#Points]
    local Magnitude = (v141 - v140).Magnitude
    local v142 = Style and Style.Depth
    if v142 == nil then
        v142 = v2.Depth
    end
    local v143 = v142 - 2
    local v144 = math.max(v143, 1)
    for v145, v146 in v139.Forks do
        local v147 = #Points * 0.15
        local v148 = math.floor(v147) + 1
        local v149 = #Points * 0.75
        local v150 = math.floor(v149)
        local v151 = Points[v4:NextInteger(v148, (math.max(v150, 2)))]
        local v152
        if Magnitude > 0.001 then
            v152 = (v141 - v140).Unit
        else
            v152 = Vector3.new(-0, -1, -0, -0)
        end
        local Unit = (v152 + perpendicular(v152) * v4:NextNumber(0.5, 1.1)).Unit
        local v153 = Style and Style.BranchLength
        if v153 == nil then
            v153 = v2.BranchLength
        end
        local v154 = v151 + Unit * (Magnitude * v153 * v4:NextNumber(0.4, 1))
        local v155 = Style and Style.Jag
        if v155 == nil then
            v155 = v2.Jag
        end
        local v156 = jagged(v151, v154, v144, v155 * 1.4)
        layLine(v146, v156, v139.WidthScale * 0.5, Style, 0.1, nil, (thicknessWalk(#v156, Style)))
    end
end

local function layMain(v157, v158) -- line 387 | captures: v2, layLine
    local Main = v157.Main
    local Points = v157.Points
    local WidthScale = v157.WidthScale
    local Style = v157.Style
    local Style_2 = v157.Style
    local v159 = Style_2 and Style_2.Taper
    if v159 == nil then
        v159 = v2.Taper
    end
    layLine(Main, Points, WidthScale, Style, v159, v158, v157.Thickness)
end

local function setAlpha(v160, v161, v162) -- line 391 | captures: v2, setLineAlpha
    setLineAlpha(v160.Main, v160.Style, v161)
    for v163, v164 in v160.Forks do
        setLineAlpha(v164, v160.Style, v162 or v161)
    end
    if not v160.Light then
        return
    end
    local Light = v160.Light
    local Style = v160.Style
    local v165 = Style and Style.LightBrightness
    if v165 == nil then
        v165 = v2.LightBrightness
    end
    Light.Brightness = v165 * v161
end

function v1.Strike(v166, v167, v168, v169) -- line 402 | captures: RunService, v2, v3, jagged, thicknessWalk, layLine, newBolt, newForks, setAlpha
    local v170 = newBolt(v168, v169)
    local v171 = v168 and v168.Leader
    if v171 == nil then
        v171 = v2.Leader
    end
    local v172 = v168 and v168.Life
    if v172 == nil then
        v172 = v2.Life
    end
    local v173 = v171 + 0.26 + 0.05
    local v174 = math.max(v172, v173)
    local v175 = v168 and v168.FadeTime
    if v175 == nil then
        v175 = v2.FadeTime
    end
    local v176
    if type(v166) == "function" then
        v176 = v166()
    else
        v176 = v166
    end
    local v177
    if type(v167) == "function" then
        v177 = v167()
    else
        v177 = v167
    end
    local Style = v170.Style
    local v178 = Style and Style.Depth
    if v178 == nil then
        v178 = v2.Depth
    end
    local Style_2 = v170.Style
    local v179 = Style_2 and Style_2.Jag
    if v179 == nil then
        v179 = v2.Jag
    end
    v170.Points = jagged(v176, v177, v178, v179)
    v170.Thickness = thicknessWalk(#v170.Points, v170.Style)
    if v170.LightAttachment then
        v170.LightAttachment.Position = v177
    end
    setAlpha(v170, 0.45, 0)
    local v180 = if v171 > 0 then 0 else nil
    local Main = v170.Main
    local Points = v170.Points
    local WidthScale = v170.WidthScale
    local Style_3 = v170.Style
    local Style_4 = v170.Style
    local v181 = Style_4 and Style_4.Taper
    if v181 == nil then
        v181 = v2.Taper
    end
    layLine(Main, Points, WidthScale, Style_3, v181, v180, v170.Thickness)
    local v182 = os.clock()
    local v183 = 0
    local v184
    local Heartbeat = RunService.Heartbeat
    local v185 = v171
    local v186 = v175
    v184 = Heartbeat:Connect(function() -- line 413 | captures: v183, v184, v170, v174, v182, v185, v186, v2, v3, layLine, newForks, setAlpha
        local v187 = os.clock() - v182
        if v174 <= v187 or not v170.Folder.Parent then
            v184:Disconnect()
            v170.Folder:Destroy()
        elseif v187 < v185 then
            local v188 = v187 / v185
            local Main = v170.Main
            local Points = v170.Points
            local WidthScale = v170.WidthScale
            local Style = v170.Style
            local Style_2 = v170.Style
            local v189 = Style_2 and Style_2.Taper
            if v189 == nil then
                v189 = v2.Taper
            end
            layLine(Main, Points, WidthScale, Style, v189, v188, v170.Thickness)
        else
            local v190 = v187 - v185
            if v190 < 0.26 then
                local v191 = 1
                for v192, v193 in v3 do
                    if v193[1] <= v190 then
                        v191 = v192
                    end
                end
                if v191 ~= v183 then
                    v183 = v191
                    local Main = v170.Main
                    local Points = v170.Points
                    local WidthScale = v170.WidthScale
                    local Style = v170.Style
                    local Style_2 = v170.Style
                    local v194 = Style_2 and Style_2.Taper
                    if v194 == nil then
                        v194 = v2.Taper
                    end
                    layLine(Main, Points, WidthScale, Style, v194, nil, v170.Thickness)
                    newForks(v170)
                    local v195 = v3[v191][2]
                    setAlpha(v170, v195, v195 * 0.9)
                end
            else
                local v196 = (v174 - v187) / math.max(v186, 0.001)
                local v197 = math.clamp(v196, 0, 1)
                setAlpha(v170, v197 * 0.5, 0)
            end
        end
    end)
end

function v1.Arc(v198, v199, v200, v201) -- line 456 | captures: RunService, v2, v4, jagged, thicknessWalk, layLine, newBolt, newForks, setAlpha
    local v202 = newBolt(v200, v201)
    local v203 = v200 and v200.Interval
    if v203 == nil then
        v203 = v2.Interval
    end
    local v204 = 0
    local v205
    local v206 = 0
    local v207 = os.clock()
    local v208
    local Heartbeat = RunService.Heartbeat
    local v209 = v203
    v208 = Heartbeat:Connect(function() -- line 464 | captures: v204, v205, v206, v208, v198, v199, v202, v207, v209, v2, v4, jagged, thicknessWalk, layLine, newForks, setAlpha
        local v210 = os.clock() - v207
        if v202.Folder.Parent then
            local v211
            if v205 then
                local v212 = v205 + v206 - v210
                if v212 <= 0 then
                    v208:Disconnect()
                    v202.Folder:Destroy()
                    return
                end
                if v206 > 0 then
                    v211 = v212 / v206
                else
                    v211 = 0
                end
            else
                v211 = 1
            end
            if v204 <= v210 then
                v204 = v210 + v209 * v4:NextNumber(0.7, 1.4)
                local v213 = v198
                if type(v198) == "function" then
                    v213 = v198()
                end
                local v214 = v199
                if type(v199) == "function" then
                    v214 = v199()
                end
                local Style = v202.Style
                local v215 = Style and Style.Depth
                if v215 == nil then
                    v215 = v2.Depth
                end
                local Style_2 = v202.Style
                local v216 = Style_2 and Style_2.Jag
                if v216 == nil then
                    v216 = v2.Jag
                end
                v202.Points = jagged(v213, v214, v215, v216)
                v202.Thickness = thicknessWalk(#v202.Points, v202.Style)
                if v202.LightAttachment then
                    v202.LightAttachment.Position = v214
                end
                local Main = v202.Main
                local Points = v202.Points
                local WidthScale = v202.WidthScale
                local Style_3 = v202.Style
                local Style_4 = v202.Style
                local v217 = Style_4 and Style_4.Taper
                if v217 == nil then
                    v217 = v2.Taper
                end
                layLine(Main, Points, WidthScale, Style_3, v217, nil, v202.Thickness)
                newForks(v202)
                local v218 = v4:NextNumber(0.55, 1)
                setAlpha(v202, v211 * v218, v211 * v218 * v4:NextNumber(0, 0.8))
            end
        else
            v208:Disconnect()
        end
    end)
    local v219 = {}

    function v219.Stop(v220, v221) -- line 490 | captures: v205, v206, v200, v207, v2
        if v205 then
            return
        end
        if v221 then
            v206 = v221
        else
            local v222 = v200 and v200.FadeTime
            if v222 == nil then
                v206 = v2.FadeTime
            else
                v206 = v222
            end
        end
        v205 = os.clock() - v207
    end

    function v219.SetWidth(v223, v224) -- line 497 | captures: v202
        v202.WidthScale = v224
    end

    return v219
end

return v1
