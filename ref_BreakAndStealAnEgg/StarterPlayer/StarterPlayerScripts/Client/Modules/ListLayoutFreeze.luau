-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}
local v2 = Vector2.new(0.5, 0.5)
local v3 = { "UIAspectRatioConstraint", "UISizeConstraint" }

local function copySizeConstraints(v4, v5) -- line 43 | captures: v3
    for v6, v7 in v4:GetChildren() do
        for v8, v9 in v3 do
            if v7.ClassName == v9 then
                v7:Clone().Parent = v5
            end
        end
    end
end

local function syncStandIn(v10, v11) -- line 53
    v11.Size = v10.Size
    v11.SizeConstraint = v10.SizeConstraint
    v11.LayoutOrder = v10.LayoutOrder
    v11.Name = v10.Name
    v11.Visible = v10.Visible
end

function v1.Freeze(v12, v13) -- line 61 | captures: v2, copySizeConstraints
    local Frame = Instance.new("Frame")
    Frame.Name = "ListLayoutFreezeRig"
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.Active = false
    Frame.Selectable = false
    local UIPadding = v12:FindFirstChildOfClass("UIPadding")
    if UIPadding then
        UIPadding:Clone().Parent = Frame
    end
    local v14 = {}
    local v15 = {}

    local function makeStandIn(v16) -- line 77 | captures: Frame, v14, copySizeConstraints
        local Frame_2 = Instance.new("Frame")
        Frame_2.BackgroundTransparency = 1
        Frame_2.Active = false
        Frame_2.Selectable = false
        Frame_2.AnchorPoint = v16.AnchorPoint
        copySizeConstraints(v16, Frame_2)
        Frame_2.Size = v16.Size
        Frame_2.SizeConstraint = v16.SizeConstraint
        Frame_2.LayoutOrder = v16.LayoutOrder
        Frame_2.Name = v16.Name
        Frame_2.Visible = v16.Visible
        Frame_2.Parent = Frame
        v14[v16] = Frame_2
    end

    for v17, v18 in v12:GetChildren() do
        if v18:IsA("GuiObject") then
            local Frame_2 = Instance.new("Frame")
            Frame_2.BackgroundTransparency = 1
            Frame_2.Active = false
            Frame_2.Selectable = false
            Frame_2.AnchorPoint = v18.AnchorPoint
            copySizeConstraints(v18, Frame_2)
            Frame_2.Size = v18.Size
            Frame_2.SizeConstraint = v18.SizeConstraint
            Frame_2.LayoutOrder = v18.LayoutOrder
            Frame_2.Name = v18.Name
            Frame_2.Visible = v18.Visible
            Frame_2.Parent = Frame
            v14[v18] = Frame_2
        end
    end
    local AbsolutePosition = v12.AbsolutePosition
    local AbsoluteSize = v12.AbsoluteSize
    for v19 in v14 do
        local v20 = v19.AbsolutePosition + v19.AbsoluteSize / 2
        v19.AnchorPoint = v2
        v19.Position = UDim2.fromScale((v20.X - AbsolutePosition.X) / AbsoluteSize.X, (v20.Y - AbsolutePosition.Y) / AbsoluteSize.Y)
    end
    v13.Parent = Frame
    Frame.Parent = v12

    local function pin() -- line 112 | captures: v12, Frame, v14, v2
        local AbsoluteSize = Frame.AbsoluteSize
        if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
            return
        end
        local AbsolutePosition = v12.AbsolutePosition
        local AbsoluteSize_2 = v12.AbsoluteSize
        for v21, v22 in v14 do
            if v21.Parent == v12 and v21.Visible then
                local v23 = v22.AbsolutePosition + v22.AbsoluteSize / 2
                v21.AnchorPoint = v2
                v21.Position = UDim2.fromScale((v23.X - AbsolutePosition.X) / AbsoluteSize_2.X, (v23.Y - AbsolutePosition.Y) / AbsoluteSize_2.Y)
            end
        end
    end

    local v24 = false

    local function relayout() -- line 135 | captures: v24, v12, Frame, v14, pin
        for v25, v26 in v14 do
            if v25.Parent == v12 then
                v26.Size = v25.Size
                v26.SizeConstraint = v25.SizeConstraint
                v26.LayoutOrder = v25.LayoutOrder
                v26.Name = v25.Name
                v26.Visible = v25.Visible
            else
                v26.Visible = false
            end
        end
        if not v24 then
            v24 = true
            task.defer(function() -- line 147 | captures: v24, v12, Frame, pin
                task.wait()
                v24 = false
                if v12.Parent ~= nil and Frame.Parent == v12 then
                    pin()
                end
            end)
        end
    end

    local function watch(v27) -- line 156 | captures: v15, relayout
        v15[v27] = {
            v27:GetPropertyChangedSignal("Visible"):Connect(relayout),
            v27:GetPropertyChangedSignal("Size"):Connect(relayout)
        }
    end

    for v28 in v14 do
        watch(v28)
    end
    v12.ChildAdded:Connect(function(v29) -- line 168 | captures: Frame, v14, relayout, watch, copySizeConstraints
        if not (v29 ~= Frame) or not v29:IsA("GuiObject") or v14[v29] then
            return
        end
        local Frame_2 = Instance.new("Frame")
        Frame_2.BackgroundTransparency = 1
        Frame_2.Active = false
        Frame_2.Selectable = false
        Frame_2.AnchorPoint = v29.AnchorPoint
        copySizeConstraints(v29, Frame_2)
        Frame_2.Size = v29.Size
        Frame_2.SizeConstraint = v29.SizeConstraint
        Frame_2.LayoutOrder = v29.LayoutOrder
        Frame_2.Name = v29.Name
        Frame_2.Visible = v29.Visible
        Frame_2.Parent = Frame
        v14[v29] = Frame_2
        watch(v29)
        relayout()
    end)
    v12.ChildRemoved:Connect(function(v30) -- line 176 | captures: v14, v15, relayout
        local v31 = v14[v30]
        if not v31 then
            return
        end
        v14[v30] = nil
        for v32, v33 in v15[v30] or {} do
            v33:Disconnect()
        end
        v15[v30] = nil
        v31:Destroy()
        relayout()
    end)
    v12:GetPropertyChangedSignal("Visible"):Connect(relayout)
    relayout()
end

return v1
