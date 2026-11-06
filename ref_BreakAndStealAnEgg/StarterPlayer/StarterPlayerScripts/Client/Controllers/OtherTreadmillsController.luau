-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local PublicTreadmillConfig = require(ReplicatedStorage.Shared.PublicTreadmillConfig)
local SpeedConfig = require(ReplicatedStorage.Shared.SpeedConfig)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = {}

local function isMachine(v3) -- line 65
    local v4, v5
    if v3:IsA("Model") then
        if string.find(v3.Name, "Treadmill") == nil then
            v5 = true
        else
            local Hitbox = v3:FindFirstChild("Hitbox")
            if Hitbox == nil then
                v4 = false
            else
                v4 = Hitbox:IsA("BasePart")
            end
            v5 = false
        end
    else
        v5 = true
    end
    if not v5 then
        return v4
    end
    return false
end

local v6 = {}

local function isOwn(v7) -- line 81 | captures: LocalPlayer
    return v7.Plot:GetAttribute("OwnerUserId") == LocalPlayer.UserId
end

local function onPublicTreadmill() -- line 85 | captures: PublicTreadmillConfig, LocalPlayer
    return LocalPlayer:GetAttribute(PublicTreadmillConfig.SlotAttribute) ~= nil
end

local function shouldHide(v8) -- line 89 | captures: SpeedConfig, LocalPlayer
    if v8.Plot:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
        return false
    end
    return v8.Model:GetAttribute(SpeedConfig.InUseAttribute) ~= true
end

local function isToggleEffect(v9) -- line 100
    return v9:IsA("Beam") or v9:IsA("Trail") or v9:IsA("Light") or v9:IsA("SurfaceGui")
end

local function hideInstance(v10, v11) -- line 104 | captures: LocalPlayer
    if v10.Saved[v11] == nil then
        if v11:IsA("BasePart") then
            v10.Saved[v11] = v11.CanCollide
            v11.LocalTransparencyModifier = 1
            v11.CanCollide = false
        elseif v11:IsA("Decal") then
            v10.Saved[v11] = true
            v11.LocalTransparencyModifier = 1
        elseif v11:IsA("BillboardGui") then
            v10.Saved[v11] = v11.PlayerToHideFrom or false
            v11.PlayerToHideFrom = LocalPlayer
        elseif v11:IsA("ParticleEmitter") then
            v10.Saved[v11] = v11.Enabled
            v11.Enabled = false
            v11:Clear()
        elseif v11:IsA("Beam") or v11:IsA("Trail") or v11:IsA("Light") or v11:IsA("SurfaceGui") then
            v10.Saved[v11] = v11.Enabled
            v11.Enabled = false
        end
    end
end

local function showInstance(v12, v13) -- line 128
    if v12:IsA("BasePart") then
        v12.LocalTransparencyModifier = 0
        v12.CanCollide = v13
    elseif v12:IsA("Decal") then
        v12.LocalTransparencyModifier = 0
    elseif v12:IsA("BillboardGui") then
        if v13 == false then
            v12.PlayerToHideFrom = nil
        else
            v12.PlayerToHideFrom = v13
        end
    elseif v12:IsA("ParticleEmitter") or v12:IsA("Beam") or v12:IsA("Trail") or v12:IsA("Light") or v12:IsA("SurfaceGui") then
        v12.Enabled = v13
    end
end

local function getOverhead(v14) -- line 145
    local Hitbox = v14.Model:FindFirstChild("Hitbox")
    local v15 = Hitbox and Hitbox:FindFirstChild("AnimalOverhead")
    if v15 and v15:IsA("BillboardGui") then
        return v15
    end
    return nil
end

local function syncOverhead(v16) -- line 154 | captures: PublicTreadmillConfig, LocalPlayer
    local v17, v18
    if v16.Hidden then
        v18 = true
    else
        local Hitbox = v16.Model:FindFirstChild("Hitbox")
        v17 = Hitbox and Hitbox:FindFirstChild("AnimalOverhead")
        v18 = false
    end
    if v18 or not (v17 and v17:IsA("BillboardGui")) then
        v17 = nil
    end
    if v17 and v16.Plot:GetAttribute("OwnerUserId") == LocalPlayer.UserId and LocalPlayer:GetAttribute(PublicTreadmillConfig.SlotAttribute) ~= nil then
        v17.PlayerToHideFrom = LocalPlayer
        v16.HiddenOverhead = v17
    else
        local HiddenOverhead = v16.HiddenOverhead
        if HiddenOverhead then
            v16.HiddenOverhead = nil
            if HiddenOverhead.PlayerToHideFrom == LocalPlayer then
                HiddenOverhead.PlayerToHideFrom = nil
            end
        end
    end
end

