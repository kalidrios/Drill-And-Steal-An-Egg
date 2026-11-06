-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HotbarAnchorConfig = require(ReplicatedStorage.Shared.HotbarAnchorConfig)
local BackpackController = require(script.Parent.BackpackController)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {}
local v2 = Vector2.new(0.5, 0.5)
local v3 = {}
local v4 = {}
local v5 = false

local function unscaledHeight(v6) -- line 38
    local UIScale = v6:FindFirstChildWhichIsA("UIScale")
    local v7 = if not (UIScale and UIScale.Scale > 0) then 1 else UIScale.Scale
    return v6.AbsoluteSize.Y / v7
end

local function applyOne(v8, v9) -- line 44 | captures: HotbarAnchorConfig, v2
    if v8.Parent == nil then
        return
    end
    v8.AnchorPoint = v2
    v8.Position = UDim2.new(0.5, 0, 0, 0)
    local v10 = v8.AbsolutePosition.Y + v8.AbsoluteSize.Y / 2
    local v11 = v9.AbsolutePosition.Y - HotbarAnchorConfig.GapPx
    local UIScale = v8:FindFirstChildWhichIsA("UIScale")
    local v12 = if not (UIScale and UIScale.Scale > 0) then 1 else UIScale.Scale
    local v13 = v11 - v8.AbsoluteSize.Y / v12 / 2
    local new = UDim2.new
    local v14 = v13 - v10 + 0.5
    v8.Position = new(0.5, 0, 0, (math.floor(v14)))
end

local function applyAll() -- line 64 | captures: v5, BackpackController, v3, applyOne
    v5 = false
    local v15 = BackpackController.GetHotbarFrame()
    if v15 and v15.Parent ~= nil then
        for v16, v17 in v3 do
            applyOne(v17, v15)
        end
    end
end

local function queueApply() -- line 77 | captures: v5, applyAll
    if not v5 then
        v5 = true
        task.defer(applyAll)
    end
end

local function adoptGui(v18) -- line 85 | captures: v5, HotbarAnchorConfig, v3, v4, applyAll, queueApply
    local function v19(v20, ...)
        table.insert(v20, ...)
    end

    local function v21(v22, ...)
        table.insert(v22, ...)
    end

    for v23, v24 in v4 do
        v24:Disconnect()
    end
    table.clear(v4)
    table.clear(v3)
    for v25, v26 in HotbarAnchorConfig.Buttons do
        local v27 = v18:FindFirstChild(v26)
        if v27 and v27:IsA("GuiObject") then
            table.insert(v3, v27)
            v19(v4, v27:GetPropertyChangedSignal("Size"):Connect(queueApply))
        else
            warn((("[HotbarAnchorController] MainGUI.%* not found"):format(v26)))
        end
    end
    v21(v4, v18:GetPropertyChangedSignal("AbsoluteSize"):Connect(queueApply))
    if not v5 then
        v5 = true
        task.defer(applyAll)
    end
end

function v1.Start() -- line 109 | captures: BackpackController, MainGui, queueApply, adoptGui
    local v28 = os.clock() + 60
    while true do
        if BackpackController.IsReady() then
            break
        end
        if v28 < os.clock() then
            warn("[HotbarAnchorController] hotbar never came up \226\128\148 buttons keep their authored position")
            return
        end
        task.wait(0.1)
    end
    local v29 = BackpackController.GetHotbarFrame()
    if not v29 then
        return
    end
    v29:GetPropertyChangedSignal("AbsolutePosition"):Connect(queueApply)
    v29:GetPropertyChangedSignal("AbsoluteSize"):Connect(queueApply)
    MainGui.Observe(adoptGui)
end

return v1
