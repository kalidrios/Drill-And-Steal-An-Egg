-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local GroupRewardConfig = require(ReplicatedStorage.Shared.GroupRewardConfig)
local GroupJoinPrompt = require(script.Parent.GroupJoinPrompt)
local NotificationController = require(script.Parent.NotificationController)
local UiFrames = require(script.Parent.UiFrames)
local LocalCharacter = require(script.Parent.Parent.Modules.LocalCharacter)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {}
local v2, v3, Title
local v4 = Color3.new(1, 1, 1)
local v5 = {
    InGroup = false,
    Claimed = false,
    LikeAsked = false,
    LikeWait = 0
}
local v6 = 0

local function currentState() -- line 74 | captures: v5, v6
    local v7 = {
        InGroup = v5.InGroup,
        Claimed = v5.Claimed,
        LikeAsked = v5.LikeAsked
    }
    if v5.LikeAsked then
        local v8 = v6 - os.clock()
        v7.LikeWait = math.max(0, v8)
    else
        v7.LikeWait = 0
    end
    return v7
end

local v9 = false
local v10 = 0
local v11 = (-1/0)
local v12 = (-1/0)
local v13 = (-1/0)
local v14 = (-1/0)
local v15 = (-1/0)

local function fireRemote(v16) -- line 114 | captures: v2
    if v2 then
        v2:FireServer(v16)
    end
end

local function fireClaim() -- line 124 | captures: v2, v12
    local v17 = os.clock()
    if v17 - v12 < 1 then
        return false
    end
    v12 = v17
    if v2 then
        v2:FireServer("Claim")
    end
    return true
end

local function showDenial(v18) -- line 136 | captures: v11, NotificationController
    local v19 = os.clock()
    if v19 - v11 >= 0.6 then
        v11 = v19
        NotificationController.Show(v18, "Error")
    end
end

local v20 = false
local v21 = 0
local v22 = 0
local v23 = false

local function confirmJoin(v24) -- line 163 | captures: v2, v5, v12, v20, v21, v22, v23, GroupRewardConfig
    v21 = os.clock() + GroupRewardConfig.JoinRefreshWait
    v22 = 0
    if v24 then
        v23 = true
    end
    if v20 then
        return
    end
    v20 = true
    while true do
        local v25
        if os.clock() < v21 then
            if v5.InGroup or v5.Claimed then
                v25 = true
            else
                local v26 = os.clock()
                if v22 <= v26 then
                    v22 = os.clock() + GroupRewardConfig.JoinRefreshInterval
                    if v2 then
                        v2:FireServer("Joined")
                    end
                end
                v25 = false
            end
        else
            v25 = true
        end
        if v25 then
            break
        end
        task.wait(0.1)
    end
    v20 = false
    local v27 = v23
    v23 = false
    if not v27 or not v5.InGroup or v5.Claimed then
        return
    end
    local v28 = os.clock()
    if v28 - v12 < 1 then
        return
    end
    v12 = v28
    if v2 then
        v2:FireServer("Claim")
    end
end

local function promptJoin(v29, v30) -- line 205 | captures: v5, v9, v15, GroupRewardConfig, GroupJoinPrompt, confirmJoin
    if not (GroupRewardConfig.GroupId <= 0) and v9 and not v5.InGroup and not v5.Claimed then
        if GroupJoinPrompt.IsMember(GroupRewardConfig.GroupId) then
            task.spawn(confirmJoin, v30)
        else
            if not v29 and os.clock() - v15 < GroupRewardConfig.PromptCooldown then
                return false
            end
            v15 = os.clock()
            task.spawn(function() -- line 223 | captures: v30, GroupRewardConfig, GroupJoinPrompt, confirmJoin
                if GroupJoinPrompt.Prompt(GroupRewardConfig.GroupId) == "Joined" then
                    confirmJoin(v30)
                end
            end)
        end
        return true
    end
    return false
end

local function paint() -- line 236 | captures: v3, Title, v4, v5, GroupRewardConfig, currentState
    if v3 then
        local v31 = GroupRewardConfig.CanClaim((currentState()))
        v3.Active = true
        v3.AutoButtonColor = v31
        local v32 = v3
        if v31 then
            v32.BackgroundColor3 = v4
        else
            v32.BackgroundColor3 = GroupRewardConfig.LockedTint
        end
    end
    if not Title then
        return
    end
    local Title_2 = Title
    if v5.Claimed then
        Title_2.Text = GroupRewardConfig.ClaimedText
    else
        Title_2.Text = GroupRewardConfig.ClaimText
    end
