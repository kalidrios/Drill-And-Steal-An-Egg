-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local v1 = {}
local v2
local v3 = {}
local v4 = {}

local function barsGui(v5) -- line 40 | captures: LocalPlayer
    if v5.BarsGui then
        local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local v6 = PlayerGui and PlayerGui:FindFirstChild(v5.BarsGui)
        if v6 and v6:IsA("ScreenGui") then
            return v6
        end
    end
    return nil
end

local function setBars(v7, v8, v9) -- line 50 | captures: v2, TweenService, LocalPlayer
    local v10, v11
    if v7.BarsGui then
        local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        v10 = PlayerGui and PlayerGui:FindFirstChild(v7.BarsGui)
        v11 = false
    else
        v11 = true
    end
    if v11 or not (v10 and v10:IsA("ScreenGui")) then
        v10 = nil
    end
    if not v10 then
        return
    end
    if v8 then
        v10.Enabled = true
    elseif v9 then
        v10.Enabled = false
    else
        local delay = task.delay
        local BarsTime = v7.BarsTime
        local v12 = v10
        delay(BarsTime, function() -- line 62 | captures: v12, v2
            if not v2 then
                v12.Enabled = false
            end
        end)
    end
    local new = TweenInfo.new
    local v13 = if v9 then 0 else v7.BarsTime
    local v14 = new(v13, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    for v15, v16 in { "Top", "Bottom" } do
        local v17 = v10:FindFirstChild(v16)
        if v17 and v17:IsA("GuiObject") then
            local v18 = if v16 == "Top" then 0 else 1
            local v19 = if v16 == "Top" then -v17.Size.Y.Scale else 1 + v17.Size.Y.Scale
            local new = UDim2.new
            local Scale = v17.Position.X.Scale
            local Offset = v17.Position.X.Offset
            if not v8 then
                v18 = v19
            end
            local v20 = new(Scale, Offset, v18, 0)
            if v9 then
                v17.Position = v20
            else
                TweenService:Create(v17, v14, { Position = v20 }):Play()
            end
        end
    end
end

local function findPath(v21) -- line 86 | captures: Workspace
    local v22 = Workspace
    for v23, v24 in v21 do
        v22 = v22 and v22:FindFirstChild(v24)
    end
    return v22
end

local function hideInTheWay(v25) -- line 96 | captures: Workspace, v4
    for v26, v27 in v25 do
        local v28 = Workspace
        for v29, v30 in v27 do
            v28 = v28 and v28:FindFirstChild(v30)
        end
        if v28 then
            for v31, v32 in v28:GetDescendants() do
                if v32:IsA("BasePart") or v32:IsA("Decal") or v32:IsA("Texture") then
                    v32.LocalTransparencyModifier = 1
                    table.insert(v4, v32)
                end
            end
            if v28:IsA("BasePart") then
                v28.LocalTransparencyModifier = 1
                table.insert(v4, v28)
            end
        end
    end
end

local function showInTheWay() -- line 114 | captures: v4
    for v33, v34 in v4 do
        if v34.Parent then
            v34.LocalTransparencyModifier = 0
        end
    end
    table.clear(v4)
end

function v1.IsActive() -- line 123 | captures: v2
    return v2 ~= nil
end

function v1.ParkBars(v35) -- line 129 | captures: v2, setBars
    if not v2 then
        setBars(v35, false, true)
    end
end

function v1.Enter(v36) -- line 136 | captures: v2, LocalPlayer, v3, setBars, hideInTheWay
    if v2 then
        return false
    end
    v2 = v36
    if v36.HideInCutscene then
        hideInTheWay(v36.HideInCutscene)
    end
    setBars(v36, false, true)
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if PlayerGui then
        for v37, v38 in PlayerGui:GetChildren() do
            if v38:IsA("ScreenGui") and v38.Name ~= v36.BarsGui and v38.Enabled then
                v3[v38] = true
                v38.Enabled = false
            end
        end
    end
    setBars(v36, true)
    return true
end

function v1.Exit() -- line 158 | captures: v2, v3, v4, setBars
    local v39 = v2
    if not v39 then
        return
    end
    v2 = nil
    for v40, v41 in v4 do
        if v41.Parent then
            v41.LocalTransparencyModifier = 0
        end
    end
    table.clear(v4)
    for v42 in v3 do
        if v42.Parent then
            v42.Enabled = true
        end
    end
    table.clear(v3)
    setBars(v39, false)
end

return v1
