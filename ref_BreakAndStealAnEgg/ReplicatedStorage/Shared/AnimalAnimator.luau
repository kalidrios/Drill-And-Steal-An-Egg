-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local KeyframeRegistrar = require(ReplicatedStorage.Shared.KeyframeRegistrar)
local WaitFor = require(ReplicatedStorage.Shared.WaitFor)
local v1 = {}

v1.__index = v1

local v2 = { "AnimalsAnim1", "AnimalsAnim2", "RBX_ANIMSAVES" }

v1.UsePublishedFallback = false
v1.AnimationIds = {}

local v3 = {
    Bird = "rbxassetid://93597131728442",
    Wild = "rbxassetid://95953778768459",
    Fish = "rbxassetid://81933091997852",
    Octopus = "rbxassetid://110744481730263",
    Nautilus = "rbxassetid://125284578355081",
    Snake = "rbxassetid://81761997293533",
    Biped = "rbxassetid://93231461556916"
}

v1.CLIP_KEYWORDS = {
    Walk = { "walk", "swim", "run" },
    Idle = { "idle" }
}

local CLIP_KEYWORDS = v1.CLIP_KEYWORDS
local v4 = {}
local v5 = {}
local v6 = {}
local v7 = { 0.5, 1, 2, 4, 8 }
local v8 = #v7 + 1

local function watchSequenceLifetime(v9) -- line 136 | captures: v4, v5, v6
    if v6[v9] then
        return
    end
    v6[v9] = true
    v9.Destroying:Once(function() -- line 141 | captures: v9, v4, v5, v6
        v4[v9] = nil
        v5[v9] = nil
        v6[v9] = nil
    end)
end

local function peekSequence(v10) -- line 150 | captures: v4, v8
    local v11 = v4[v10]
    if v11 == nil then
        return nil, true
    end
    if v11.Hash then
        return v11.Hash, false
    end
    local Failures = v11.Failures
    if v8 <= Failures then
        return nil, false
    end
    local v12 = os.clock()
    return nil, v11.NextAt <= v12
end

