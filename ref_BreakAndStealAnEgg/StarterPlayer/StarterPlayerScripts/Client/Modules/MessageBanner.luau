-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local GlobalAnnouncementController = require(script.Parent.Parent.Controllers.GlobalAnnouncementController)
local LocalPlayer = Players.LocalPlayer
local v1 = {}

v1.__index = v1

local v2 = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

function v1.new(v4) -- line 69 | captures: RunService, v1
    local v5 = {}
    local v6 = setmetatable(v5, v1)
    v6.Name = v4.Name
    v6.Order = v4.Order or 1
    v6.Hold = v4.Hold or 4
    v6.PartNames = v4.Parts or { "Texts", "Background" }
    v6.OnResolve = v4.OnResolve
    v6.Strip = nil
    v6.Parts = {}
    v6.Generation = 0
    v6.Tween = nil
    v6.Slide = Instance.new("NumberValue")
    v6.Settle = 0
    v6.LastSlotY = nil
    local v7 = ("MessageBanner_%*"):format(v6.Name)
    local Value = Enum.RenderPriority.Last.Value
    RunService:BindToRenderStep(v7, Value, function(v8) -- line 83 | captures: v6
        v6:_place(v8)
    end)
    return v6
end

function v1.Resolve(v9) -- line 90 | captures: LocalPlayer
    local Strip = v9.Strip
    if Strip and Strip.Parent then
        return Strip
    end
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v10 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    local v11 = v10 and v10:FindFirstChild("Messages")
    local v12 = v11 and v11:FindFirstChild(v9.Name)
    if v12 and v12:IsA("GuiObject") then
        v9.Strip = v12
        v12.Visible = false
        v9.Slide.Value = 0
        v9.Settle = 0
        v9.LastSlotY = nil
        table.clear(v9.Parts)
        for v13, v14 in v9.PartNames do
            local v15 = v12:FindFirstChild(v14)
            if v15 and v15:IsA("GuiObject") then
                local Parts = v9.Parts
                local v16 = {
                    Part = v15,
                    Rest = v15.Position
                }
                table.insert(Parts, v16)
            end
        end
        v12.LayoutOrder = -100 + v9.Order
        v9:_attach(v12)
        if v9.OnResolve then
            v9.OnResolve(v12)
        end
        return v12
    end
    return nil
end

function v1._attach(v17, v18) -- line 125 | captures: GlobalAnnouncementController
    local v19 = GlobalAnnouncementController.GetHolder()
    if v19 and v18.Parent ~= v19 then
        local Parent = v18.Parent
        if Parent and Parent.Parent == v19.Parent then
            v18.Parent = v19
            v17.LastSlotY = nil
        end
    end
end

function v1._place(v20, v21) -- line 140 | captures: GlobalAnnouncementController
    local Strip = v20.Strip
    if Strip and Strip.Parent and Strip.Visible then
        local Parent = Strip.Parent
        local v22 = Strip.AbsolutePosition.Y - Parent.AbsolutePosition.Y + GlobalAnnouncementController.GapAbove(Strip)
        local LastSlotY = v20.LastSlotY
        if LastSlotY then
            local v23 = v22 - LastSlotY
            if math.abs(v23) > 0.5 then
                v20.Settle += LastSlotY - v22
            end
        end
        v20.LastSlotY = v22
        local Settle = v20.Settle
        local v24 = v21 * -14
        v20.Settle = Settle * math.exp(v24)
        local Settle_2 = v20.Settle
        if math.abs(Settle_2) < 0.5 then
            v20.Settle = 0
        end
        local v25 = v20.Slide.Value + v20.Settle + GlobalAnnouncementController.GapAbove(Strip)
        for v26, v27 in v20.Parts do
            local Rest = v27.Rest
            v27.Part.Position = UDim2.new(Rest.X.Scale, Rest.X.Offset, Rest.Y.Scale, Rest.Y.Offset + v25)
        end
    else
        v20.LastSlotY = nil
    end
end

function v1._offscreenLift(v28, v29) -- line 171 | captures: GlobalAnnouncementController
    return v29.AbsolutePosition.Y + GlobalAnnouncementController.GapAbove(v29) + v29.AbsoluteSize.Y + 36
end

local function _restore(v30, v31) -- line 176
    v31.Visible = false
    v30.Slide.Value = 0
    v30.Settle = 0
    v30.LastSlotY = nil
    for v32, v33 in v30.Parts do
        v33.Part.Position = v33.Rest
    end
end

v1._restore = _restore

function v1.Show(v34, v35) -- line 187 | captures: RunService, TweenService, v2, v3
    local v36 = v34:Resolve()
    if not v36 then
        return
    end
    v34:_attach(v36)
    if v35 then
        v35(v36)
    end
    v34.Generation += 1
    local Generation = v34.Generation
    if v34.Tween then
        v34.Tween:Cancel()
        v34.Tween = nil
    end
    v34.Slide.Value = -100000
    v34.Settle = 0
    v34.LastSlotY = nil
    v36.Visible = true
    RunService.Heartbeat:Wait()
    if not (v34.Generation == Generation and v36.Parent) then
        return
    end
    v34.Slide.Value = -v34:_offscreenLift(v36)
    local v37 = TweenService:Create(v34.Slide, v2, { Value = 0 })
    v34.Tween = v37
    v37:Play()
    task.delay(v2.Time + v34.Hold, function() -- line 220 | captures: v34, v36, Generation, TweenService, v3
        if v34.Generation == Generation and v36.Parent then
            if v34.Tween then
                v34.Tween:Cancel()
            end
        else
            return
        end
        local v38 = TweenService:Create(v34.Slide, v3, { Value = -v34:_offscreenLift(v36) - v34.Settle })
        v34.Tween = v38
        v38:Play()
        task.delay(v3.Time, function() -- line 231 | captures: v34, v36, Generation
            if v34.Generation == Generation and v36.Parent then
                v34:_restore(v36)
            end
        end)
    end)
end

local function HideNow(v39) -- line 241
    v39.Generation += 1
    if v39.Tween then
        v39.Tween:Cancel()
        v39.Tween = nil
    end
    local Strip = v39.Strip
    if Strip and Strip.Parent then
        v39:_restore(Strip)
    end
end

v1.HideNow = HideNow
return v1
