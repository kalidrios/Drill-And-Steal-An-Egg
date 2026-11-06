-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local GenderConfig = require(ReplicatedStorage.Shared.GenderConfig)
local WeightTag = require(ReplicatedStorage.Shared.WeightTag)
local LocalModelHider = require(script.Parent.Parent.Modules.LocalModelHider)
local UiFrames = require(script.Parent.UiFrames)
local v1 = {}
local v2 = Color3.fromRGB(255, 255, 255)
local v3 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v4 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v5, v6, v7, v8, v9

local function adoptWeightFrame(v10) -- line 84 | captures: v5, v6, v7, v8, v9
    task.spawn(function() -- line 85 | captures: v10, v5, v6, v7, v8, v9
        local v11 = v10:WaitForChild("AnimalWeight", 10)
        if v11 and v11:IsA("GuiObject") then
            v11.Visible = false
            v5 = v11
            v8 = v11:FindFirstAncestorOfClass("ScreenGui")
            v9 = nil
            local v12 = v11:FindFirstChild("Amount", true)
            if v12 then
                if not v12:IsA("TextLabel") then
                    v12 = nil
                end
            else
                v12 = nil
            end
            v6 = v12
            local v13 = v11:FindFirstChild("Gender", true)
            if not (v13 and v13:IsA("ImageLabel")) then
                v13 = nil
            end
            v7 = v13
        else
            warn("[HoverInfoController] MainGUI.AnimalWeight (Frame) not found")
        end
    end)
end

local Highlight

local function getHighlight() -- line 105 | captures: Highlight, Players, v2
    if Highlight and Highlight.Parent then
        return Highlight
    end
    local LocalPlayer = Players.LocalPlayer
    local v14 = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if v14 then
        local Highlight_2 = Instance.new("Highlight")
        Highlight_2.Name = "_HoverOutline"
        Highlight_2.FillTransparency = 1
        Highlight_2.OutlineColor = v2
        Highlight_2.OutlineTransparency = 1
        Highlight_2.DepthMode = Enum.HighlightDepthMode.Occluded
        Highlight_2.Enabled = false
        Highlight_2.Parent = v14
        Highlight = Highlight_2
        return Highlight_2
    end
    return nil
end

local v15 = false
local v16

local function setHighlightShown(v17) -- line 137 | captures: v15, v16, TweenService, v3, v4, getHighlight
    local v18 = getHighlight()
    local v19
    if v18 then
        if v15 == v17 then
            v19 = true
        else
            v15 = v17
            if v16 then
                v16:Cancel()
            end
            v19 = false
        end
    else
        v19 = true
    end
    if v19 then
        return
    end
    local v20
    if v17 then
        v18.Enabled = true
        v20 = TweenService:Create(v18, v3, { OutlineTransparency = 0.35 })
    else
        v20 = TweenService:Create(v18, v4, { OutlineTransparency = 1 })
        v20.Completed:Once(function(v21) -- line 156 | captures: v18, v15
            if v21 == Enum.PlaybackState.Completed and not v15 then
                v18.Enabled = false
                v18.Adornee = nil
            end
        end)
    end
    v16 = v20
    v20:Play()
end

local function resolveTarget(v22) -- line 175 | captures: CollectionService
    if v22:GetAttribute("WeightKg") == nil then
        local v23 = v22:FindFirstAncestorOfClass("Model")
        while true do
            if v23 then
                if v23:GetAttribute("EggId") == nil then
                    if v23:GetAttribute("WeightKg") == nil then
                        local PrimaryPart = v23.PrimaryPart
                        if PrimaryPart and PrimaryPart:GetAttribute("WeightKg") ~= nil and CollectionService:HasTag(PrimaryPart, "BreakableEgg") then
                            return PrimaryPart, v23
                        end
                        v23 = v23:FindFirstAncestorOfClass("Model")
                        continue
                    end
                    return v23, v23
                end
                break
            end
            return nil, nil
        end
        return nil, nil
    end
    local Model = v22:FindFirstAncestorOfClass("Model")
    if not (Model and Model.PrimaryPart == v22) then
        Model = v22
    end
    return v22, Model
end

local v24, WeightKg

local function hide() -- line 210 | captures: v5, v24, WeightKg, setHighlightShown
    v24 = nil
    WeightKg = nil
    local v25 = v5
    if v25 and v25.Visible then
        v25.Visible = false
    end
    setHighlightShown(false)
end

local function refreshWeight(v26) -- line 223 | captures: v6, WeightKg, WeightTag
    local v27 = v6
    if not v27 then
        return
    end
    local WeightKg_2 = v26:GetAttribute("WeightKg")
    local v28, v29
    if WeightKg_2 == nil then
        WeightKg = WeightKg_2
        if WeightKg_2 == nil then
            v28 = ""
        else
            v28 = ("%*KG"):format((WeightTag.FormatKg(WeightKg_2)))
        end
        v29 = false
    elseif WeightKg_2 == WeightKg then
        v29 = true
    else
        WeightKg = WeightKg_2
        if WeightKg_2 == nil then
            v28 = ""
        else
            v28 = ("%*KG"):format((WeightTag.FormatKg(WeightKg_2)))
        end
        v29 = false
    end
    if not v29 then
        v27.Text = v28
    end
