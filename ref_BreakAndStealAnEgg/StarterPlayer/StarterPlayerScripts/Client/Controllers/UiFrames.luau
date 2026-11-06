-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local UiFramesConfig = require(ReplicatedStorage.Shared.UiFramesConfig)
local v1 = TweenInfo.new(UiFramesConfig.TweenDuration, UiFramesConfig.TweenEasingStyle, UiFramesConfig.TweenEasingDirection)
local v2 = TweenInfo.new(UiFramesConfig.CloseTweenDuration, UiFramesConfig.CloseTweenEasingStyle, UiFramesConfig.CloseTweenEasingDirection)
local v3 = TweenInfo.new(UiFramesConfig.SlideOpenTweenDuration, UiFramesConfig.SlideOpenEasingStyle, UiFramesConfig.SlideOpenEasingDirection)
local v4 = TweenInfo.new(UiFramesConfig.SlideCloseTweenDuration, UiFramesConfig.SlideCloseEasingStyle, UiFramesConfig.SlideCloseEasingDirection)
local v5 = {}
local v6 = {}
local v7
local v8 = {}
local v9 = {}

local function playOpenSound() -- line 85 | captures: Debris, SoundService, UiFramesConfig
    local UiSounds = SoundService:FindFirstChild("UiSounds")
    local v10 = UiSounds and UiSounds:FindFirstChild(UiFramesConfig.OpenSoundName)
    if not (v10 and v10:IsA("Sound")) then
        return
    end
    local v11 = v10:Clone()
    v11.Parent = SoundService
    v11.Ended:Once(function() -- line 94 | captures: v11
        v11:Destroy()
    end)
    local TimeLength = v11.TimeLength
    Debris:AddItem(v11, math.max(TimeLength, 1) + 1)
    v11:Play()
end

local function getState(v12) -- line 103 | captures: v7, v6, v8
    local v13 = v6[v12]
    local v14 = v13
    if v13 == nil then
        local UiFrameScale = v12:FindFirstChild("UiFrameScale")
        if UiFrameScale == nil or not UiFrameScale:IsA("UIScale") then
            UiFrameScale = Instance.new("UIScale")
            UiFrameScale.Name = "UiFrameScale"
            UiFrameScale.Scale = 1
            UiFrameScale.Parent = v12
        end
        v13 = {
            tween = nil,
            positionTween = nil,
            uiScale = UiFrameScale,
            originalPosition = v12.Position,
            observers = {},
            open = v12.Visible
        }
        v14 = v13
        v6[v12] = v13
        v12.Destroying:Connect(function() -- line 127 | captures: v14, v12, v7, v6, v8
            if v14.tween ~= nil then
                v14.tween:Cancel()
            end
            if v14.positionTween ~= nil then
                v14.positionTween:Cancel()
            end
            v6[v12] = nil
            if v7 == v12 then
                v7 = nil
            end
            v8[v12] = nil
            for v15, v16 in v8 do
                if v16 == v12 then
                    v8[v15] = nil
                end
            end
        end)
    end
    return v14
end

local function slideClosedPosition(v17, v18) -- line 157 | captures: UiFramesConfig
    local GuiBase2d = v17:FindFirstAncestorWhichIsA("GuiBase2d")
    if GuiBase2d == nil then
        return v18.originalPosition + UDim2.fromScale(1, 0)
    end
    local X = v17.AbsoluteSize.X
    local X_2 = v18.originalPosition.X
    local v19 = GuiBase2d.AbsolutePosition.X + X_2.Scale * GuiBase2d.AbsoluteSize.X + X_2.Offset - v17.AnchorPoint.X * X
    local v20 = GuiBase2d.AbsolutePosition.X + GuiBase2d.AbsoluteSize.X - v19
    local v21 = math.max(v20, 0) + UiFramesConfig.SlideMarginPixels
    return v18.originalPosition + UDim2.fromOffset(v21, 0)
end

local setOpen

