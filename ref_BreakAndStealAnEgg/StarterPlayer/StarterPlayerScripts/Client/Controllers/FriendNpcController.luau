-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SocialService = game:GetService("SocialService")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local v1 = require(Shared:WaitForChild("CollisionGroups"))
local v2 = require(Shared:WaitForChild("FriendNpcConfig"))
local v3 = {}
local LocalPlayer = Players.LocalPlayer
local v4 = Random.new()
local Folder, v5, Id, v6
local v7 = 0
local v8 = CFrame.new(v2.Position)
local Angles = CFrame.Angles
local OrientationY = v2.OrientationY
local v9 = v8 * Angles(0, math.rad(OrientationY), 0)
local OrientationY_2 = v2.OrientationY
local v10 = math.rad(OrientationY_2)

local function isDeletedAccount(v11, v12) -- line 81
    for v13, v14 in { v11, v12 } do
        if type(v14) == "string" then
            local v15 = v14:lower()
            if v15:find("account deleted", 1, true) or v15:find("content deleted", 1, true) or v15:match("^%[?deleted") or v15:match("^%d+_deleted$") then
                return true
            end
        end
    end
    return false
end

local v16 = {}

local function warnOnce(v17, v18) -- line 100 | captures: v16
    if not v16[v17] then
        v16[v17] = true
        warn(v18)
    end
end

local function onlineFriends() -- line 107 | captures: v2, LocalPlayer, isDeletedAccount, v16
    local v19 = {}
    local v20, v21 = pcall(function() -- line 109 | captures: v2, LocalPlayer
        return LocalPlayer:GetFriendsOnline(v2.MaxFriendsToFetch)
    end)
    if v20 then
        if type(v21) == "table" then
            for v22, v23 in v21 do
                local v24 = v23.VisitorId or v23.Id
                if type(v24) == "number" and not isDeletedAccount(v23.UserName, v23.DisplayName) then
                    local v25 = {
                        Id = v24,
                        Name = v23.UserName or "Friend"
                    }
                    v25.DisplayName = v23.DisplayName or v23.UserName or "Friend"
                    table.insert(v19, v25)
                end
            end
        end
    else
        local v26 = ("[FriendNpcController] GetFriendsOnline failed: %*"):format(v21)
        if not v16.online then
            v16.online = true
            warn(v26)
        end
    end
    return v19
end

local function anyFriends() -- line 132 | captures: Players, LocalPlayer, isDeletedAccount, v16
    local v27 = {}
    local v28, v29 = pcall(function() -- line 134 | captures: Players, LocalPlayer
        return Players:GetFriendsAsync(LocalPlayer.UserId)
    end)
    if not v28 or not v29 then
        local v30 = ("[FriendNpcController] GetFriendsAsync failed: %*"):format(v29)
        if not v16.any then
            v16.any = true
            warn(v30)
        end
    else
        local v31, v32 = pcall(function() -- line 141 | captures: v29
            return v29:GetCurrentPage()
        end)
        if v31 and type(v32) == "table" then
            for v33, v34 in v32 do
                local Id = v34.Id
                if type(Id) == "number" and not isDeletedAccount(v34.Username, v34.DisplayName) then
                    local v35 = {
                        Id = v34.Id,
                        Name = v34.Username or "Friend"
                    }
                    v35.DisplayName = v34.DisplayName or v34.Username or "Friend"
                    table.insert(v27, v35)
                end
            end
        end
    end
    return v27
end

local function removeFriendsInServer(v36) -- line 160 | captures: Players
    local v37 = {}
    for v38, v39 in Players:GetPlayers() do
        v37[v39.UserId] = true
    end
    local v40 = {}
    for v41, v42 in v36 do
        if not v37[v42.Id] then
            table.insert(v40, v42)
        end
    end
    return v40
end

local function fallbackFriend() -- line 179 | captures: Id, v2
    if v2.FallbackUserId == Id then
        return nil
    end
    return {
        Id = v2.FallbackUserId,
        Name = v2.FallbackUsername,
        DisplayName = v2.FallbackDisplayName
    }
end

local v43 = {}
local v44 = 0

local function noteShown(v45) -- line 198 | captures: v44, v43
    if not v43[v45] then
        v43[v45] = true
        v44 += 1
    end
end

local function buildPool() -- line 209 | captures: v44, v2, onlineFriends, anyFriends, removeFriendsInServer, v43
    local v46 = removeFriendsInServer((onlineFriends()))
    if #v46 == 0 then
        v46 = removeFriendsInServer((anyFriends()))
    end
    local MaxDistinctFriendsPerSession = v2.MaxDistinctFriendsPerSession
    local v47
    if MaxDistinctFriendsPerSession and MaxDistinctFriendsPerSession <= v44 then
        v47 = {}
        for v48, v49 in v46 do
            if v43[v49.Id] then
                table.insert(v47, v49)
            end
        end
    else
        v47 = v46
    end
    return v47