end

local function refreshGender(v30) -- line 237 | captures: v7, GenderConfig
    local v31 = v7
    if not v31 then
        return
    end
    local v32 = GenderConfig.Icon((v30:GetAttribute(GenderConfig.Attribute)))
    v31.Image = v32 or ""
    v31.Visible = v32 ~= nil
end

local function positionFrame(v33, v34) -- line 252 | captures: v8, v9, GuiService
    local v35 = v8
    if not v35 or v35.Parent == nil then
        v35 = v33:FindFirstAncestorOfClass("ScreenGui")
        v8 = v35
    end
    if not v35 then
        return
    end
    local v36 = v34 - GuiService:GetGuiInset() - v35.AbsolutePosition
    local AbsoluteSize = v33.AbsoluteSize
    local v37 = v36 + Vector2.new(AbsoluteSize.X / 4 + 6, AbsoluteSize.Y * 1)
    local AnchorPoint = v33.AnchorPoint
    local v38 = UDim2.fromOffset(v37.X + (AnchorPoint.X - 0.5) * AbsoluteSize.X, v37.Y + (AnchorPoint.Y - 0.5) * AbsoluteSize.Y)
    if v38 ~= v9 then
        v9 = v38
        v33.Position = v38
    end
end

local function show(v39, v40, v41) -- line 282 | captures: v5, v6, v7, v24, WeightKg, GenderConfig, WeightTag, getHighlight, setHighlightShown, positionFrame
    local BasePart = v39:IsA("BasePart")
    local v42 = getHighlight()
    if v24 ~= v39 then
        v24 = v39
        WeightKg = nil
        if v42 and not BasePart then
            v42.Adornee = v40
        end
        local v43, v44, v45
        if BasePart then
            v45 = true
        else
            v43 = v7
            if v43 then
                local v46 = GenderConfig.Icon((v39:GetAttribute(GenderConfig.Attribute)))
                v43.Image = v46 or ""
                v44 = v46 ~= nil
                v45 = false
            else
                v45 = true
            end
        end
        if not v45 then
            v43.Visible = v44
        end
    end
    setHighlightShown(not BasePart)
    local v47 = v5
    if v47 and v47.Parent then
        if BasePart then
            if v47.Visible then
                v47.Visible = false
            end
        else
            local v48 = v6
            if v48 then
                local WeightKg_2 = v39:GetAttribute("WeightKg")
                if WeightKg_2 == nil or WeightKg_2 ~= WeightKg then
                    WeightKg = WeightKg_2
                    if WeightKg_2 == nil then
                        v48.Text = ""
                    else
                        v48.Text = ("%*KG"):format((WeightTag.FormatKg(WeightKg_2)))
                    end
                end
            end
            positionFrame(v47, v41)
            if not v47.Visible then
                v47.Visible = true
            end
        end
    end
end

local v49 = RaycastParams.new()

v49.FilterType = Enum.RaycastFilterType.Exclude

local v50

local function setHoverFilter(v51) -- line 330 | captures: v50, v49
    v50 = v51
    local v52 = if v51 then { v51 } else {}
    v49.FilterDescendantsInstances = v52
end

local function hiddenModelOf(v53) -- line 338 | captures: LocalModelHider
    local v54 = v53:FindFirstAncestorOfClass("Model")
    while true do
        if v54 then
            if LocalModelHider.IsHidden(v54) then
                break
            end
            v54 = v54:FindFirstAncestorOfClass("Model")
            continue
        end
        return nil
    end
    return v54
end

local function hoverRaycast(v55, v56) -- line 355 | captures: v50, Workspace, v49, hiddenModelOf
    local v57 = Workspace:Raycast(v55, v56, v49)
    local v58
    local v59 = 0
    while true do
        if v57 and v57.Instance:IsA("BasePart") then
            local v60 = hiddenModelOf(v57.Instance)
            if v60 then
                v59 += 1
                if v59 > 8 then
                    return nil
                end
                local v61
                if v58 then
                    v61 = v58
                else
                    local v62 = RaycastParams.new()
                    v62.FilterType = Enum.RaycastFilterType.Exclude
                    if v50 then
                        v62.FilterDescendantsInstances = { v50 }
                    else
                        v62.FilterDescendantsInstances = {}
                    end
                    v61 = v62
                end
                v61:AddToFilter(v60)
                v57 = Workspace:Raycast(v55, v56, v61)
                v58 = v61
                continue
            end
            break
        end
        return v57
    end
    return v57
end

