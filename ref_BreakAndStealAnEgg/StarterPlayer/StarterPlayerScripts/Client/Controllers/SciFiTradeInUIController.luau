-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local SciFiTradeInUIConfig = require(ReplicatedStorage.Shared.SciFiTradeInUIConfig)
local Session = require(script.Parent.Parent.Modules.SciFiTradeInUI.Session)
local DemonEventUIController = require(script.Parent.DemonEventUIController)
local NotificationController = require(script.Parent.NotificationController)
local UiFrames = require(script.Parent.UiFrames)
local v1 = {}
local v2
local v3 = {}

local function notify(v4) -- line 60 | captures: v3
    for v5, v6 in v3 do
        task.spawn(v6, v4)
    end
end

local function onOpenChanged(v7) -- line 68 | captures: DemonEventUIController, NotificationController, UiFrames, v3
    local v8 = v7:GetAttribute("Open") == true
    if v8 then
        local v9 = UiFrames.GetOpen()
        if v9 then
            UiFrames.Close(v9)
        end
        DemonEventUIController.Close()
        NotificationController.Raise(v7)
    else
        NotificationController.Lower(v7)
    end
    for v10, v11 in v3 do
        task.spawn(v11, v8)
    end
end

local function bind(v12) -- line 84 | captures: v2, Session, NotificationController, v3, onOpenChanged
    if not (v12.Name == "SciFi UI" and v12:IsA("ScreenGui")) then
        return
    end
    if v2 and v2.Gui == v12 and v2.IsAlive() then
        return
    end
    if v2 then
        v2.Destroy()
        v2 = nil
    end
    local v13, v14 = pcall(Session.new, v12)
    if v13 then
        v2 = v14
        local v15 = v12:GetAttributeChangedSignal("Open"):Connect(function() -- line 102 | captures: v12, onOpenChanged
            onOpenChanged(v12)
        end)
        v12.Destroying:Once(function() -- line 105 | captures: v12, v14, v15, v2, NotificationController, v3
            v15:Disconnect()
            if v2 == v14 then
                v2 = nil
            end
            NotificationController.Lower(v12)
            for v16, v17 in v3 do
                task.spawn(v17, false)
            end
        end)
    else
        warn((("[SciFiTradeInUIController] failed to bind %*: %*"):format(v12:GetFullName(), v14)))
    end
end

local function getSession() -- line 115 | captures: v2
    if not (v2 and v2.IsAlive()) then
        return nil
    end
    return v2
end

function v1.Open() -- line 122 | captures: v2
    local v18
    if not (v2 and v2.IsAlive()) then
    else
        v18 = v2
    end
    if v18 then
        v18.SetOpen(true)
    end
end

function v1.Close() -- line 129 | captures: v2
    local v19
    if not (v2 and v2.IsAlive()) then
    else
        v19 = v2
    end
    if v19 then
        v19.SetOpen(false)
    end
end

function v1.Toggle() -- line 136 | captures: v2
    local v20
    if not (v2 and v2.IsAlive()) then
    else
        v20 = v2
    end
    if v20 then
        v20.SetOpen(not v20.IsOpen())
    end
end

function v1.IsOpen() -- line 143 | captures: v2
    local v21
    if not (v2 and v2.IsAlive()) then
    else
        v21 = v2
    end
    if v21 == nil then
        return false
    end
    return (v21.IsOpen())
end

function v1.GetGui() -- line 148 | captures: v2
    local v22
    if not (v2 and v2.IsAlive()) then
    else
        v22 = v2
    end
    return v22 and v22.Gui or nil
end

function v1.Observe(v23) -- line 154 | captures: v3
    table.insert(v3, v23)
end

local v24 = {}

local function bindPrompt(v25) -- line 167 | captures: v1, v24
    if not v25:IsA("ProximityPrompt") or v24[v25] then
        return
    end
    v24[v25] = v25.Triggered:Connect(function() -- line 175 | captures: v1
        v1.Open()
    end)
    local v26
    v26 = v25.AncestryChanged:Connect(function() -- line 180 | captures: v26, v25, v24
        if v25:IsDescendantOf(game) then
            return
        end
        v26:Disconnect()
        local v27 = v24[v25]
        if v27 then
            v27:Disconnect()
            v24[v25] = nil
        end
    end)
end

local function bindMachine(v28) -- line 193 | captures: SciFiTradeInUIConfig, bindPrompt
    if v28.Name == SciFiTradeInUIConfig.MACHINE_NAME then
        for v29, v30 in v28:GetDescendants() do
            bindPrompt(v30)
        end
        v28.DescendantAdded:Connect(bindPrompt)
    end
end

function v1.Start() -- line 203 | captures: Players, Workspace, DemonEventUIController, UiFrames, v1, bind, bindMachine
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    PlayerGui.ChildAdded:Connect(bind)
    local v31 = PlayerGui:FindFirstChild("SciFi UI")
    if v31 then
        bind(v31)
    end
    UiFrames.ObserveAny(function(v32, v33) -- line 213 | captures: v1
        if v33 then
            v1.Close()
        end
    end)
    DemonEventUIController.Observe(function(v34) -- line 219 | captures: v1
        if v34 then
            v1.Close()
        end
    end)
    Workspace.ChildAdded:Connect(bindMachine)
    for v35, v36 in Workspace:GetChildren() do
        bindMachine(v36)
    end
end

return v1
