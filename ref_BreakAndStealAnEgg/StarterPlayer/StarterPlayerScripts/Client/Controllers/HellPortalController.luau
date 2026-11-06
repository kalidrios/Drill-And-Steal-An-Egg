-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local HellEventConfig = require(ReplicatedStorage.Shared.HellEventConfig)
local v1 = {}
local Portal = HellEventConfig.Portal
local Timer = HellEventConfig.Timer
local LocalPlayer = Players.LocalPlayer
local v2, v3, v4, v5
local v6 = {}
local v7
local v8 = 0
local v9 = 0
local v10 = false
local v11, Parent
local v12 = false
local v13 = 0
local v14 = {}

local function isJoinable() -- line 87 | captures: Workspace, HellEventConfig
    return Workspace:GetAttribute(HellEventConfig.JoinableAttribute) == true
end

local function isCharging() -- line 91 | captures: Workspace, HellEventConfig
    return Workspace:GetAttribute(HellEventConfig.PortalChargeAttribute) ~= nil
end

local v15 = (-1/0)

local function askToJoin() -- line 102 | captures: v15, ReplicatedStorage, Workspace, HellEventConfig, LocalPlayer
    if Workspace:GetAttribute(HellEventConfig.JoinableAttribute) == true and LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) ~= true then
        local v16 = os.clock()
        if not (v16 - v15 < 1.5) then
            v15 = v16
            local v17 = ReplicatedStorage:FindFirstChild(HellEventConfig.JoinRemoteName)
            if v17 and v17:IsA("RemoteEvent") then
                v17:FireServer()
            end
        end
    end
end

local function atDoorway() -- line 118 | captures: v3, Portal, LocalPlayer
    local v18 = v3
    local Character = LocalPlayer.Character
    local v19 = Character and Character:FindFirstChild("HumanoidRootPart")
    if v18 and v18.Parent and v19 and v19:IsA("BasePart") then
        local v20 = v18.Size / 2 + Vector3.new(1, 1, 1) * Portal.TouchMargin
        local v21 = v18.CFrame:PointToObjectSpace(v19.Position)
        local X = v21.X
        if math.abs(X) <= v20.X then
            local Y = v21.Y
            if math.abs(Y) <= v20.Y then
                local Z = v21.Z
                return math.abs(Z) <= v20.Z
            end
        end
        return false
    end
    return false
end

local function adopt(v22) -- line 135 | captures: v2, v3, v4, v5, v7, v10, v11, Parent, v12, Portal, LocalPlayer, v6, v14, askToJoin
    v2 = v22
    Parent = v22.Parent
    v12 = false
    local v23 = v22:FindFirstChild(Portal.TouchPart)
    if not (v23 and v23:IsA("BasePart")) then
        v23 = nil
    end
    v3 = v23
    if not v3 then
        warn((("[HellPortalController] %*.%* not found \226\128\148 touch-to-join is server-side only"):format(v22:GetFullName(), Portal.TouchPart)))
    end
    local v24 = v22:FindFirstChild(Portal.Face)
    if not (v24 and v24:IsA("BasePart")) then
        v24 = nil
    end
    v4 = v24
    if v4 then
        v5 = {
            Transparency = v4.Transparency,
            Color = v4.Color,
            Size = v4.Size
        }
    else
        v5 = nil
    end
    table.clear(v6)
    for v25, v26 in Portal.OpenEmitters do
        local v27 = v22:FindFirstChild(v26)
        if v27 then
            for v28, v29 in v27:GetDescendants() do
                if v29:IsA("ParticleEmitter") then
                    v29.Enabled = false
                    table.insert(v6, v29)
                end
            end
        end
    end
    v10 = false
    table.clear(v14)
    local v30 = {}
    for v31, v32 in Portal.PassThrough or {} do
        v30[v32] = true
    end
    for v33, v34 in v22:GetDescendants() do
        if v34:IsA("BasePart") then
            if v30[v34.Name] or v34.Transparency >= 1 then
                v34.CanCollide = false
            else
                table.insert(v14, v34)
            end
        end
    end
    if v11 then
        v11:Disconnect()
        v11 = nil
    end
    if v3 then
        v11 = v3.Touched:Connect(function(v35) -- line 188 | captures: LocalPlayer, askToJoin
            local Character = LocalPlayer.Character
            if Character and v35:IsDescendantOf(Character) then
                askToJoin()
            end
        end)
    end
    v7 = nil
