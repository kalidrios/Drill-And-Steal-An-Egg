-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CountingNumber = require(ReplicatedStorage.Shared.CountingNumber)
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local PollConfig = require(ReplicatedStorage.Shared.PollConfig)
local GuiFade = require(script.Parent.Parent.Modules.GuiFade)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local MessagesLift = require(script.Parent.Parent.Modules.MessagesLift)
local GlobalAnnouncementController = require(script.Parent.GlobalAnnouncementController)
local v1 = {}
local v2 = { "Red", "Blue" }
local v3, v4, v5

local function child(v6, v7) -- line 78
    if v6 then
        return (v6:FindFirstChild(v7))
    end
    return nil
end

local function findVotesLabel(v8, v9) -- line 83
    local v10 = v8:FindFirstChild((("%*Votes"):format(v9))) or v8:FindFirstChild(((" %*Votes"):format(v9)))
    if v10 and v10:IsA("TextLabel") then
        return v10
    end
    return nil
end

local function remaining(v11) -- line 88 | captures: Workspace
    local v12 = v11.EndsAt - Workspace:GetServerTimeNow()
    return (math.max(v12, 0))
end

local function questionText(v13) -- line 93 | captures: Workspace
    local State = v13.State
    if State.Ended then
        local v14 = State.Winner and State.Answers[State.Winner]
        if v14 then
            return (("%* - %* wins!"):format(State.Question, v14))
        end
        return (("%* - It's a tie!"):format(State.Question))
    end
    local Question = State.Question
    local v15 = State.EndsAt - Workspace:GetServerTimeNow()
    local v16 = math.max(v15, 0)
    return (("%* (%*s)"):format(Question, (math.ceil(v16))))
end

local function paintChoices(v17, v18) -- line 103 | captures: PollConfig
    for v19, v20 in v17.Buttons do
        local v21 = if v18 == nil then false else v19 ~= v18
        if v21 then
            v20.BackgroundColor3 = v17.ButtonColors[v19]:Lerp(PollConfig.DimColor, PollConfig.DimAmount)
        else
            v20.BackgroundColor3 = v17.ButtonColors[v19]
        end
        local v22 = v17.Labels[v19]
        if v22 then
            if v21 then
                v22.TextColor3 = PollConfig.DimTextColor
            else
                v22.TextColor3 = v17.LabelColors[v19]
            end
        end
    end
end

local function paintCounts(v23, v24) -- line 117 | captures: TweenService, PollConfig
    local Counts = v23.State.Counts
    local v25 = Counts[1]
    local v26 = tonumber(v25) or 0
    local v27 = Counts[2]
    local v28 = v26 + (tonumber(v27) or 0)
    local v29 = if v28 > 0 then v26 / v28 else 0.5
    local v30 = {
        { Size = UDim2.fromScale(v29, 1) },
        { Size = UDim2.fromScale(1 - v29, 1) }
    }
    for v31, v32 in v23.Bars do
        if v24 then
            TweenService:Create(v32, PollConfig.BarTween, v30[v31]):Play()
        else
            v32.Size = v30[v31].Size
        end
    end
    for v33, v34 in v23.Counters do
        local v35 = Counts[v33]
        local v36 = tonumber(v35) or 0
        if v24 then
            v34:Set(v36)
        else
            v34:Snap(v36)
        end
    end
end

local function destroyStrip(v37) -- line 144 | captures: v4
    if v4 == v37 then
        v4 = nil
    end
    for v38, v39 in v37.Counters do
        v39:Snap(v39:Value())
    end
    v37.Frame:Destroy()
end

local function hide(v40, v41) -- line 155 | captures: v4, TweenService, PollConfig, GuiFade, MessagesLift, destroyStrip
    if v40.Hiding then
        return
    end
    v40.Hiding = true
    if v4 == v40 or v4 == nil then
        MessagesLift.Request(0)
    end
    if v41 or not v40.Frame.Parent then
        destroyStrip(v40)
    else
        local v42 = v40.Frame.AbsoluteSize.Y * 0.9
        for v43, v44 in v40.Parts do
            local Rest = v44.Rest
            TweenService:Create(v44.Part, PollConfig.HideTween, { Position = UDim2.new(Rest.X.Scale, Rest.X.Offset, Rest.Y.Scale, Rest.Y.Offset - v42) }):Play()
        end
        GuiFade.Tween(v40.Fade, PollConfig.HideTween, 1)
        task.delay(PollConfig.HideTween.Time, function() -- line 176 | captures: v40, destroyStrip
            destroyStrip(v40)
        end)
    end
end

