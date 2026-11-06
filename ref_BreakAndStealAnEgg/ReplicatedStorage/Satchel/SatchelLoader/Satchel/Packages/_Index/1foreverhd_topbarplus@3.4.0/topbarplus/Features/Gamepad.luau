-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local GamepadService = game:GetService("GamepadService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local DPadUp = Enum.KeyCode.DPadUp
local Gamepad = Enum.PreferredInput.Gamepad
local v1 = {}
local v2

function v1.start(v3) -- line 26 | captures: v2, GamepadService, UserInputService, GuiService, DPadUp, Gamepad, v1
    v2 = v3
    local v4 = v2
    if v2.highlightKey == nil then
        v4.highlightKey = DPadUp
    else
        v4.highlightKey = v2.highlightKey
    end
    v2.highlightIcon = false
    task.delay(1, function() -- line 35 | captures: v2, GamepadService, UserInputService, GuiService, DPadUp, Gamepad, v1
        local iconsDictionary = v2.iconsDictionary

        local function getIconFromSelectedObject() -- line 38 | captures: iconsDictionary, GuiService
            local SelectedObject = GuiService.SelectedObject
            local v5 = SelectedObject and SelectedObject:GetAttribute("CorrespondingIconUID")
            return v5 and iconsDictionary[v5]
        end

        local v6
        local v7 = DPadUp ~= v2.highlightKey
        local v8 = DPadUp ~= v2.highlightKey
        local Selection = require(script.Parent.Parent.Elements.Selection)

        local function updateSelectedObject() -- line 50 | captures: v6, v7, v8, iconsDictionary, Selection, v2, UserInputService, GuiService, Gamepad, v1
            local SelectedObject = GuiService.SelectedObject
            local v9 = SelectedObject and SelectedObject:GetAttribute("CorrespondingIconUID")
            local v10 = v9 and iconsDictionary[v9]
            local v11 = UserInputService.PreferredInput == Gamepad
            if v10 then
                if v11 then
                    local ClickRegion = v10:getInstance("ClickRegion")
                    local selection = v10.selection
                    if not selection then
                        selection = v10.janitor:add(Selection(v2))
                        selection:SetAttribute("IgnoreVisibilityUpdater", true)
                        selection.Parent = v10.widget
                        v10.selection = selection
                        v10:refreshAppearance(selection)
                    end
                    ClickRegion.SelectionImageObject = selection.Selection
                end
                if v6 and v6 ~= v10 then
                    v6:setIndicator()
                end
                local v12 = if v11 and not v8 and not v10.parentIconUID then Enum.KeyCode.ButtonB else nil
                v6 = v10
                v2.lastHighlightedIcon = v10
                v10:setIndicator(v12)
            else
                local highlightKey
                if not v11 or v7 then
                else
                    highlightKey = v2.highlightKey
                end
                v6 = v6 or v1.getIconToHighlight()
                if highlightKey == v2.highlightKey then
                    v7 = true
                end
                if v6 then
                    v6:setIndicator(highlightKey)
                end
            end
        end

        GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(updateSelectedObject)

        local function preferredInputChanged() -- line 93 | captures: v7, v8, updateSelectedObject, UserInputService, Gamepad
            if UserInputService.PreferredInput ~= Gamepad then
                v7 = false
                v8 = false
            end
            updateSelectedObject()
        end

        UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(preferredInputChanged)
        if UserInputService.PreferredInput ~= Gamepad then
            v7 = false
            v8 = false
        end
        updateSelectedObject()
        UserInputService.InputBegan:Connect(function(v13, v14) -- line 109 | captures: iconsDictionary, v2, GamepadService, GuiService, v1
            if v13.UserInputType == Enum.UserInputType.MouseButton1 then
                local SelectedObject = GuiService.SelectedObject
                local v15 = SelectedObject and SelectedObject:GetAttribute("CorrespondingIconUID")
                if v15 and iconsDictionary[v15] then
                    GuiService.SelectedObject = nil
                end
            elseif v13.KeyCode == v2.highlightKey then
                local v16 = v1.getIconToHighlight()
                if v16 then
                    if GamepadService.GamepadCursorEnabled then
                        task.wait(0.2)
                        GamepadService:DisableGamepadCursor()
                    end
                    local ClickRegion = v16:getInstance("ClickRegion")
                    GuiService.SelectedObject = ClickRegion
                end
            end
        end)
    end)
end

function v1.getIconToHighlight() -- line 136 | captures: v2
    local iconsDictionary = v2.iconsDictionary
    local v17 = v2.highlightIcon or v2.lastHighlightedIcon
    if not v17 then
        local v18 = v17
        local X
        for v19, v20 in pairs(iconsDictionary) do
            if not v20.parentIconUID then
                local X_2 = v20.widget.AbsolutePosition.X
                if X then
                    if X_2 < X then
                        X = v20.widget.AbsolutePosition.X
                        v18 = v20
                    end
                else
                    X = v20.widget.AbsolutePosition.X
                    v18 = v20
                end
            end
            v17 = v18
        end
    end
    return v17
end

function v1.registerButton(v21) -- line 158 | captures: GamepadService, UserInputService, GuiService
    local v22 = false
    v21.InputBegan:Connect(function(v23) -- line 164 | captures: v22
        v22 = true
        task.wait()
        task.wait()
        v22 = false
    end)
    local v24 = UserInputService.InputBegan:Connect(function(v25) -- line 173 | captures: v22, v21, GamepadService, GuiService
        task.wait()
        if not (v25.KeyCode == Enum.KeyCode.ButtonA and v22) then
            local v26 = GuiService.SelectedObject == v21
            local v27 = { "ButtonB", "ButtonSelect" }
            local Name = v25.KeyCode.Name
            if table.find(v27, Name) and v26 and (Name ~= "ButtonSelect" or GamepadService.GamepadCursorEnabled) then
                GuiService.SelectedObject = nil
            end
        else
            task.wait(0.2)
            GamepadService:DisableGamepadCursor()
            GuiService.SelectedObject = v21
        end
    end)
    v21.Destroying:Once(function() -- line 194 | captures: v24
        v24:Disconnect()
    end)
end

return v1