end

local function setNoCollide(v50) -- line 241 | captures: v1
    local function tag(v51) -- line 242 | captures: v1
        if v51:IsA("BasePart") then
            v51.CollisionGroup = v1.Players
        end
    end

    for v52, v53 in v50:GetDescendants() do
        if v53:IsA("BasePart") then
            v53.CollisionGroup = v1.Players
        end
    end
    v50.DescendantAdded:Connect(tag)
end

local function addOverhead(v54) -- line 255 | captures: ReplicatedStorage, v2
    local v55 = ReplicatedStorage:FindFirstChild(v2.OverheadTemplate)
    if v55 then
        local Head = v54:FindFirstChild("Head")
        local v56 = v55:Clone()
        if not (Head and Head:IsA("BasePart")) then
            Head = v54.PrimaryPart
        end
        v56.Parent = Head
    else
        warn((("[FriendNpcController] '%*' template missing from ReplicatedStorage"):format(v2.OverheadTemplate)))
    end
end

local function startWaving(v57, v58) -- line 272 | captures: v2
    local Animator = v57:FindFirstChildOfClass("Animator")
    local Animator_2 = Animator
    if not Animator then
        Animator = Instance.new("Animator")
        Animator_2 = Animator
        Animator.Parent = v57
    end

    local function loadTrack(v59) -- line 279 | captures: Animator_2, v57
        local Animation = Instance.new("Animation")
        Animation.AnimationId = v59
        Animation.Parent = v57
        return Animator_2:LoadAnimation(Animation)
    end

    local IdleAnimation = v2.IdleAnimation
    local Animation = Instance.new("Animation")
    Animation.AnimationId = IdleAnimation
    Animation.Parent = v57
    local v60 = Animator_2:LoadAnimation(Animation)
    v60.Looped = true
    v60.Priority = Enum.AnimationPriority.Idle
    v60:Play(0.2)
    local WaveAnimation = v2.WaveAnimation
    local Animation_2 = Instance.new("Animation")
    Animation_2.AnimationId = WaveAnimation
    Animation_2.Parent = v57
    local v61 = Animator_2:LoadAnimation(Animation_2)
    v61.Looped = false
    v61.Priority = Enum.AnimationPriority.Action
    task.spawn(function() -- line 295 | captures: v58, v61, v2
        while true do
            if v58.Parent == nil then
                break
            end
            v61:Play(0.2)
            task.wait(v2.WaveIntervalSeconds)
        end
    end)
end

local function promptInvite() -- line 307 | captures: SocialService, LocalPlayer
    local v62, v63 = pcall(function() -- line 308 | captures: SocialService, LocalPlayer
        SocialService:PromptGameInvite(LocalPlayer)
    end)
    if not v62 then
        warn((("[FriendNpcController] invite prompt failed: %*"):format(v63)))
    end
end

local function startInviteZone(v64) -- line 316 | captures: RunService, SocialService, v2, LocalPlayer
    local v65 = false
    RunService.Heartbeat:Connect(function() -- line 318 | captures: v65, v64, SocialService, v2, LocalPlayer
        local Character = LocalPlayer.Character
        local v66 = Character and Character:FindFirstChild("HumanoidRootPart")
        if v66 and v66:IsA("BasePart") then
            local v67 = v64.CFrame:PointToObjectSpace(v66.Position)
            local v68 = v64.Size / 2
            local X = v67.X
            local v69
            if math.abs(X) <= v68.X then
                local Z = v67.Z
                if math.abs(Z) <= v68.Z then
                    local Y = v67.Y
                    v69 = math.abs(Y) <= v68.Y + v2.HitboxVerticalSlack
                else
                    v69 = false
                end
            else
                v69 = false
            end
            if not v69 or v65 then
                if not v69 then
                    v65 = false
                end
            else
                v65 = true
                local v70, v71 = pcall(function() -- line 308 | captures: SocialService, LocalPlayer
                    SocialService:PromptGameInvite(LocalPlayer)
                end)
                if not v70 then
                    warn((("[FriendNpcController] invite prompt failed: %*"):format(v71)))
                end
            end
        else
            v65 = false
        end
    end)
end

