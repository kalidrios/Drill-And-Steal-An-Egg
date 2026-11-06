-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimalViewport = require(ReplicatedStorage.Shared.AnimalViewport)
local IconViewportConfig = require(ReplicatedStorage.Shared.IconViewportConfig)
local ViewportLighting = require(ReplicatedStorage.Shared.ViewportLighting)
local v1 = {}

v1.__index = v1

local v2 = { "InitialPoses" }

local function overlaps(v3, v4) -- line 65
    local AbsolutePosition = v3.AbsolutePosition
    local AbsolutePosition_2 = v4.AbsolutePosition
    local v5 = AbsolutePosition + v3.AbsoluteSize
    local v6 = AbsolutePosition_2 + v4.AbsoluteSize
    if AbsolutePosition.X < v6.X and AbsolutePosition_2.X < v5.X and AbsolutePosition.Y < v6.Y then
        return AbsolutePosition_2.Y < v5.Y
    end
    return false
end

local function isOnScreen(v7) -- line 73
    local v8 = v7
    while true do
        if v8 then
            if v8:IsA("GuiObject") then
                if v8.Visible then
                    if v8 ~= v7 and (v8:IsA("ScrollingFrame") or v8.ClipsDescendants) then
                        local AbsolutePosition = v7.AbsolutePosition
                        local AbsolutePosition_2 = v8.AbsolutePosition
                        local v9 = AbsolutePosition + v7.AbsoluteSize
                        local v10 = AbsolutePosition_2 + v8.AbsoluteSize
                        if not (AbsolutePosition.X < v10.X and AbsolutePosition_2.X < v9.X and AbsolutePosition.Y < v10.Y and AbsolutePosition_2.Y < v9.Y) then
                            return false
                        end
                    end
                    v8 = v8.Parent
                    continue
                end
                return false
            end
            if v8:IsA("LayerCollector") then
                break
            end
            v8 = v8.Parent
            continue
        end
        return false
    end
    return v8.Enabled and v8:IsDescendantOf(game)
end

local function cameraOf(v11) -- line 94 | captures: IconViewportConfig
    local DefaultCamera = IconViewportConfig.DefaultCamera
    local v12 = {}
    v12.Yaw = v11.Yaw or DefaultCamera.Yaw
    v12.Pitch = v11.Pitch or DefaultCamera.Pitch
    if v11.FlipFacing == nil then
        v12.FlipFacing = DefaultCamera.FlipFacing
    else
        v12.FlipFacing = v11.FlipFacing
    end
    v12.Fov = v11.Fov or DefaultCamera.Fov
    v12.Fill = v11.Fill or DefaultCamera.Fill
    v12.Nudge = v11.Nudge or DefaultCamera.Nudge
    return v12
end

local function findPath(v13, v14) -- line 107
    local v15 = v13
    for v16, v17 in v14 do
        v15 = v15 and v15:FindFirstChild(v17)
    end
    return v15
end

local function alignedBounds(v18, v19) -- line 117
    local v20, v21 = Vector3.new(1, 1, 1) * (1/0), Vector3.new(-1, -1, -1, -0) * (1/0)
    for v22, v23 in v18:GetDescendants() do
        if v23:IsA("BasePart") then
            local v24 = v23.Size / 2
            local v25 = v20
            local v26 = v21
            for v27, v28 in { -1, 1 } do
                local v29 = v25
                local v30 = v26
                for v31, v32 in { -1, 1 } do
                    local v33 = v29
                    local v34 = v30
                    for v35, v36 in { -1, 1 } do
                        local v37 = v19:PointToObjectSpace((v23.CFrame:PointToWorldSpace(v24 * Vector3.new(v28, v32, v36))))
                        v33, v34 = v33:Min(v37), v34:Max(v37)
                        v29 = v33
                        v30 = v34
                    end
                    v25 = v29
                    v26 = v30
                end
                v20 = v25
                v21 = v26
            end
        end
    end
    if v20.X == (1/0) then
        return v18:GetPivot().Position, (Vector3.new(1, 1, 1))
    end
    return v19:PointToWorldSpace((v20 + v21) / 2), v21 - v20
end

