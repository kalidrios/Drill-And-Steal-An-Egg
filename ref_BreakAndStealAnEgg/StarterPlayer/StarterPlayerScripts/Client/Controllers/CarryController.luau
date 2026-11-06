-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local AnimationAssets = require(ReplicatedStorage.Shared.AnimationAssets)
local AnimationCache = require(script.Parent.AnimationCache)
local BackpackGui = require(script.Parent.Parent.Modules.BackpackGui)
local HudVisibility = require(ReplicatedStorage.Shared.HudVisibility)
local v1 = {}
local v2 = {
    MainGUI = true,
    ProximityPrompts = true,
    RewardFlashHolder = true,
    TouchGui = true,
    ContextActionGui = true
}
local v3 = { "Currencies" }
local LocalPlayer = Players.LocalPlayer
local v4 = {}
local v5 = {}
local v6
local v7 = false
local v8 = false
local v9 = false
local v10 = HudVisibility.new()
local v11 = false
local v12 = {}
local v13 = {}
local v14 = false

local function hideForCarry(v15) -- line 78 | captures: v7, v4, v5
    local function v16(v17, ...)
        table.insert(v17, ...)
    end

    v15.Enabled = false
    table.insert(v4, v15)
    local Enabled = v15:GetPropertyChangedSignal("Enabled")
    v16(v5, Enabled:Connect(function() -- line 81 | captures: v15, v7
        if v7 and v15.Enabled then
            v15.Enabled = false
        end
    end))
end

local function setUiHidden(v18) -- line 88 | captures: v7, v9, StarterGui, v2, v3, LocalPlayer, v4, v5, v10
    local function v19(v20, ...)
        table.insert(v20, ...)
    end

    local function v21(v22, ...)
        table.insert(v22, ...)
    end

    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if v18 then
        if PlayerGui then
            for v23, v24 in PlayerGui:GetChildren() do
                if v24:IsA("ScreenGui") and v24.Enabled and not v2[v24.Name] then
                    v24.Enabled = false
                    table.insert(v4, v24)
                    local Enabled = v24:GetPropertyChangedSignal("Enabled")
                    local v25 = v24
                    v19(v5, Enabled:Connect(function() -- line 81 | captures: v25, v7
                        if v7 and v25.Enabled then
                            v25.Enabled = false
                        end
                    end))
                end
            end
            v10:HideChildren(PlayerGui:FindFirstChild("MainGUI"), v3)
            v21(v5, PlayerGui.ChildAdded:Connect(function(v26) -- line 103 | captures: v7, v2, v3, v4, v5, v10
                task.defer(function() -- line 104 | captures: v26, v7, v2, v3, v4, v5, v10
                    local function v27(v28, ...)
                        table.insert(v28, ...)
                    end

                    if v7 and v26:IsA("ScreenGui") then
                        if v26.Name == "MainGUI" then
                            v10:HideChildren(v26, v3)
                        elseif v26.Enabled and not v2[v26.Name] then
                            v26.Enabled = false
                            table.insert(v4, v26)
                            local Enabled = v26:GetPropertyChangedSignal("Enabled")
                            v27(v5, Enabled:Connect(function() -- line 81 | captures: v26, v7
                                if v7 and v26.Enabled then
                                    v26.Enabled = false
                                end
                            end))
                        end
                    end
                end)
            end))
        end
        pcall(function() -- line 121 | captures: v9, StarterGui
            v9 = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack)
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
        end)
    else
        for v29, v30 in v5 do
            v30:Disconnect()
        end
        table.clear(v5)
        for v31, v32 in v4 do
            if v32.Parent then
                v32.Enabled = true
            end
        end
        table.clear(v4)
        v10:RestoreAll()
        pcall(StarterGui.SetCoreGuiEnabled, StarterGui, Enum.CoreGuiType.Backpack, v9)
    end
end

local function hideSatchelForJail(v33) -- line 146 | captures: v11, v12, v13
    local function v34(v35, ...)
        table.insert(v35, ...)
    end

    v33.Enabled = false
    table.insert(v12, v33)
    local Enabled = v33:GetPropertyChangedSignal("Enabled")
    v34(v13, Enabled:Connect(function() -- line 149 | captures: v33, v11
        if v11 and v33.Enabled then
            v33.Enabled = false
        end
    end))
end

