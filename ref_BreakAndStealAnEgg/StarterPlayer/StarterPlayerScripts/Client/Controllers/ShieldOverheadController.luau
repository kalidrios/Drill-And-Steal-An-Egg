-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local HellBossConfig = require(ReplicatedStorage.Shared.HellBossConfig)
local HellEventConfig = require(ReplicatedStorage.Shared.HellEventConfig)
local ShieldModel = require(ReplicatedStorage.Shared.ShieldModel)
local Shields = HellBossConfig.Shields
local Overhead = Shields.Overhead
local v1 = {}
local v2 = {}

local function getTemplate() -- line 37 | captures: ReplicatedStorage, Overhead
    local v3 = ReplicatedStorage:WaitForChild("Assets", 10)
    local v4 = v3 and v3:WaitForChild("BillboardGui", 10)
    local v5 = v4 and v4:WaitForChild(Overhead.Template, 10)
    if v5 and v5:IsA("BillboardGui") then
        return v5
    end
    warn((("[ShieldOverheadController] ReplicatedStorage.Assets.BillboardGui.%* missing"):format(Overhead.Template)))
    return nil
end

local function getAnchor(v6) -- line 51 | captures: ShieldModel, Overhead
    local v7 = v6:WaitForChild(Overhead.Attachment, 10)
    if not (v7 and v7:IsA("Attachment")) then
        warn((("[ShieldOverheadController] %* has no %*"):format(v6:GetFullName(), Overhead.Attachment)))
    else
        if v7.Parent and v7.Parent:IsA("BasePart") then
            return v7
        end
        local v8 = ShieldModel.HitPart(v6)
        if v8 then
            local WorldPosition = v7.WorldPosition
            if v6:IsA("Model") then
                local v9, v10 = v6:GetBoundingBox()
                local Magnitude = (WorldPosition - v9.Position).Magnitude
                if v10.Magnitude < Magnitude then
                    local Position = v9.Position
                    local v11 = v10.Y / 2
                    WorldPosition = Position + Vector3.new(0, v11, 0)
                end
            end
            local Attachment = Instance.new("Attachment")
            Attachment.Name = ("%*_Local"):format(Overhead.Attachment)
            Attachment.Parent = v8
            Attachment.WorldPosition = WorldPosition
            return Attachment
        end
    end
    return nil
end