local function vote(v45, v46) -- line 181 | captures: v4, ReplicatedStorage, Workspace, PollConfig, paintChoices
    if v45.MyVote ~= v46 and not v45.State.Ended and not v45.Voting then
        local v47 = v45.State.EndsAt - Workspace:GetServerTimeNow()
        if not (math.max(v47, 0) <= 0) then
            local v48 = ReplicatedStorage:FindFirstChild(PollConfig.VoteRemote)
            if v48 and v48:IsA("RemoteFunction") then
                local MyVote = v45.MyVote
                v45.Voting = true
                v45.MyVote = v46
                paintChoices(v45, v46)
                local v49, v50 = pcall(function() -- line 194 | captures: v45, v46, v48
                    return v48:InvokeServer(v45.State.Id, v46)
                end)
                v45.Voting = false
                if v49 then
                    if not v50 and v4 == v45 and not v45.State.Ended then
                        v45.MyVote = MyVote
                        paintChoices(v45, MyVote)
                    end
                elseif v4 == v45 and not v45.State.Ended then
                    v45.MyVote = MyVote
                    paintChoices(v45, MyVote)
                end
            end
        end
    end
end

local function show(v51) -- line 206 | captures: v3, v4, RunService, TweenService, CountingNumber, FormatNumber, PollConfig, GuiFade, MessagesLift, GlobalAnnouncementController, v2, questionText, paintChoices, paintCounts, vote
    local v52 = v3
    local v53 = GlobalAnnouncementController.GetHolder()
    local v54, v55
    if v52 and v53 then
        v54 = v52:Clone()
        v54.Name = "ActiveGlobalVote"
        v54.LayoutOrder = -1000
        if v54 then
            v55 = v54:FindFirstChild("Question")
        end
    else
        return nil
    end
    local v56
    if v55 then
        v56 = v55:FindFirstChild("Text")
    end
    local v57
    if v54 then
        v57 = v54:FindFirstChild("ButtonList")
    end
    local v58 = {
        Hiding = false,
        Voting = false,
        Id = v51.Id,
        Frame = v54,
        Parts = {},
        Fade = {}
    }
    if not (v56 and v56:IsA("TextLabel")) then
        v56 = nil
    end
    v58.Question = v56
    v58.Bars = {}
    v58.Counters = {}
    v58.Buttons = {}
    v58.ButtonColors = {}
    v58.Labels = {}
    v58.LabelColors = {}
    v58.State = v51
    v58.MyVote = v51.MyVote
    local v59
    if v54 then
        v59 = v54:FindFirstChild("VoteBar")
    end
    for v60, v61 in v2 do
        local v62 = ("%*Side"):format(v61)
        local v63
        if v59 then
            v63 = v59:FindFirstChild(v62)
        end
        if v63 and v63:IsA("GuiObject") then
            local new = Vector2.new
            local v64 = if v60 == 1 then 0 else 1
            v63.AnchorPoint = new(v64, 0.5)
            local fromScale = UDim2.fromScale
            local v65 = if v60 == 1 then 0 else 1
            v63.Position = fromScale(v65, 0.5)
            v58.Bars[v60] = v63
        end
        local v66 = v54:FindFirstChild((("%*Votes"):format(v61))) or v54:FindFirstChild(((" %*Votes"):format(v61)))
        if not (v66 and v66:IsA("TextLabel")) then
            v66 = nil
        end
        local Counters = v58.Counters
        local new = CountingNumber.new
        local v67 = v66
        Counters[v60] = new(function(v68) -- line 247 | captures: v67, FormatNumber
            if not v67 then
                return
            end
            local Commas = FormatNumber.Commas
            local v69 = v68 + 0.5
            v67.Text = Commas((math.floor(v69)))
        end)
        local v70
        if v57 then
            v70 = v57:FindFirstChild(v61)
        end
        if v70 and v70:IsA("GuiButton") then
            v58.Buttons[v60] = v70
            v58.ButtonColors[v60] = v70.BackgroundColor3
            local v71 = v70:FindFirstChild("Text")
            if not (v71 and v71:IsA("TextLabel")) then
                v71 = nil
            end
            v58.Labels[v60] = v71
            local LabelColors = v58.LabelColors
            if v71 then
                LabelColors[v60] = v71.TextColor3
                v71.Text = v51.Answers[v60] or ""
            else
                LabelColors[v60] = Color3.new(1, 1, 1)
            end
            local Activated = v70.Activated
            local v72 = v60
            Activated:Connect(function() -- line 263 | captures: v58, v72, vote
                task.spawn(vote, v58, v72)
            end)
        end
    end
    for v73, v74 in v54:GetChildren() do
        if v74:IsA("GuiObject") then
            local Parts = v58.Parts
            local v75 = {
                Part = v74,
                Rest = v74.Position
            }
            table.insert(Parts, v75)
        end
    end
    v58.Fade = GuiFade.Capture(v54)
    GuiFade.Set(v58.Fade, 1)
    v54.Visible = true
    v54.Parent = v53
    if v58.Question then
        v58.Question.Text = questionText(v58)
    end
    paintCounts(v58, false)
    paintChoices(v58, v58.MyVote)
    v4 = v58
    MessagesLift.Request(PollConfig.ZoneLift)
    local defer = task.defer
    local v76 = v54
    defer(function() -- line 292 | captures: v58, v76, RunService, TweenService, PollConfig, GuiFade, paintChoices
        RunService.Heartbeat:Wait()
        if v58.Hiding or not v76.Parent then
            return
        end
        local v77 = v76.AbsolutePosition.Y + v76.AbsoluteSize.Y + 36
        for v78, v79 in v58.Parts do
            local Rest = v79.Rest
            v79.Part.Position = UDim2.new(Rest.X.Scale, Rest.X.Offset, Rest.Y.Scale, Rest.Y.Offset - v77)
            TweenService:Create(v79.Part, PollConfig.ShowTween, { Position = Rest }):Play()
        end
        GuiFade.Set(v58.Fade, 0)
        paintChoices(v58, v58.MyVote)
    end)
    return v58