local function setJailUiHidden(v36) -- line 156 | captures: v11, v14, StarterGui, BackpackGui, LocalPlayer, v12, v13
    local function v37(v38, ...)
        table.insert(v38, ...)
    end

    local function v39(v40, ...)
        table.insert(v40, ...)
    end

    if v36 == v11 then
        return
    end
    v11 = v36
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if v36 then
        local v41 = PlayerGui and PlayerGui:FindFirstChild(BackpackGui.Name())
        if v41 and v41:IsA("ScreenGui") and v41.Enabled then
            v41.Enabled = false
            table.insert(v12, v41)
            local Enabled = v41:GetPropertyChangedSignal("Enabled")
            v37(v13, Enabled:Connect(function() -- line 149 | captures: v41, v11
                if v11 and v41.Enabled then
                    v41.Enabled = false
                end
            end))
        end
        if PlayerGui then
            v39(v13, PlayerGui.ChildAdded:Connect(function(v42) -- line 169 | captures: v11, BackpackGui, v12, v13
                task.defer(function() -- line 170 | captures: v42, v11, BackpackGui, v12, v13
                    local function v43(v44, ...)
                        table.insert(v44, ...)
                    end

                    if not (v11 and v42.Name == BackpackGui.Name() and v42:IsA("ScreenGui") and v42.Enabled) then
                        return
                    end
                    v42.Enabled = false
                    table.insert(v12, v42)
                    local Enabled = v42:GetPropertyChangedSignal("Enabled")
                    v43(v13, Enabled:Connect(function() -- line 149 | captures: v42, v11
                        if v11 and v42.Enabled then
                            v42.Enabled = false
                        end
                    end))
                end)
            end))
        end
        pcall(function() -- line 182 | captures: v14, StarterGui
            v14 = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack)
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
        end)
    else
        for v45, v46 in v13 do
            v46:Disconnect()
        end
        table.clear(v13)
        for v47, v48 in v12 do
            if v48.Parent then
                v48.Enabled = true
            end
        end
        table.clear(v12)
        pcall(StarterGui.SetCoreGuiEnabled, StarterGui, Enum.CoreGuiType.Backpack, v14)
    end
end

local function stopAnimation() -- line 201 | captures: v6
    if v6 then
        v6:Stop(0.15)
    end
end

local function playAnimation() -- line 208 | captures: v6
    if v6 then
        v6:Play(0.15)
    end
end

local function loadTrack(v49) -- line 218 | captures: v6, v8, AnimationAssets, AnimationCache, LocalPlayer
    v6 = nil
    local v50 = AnimationCache.Warm(v49, AnimationAssets.Carry, Enum.AnimationPriority.Action, true)
    if v50 and LocalPlayer.Character == v49 then
        v6 = v50
        if v8 then
            v50:Play(0.15)
        end
    end
end

local function refreshState() -- line 237 | captures: v6, v7, v8, LocalPlayer, setUiHidden, setJailUiHidden
    local v51 = LocalPlayer:GetAttribute("Carrying") ~= nil
    local v52 = LocalPlayer:GetAttribute("CarryingJail") == true
    local v53 = LocalPlayer:GetAttribute("Jailed") == true
    if v51 ~= v7 then
        v7 = v51
        setUiHidden(v7)
    end
    local v54 = v51 or v52
    if v54 ~= v8 then
        v8 = v54
        if v54 then
            if v6 then
                v6:Play(0.15)
            end
        elseif v6 then
            v6:Stop(0.15)
        end
    end
    local v55 = LocalPlayer:GetAttribute("GuardMorph") ~= nil
    setJailUiHidden(v52 or v53 or v55)
end

function v1.Start() -- line 267 | captures: LocalPlayer, loadTrack, refreshState
    LocalPlayer:GetAttributeChangedSignal("Carrying"):Connect(refreshState)
    LocalPlayer:GetAttributeChangedSignal("CarryingJail"):Connect(refreshState)
    LocalPlayer:GetAttributeChangedSignal("Jailed"):Connect(refreshState)
    LocalPlayer:GetAttributeChangedSignal("GuardMorph"):Connect(refreshState)
    LocalPlayer.CharacterAdded:Connect(function(v56) -- line 274 | captures: loadTrack
        task.spawn(loadTrack, v56)
    end)
    if LocalPlayer.Character then
        task.spawn(loadTrack, LocalPlayer.Character)
    end
    refreshState()
end

return v1
