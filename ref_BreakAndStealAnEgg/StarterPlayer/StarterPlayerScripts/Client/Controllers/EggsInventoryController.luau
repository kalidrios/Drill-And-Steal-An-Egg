-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local AnimalRenders = require(ReplicatedStorage.Shared.AnimalRenders)
local ChaseState = require(ReplicatedStorage.Shared.ChaseState)
local EggTypeConfig = require(ReplicatedStorage.Shared.EggTypeConfig)
local MergeConfig = require(ReplicatedStorage.Shared.MergeConfig)
local UiFrames = require(script.Parent.UiFrames)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local EggGrowthBoostText = require(script.Parent.Parent.Modules.EggGrowthBoostText)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = {}
local v3, v4, v5, v6

local function fireRemote(v7, ...) -- line 75 | captures: ReplicatedStorage, MergeConfig
    local v8 = ReplicatedStorage:FindFirstChild(MergeConfig.RemoteName)
    if v8 and v8:IsA("RemoteEvent") then
        v8:FireServer(v7, ...)
    end
end

local function isMine(v9) -- line 82 | captures: LocalPlayer
    return v9:IsA("Model") and v9:GetAttribute("OwnerUserId") == LocalPlayer.UserId
end

local function readEgg(v10) -- line 88 | captures: MergeConfig
    local v11, v12 = MergeConfig.RemainingSeconds(v10)
    return v11, v12, v10:GetAttribute("Ready") == true
end

local function resortRows() -- line 98 | captures: v2
    local v13 = {}
    for v14, v15 in v2 do
        table.insert(v13, v15)
    end
    table.sort(v13, function(v16, v17) -- line 103
        local function v18(...)
            return (tostring(...))
        end

        local function v19(...)
            return (tostring(...))
        end

        local v20 = v16.Model:GetAttribute("Ready") == true
        if v20 == (v17.Model:GetAttribute("Ready") == true) then
            local v21 = v16.Model:GetAttribute("ReadyAtServerTime") or 0
            local v22 = v17.Model:GetAttribute("ReadyAtServerTime") or 0
            if v21 == v22 then
                return v18(v16.Model:GetAttribute("EggId")) < v19(v17.Model:GetAttribute("EggId"))
            end
            return v21 < v22
        end
        return v20
    end)
    for v23, v24 in v13 do
        v24.Frame.LayoutOrder = v23
    end
end

local function updateRow(v25) -- line 122 | captures: MergeConfig, EggGrowthBoostText
    local Model = v25.Model
    local v26, v27 = MergeConfig.RemainingSeconds(Model)
    local v28 = Model:GetAttribute("Ready") == true
    local v29 = v25.Ready ~= v28
    if v29 then
        v25.Ready = v28
        if v25.Open then
            v25.Open.Visible = v28
        end
        if v25.Timer then
            v25.Timer.Visible = not v28
        end
        if v25.Skip then
            v25.Skip.Visible = not v28
        end
    end
    if not v28 then
        local TimerTitle = v25.TimerTitle
        local v30, v31, v32
        if TimerTitle then
            local v33 = math.ceil(v26)
            v30 = math.max(v33, 0)
            v31 = EggGrowthBoostText.MultiplierFor(v25.Model)
            if v30 == v25.TextSeconds then
                v32 = v31 == v25.TextMultiplier
            else
                v32 = false
            end
        else
            v32 = true
        end
        if not v32 then
            v25.TextSeconds = v30
            v25.TextMultiplier = v31
            local v34 = EggGrowthBoostText.Decorate(TimerTitle, v25.Model, string.lower(MergeConfig.FormatDuration(v26)))
            if v34 ~= v25.Text then
                v25.Text = v34
                TimerTitle.Text = v34
            end
        end
        if v25.Bar and v25.BarY then
            local v35
            if v27 > 0 then
                local v36 = 1 - v26 / v27
                v35 = math.clamp(v36, 0, 1)
            else
                v35 = 1
            end
            local v37 = v35 - (v25.LastProgress or -1)
            if math.abs(v37) > 0.001 then
                v25.LastProgress = v35
                v25.Bar.Position = UDim2.new(v35, 0, v25.BarY.Scale, v25.BarY.Offset)
            end
        end
    end
    return v29
end

local function rowHeightFor(v38, v39) -- line 170
    local v40 = v38.AbsoluteWindowSize.Y * v39.Size.Y.Scale
    local v41 = math.floor(v40)
    return (math.max(v41, 1))
end

local function removeRow(v42) -- line 174 | captures: v2
    local v43 = v2[v42]
    if not v43 then
        return
    end
    v2[v42] = nil
    for v44, v45 in v43.Connections do
        v45:Disconnect()
    end
    v43.Frame:Destroy()
end