local function apply(v19) -- line 170 | captures: PublicTreadmillConfig, SpeedConfig, LocalPlayer, hideInstance, showInstance
    local v20 = if v19.Plot:GetAttribute("OwnerUserId") == LocalPlayer.UserId then false else v19.Model:GetAttribute(SpeedConfig.InUseAttribute) ~= true
    if v20 ~= v19.Hidden then
        v19.Hidden = v20
        if v20 then
            local Hitbox
            if v19.Hidden then
            else
                Hitbox = v19.Model:FindFirstChild("Hitbox")
                if Hitbox then
                    Hitbox = Hitbox:FindFirstChild("AnimalOverhead")
                    if Hitbox then
                        if not Hitbox:IsA("BillboardGui") then
                            Hitbox = nil
                        end
                    else
                        Hitbox = nil
                    end
                else
                    Hitbox = nil
                end
            end
            if Hitbox and v19.Plot:GetAttribute("OwnerUserId") == LocalPlayer.UserId and LocalPlayer:GetAttribute(PublicTreadmillConfig.SlotAttribute) ~= nil then
                Hitbox.PlayerToHideFrom = LocalPlayer
                v19.HiddenOverhead = Hitbox
            else
                local HiddenOverhead = v19.HiddenOverhead
                if HiddenOverhead then
                    v19.HiddenOverhead = nil
                    if HiddenOverhead.PlayerToHideFrom == LocalPlayer then
                        HiddenOverhead.PlayerToHideFrom = nil
                    end
                end
            end
            for v21, v22 in v19.Model:GetDescendants() do
                hideInstance(v19, v22)
            end
        else
            for v23, v24 in v19.Saved do
                showInstance(v23, v24)
            end
            table.clear(v19.Saved)
        end
    end
    local v25, v26
    if v19.Hidden then
        v26 = true
    else
        local Hitbox = v19.Model:FindFirstChild("Hitbox")
        v25 = Hitbox and Hitbox:FindFirstChild("AnimalOverhead")
        v26 = false
    end
    if v26 or not (v25 and v25:IsA("BillboardGui")) then
        v25 = nil
    end
    if v25 and v19.Plot:GetAttribute("OwnerUserId") == LocalPlayer.UserId and LocalPlayer:GetAttribute(PublicTreadmillConfig.SlotAttribute) ~= nil then
        v25.PlayerToHideFrom = LocalPlayer
        v19.HiddenOverhead = v25
    else
        local HiddenOverhead = v19.HiddenOverhead
        if HiddenOverhead then
            v19.HiddenOverhead = nil
            if HiddenOverhead.PlayerToHideFrom == LocalPlayer then
                HiddenOverhead.PlayerToHideFrom = nil
            end
        end
    end
end

local function untrack(v27) -- line 191 | captures: PublicTreadmillConfig, LocalPlayer, v2, v6, showInstance
    local v28 = v6[v27]
    if v28 then
        v28:Disconnect()
        v6[v27] = nil
    end
    local v29 = v2[v27]
    if not v29 then
        return
    end
    v2[v27] = nil
    for v30, v31 in v29.Connections do
        v31:Disconnect()
    end
    v29.Hidden = true
    local v32, v33
    if v29.Hidden then
        v33 = true
    else
        local Hitbox = v29.Model:FindFirstChild("Hitbox")
        v32 = Hitbox and Hitbox:FindFirstChild("AnimalOverhead")
        v33 = false
    end
    if v33 or not (v32 and v32:IsA("BillboardGui")) then
        v32 = nil
    end
    if v32 and v29.Plot:GetAttribute("OwnerUserId") == LocalPlayer.UserId and LocalPlayer:GetAttribute(PublicTreadmillConfig.SlotAttribute) ~= nil then
        v32.PlayerToHideFrom = LocalPlayer
        v29.HiddenOverhead = v32
    else
        local HiddenOverhead = v29.HiddenOverhead
        if HiddenOverhead then
            v29.HiddenOverhead = nil
            if HiddenOverhead.PlayerToHideFrom == LocalPlayer then
                HiddenOverhead.PlayerToHideFrom = nil
            end
        end
    end
    for v34, v35 in v29.Saved do
        showInstance(v34, v35)
    end
    table.clear(v29.Saved)
end

local track