end

local function resolve() -- line 202 | captures: v2, v12, HellEventConfig, adopt
    if v2 and (v2.Parent or v12) then
        return v2
    end
    local v36 = HellEventConfig.FindPortal()
    if v36 then
        adopt(v36)
    end
    return v36
end

local function setEmitters(v37, v38) -- line 217 | captures: v10, Portal, v6
    if v37 ~= v10 then
        v10 = v37
        for v39, v40 in v6 do
            v40.Enabled = v37
            if v37 and v38 and (Portal.OpenBurst or 0) > 0 then
                v40:Emit(Portal.OpenBurst)
            end
        end
    end
end

local function setSolid(v41) -- line 232 | captures: Portal, v14
    local v42 = v41 and Portal.SolidWhenEnabled == true
    for v43, v44 in v14 do
        if v44.CanCollide ~= v42 then
            v44.CanCollide = v42
        end
    end
end

local function setOpen(v45) -- line 243 | captures: v4, v5, Portal
    local v46 = v5
    if not v4 or not v46 then
        return
    end
    local Dormant = Portal.Dormant
    local v47 = math.clamp(v45, 0, 1)
    v4.Transparency = Dormant.Transparency + (v46.Transparency - Dormant.Transparency) * v47
    v4.Color = Dormant.Color:Lerp(v46.Color, v47)
    local v48 = Dormant.Scale + (1 - Dormant.Scale) * math.max(v45, 0)
    v4.Size = v46.Size * v48
end

local function animate(v49, v50, v51, v52) -- line 257 | captures: v8, v9, RunService, TweenService, setOpen
    v9 += 1
    local v53 = v9
    local v54 = v8
    local v55 = os.clock()
    local v56
    v56 = RunService.RenderStepped:Connect(function() -- line 263 | captures: v56, v49, v50, v51, v52, v53, v54, v55, v8, v9, TweenService, setOpen
        if v53 == v9 then
            local v57 = (os.clock() - v55) / math.max(v50, 0.001)
            local v58 = math.clamp(v57, 0, 1)
            local v59 = v54 + (v49 - v54) * TweenService:GetValue(v58, v51, v52)
            v8 = math.clamp(v59, 0, 1)
            setOpen(v59)
            if v58 >= 1 then
                v56:Disconnect()
            end
        else
            v56:Disconnect()
        end
    end)
end

local function setShown(v60, v61) -- line 281 | captures: v2, v10, Parent, v12, v13, Portal, v6
    if not (Portal.HideWhenShut and v2) then
        return
    end
    v13 += 1
    local v62 = v13
    if v60 then
        if v12 and Parent and Parent.Parent then
            v2.Parent = Parent
        end
        v12 = false
    else
        local function hide() -- line 294 | captures: v62, v2, v10, Parent, v12, v13, v6
            local v63 = v2
            local v64
            if v62 == v13 and v63 then
                if v12 then
                    v64 = true
                else
                    if v63.Parent then
                        Parent = v63.Parent
                    end
                    v64 = false
                end
            else
                v64 = true
            end
            if v64 then
                return
            end
            if v10 ~= false then
                v10 = false
                for v65, v66 in v6 do
                    v66.Enabled = false
                end
            end
            v63.Parent = nil
            v12 = true
        end

        if not (v61 and v61 > 0) then
            local v67 = v2
            if v62 == v13 and v67 then
                if v12 then
                    return
                end
                if v67.Parent then
                    Parent = v67.Parent
                end
                if v10 ~= false then
                    v10 = false
                    for v68, v69 in v6 do
                        v69.Enabled = false
                    end
                end
                v67.Parent = nil
                v12 = true
            end
        else
            task.delay(v61, hide)
        end
    end
