-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local TweenService = game:GetService("TweenService")
local AnimalChatConfig = require(script.Parent.AnimalChatConfig)
local AnimalOverhead = require(script.Parent.AnimalOverhead)
local BillboardAssets = require(script.Parent.BillboardAssets)
local ChatBubbleSize = require(script.Parent.ChatBubbleSize)
local v1 = {}
local v2 = false

function v1.Template() -- line 49 | captures: v2, AnimalChatConfig, BillboardAssets
    for v3, v4 in AnimalChatConfig.TemplateNames do
        local v5 = BillboardAssets.Find(v4)
        if v5 then
            return v5
        end
    end
    if not v2 then
        v2 = true
        warn((("[AnimalBubble] ReplicatedStorage.Assets.BillboardGui.%* (BillboardGui) not found \226\128\148 no speech bubbles"):format(AnimalChatConfig.TemplateNames[1])))
    end
    return nil
end

local function HeadPosition(v6) -- line 68
    for v7, v8 in v6:GetDescendants() do
        if v8.Name:lower():find("head", 1, true) then
            if v8:IsA("Bone") then
                return v8.TransformedWorldCFrame.Position
            end
            if v8:IsA("BasePart") then
                local Position = v8.Position
                local v9 = v8.Size.Y / 2
                return Position + Vector3.new(0, v9, 0)
            end
        end
    end
    local v10, v11 = v6:GetBoundingBox()
    local Position = v10.Position
    local v12 = v11.Y / 2
    return Position + Vector3.new(0, v12, 0)
end

v1.HeadPosition = HeadPosition

local function placeOverHead(v13, v14) -- line 86 | captures: AnimalChatConfig, v1
    local v15 = v1.HeadPosition(v13)
    local v16, v17 = v13:GetBoundingBox()
    local v18 = v16.Position.Y + v17.Y / 2
    local v19 = v15.Y + AnimalChatConfig.HeightAboveHead
    local v20 = v18 + AnimalChatConfig.HeightAboveTop
    local v21 = math.max(v19, v20)
    local X = v15.X
    local Z = v15.Z
    v14.WorldPosition = Vector3.new(X, v21, Z)
    v14:SetAttribute(AnimalChatConfig.HeadAnchoredAttribute, true)
end

local function isStackedOnOverhead(v22, v23, v24) -- line 98 | captures: AnimalChatConfig, AnimalOverhead
    local v25 = v23:FindFirstChild(AnimalOverhead.AttachmentName)
    local v26 = if not (v25 and v25:IsA("Attachment")) then v22:GetBoundingBox().Position else v25.WorldPosition
    local v27 = v24.WorldPosition - v26
    return Vector2.new(v27.X, v27.Z).Magnitude <= AnimalChatConfig.StackedTolerance
end

function v1.Attachment(v28) -- line 111 | captures: AnimalChatConfig, placeOverHead, isStackedOnOverhead
    local v29 = v28.PrimaryPart or v28:FindFirstChildWhichIsA("BasePart", true)
    if v29 then
        local v30 = v29:FindFirstChild(AnimalChatConfig.AttachmentName)
        if v30 and v30:IsA("Attachment") then
            if v30:GetAttribute(AnimalChatConfig.HeadAnchoredAttribute) ~= true and isStackedOnOverhead(v28, v29, v30) then
                placeOverHead(v28, v30)
            end
            return v30
        end
        local Attachment = Instance.new("Attachment")
        Attachment.Name = AnimalChatConfig.AttachmentName
        Attachment.Parent = v29
        placeOverHead(v28, Attachment)
        return Attachment
    end
    return nil
end

local function overheadRowsTop(v31) -- line 137 | captures: AnimalOverhead
    local v32 = v31.PrimaryPart or v31:FindFirstChildWhichIsA("BasePart", true)
    local v33 = v32 and v32:FindFirstChild(AnimalOverhead.AttachmentName)
    local Scale, v34, v35, v36
    if v33 then
        v34 = v33:FindFirstChildWhichIsA("BillboardGui")
        if v33:IsA("Attachment") and v34 and v34.Enabled then
            Scale = v34.Size.Y.Scale
            local UIListLayout = v34:FindFirstChildWhichIsA("UIListLayout")
            if UIListLayout then
                v35 = UIListLayout.Padding.Scale
            else
                v35 = 0
            end
            v36 = false
        else
            v36 = true
        end
    else
        v34 = v33
        v36 = true
    end
    if v36 then
        return nil
    end
    local v37 = 0
    local v38 = 0
    for v39, v40 in v34:GetChildren() do
        if v40:IsA("GuiObject") and v40.Visible then
            v37 += v40.Size.Y.Scale
            v38 += 1
        end
    end
    if v38 == 0 then
        return nil
    end
    local v41 = v37 + v35 * (v38 - 1)
    return v33.WorldPosition.Y + v41 * Scale