local function step() -- line 380 | captures: v5, v24, WeightKg, UserInputService, Workspace, UiFrames, setHighlightShown, resolveTarget, show, hoverRaycast
    if UiFrames.GetOpen() == nil then
        local CurrentCamera = Workspace.CurrentCamera
        if CurrentCamera then
            local v63 = UserInputService:GetMouseLocation()
            local v64 = CurrentCamera:ViewportPointToRay(v63.X, v63.Y)
            local v65 = hoverRaycast(v64.Origin, v64.Direction * 120)
            local v66 = v65 and v65.Instance
            if v66 and v66:IsA("BasePart") then
                local v67, v68 = resolveTarget(v66)
                if v67 and v68 and not v67:GetAttribute("Broken") then
                    show(v67, v68, v63)
                    return
                end
                v24 = nil
                WeightKg = nil
                local v69 = v5
                if v69 and v69.Visible then
                    v69.Visible = false
                end
                setHighlightShown(false)
                return
            end
            v24 = nil
            WeightKg = nil
            local v70 = v5
            if v70 and v70.Visible then
                v70.Visible = false
            end
        else
            v24 = nil
            WeightKg = nil
            local v71 = v5
            if v71 and v71.Visible then
                v71.Visible = false
            end
        end
    else
        v24 = nil
        WeightKg = nil
        local v72 = v5
        if v72 and v72.Visible then
            v72.Visible = false
        end
    end
    setHighlightShown(false)
end

function v1.Start() -- line 414 | captures: v5, v6, v7, v8, v9, v24, WeightKg, v50, Players, RunService, UserInputService, Workspace, setHighlightShown, positionFrame, v49, setHoverFilter, step
    local Character = Players.LocalPlayer.Character
    v50 = Character
    local v73 = if Character then { Character } else {}
    v49.FilterDescendantsInstances = v73
    Players.LocalPlayer.CharacterAdded:Connect(setHoverFilter)
    task.spawn(function() -- line 421 | captures: v5, v6, v7, v8, v9, Players
        local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
        PlayerGui.ChildAdded:Connect(function(v74) -- line 424 | captures: v5, v6, v7, v8, v9
            if v74.Name == "MainGUI" then
                task.spawn(function() -- line 85 | captures: v74, v5, v6, v7, v8, v9
                    local v75 = v74:WaitForChild("AnimalWeight", 10)
                    if v75 and v75:IsA("GuiObject") then
                        v75.Visible = false
                        v5 = v75
                        v8 = v75:FindFirstAncestorOfClass("ScreenGui")
                        v9 = nil
                        local v76 = v75:FindFirstChild("Amount", true)
                        if v76 then
                            if not v76:IsA("TextLabel") then
                                v76 = nil
                            end
                        else
                            v76 = nil
                        end
                        v6 = v76
                        local v77 = v75:FindFirstChild("Gender", true)
                        if not (v77 and v77:IsA("ImageLabel")) then
                            v77 = nil
                        end
                        v7 = v77
                    else
                        warn("[HoverInfoController] MainGUI.AnimalWeight (Frame) not found")
                    end
                end)
            end
        end)
        local MainGUI = PlayerGui:FindFirstChild("MainGUI")
        if MainGUI then
            task.spawn(function() -- line 85 | captures: MainGUI, v5, v6, v7, v8, v9
                local v78 = MainGUI:WaitForChild("AnimalWeight", 10)
                if v78 and v78:IsA("GuiObject") then
                    v78.Visible = false
                    v5 = v78
                    v8 = v78:FindFirstAncestorOfClass("ScreenGui")
                    v9 = nil
                    local v79 = v78:FindFirstChild("Amount", true)
                    if v79 then
                        if not v79:IsA("TextLabel") then
                            v79 = nil
                        end
                    else
                        v79 = nil
                    end
                    v6 = v79
                    local v80 = v78:FindFirstChild("Gender", true)
                    if not (v80 and v80:IsA("ImageLabel")) then
                        v80 = nil
                    end
                    v7 = v80
                else
                    warn("[HoverInfoController] MainGUI.AnimalWeight (Frame) not found")
                end
            end)
        end
    end)
    local v81 = 0.05
    RunService.RenderStepped:Connect(function(v82) -- line 443 | captures: v81, v5, v24, WeightKg, UserInputService, Workspace, setHighlightShown, positionFrame, step
        local v83 = v24
        local v84
        if v83 then
            if v83:IsDescendantOf(Workspace) then
                v84 = true
            else
                v24 = nil
                WeightKg = nil
                local v85 = v5
                if v85 and v85.Visible then
                    v85.Visible = false
                end
                v84 = false
            end
        else
            v84 = true
        end
        if not v84 then
            setHighlightShown(false)
        end
        v81 += v82
        if v81 >= 0.05 then
            v81 = 0
            step()
        else
            local v86 = v5
            if v24 and v86 and v86.Visible then
                positionFrame(v86, UserInputService:GetMouseLocation())
            end
        end
    end)
end

return v1