end

local function setupClaim(v33) -- line 263 | captures: v2, v3, Title, v4, v5, v9, v11, v12, v13, v14, GroupRewardConfig, NotificationController, currentState, promptJoin
    local v34 = v33:FindFirstChild(GroupRewardConfig.ClaimButtonName)
    if v34 and v34:IsA("GuiButton") then
        v3 = v34
        v4 = v34.BackgroundColor3
        local Title_2 = v34:FindFirstChild("Title")
        if Title_2 and Title_2:IsA("TextLabel") then
            Title = Title_2
        end
    else
        return
    end
    v34.Activated:Connect(function() -- line 280 | captures: v2, v5, v9, v11, v12, v13, v14, GroupRewardConfig, NotificationController, currentState, promptJoin
        local v35 = os.clock()
        if v35 - v13 < GroupRewardConfig.ClaimDebounce then
            return
        end
        if v5.InGroup and not v5.Claimed and v5.LikeAsked and v35 - v14 < GroupRewardConfig.LikeAskDebounce then
            return
        end
        v13 = v35
        local v36 = GroupRewardConfig.ClaimDenial((currentState()))
        if v36 then
            if not promptJoin(true, true) then
                if v9 and v5.InGroup and not v5.Claimed then
                    local v37 = os.clock()
                    if not (v37 - v12 < 1) then
                        v12 = v37
                        if v2 then
                            v2:FireServer("Claim")
                        end
                    end
                else
                    local v38 = os.clock()
                    if v38 - v11 >= 0.6 then
                        v11 = v38
                        NotificationController.Show(v36, "Error")
                    end
                    if not v5.Claimed and not v5.InGroup and v2 then
                        v2:FireServer("Refresh")
                    end
                end
            end
        else
            local v39 = os.clock()
            if not (v39 - v12 < 1) then
                v12 = v39
                if v2 then
                    v2:FireServer("Claim")
                end
            end
        end
    end)
end

local v40

local function watchHitbox() -- line 343 | captures: v40, RunService, GroupRewardConfig, UiFrames, LocalCharacter
    local v41 = workspace:WaitForChild(GroupRewardConfig.ModelName, 60)
    if v41 then
        for v42, v43 in GroupRewardConfig.HitboxPath do
            v41 = v41 and v41:WaitForChild(v43, 30)
        end
        if v41 and v41:IsA("BasePart") then
            local v44 = v41

            local function isInside() -- line 359 | captures: v44, LocalCharacter
                local v45 = LocalCharacter.GetPosition()
                if v45 then
                    local v46 = v44.CFrame:PointToObjectSpace(v45)
                    local v47 = v44.Size / 2
                    local X = v46.X
                    if math.abs(X) <= v47.X then
                        local Y = v46.Y
                        if math.abs(Y) <= v47.Y then
                            local Z = v46.Z
                            return math.abs(Z) <= v47.Z
                        end
                    end
                    return false
                end
                return false
            end

            local v48 = false
            RunService.Heartbeat:Connect(function() -- line 372 | captures: v48, isInside, v40, UiFrames
                local v49 = isInside()
                if v49 == v48 then
                    return
                end
                v48 = v49
                local v50 = v40
                if v50 then
                    if v49 then
                        UiFrames.Open(v50)
                        return
                    end
                else
                    return
                end
                UiFrames.Close(v50)
            end)
        end
    end
end