local function hookShield(v12, v13) -- line 80 | captures: TweenService, Workspace, FormatNumber, Overhead, v2, getAnchor
    if v2[v12] then
        return
    end
    v2[v12] = true
    task.spawn(function() -- line 86 | captures: v12, v13, TweenService, Workspace, FormatNumber, Overhead, v2, getAnchor
        local v14 = getAnchor(v12)
        if v14 and v12.Parent then
            local v15 = v13:Clone()
            v15.Name = "ShieldOverhead"
            v15.Adornee = v14
            v15.Parent = v14
            local HpBar = v15:FindFirstChild("HpBar")
            local v16 = HpBar and HpBar:FindFirstChild("Bar")
            local v17 = HpBar and HpBar:FindFirstChild("Amount")
            if v16 and v16:IsA("GuiObject") then
                local Position = v16.Position
                local v18 = (1 - v16.AnchorPoint.X) * v16.Size.X.Scale
                local v19 = v18
                local Position_2 = Position

                local function positionFor(v20) -- line 110 | captures: v19, Position_2
                    return UDim2.new(v20 - v19, Position_2.X.Offset, Position_2.Y.Scale, Position_2.Y.Offset)
                end

                local v21
                local v22 = v15
                local v23 = v17
                local v24 = v16
                local v25 = v18
                local Position_3 = Position

                local function refresh(v26) -- line 120 | captures: v21, v22, v23, v24, v25, Position_3, v12, TweenService, FormatNumber, Overhead
                    local Health = v12:GetAttribute("Health")
                    local MaxHealth = v12:GetAttribute("MaxHealth")
                    local Enabled, v27, v28, v29
                    if type(Health) == "number" and type(MaxHealth) == "number" then
                        if MaxHealth <= 0 then
                            v29 = true
                        else
                            Enabled = v22.Enabled
                            v27 = v22
                            v28 = Health > 0
                            v29 = false
                        end
                    else
                        v29 = true
                    end
                    if not v29 then
                        v27.Enabled = v28
                        local v30 = Health / MaxHealth
                        local v31 = math.clamp(v30, 0, 1)
                        if v23 and v23:IsA("TextLabel") then
                            v23.Text = string.format(Overhead.Text, FormatNumber.Commas((math.max(Health, 0))), FormatNumber.Commas(MaxHealth))
                        end
                        if v21 then
                            v21:Cancel()
                            v21 = nil
                        end
                        if not v26 and Enabled then
                            v21 = TweenService:Create(v24, Overhead.BarTween, { Position = UDim2.new(v31 - v25, Position_3.X.Offset, Position_3.Y.Scale, Position_3.Y.Offset) })
                            v21:Play()
                        else
                            v24.Position = UDim2.new(v31 - v25, Position_3.X.Offset, Position_3.Y.Scale, Position_3.Y.Offset)
                        end
                    else
                        v22.Enabled = false
                    end
                end

                refresh(true)
                local Health = v12:GetAttributeChangedSignal("Health")
                local refresh_2 = refresh
                local v32 = Health:Connect(function() -- line 151 | captures: refresh_2
                    refresh_2()
                end)
                local MaxHealth = v12:GetAttributeChangedSignal("MaxHealth")
                local refresh_3 = refresh
                local v33 = {
                    v32,
                    MaxHealth:Connect(function() -- line 154 | captures: refresh_3
                        refresh_3(true)
                    end)
                }
                local v34
                local AncestryChanged = v12.AncestryChanged
                local v35 = v33
                local v36 = v15
                local v37 = v14
                v34 = AncestryChanged:Connect(function() -- line 159 | captures: v34, v35, v36, v37, v12, Workspace, Overhead, v2
                    if v12:IsDescendantOf(Workspace) then
                        return
                    end
                    v34:Disconnect()
                    for v38, v39 in v35 do
                        v39:Disconnect()
                    end
                    v36:Destroy()
                    if v37.Name ~= Overhead.Attachment then
                        v37:Destroy()
                    end
                    v2[v12] = nil
                end)
            else
                warn((("[ShieldOverheadController] %*.HpBar.Bar missing"):format(Overhead.Template)))
            end
        else
            v2[v12] = nil
        end
    end)
end