local function frameCamera(v38, v39, v40) -- line 143 | captures: alignedBounds
    local v41 = v38.PrimaryPart or v38:FindFirstChildWhichIsA("BasePart", true)
    local v42 = if v41 then v41.CFrame.Rotation else CFrame.identity
    local v43, v44 = alignedBounds(v38, v42)
    local UpVector = v42.UpVector
    local LookVector = v42.LookVector
    local v45 = if v39.FlipFacing then -1 else 1
    local v46 = LookVector * v45
    local Yaw = v39.Yaw
    local v47 = math.rad(Yaw)
    local Pitch = v39.Pitch
    local v48 = math.rad(Pitch)
    local Unit = (CFrame.fromAxisAngle(UpVector, -v47):VectorToWorldSpace(v46) * math.cos(v48) + UpVector * math.sin(v48)).Unit
    local v49 = math.cos(v47)
    local v50 = math.abs(v49) * v44.X
    local v51 = math.sin(v47)
    local v52 = (v50 + math.abs(v51) * v44.Z) / 2
    local v53 = math.cos(v48)
    local v54 = math.abs(v53) * v44.Y
    local v55 = math.sin(v48)
    local v56 = (v54 + math.abs(v55) * v44.Z) / 2
    local v57 = v44.Z / 2
    local Fov = v39.Fov
    local v58 = math.rad(Fov) / 2
    local v59 = math.tan(v58)
    local v60 = v56 / v59
    local v61 = v52 / (v59 * math.max(v40, 0.01))
    local v62 = math.max(v60, v61)
    local Fill = v39.Fill
    local v63 = v62 / math.max(Fill, 0.01) + v57
    local v64 = CFrame.lookAt(v43 + Unit * v63, v43, UpVector)
    local Nudge = v39.Nudge
    if not (Nudge.X == 0 and Nudge.Y == 0) then
        local v65 = 2 * v63 * v59
        v64 -= (v64.RightVector * Nudge.X * v40 + v64.UpVector * Nudge.Y) * v65
    end
    return v64
end

local function prepareClone(v66, v67) -- line 174 | captures: AnimalViewport, v2
    local v68 = AnimalViewport.CloneForViewport(v66)
    local v69
    if v67 then
        v69 = v68:FindFirstChild(v67, true)
    end
    if v69 and v69:IsA("BasePart") then
        v68.PrimaryPart = v69
    end
    for v70, v71 in v2 do
        local v72 = v68:FindFirstChild(v71)
        if v72 then
            v72:Destroy()
        end
    end
    AnimalViewport.PrepareModel(v68)
    local v73 = v68.PrimaryPart or v68:FindFirstChildWhichIsA("BasePart", true)
    if v73 then
        v73.Anchored = true
    end
    return v68
end

local function findAnimator(v74) -- line 198
    local v75 = v74:FindFirstChildWhichIsA("Animator", true)
    if v75 then
        return v75
    end
    local v76 = v74:FindFirstChildWhichIsA("AnimationController") or Instance.new("AnimationController")
    v76.Parent = v74
    local Animator = Instance.new("Animator")
    Animator.Parent = v76
    return Animator
end

local function disableButton(v77, v78) -- line 212
    local v79
    if v78 then
        v79 = v77:FindFirstChild(v78)
    end
    if not (v79 and v79:IsA("GuiButton")) then
        return
    end
    v79:SetAttribute("NoButtonTween", true)
    v79.Active = false
    v79.Interactable = false
    v79.Visible = false
end

local function clearOld(v80) -- line 223
    for v81, v82 in { "IconViewportWorld", "IconViewportCamera" } do
        local v83 = v80:FindFirstChild(v82)
        if v83 then
            v83:Destroy()
        end
    end
end

function v1.Mount(v84, v85, v86) -- line 236 | captures: AnimalViewport, IconViewportConfig, ViewportLighting, v1, cameraOf, prepareClone, clearOld
    local function v87(v88, ...)
        table.insert(v88, ...)
    end

    local function v89(v90, ...)
        table.insert(v90, ...)
    end

    local v91 = {
        _playing = false,
        _destroyed = false,
        _icon = v84,
        _target = v86,
        _camera = cameraOf(v86),
        _framing = v86.Framing or "Fit",
        _name = v85.Name,
        _layers = {},
        _connections = {}
    }
    local v92 = setmetatable(v91, v1)
    local Button = v86.Button
    local v93
    if Button then
        v93 = v84:FindFirstChild(Button)
    end
    if v93 and v93:IsA("GuiButton") then
        v93:SetAttribute("NoButtonTween", true)
        v93.Active = false
        v93.Interactable = false
        v93.Visible = false
    end
    local v94 = { v84 }
    local v95
    if v86.Layer then
        v95 = v84:FindFirstChild(v86.Layer)
    end
    if v95 and v95:IsA("ViewportFrame") then
        table.insert(v94, v95)
    end
    local v96 = v94[#v94]
    local v97
    if v86.Animation then
        v97 = v85
        for v98, v99 in v86.Animation do
            v97 = v97 and v97:FindFirstChild(v99)
        end
        if not (v97 and v97:IsA("Animation")) then
            warn((("[IconViewport] %* has no Animation %* \226\128\148 showing it static"):format(v85:GetFullName(), (table.concat(v86.Animation, ".")))))
            v97 = nil
        end
    end
    for v100, v101 in v94 do
        clearOld(v101)
        local WorldModel = Instance.new("WorldModel")
        WorldModel.Name = "IconViewportWorld"
        local v102 = prepareClone(v85, v86.Primary)
        v102.Parent = WorldModel
        WorldModel.Parent = v101
        local Camera
        if v92._framing == "Animal" then
            Camera = AnimalViewport.AttachCamera(v101, v102, v85.Name, v86.View)
        else
            Camera = Instance.new("Camera")
            Camera.FieldOfView = v92._camera.Fov
            Camera.Parent = v101
            v101.CurrentCamera = Camera
            v101.BackgroundColor3 = IconViewportConfig.EdgeBlendColor
            if v101 == v96 then
                ViewportLighting.Apply(v101)
            end
        end
        Camera.Name = "IconViewportCamera"
        local v103
        if v97 then
            local v104 = v102:FindFirstChildWhichIsA("Animator", true)
            if not v104 then
                local v105 = v102:FindFirstChildWhichIsA("AnimationController") or Instance.new("AnimationController")
                v105.Parent = v102
                v104 = Instance.new("Animator")
                v104.Parent = v105
            end
            v103 = v104:LoadAnimation(v97)
            v103.Looped = true
        end
        local _layers = v92._layers
        local v106 = {
            Viewport = v101,
            World = WorldModel,
            Camera = Camera,
            Model = v102,
            Track = v103
        }
        table.insert(_layers, v106)
    end
    v92:_frame()
    v87(v92._connections, v84:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line 314 | captures: v92
        v92:_frame()
    end))
    v89(v92._connections, v84.Destroying:Connect(function() -- line 317 | captures: v92
        v92:Destroy()
    end))
    for v107, v108 in v92._layers do
        local Track = v108.Track
        if Track then
            v92:_keepLooping(Track)
        end
    end
    v92:_watchVisibility()
    return v92