local function setOpen_2(v22, v23, v24) -- line 171 | captures: v7, TweenService, UiFramesConfig, v1, v2, v3, v4, v6, v8, v9, playOpenSound, getState, slideClosedPosition, setOpen
    if not (v6[v22] == nil and v22.Parent == nil) then
        local v25 = getState(v22)
        if v25.open ~= v23 then
            v25.open = v23
            if v25.tween ~= nil then
                v25.tween:Cancel()
                v25.tween = nil
            end
            if v25.positionTween ~= nil then
                v25.positionTween:Cancel()
                v25.positionTween = nil
            end
            local v26 = UiFramesConfig.SlideFrames[v22.Name] == true
            local v27
            if v26 then
                v27 = slideClosedPosition(v22, v25)
            else
                v27 = v25.originalPosition + UiFramesConfig.ClosedPositionOffset
            end
            if v23 then
                if v7 ~= nil and v7 ~= v22 then
                    setOpen(v7, false)
                end
                v7 = v22
                if v26 then
                    if not v22.Visible then
                        v22.Position = v27
                    end
                    v25.uiScale.Scale = 1
                    v22.Visible = true
                    local v28 = TweenService:Create(v22, v3, { Position = v25.originalPosition })
                    v25.positionTween = v28
                    v28:Play()
                else
                    v22.Visible = true
                    v25.uiScale.Scale = UiFramesConfig.ClosedScale
                    v22.Position = v27
                    local v29 = TweenService:Create(v25.uiScale, v1, { Scale = 1 })
                    v25.tween = v29
                    v29:Play()
                    local v30 = TweenService:Create(v22, v1, { Position = v25.originalPosition })
                    v25.positionTween = v30
                    v30:Play()
                end
                playOpenSound()
            else
                if v7 == v22 then
                    v7 = nil
                end
                local v31 = v8[v22]
                if v31 ~= nil and not v24 then
                    v8[v22] = nil
                    task.defer(function() -- line 249 | captures: v22, v31, v7, v6, setOpen
                        local v32 = v6[v22]
                        local v33 = if v32 == nil then true else not v32.open
                        if v7 == nil and v33 and v31.Parent then
                            setOpen(v31, true)
                        end
                    end)
                end
                if v26 then
                    local v34 = TweenService:Create(v22, v4, { Position = v27 })
                    v25.positionTween = v34
                    v34.Completed:Once(function(v35) -- line 268 | captures: v22, v25
                        if v35 == Enum.PlaybackState.Completed then
                            v22.Visible = false
                            v22.Position = v25.originalPosition
                        end
                    end)
                    v34:Play()
                else
                    local v36 = TweenService:Create(v25.uiScale, v2, { Scale = UiFramesConfig.CloseScale })
                    v25.tween = v36
                    v36.Completed:Once(function(v37) -- line 283 | captures: v22, v25
                        if v37 ~= Enum.PlaybackState.Completed then
                            return
                        end
                        v22.Visible = false
                        v25.uiScale.Scale = 1
                        v22.Position = v25.originalPosition
                    end)
                    v36:Play()
                    local v38 = TweenService:Create(v22, v2, { Position = v27 })
                    v25.positionTween = v38
                    v38:Play()
                end
            end
            for v39, v40 in v25.observers do
                task.spawn(v40, v23)
            end
            for v41, v42 in v9 do
                task.spawn(v42, v22, v23)
            end
        end
    end
end

setOpen = setOpen_2

function v5.IsOpen(v43) -- line 309 | captures: v6
    local v44 = v6[v43]
    if v44 == nil then
        return v43.Visible
    end
    return v44.open
end

function v5.Open(v45) -- line 322 | captures: setOpen_2
    setOpen_2(v45, true)
end

function v5.OpenOver(v46) -- line 326 | captures: v7, v8, setOpen_2
    local v47 = v7
    if v47 ~= nil and v47 ~= v46 then
        v8[v46] = v47
    end
    setOpen_2(v46, true)
end

function v5.Close(v48, v49) -- line 334 | captures: v8, setOpen_2
    for v50, v51 in v8 do
        if v51 == v48 then
            v8[v50] = nil
        end
    end
    setOpen_2(v48, false, v49)
end

function v5.Toggle(v52) -- line 345 | captures: getState, setOpen_2
    setOpen_2(v52, not getState(v52).open)
end

function v5.Observe(v53, v54) -- line 349 | captures: getState
    local observers = getState(v53).observers
    table.insert(observers, v54)
end

function v5.PlayOpenSound() -- line 355 | captures: playOpenSound
    playOpenSound()
end

function v5.GetOpen() -- line 360 | captures: v7
    return v7
end

function v5.ObserveAny(v55) -- line 364 | captures: v9
    table.insert(v9, v55)
end

return v5