end

local function clearOverhead(v42, v43, v44, v45) -- line 163 | captures: AnimalChatConfig, overheadRowsTop
    local v46 = overheadRowsTop(v42)
    if v46 then
        local v47 = v44:FindFirstChild(AnimalChatConfig.BubbleRootName, true)
        local v48 = if not (v47 and v47:IsA("GuiObject")) then 1 else v47.Size.Y.Scale
        local v49 = v45.Y.Scale * v48 / 2
        local v50 = v46 + AnimalChatConfig.OverheadClearance + v49 - v43.WorldPosition.Y
        local v51 = math.max(v50, 0)
        v44.StudsOffsetWorldSpace = Vector3.new(0, v51, 0)
    else
        v44.StudsOffsetWorldSpace = Vector3.new(0, 0, 0)
    end
end

function v1.Show(v52, v53, v54) -- line 180 | captures: TweenService, AnimalChatConfig, ChatBubbleSize, v1, clearOverhead
    if v52.Parent then
        local v55 = v1.Attachment(v52)
        local v56 = v1.Template()
        local Bubble, v57
        if v55 and v56 then
            Bubble = AnimalChatConfig.Bubble
            v57 = v54 or {}
        else
            return nil
        end
        local v58 = v57.AppearDelay or Bubble.AppearDelay
        local v59 = v57.PopTime or Bubble.PopTime
        local v60 = v57.DisplayTime or Bubble.DisplayTime
        local v61 = v57.FadeTime or Bubble.FadeTime
        local BillboardGui = v55:FindFirstChildWhichIsA("BillboardGui")
        if BillboardGui then
            BillboardGui:Destroy()
        end
        local v62 = v56:Clone()
        local v63 = ChatBubbleSize.Apply(v62, v53)
        local v64 = v52:GetAttribute("SizeMult") or 1
        local v65 = v57.MinScale or Bubble.MinScale
        local v66 = v57.MaxScale or Bubble.MaxScale
        local v67 = math.clamp(v64, v65, v66)
        local v68 = UDim2.new(v62.Size.X.Scale * v67 * v63.WidthMult, v62.Size.X.Offset * v67 * v63.WidthMult, v62.Size.Y.Scale * v67, v62.Size.Y.Offset * v67)
        v62.Size = UDim2.new(0, 0, 0, 0)
        v62.Enabled = true
        v62.Parent = v55
        local v69 = v55:GetAttribute(AnimalChatConfig.HeadAnchoredAttribute) == true
        task.delay(v58, function() -- line 229 | captures: v52, v55, v62, v68, v69, v59, TweenService, clearOverhead
            if v62.Parent then
                if v69 then
                    clearOverhead(v52, v55, v62, v68)
                end
                TweenService:Create(v62, TweenInfo.new(v59, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = v68 }):Play()
            end
        end)
        task.delay(v58 + v59 + v60, function() -- line 244 | captures: v62, v61, TweenService
            if not v62.Parent then
                return
            end
            local v70 = TweenInfo.new(v61, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            for v71, v72 in v62:GetDescendants() do
                if v72:IsA("TextLabel") then
                    TweenService:Create(v72, v70, {
                        TextTransparency = 1,
                        BackgroundTransparency = 1,
                        TextStrokeTransparency = 1
                    }):Play()
                elseif v72:IsA("ImageLabel") then
                    TweenService:Create(v72, v70, {
                        ImageTransparency = 1,
                        BackgroundTransparency = 1
                    }):Play()
                elseif v72:IsA("Frame") then
                    TweenService:Create(v72, v70, { BackgroundTransparency = 1 }):Play()
                end
            end
            task.delay(v61, function() -- line 267 | captures: v62
                if v62.Parent then
                    v62:Destroy()
                end
            end)
        end)
        return v62
    end
    return nil
end

return v1