local function watchFolder(v40, v41) -- line 177 | captures: TweenService, Workspace, FormatNumber, Overhead, v2, getAnchor
    for v42, v43 in v40:GetChildren() do
        if not v2[v43] then
            v2[v43] = true
            local spawn = task.spawn
            local v44 = v43
            spawn(function() -- line 86 | captures: v41, v44, TweenService, Workspace, FormatNumber, Overhead, v2, getAnchor
                local v45 = getAnchor(v44)
                if v45 and v44.Parent then
                    local v46 = v41:Clone()
                    v46.Name = "ShieldOverhead"
                    v46.Adornee = v45
                    v46.Parent = v45
                    local HpBar = v46:FindFirstChild("HpBar")
                    local v47 = HpBar and HpBar:FindFirstChild("Bar")
                    local v48 = HpBar and HpBar:FindFirstChild("Amount")
                    if v47 and v47:IsA("GuiObject") then
                        local Position = v47.Position
                        local v49 = (1 - v47.AnchorPoint.X) * v47.Size.X.Scale
                        local v50 = v49
                        local Position_2 = Position

                        local function positionFor(v51) -- line 110 | captures: v50, Position_2
                            return UDim2.new(v51 - v50, Position_2.X.Offset, Position_2.Y.Scale, Position_2.Y.Offset)
                        end

                        local v52
                        local v53 = v46
                        local v54 = v48
                        local v55 = v47
                        local v56 = v49
                        local Position_3 = Position

                        local function refresh(v57) -- line 120 | captures: v44, TweenService, FormatNumber, Overhead, v52, v53, v54, v55, v56, Position_3
                            local Health = v44:GetAttribute("Health")
                            local MaxHealth = v44:GetAttribute("MaxHealth")
                            local Enabled, v58, v59, v60
                            if type(Health) == "number" and type(MaxHealth) == "number" then
                                if MaxHealth <= 0 then
                                    v60 = true
                                else
                                    Enabled = v53.Enabled
                                    v58 = v53
                                    v59 = Health > 0
                                    v60 = false
                                end
                            else
                                v60 = true
                            end
                            if not v60 then
                                v58.Enabled = v59
                                local v61 = Health / MaxHealth
                                local v62 = math.clamp(v61, 0, 1)
                                if v54 and v54:IsA("TextLabel") then
                                    v54.Text = string.format(Overhead.Text, FormatNumber.Commas((math.max(Health, 0))), FormatNumber.Commas(MaxHealth))
                                end
                                if v52 then
                                    v52:Cancel()
                                    v52 = nil
                                end
                                if not v57 and Enabled then
                                    v52 = TweenService:Create(v55, Overhead.BarTween, { Position = UDim2.new(v62 - v56, Position_3.X.Offset, Position_3.Y.Scale, Position_3.Y.Offset) })
                                    v52:Play()
                                else
                                    v55.Position = UDim2.new(v62 - v56, Position_3.X.Offset, Position_3.Y.Scale, Position_3.Y.Offset)
                                end
                            else
                                v53.Enabled = false
                            end
                        end

                        refresh(true)
                        local Health = v44:GetAttributeChangedSignal("Health")
                        local refresh_2 = refresh
                        local v63 = Health:Connect(function() -- line 151 | captures: refresh_2
                            refresh_2()
                        end)
                        local MaxHealth = v44:GetAttributeChangedSignal("MaxHealth")
                        local refresh_3 = refresh
                        local v64 = {
                            v63,
                            MaxHealth:Connect(function() -- line 154 | captures: refresh_3
                                refresh_3(true)
                            end)
                        }
                        local v65
                        local AncestryChanged = v44.AncestryChanged
                        local v66 = v64
                        local v67 = v46
                        local v68 = v45
                        v65 = AncestryChanged:Connect(function() -- line 159 | captures: v44, Workspace, Overhead, v2, v65, v66, v67, v68
                            if v44:IsDescendantOf(Workspace) then
                                return
                            end
                            v65:Disconnect()
                            for v69, v70 in v66 do
                                v70:Disconnect()
                            end
                            v67:Destroy()
                            if v68.Name ~= Overhead.Attachment then
                                v68:Destroy()
                            end
                            v2[v44] = nil
                        end)
                    else
                        warn((("[ShieldOverheadController] %*.HpBar.Bar missing"):format(Overhead.Template)))
                    end
                else
                    v2[v44] = nil
                end
            end)
        end
    end
    v40.ChildAdded:Connect(function(v71) -- line 181 | captures: v41, TweenService, Workspace, FormatNumber, Overhead, v2, getAnchor
        if v2[v71] then
            return
        end
        v2[v71] = true
        task.spawn(function() -- line 86 | captures: v71, v41, TweenService, Workspace, FormatNumber, Overhead, v2, getAnchor
            local v72 = getAnchor(v71)
            if v72 and v71.Parent then
                local v73 = v41:Clone()
                v73.Name = "ShieldOverhead"
                v73.Adornee = v72
                v73.Parent = v72
                local HpBar = v73:FindFirstChild("HpBar")
                local v74 = HpBar and HpBar:FindFirstChild("Bar")
                local v75 = HpBar and HpBar:FindFirstChild("Amount")
                if v74 and v74:IsA("GuiObject") then
                    local Position = v74.Position
                    local v76 = (1 - v74.AnchorPoint.X) * v74.Size.X.Scale
                    local v77 = v76
                    local Position_2 = Position

                    local function positionFor(v78) -- line 110 | captures: v77, Position_2
                        return UDim2.new(v78 - v77, Position_2.X.Offset, Position_2.Y.Scale, Position_2.Y.Offset)
                    end

                    local v79
                    local v80 = v73
                    local v81 = v75
                    local v82 = v74
                    local v83 = v76
                    local Position_3 = Position

                    local function refresh(v84) -- line 120 | captures: v71, TweenService, FormatNumber, Overhead, v79, v80, v81, v82, v83, Position_3
                        local Health = v71:GetAttribute("Health")
                        local MaxHealth = v71:GetAttribute("MaxHealth")
                        local Enabled, v85, v86, v87
                        if type(Health) == "number" and type(MaxHealth) == "number" then
                            if MaxHealth <= 0 then
                                v87 = true
                            else
                                Enabled = v80.Enabled
                                v85 = v80
                                v86 = Health > 0
                                v87 = false
                            end
                        else
                            v87 = true
                        end
                        if not v87 then
                            v85.Enabled = v86
                            local v88 = Health / MaxHealth
                            local v89 = math.clamp(v88, 0, 1)
                            if v81 and v81:IsA("TextLabel") then
                                v81.Text = string.format(Overhead.Text, FormatNumber.Commas((math.max(Health, 0))), FormatNumber.Commas(MaxHealth))
                            end
                            if v79 then
                                v79:Cancel()
                                v79 = nil
                            end
                            if not v84 and Enabled then
                                v79 = TweenService:Create(v82, Overhead.BarTween, { Position = UDim2.new(v89 - v83, Position_3.X.Offset, Position_3.Y.Scale, Position_3.Y.Offset) })
                                v79:Play()
                            else
                                v82.Position = UDim2.new(v89 - v83, Position_3.X.Offset, Position_3.Y.Scale, Position_3.Y.Offset)
                            end
                        else
                            v80.Enabled = false
                        end
                    end

                    refresh(true)
                    local Health = v71:GetAttributeChangedSignal("Health")
                    local refresh_2 = refresh
                    local v90 = Health:Connect(function() -- line 151 | captures: refresh_2
                        refresh_2()
                    end)
                    local MaxHealth = v71:GetAttributeChangedSignal("MaxHealth")
                    local refresh_3 = refresh
                    local v91 = {
                        v90,
                        MaxHealth:Connect(function() -- line 154 | captures: refresh_3
                            refresh_3(true)
                        end)
                    }
                    local v92
                    local AncestryChanged = v71.AncestryChanged
                    local v93 = v91
                    local v94 = v73
                    local v95 = v72
                    v92 = AncestryChanged:Connect(function() -- line 159 | captures: v71, Workspace, Overhead, v2, v92, v93, v94, v95
                        if v71:IsDescendantOf(Workspace) then
                            return
                        end
                        v92:Disconnect()
                        for v96, v97 in v93 do
                            v97:Disconnect()
                        end
                        v94:Destroy()
                        if v95.Name ~= Overhead.Attachment then
                            v95:Destroy()
                        end
                        v2[v71] = nil
                    end)
                else
                    warn((("[ShieldOverheadController] %*.HpBar.Bar missing"):format(Overhead.Template)))
                end
            else
                v2[v71] = nil
            end
        end)
    end)