local function track_2(v36, v37) -- line 213 | captures: PublicTreadmillConfig, SpeedConfig, LocalPlayer, v2, isMachine, v6, hideInstance, showInstance, apply, track
    local function v38(v39, ...)
        table.insert(v39, ...)
    end

    local function v40(v41, ...)
        table.insert(v41, ...)
    end

    local function v42(v43, ...)
        table.insert(v43, ...)
    end

    if not (v2[v36] or v6[v36]) then
        if isMachine(v36) then
            local v44 = {
                Hidden = false,
                Model = v36,
                Plot = v37,
                Saved = {},
                Connections = {}
            }
            v2[v36] = v44
            v38(v44.Connections, v36:GetAttributeChangedSignal(SpeedConfig.InUseAttribute):Connect(function() -- line 248 | captures: v44, apply
                apply(v44)
            end))
            v40(v44.Connections, v36.DescendantAdded:Connect(function(v45) -- line 255 | captures: v44, PublicTreadmillConfig, LocalPlayer, hideInstance
                if v44.Hidden then
                    hideInstance(v44, v45)
                elseif v45.Name == "AnimalOverhead" or v45.Name == "Hitbox" then
                    local v46, v47
                    if v44.Hidden then
                        v47 = true
                    else
                        local Hitbox = v44.Model:FindFirstChild("Hitbox")
                        v46 = Hitbox and Hitbox:FindFirstChild("AnimalOverhead")
                        v47 = false
                    end
                    if v47 or not (v46 and v46:IsA("BillboardGui")) then
                        v46 = nil
                    end
                    if v46 and v44.Plot:GetAttribute("OwnerUserId") == LocalPlayer.UserId and LocalPlayer:GetAttribute(PublicTreadmillConfig.SlotAttribute) ~= nil then
                        v46.PlayerToHideFrom = LocalPlayer
                        v44.HiddenOverhead = v46
                    else
                        local HiddenOverhead = v44.HiddenOverhead
                        if HiddenOverhead then
                            v44.HiddenOverhead = nil
                            if HiddenOverhead.PlayerToHideFrom == LocalPlayer then
                                HiddenOverhead.PlayerToHideFrom = nil
                            end
                        end
                    end
                end
            end))
            v42(v44.Connections, v36.DescendantRemoving:Connect(function(v48) -- line 265 | captures: v44, showInstance
                local v49 = v44.Saved[v48]
                if v49 ~= nil then
                    v44.Saved[v48] = nil
                    showInstance(v48, v49)
                end
            end))
            apply(v44)
        elseif v36:IsA("Model") and v36.Name ~= "TreadmillBoard" and string.find(v36.Name, "Treadmill") ~= nil then
            local ChildAdded = v36.ChildAdded
            v6[v36] = ChildAdded:Connect(function(v50) -- line 223 | captures: v36, v37, v6, track
                if not (v50.Name == "Hitbox" and v50:IsA("BasePart")) then
                    return
                end
                local v51 = v6[v36]
                if v51 then
                    v51:Disconnect()
                    v6[v36] = nil
                end
                track(v36, v37)
            end)
        end
    end
end

track = track_2

local function refreshPlot(v52) -- line 281 | captures: v2, apply
    for v53, v54 in v2 do
        if v54.Plot == v52 then
            apply(v54)
        end
    end
end

local function hookPlot(v55) -- line 289 | captures: v2, apply, untrack, track_2
    for v56, v57 in v55:GetChildren() do
        track_2(v57, v55)
    end
    v55.ChildAdded:Connect(function(v58) -- line 294 | captures: v55, track_2
        track_2(v58, v55)
    end)
    v55.ChildRemoved:Connect(untrack)
    v55:GetAttributeChangedSignal("OwnerUserId"):Connect(function() -- line 299 | captures: v55, v2, apply
        for v59, v60 in v2 do
            if v60.Plot == v55 then
                apply(v60)
            end
        end
    end)
end

function v1.Start() -- line 304 | captures: Workspace, PublicTreadmillConfig, LocalPlayer, v2, hookPlot
    local Plots = Workspace:WaitForChild("Plots")
    for v61, v62 in Plots:GetChildren() do
        hookPlot(v62)
    end
    Plots.ChildAdded:Connect(hookPlot)
    LocalPlayer:GetAttributeChangedSignal(PublicTreadmillConfig.SlotAttribute):Connect(function() -- line 312 | captures: PublicTreadmillConfig, LocalPlayer, v2
        for v63, v64 in v2 do
            local v65
            if v64.Hidden then
            else
                local Hitbox = v64.Model:FindFirstChild("Hitbox")
                v65 = Hitbox and Hitbox:FindFirstChild("AnimalOverhead")
                if not (v65 and v65:IsA("BillboardGui")) then
                    v65 = nil
                end
            end
            if v65 and v64.Plot:GetAttribute("OwnerUserId") == LocalPlayer.UserId and LocalPlayer:GetAttribute(PublicTreadmillConfig.SlotAttribute) ~= nil then
                v65.PlayerToHideFrom = LocalPlayer
                v64.HiddenOverhead = v65
            else
                local HiddenOverhead = v64.HiddenOverhead
                if HiddenOverhead then
                    v64.HiddenOverhead = nil
                    if HiddenOverhead.PlayerToHideFrom == LocalPlayer then
                        HiddenOverhead.PlayerToHideFrom = nil
                    end
                end
            end
        end
    end)
end

return v1
