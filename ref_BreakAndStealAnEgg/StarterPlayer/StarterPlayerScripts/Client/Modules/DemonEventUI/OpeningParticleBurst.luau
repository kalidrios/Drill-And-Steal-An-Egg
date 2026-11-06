-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

return {
    new = function() -- new | line 37
        local v1 = {}
        local v2 = { live = 0 }
        v1.state = v2
        local T, rng, main, v3, offsetsFor, v4, v5
        local v6 = false
        local v7 = 0
        local v8 = 1
        local floor = math.floor
        local rad = math.rad
        local deg = math.deg
        local atan2 = math.atan2
        local sin = math.sin
        local cos = math.cos
        local v9 = {}
        local v10 = {}
        local v11 = {}
        local v12 = {}
        local v13 = {}
        local v14 = {}
        local v15 = {}
        local v16 = {}
        local v17 = {}
        local v18 = {}
        local v19 = {}
        local v20 = {}
        local v21 = {}
        local v22 = {}
        local v23 = {}
        local v24 = {}
        local v25 = {}
        local v26 = {}
        local v27 = {}
        local v28 = {}
        local v29 = {}
        local v30 = {}
        local v31 = 0
        local v32 = 0
        local v33 = 0
        local v34 = 0
        local v35 = 0
        local v36 = 0
        local v37 = 0
        local v38 = 0

        local function addSlots(v39, v40, v41, v42, v43) -- line 58 | captures: main, v3, offsetsFor, v7, floor, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29, v30
            local v44 = v3 and v3:FindFirstChild(v39)
            if not (v40 <= 0) and v44 and v44:IsA("ImageLabel") then
                local Cells = v44:GetAttribute("Cells")
                local FPS = v44:GetAttribute("FPS")
                local ImageRectSize = v44.ImageRectSize
                local v45, v46, v47
                if typeof(Cells) == "Vector2" and type(FPS) == "number" then
                    if FPS <= 0 or ImageRectSize.X <= 0 or ImageRectSize.Y <= 0 then
                        v47 = true
                    else
                        v45 = offsetsFor(Cells, ImageRectSize, false)
                        local Frames = v44:GetAttribute("Frames")
                        if type(Frames) == "number" and Frames >= 1 then
                            local v48 = floor(Frames)
                            local v49 = #v45
                            v46 = math.min(v48, v49) or #v45
                        else
                            v46 = #v45
                        end
                        v47 = false
                    end
                else
                    v47 = true
                end
                if v47 then
                    return 0, 0
                end
                local v50 = v7 + 1
                for v51 = 1, v40 do
                    local v52 = v44:Clone()
                    v52.Name = "OPB_" .. v39
                    v52.AnchorPoint = Vector2.new(0.5, 0.5)
                    v52.ZIndex = v43
                    v52.Active = false
                    v52.Visible = false
                    v52.Parent = main
                    v7 += 1
                    local v53 = v7
                    local v54 = v7
                    local v55 = v7
                    local v56 = v7
                    v9[v53] = v52
                    v10[v54] = v45
                    v11[v55] = v46
                    v12[v56] = FPS
                    local v57 = v7
                    local v58 = v7
                    local v59 = v7
                    local ImageTransparency = v44.ImageTransparency
                    v13[v57] = v41
                    v14[v58] = v42
                    v15[v59] = ImageTransparency
                    local v60 = v7
                    local v61 = v7
                    local v62 = v7
                    local v63 = v7
                    local v64 = v7
                    local v65 = v7
                    local v66 = v7
                    local v67 = v46 / FPS
                    v16[v60] = false
                    v17[v61] = false
                    v18[v62] = 0
                    v19[v63] = v67
                    v20[v64] = 0
                    v21[v65] = 0
                    v22[v66] = -1
                    local v68 = v7
                    local v69 = v7
                    local v70 = v7
                    local v71 = v7
                    local v72 = v7
                    local v73 = v7
                    local v74 = v7
                    local v75 = v7
                    v23[v68] = 0
                    v24[v69] = 0
                    v25[v70] = 0
                    v26[v71] = 0
                    v27[v72] = 0
                    v28[v73] = 0
                    v29[v74] = 0
                    v30[v75] = 0
                end
                return v50, v40
            end
            return 0, 0
        end

        local function build() -- line 91 | captures: T, main, v4, v5, v6, v8, v31, v32, v33, v34, v35, v36, v37, v38, addSlots
            v6 = true
            local v76 = v4.touchOnly or v4.lowEnd
            local UIAspectRatioConstraint = main:FindFirstChildOfClass("UIAspectRatioConstraint")
            if UIAspectRatioConstraint then
                v8 = 1 / UIAspectRatioConstraint.AspectRatio
            else
                local AbsoluteSize = main.AbsoluteSize
                v8 = AbsoluteSize.X > 0 and AbsoluteSize.Y > 0 and AbsoluteSize.Y / AbsoluteSize.X or 1
            end
            local OPB_Z = T.OPB_Z
            local OPB_EMBERS_LOW = v76 and T.OPB_EMBERS_LOW or T.OPB_EMBERS
            v31, v32 = addSlots("FireEmber", OPB_EMBERS_LOW, true, true, OPB_Z)
            local OPB_SPARKS_LOW = v76 and T.OPB_SPARKS_LOW or T.OPB_SPARKS
            v33, v34 = addSlots("FireSpark", OPB_SPARKS_LOW, true, true, OPB_Z)
            v5 = v76 and T.OPB_POOFS_LOW or T.OPB_POOFS
            v35, v36 = addSlots("DustPoof", #v5, false, false, OPB_Z - 1)
            v37, v38 = addSlots("SideDust", #T.OPB_SIDE, false, false, OPB_Z - 1)
        end

        function v1.build() -- line 108 | captures: v6, build
            if not v6 then
                build()
            end
        end

        local function between(v77) -- line 114 | captures: rng
            return rng:NextNumber(v77[1], v77[2])
        end

        local function arm(v78, v79, v80) -- line 119 | captures: T, v2, v16, v18, v19, v20, v22
            if not v16[v78] then
                v2.live += 1
            end
            v16[v78] = true
            v18[v78] = -v79
            v19[v78] = v80
            v20[v78] = v80 * (1 - T.OPB_FADE)
            v22[v78] = -1
        end

        local function armFire(v81, v82, v83, v84, v85, v86) -- line 133 | captures: T, rng, v8, v2, deg, atan2, sin, cos, v11, v16, v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29, v30
            local OPB_FIRE_JITTER = T.OPB_FIRE_JITTER
            local v87 = v85 + (v82 + rng:NextNumber(-OPB_FIRE_JITTER, OPB_FIRE_JITTER)) / v83 * 6.283185307179586
            local v88 = cos(v87)
            local v89 = sin(v87)
            local v90 = 0.5 / v8
            local v91 = v88 ~= 0 and v90 / math.abs(v88) or (1/0)
            local v92 = v89 ~= 0 and 0.5 / math.abs(v89) or (1/0)
            local v93 = math.min(v91, v92) * T.OPB_FIRE_FROM
            local OPB_EMBER_SPEED = v84 and T.OPB_EMBER_SPEED or T.OPB_SPARK_SPEED
            local v94 = rng:NextNumber(OPB_EMBER_SPEED[1], OPB_EMBER_SPEED[2])
            local v95 = v88 * v94
            local v96 = v89 * v94
            local v97 = v88 * v93
            local v98 = v89 * v93
            v23[v81] = v97
            v24[v81] = v98
            v25[v81] = v95
            v26[v81] = v96
            local OPB_EMBER_GRAVITY = v84 and T.OPB_EMBER_GRAVITY or T.OPB_SPARK_GRAVITY
            v27[v81] = OPB_EMBER_GRAVITY
            local OPB_EMBER_SIZE = v84 and T.OPB_EMBER_SIZE or T.OPB_SPARK_SIZE
            v30[v81] = rng:NextNumber(OPB_EMBER_SIZE[1], OPB_EMBER_SIZE[2])
            local v99
            if v84 then
                local v100 = -v95
                local v101 = atan2(v100, v96)
                v99 = deg(v101) + rng:NextNumber(-15, 15) or rng:NextNumber(0, 360)
            else
                v99 = rng:NextNumber(0, 360)
            end
            v28[v81] = v99
            local OPB_EMBER_SPIN = v84 and T.OPB_EMBER_SPIN or T.OPB_SPARK_SPIN
            v29[v81] = rng:NextNumber(-OPB_EMBER_SPIN, OPB_EMBER_SPIN)
            v21[v81] = rng:NextInteger(0, v11[v81] - 1)
            local v102 = v86 + rng:NextNumber(0, T.OPB_FIRE_SPREAD) * T.TIME_SCALE
            local OPB_EMBER_LIFE = v84 and T.OPB_EMBER_LIFE or T.OPB_SPARK_LIFE
            local v103 = rng:NextNumber(OPB_EMBER_LIFE[1], OPB_EMBER_LIFE[2])
            if not v16[v81] then
                v2.live += 1
            end
            v16[v81] = true
            v18[v81] = -v102
            v19[v81] = v103
            v20[v81] = v103 * (1 - T.OPB_FADE)
            v22[v81] = -1
        end

        function v1.play() -- line 156 | captures: T, rng, v5, v6, v7, v8, v31, v32, v33, v34, v35, v36, v37, v38, v2, rad, sin, cos, v11, v12, v16, v18, v19, v20, v21, v22, v23, v24, v28, v30, build, armFire
            if not v6 then
                build()
            end
            if v7 == 0 then
                return
            end
            local v104 = T.OPB_AT * T.TIME_SCALE
            local v105 = v32 + v34
            local v106 = rng:NextNumber(0, 6.283185307179586)
            local v107 = v32
            for v108 = 1, v107 do
                armFire(v31 + v108 - 1, (v108 - 1) * 2, v105, true, v106, v104)
            end
            local v109 = v34
            for v110 = 1, v109 do
                armFire(v33 + v110 - 1, v110 * 2 - 1, v105, false, v106, v104)
            end
            local v111 = v36
            for v112 = 1, v111 do
                local v113 = v35 + v112 - 1
                local v114 = v5[v112]
                local v115 = v114[1]
                local v116 = v114[2]
                local v117 = v114[3]
                v23[v113] = v115
                v24[v113] = v116
                v30[v113] = v117
                v28[v113] = rng:NextNumber(0, 360)
                v21[v113] = 0
                local v118 = v104 + v114[4] * T.TIME_SCALE
                local v119 = v11[v113] / v12[v113]
                if not v16[v113] then
                    v2.live += 1
                end
                v16[v113] = true
                v18[v113] = -v118
                v19[v113] = v119
                v20[v113] = v119 * (1 - T.OPB_FADE)
                v22[v113] = -1
            end
            local OPB_SIDE_ORIGIN = T.OPB_SIDE_ORIGIN
            local v120 = v38
            for v121 = 1, v120 do
                local v122 = v37 + v121 - 1
                local v123 = T.OPB_SIDE[v121]
                local v124 = v123[3]
                local v125 = v123[4] > 0
                local v126 = if v125 then -T.OPB_SIDE_TILT else nil
                local v127 = if not v125 or not v126 then 180 + T.OPB_SIDE_TILT else v126
                local v128 = (OPB_SIDE_ORIGIN[1] - 0.5) * v124
                local v129 = (OPB_SIDE_ORIGIN[2] - 0.5) * v124
                local v130 = rad(v127)
                local v131 = cos(v130)
                local v132 = rad(v127)
                local v133 = sin(v132)
                v23[v122] = v123[1] - (v128 * v131 - v129 * v133) * v8
                v24[v122] = v123[2] - (v128 * v133 + v129 * v131)
                v30[v122] = v124
                v28[v122] = v127
                v21[v122] = 0
                local v134 = v104 + v123[5] * T.TIME_SCALE
                local v135 = v11[v122] / v12[v122]
                if not v16[v122] then
                    v2.live += 1
                end
                v16[v122] = true
                v18[v122] = -v134
                v19[v122] = v135
                v20[v122] = v135 * (1 - T.OPB_FADE)
                v22[v122] = -1
            end
        end

        local function show(v136) -- line 201 | captures: v8, v9, v14, v15, v17, v23, v24, v28, v30
            local v137 = v9[v136]
            local v138 = v30[v136]
            v137.Size = UDim2.fromScale(v138 * v8, v138)
            if v14[v136] then
                v137.Position = UDim2.fromScale(0.5 + v23[v136] * v8, 0.5 + v24[v136])
            else
                v137.Position = UDim2.fromScale(v23[v136], v24[v136])
            end
            v137.Rotation = v28[v136]
            v137.ImageTransparency = v15[v136]
            v137.Visible = true
            v17[v136] = true
        end

        function v1.step(v139) -- line 216 | captures: T, v7, v8, v2, floor, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29, show
            local v140 = v2.live
            local v141 = 1 / (1 + T.OPB_DRAG * v139)
            local v142 = v7
            for v143 = 1, v142 do
                if v16[v143] then
                    local v144 = v18[v143] + v139
                    v18[v143] = v144
                    if v144 >= 0 then
                        local v145 = v9[v143]
                        local v146 = v19[v143]
                        if v146 <= v144 then
                            v16[v143] = false
                            v140 -= 1
                            if v17[v143] then
                                v17[v143] = false
                                v145.Visible = false
                            end
                        else
                            if not v17[v143] then
                                show(v143)
                            end
                            local v147 = v11[v143]
                            local v148 = v144 * v12[v143]
                            local v149 = floor(v148) + v21[v143]
                            if v13[v143] then
                                v147 = v149 % v147 + 1
                            elseif not (v147 <= v149) then
                                v147 = v149 + 1
                            end
                            if v147 ~= v22[v143] then
                                v22[v143] = v147
                                v145.ImageRectOffset = v10[v143][v147]
                            end
                            if v14[v143] then
                                local v150 = v25[v143] * v141
                                local v151 = v26[v143] * v141 + v27[v143] * v139
                                v25[v143] = v150
                                v26[v143] = v151
                                local v152 = v23[v143] + v150 * v139
                                local v153 = v24[v143] + v151 * v139
                                v23[v143] = v152
                                v24[v143] = v153
                                v145.Position = UDim2.fromScale(0.5 + v152 * v8, 0.5 + v153)
                                local v154 = v28[v143] + v29[v143] * v139
                                v28[v143] = v154
                                v145.Rotation = v154
                                local v155 = v20[v143]
                                if v155 < v144 then
                                    local v156 = v15[v143]
                                    v145.ImageTransparency = v156 + (1 - v156) * (v144 - v155) / (v146 - v155)
                                end
                            end
                        end
                    end
                end
            end
            v2.live = v140
        end

        function v1.hideAll() -- line 274 | captures: v7, v2, v9, v16, v17
            if v2.live == 0 then
                return
            end
            local v157 = v7
            for v158 = 1, v157 do
                if v17[v158] then
                    v17[v158] = false
                    v9[v158].Visible = false
                end
                v16[v158] = false
            end
            v2.live = 0
        end

        function v1.destroy() -- line 288 | captures: v7, v1, v9
            v1.hideAll()
            local v159 = v7
            for v160 = 1, v159 do
                v9[v160]:Destroy()
                v9[v160] = nil
            end
            v7 = 0
        end

        function v1.init(v161) -- line 297 | captures: T, rng, main, v3, offsetsFor, v4
            v4 = v161
            local T_2 = v4.T
            local rng_2 = v4.rng
            local main_2 = v4.main
            T = T_2
            rng = rng_2
            main = main_2
            v3 = v161.gui:FindFirstChild("VFXAssets")
            offsetsFor = v161.Sprites.offsetsFor
        end

        return v1
    end
}
