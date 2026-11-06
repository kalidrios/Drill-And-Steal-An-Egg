-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ContextActionService = game:GetService("ContextActionService")
local GamepadService = game:GetService("GamepadService")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GamepadConfig = require(ReplicatedStorage.Shared.GamepadConfig)
local UiFramesConfig = require(ReplicatedStorage.Shared.UiFramesConfig)
local UiFrames = require(script.Parent.UiFrames)
local v1 = {}

function v1.IsUsingGamepad() -- line 50 | captures: GuiService, UserInputService, GamepadConfig
    if GamepadConfig.IsGamepadInput(UserInputService:GetLastInputType()) then
        return true
    end
    return GuiService:IsTenFootInterface()
end

local function isInside(v2, v3) -- line 58
    if v2 == nil or v3 == nil then
        return false
    end
    return (v2:IsDescendantOf(v3))
end

local function clearSelectionInside(v4) -- line 62 | captures: GuiService
    local SelectedObject = GuiService.SelectedObject
    if SelectedObject ~= nil and v4 ~= nil and SelectedObject:IsDescendantOf(v4) then
        GuiService.SelectedObject = nil
    end
end

local function isShown(v5, v6) -- line 71
    local v7 = v5
    while true do
        if v7 then
            if v7 == v6.Parent then
                return true
            end
            if not v7:IsA("GuiObject") or v7.Visible then
                v7 = v7.Parent
                continue
            end
            break
        end
        return true
    end
    return false
end

local function pickButton(v8) -- line 82 | captures: GamepadConfig, isShown
    local v9, v10
    for v11, v12 in v8:GetDescendants() do
        if v12:IsA("GuiButton") and v12.Selectable and isShown(v12, v8) then
            if GamepadConfig.AutoSelectSkipNames[v12.Name] then
                v10 = v10 or v12
            elseif v9 == nil then
                v9 = v12
            else
                local AbsolutePosition = v12.AbsolutePosition
                local AbsolutePosition_2 = v9.AbsolutePosition
                if AbsolutePosition.Y < AbsolutePosition_2.Y - 1 then
                    v9 = v12
                else
                    local v13 = AbsolutePosition.Y - AbsolutePosition_2.Y
                    if math.abs(v13) <= 1 and AbsolutePosition.X < AbsolutePosition_2.X then
                        v9 = v12
                    end
                end
            end
        end
    end
    return v9 or v10
end

local function isCursorOn() -- line 114 | captures: GamepadService
    return GamepadService.GamepadCursorEnabled
end

local function enableCursor(v14) -- line 120 | captures: GamepadService, GamepadConfig
    if GamepadConfig.UseVirtualCursor then
        if GamepadService.GamepadCursorEnabled then
            return true
        end
        pcall(function() -- line 127 | captures: v14, GamepadService
            GamepadService:EnableGamepadCursor(v14)
        end)
        return GamepadService.GamepadCursorEnabled
    end
    return false
end

local function disableCursor() -- line 133 | captures: GamepadService
    if GamepadService.GamepadCursorEnabled then
        pcall(function() -- line 137 | captures: GamepadService
            GamepadService:DisableGamepadCursor()
        end)
        return true
    end
    return false
end