end

local v70 = ""

local function sync() -- line 315 | captures: v2, v8, v9, v10, v12, v70, RunService, TweenService, Workspace, HellEventConfig, Portal, v6, v14, adopt, setOpen, setShown
    local v71
    if v2 and (v2.Parent or v12) then
        v71 = v2
    else
        v71 = HellEventConfig.FindPortal()
        if v71 then
            adopt(v71)
        end
    end
    if v71 then
        local v72
        if Workspace:GetAttribute(HellEventConfig.JoinableAttribute) == true then
            v72 = "Open"
        elseif Workspace:GetAttribute(HellEventConfig.PortalChargeAttribute) ~= nil then
            v72 = "Charge"
        else
            v72 = "Shut"
        end
        if v72 ~= v70 then
            v70 = v72
            local v73 = v72 ~= "Shut"
            local v74 = if v72 == "Shut" then Portal.CloseTime else nil
            setShown(v73, v74)
            local v75 = v72 ~= "Shut" and Portal.SolidWhenEnabled == true
            for v76, v77 in v14 do
                if v77.CanCollide ~= v75 then
                    v77.CanCollide = v75
                end
            end
            if v72 == "Open" then
                if v10 ~= true then
                    v10 = true
                    for v78, v79 in v6 do
                        v79.Enabled = true
                        if (Portal.OpenBurst or 0) > 0 then
                            v79:Emit(Portal.OpenBurst)
                        end
                    end
                end
                local OpenTime = Portal.OpenTime
                local OpenStyle = Portal.OpenStyle
                local Out = Enum.EasingDirection.Out
                v9 += 1
                local v80 = v9
                local v81 = v8
                local v82 = os.clock()
                local v83
                local RenderStepped = RunService.RenderStepped
                local v84 = 1
                v83 = RenderStepped:Connect(function() -- line 263 | captures: v83, OpenTime, OpenStyle, Out, v80, v81, v82, v84, v8, v9, TweenService, setOpen
                    if v80 == v9 then
                        local v85 = (os.clock() - v82) / math.max(OpenTime, 0.001)
                        local v86 = math.clamp(v85, 0, 1)
                        local v87 = v81 + (v84 - v81) * TweenService:GetValue(v86, OpenStyle, Out)
                        v8 = math.clamp(v87, 0, 1)
                        setOpen(v87)
                        if v86 >= 1 then
                            v83:Disconnect()
                        end
                    else
                        v83:Disconnect()
                    end
                end)
            else
                local v88 = v72 == "Charge"
                local v89
                if v88 then
                    if v10 ~= false then
                        v10 = false
                        for v90, v91 in v6 do
                            v91.Enabled = false
                        end
                    end
                    v89 = v8 < Portal.StartShare
                else
                    if v10 ~= false then
                        v10 = false
                        for v92, v93 in v6 do
                            v93.Enabled = false
                        end
                    end
                    local CloseTime = Portal.CloseTime
                    local CloseStyle = Portal.CloseStyle
                    local In = Enum.EasingDirection.In
                    v9 += 1
                    local v94 = v9
                    local v95 = v8
                    local v96 = os.clock()
                    local v97
                    local RenderStepped = RunService.RenderStepped
                    local v98 = 0
                    v97 = RenderStepped:Connect(function() -- line 263 | captures: CloseTime, CloseStyle, In, v94, v95, v96, v98, v8, v9, TweenService, setOpen, v97
                        if v94 == v9 then
                            local v99 = (os.clock() - v96) / math.max(CloseTime, 0.001)
                            local v100 = math.clamp(v99, 0, 1)
                            local v101 = v95 + (v98 - v95) * TweenService:GetValue(v100, CloseStyle, In)
                            v8 = math.clamp(v101, 0, 1)
                            setOpen(v101)
                            if v100 >= 1 then
                                v97:Disconnect()
                            end
                        else
                            v97:Disconnect()
                        end
                    end)
                end
                if (not v88 or v89) and v88 then
                    local StartShare = Portal.StartShare
                    local KickTime = HellEventConfig.PortalCharge.KickTime
                    local Quad = Enum.EasingStyle.Quad
                    local Out = Enum.EasingDirection.Out
                    v9 += 1
                    local v102 = v9
                    local v103 = v8
                    local v104 = os.clock()
                    local v105
                    v105 = RunService.RenderStepped:Connect(function() -- line 263 | captures: v105, StartShare, KickTime, Quad, Out, v102, v103, v104, v8, v9, TweenService, setOpen
                        if v102 == v9 then
                            local v106 = (os.clock() - v104) / math.max(KickTime, 0.001)
                            local v107 = math.clamp(v106, 0, 1)
                            local v108 = v103 + (StartShare - v103) * TweenService:GetValue(v107, Quad, Out)
                            v8 = math.clamp(v108, 0, 1)
                            setOpen(v108)
                            if v107 >= 1 then
                                v105:Disconnect()
                            end
                        else
                            v105:Disconnect()
                        end
                    end)
                end
            end
        end
    end