local function startLookAt(v72) -- line 348 | captures: v10, RunService, v2, LocalPlayer
    local v73 = v10
    local v74 = v2.LookRadius * v2.LookRadius
    return RunService.RenderStepped:Connect(function(v75) -- line 352 | captures: v73, v72, v74, v10, v2, LocalPlayer
        local v76 = v10
        local Character = LocalPlayer.Character
        local v77 = Character and Character:FindFirstChild("HumanoidRootPart")
        if v77 and v77:IsA("BasePart") then
            local v78 = v77.Position - v72.Position
            local v79 = v78.X * v78.X + v78.Z * v78.Z
            if v79 <= v74 and v79 > 0.001 then
                local v80 = -v78.X
                local v81 = -v78.Z
                v76 = math.atan2(v80, v81)
            end
        end
        local v82 = (v76 - v73 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
        if math.abs(v82) < 0.005 then
            if v73 ~= v76 then
                v73 = v76
                v72.CFrame = CFrame.new(v72.Position) * CFrame.Angles(0, v73, 0)
            end
        else
            local v83 = v73
            local v84 = -v2.LookSpeed * v75
            v73 = v83 + v82 * (1 - math.exp(v84))
            v72.CFrame = CFrame.new(v72.Position) * CFrame.Angles(0, v73, 0)
        end
    end)
end

local function spawnFriendNpc(v85) -- line 384 | captures: Folder, v5, Id, v6, v7, v9, v10, v44, Players, RunService, v2, LocalPlayer, v43, setNoCollide, addOverhead, startWaving
    v7 += 1
    local v86 = v7
    local v87, v88 = pcall(function() -- line 389 | captures: v85, Players
        local v89 = Players:GetHumanoidDescriptionFromUserId(v85.Id)
        return Players:CreateHumanoidModelFromDescription(v89, Enum.HumanoidRigType.R15)
    end)
    if not v87 or not v88 then
        warn((("[FriendNpcController] failed to build avatar for %* (%*): %*"):format(v85.Name, v85.Id, v88)))
    else
        if v86 == v7 then
            v88.Name = "FriendNpc"
            local Humanoid = v88:FindFirstChildOfClass("Humanoid")
            local HumanoidRootPart = v88:FindFirstChild("HumanoidRootPart")
            if Humanoid and HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                setNoCollide(v88)
                v88.PrimaryPart = HumanoidRootPart
                v88:SetPrimaryPartCFrame(v9 + Vector3.new(0, 3, 0))
                if v6 then
                    v6()
                    v6 = nil
                end
                if v5 then
                    v5:Destroy()
                end
                v5 = v88
                Id = v85.Id
                local Id_2 = v85.Id
                if not v43[Id_2] then
                    v43[Id_2] = true
                    v44 += 1
                end
                v88.Parent = Folder
                addOverhead(v88)
                local v90 = v10
                local v91 = v2.LookRadius * v2.LookRadius
                local v92 = RunService.RenderStepped:Connect(function(v93) -- line 352 | captures: v90, HumanoidRootPart, v91, v10, v2, LocalPlayer
                    local v94 = v10
                    local Character = LocalPlayer.Character
                    local v95 = Character and Character:FindFirstChild("HumanoidRootPart")
                    if v95 and v95:IsA("BasePart") then
                        local v96 = v95.Position - HumanoidRootPart.Position
                        local v97 = v96.X * v96.X + v96.Z * v96.Z
                        if v97 <= v91 and v97 > 0.001 then
                            local v98 = -v96.X
                            local v99 = -v96.Z
                            v94 = math.atan2(v98, v99)
                        end
                    end
                    local v100 = (v94 - v90 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
                    if math.abs(v100) < 0.005 then
                        if v90 ~= v94 then
                            v90 = v94
                            HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position) * CFrame.Angles(0, v90, 0)
                        end
                    else
                        local v101 = v90
                        local v102 = -v2.LookSpeed * v93
                        v90 = v101 + v100 * (1 - math.exp(v102))
                        HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position) * CFrame.Angles(0, v90, 0)
                    end
                end)

                function v6() -- line 441 | captures: v92
                    v92:Disconnect()
                end

                startWaving(Humanoid, v88)
                return true
            end
        end
        v88:Destroy()
    end
    return false
end