local function onWindowChanged(v15, v16) -- line 143 | captures: GamepadService, GuiService, GamepadConfig, UiFramesConfig, UiFrames, v1, pickButton
    if v16 then
        if GamepadConfig.AutoSelectOnOpen and v1.IsUsingGamepad() then
            task.delay(UiFramesConfig.TweenDuration, function() -- line 159 | captures: v15, GamepadService, GuiService, GamepadConfig, UiFrames, v1, pickButton
                local v17
                if UiFrames.GetOpen() == v15 and v1.IsUsingGamepad() then
                    local SelectedObject = GuiService.SelectedObject
                    if SelectedObject == nil or v15 == nil then
                        v17 = false
                    else
                        v17 = SelectedObject:IsDescendantOf(v15)
                    end
                else
                    return
                end
                if v17 then
                    return
                end
                local v18 = pickButton(v15)
                local v19 = v18 or v15
                local v20
                if GamepadConfig.UseVirtualCursor then
                    if GamepadService.GamepadCursorEnabled then
                        v20 = true
                    else
                        pcall(function() -- line 127 | captures: v19, GamepadService
                            GamepadService:EnableGamepadCursor(v19)
                        end)
                        v20 = GamepadService.GamepadCursorEnabled
                    end
                else
                    v20 = false
                end
                if not v20 and v18 then
                    GuiService.SelectedObject = v18
                end
            end)
        end
    else
        local SelectedObject = GuiService.SelectedObject
        if SelectedObject ~= nil and v15 ~= nil and SelectedObject:IsDescendantOf(v15) then
            GuiService.SelectedObject = nil
        end
        if UiFrames.GetOpen() == nil then
            if not GamepadService.GamepadCursorEnabled then
                return
            end
            pcall(function() -- line 137 | captures: GamepadService
                GamepadService:DisableGamepadCursor()
            end)
        end
    end
end

local function onBack(v21, v22, v23) -- line 179 | captures: GamepadService, GuiService, UiFrames
    if v22 == Enum.UserInputState.Begin then
        local v24 = UiFrames.GetOpen()
        if v24 then
            local SelectedObject = GuiService.SelectedObject
            if SelectedObject ~= nil and v24 ~= nil and SelectedObject:IsDescendantOf(v24) then
                GuiService.SelectedObject = nil
            end
            UiFrames.Close(v24)
            if GamepadService.GamepadCursorEnabled then
                pcall(function() -- line 137 | captures: GamepadService
                    GamepadService:DisableGamepadCursor()
                end)
            end
        elseif GamepadService.GamepadCursorEnabled then
            pcall(function() -- line 137 | captures: GamepadService
                GamepadService:DisableGamepadCursor()
            end)
        else
            if GuiService.SelectedObject == nil then
                return Enum.ContextActionResult.Pass
            end
            GuiService.SelectedObject = nil
        end
        return Enum.ContextActionResult.Sink
    end
    return Enum.ContextActionResult.Pass
end

local function onCursorToggle(v25, v26, v27) -- line 207 | captures: GamepadService, GuiService, GamepadConfig, UiFrames, pickButton
    local v28
    if v26 == Enum.UserInputState.Begin and GamepadConfig.UseVirtualCursor then
        if GamepadService.GamepadCursorEnabled then
            pcall(function() -- line 137 | captures: GamepadService
                GamepadService:DisableGamepadCursor()
            end)
            v28 = true
        else
            v28 = false
        end
    else
        return Enum.ContextActionResult.Pass
    end
    if not v28 then
        local v29 = UiFrames.GetOpen()
        local v30 = v29 and pickButton(v29) or v29
        GuiService.SelectedObject = nil
        pcall(function() -- line 218 | captures: v30, GamepadService
            GamepadService:EnableGamepadCursor(v30)
        end)
        if not GamepadService.GamepadCursorEnabled then
            warn("[GamepadController] Virtual cursor unavailable \226\128\148 set StarterGui.VirtualCursorMode to Enabled")
        end
    end
    return Enum.ContextActionResult.Sink
end

function v1.Start() -- line 227 | captures: ContextActionService, GamepadConfig, UiFrames, onWindowChanged, onBack, onCursorToggle
    UiFrames.ObserveAny(onWindowChanged)
    ContextActionService:BindAction("GamepadCursorToggle", onCursorToggle, false, GamepadConfig.CursorToggleButton)
    ContextActionService:BindActionAtPriority("GamepadBackOut", onBack, false, Enum.ContextActionPriority.Low.Value, GamepadConfig.BackButton)
end

return v1