local function adopt(v51) -- line 393 | captures: v2, v3, Title, v4, v5, v10, v40, FormatNumber, GroupRewardConfig, UiFrames, currentState, promptJoin, setupClaim
    v3 = nil
    Title = nil
    local Frames = v51:FindFirstChild("Frames")
    local v52 = Frames and Frames:FindFirstChild(GroupRewardConfig.FrameName)
    if v52 and v52:IsA("GuiObject") then
        v40 = v52
        v52.Visible = false
        local v53 = v52:FindFirstChild(GroupRewardConfig.AmountName)
        if v53 and v53:IsA("TextLabel") then
            v53.Text = GroupRewardConfig.AmountText:gsub("{amount}", FormatNumber.Short(GroupRewardConfig.RewardSpeed, 1))
        end
        setupClaim(v52)
        UiFrames.Observe(v52, function(v54) -- line 415 | captures: v2, v10, promptJoin
            if not v54 then
                return
            end
            if v2 then
                v2:FireServer("Refresh")
            end
            local v55 = v10
            task.spawn(function() -- line 425 | captures: v55, v10, promptJoin
                local v56 = os.clock() + 3
                while os.clock() < v56 and v10 == v55 do
                    task.wait(0.1)
                end
                promptJoin(false, false)
            end)
        end)
        if v3 then
            local v57 = GroupRewardConfig.CanClaim((currentState()))
            v3.Active = true
            v3.AutoButtonColor = v57
            local v58 = v3
            if v57 then
                v58.BackgroundColor3 = v4
            else
                v58.BackgroundColor3 = GroupRewardConfig.LockedTint
            end
        end
        if Title then
            local Title_2 = Title
            if v5.Claimed then
                Title_2.Text = GroupRewardConfig.ClaimedText
            else
                Title_2.Text = GroupRewardConfig.ClaimText
            end
        end
    else
        v40 = nil
    end
end

function v1.Start() -- line 438 | captures: v2, v3, Title, v4, v5, v6, v9, v10, v14, ReplicatedStorage, GroupRewardConfig, MainGui, currentState, watchHitbox, adopt
    MainGui.Observe(adopt)
    task.spawn(watchHitbox)
    local v59 = ReplicatedStorage:WaitForChild(GroupRewardConfig.RemoteName, 30)
    if not (v59 and v59:IsA("RemoteEvent")) then
        return
    end
    v2 = v59
    v59.OnClientEvent:Connect(function(v60, v61) -- line 451 | captures: v3, Title, v4, v5, v6, v9, v10, v14, GroupRewardConfig, currentState
        local v62
        if v60 == "State" and typeof(v61) == "table" then
            local LikeWait = v61.LikeWait
            if typeof(LikeWait) == "number" then
                local LikeWait = v61.LikeWait
                v62 = math.max(LikeWait, 0)
            else
                v62 = 0
            end
        else
            return
        end
        local LikeAsked = v5.LikeAsked
        v5 = {
            InGroup = v61.InGroup == true,
            Claimed = v61.Claimed == true,
            LikeAsked = v61.LikeAsked == true,
            LikeWait = v62
        }
        if v5.LikeAsked and not LikeAsked then
            v14 = os.clock()
        end
        v6 = os.clock() + v62
        v9 = true
        v10 += 1
        if v3 then
            local v63 = GroupRewardConfig.CanClaim((currentState()))
            v3.Active = true
            v3.AutoButtonColor = v63
            local v64 = v3
            if v63 then
                v64.BackgroundColor3 = v4
            else
                v64.BackgroundColor3 = GroupRewardConfig.LockedTint
            end
        end
        if Title then
            local Title_2 = Title
            if v5.Claimed then
                Title_2.Text = GroupRewardConfig.ClaimedText
            else
                Title_2.Text = GroupRewardConfig.ClaimText
            end
        end
        if not (v5.LikeAsked and v62 > 0) then
            return
        end
        local v65 = v10
        task.delay(v62 + 0.05, function() -- line 479 | captures: v65, v3, Title, v4, v5, v10, GroupRewardConfig, currentState
            if v10 == v65 then
                if v3 then
                    local v66 = GroupRewardConfig.CanClaim((currentState()))
                    v3.Active = true
                    v3.AutoButtonColor = v66
                    local v67 = v3
                    if v66 then
                        v67.BackgroundColor3 = v4
                    else
                        v67.BackgroundColor3 = GroupRewardConfig.LockedTint
                    end
                end
                if Title then
                    local Title_2 = Title
                    if v5.Claimed then
                        Title_2.Text = GroupRewardConfig.ClaimedText
                    else
                        Title_2.Text = GroupRewardConfig.ClaimText
                    end
                end
            end
        end)
    end)
    if v2 then
        v2:FireServer("Get")
    end
end

return v1
