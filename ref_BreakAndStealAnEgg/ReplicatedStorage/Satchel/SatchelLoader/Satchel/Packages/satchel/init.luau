-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ContextActionService = game:GetService("ContextActionService")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local VRService = game:GetService("VRService")
local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local v1 = {
    OpenClose = nil,
    IsOpen = false,
    StateChanged = Instance.new("BindableEvent"),
    ModuleName = "Backpack",
    KeepVRTopbarOpen = true,
    VRIsExclusive = true,
    VRClosesNonExclusive = true,
    BackpackEmpty = Instance.new("BindableEvent")
}

v1.BackpackEmpty.Name = "BackpackEmpty"
v1.BackpackItemAdded = Instance.new("BindableEvent")
v1.BackpackItemAdded.Name = "BackpackAdded"
v1.BackpackItemRemoved = Instance.new("BindableEvent")
v1.BackpackItemRemoved.Name = "BackpackRemoved"

local script_2 = script
require(script.Attribution)
local v2 = GuiService.PreferredTransparency or 1
local v3 = not script_2:GetAttribute("OutlineEquipBorder") or false
local InsetIconPadding = script_2:GetAttribute("InsetIconPadding")
local v4 = script_2:GetAttribute("BackgroundTransparency") or 0.3
local v5 = v4 * v2
local v6 = v5
local v7 = UDim.new(0, 8)
local v8 = script_2:GetAttribute("BackgroundColor3") or Color3.new(0.09803921568627451, 0.10588235294117647, 0.11372549019607843)
local v9 = script_2:GetAttribute("EquipBorderColor3") or Color3.new(0, 0.6352941176470588, 1)
local v10 = script_2:GetAttribute("BackgroundTransparency") or 0.3
local v11 = v10 * v2
local v12 = script_2:GetAttribute("EquipBorderSizePixel") or 5
local v13 = script_2:GetAttribute("CornerRadius") or UDim.new(0, 8)
local v14 = Color3.new(1, 1, 1)
local v15 = v13 - UDim.new(0, 5) or UDim.new(0, 3)
local v16 = script_2:GetAttribute("BackgroundColor3") or Color3.new(0.09803921568627451, 0.10588235294117647, 0.11372549019607843)
local v17 = script_2:GetAttribute("TextColor3") or Color3.new(1, 1, 1)
local v18 = script_2:GetAttribute("TextStrokeTransparency") or 0.5
local v19 = script_2:GetAttribute("TextStrokeColor3") or Color3.new(0, 0, 0)
local v20 = Color3.new(0.09803921568627451, 0.10588235294117647, 0.11372549019607843)
local v21 = v2 * 0.2
local v22 = v21
local v23 = Color3.new(1, 1, 1)
local v24 = UDim.new(0, 3)
local v25 = script_2:GetAttribute("FontFace") or Font.new("rbxasset://fonts/families/BuilderSans.json")
local v26 = script_2:GetAttribute("TextSize") or 16
local Value = Enum.KeyCode.Backspace.Value
local Value_2 = Enum.KeyCode.Zero.Value
local v27 = 60
local v28 = {}

v28[Enum.UserInputType.MouseButton1] = true
v28[Enum.UserInputType.MouseButton2] = true
v28[Enum.UserInputType.MouseButton3] = true
v28[Enum.UserInputType.MouseMovement] = true
v28[Enum.UserInputType.MouseWheel] = true

local v29 = {}

v29[Enum.UserInputType.Gamepad1] = true
v29[Enum.UserInputType.Gamepad2] = true
v29[Enum.UserInputType.Gamepad3] = true
v29[Enum.UserInputType.Gamepad4] = true
v29[Enum.UserInputType.Gamepad5] = true
v29[Enum.UserInputType.Gamepad6] = true
v29[Enum.UserInputType.Gamepad7] = true
v29[Enum.UserInputType.Gamepad8] = true

local v30 = true
local v31 = require(script.Parent.topbarplus).new():setName("Inventory"):setImage("rbxasset://textures/ui/TopBar/inventoryOn.png", "Selected"):setImage("rbxasset://textures/ui/TopBar/inventoryOff.png", "Deselected"):setImageScale(1):setCaption("Inventory"):bindToggleKey(Enum.KeyCode.Backquote):autoDeselect(false):setOrder(-1)
v31.toggled:Connect(function() -- line 156 | captures: GuiService, v1
    if not GuiService.MenuIsOpen then
        v1.OpenClose()
    end
end)
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.DisplayOrder = 120
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "BackpackGui"
ScreenGui.Parent = PlayerGui

local v32 = GuiService:IsTenFootInterface()

if v32 then
    v27 = 100
    v26 = 24
end
local v33 = false
local v34 = UserInputService.TouchEnabled and workspace.CurrentCamera.ViewportSize.X < 1024
local LocalPlayer = Players.LocalPlayer
local LocalPlayer_2 = LocalPlayer
local v35, v36, v37, v38, v39, v40, v41
local Character = LocalPlayer.Character
local v42 = Character

if not Character then
    Character = LocalPlayer.CharacterAdded:Wait()
    v42 = Character
end
local Humanoid = Character:FindFirstChildOfClass("Humanoid")
local v43 = Humanoid
while not Humanoid do
    Character.ChildAdded:Wait()
    Humanoid = Character:FindFirstChildOfClass("Humanoid")
    v43 = Humanoid
end
local v44 = LocalPlayer:WaitForChild("Backpack")
local v45 = {}
local v46
local v47 = {}
local v48 = {}
local v49 = {}
local v50 = 0
local v51
local v52 = false
local v53 = false
local v54 = false
local v55 = false
local v56 = {}
local v57 = false
local VREnabled = VRService.VREnabled
local v58, v59

if VREnabled then
    v59 = 6
    v58 = 3
elseif v34 then
    v59 = 6
    v58 = 2
else
    v59 = 10
    v58 = 4
end
local v60

local function EvaluateBackpackPanelVisibility(v61) -- line 223 | captures: v30, VRService, v31
    return v61 and v31.enabled and v30 and VRService.VREnabled
end

local function ShowVRBackpackPopup() -- line 227
end

local v62 = v59

local function FindLowestEmpty() -- line 233 | captures: v45, v62
    for v63 = 1, v62 do
        local v64 = v45[v63]
        if not v64.Tool then
            return v64
        end
    end
    return nil
end

function v1.IsInventoryEmpty() -- line 243 | captures: v45, v62
    local v65 = v62 + 1
    local v66 = #v45
    for v67 = v65, v66 do
        local v68 = v45[v67]
        if v68 and v68.Tool then
            return false
        end
    end
    return true
end

local function UseGazeSelection() -- line 255
    return false
end

local function AdjustHotbarFrames() -- line 259 | captures: v37, v50, v45, v62
    local Visible = v37.Visible
    local v69 = Visible and v62 or v50
    local v70 = 0
    for v71 = 1, v62 do
        local v72 = v45[v71]
        if v72.Tool or Visible then
            v70 += 1
            v72:Readjust(v70, v69)
            v72.Frame.Visible = true
        else
            v72.Frame.Visible = false
        end
    end
end