end

local function watchMap(v98, v99) -- line 186 | captures: Shields, watchFolder
    local v100 = v98:FindFirstChild(Shields.Folder)
    if v100 then
        watchFolder(v100, v99)
    end
    v98.ChildAdded:Connect(function(v101) -- line 191 | captures: v99, Shields, watchFolder
        if v101.Name == Shields.Folder then
            watchFolder(v101, v99)
        end
    end)
end

function v1.Start() -- line 198 | captures: Workspace, HellEventConfig, Shields, getTemplate, watchFolder
    if Shields.Breakable then
        local v102 = getTemplate()
        if v102 then
            local v103 = Workspace:FindFirstChild(HellEventConfig.MapName)
            if v103 then
                local v104 = v103:FindFirstChild(Shields.Folder)
                if v104 then
                    watchFolder(v104, v102)
                end
                v103.ChildAdded:Connect(function(v105) -- line 191 | captures: v102, Shields, watchFolder
                    if v105.Name == Shields.Folder then
                        watchFolder(v105, v102)
                    end
                end)
            end
            Workspace.ChildAdded:Connect(function(v106) -- line 210 | captures: v102, HellEventConfig, Shields, watchFolder
                if v106.Name ~= HellEventConfig.MapName then
                    return
                end
                local v107 = v106:FindFirstChild(Shields.Folder)
                if v107 then
                    watchFolder(v107, v102)
                end
                v106.ChildAdded:Connect(function(v108) -- line 191 | captures: v102, Shields, watchFolder
                    if v108.Name == Shields.Folder then
                        watchFolder(v108, v102)
                    end
                end)
            end)
        end
    end
end

return v1
