-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

return function(v1, v2) -- line 1
    local Frame = Instance.new("Frame")
    Frame.Name = "Notice"
    Frame.ZIndex = 25
    Frame.AutomaticSize = Enum.AutomaticSize.X
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.BackgroundTransparency = 0.1
    Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame.Visible = false
    Frame.Parent = v1.widget
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Frame
    Instance.new("UIStroke").Parent = Frame
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "NoticeLabel"
    TextLabel.ZIndex = 26
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel.AutomaticSize = Enum.AutomaticSize.X
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.new(0.5, 0, 0.515, 0)
    TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.FontSize = Enum.FontSize.Size14
    TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.Text = "1"
    TextLabel.TextWrapped = true
    TextLabel.TextWrap = true
    TextLabel.Font = Enum.Font.Arial
    TextLabel.Parent = Frame
    local Parent = script.Parent.Parent
    local Packages = Parent.Packages
    local Janitor = require(Packages.Janitor)
    local GoodSignal = require(Packages.GoodSignal)
    local Utility = require(Parent.Utility)
    v1.noticeChanged:Connect(function(v3) -- line 43 | captures: v1, v2, Frame, TextLabel, Utility
        if not v3 then
            return
        end
        local v4 = v3 > 99
        local v5 = if v4 then "99+" else v3
        TextLabel.Text = v5
        if v4 then
            TextLabel.TextSize = 11
        end
        local v6 = not (v3 < 1)
        local v7 = v2.getIconByUID(v1.parentIconUID)
        local v8 = if #v1.dropdownIcons > 0 then true else #v1.menuIcons > 0
        if not v1.isSelected or not v8 then
            if v7 and not v7.isSelected then
                v6 = false
            end
        else
            v6 = false
        end
        Utility.setVisible(Frame, v6, "NoticeHandler")
    end)
    v1.noticeStarted:Connect(function(v9, v10) -- line 71 | captures: v1, v2, Janitor, GoodSignal, Utility
        local v11 = v10
        local v12 = v9 or v1.deselected
        local v13 = v2.getIconByUID(v1.parentIconUID)
        if v13 then
            v13:notify(v12)
        end
        local v14 = v1.janitor:add(Janitor.new())
        local v15 = v14:add(GoodSignal.new())
        local endNotices = v1.endNotices
        v14:add(endNotices:Connect(function() -- line 83 | captures: v15
            v15:Fire()
        end))
        v14:add(v12:Connect(function() -- line 86 | captures: v15
            v15:Fire()
        end))
        local v16 = v10 or Utility.generateUID()
        v11 = v16
        v1.notices[v16] = {
            completeSignal = v15,
            clearNoticeEvent = v12
        }

        local function updateNotice() -- line 94 | captures: v1
            v1.noticeChanged:Fire(v1.totalNotices)
        end

        v1.notified:Fire(v16)
        v1.totalNotices += 1
        v1.noticeChanged:Fire(v1.totalNotices)
        v15:Once(function() -- line 100 | captures: v11, v14, v1
            v14:destroy()
            v1.totalNotices -= 1
            v1.notices[v11] = nil
            v1.noticeChanged:Fire(v1.totalNotices)
        end)
    end)
    Frame:SetAttribute("ClipToJoinedParent", true)
    v1:clipOutside(Frame)
    return Frame
end