end

local function formatRemaining(v109) -- line 346
    local v110 = math.ceil(v109)
    local v111 = math.max(v110, 0)
    if v111 >= 60 then
        return (("%*m %*s"):format(v111 // 60, v111 % 60))
    end
    return (("%*s"):format(v111))
end

local function signText() -- line 354 | captures: Workspace, HellEventConfig, Portal, Timer, LocalPlayer
    if LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true then
        return Timer.LiveText
    end
    if Workspace:GetAttribute(HellEventConfig.JoinableAttribute) == true then
        return Timer.JoinText
    end
    if Workspace:GetAttribute(HellEventConfig.PortalChargeAttribute) ~= nil then
        return Timer.ChargingText or Timer.JoinText
    end
    if Workspace:GetAttribute(HellEventConfig.StartedAtAttribute) == nil then
        local v112 = Workspace:GetAttribute(HellEventConfig.NextAtAttribute)
        if type(v112) == "number" then
            local format = string.format
            local Countdown = Timer.Countdown
            local v113 = v112 - Workspace:GetServerTimeNow()
            local v114 = math.ceil(v113)
            local v115 = math.max(v114, 0)
            local v116
            if v115 >= 60 then
                v116 = ("%*m %*s"):format(v115 // 60, v115 % 60)
            else
                v116 = ("%*s"):format(v115)
            end
            return format(Countdown, v116)
        end
        return ""
    end
    return Portal.Label.ClosedText
end

local function refreshSign() -- line 371 | captures: v7, signText
    local v117 = v7
    if v117 and v117.Parent then
        local v118 = signText()
        if v117.Text ~= v118 then
            v117.Text = v118
        end
    end
end

function v1.Kick(v119) -- line 387 | captures: v2, v8, v9, v12, RunService, TweenService, Workspace, HellEventConfig, adopt, setOpen
    local v120
    if v2 and (v2.Parent or v12) then
        v120 = v2
    else
        v120 = HellEventConfig.FindPortal()
        if v120 then
            adopt(v120)
        end
    end
    if not v120 or not (Workspace:GetAttribute(HellEventConfig.PortalChargeAttribute) ~= nil) or not (Workspace:GetAttribute(HellEventConfig.JoinableAttribute) ~= true) or v119 <= v8 then
        return
    end
    local KickTime = HellEventConfig.PortalCharge.KickTime
    local v121 = math.min(v119, 1)
    local Back = Enum.EasingStyle.Back
    local Out = Enum.EasingDirection.Out
    v9 += 1
    local v122 = v9
    local v123 = v8
    local v124 = os.clock()
    local v125
    v125 = RunService.RenderStepped:Connect(function() -- line 263 | captures: v125, KickTime, v121, Back, Out, v122, v123, v124, v8, v9, TweenService, setOpen
        if v122 == v9 then
            local v126 = (os.clock() - v124) / math.max(KickTime, 0.001)
            local v127 = math.clamp(v126, 0, 1)
            local v128 = v123 + (v121 - v123) * TweenService:GetValue(v127, Back, Out)
            v8 = math.clamp(v128, 0, 1)
            setOpen(v128)
            if v127 >= 1 then
                v125:Disconnect()
            end
        else
            v125:Disconnect()
        end
    end)
end

function v1.GetTargetPoint(v129, v130) -- line 401 | captures: v2, v3, v4, v12, HellEventConfig, adopt
    if not (v2 and (v2.Parent or v12)) then
        local v131 = HellEventConfig.FindPortal()
        if v131 then
            adopt(v131)
        end
    end
    local v132 = v3 or v4
    local v133, v134, v135
    if v132 and v132.Parent then
        local v136 = v130 or 1
        v133 = v132.Size / 2
        local v137 = (math.random() * 2 - 1) * v133.X * v136
        local v138 = (math.random() * 2 - 1) * v133.Y * v136
        v134 = Vector3.new(v137, v138, 0)
        if v132.CFrame:PointToObjectSpace(v129).Z >= 0 then
            v135 = 1
        else
            v135 = -1
        end
    else
        return nil
    end
    local CFrame = v132.CFrame
    local v139 = v135 * (v133.Z + 0.5)
    return CFrame:PointToWorldSpace(v134 + Vector3.new(0, 0, v139))
end

function v1.Start() -- line 415 | captures: v2, v7, v8, v10, Parent, v12, v13, v70, RunService, Workspace, HellEventConfig, Portal, LocalPlayer, v6, v14, askToJoin, atDoorway, adopt, setOpen, sync, signText, refreshSign
    Workspace:GetAttributeChangedSignal(HellEventConfig.JoinableAttribute):Connect(function() -- line 416 | captures: v7, sync, signText
        sync()
        local v140 = v7
        if v140 and v140.Parent then
            local v141 = signText()
            if v140.Text ~= v141 then
                v140.Text = v141
            end
        end
    end)
    Workspace:GetAttributeChangedSignal(HellEventConfig.PortalChargeAttribute):Connect(function() -- line 420 | captures: v7, sync, signText
        sync()
        local v142 = v7
        if v142 and v142.Parent then
            local v143 = signText()
            if v142.Text ~= v143 then
                v142.Text = v143
            end
        end
    end)
    LocalPlayer:GetAttributeChangedSignal(HellEventConfig.PlayerAttribute):Connect(refreshSign)
    local v144 = Workspace
    local v145 = os.clock() + 30
    for v146, v147 in Portal.Path do
        if v144 then
            local v148 = v145 - os.clock()
            v144 = v144:WaitForChild(v147, (math.max(v148, 0.1)))
        end
    end
    local v149
    if v2 and (v2.Parent or v12) then
        v149 = v2
    else
        v149 = HellEventConfig.FindPortal()
        if v149 then
            adopt(v149)
        end
    end
    if not v149 then
        warn((("[HellPortalController] Workspace.%* not found \226\128\148 no Hell portal visuals"):format((table.concat(Portal.Path, ".")))))
    else
        if Workspace:GetAttribute(HellEventConfig.JoinableAttribute) == true then
            v70 = "Open"
        elseif Workspace:GetAttribute(HellEventConfig.PortalChargeAttribute) ~= nil then
            v70 = "Charge"
        else
            v70 = "Shut"
        end
        if v70 == "Open" then
            v8 = 1
        elseif v70 == "Charge" then
            v8 = Portal.StartShare
        else
            v8 = 0
        end
        setOpen(v8)
        local v150 = v70 == "Open"
        if v150 ~= v10 then
            v10 = v150
            for v151, v152 in v6 do
                v152.Enabled = v150
            end
        end
        local v153 = v70 ~= "Shut"
        if Portal.HideWhenShut and v2 then
            v13 += 1
            local v154 = v13
            if v153 then
                if v12 and Parent and Parent.Parent then
                    v2.Parent = Parent
                end
                v12 = false
            else
                local function hide() -- line 294 | captures: v154, v2, v10, Parent, v12, v13, v6
                    local v155 = v2
                    local v156
                    if v154 == v13 and v155 then
                        if v12 then
                            v156 = true
                        else
                            if v155.Parent then
                                Parent = v155.Parent
                            end
                            v156 = false
                        end
                    else
                        v156 = true
                    end
                    if v156 then
                        return
                    end
                    if v10 ~= false then
                        v10 = false
                        for v157, v158 in v6 do
                            v158.Enabled = false
                        end
                    end
                    v155.Parent = nil
                    v12 = true
                end

                local v159 = v2
                local v160
                if v154 == v13 and v159 then
                    if v12 then
                        v160 = true
                    else
                        if v159.Parent then
                            Parent = v159.Parent
                        end
                        v160 = false
                    end
                else
                    v160 = true
                end
                if not v160 then
                    if v10 ~= false then
                        v10 = false
                        for v161, v162 in v6 do
                            v162.Enabled = false
                        end
                    end
                    v159.Parent = nil
                    v12 = true
                end
            end
        end
        local v163 = v70 ~= "Shut" and Portal.SolidWhenEnabled == true
        for v164, v165 in v14 do
            if v165.CanCollide ~= v163 then
                v165.CanCollide = v163
            end
        end
        local v166 = v7
        if v166 and v166.Parent then
            local v167 = signText()
            if v166.Text ~= v167 then
                v166.Text = v167
            end
        end
        local v168 = 0
        local v169 = 0
        RunService.Heartbeat:Connect(function() -- line 447 | captures: v168, v169, v2, v7, v12, v70, Workspace, HellEventConfig, Portal, askToJoin, atDoorway, adopt, sync, signText
            local v170 = os.clock()
            if v168 <= v170 then
                v168 = v170 + Portal.TouchCheckInterval
                if Workspace:GetAttribute(HellEventConfig.JoinableAttribute) == true and atDoorway() then
                    askToJoin()
                end
            end
            local v171 = false
            local v172 = false
            local v173 = false
            local v174 = false
            local v175 = false
            if v169 <= v170 then
                v171 = true
            else
                v175 = true
            end
            if v171 then
                v169 = v170 + Portal.Label.Every
                if v2 then
                    v172 = true
                else
                    v173 = true
                end
            end
            v171 = false
            if v172 then
                if v2.Parent then
                    v175 = false
                else
                    v171 = true
                end
            end
            v172 = false
            if v171 then
                if v12 then
                    v175 = false
                else
                    v173 = true
                end
            end
            v171 = false
            if v173 then
                if v2 then
                    v171 = true
                else
                    v172 = true
                end
            end
            v173 = false
            if v171 then
                if v2.Parent then
                    v174 = true
                else
                    v173 = true
                end
            end
            v171 = false
            if v173 then
                if v12 then
                    v174 = true
                else
                    v172 = true
                end
            end
            v173 = false
            local v176
            if v172 then
                v176 = HellEventConfig.FindPortal()
                if v176 then
                    v173 = true
                else
                    v171 = true
                end
            end
            if v173 then
                adopt(v176)
                v171 = true
            end
            v173 = false
            local v177
            if v171 then
                v177 = v176
                v173 = true
            end
            v171 = false
            if v174 then
                v177 = v2
                v173 = true
            end
            if v173 then
                if v177 then
                    v171 = true
                else
                    v175 = false
                end
            end
            if v171 then
                v70 = ""
                sync()
                v175 = false
            end
            if not v175 then
                local v178 = v7
                if v178 and v178.Parent then
                    local v179 = signText()
                    if v178.Text ~= v179 then
                        v178.Text = v179
                    end
                end
            end
        end)
    end
end

return v1