local function spawnFromPool(v103) -- line 452 | captures: v5, Id, v2, v4, spawnFriendNpc
    if #v103 == 1 and v103[1].Id == Id and v5 and v5.Parent then
        return true
    end
    if Id and #v103 > 1 then
        local v104 = #v103
        for v105 = v104, 1, -1 do
            if v103[v105].Id == Id then
                table.remove(v103, v105)
            end
        end
    end
    local v106 = #v103
    local MaxSpawnAttempts = v2.MaxSpawnAttempts
    local v107 = math.min(v106, MaxSpawnAttempts)
    for v108 = 1, v107 do
        local v109 = table.remove(v103, v4:NextInteger(1, #v103))
        if spawnFriendNpc(v109) then
            return true
        end
    end
    return false
end

local function waitForPlaceholder(v110) -- line 490 | captures: v2
    local v111 = os.clock() + v110
    local v112
    while true do
        v112 = workspace:FindFirstChild(v2.PlaceholderFolder, true)
        if v112 then
            break
        end
        if v111 <= os.clock() then
            return nil
        end
        task.wait(0.5)
    end
    return v112
end

local function consumePlaceholder() -- line 504 | captures: v9, v10, v2, waitForPlaceholder
    local v113 = waitForPlaceholder(15)
    if v113 then
        local v114 = v113:WaitForChild(v2.PlaceholderRig, 5)
        if v114 and v114:IsA("Model") then
            local v115 = v114:GetPivot()
            v9 = v115
            local LookVector = v115.LookVector
            local v116 = -LookVector.X
            local v117 = -LookVector.Z
            v10 = math.atan2(v116, v117)
            v114:Destroy()
        end
        local v118 = v113:FindFirstChild(v2.HitboxName, true)
        if v118 and v118:IsA("BasePart") then
            return v118
        end
        warn((("[FriendNpcController] '%*' part not found in %* \226\128\148 invite touch zone disabled"):format(v2.HitboxName, v113.Name)))
    else
        warn((("[FriendNpcController] placeholder '%*' not found \226\128\148 using config fallback spot"):format(v2.PlaceholderFolder)))
    end
    return nil
end

function v3.Start() -- line 534 | captures: Folder, v5, Id, Players, RunService, SocialService, v2, LocalPlayer, v16, buildPool, spawnFriendNpc, spawnFromPool, consumePlaceholder
    local v119 = consumePlaceholder()
    if v119 then
        local v120 = false
        RunService.Heartbeat:Connect(function() -- line 318 | captures: v120, v119, SocialService, v2, LocalPlayer
            local Character = LocalPlayer.Character
            local v121 = Character and Character:FindFirstChild("HumanoidRootPart")
            if v121 and v121:IsA("BasePart") then
                local v122 = v119.CFrame:PointToObjectSpace(v121.Position)
                local v123 = v119.Size / 2
                local X = v122.X
                local v124
                if math.abs(X) <= v123.X then
                    local Z = v122.Z
                    if math.abs(Z) <= v123.Z then
                        local Y = v122.Y
                        v124 = math.abs(Y) <= v123.Y + v2.HitboxVerticalSlack
                    else
                        v124 = false
                    end
                else
                    v124 = false
                end
                if not v124 or v120 then
                    if not v124 then
                        v120 = false
                    end
                else
                    v120 = true
                    local v125, v126 = pcall(function() -- line 308 | captures: SocialService, LocalPlayer
                        SocialService:PromptGameInvite(LocalPlayer)
                    end)
                    if not v125 then
                        warn((("[FriendNpcController] invite prompt failed: %*"):format(v126)))
                    end
                end
            else
                v120 = false
            end
        end)
    end
    local Folder_2 = Instance.new("Folder")
    Folder_2.Name = "FriendNpc"
    Folder_2.Parent = workspace
    Folder = Folder_2
    Players.PlayerAdded:Connect(function(v127) -- line 547 | captures: Id, v2, buildPool, spawnFriendNpc, spawnFromPool
        if Id and v127.UserId == Id then
            task.spawn(function() -- line 549 | captures: Id, v2, buildPool, spawnFriendNpc, spawnFromPool
                if not spawnFromPool((buildPool())) then
                    local v128
                    if v2.FallbackUserId == Id then
                    else
                        v128 = {
                            Id = v2.FallbackUserId,
                            Name = v2.FallbackUsername,
                            DisplayName = v2.FallbackDisplayName
                        }
                    end
                    if v128 then
                        spawnFriendNpc(v128)
                    end
                end
            end)
        end
    end)
    task.spawn(function() -- line 562 | captures: v5, Id, v2, v16, buildPool, spawnFriendNpc, spawnFromPool
        while true do
            local v129 = buildPool()
            local v130 = #v129 > 0
            local v131 = spawnFromPool(v129)
            local v132, v133
            if v131 then
                v133 = true
            elseif v5 == nil then
                if v2.FallbackUserId == Id then
                else
                    v132 = {
                        Id = v2.FallbackUserId,
                        Name = v2.FallbackUsername,
                        DisplayName = v2.FallbackDisplayName
                    }
                end
                v133 = false
            else
                v133 = true
            end
            if not v133 and v132 then
                local v134 = "[FriendNpcController] showing fallback account \226\128\148 %*"
                local v135 = if v130 then "every attempted friend avatar failed to build" else "Roblox returned no usable friends (see warnings above, if any)"
                local v136 = v134:format(v135)
                if not v16.fallback then
                    v16.fallback = true
                    warn(v136)
                end
                spawnFriendNpc(v132)
            end
            if v131 then
                task.wait(v2.SwitchIntervalSeconds)
            elseif v130 or not (Id == v2.FallbackUserId) then
                task.wait(v2.EmptyRetrySeconds)
            else
                task.wait(v2.SwitchIntervalSeconds)
            end
        end
    end)
end

return v3