end

function v1._frame(v109) -- line 334 | captures: frameCamera
    if v109._framing ~= "Fit" then
        return
    end
    local AbsoluteSize = v109._icon.AbsoluteSize
    local v110 = if not (AbsoluteSize.X > 0 and AbsoluteSize.Y > 0) then 1 else AbsoluteSize.X / AbsoluteSize.Y
    for v111, v112 in v109._layers do
        v112.Camera.CFrame = frameCamera(v112.Model, v109._camera, v110)
    end
end

local function _keepLooping(v113, v114) -- line 348
    local function v115(v116, ...)
        table.insert(v116, ...)
    end

    task.spawn(function() -- line 349 | captures: v113, v114
        local v117 = os.clock()
        while not v113._destroyed and v114.Length <= 0 and os.clock() - v117 < 10 do
            task.wait(0.1)
        end
        if not v113._destroyed then
            v114.Looped = true
        end
    end)
    v115(v113._connections, v114.Stopped:Connect(function() -- line 358 | captures: v113
        if v113._playing and not v113._destroyed then
            v113:_play()
        end
    end))
end

v1._keepLooping = _keepLooping

local function _play(v118) -- line 366
    v118._playing = true
    for v119, v120 in v118._layers do
        local Track = v120.Track
        if Track then
            Track.Looped = true
            Track:Play(0)
            Track.TimePosition = 0
        end
    end
end

v1._play = _play

local function _stop(v121) -- line 378
    v121._playing = false
    for v122, v123 in v121._layers do
        if v123.Track then
            v123.Track:Stop(0)
        end
    end
end

v1._stop = _stop

local function _resync(v124) -- line 388
    local Track = v124._layers[#v124._layers].Track
    if Track and Track.IsPlaying then
        for v125, v126 in v124._layers do
            local Track_2 = v126.Track
            if Track_2 and Track_2 ~= Track and Track_2.IsPlaying then
                Track_2.TimePosition = Track.TimePosition
            end
        end
    end
end

v1._resync = _resync

function v1._watchVisibility(v127) -- line 402 | captures: IconViewportConfig, isOnScreen
    task.spawn(function() -- line 403 | captures: v127, IconViewportConfig, isOnScreen
        local v128 = 0
        while true do
            if v127._destroyed then
                break
            end
            local v129
            if isOnScreen(v127._icon) then
                if v127._playing then
                    v129 = v128 + IconViewportConfig.VisibilityCheck
                    if IconViewportConfig.ResyncInterval <= v129 then
                        v127:_resync()
                        v129 = 0
                    end
                else
                    v127:_play()
                    v129 = 0
                end
            else
                if v127._playing then
                    v127:_stop()
                end
                v129 = v128
            end
            task.wait(IconViewportConfig.VisibilityCheck)
            v128 = v129
        end
    end)
end

local function Destroy(v130) -- line 424
    if v130._destroyed then
        return
    end
    v130._destroyed = true
    v130._playing = false
    for v131, v132 in v130._connections do
        v132:Disconnect()
    end
    table.clear(v130._connections)
    for v133, v134 in v130._layers do
        if v134.Track then
            v134.Track:Stop(0)
            v134.Track:Destroy()
        end
        v134.World:Destroy()
        v134.Camera:Destroy()
    end
    table.clear(v130._layers)
end

v1.Destroy = Destroy
return v1