local function addRow(v46) -- line 186 | captures: v5, v6, AnimalRenders, EggTypeConfig, LocalPlayer, v2, fireRemote, resortRows, updateRow
    local function v47(v48, ...)
        table.insert(v48, ...)
    end

    local function v49(v50, ...)
        table.insert(v50, ...)
    end

    local v51 = v5
    local v52 = v6
    if v51 then
        local v53, v54
        if v52 then
            if v2[v46] then
                v54 = true
            else
                v53 = v46:IsA("Model") and v46:GetAttribute("OwnerUserId") == LocalPlayer.UserId
                v54 = false
            end
        else
            v54 = true
        end
        if not v54 and v53 then
            local AnimalName = v46:GetAttribute("AnimalName")
            if typeof(AnimalName) == "string" then
                local v55 = v52:Clone()
                v55.Name = "Entry"
                v55.Visible = true
                local new = UDim2.new
                local v56 = v51.AbsoluteWindowSize.Y * v52.Size.Y.Scale
                local v57 = math.floor(v56)
                v55.Size = new(1, 0, 0, (math.max(v57, 1)))
                local Container = v55:FindFirstChild("Container")

                local function child(v58) -- line 204 | captures: Container
                    return Container and Container:FindFirstChild(v58)
                end

                local v59 = EggTypeConfig.Get(v46:GetAttribute(EggTypeConfig.Attribute))
                local v60
                if v59 and v59.Icon then
                    v60 = v59.Icon
                else
                    v60 = AnimalRenders.GetEggImage(AnimalName)
                end
                if v60 == "" then
                    v60 = AnimalRenders.GetImage(AnimalName)
                end
                local v61 = Container and Container:FindFirstChild("EggDisplay")
                if v61 and v61:IsA("ImageLabel") then
                    v61.Image = v60
                    local Inner = v61:FindFirstChild("Inner")
                    if Inner and Inner:IsA("ImageLabel") then
                        Inner.Image = v60
                    end
                end
                local v62 = Container and Container:FindFirstChild("Timer")
                local v63, v64
                if v62 then
                    v63 = v62:FindFirstChild("Title")
                    v64 = v62:FindFirstChild("Bar")
                else
                    v63 = v62
                    v64 = v62
                end
                local v65, v66
                if Container then
                    v65 = Container:FindFirstChild("Open")
                    v66 = Container:FindFirstChild("Skip")
                else
                    v65 = Container
                    v66 = Container
                end
                local v67 = {
                    Ready = nil,
                    Text = nil,
                    OpeningUntil = 0,
                    Model = v46,
                    Frame = v55
                }
                if not (v62 and v62:IsA("GuiObject")) then
                    v62 = nil
                end
                v67.Timer = v62
                if not (v63 and v63:IsA("TextLabel")) then
                    v63 = nil
                end
                v67.TimerTitle = v63
                local v68
                if not (v64 and v64:IsA("GuiObject")) then
                else
                    v68 = v64
                end
                v67.Bar = v68
                local Y
                if not (v64 and v64:IsA("GuiObject")) then
                else
                    Y = v64.Position.Y
                end
                v67.BarY = Y
                local v69
                if not (v65 and v65:IsA("GuiObject")) then
                else
                    v69 = v65
                end
                v67.Open = v69
                local v70
                if not (v66 and v66:IsA("GuiObject")) then
                else
                    v70 = v66
                end
                v67.Skip = v70
                v67.Connections = {}
                if v65 and v65:IsA("GuiButton") then
                    v65.Activated:Connect(function() -- line 246 | captures: v46, v67, fireRemote
                        local v71 = os.clock()
                        if v67.Ready and v67.OpeningUntil <= v71 then
                            v67.OpeningUntil = v71 + 2
                            fireRemote("HatchEgg", v46:GetAttribute("EggId"))
                        end
                    end)
                end
                if v66 and v66:IsA("GuiButton") then
                    v66.Activated:Connect(function() -- line 255 | captures: v46, v67, fireRemote
                        if not v67.Ready then
                            fireRemote("SkipEgg", v46:GetAttribute("EggId"))
                        end
                    end)
                end

                local function onStateChanged() -- line 263 | captures: v67, resortRows, updateRow
                    updateRow(v67)
                    resortRows()
                end

                v47(v67.Connections, v46:GetAttributeChangedSignal("Ready"):Connect(onStateChanged))
                v49(v67.Connections, v46:GetAttributeChangedSignal("ReadyAtServerTime"):Connect(onStateChanged))
                v2[v46] = v67
                updateRow(v67)
                v55.Parent = v51
                resortRows()
            end
        end
    end
end

local function clearRows() -- line 276 | captures: v2
    local v72 = {}
    for v73 in v2 do
        table.insert(v72, v73)
    end
    for v74, v75 in v72 do
        local v76 = v2[v75]
        if v76 then
            v2[v75] = nil
            for v77, v78 in v76.Connections do
                v78:Disconnect()
            end
            v76.Frame:Destroy()
        end
    end