local function registerSequence(v13) -- line 165 | captures: KeyframeRegistrar, v4, v5, v6, v7, v8
    if not KeyframeRegistrar.IsBlocked() then
        local v14 = v4[v13]
        local Hash, v15
        if v14 == nil then
            v15 = true
        elseif v14.Hash then
            Hash = v14.Hash
            v15 = false
        else
            local Failures = v14.Failures
            if v8 <= Failures then
                v15 = false
            else
                local v16 = os.clock()
                v15 = v14.NextAt <= v16
            end
        end
        if Hash then
            return Hash
        end
        if v15 then
            local v17 = os.clock() + 8
            while true do
                local Hash, v18
                if v5[v13] and os.clock() < v17 then
                    task.wait()
                    local v19 = v4[v13]
                    if v19 == nil then
                        v18 = true
                    elseif v19.Hash then
                        Hash = v19.Hash
                        v18 = false
                    else
                        local Failures = v19.Failures
                        if v8 <= Failures then
                            v18 = false
                        else
                            local v20 = os.clock()
                            v18 = v19.NextAt <= v20
                        end
                    end
                else
                    break
                end
                if Hash then
                    return Hash
                end
                if v18 then
                    continue
                end
                return nil
            end
            v5[v13] = true
            if v13:IsA("KeyframeSequence") then
                pcall(function() -- line 200 | captures: v13
                    v13.Loop = true
                end)
            end
            local v21 = KeyframeRegistrar.Register(v13)
            v5[v13] = nil
            if v21 == nil then
                if not KeyframeRegistrar.IsBlocked() then
                    local v22 = v4[v13]
                    local v23 = (v22 and v22.Failures or 0) + 1
                    if not v6[v13] then
                        v6[v13] = true
                        v13.Destroying:Once(function() -- line 141 | captures: v13, v4, v5, v6
                            v4[v13] = nil
                            v5[v13] = nil
                            v6[v13] = nil
                        end)
                    end
                    local v24 = {
                        Hash = nil,
                        Failures = v23
                    }
                    v24.NextAt = os.clock() + (v7[v23] or v7[#v7])
                    v4[v13] = v24
                end
                return nil
            end
            if not v6[v13] then
                v6[v13] = true
                v13.Destroying:Once(function() -- line 141 | captures: v13, v4, v5, v6
                    v4[v13] = nil
                    v5[v13] = nil
                    v6[v13] = nil
                end)
            end
            v4[v13] = {
                Failures = 0,
                NextAt = 0,
                Hash = v21
            }
            return v21
        end
    end
    return nil
end

local v25 = { 0.25, 0.5, 1, 2, 4, 8, 16 }
local v26 = {}

local function warnOnce(v27, v28) -- line 261 | captures: v26
    if not v26[v27] then
        v26[v27] = true
        warn(v28)
    end
end

local function resolveAnimator(v29) -- line 270
    local v30 = v29:FindFirstChildOfClass("AnimationController") or v29:FindFirstChildOfClass("Humanoid")
    if v30 == nil then
        v30 = Instance.new("AnimationController")
        v30.Parent = v29
    end
    local Animator = v30:FindFirstChildOfClass("Animator")
    if Animator == nil then
        Animator = Instance.new("Animator")
        Animator.Parent = v30
    end
    return Animator
end

local function findSequence(v31, v32) -- line 287 | captures: CLIP_KEYWORDS
    local v33 = CLIP_KEYWORDS[v32]
    if v33 ~= nil then
        for v34, v35 in ipairs(v33) do
            for v36, v37 in ipairs(v31:GetChildren()) do
                if v37:IsA("KeyframeSequence") and string.find(v37.Name:lower(), v35, 1, true) then
                    return v37
                end
            end
        end
    end
    return nil
end

local function findAnimationInstance(v38, v39) -- line 307 | captures: CLIP_KEYWORDS
    if v38 ~= nil then
        local v40 = v38:FindFirstChild(v39)
        if v40 and v40:IsA("Animation") and v40.AnimationId ~= "" then
            return v40
        end
        local v41 = CLIP_KEYWORDS[v39]
        if v41 ~= nil then
            for v42, v43 in ipairs(v41) do
                for v44, v45 in ipairs(v38:GetChildren()) do
                    if v45:IsA("Animation") and v45.AnimationId ~= "" and string.find(v45.Name:lower(), v43, 1, true) then
                        return v45
                    end
                end
            end
        end
    end
    return nil
end

local function hasSequences(v46) -- line 336
    if v46 then
        for v47, v48 in v46:GetChildren() do
            if v48:IsA("KeyframeSequence") then
                return true
            end
        end
    end
    return false
end

local function poolTemplate(v49) -- line 348 | captures: EggRewards
    return EggRewards.FindAnimalTemplate(v49)
end

local function resolveAnimSets(v50, v51, v52, v53) -- line 367 | captures: ReplicatedStorage, EggRewards, v2
    local v54 = {}
    local v55 = {}

    local function add(v56) -- line 371 | captures: v54, v55
        if not v56 or v55[v56] then
            return
        end
        local v57 = false
        local v58
        for v59, v60 in v56:GetChildren() do
            if v60:IsA("KeyframeSequence") then
                v58 = true
                v57 = true
                break
            end
        end
        if not v57 then
            v58 = false
        end
        if v58 then
            v55[v56] = true
            table.insert(v54, v56)
        end
    end

    local v61 = v50 and v50.AnimSet
    if type(v61) ~= "string" or v61 == "" then
        v61 = nil
    end
    if v61 then
        for v62, v63 in v2 do
            local v64 = ReplicatedStorage:FindFirstChild(v63)
            local v65 = v64 and v64:FindFirstChild(v61)
            if v65 and not v55[v65] then
                local v66 = false
                for v67, v68 in v65:GetChildren() do
                    if v68:IsA("KeyframeSequence") then
                        v66 = true
                        break
                    end
                    v66 = false
                end
                if v66 then
                    v55[v65] = true
                    table.insert(v54, v65)
                end
            end
        end
    end
    local v69 = v51 and v51:FindFirstChild("AnimSaves")
    if v69 and not v55[v69] then
        local v70 = false
        local v71
        for v72, v73 in v69:GetChildren() do
            if v73:IsA("KeyframeSequence") then
                v71 = true
                v70 = true
                break
            end
        end
        if not v70 then
            v71 = false
        end
        if v71 then
            v55[v69] = true
            table.insert(v54, v69)
        end
    end
    local v74 = EggRewards.FindAnimalTemplate(v52)
    local v75 = v74 and v74:FindFirstChild("AnimSaves")
    if v75 and not v55[v75] then
        local v76 = false
        local v77
        for v78, v79 in v75:GetChildren() do
            if v79:IsA("KeyframeSequence") then
                v77 = true
                v76 = true
                break
            end
        end
        if not v76 then
            v77 = false
        end
        if v77 then
            v55[v75] = true
            table.insert(v54, v75)
        end
    end
    for v80, v81 in v2 do
        local v82 = ReplicatedStorage:FindFirstChild(v81)
        if v82 ~= nil then
            if v52 then
                local v83 = v82:FindFirstChild(v52)
                if v83 and not v55[v83] then
                    local v84 = false
                    for v85, v86 in v83:GetChildren() do
                        if v86:IsA("KeyframeSequence") then
                            v84 = true
                            break
                        end
                        v84 = false
                    end
                    if v84 then
                        v55[v83] = true
                        table.insert(v54, v83)
                    end
                end
            end
            if v53 then
                local v87 = v82:FindFirstChild(v53.Name)
                if v87 and not v55[v87] then
                    local v88 = false
                    for v89, v90 in v87:GetChildren() do
                        if v90:IsA("KeyframeSequence") then
                            v88 = true
                            break
                        end
                        v88 = false
                    end
                    if v88 then
                        v55[v87] = true
                        table.insert(v54, v87)
                    end
                end
                local v91 = v82:FindFirstChild(v53.Name .. "_Rig")
                if v91 and not v55[v91] then
                    local v92 = false
                    for v93, v94 in v91:GetChildren() do
                        if v94:IsA("KeyframeSequence") then
                            v92 = true
                            break
                        end
                        v92 = false
                    end
                    if v92 then
                        v55[v91] = true
                        table.insert(v54, v91)
                    end
                end
            end
        end
    end
    return v54
end

local function ResolveMesh(v95) -- line 410
    local v96
    local v97 = -1
    for v98, v99 in ipairs(v95:GetDescendants()) do
        if v99:IsA("MeshPart") or v99:IsA("BasePart") then
            local Size = v99.Size
            local v100 = Size.X * Size.Y * Size.Z
            if v97 < v100 then
                v96 = v99
                v97 = v100
            end
        end
    end
    return v96
end

v1.ResolveMesh = ResolveMesh

function v1.new(v101, v102, v103) -- line 426 | captures: WaitFor, v1, resolveAnimator
    local v104 = {}
    local v105 = setmetatable(v104, v1)
    v105._model = v101
    v105._config = v102 or {}
    v105._mesh = v103 or v1.ResolveMesh(v101)
    v105._animator = resolveAnimator(v101)
    v105._tracks = {}
    v105._current = nil
    v105._generation = 0
    v105._repairAttempt = 0
    v105._restartAt = {}
    if v105._animator ~= nil then
        v105:_loadTracks()
        v105._boneArrivals = 0
        local DescendantAdded = v101.DescendantAdded
        v105._boneWatch = DescendantAdded:Connect(function(v106) -- line 453 | captures: v105, WaitFor
            if v106:IsA("Bone") then
                v105._boneArrivals += 1
                if not v105._reloadPending then
                    v105._reloadPending = true
                    task.spawn(function() -- line 462 | captures: v105, WaitFor
                        WaitFor.Stable(function() -- line 469 | captures: v105
                            return v105._boneArrivals
                        end, 3, 1)
                        v105._reloadPending = nil
                        if not v105._destroyed and v105._model.Parent then
                            v105:_reload()
                        end
                    end)
                end
            end
        end)
    end
    return v105
end

local function _reload(v107) -- line 484
    local _current = v107._current
    v107._generation += 1
    local _tracks = v107._tracks
    v107._tracks = {}
    v107._current = nil
    v107._currentTrack = nil
    v107._lastRate = nil
    for v108, v109 in pairs(_tracks) do
        v109:Stop(0)
        v109:Destroy()
    end
    v107._repairAttempt = 0
    v107:_loadTracks()
    if not v107._destroyed and _current == "Idle" then
        v107:PlayIdle()
    end
end

v1._reload = _reload

local function resolveFallbackId(v110) -- line 521 | captures: v3
    for v111, v112 in v110 do
        for v113, v114 in ipairs(v112:GetChildren()) do
            local v115 = v114.Name:lower()
            for v116, v117 in pairs(v3) do
                if string.find(v115, v116:lower(), 1, true) then
                    return v117
                end
            end
        end
    end
    return "rbxassetid://139927001766889"
end

function v1._resolveAnimationId(v118, v119, v120) -- line 535 | captures: EggRewards, KeyframeRegistrar, v1, registerSequence, v26, findSequence, findAnimationInstance, resolveFallbackId
    local v121 = findAnimationInstance(v118._model:FindFirstChild("Animations"), v119)
    local v122
    if v121 == nil then
        local _animalName = v118._animalName
        local v123 = EggRewards.FindAnimalTemplate(_animalName)
        local v124 = v123 and v123:FindFirstChild("Animations")
        v122 = findAnimationInstance(v124, v119)
    else
        v122 = v121
    end
    if v122 then
        return v122.AnimationId
    end
    local v125 = v118._config.Animations and v118._config.Animations[v119]
    if type(v125) == "string" and v125 ~= "" then
        return v125
    end
    local v126 = v118._animalName and v1.AnimationIds[v118._animalName]
    local v127 = v126 and v126[v119]
    if type(v127) ~= "string" or v127 == "" then
        local v128 = false
        for v129, v130 in v120 do
            local v131 = findSequence(v130, v119)
            if v131 ~= nil then
                local v132 = registerSequence(v131)
                if v132 == nil then
                    v128 = true
                else
                    return v132
                end
            end
        end
        if v128 and not KeyframeRegistrar.IsBlocked() then
            local v133 = ("%*_reg_%*"):format(v118._model.Name, v119)
            local v134 = ("[AnimalAnimator] %*: could not register a \"%*\" sequence (will retry)"):format(v118._model.Name, v119)
            if not v26[v133] then
                v26[v133] = true
                warn(v134)
            end
        end
        if v1.UsePublishedFallback then
            return (resolveFallbackId(v120))
        end
        return nil
    end
    return v127
end

function v1._missingClips(v135) -- line 607 | captures: CLIP_KEYWORDS
    local v136 = {}
    for v137 in pairs(CLIP_KEYWORDS) do
        if v135._tracks[v137] == nil then
            table.insert(v136, v137)
        end
    end
    return v136
end

function v1._loadTracks(v138) -- line 619 | captures: v26, resolveAnimSets
    local v139 = v138._model:GetAttribute("AnimalName") or v138._model.Name
    v138._animalName = v139
    local _generation = v138._generation
    local v140 = resolveAnimSets(v138._config, v138._model, v139, v138._mesh)
    for v141, v142 in v138:_missingClips() do
        local v143 = v138:_resolveAnimationId(v142, v140)
        if v138._destroyed then
            return
        end
        if v138._generation == _generation then
            if v143 ~= nil and v138._tracks[v142] == nil then
                local Animation = Instance.new("Animation")
                Animation.Name = v142
                Animation.AnimationId = v143
                local v144, v145 = pcall(function() -- line 643 | captures: v138, Animation
                    return v138._animator:LoadAnimation(Animation)
                end)
                if v144 and v145 then
                    if v138._destroyed then
                        v145:Destroy()
                        return
                    end
                    if v138._generation == _generation then
                        v138._tracks[v142] = v145
                        v138:_watchTrack(v142, v145)
                        if v138._current == v142 then
                            v138:_assert(v142)
                        end
                    else
                        v145:Destroy()
                        return
                    end
                else
                    local v146 = ("%*_load_%*"):format(v138._model.Name, v142)
                    local v147 = ("[AnimalAnimator] %*: failed to load \"%*\""):format(v138._model.Name, v142)
                    if not v26[v146] then
                        v26[v146] = true
                        warn(v147)
                    end
                end
            end
        else
            return
        end
    end
    if v138._generation == _generation and #v138:_missingClips() > 0 then
        v138:_scheduleRepair()
    end
end

function v1._scheduleRepair(v148) -- line 679 | captures: KeyframeRegistrar, v1, v25
    if v148._destroyed or v148._repairPending then
        return
    end
    local v149 = v148._repairAttempt + 1
    if v149 > 10 and KeyframeRegistrar.IsBlocked() and not v1.UsePublishedFallback then
        return
    end
    local v150 = v25[v149] or v25[#v25]
    v148._repairAttempt = v149
    v148._repairPending = true
    task.delay(v150, function() -- line 704 | captures: v148
        v148._repairPending = nil
        if v148._destroyed or #v148:_missingClips() == 0 then
            return
        end
        local v151 = v148._model.Parent == nil
        local v152
        if v151 then
            v148._unparentedRepairs = (v148._unparentedRepairs or 0) + 1
            v152 = v148._unparentedRepairs >= 2
        else
            v148._unparentedRepairs = 0
        end
        if v151 and not v152 or not v151 then
            v148:_loadTracks()
        end
    end)
end

function v1._watchData(v153, v154, v155) -- line 738 | captures: WaitFor
    if not (v155.Length > 0) then
        task.spawn(function() -- line 742 | captures: v153, v154, v155, WaitFor
            WaitFor.Until(function() -- line 747 | captures: v153, v155
                return v153._destroyed or v155.Length > 0
            end, 10)
            if not v153._destroyed and v153._tracks[v154] == v155 then
                v155.Looped = true
                if v153._current == v154 then
                    v153:_assert(v154)
                end
            end
        end)
    end
end

local function _watchTrack(v156, v157, v158) -- line 770
    v156:_watchData(v157, v158)
    v158.Stopped:Connect(function() -- line 772 | captures: v156, v157, v158
        if v156._destroyed or not (v156._current == v157) or not (v156._tracks[v157] == v158) then
            return
        end
        local v159 = os.clock()
        local v160 = (v156._restartAt[v157] or 0) - v159
        local v161 = math.max(v160, 0)
        v156._restartAt[v157] = v159 + v161 + 0.5
        if v161 <= 0 then
            v156:_assert(v157)
        else
            task.delay(v161, function() -- line 787 | captures: v156, v157, v158
                if v156._tracks[v157] == v158 then
                    v156:_assert(v157)
                end
            end)
        end
    end)
end

v1._watchTrack = _watchTrack

local function _assert(v162, v163) -- line 798
    if v162._destroyed or not (v162._current == v163) then
        return
    end
    local v164 = v162._tracks[v163]
    if v164 == nil or v162._model.Parent == nil then
        return
    end
    if not v164.Looped then
        v164.Looped = true
    end
    if v164.IsPlaying then
        return
    end
    v164:Play(0.2)
    v162._currentTrack = v164
    v162._lastRate = nil
    v162._verifyAt = os.clock() + 0.25
end

v1._assert = _assert

local function _switchTo(v165, v166) -- line 824
    local v167 = v165._tracks[v166]
    v165:_stopCurrent()
    v165._current = v166
    if v167 == nil then
        return false
    end
    v167.Looped = true
    v167:AdjustSpeed(1)
    v167:Play(0.2)
    v165._currentTrack = v167
    v165._lastRate = 1
    v165._verifyAt = os.clock() + 0.25
    return true
end

v1._switchTo = _switchTo

local function PlayRun(v168, v169) -- line 843
    local Walk = v168._tracks.Walk
    if Walk == nil then
        v168:PlayIdle()
    else
        local v170 = v169 / (v168._config.AnimationBaseWalkSpeed or 7)
        local v171 = math.max(v170, 0.01)
        if v168._current == "Walk" then
            local v172 = v168._lastRate == nil
            local v173
            if not v172 then
                local v174 = v171 - v168._lastRate
                v173 = math.abs(v174) > 0.02
            end
            if v172 or v173 then
                Walk:AdjustSpeed(v171)
                v168._lastRate = v171
            end
            local v175 = os.clock()
            if (v168._verifyAt or 0) <= v175 then
                v168._verifyAt = v175 + 0.25
                if not Walk.IsPlaying then
                    v168:_assert("Walk")
                    Walk:AdjustSpeed(v171)
                    v168._lastRate = v171
                end
            end
        elseif v168:_switchTo("Walk") then
            Walk:AdjustSpeed(v171)
            v168._lastRate = v171
        end
    end
end

v1.PlayRun = PlayRun

local function PlayIdle(v176) -- line 885
    if v176._current == "Idle" then
        v176:_assert("Idle")
    else
        v176:_switchTo("Idle")
    end
end

v1.PlayIdle = PlayIdle

local function Stop(v177) -- line 900
    v177:_stopCurrent()
    v177._current = nil
end

v1.Stop = Stop

local function _stopCurrent(v178) -- line 905
    if v178._currentTrack then
        v178._currentTrack:Stop(0.2)
    end
    v178._current = nil
    v178._currentTrack = nil
    v178._lastRate = nil
end

v1._stopCurrent = _stopCurrent

local function Destroy(v179) -- line 914
    v179._destroyed = true
    v179._generation += 1
    if v179._boneWatch then
        v179._boneWatch:Disconnect()
        v179._boneWatch = nil
    end
    for v180, v181 in pairs(v179._tracks) do
        v181:Stop(0)
        v181:Destroy()
    end
    v179._tracks = {}
    v179._current = nil
    v179._currentTrack = nil
end

v1.Destroy = Destroy
return v1
