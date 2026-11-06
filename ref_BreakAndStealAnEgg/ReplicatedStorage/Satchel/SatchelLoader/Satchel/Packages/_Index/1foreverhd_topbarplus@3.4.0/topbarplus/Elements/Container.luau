-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = false
local v2 = 0
return function(v3) -- line 3 | captures: v1, v2
    local GuiService = game:GetService("GuiService")
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local v4 = {}
    local v5 = require(script.Parent.Parent.Packages.GoodSignal).new()
    local v6 = GuiService:GetGuiInset()
    local v7 = 0
    local v8 = 0
    local v9 = 0
    local v10 = 0
    local v11 = false
    local v12 = false
    local checkInset

    local function checkInset_2(v13) -- line 20 | captures: v6, v7, v8, v9, v10, v11, v12, v3, GuiService, Players, UserInputService, v5, checkInset, v1, v2
        local Height = GuiService.TopbarInset.Height
        local v14 = Height <= 36
        v11 = GuiService:IsTenFootInterface()
        v12 = UserInputService.VREnabled
        v3.isOldTopbar = v14
        v10 += 1
        if not (Height == 0 and v13 == nil) then
            if v10 == 1 then
                task.delay(5, function() -- line 38 | captures: v10, Players, checkInset
                    Players.LocalPlayer:WaitForChild("PlayerGui")
                    if v10 == 1 then
                        checkInset()
                    end
                end)
            end
        else
            task.defer(function() -- line 33 | captures: checkInset
                task.wait(8)
                checkInset("ForceConvertToOld")
            end)
        end
        if not (not v3.isOldTopbar or v11 or v12 or v1 ~= false or Height == 0 and v13 ~= "ForceConvertToOld") then
            v1 = true
            task.defer(function() -- line 50 | captures: v3, GuiService
                local Classic = require(script.Parent.Parent.Features.Themes.Classic)
                v3.modifyBaseTheme(Classic)

                local function decideToHideTopbar() -- line 57 | captures: v3, GuiService
                    if GuiService.MenuIsOpen then
                        v3.setTopbarEnabled(false, true)
                    else
                        v3.setTopbarEnabled()
                    end
                end

                GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(decideToHideTopbar)
                if GuiService.MenuIsOpen then
                    v3.setTopbarEnabled(false, true)
                else
                    v3.setTopbarEnabled()
                end
            end)
        end
        v6 = GuiService:GetGuiInset()
        if v14 then
            v7 = 12
            v8 = 2
        else
            v7 = v6.Y - 50
            v8 = 0
        end
        v9 = -2
        if v11 then
            v7 = 10
            v8 = 0
        end
        if GuiService.TopbarInset.Height == 0 and not v1 then
            v8 += 13
            v9 = 50
        end
        v5:Fire(v6)
        local Y = v6.Y
        if Y == v2 then
            return
        end
        v2 = Y
        task.defer(function() -- line 88 | captures: Y, v3
            v3.insetHeightChanged:Fire(Y)
        end)
    end

    checkInset = checkInset_2
    GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(checkInset_2)
    checkInset_2("FirstTime")
    local ScreenGui = Instance.new("ScreenGui")
    v5:Connect(function() -- line 98 | captures: v7, ScreenGui
        ScreenGui:SetAttribute("StartInset", v7)
    end)
    ScreenGui.Name = "TopbarStandard"
    ScreenGui.Enabled = true
    ScreenGui.DisplayOrder = v3.baseDisplayOrder
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ScreenInsets = Enum.ScreenInsets.TopbarSafeInsets
    v4[ScreenGui.Name] = ScreenGui
    v3.baseDisplayOrderChanged:Connect(function() -- line 109 | captures: v3, ScreenGui
        ScreenGui.DisplayOrder = v3.baseDisplayOrder
    end)
    local Frame = Instance.new("Frame")
    Frame.Name = "Holders"
    Frame.BackgroundTransparency = 1
    v5:Connect(function() -- line 116 | captures: v8, v9, v11, v12, Frame
        local v15 = if v12 then 36 else 56
        local v16
        if v11 then
            v16 = UDim2.new(1, 0, 0, v15)
        else
            v16 = UDim2.new(1, 0, 1, v9)
        end
        Frame.Position = UDim2.new(0, 0, 0, v8)
        Frame.Size = v16
    end)
    Frame.Visible = true
    Frame.ZIndex = 1
    Frame.Parent = ScreenGui
    local v17 = ScreenGui:Clone()
    local Holders = v17.Holders

    local function updateCenteredHoldersHeight() -- line 128 | captures: v9, GuiService, Holders
        Holders.Size = UDim2.new(1, 0, 0, GuiService.TopbarInset.Height + v9)
    end

    v17.Name = "TopbarCentered"
    v17.DisplayOrder = v3.baseDisplayOrder
    v17.ScreenInsets = Enum.ScreenInsets.None
    v3.baseDisplayOrderChanged:Connect(function() -- line 134 | captures: v3, v17
        v17.DisplayOrder = v3.baseDisplayOrder
    end)
    v4[v17.Name] = v17
    v5:Connect(updateCenteredHoldersHeight)
    Holders.Size = UDim2.new(1, 0, 0, GuiService.TopbarInset.Height + v9)
    local v18 = ScreenGui:Clone()
    v18.Name ..= "Clipped"
    v18.DisplayOrder = v3.baseDisplayOrder + 1
    v3.baseDisplayOrderChanged:Connect(function() -- line 145 | captures: v3, v18
        v18.DisplayOrder = v3.baseDisplayOrder + 1
    end)
    v4[v18.Name] = v18
    local v19 = v17:Clone()
    v19.Name ..= "Clipped"
    v19.DisplayOrder = v3.baseDisplayOrder + 1
    v3.baseDisplayOrderChanged:Connect(function() -- line 153 | captures: v3, v19
        v19.DisplayOrder = v3.baseDisplayOrder + 1
    end)
    v4[v19.Name] = v19
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame:SetAttribute("IsAHolder", true)
    ScrollingFrame.Name = "Left"
    v5:Connect(function() -- line 162 | captures: v7, ScrollingFrame
        ScrollingFrame.Position = UDim2.fromOffset(v7, 0)
    end)
    ScrollingFrame.Size = UDim2.new(1, -24, 1, 0)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.Visible = true
    ScrollingFrame.ZIndex = 1
    ScrollingFrame.Active = false
    ScrollingFrame.ClipsDescendants = true
    ScrollingFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.None
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 1, -1)
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
    ScrollingFrame.ScrollBarThickness = 0
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Selectable = false
    ScrollingFrame.ScrollingEnabled = false
    ScrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Never
    ScrollingFrame.Parent = Frame
    local UIListLayout = Instance.new("UIListLayout")
    v5:Connect(function() -- line 183 | captures: v7, UIListLayout
        UIListLayout.Padding = UDim.new(0, v7)
    end)
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    UIListLayout.Parent = ScrollingFrame
    local v20 = ScrollingFrame:Clone()
    v5:Connect(function() -- line 193 | captures: v7, v20
        v20.UIListLayout.Padding = UDim.new(0, v7)
    end)
    v20.ScrollingEnabled = false
    v20.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    v20.Name = "Center"
    v20.Parent = Holders
    local v21 = ScrollingFrame:Clone()
    v5:Connect(function() -- line 202 | captures: v7, v21
        v21.UIListLayout.Padding = UDim.new(0, v7)
    end)
    v21.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    v21.Name = "Right"
    v21.AnchorPoint = Vector2.new(1, 0)
    v21.Position = UDim2.new(1, -12, 0, 0)
    v21.Parent = Frame
    v5:Fire(v6)
    return v4
end