end

local function rebuildRows() -- line 286 | captures: CollectionService, MergeConfig, addRow, clearRows
    clearRows()
    for v79, v80 in CollectionService:GetTagged(MergeConfig.PlacedEggTag) do
        addRow(v80)
    end
end

local function adopt(v81) -- line 297 | captures: v3, v4, v5, v6, CollectionService, ChaseState, MergeConfig, UiFrames, LocalPlayer, v2, fireRemote, resortRows, updateRow, addRow, clearRows
    clearRows()
    v3 = nil
    v4 = nil
    v5 = nil
    v6 = nil
    local v82 = v81:WaitForChild("RightHUD", 10)
    local v83 = v81:WaitForChild("Frames", 10)
    local v84 = v82 and v82:FindFirstChild("Eggs")
    local v85 = v83 and v83:FindFirstChild("EggsInventory")
    local v86, v87
    if v82 and v82:IsA("GuiObject") and v85 and v85:IsA("GuiObject") then
        v86 = v85:FindFirstChild("ScrollingFrame", true)
        v87 = v86 and v86:FindFirstChild("Template")
    else
        return
    end
    if v86 and v86:IsA("ScrollingFrame") and v87 and v87:IsA("Frame") then
        v87.Visible = false
        v85.Visible = false
        v3 = v85
        v4 = v82
        v5 = v86
        v6 = v87
        UiFrames.Observe(v85, function(v88) -- line 328 | captures: v82, ChaseState, LocalPlayer, v2, resortRows, updateRow
            if not ChaseState.IsActive(LocalPlayer) then
                v82.Visible = not v88
            end
            if v88 then
                for v89, v90 in v2 do
                    updateRow(v90)
                end
                resortRows()
            end
        end)
        if v84 and v84:IsA("GuiButton") then
            v84.Activated:Connect(function() -- line 342 | captures: v85, UiFrames
                UiFrames.Open(v85)
            end)
        end
    else
        return
    end
    local TopBar = v85:FindFirstChild("TopBar")
    TopBar = TopBar and (TopBar:FindFirstChild("GrowAll") or TopBar:FindFirstChild("PurchaseMoreEquipped"))
    if TopBar and TopBar:IsA("GuiButton") then
        TopBar.Activated:Connect(function() -- line 353 | captures: fireRemote
            fireRemote("SkipAll")
        end)
    end
    local AbsoluteWindowSize = v86:GetPropertyChangedSignal("AbsoluteWindowSize")
    local v91 = v86
    local v92 = v87
    AbsoluteWindowSize:Connect(function() -- line 359 | captures: v91, v92, v2
        local v93 = v91.AbsoluteWindowSize.Y * v92.Size.Y.Scale
        local v94 = math.floor(v93)
        local v95 = math.max(v94, 1)
        for v96, v97 in v2 do
            v97.Frame.Size = UDim2.new(1, 0, 0, v95)
        end
    end)
    clearRows()
    for v98, v99 in CollectionService:GetTagged(MergeConfig.PlacedEggTag) do
        addRow(v99)
    end
end

function v1.Start() -- line 369 | captures: v3, v4, CollectionService, RunService, ChaseState, MergeConfig, UiFrames, MainGui, LocalPlayer, v2, resortRows, updateRow, removeRow, addRow, adopt
    CollectionService:GetInstanceAddedSignal(MergeConfig.PlacedEggTag):Connect(addRow)
    CollectionService:GetInstanceRemovedSignal(MergeConfig.PlacedEggTag):Connect(removeRow)
    RunService.Heartbeat:Connect(function() -- line 375 | captures: v3, UiFrames, v2, resortRows, updateRow
        local v100 = v3
        if not (v100 and UiFrames.IsOpen(v100)) then
            return
        end
        local v101 = false
        for v102, v103 in v2 do
            if v102.Parent == nil then
                local v104 = v2[v102]
                if v104 then
                    v2[v102] = nil
                    for v105, v106 in v104.Connections do
                        v106:Disconnect()
                    end
                    v104.Frame:Destroy()
                end
            elseif updateRow(v103) then
                v101 = true
            end
        end
        if v101 then
            resortRows()
        end
    end)
    ChaseState.Observe(LocalPlayer, function(v107) -- line 397 | captures: v3, v4, ChaseState, UiFrames, LocalPlayer
        if not v107 then
            task.defer(task.defer, function() -- line 399 | captures: v3, v4, ChaseState, UiFrames, LocalPlayer
                local v108 = v4
                local v109 = v3
                if v108 and v109 and not ChaseState.IsActive(LocalPlayer) and UiFrames.IsOpen(v109) then
                    v108.Visible = false
                end
            end)
        end
    end)
    MainGui.Observe(adopt)
end

return v1
