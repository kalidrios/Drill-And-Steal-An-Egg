-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local GlobalAnnouncementConfig = require(ReplicatedStorage.Shared.GlobalAnnouncementConfig)
local v1 = { TweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) }
local NumberValue = Instance.new("NumberValue")
local BindableEvent = Instance.new("BindableEvent")
local v2 = 0
local v3 = 0
local v4 = 0
local v5, v6
local v7 = {}
local v8 = {}
local v9 = {}
local v10 = false

v1.Changed = NumberValue.Changed
v1.TargetChanged = BindableEvent.Event

function v1.Get() -- line 66 | captures: NumberValue
    return NumberValue.Value
end

function v1.Target() -- line 70 | captures: v2
    return v2
end

local function occupied() -- line 75 | captures: v6
    local v11 = v6
    if v11 and v11.Parent then
        for v12, v13 in v11:GetChildren() do
            if v13:IsA("GuiObject") and v13.Visible then
                return true
            end
        end
    end
    return false
end

local function retarget() -- line 88 | captures: v2, v3, v4, v5, TweenService, v1, NumberValue, BindableEvent, occupied
    local v14
    if v4 > 0 then
        v14 = -v4
    elseif not (v3 > 0 and occupied()) then
        v14 = 0
    else
        v14 = v3
    end
    if v14 == v2 then
        return
    end
    v2 = v14
    if v5 then
        v5:Cancel()
    end
    local v15 = TweenService:Create(NumberValue, v1.TweenInfo, { Value = v14 })
    v5 = v15
    v15:Play()
    BindableEvent:Fire(v14)
end

function v1.Refresh() -- line 108 | captures: retarget
    retarget()
end

function v1.Request(v16) -- line 112 | captures: v3, retarget
    v3 = v16
    retarget()
end

local function Rest(v17) -- line 120
    local MessagesRest = v17:GetAttribute("MessagesRest")
    if typeof(MessagesRest) ~= "UDim2" then
        MessagesRest = v17.Position
        v17:SetAttribute("MessagesRest", MessagesRest)
    end
    return MessagesRest
end

v1.Rest = Rest

function v1.Lifted(v18, v19) -- line 129 | captures: NumberValue
    local v20 = v19 or NumberValue.Value
    return UDim2.new(v18.X.Scale, v18.X.Offset, v18.Y.Scale, v18.Y.Offset - v20)
end

local function restTop(v21, v22) -- line 140
    local Parent = v21.Parent
    if not (Parent and Parent:IsA("GuiBase2d")) then
        return nil
    end
    return Parent.AbsolutePosition.Y + v22.Y.Scale * Parent.AbsoluteSize.Y + v22.Y.Offset - v21.AnchorPoint.Y * v21.AbsoluteSize.Y
end

local function onScreen(v23) -- line 153
    local v24 = v23
    while true do
        if v24 then
            if not v24:IsA("GuiObject") or v24.Visible then
                if v24:IsA("LayerCollector") then
                    return v24.Enabled
                end
                v24 = v24.Parent
                continue
            end
            break
        end
        return false
    end
    return false
end

local function resolve(v25, v26) -- line 166
    local v27 = v25
    for v28, v29 in v26 do
        v27 = v27 and v27:FindFirstChild(v29)
    end
    if not (v27 and v27:IsA("GuiObject")) then
        return nil
    end
    return v27
end

local function measureDrop() -- line 176 | captures: v6, GlobalAnnouncementConfig, v1, onScreen, resolve
    local v30 = v6
    local v31
    if v30 and v30.Parent and v30:IsA("GuiObject") then
        local v32 = v1.Rest(v30)
        local Parent = v30.Parent
        if Parent and Parent:IsA("GuiBase2d") then
            v31 = Parent.AbsolutePosition.Y + v32.Y.Scale * Parent.AbsoluteSize.Y + v32.Y.Offset - v30.AnchorPoint.Y * v30.AbsoluteSize.Y
        end
    else
        return 0
    end
    if v31 then
        local v33
        for v34, v35 in GlobalAnnouncementConfig.DropBelow or {} do
            local v36 = resolve(v30.Parent, v35.Path)
            if v36 and onScreen(v36) then
                local MessagesDropRest = v36:GetAttribute("MessagesDropRest")
                if typeof(MessagesDropRest) ~= "UDim2" then
                    MessagesDropRest = v36.Position
                end
                local Parent = v36.Parent
                local v37 = if Parent and Parent:IsA("GuiBase2d") then Parent.AbsolutePosition.Y + MessagesDropRest.Y.Scale * Parent.AbsoluteSize.Y + MessagesDropRest.Y.Offset - v36.AnchorPoint.Y * v36.AbsoluteSize.Y else nil
                if v37 then
                    local v38 = v33
                    for v39, v40 in v35.Parts do
                        local v41 = v36:FindFirstChild(v40)
                        if v41 and v41:IsA("GuiObject") and v41.Visible then
                            local v42 = v37 + (v41.AbsolutePosition.Y - v36.AbsolutePosition.Y) + v41.AbsoluteSize.Y
                            if v38 then
                                v38 = math.max(v38, v42)
                            else
                                v38 = v42
                            end
                        end
                        v33 = v38
                    end
                end
            end
        end
        if v33 then
            local v43 = v33 + (GlobalAnnouncementConfig.AvoidGap or 0) - v31
            local v44 = math.ceil(v43)
            return (math.max(v44, 0))
        end
    end
    return 0
end

local function refreshDrop() -- line 212 | captures: v4, retarget, measureDrop
    local v45 = measureDrop()
    local v46 = v45 - v4
    if not (math.abs(v46) < 1) then
        v4 = v45
        retarget()
    end