end

local function onState(v80) -- line 309 | captures: v4, v5, PollConfig, MessagesLift, questionText, paintChoices, paintCounts, destroyStrip, hide, show
    local v81, v82
    if type(v80) == "table" then
        local Id = v80.Id
        if type(Id) == "string" then
            local Answers = v80.Answers
            if type(Answers) == "table" then
                v5 = v80
                v81 = v4
                if v81 and v81.Id ~= v80.Id then
                    if not v81.Hiding then
                        v81.Hiding = true
                        if v4 == v81 or v4 == nil then
                            MessagesLift.Request(0)
                        end
                        destroyStrip(v81)
                    end
                    v81 = nil
                end
                v82 = false
            else
                v82 = true
            end
        else
            v82 = true
        end
    else
        v82 = true
    end
    if v82 then
        return
    end
    if v80.Cancelled then
        if v81 then
            hide(v81)
        end
        v5 = nil
    else
        if not v81 then
            if v80.Ended then
                return
            end
            v81 = show(v80)
            if not v81 then
                return
            end
        end
        local Ended = v81.State.Ended
        v81.State = v80
        if v80.MyVote then
            v81.MyVote = v80.MyVote
        end
        paintCounts(v81, true)
        if v81.Question then
            v81.Question.Text = questionText(v81)
        end
        if not v80.Ended or Ended then
            if not v80.Ended then
                paintChoices(v81, v81.MyVote)
            end
        else
            paintChoices(v81, v80.Winner)
            local delay = task.delay
            local ResultTime = PollConfig.ResultTime
            local v83 = v81
            delay(ResultTime, function() -- line 351 | captures: v83, v5, hide
                hide(v83)
                if v5 and v5.Id == v83.Id then
                    v5 = nil
                end
            end)
        end
    end
end

local function adopt(v84) -- line 364 | captures: v3, v4, v5, Workspace, MessagesLift, GlobalAnnouncementController, onState
    v4 = nil
    local Messages = v84:FindFirstChild("Messages")
    local v85 = Messages and Messages:FindFirstChild("GlobalVote")
    if v85 and v85:IsA("GuiObject") then
        v85.Visible = false
        v3 = v85
        local v86 = v5
        if v86 then
            if v86.Ended then
                MessagesLift.Request(0)
            else
                local v87 = v86.EndsAt - Workspace:GetServerTimeNow()
                if not (math.max(v87, 0) > 0) then
                    MessagesLift.Request(0)
                end
            end
        else
            MessagesLift.Request(0)
        end
        if v86 and not v86.Ended then
            local v88 = v86.EndsAt - Workspace:GetServerTimeNow()
            if math.max(v88, 0) > 0 then
                task.spawn(function() -- line 382 | captures: v86, v4, v5, GlobalAnnouncementController, onState
                    for v89 = 1, 50 do
                        if GlobalAnnouncementController.GetHolder() then
                            break
                        end
                        task.wait(0.1)
                    end
                    if v5 == v86 and not v4 then
                        onState(v86)
                    end
                end)
            end
        end
    else
        warn("[PollController] MainGUI.Messages.GlobalVote missing")
        v3 = nil
    end
end

function v1.Start() -- line 396 | captures: v4, ReplicatedStorage, PollConfig, MainGui, questionText, onState, adopt
    MainGui.Observe(adopt)
    task.spawn(function() -- line 400 | captures: v4, questionText
        while true do
            local v90 = v4
            if v90 and v90.Question and not v90.State.Ended and not v90.Hiding then
                v90.Question.Text = questionText(v90)
            end
            task.wait(0.2)
        end
    end)
    ReplicatedStorage:WaitForChild(PollConfig.StateRemote).OnClientEvent:Connect(onState)
end

return v1
