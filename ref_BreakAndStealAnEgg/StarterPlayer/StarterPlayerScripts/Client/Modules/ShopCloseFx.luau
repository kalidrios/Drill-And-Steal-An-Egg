-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local v1 = Color3.fromRGB(40, 42, 55)
local v2 = Color3.fromRGB(236, 236, 236)
local v3 = {}
local v4 = {}
local v5 = Vector2.new(0.5, 0.5)
local v6 = TweenInfo.new(0.35)
local v7 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v8 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local v9 = TweenInfo.new(0.09, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v10 = TweenInfo.new(0.11, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local v11 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function easeInOutQuad(v12) -- line 135
    if v12 < 0.5 then
        return v12 * 2 * v12
    end
    return 1 - (v12 * -2 + 2) ^ 2 / 2
end

local function getOrCreateScale(v13, v14) -- line 139
    local v15 = v13:FindFirstChild(v14)
    if v15 ~= nil and v15:IsA("UIScale") then
        return v15
    end
    local UIScale = Instance.new("UIScale")
    UIScale.Name = v14
    UIScale.Scale = 1
    UIScale.Parent = v13
    return UIScale
end

local v16 = {}

local function acquireGhost() -- line 157 | captures: v1, v5, v16
    local v17 = table.remove(v16)
    if v17 == nil then
        local Frame = Instance.new("Frame")
        Frame.Name = "ShopCloseGhost"
        Frame.AnchorPoint = v5
        Frame.BackgroundColor3 = v1
        Frame.BorderSizePixel = 0
        local UICorner = Instance.new("UICorner")
        UICorner.Parent = Frame
        return Frame, UICorner
    end
    return v17, (v17:FindFirstChildWhichIsA("UICorner"))
end

local function releaseGhost(v18) -- line 172 | captures: v16
    if v18.Parent ~= nil then
        if #v16 < 16 then
            v18.Parent = nil
            table.insert(v16, v18)
        else
            v18:Destroy()
        end
    end
end

local function spawnGhost(v19, v20, v21, v22, v23, v24, v25) -- line 190 | captures: TweenService, v6, acquireGhost, releaseGhost
    local v26, v27 = acquireGhost()
    local v28 = v21 - v20.AbsolutePosition
    v26.Position = UDim2.fromOffset(v28.X, v28.Y)
    v26.Size = UDim2.fromOffset(v23.X, v23.Y)
    v26.Rotation = v22
    v26.BackgroundTransparency = 0.82
    v26.ZIndex = v24 - 1
    if v25 == nil then
        v27.CornerRadius = UDim.new(0, 0)
    else
        v27.CornerRadius = v25.CornerRadius
    end
    v26.Parent = v19
    TweenService:Create(v26, v6, { BackgroundTransparency = 1 }):Play()
    task.delay(0.39999999999999997, releaseGhost, v26)
end

local function ringBurst(v29, v30) -- line 219 | captures: Debris, TweenService, v2, v5, v7, v8
    local LayerCollector = v29:FindFirstAncestorWhichIsA("LayerCollector")
    if LayerCollector == nil then
        return
    end
    local X = v29.AbsoluteSize.X
    local v31 = v29.AbsolutePosition + v29.AbsoluteSize / 2 - LayerCollector.AbsolutePosition + v30 * X * 0.12
    local v32 = X * 1
    local v33 = X * 1.8
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "ShopCloseRing"
    ImageLabel.Image = "rbxassetid://111884923684629"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.ImageColor3 = v2
    ImageLabel.ImageTransparency = 0
    ImageLabel.AnchorPoint = v5
    ImageLabel.Position = UDim2.fromOffset(v31.X, v31.Y)
    ImageLabel.Size = UDim2.fromOffset(v32, v32)
    ImageLabel.ZIndex = 0
    ImageLabel.Parent = LayerCollector
    TweenService:Create(ImageLabel, v7, { Size = UDim2.fromOffset(v33, v33) }):Play()
    TweenService:Create(ImageLabel, v8, { ImageTransparency = 1 }):Play()
    Debris:AddItem(ImageLabel, 0.21)
end

local function buttonPop(v34) -- line 290 | captures: TweenService, v9, v10, v11
    local ButtonTweenScale = v34:FindFirstChild("ButtonTweenScale")
    if not (ButtonTweenScale ~= nil and ButtonTweenScale:IsA("UIScale")) then
        ButtonTweenScale = Instance.new("UIScale")
        ButtonTweenScale.Name = "ButtonTweenScale"
        ButtonTweenScale.Scale = 1
        ButtonTweenScale.Parent = v34
    end
    local v35 = TweenService:Create(ButtonTweenScale, v9, { Scale = 1.35 })
    local v36 = TweenService:Create(v34, v9, { Rotation = -10 })
    local v37 = TweenService:Create(ButtonTweenScale, v10, { Scale = 0.93 })
    local v38 = TweenService:Create(v34, v10, { Rotation = -2 })
    local v39 = TweenService:Create(ButtonTweenScale, v11, { Scale = 1 })
    local v40 = TweenService:Create(v34, v11, { Rotation = 0 })
    v35.Completed:Once(function() -- line 300 | captures: v37, v38
        v37:Play()
        v38:Play()
    end)
    v37.Completed:Once(function() -- line 304 | captures: v39, v40
        v39:Play()
        v40:Play()
    end)
    v35:Play()
    v36:Play()
end

function v3.IsPlaying(v41) -- line 313 | captures: v4
    return v4[v41] == true
end

function v3.Play(v42, v43, v44) -- line 317 | captures: RunService, v4, v5, spawnGhost, ringBurst, buttonPop
    if v4[v42] then
        return
    end
    v4[v42] = true
    local Parent = v42.Parent
    local GuiBase2d = v42:FindFirstAncestorWhichIsA("GuiBase2d")
    if Parent ~= nil and GuiBase2d ~= nil then
        local v45 = {}
        for v46, v47 in v44 or {} do
            if v47:IsA("GuiObject") and v47.Visible then
                v47.Visible = false
                table.insert(v45, v47)
            end
        end
        local AbsolutePosition = GuiBase2d.AbsolutePosition
        local AbsoluteSize = GuiBase2d.AbsoluteSize
        local v48 = v43.AbsolutePosition + v43.AbsoluteSize / 2
        local v49 = v42.AbsolutePosition + v42.AbsoluteSize / 2
        local AbsoluteSize_2 = v42.AbsoluteSize
        local v50 = UDim2.fromScale((v49.X - AbsolutePosition.X) / AbsoluteSize.X, (v49.Y - AbsolutePosition.Y) / AbsoluteSize.Y)
        local v51 = UDim2.fromScale((v48.X - AbsolutePosition.X) / AbsoluteSize.X, (v48.Y - AbsolutePosition.Y) / AbsoluteSize.Y)
        local UICorner = v42:FindFirstChildWhichIsA("UICorner")
        local v52 = v49 - v48
        local v53
        if v52.Magnitude > 0 then
            v53 = v52.Unit
        else
            v53 = Vector2.new(0.7, -0.7)
        end
        local v54 = AbsoluteSize_2 * 1.5
        local CanvasGroup = Instance.new("CanvasGroup")
        CanvasGroup.Name = "ShopCloseFxFlight"
        CanvasGroup.AnchorPoint = v5
        CanvasGroup.Position = v50
        CanvasGroup.Size = UDim2.fromOffset(v54.X, v54.Y)
        CanvasGroup.BackgroundTransparency = 1
        CanvasGroup.BorderSizePixel = 0
        CanvasGroup.ZIndex = v42.ZIndex
        local UIScale = Instance.new("UIScale")
        UIScale.Name = "ShopCloseFxScale"
        UIScale.Scale = 1
        UIScale.Parent = CanvasGroup
        CanvasGroup.Parent = Parent
        local AnchorPoint = v42.AnchorPoint
        local Position = v42.Position
        local Size = v42.Size
        v42.AnchorPoint = v5
        v42.Position = UDim2.fromScale(0.5, 0.5)
        v42.Size = UDim2.fromOffset(AbsoluteSize_2.X, AbsoluteSize_2.Y)
        v42.Parent = CanvasGroup
        local v55 = {}
        local v56 = (-1/0)
        local v57 = false
        local v58 = false
        local v59 = 0
        while true do
            local v60, v61, v62
            if v59 < 0.75 then
                if CanvasGroup.Parent == nil then
                    v62 = true
                elseif v42.Parent == CanvasGroup then
                    v60 = v59 + RunService.Heartbeat:Wait()
                    if v57 then
                        if v58 then
                            v61 = v58
                        else
                            ringBurst(v43, v53)
                            buttonPop(v43)
                            v61 = true
                        end
                    else
                        v61 = v58
                    end
                    v62 = false
                else
                    v62 = true
                end
            else
                v62 = true
            end
            if v62 then
                break
            end
            local v63 = v60 / 0.75
            local v64 = math.clamp(v63, 0, 1)
            local v65 = if v64 < 0.5 then v64 * 2 * v64 else 1 - (v64 * -2 + 2) ^ 2 / 2
            CanvasGroup.Position = v50:Lerp(v51, v65)
            CanvasGroup.Rotation = v65 * -20
            UIScale.Scale = v65 * -0.88 + 1
            local v66 = (v64 - 0.6) / 0.32000000000000006
            local v67 = math.clamp(v66, 0, 1)
            if v67 > 0 then
                CanvasGroup.GroupTransparency = v67
            end
            local v68 = {
                time = v60,
                center = CanvasGroup.AbsolutePosition + CanvasGroup.AbsoluteSize / 2,
                rotation = CanvasGroup.Rotation,
                size = CanvasGroup.AbsoluteSize * 0.6666666666666666
            }
            table.insert(v55, v68)
            while #v55 > 1 and v60 - v55[2].time >= 0.1 do
                table.remove(v55, 1)
            end
            if v60 - v56 >= 0.05 and v64 < 0.92 and v60 - v55[1].time >= 0.1 then
                local v69 = v55[1]
                spawnGhost(Parent, GuiBase2d, v69.center, v69.rotation, v69.size, CanvasGroup.ZIndex, UICorner)
                v56 = v60
            end
            if v67 >= 1 then
                v57 = true
            end
            v58 = v61
            v59 = v60
        end
        if not v58 and v43.Parent ~= nil then
            ringBurst(v43, v53)
            buttonPop(v43)
        end
        if v42.Parent == CanvasGroup then
            v42.Visible = false
            v42.AnchorPoint = AnchorPoint
            v42.Position = Position
            v42.Size = Size
            v42.Parent = Parent
        end
        CanvasGroup:Destroy()
        for v70, v71 in v45 do
            if v71.Parent ~= nil then
                v71.Visible = true
            end
        end
    end
    v4[v42] = nil
end

return v3