end

local function queueDrop() -- line 223 | captures: v4, v10, retarget, measureDrop
    if not v10 then
        v10 = true
        task.defer(function() -- line 228 | captures: v4, v10, retarget, measureDrop
            v10 = false
            local v47 = measureDrop()
            local v48 = v47 - v4
            if not (math.abs(v48) < 1) then
                v4 = v47
                retarget()
            end
        end)
    end
end

local function watchDrop(v49) -- line 234 | captures: v4, v10, GlobalAnnouncementConfig, v9, retarget, resolve, measureDrop, queueDrop
    local function v50(v51, ...)
        table.insert(v51, ...)
    end

    local function v52(v53, ...)
        table.insert(v53, ...)
    end

    local function v54(...)
        return (typeof(...))
    end

    local function v55(v56, ...)
        table.insert(v56, ...)
    end

    local function v57(v58, ...)
        table.insert(v58, ...)
    end

    local function v59(v60, ...)
        table.insert(v60, ...)
    end

    local function v61(v62, ...)
        table.insert(v62, ...)
    end

    for v63, v64 in v9 do
        v64:Disconnect()
    end
    table.clear(v9)

    local function on(v65) -- line 239 | captures: v9, queueDrop
        local function v66(v67, ...)
            table.insert(v67, ...)
        end

        v66(v9, v65:Connect(queueDrop))
    end

    if v49:IsA("LayerCollector") then
        local Enabled = v49:GetPropertyChangedSignal("Enabled")
        v50(v9, Enabled:Connect(queueDrop))
    end
    if v49:IsA("GuiBase2d") then
        local AbsoluteSize = v49:GetPropertyChangedSignal("AbsoluteSize")
        v52(v9, AbsoluteSize:Connect(queueDrop))
    end
    for v68, v69 in GlobalAnnouncementConfig.DropBelow or {} do
        local v70 = resolve(v49, v69.Path)
        if v70 then
            if v54(v70:GetAttribute("MessagesDropRest")) ~= "UDim2" then
                v70:SetAttribute("MessagesDropRest", v70.Position)
            end
            local Visible = v70:GetPropertyChangedSignal("Visible")
            v55(v9, Visible:Connect(queueDrop))
            local AbsoluteSize = v70:GetPropertyChangedSignal("AbsoluteSize")
            v57(v9, AbsoluteSize:Connect(queueDrop))
            local v71 = v69

            local function hookPart(v72) -- line 259 | captures: v71, v4, v10, v9, retarget, measureDrop, queueDrop
                local function v73(v74, ...)
                    table.insert(v74, ...)
                end

                local function v75(v76, ...)
                    table.insert(v76, ...)
                end

                if not (v72:IsA("GuiObject") and table.find(v71.Parts, v72.Name)) then
                    return
                end
                local Visible = v72:GetPropertyChangedSignal("Visible")
                v73(v9, Visible:Connect(queueDrop))
                local AbsoluteSize = v72:GetPropertyChangedSignal("AbsoluteSize")
                v75(v9, AbsoluteSize:Connect(queueDrop))
                if v10 then
                    return
                end
                v10 = true
                task.defer(function() -- line 228 | captures: v4, v10, retarget, measureDrop
                    v10 = false
                    local v77 = measureDrop()
                    local v78 = v77 - v4
                    if not (math.abs(v78) < 1) then
                        v4 = v77
                        retarget()
                    end
                end)
            end

            for v79, v80 in v70:GetChildren() do
                hookPart(v80)
            end
            v59(v9, v70.ChildAdded:Connect(hookPart))
            local ChildRemoved = v70.ChildRemoved
            v61(v9, ChildRemoved:Connect(queueDrop))
        end
    end
    if not v10 then
        v10 = true
        task.defer(function() -- line 228 | captures: v4, v10, retarget, measureDrop
            v10 = false
            local v81 = measureDrop()
            local v82 = v81 - v4
            if not (math.abs(v82) < 1) then
                v4 = v81
                retarget()
            end
        end)
    end
end

function v1.Watch(v83) -- line 276 | captures: v6, v7, v8, retarget, watchDrop
    local function v84(v85, ...)
        table.insert(v85, ...)
    end

    local function v86(v87, ...)
        table.insert(v87, ...)
    end

    if v6 == v83 then
        return
    end
    for v88, v89 in v7 do
        v89:Disconnect()
    end
    table.clear(v7)
    for v90, v91 in v8 do
        v91:Disconnect()
    end
    table.clear(v8)
    v6 = v83

    local function watchChild(v92) -- line 289 | captures: v8, retarget
        if v92:IsA("GuiObject") and not v8[v92] then
            v8[v92] = v92:GetPropertyChangedSignal("Visible"):Connect(retarget)
        end
    end

    for v93, v94 in v83:GetChildren() do
        if v94:IsA("GuiObject") and not v8[v94] then
            v8[v94] = v94:GetPropertyChangedSignal("Visible"):Connect(retarget)
        end
    end
    v84(v7, v83.ChildAdded:Connect(function(v95) -- line 297 | captures: v8, retarget
        if v95:IsA("GuiObject") and not v8[v95] then
            v8[v95] = v95:GetPropertyChangedSignal("Visible"):Connect(retarget)
        end
        retarget()
    end))
    v86(v7, v83.ChildRemoved:Connect(function(v96) -- line 301 | captures: v8, retarget
        local v97 = v8[v96]
        if v97 then
            v8[v96] = nil
            v97:Disconnect()
        end
        retarget()
    end))
    local Parent = v83.Parent
    if Parent then
        watchDrop(Parent)
    end
    retarget()
end

return v1