local function UpdateScrollingFrameCanvasSize() -- line 276 | captures: v27, v39, v40
    local v73 = v39.AbsoluteSize.X / (v27 + 5)
    local v74 = math.floor(v73)
    local v75 = (#v40:GetChildren() - 1) / v74
    local v76 = math.ceil(v75) * (v27 + 5) + 5
    v39.CanvasSize = UDim2.fromOffset(0, v76)
end

local function AdjustInventoryFrames() -- line 283 | captures: v27, v39, v40, v45, v62
    local v77 = v62 + 1
    local v78 = #v45
    for v79 = v77, v78 do
        local v80 = v45[v79]
        v80.Frame.LayoutOrder = v80.Index
        v80.Frame.Visible = v80.Tool ~= nil
    end
    local v81 = v39.AbsoluteSize.X / (v27 + 5)
    local v82 = math.floor(v81)
    local v83 = (#v40:GetChildren() - 1) / v82
    local v84 = math.ceil(v83) * (v27 + 5) + 5
    v39.CanvasSize = UDim2.fromOffset(0, v84)
end

local v85 = v58

local function UpdateBackpackLayout() -- line 292 | captures: v27, v36, v37, v39, VREnabled, v62, AdjustHotbarFrames, AdjustInventoryFrames, v85
    v36.Size = UDim2.new(0, v62 * (v27 + 5) + 5, 0, v27 + 5 + 5)
    v36.Position = UDim2.new(0.5, -v36.Size.X.Offset / 2, 1, -v36.Size.Y.Offset)
    local v86 = v37
    local new = UDim2.new
    local Offset = v36.Size.X.Offset
    local v87 = v36.Size.Y.Offset * v85 + 40
    local v88 = if VREnabled then 80 else 0
    v86.Size = new(0, Offset, 0, v87 + v88)
    v37.Position = UDim2.new(0.5, -v37.Size.X.Offset / 2, 1, v36.Position.Y.Offset - v37.Size.Y.Offset)
    local v89 = v39
    local new_2 = UDim2.new
    local v90 = v39.ScrollBarThickness + 1
    local v91 = if VREnabled then 80 else 0
    v89.Size = new_2(1, v90, 1, -40 - v91)
    local fromOffset = UDim2.fromOffset
    local v92 = if VREnabled then 40 else 0
    v89.Position = fromOffset(0, 40 + v92)
    AdjustHotbarFrames()
    AdjustInventoryFrames()
end

local function Clamp(v93, v94, v95) -- line 326
    local v96 = math.max(v93, v95)
    return (math.min(v94, v96))
end

local function CheckBounds(v97, v98, v99) -- line 330
    local AbsolutePosition = v97.AbsolutePosition
    local AbsoluteSize = v97.AbsoluteSize
    if AbsolutePosition.X < v98 and v98 <= AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y < v99 then
        return v99 <= AbsolutePosition.Y + AbsoluteSize.Y
    end
    return false
end

local function GetOffset(v100, v101) -- line 336
    return (v100.AbsolutePosition + v100.AbsoluteSize / 2 - v101).Magnitude
end

local function DisableActiveHopper() -- line 341 | captures: v51, v47
    v51:ToggleSelect()
    v47[v51]:UpdateEquipView()
    v51 = nil
end

local function UnequipAllTools() -- line 347 | captures: v43, v51, v47
    if v43 then
        v43:UnequipTools()
        if v51 then
            v51:ToggleSelect()
            v47[v51]:UpdateEquipView()
            v51 = nil
        end
    end
end

local function EquipNewTool(v102) -- line 356 | captures: v43, v51, v47
    if v43 then
        v43:UnequipTools()
        if v51 then
            v51:ToggleSelect()
            v47[v51]:UpdateEquipView()
            v51 = nil
        end
    end
    v43:EquipTool(v102)
end

local function IsEquipped(v103) -- line 362 | captures: v42
    return v103 and v103.Parent == v42
end

local MakeSlot

local function MakeSlot_2(v104, v105) -- line 367 | captures: v11, v26, v27, v33, v36, v37, v39, v40, v41, v42, v43, v44, v46, v50, v51, v53, v55, v60, ContextActionService, UserInputService, v3, InsetIconPadding, v12, v14, v13, v18, Value_2, v31, v45, v47, v48, v49, v62, MakeSlot, v25, v19, v17, v16, v15, v9, v8
    local v106 = v105 or #v45 + 1
    local v107 = {
        Tool = nil,
        Index = v106,
        Frame = nil
    }
    local v108, v109, v110, v111, v112, v113, v114, v115

    local function UpdateSlotFading() -- line 392 | captures: v108, v11
        v108.SelectionImageObject = nil
        local v116 = v108
        if v108.Draggable then
            v116.BackgroundTransparency = 0
        else
            v116.BackgroundTransparency = v11
        end
    end

    function v107.Readjust(v117, v118, v119) -- line 398 | captures: v108, v27, v36
        local v120 = v36.Size.X.Offset / 2
        local v121 = v27 + 5
        local v122 = v118 - (v119 / 2 + 0.5)
        v108.Position = UDim2.fromOffset(v120 - v27 / 2 + v121 * v122, 5)
    end

    function v107.Fill(v123, v124) -- line 408 | captures: v108, v110, v111, v112, v114, v33, v37, v41, v46, v50, v53, ContextActionService, UserInputService, v45, v47, v62
        if v124 then
            v123.Tool = v124

            local function assignToolData() -- line 417 | captures: v124, v110, v111, v114
                local TextureId = v124.TextureId
                v110.Image = TextureId
                if TextureId == "" then
                    v111.Visible = true
                else
                    v111.Visible = false
                end
                v111.Text = v124.Name
                if not (v114 and v124:IsA("Tool")) then
                    return
                end
                v114.Text = v124.ToolTip
                v114.Size = UDim2.fromOffset(0, 16)
                v114.Position = UDim2.new(0.5, 0, 0, -5)
            end

            assignToolData()
            if v112 then
                v112:Disconnect()
                v112 = nil
            end
            v112 = v124.Changed:Connect(function(v125) -- line 446 | captures: assignToolData
                if not (v125 ~= "TextureId" and v125 ~= "Name" and v125 ~= "ToolTip") then
                    assignToolData()
                end
            end)
            local v126 = v123.Index <= v62
            local Visible = v37.Visible
            if (not v126 or Visible) and not UserInputService.VREnabled then
                v108.Draggable = true
            end
            v123:UpdateEquipView()
            if v126 then
                v50 += 1
                if v53 and v50 >= 1 and not v33 then
                    v33 = true
                    ContextActionService:BindAction("BackpackHotbarEquip", v41, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
                end
            end
            v47[v124] = v123
            local v127 = false
            local v128
            for v129 = 1, v62 do
                local v130 = v45[v129]
                if not v130.Tool then
                    v128 = v130
                    v127 = true
                    break
                end
            end
            if not v127 then
                v128 = nil
            end
            v46 = v128
        else
            return v123:Clear()
        end
    end

    function v107.Clear(v131) -- line 482 | captures: v108, v110, v111, v112, v114, v33, v46, v50, ContextActionService, v45, v47, v62
        if not v131.Tool then
            return
        end
        if v112 then
            v112:Disconnect()
            v112 = nil
        end
        v110.Image = ""
        v111.Text = ""
        if v114 then
            v114.Text = ""
            v114.Visible = false
        end
        v108.Draggable = false
        v131:UpdateEquipView(true)
        if v131.Index <= v62 then
            v50 -= 1
            if v50 < 1 then
                v33 = false
                ContextActionService:UnbindAction("BackpackHotbarEquip")
            end
        end
        v47[v131.Tool] = nil
        v131.Tool = nil
        local v132 = false
        local v133
        for v134 = 1, v62 do
            local v135 = v45[v134]
            if not v135.Tool then
                v133 = v135
                v132 = true
                break
            end
        end
        if not v132 then
            v133 = nil
        end
        v46 = v133
    end

    function v107.UpdateEquipView(v136, v137) -- line 517 | captures: v108, v110, v113, v107, v11, v42, v60, v3, v12, v9
        local v138
        if v137 then
            v138 = false
        else
            local Tool = v136.Tool
            v138 = not not (Tool and Tool.Parent == v42)
        end
        if v138 then
            v60 = v107
            if not v113 then
                v113 = Instance.new("UIStroke")
                v113.Name = "Border"
                v113.Thickness = v12
                v113.Color = v9
                v113.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            end
            if v3 == true then
                v113.Parent = v110
            else
                v113.Parent = v108
            end
        elseif v113 then
            v113.Parent = nil
        end
        v108.SelectionImageObject = nil
        local v139 = v108
        if v108.Draggable then
            v139.BackgroundTransparency = 0
        else
            v139.BackgroundTransparency = v11
        end
    end

    function v107.IsEquipped(v140) -- line 541 | captures: v42
        local Tool = v140.Tool
        return Tool and Tool.Parent == v42
    end

    function v107.Delete(v141) -- line 545 | captures: v108, v27, v39, v40, v45
        v108:Destroy()
        table.remove(v45, v141.Index)
        local v142 = #v45
        local Index = v141.Index
        for v143 = Index, v142 do
            v45[v143]:SlideBack()
        end
        local v144 = v39.AbsoluteSize.X / (v27 + 5)
        local v145 = math.floor(v144)
        local v146 = (#v40:GetChildren() - 1) / v145
        local v147 = math.ceil(v146) * (v27 + 5) + 5
        v39.CanvasSize = UDim2.fromOffset(0, v147)
    end

    local function Swap(v148, v149) -- line 558
        local Tool = v148.Tool
        local Tool_2 = v149.Tool
        v148:Clear()
        if Tool_2 then
            v149:Clear()
            v148:Fill(Tool_2)
        end
        if Tool then
            v149:Fill(Tool)
        else
            v149:Clear()
        end
    end

    v107.Swap = Swap

    function v107.SlideBack(v150) -- line 572 | captures: v108
        v150.Index -= 1
        v108.Name = v150.Index
        v108.LayoutOrder = v150.Index
    end

    function v107.TurnNumber(v151, v152) -- line 578 | captures: v115
        if v115 then
            v115.Visible = v152
        end
    end

    function v107.SetClickability(v153, v154) -- line 584 | captures: v108, v11, UserInputService
        if not v153.Tool then
            return
        end
        if UserInputService.VREnabled then
            v108.Draggable = false
        else
            v108.Draggable = not v154
        end
        v108.SelectionImageObject = nil
        local v155 = v108
        if v108.Draggable then
            v155.BackgroundTransparency = 0
        else
            v155.BackgroundTransparency = v11
        end
    end

    function v107.CheckTerms(v156, v157) -- line 595 | captures: v111, v114
        local v158 = 0

        local function checkEm(v159, v160) -- line 597 | captures: v158
            local v161, v162 = v159:lower():gsub(v160, "")
            v158 += v162
        end

        local Tool = v156.Tool
        if Tool then
            for v163 in pairs(v157) do
                local v164, v165 = v111.Text:lower():gsub(v163, "")
                v158 += v165
                if Tool:IsA("Tool") then
                    local v166, v167 = (v114 and v114.Text or ""):lower():gsub(v163, "")
                    v158 += v167
                end
            end
        end
        return v158
    end

    function v107.Select(v168) -- line 615 | captures: v107, v42, v43, v44, v51, v47
        local Tool = v107.Tool
        if Tool then
            if Tool.Parent == v42 then
                if v43 then
                    v43:UnequipTools()
                    if v51 then
                        v51:ToggleSelect()
                        v47[v51]:UpdateEquipView()
                        v51 = nil
                    end
                end
            elseif Tool.Parent == v44 then
                if v43 then
                    v43:UnequipTools()
                    if v51 then
                        v51:ToggleSelect()
                        v47[v51]:UpdateEquipView()
                        v51 = nil
                    end
                end
                v43:EquipTool(Tool)
            end
        end
    end

    v108 = Instance.new("TextButton")
    local v169 = tostring(v106)
    v108.Name = v169
    v108.BackgroundColor3 = v8
    v108.BorderColor3 = v14
    v108.Text = ""
    v108.BorderSizePixel = 0
    v169 = UDim2.fromOffset(v27, v27)
    v108.Size = v169
    v108.Active = true
    v108.Draggable = false
    v169 = v11
    v108.BackgroundTransparency = v169
    v108.MouseButton1Click:Connect(function() -- line 638 | captures: v107
        changeSlot(v107)
    end)
    v169 = Instance.new("UICorner")
    v169.Name = "Corner"
    v169.CornerRadius = v13
    v169.Parent = v108
    v107.Frame = v108
    local Frame = Instance.new("Frame")
    Frame.Name = "SelectionObjectClipper"
    Frame.BackgroundTransparency = 1
    Frame.Visible = false
    Frame.Parent = v108
    local v170 = Instance.new("ImageLabel")
    v170.Name = "Selector"
    v170.BackgroundTransparency = 1
    v170.Size = UDim2.fromScale(1, 1)
    v170.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png"
    v170.ScaleType = Enum.ScaleType.Slice
    v170.SliceCenter = Rect.new(12, 12, 52, 52)
    v170.Parent = Frame
    v110 = Instance.new("ImageLabel")
    v110.BackgroundTransparency = 1
    v110.Name = "Icon"
    Frame = UDim2.fromScale(1, 1)
    v110.Size = Frame
    Frame = UDim2.fromScale(0.5, 0.5)
    v110.Position = Frame
    Frame = Vector2.new(0.5, 0.5)
    v110.AnchorPoint = Frame
    if InsetIconPadding == true then
        Frame = UDim2.new(1, -v12 * 2, 1, -v12 * 2)
    else
        Frame = UDim2.fromScale(1, 1)
    end
    v110.Size = Frame
    v110.Parent = v108
    Frame = Instance.new("UICorner")
    Frame.Name = "Corner"
    if InsetIconPadding == true then
        Frame.CornerRadius = v13 - UDim.new(0, v12)
    else
        Frame.CornerRadius = v13
    end
    Frame.Parent = v110
    v111 = Instance.new("TextLabel")
    v111.BackgroundTransparency = 1
    v111.Name = "ToolName"
    v111.Text = ""
    v111.TextColor3 = v17
    v111.TextStrokeTransparency = v18
    v111.TextStrokeColor3 = v19
    v170 = Font.new(v25.Family, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    v111.FontFace = v170
    v170 = v26
    v111.TextSize = v170
    v170 = UDim2.new(1, -v12 * 2, 1, -v12 * 2)
    v111.Size = v170
    v170 = UDim2.fromScale(0.5, 0.5)
    v111.Position = v170
    v170 = Vector2.new(0.5, 0.5)
    v111.AnchorPoint = v170
    v111.TextWrapped = true
    v170 = Enum.TextTruncate.AtEnd
    v111.TextTruncate = v170
    v111.Parent = v108
    v107.Frame.LayoutOrder = v107.Index
    local UIPadding, v171
    if v106 <= v62 then
        v114 = Instance.new("TextLabel")
        v114.Name = "ToolTip"
        v114.Text = ""
        v170 = UDim2.fromScale(1, 1)
        v114.Size = v170
        v114.TextColor3 = v17
        v114.TextStrokeTransparency = v18
        v114.TextStrokeColor3 = v19
        v170 = Font.new(v25.Family, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        v114.FontFace = v170
        v170 = v26
        v114.TextSize = v170
        v114.ZIndex = 2
        v114.TextWrapped = false
        v170 = Enum.TextYAlignment.Center
        v114.TextYAlignment = v170
        v114.BackgroundColor3 = v16
        v170 = v11
        v114.BackgroundTransparency = v170
        v170 = Vector2.new(0.5, 1)
        v114.AnchorPoint = v170
        v114.BorderSizePixel = 0
        v114.Visible = false
        v170 = Enum.AutomaticSize.X
        v114.AutomaticSize = v170
        v114.Parent = v108
        v170 = Instance.new("UICorner")
        v170.Name = "Corner"
        v170.CornerRadius = v15
        v170.Parent = v114
        UIPadding = Instance.new("UIPadding")
        UIPadding.PaddingLeft = UDim.new(0, 4)
        UIPadding.PaddingRight = UDim.new(0, 4)
        UIPadding.PaddingTop = UDim.new(0, 4)
        UIPadding.PaddingBottom = UDim.new(0, 4)
        UIPadding.Parent = v114
        v108.MouseEnter:Connect(function() -- line 737 | captures: v114
            if v114.Text ~= "" then
                v114.Visible = true
            end
        end)
        v108.MouseLeave:Connect(function() -- line 742 | captures: v114
            v114.Visible = false
        end)

        function v107.MoveToInventory(v172) -- line 746 | captures: v107, v37, v40, v42, v43, v51, v55, v47, v62, MakeSlot
            if not (v107.Index <= v62) then
                return
            end
            local Tool = v107.Tool
            v172:Clear()
            local v173 = MakeSlot(v40)
            v173:Fill(Tool)
            if Tool and Tool.Parent == v42 and v43 then
                v43:UnequipTools()
                if v51 then
                    v51:ToggleSelect()
                    v47[v51]:UpdateEquipView()
                    v51 = nil
                end
            end
            if v55 then
                v173.Frame.Visible = false
                v173.Parent = v37
            end
        end

        if v106 < 10 then
            v171 = false
        else
            v171 = v106 ~= v62
        end
    else
        v171 = true
    end
    local v174
    if not v171 then
        if not (v106 < 10) or not v106 then
            v174 = 0
        else
            v174 = v106
        end
        v115 = Instance.new("TextLabel")
        v115.BackgroundTransparency = 1
        v115.Name = "Number"
        v115.TextColor3 = v17
        v115.TextStrokeTransparency = v18
        v115.TextStrokeColor3 = v19
        local v175 = v26
        v115.TextSize = v175
        v175 = tostring(v174)
        v115.Text = v175
        v175 = Font.new(v25.Family, Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
        v115.FontFace = v175
        v175 = UDim2.fromScale(0.4, 0.4)
        v115.Size = v175
        v115.Visible = false
        v115.Parent = v108
        v48[Value_2 + v174] = v107.Select
    end
    local v176 = v108.Position
    local v177 = 0
    local Parent
    v108.DragBegin:Connect(function(v178) -- line 787 | captures: v108, v109, v110, v111, v115, v176, Parent, v37, v40, v31, v49
        v49[v108] = true
        v176 = v178
        v108.BorderSizePixel = 2
        v31:lock()
        v108.ZIndex = 2
        v110.ZIndex = 2
        v111.ZIndex = 2
        v108.Parent.ZIndex = 2
        if v115 then
            v115.ZIndex = 2
        end
        Parent = v108.Parent
        if Parent ~= v40 then
            return
        end
        local v179 = UDim2.new(0, v108.AbsolutePosition.X - v37.AbsolutePosition.X, 0, v108.AbsolutePosition.Y - v37.AbsolutePosition.Y)
        v108.Parent = v37
        v108.Position = v179
        v109 = Instance.new("Frame")
        v109.Name = "FakeSlot"
        v109.LayoutOrder = v108.LayoutOrder
        v109.Size = v108.Size
        v109.BackgroundTransparency = 1
        v109.Parent = v40
    end)
    v108.DragStopped:Connect(function(v180, v181) -- line 830 | captures: v108, v109, v110, v111, v115, v176, v177, Parent, v107, v36, v37, v42, v43, v46, v51, v55, v31, v45, v47, v49, v62
        if v109 then
            v109:Destroy()
        end
        local v182 = os.clock()
        v108.Position = v176
        v108.Parent = Parent
        v108.BorderSizePixel = 0
        v31:unlock()
        v108.ZIndex = 1
        v110.ZIndex = 1
        v111.ZIndex = 1
        Parent.ZIndex = 1
        if v115 then
            v115.ZIndex = 1
        end
        v49[v108] = nil
        if not v107.Tool then
            return
        end
        local v183 = v37
        local AbsolutePosition = v183.AbsolutePosition
        local AbsoluteSize = v183.AbsoluteSize
        if AbsolutePosition.X < v180 and v180 <= AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y < v181 and v181 <= AbsolutePosition.Y + AbsoluteSize.Y then
            if v107.Index <= v62 then
                v107:MoveToInventory()
            end
            local Index = v107.Index
            if v62 < Index and v182 - v177 < 0.5 then
                if v46 then
                    local Tool = v107.Tool
                    v107:Clear()
                    v46:Fill(Tool)
                    v107:Delete()
                end
                v177 = 0
            else
                v177 = v182
            end
        else
            local v184 = v36
            local AbsolutePosition = v184.AbsolutePosition
            local AbsoluteSize = v184.AbsoluteSize
            if AbsolutePosition.X < v180 and v180 <= AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y < v181 and v181 <= AbsolutePosition.Y + AbsoluteSize.Y then
                local v185 = { (1/0), nil }
                for v186 = 1, v62 do
                    local v187 = v45[v186]
                    local Frame = v187.Frame
                    local v188 = Vector2.new(v180, v181)
                    local Magnitude = (Frame.AbsolutePosition + Frame.AbsoluteSize / 2 - v188).Magnitude
                    if Magnitude < v185[1] then
                        v185 = { Magnitude, v187 }
                    end
                end
                local v189 = v185[2]
                if v189 ~= v107 then
                    v107:Swap(v189)
                    local Index = v107.Index
                    if v62 < Index then
                        local Tool = v107.Tool
                        if Tool then
                            if Tool.Parent == v42 and v43 then
                                v43:UnequipTools()
                                if v51 then
                                    v51:ToggleSelect()
                                    v47[v51]:UpdateEquipView()
                                    v51 = nil
                                end
                            end
                            if v55 then
                                v107.Frame.Visible = false
                                v107.Frame.Parent = v37
                            end
                        else
                            v107:Delete()
                        end
                    end
                end
            elseif v107.Index <= v62 then
                v107:MoveToInventory()
            end
            v177 = v182
        end
    end)
    v108.Parent = v104
    v45[v106] = v107
    if v62 < v106 then
        UIPadding = v39.AbsoluteSize.X / (v27 + 5)
        v170 = math.floor(UIPadding)
        v174 = (#v40:GetChildren() - 1) / v170
        v174 = math.ceil(v174) * (v27 + 5) + 5
        v39.CanvasSize = UDim2.fromOffset(0, v174)
        if v37.Visible and not v55 then
            v170 = v39.CanvasSize.Y.Offset - v39.AbsoluteSize.Y
            v39.CanvasPosition = Vector2.new(0, (math.max(0, v170)))
        end
    end
    return v107
end

MakeSlot = MakeSlot_2

local function OnChildAdded(v190) -- line 940 | captures: LocalPlayer_2, v37, v40, v42, v43, v44, v46, v51, v52, v1, v45, v47, v62, AdjustHotbarFrames, MakeSlot_2
    if not (v190:IsA("Tool") or v190:IsA("HopperBin")) then
        if v190:IsA("Humanoid") and v190.Parent == v42 then
            v43 = v190
        end
    else
        if v190.Parent == v42 then
        end
        if v51 and v190.Parent == v42 then
            v51:ToggleSelect()
            v47[v51]:UpdateEquipView()
            v51 = nil
        end
        local v191, v192
        if v52 then
            v192 = true
        elseif v190.Parent == v42 then
            if v47[v190] then
                v192 = true
            else
                local StarterGear = LocalPlayer_2:FindFirstChild("StarterGear")
                if StarterGear and StarterGear:FindFirstChild(v190.Name) then
                    v52 = true
                    v191 = v46 or MakeSlot_2(v40)
                    v192 = false
                else
                    v192 = true
                end
            end
        else
            v192 = true
        end
        if not v192 then
            local Index = v191.Index
            for v193 = Index, 1, -1 do
                local v194 = v45[v193]
                local v195 = v193 - 1
                if v195 > 0 then
                    v45[v195]:Swap(v194)
                else
                    v194:Fill(v190)
                end
            end
            for v196, v197 in pairs(v42:GetChildren()) do
                if v197:IsA("Tool") and v197 ~= v190 then
                    v197.Parent = v44
                end
            end
            AdjustHotbarFrames()
        else
            local v198 = v47[v190]
            if v198 then
                v198:UpdateEquipView()
            else
                local v199 = v46 or MakeSlot_2(v40)
                v199:Fill(v190)
                if v199.Index <= v62 and not v37.Visible then
                    AdjustHotbarFrames()
                end
                if v190:IsA("HopperBin") and v190.Active then
                    if v43 then
                        v43:UnequipTools()
                        if v51 then
                            v51:ToggleSelect()
                            v47[v51]:UpdateEquipView()
                            v51 = nil
                        end
                    end
                    v51 = v190
                end
            end
            v1.BackpackItemAdded:Fire()
        end
    end
end

local function OnChildRemoved(v200) -- line 1007 | captures: v37, v42, v44, v51, v1, v45, v47, v62, AdjustHotbarFrames
    if not (v200:IsA("Tool") or v200:IsA("HopperBin")) then
        return
    end
    local Parent = v200.Parent
    if Parent == v42 or Parent == v44 then
        return
    end
    local v201 = v47[v200]
    if v201 then
        v201:Clear()
        local Index = v201.Index
        if v62 < Index then
            v201:Delete()
        elseif not v37.Visible then
            AdjustHotbarFrames()
        end
    end
    if v200 == v51 then
        v51 = nil
    end
    v1.BackpackItemRemoved:Fire()
    local v202 = v62 + 1
    local v203 = #v45
    local v204 = false
    local v205
    for v206 = v202, v203 do
        local v207 = v45[v206]
        if v207 and v207.Tool then
            v205 = false
            v204 = true
            break
        end
    end
    if not v204 then
        v205 = true
    end
    if v205 then
        v1.BackpackEmpty:Fire()
    end
end

local function OnCharacterAdded(v208) -- line 1041 | captures: LocalPlayer_2, v42, v44, v51, v56, v45, v62, AdjustHotbarFrames, OnChildAdded, OnChildRemoved
    local function v209(v210, ...)
        table.insert(v210, ...)
    end

    local function v211(v212, ...)
        table.insert(v212, ...)
    end

    local function v213(v214, ...)
        table.insert(v214, ...)
    end

    local function v215(v216, ...)
        table.insert(v216, ...)
    end

    local v217 = #v45
    for v218 = v217, 1, -1 do
        local v219 = v45[v218]
        if v219.Tool then
            v219:Clear()
        end
        if v62 < v218 then
            v219:Delete()
        end
    end
    v51 = nil
    for v220, v221 in pairs(v56) do
        v221:Disconnect()
    end
    v56 = {}
    v42 = v208
    v209(v56, v208.ChildRemoved:Connect(OnChildRemoved))
    v211(v56, v208.ChildAdded:Connect(OnChildAdded))
    for v222, v223 in pairs(v208:GetChildren()) do
        OnChildAdded(v223)
    end
    v44 = LocalPlayer_2:WaitForChild("Backpack")
    v213(v56, v44.ChildRemoved:Connect(OnChildRemoved))
    v215(v56, v44.ChildAdded:Connect(OnChildAdded))
    for v224, v225 in pairs(v44:GetChildren()) do
        OnChildAdded(v225)
    end
    AdjustHotbarFrames()
end

local function OnInputBegan(v226, v227) -- line 1080 | captures: v37, v53, v54, TextChatService, Value, v31, v48
    local ChatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")
    if not (v226.UserInputType ~= Enum.UserInputType.Keyboard or v54 or ChatInputBarConfiguration.IsFocused or not v53 and v226.KeyCode.Value ~= Value) then
        local v228 = v48[v226.KeyCode.Value]
        if v228 then
            v228(v227)
        end
    end
    local UserInputType = v226.UserInputType
    if not (v227 or UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch) and v37.Visible then
        v31:deselect()
    end
end

local function OnUISChanged() -- line 1106 | captures: UserInputService, v28, v29, v45, v62
    if UserInputService:GetLastInputType() == Enum.UserInputType.Touch then
        for v229 = 1, v62 do
            v45[v229]:TurnNumber(false)
        end
    elseif UserInputService:GetLastInputType() == Enum.UserInputType.Keyboard then
        for v230 = 1, v62 do
            v45[v230]:TurnNumber(true)
        end
    else
        for v231, v232 in pairs(v28) do
            if UserInputService:GetLastInputType() == v232 then
                for v233 = 1, v62 do
                    v45[v233]:TurnNumber(true)
                end
                return
            end
        end
        for v234, v235 in pairs(v29) do
            if UserInputService:GetLastInputType() == v235 then
                for v236 = 1, v62 do
                    v45[v236]:TurnNumber(false)
                end
                return
            end
        end
    end
end

local v237, v238

local function v239() -- line 1147
end

function unbindAllGamepadEquipActions() -- line 1150 | captures: ContextActionService
    ContextActionService:UnbindAction("BackpackHasGamepadFocus")
    ContextActionService:UnbindAction("BackpackCloseInventory")
end

function v41(v240, v241, v242) -- line 1226 | captures: v43, v51, v60, v237, v238, v45, v47, v62
    if v241 ~= Enum.UserInputState.Begin then
        return
    end
    if not (not v237 or not (v237.KeyCode == Enum.KeyCode.ButtonR1 and v242.KeyCode == Enum.KeyCode.ButtonL1) and (v237.KeyCode ~= Enum.KeyCode.ButtonL1 or v242.KeyCode ~= Enum.KeyCode.ButtonR1)) and os.clock() - v238 <= 0.06 then
        if v43 then
            v43:UnequipTools()
            if v51 then
                v51:ToggleSelect()
                v47[v51]:UpdateEquipView()
                v51 = nil
            end
        end
        v237 = v242
        v238 = os.clock()
    else
        v237 = v242
        v238 = os.clock()
        task.delay(0.06, function() -- line 1254 | captures: v242, v43, v51, v60, v237, v45, v47, v62
            if v237 ~= v242 then
                return
            end
            local v243 = if v242.KeyCode == Enum.KeyCode.ButtonL1 then -1 else 1
            for v244 = 1, v62 do
                if v45[v244]:IsEquipped() then
                    local v245 = v243 + v244
                    local v246
                    if v62 < v245 then
                        v245 = 1
                        v246 = true
                    elseif v245 < 1 then
                        v245 = v62
                        v246 = true
                    else
                        v246 = false
                    end
                    local v247 = v245
                    while true do
                        if v45[v247].Tool then
                            break
                        end
                        v247 += v243
                        if v247 == v245 then
                            return
                        end
                        if v62 < v247 then
                            v247 = 1
                            v246 = true
                        elseif v247 < 1 then
                            v247 = v62
                            v246 = true
                        end
                    end
                    if v246 then
                        if v43 then
                            v43:UnequipTools()
                            if v51 then
                                v51:ToggleSelect()
                                v47[v51]:UpdateEquipView()
                                v51 = nil
                            end
                        end
                        v60 = nil
                    else
                        v45[v247]:Select()
                    end
                    return
                end
            end
            if v60 and v60.Tool then
                v60:Select()
            else
                local v248 = v243 == -1 and v62 or 1
                local v249 = if v243 == -1 then 1 else v62
                for v250 = v248, v249, v243 do
                    if v45[v250].Tool then
                        v45[v250]:Select()
                        return
                    end
                end
            end
        end)
    end
end

function getGamepadSwapSlot() -- line 1321 | captures: v45
    local v251 = #v45
    for v252 = 1, v251 do
        if v45[v252].Frame.BorderSizePixel > 0 then
            return v45[v252]
        end
    end
end

function changeSlot(v253) -- line 1331 | captures: v37, v38, GuiService, VRService, v62
    local v254 = not VRService.VREnabled or v37.Visible
    if v253.Frame == GuiService.SelectedObject and v254 then
        local v255 = getGamepadSwapSlot()
        if v255 then
            v255.Frame.BorderSizePixel = 0
            if v255 ~= v253 then
                v253:Swap(v255)
                v38.SelectionImageObject.Visible = false
                local Index = v253.Index
                if v62 < Index and not v253.Tool then
                    if GuiService.SelectedObject == v253.Frame then
                        GuiService.SelectedObject = v255.Frame
                    end
                    v253:Delete()
                end
                local Index_2 = v255.Index
                local v256
                if v62 < Index_2 then
                    if v255.Tool then
                        v256 = true
                    else
                        if GuiService.SelectedObject == v255.Frame then
                            GuiService.SelectedObject = v253.Frame
                        end
                        v256 = false
                    end
                else
                    v256 = true
                end
                if not v256 then
                    v255:Delete()
                end
            end
        else
            local Size = v253.Frame.Size
            local Position = v253.Frame.Position
            v253.Frame:TweenSizeAndPosition(Size + UDim2.fromOffset(10, 10), Position - UDim2.fromOffset(5, 5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true, function() -- line 1367 | captures: v253, Size, Position
                v253.Frame:TweenSizeAndPosition(Size, Position, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.1, true)
            end)
            v253.Frame.BorderSizePixel = 3
            v38.SelectionImageObject.Visible = true
        end
    else
        v253:Select()
        v38.SelectionImageObject.Visible = false
    end
end

function vrMoveSlotToInventory() -- line 1387 | captures: v38, VRService
    if VRService.VREnabled then
        local v257 = getGamepadSwapSlot()
        if v257 and v257.Tool then
            v257.Frame.BorderSizePixel = 0
            v257:MoveToInventory()
            v38.SelectionImageObject.Visible = false
        end
    end
end

function enableGamepadInventoryControl() -- line 1400 | captures: v36, v37, ContextActionService, GuiService, v31, v239
    local function v258() -- line 1401 | captures: v37, v31
        if getGamepadSwapSlot() then
            local v259 = getGamepadSwapSlot()
            if v259 then
                v259.Frame.BorderSizePixel = 0
            end
        elseif v37.Visible then
            v31:deselect()
        end
    end

    ContextActionService:BindAction("BackpackHasGamepadFocus", v239, false, Enum.UserInputType.Gamepad1)
    ContextActionService:BindAction("BackpackCloseInventory", v258, false, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonStart)
    GuiService.SelectedObject = v36:FindFirstChild("1")
end

function disableGamepadInventoryControl() -- line 1434 | captures: v35, GuiService, v45, v62
    unbindAllGamepadEquipActions()
    for v260 = 1, v62 do
        local v261 = v45[v260]
        if v261 and v261.Frame then
            v261.Frame.BorderSizePixel = 0
        end
    end
    if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(v35) then
        GuiService.SelectedObject = nil
    end
end

local function bindBackpackHotbarAction() -- line 1449 | captures: v33, v41, v53, ContextActionService
    if v53 and not v33 then
        v33 = true
        ContextActionService:BindAction("BackpackHotbarEquip", v41, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
    end
end

local function unbindBackpackHotbarAction() -- line 1462 | captures: v33, ContextActionService
    disableGamepadInventoryControl()
    v33 = false
    ContextActionService:UnbindAction("BackpackHotbarEquip")
end

function gamepadDisconnected() -- line 1468 | captures: v57
    v57 = false
    disableGamepadInventoryControl()
end

function gamepadConnected() -- line 1473 | captures: v33, v35, v37, v41, v50, v53, v57, ContextActionService, GuiService
    v57 = true
    GuiService:AddSelectionParent("BackpackSelection", v35)
    if v50 >= 1 and v53 and not v33 then
        v33 = true
        ContextActionService:BindAction("BackpackHotbarEquip", v41, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
    end
    if v37.Visible then
        enableGamepadInventoryControl()
    end
end

local function OnIconChanged(v262) -- line 1486 | captures: v33, v35, v41, v50, v53, ContextActionService, StarterGui
    if not pcall(function() -- line 1488 | captures: v262, StarterGui
            return v262 and StarterGui:GetCore("TopbarEnabled")
        end) then
        return
    end
    v53 = v262
    v35.Visible = v262
    if v262 then
        if v50 >= 1 and v53 and not v33 then
            v33 = true
            ContextActionService:BindAction("BackpackHotbarEquip", v41, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
        end
    else
        disableGamepadInventoryControl()
        v33 = false
        ContextActionService:UnbindAction("BackpackHotbarEquip")
    end
end

local function MakeVRRoundButton(v263, v264) -- line 1517
    local ImageButton = Instance.new("ImageButton")
    ImageButton.BackgroundTransparency = 1
    ImageButton.Name = v263
    ImageButton.Size = UDim2.fromOffset(40, 40)
    ImageButton.Image = "rbxasset://textures/ui/Keyboard/close_button_background.png"
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "Icon"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Size = UDim2.fromScale(0.5, 0.5)
    ImageLabel.Position = UDim2.fromScale(0.25, 0.25)
    ImageLabel.Image = v264
    ImageLabel.Parent = ImageButton
    local ImageLabel_2 = Instance.new("ImageLabel")
    ImageLabel_2.BackgroundTransparency = 1
    ImageLabel_2.Name = "Selection"
    ImageLabel_2.Size = UDim2.fromScale(0.9, 0.9)
    ImageLabel_2.Position = UDim2.fromScale(0.05, 0.05)
    ImageLabel_2.Image = "rbxasset://textures/ui/Keyboard/close_button_selection.png"
    ImageButton.SelectionImageObject = ImageLabel_2
    return ImageButton, ImageLabel, ImageLabel_2
end

v35 = Instance.new("Frame")
v35.BackgroundTransparency = 1
v35.Name = "Backpack"

local v265 = UDim2.fromScale(1, 1)

v35.Size = v265
v35.Visible = false
v35.Parent = ScreenGui
v36 = Instance.new("Frame")
v36.BackgroundTransparency = 1
v36.Name = "Hotbar"
v265 = UDim2.fromScale(1, 1)
v36.Size = v265
v36.Parent = v35
for v266 = 1, v59 do
    local v267 = MakeSlot_2(v36, v266)
    v267.Frame.Visible = false
    v46 = v46 or v267
end
v265 = Instance.new("ImageLabel")
v265.BackgroundTransparency = 1
v265.Name = "LeftBumper"
v265.Size = UDim2.fromOffset(40, 40)
v265.Position = UDim2.new(0, -v265.Size.X.Offset, 0.5, -v265.Size.Y.Offset / 2)

local ImageLabel = Instance.new("ImageLabel")

ImageLabel.BackgroundTransparency = 1
ImageLabel.Name = "RightBumper"
ImageLabel.Size = UDim2.fromOffset(40, 40)
ImageLabel.Position = UDim2.new(1, 0, 0.5, -ImageLabel.Size.Y.Offset / 2)
v37 = Instance.new("Frame")
v37.Name = "Inventory"

local v268 = UDim2.fromScale(1, 1)

v37.Size = v268
v37.BackgroundTransparency = v5
v37.BackgroundColor3 = v8
v37.Active = true
v37.Visible = false
v37.Parent = v35
v268 = Instance.new("UICorner")
v268.Name = "Corner"
v268.CornerRadius = v7
v268.Parent = v37
v38 = Instance.new("TextButton")
v38.Name = "VRInventorySelector"

local v269 = UDim2.new(0, 0, 0, 0)

v38.Position = v269
v269 = UDim2.fromScale(1, 1)
v38.Size = v269
v38.BackgroundTransparency = 1
v38.Text = ""
v38.Parent = v37
v269 = Instance.new("ImageLabel")
v269.BackgroundTransparency = 1
v269.Name = "Selector"
v269.Size = UDim2.fromScale(1, 1)
v269.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png"
v269.ScaleType = Enum.ScaleType.Slice
v269.SliceCenter = Rect.new(12, 12, 52, 52)
v269.Visible = false
v38.SelectionImageObject = v269
v38.MouseButton1Click:Connect(function() -- line 1614
    vrMoveSlotToInventory()
end)
v39 = Instance.new("ScrollingFrame")
v39.BackgroundTransparency = 1
v39.Name = "ScrollingFrame"

local Frame = UDim2.fromScale(1, 1)

v39.Size = Frame
v39.Selectable = false
Frame = Enum.ScrollingDirection.Y
v39.ScrollingDirection = Frame
v39.BorderSizePixel = 0
v39.ScrollBarThickness = 8
Frame = Color3.new(1, 1, 1)
v39.ScrollBarImageColor3 = Frame
Frame = Enum.ScrollBarInset.ScrollBar
v39.VerticalScrollBarInset = Frame
Frame = UDim2.new(0, 0, 0, 0)
v39.CanvasSize = Frame
v39.Parent = v37
v40 = Instance.new("Frame")
v40.BackgroundTransparency = 1
v40.Name = "UIGridFrame"
v40.Selectable = false
Frame = UDim2.new(1, -10, 1, 0)
v40.Size = Frame
Frame = UDim2.fromOffset(5, 0)
v40.Position = Frame
v40.Parent = v39
Frame = Instance.new("UIGridLayout")
Frame.SortOrder = Enum.SortOrder.LayoutOrder
Frame.CellSize = UDim2.fromOffset(v27, v27)
Frame.CellPadding = UDim2.fromOffset(5, 5)
Frame.Parent = v40

local v270 = MakeVRRoundButton("ScrollUpButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png")

v270.Size = UDim2.fromOffset(34, 34)
v270.Position = UDim2.new(0.5, -v270.Size.X.Offset / 2, 0, 43)
v270.Icon.Position = v270.Icon.Position - UDim2.fromOffset(0, 2)
v270.MouseButton1Click:Connect(function() -- line 1651 | captures: v27, v39
    local v271 = v39
    local new = Vector2.new
    local X = v39.CanvasPosition.X
    local v272 = v39.CanvasSize.Y.Offset - v39.AbsoluteWindowSize.Y
    local v273 = v39.CanvasPosition.Y - (v27 + 5)
    local v274 = math.max(0, v273)
    v271.CanvasPosition = new(X, (math.min(v272, v274)))
end)
local v275 = MakeVRRoundButton("ScrollDownButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png")

v275.Rotation = 180
v275.Icon.Position = v275.Icon.Position - UDim2.fromOffset(0, 2)
v275.Size = UDim2.fromOffset(34, 34)
v275.Position = UDim2.new(0.5, -v275.Size.X.Offset / 2, 1, -v275.Size.Y.Offset - 3)
v275.MouseButton1Click:Connect(function() -- line 1668 | captures: v27, v39
    local v276 = v39
    local new = Vector2.new
    local X = v39.CanvasPosition.X
    local v277 = v39.CanvasSize.Y.Offset - v39.AbsoluteWindowSize.Y
    local v278 = v39.CanvasPosition.Y + (v27 + 5)
    local v279 = math.max(0, v278)
    v276.CanvasPosition = new(X, (math.min(v277, v279)))
end)
v39.Changed:Connect(function(v280) -- line 1679 | captures: v39, v270, v275
    if v280 ~= "AbsoluteWindowSize" and v280 ~= "CanvasPosition" and v280 ~= "CanvasSize" then
        return
    end
    local v281 = v39.CanvasPosition.Y ~= 0
    local v282 = v39.CanvasPosition.Y < v39.CanvasSize.Y.Offset - v39.AbsoluteWindowSize.Y
    v270.Visible = v281
    v275.Visible = v282
end)
UpdateBackpackLayout()
local Frame_2 = Instance.new("Frame")

Frame_2.Name = "GamepadHintsFrame"

local fromOffset = UDim2.fromOffset
local v283 = v36.Size.X.Offset
local v284 = if v32 then 95 else 60

Frame_2.Size = fromOffset(v283, v284)
Frame_2.BackgroundTransparency = v5
Frame_2.BackgroundColor3 = v8
Frame_2.Visible = false
Frame_2.Parent = v35
fromOffset = Instance.new("UIListLayout")
fromOffset.Name = "Layout"
fromOffset.Padding = UDim.new(0, 25)
fromOffset.FillDirection = Enum.FillDirection.Horizontal
fromOffset.HorizontalAlignment = Enum.HorizontalAlignment.Center
fromOffset.SortOrder = Enum.SortOrder.LayoutOrder
fromOffset.Parent = Frame_2
v283 = Instance.new("UICorner")
v283.Name = "Corner"
v283.CornerRadius = v7
v283.Parent = Frame_2

local function addGamepadHint(v285, v286) -- line 1715 | captures: v32, Frame_2, v25
    local Frame = Instance.new("Frame")
    Frame.Name = "HintFrame"
    Frame.AutomaticSize = Enum.AutomaticSize.XY
    Frame.BackgroundTransparency = 1
    Frame.Parent = Frame_2
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Name = "Layout"
    UIListLayout.Padding = v32 and UDim.new(0, 20) or UDim.new(0, 12)
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Parent = Frame
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "HintImage"
    ImageLabel.Size = v32 and UDim2.fromOffset(60, 60) or UDim2.fromOffset(30, 30)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = v285
    ImageLabel.Parent = Frame
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "HintText"
    TextLabel.AutomaticSize = Enum.AutomaticSize.XY
    TextLabel.FontFace = Font.new(v25.Family, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    if v32 then
        TextLabel.TextSize = 32
    else
        TextLabel.TextSize = 19
    end
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = v286
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextYAlignment = Enum.TextYAlignment.Center
    TextLabel.TextWrapped = true
    TextLabel.Parent = Frame
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
    UITextSizeConstraint.MaxTextSize = TextLabel.TextSize
    UITextSizeConstraint.Parent = TextLabel
end

addGamepadHint(UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonX), "Remove From Hotbar")
addGamepadHint(UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonA), "Select/Swap")
addGamepadHint(UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonB), "Close Backpack")

local function resizeGamepadHintsFrame() -- line 1759 | captures: v36, v37, v32, Frame_2
    local new = UDim2.new
    local Scale = v36.Size.X.Scale
    local Offset = v36.Size.X.Offset
    local v287 = if v32 then 95 else 60
    Frame_2.Size = new(Scale, Offset, 0, v287)
    Frame_2.Position = UDim2.new(v36.Position.X.Scale, v36.Position.X.Offset, v37.Position.Y.Scale, v37.Position.Y.Offset - Frame_2.Size.Y.Offset - 5)
    local v288 = Frame_2:GetChildren()
    local v289 = {}
    for v290, v291 in pairs(v288) do
        if v291:IsA("GuiObject") then
            table.insert(v289, v291)
        end
    end
    local v292 = #v289
    local v293 = 0
    for v294 = 1, v292 do
        if v289[v294]:IsA("GuiObject") then
            v289[v294].Size = UDim2.new(1, 0, 1, -5)
            v289[v294].Position = UDim2.new(0, 0, 0, 0)
            v293 += v289[v294].HintText.Position.X.Offset + v289[v294].HintText.TextBounds.X
        end
    end
    local v295 = (Frame_2.AbsoluteSize.X - v293) / (#v289 - 1)
    local v296 = #v289
    for v297 = 1, v296 do
        local v298 = v289[v297]
        local v299 = v297 == 1
        local v300
        if v299 then
            v300 = UDim2.new(0, 0, 0, 0)
        end
        if not v299 or not v300 then
            v298.Position = UDim2.new(0, v289[v297 - 1].Position.X.Offset + v289[v297 - 1].Size.X.Offset + v295, 0, 0)
        else
            v298.Position = v300
        end
        v289[v297].Size = UDim2.new(0, v289[v297].HintText.Position.X.Offset + v289[v297].HintText.TextBounds.X, 1, -5)
    end
end

local Frame_3 = Instance.new("Frame")

Frame_3.Name = "Search"
Frame_3.BackgroundColor3 = v20
Frame_3.BackgroundTransparency = v21
Frame_3.Size = UDim2.new(0, 190, 0, 30)
Frame_3.Position = UDim2.new(1, -Frame_3.Size.X.Offset - 5, 0, 5)
Frame_3.Parent = v37

local UICorner = Instance.new("UICorner")

UICorner.Name = "Corner"
UICorner.CornerRadius = v24
UICorner.Parent = Frame_3

local UIStroke = Instance.new("UIStroke")

UIStroke.Name = "Border"
UIStroke.Color = v23
UIStroke.Thickness = 1
UIStroke.Transparency = 0.8
UIStroke.Parent = Frame_3

local TextBox = Instance.new("TextBox")

TextBox.BackgroundTransparency = 1
TextBox.Name = "TextBox"
TextBox.Text = ""
TextBox.TextColor3 = v17
TextBox.TextStrokeTransparency = v18
TextBox.TextStrokeColor3 = v19
TextBox.FontFace = Font.new(v25.Family, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TextBox.PlaceholderText = "Search"
TextBox.TextColor3 = v17
TextBox.TextTransparency = v18
TextBox.TextStrokeColor3 = v19
TextBox.ClearTextOnFocus = false
TextBox.TextTruncate = Enum.TextTruncate.AtEnd
TextBox.TextSize = v26
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.TextYAlignment = Enum.TextYAlignment.Center
TextBox.Size = UDim2.new(0, 154, 0, 14)
TextBox.AnchorPoint = Vector2.new(0, 0.5)
TextBox.Position = UDim2.new(0, 8, 0.5, 0)
TextBox.ZIndex = 2
TextBox.Parent = Frame_3

local TextButton = Instance.new("TextButton")

TextButton.Name = "X"
TextButton.Text = ""
TextButton.Size = UDim2.fromOffset(30, 30)
TextButton.Position = UDim2.new(1, -TextButton.Size.X.Offset, 0.5, -TextButton.Size.Y.Offset / 2)
TextButton.ZIndex = 4
TextButton.Visible = false
TextButton.BackgroundTransparency = 1
TextButton.Parent = Frame_3

local ImageButton = Instance.new("ImageButton")

ImageButton.Name = "X"
ImageButton.Image = "rbxasset://textures/ui/InspectMenu/x.png"
ImageButton.BackgroundTransparency = 1
ImageButton.Size = UDim2.new(0, Frame_3.Size.Y.Offset - 20, 0, Frame_3.Size.Y.Offset - 20)
ImageButton.AnchorPoint = Vector2.new(0.5, 0.5)
ImageButton.Position = UDim2.fromScale(0.5, 0.5)
ImageButton.ZIndex = 1
ImageButton.BorderSizePixel = 0
ImageButton.Parent = TextButton

local function search() -- line 1896 | captures: v27, v37, v39, v40, v55, v45, v62, TextBox, TextButton
    local v301 = {}
    for v302 in TextBox.Text:gmatch("%S+") do
        v301[v302:lower()] = true
    end
    local v303 = {}
    local v304 = v62 + 1
    local v305 = #v45
    for v306 = v304, v305 do
        local v307 = v45[v306]
        local v308 = {
            v307,
            (v307:CheckTerms(v301))
        }
        table.insert(v303, v308)
        v307.Frame.Visible = false
        v307.Frame.Parent = v37
    end
    table.sort(v303, function(v309, v310) -- line 1911
        local v311 = v309[2]
        return v310[2] < v311
    end)
    v55 = true
    local v312 = 0
    for v313, v314 in ipairs(v303) do
        local v315 = v314[1]
        if v314[2] > 0 then
            v315.Frame.Visible = true
            v315.Frame.Parent = v40
            v315.Frame.LayoutOrder = v62 + v312
            v312 += 1
        end
    end
    v39.CanvasPosition = Vector2.new(0, 0)
    local v316 = v39.AbsoluteSize.X / (v27 + 5)
    local v317 = math.floor(v316)
    local v318 = (#v40:GetChildren() - 1) / v317
    local v319 = math.ceil(v318) * (v27 + 5) + 5
    v39.CanvasSize = UDim2.fromOffset(0, v319)
    TextButton.ZIndex = 3
end

local function clearResults() -- line 1933 | captures: v27, v39, v40, v55, v45, v62, TextButton
    if TextButton.ZIndex > 0 then
        v55 = false
        local v320 = v62 + 1
        local v321 = #v45
        for v322 = v320, v321 do
            local v323 = v45[v322]
            v323.Frame.LayoutOrder = v323.Index
            v323.Frame.Parent = v40
            v323.Frame.Visible = true
        end
        TextButton.ZIndex = 0
    end
    local v324 = v39.AbsoluteSize.X / (v27 + 5)
    local v325 = math.floor(v324)
    local v326 = (#v40:GetChildren() - 1) / v325
    local v327 = math.ceil(v326) * (v27 + 5) + 5
    v39.CanvasSize = UDim2.fromOffset(0, v327)
end

local function reset() -- line 1947 | captures: TextBox, clearResults
    clearResults()
    TextBox.Text = ""
end

local function onChanged(v328) -- line 1952 | captures: v18, TextBox, TextButton, search, clearResults
    if v328 ~= "Text" then
        return
    end
    local Text = TextBox.Text
    if Text == "" then
        TextBox.TextTransparency = v18
        clearResults()
    elseif Text ~= "" then
        TextBox.TextTransparency = 0
        search()
    end
    local v329 = if Text == "" then false else Text ~= ""
    TextButton.Visible = v329
end

local function focusLost(v330) -- line 1966 | captures: search
    if v330 then
        search()
    end
end

TextButton.MouseButton1Click:Connect(reset)
TextBox.Changed:Connect(onChanged)
TextBox.FocusLost:Connect(focusLost)
v1.StateChanged.Event:Connect(function(v331) -- line 1977 | captures: TextBox, clearResults
    if not v331 then
        clearResults()
        TextBox.Text = ""
    end
end)
local MouseButton1Click = Enum.KeyCode.Escape.Value

v48[MouseButton1Click] = function(v332) -- line 1985 | captures: TextBox, clearResults
    if v332 then
        clearResults()
        TextBox.Text = ""
    end
end

local function detectGamepad(v333) -- line 1990 | captures: UserInputService, Frame_3
    if v333 ~= Enum.UserInputType.Gamepad1 or UserInputService.VREnabled then
        Frame_3.Visible = true
    else
        Frame_3.Visible = false
    end
end

UserInputService.LastInputTypeChanged:Connect(detectGamepad)
GuiService.MenuOpened:Connect(function() -- line 2001 | captures: v31, ScreenGui
    ScreenGui.Enabled = false
    v31:setEnabled(false)
end)
GuiService.MenuClosed:Connect(function() -- line 2007 | captures: v31, ScreenGui
    ScreenGui.Enabled = true
    v31:setEnabled(true)
end)

local function v334(v335, v336, v337) -- line 2014 | captures: GuiService, v45, v62
    if v336 == Enum.UserInputState.Begin and GuiService.SelectedObject then
        for v338 = 1, v62 do
            if v45[v338].Frame == GuiService.SelectedObject and v45[v338].Tool then
                v45[v338]:MoveToInventory()
                return
            end
        end
    end
end

local function openClose() -- line 2030 | captures: v36, v37, v57, ContextActionService, UserInputService, v1, v29, v45, v49, v62, AdjustHotbarFrames, Frame_2, resizeGamepadHintsFrame, v334
    if not next(v49) then
        v37.Visible = not v37.Visible
        local Visible = v37.Visible
        AdjustHotbarFrames()
        v36.Active = not v36.Active
        for v339 = 1, v62 do
            v45[v339]:SetClickability(not Visible)
        end
    end
    if v37.Visible then
        if v57 then
            if v29[UserInputService:GetLastInputType()] then
                resizeGamepadHintsFrame()
                Frame_2.Visible = not UserInputService.VREnabled
            end
            enableGamepadInventoryControl()
        end
    else
        if v57 then
            Frame_2.Visible = false
        end
        disableGamepadInventoryControl()
    end
    if v37.Visible then
        ContextActionService:BindAction("BackpackRemoveSlot", v334, false, Enum.KeyCode.ButtonX)
    else
        ContextActionService:UnbindAction("BackpackRemoveSlot")
    end
    v1.IsOpen = v37.Visible
    v1.StateChanged:Fire(v37.Visible)
end

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
v1.OpenClose = openClose
while not LocalPlayer_2 do
    task.wait()
    LocalPlayer_2 = Players.LocalPlayer
end
LocalPlayer_2.CharacterAdded:Connect(OnCharacterAdded)

if LocalPlayer_2.Character then
    OnCharacterAdded(LocalPlayer_2.Character)
end
UserInputService.InputBegan:Connect(OnInputBegan)
UserInputService.TextBoxFocused:Connect(function() -- line 2093 | captures: v54
    v54 = true
end)
UserInputService.TextBoxFocusReleased:Connect(function() -- line 2096 | captures: v54
    v54 = false
end)

v48[Value] = function() -- line 2101 | captures: v43, v51, v47
    if v51 and v43 then
        v43:UnequipTools()
        if v51 then
            v51:ToggleSelect()
            v47[v51]:UpdateEquipView()
            v51 = nil
        end
    end
end

UserInputService.LastInputTypeChanged:Connect(OnUISChanged)
OnUISChanged()

if UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1) then
    gamepadConnected()
end
UserInputService.GamepadConnected:Connect(function(v340) -- line 2115
    if v340 == Enum.UserInputType.Gamepad1 then
        gamepadConnected()
    end
end)
UserInputService.GamepadDisconnected:Connect(function(v341) -- line 2120
    if v341 == Enum.UserInputType.Gamepad1 then
        gamepadDisconnected()
    end
end)

function v1.SetBackpackEnabled(v342, v343) -- line 2128 | captures: v30
    v30 = v343
end

function v1.IsOpened(v344) -- line 2133 | captures: v1
    return v1.IsOpen
end

function v1.GetBackpackEnabled(v345) -- line 2138 | captures: v30
    return v30
end

function v1.GetStateChangedEvent(v346) -- line 2143 | captures: v1
    return v1.StateChanged
end

RunService.Heartbeat:Connect(function() -- line 2148 | captures: v30, OnIconChanged
    OnIconChanged(v30)
end)

local function OnPreferredTransparencyChanged() -- line 2153 | captures: v6, v11, v22, v37, GuiService, v4, v10, v45, Frame_3
    local PreferredTransparency = GuiService.PreferredTransparency
    v6 = v4 * PreferredTransparency
    v37.BackgroundTransparency = v6
    v11 = v10 * PreferredTransparency
    for v347, v348 in ipairs(v45) do
        v348.Frame.BackgroundTransparency = v11
    end
    v22 = PreferredTransparency * 0.2
    Frame_3.BackgroundTransparency = v22
end

GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(OnPreferredTransparencyChanged)
return v1
