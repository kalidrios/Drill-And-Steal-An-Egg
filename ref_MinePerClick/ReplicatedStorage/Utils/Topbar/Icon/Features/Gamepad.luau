-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local GamepadService = game:GetService("GamepadService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local DPadUp = Enum.KeyCode.DPadUp
local Gamepad = Enum.PreferredInput.Gamepad
local t = {}
local v1 = nil

function t.start(p1) --[[ start | Line: 26 | Upvalues: v1 (ref), DPadUp (copy), GuiService (copy), UserInputService (copy), Gamepad (copy), t (copy), GamepadService (copy) ]]
	v1 = p1

	local v12 = v1

	v12.highlightKey = if v1.highlightKey == nil then DPadUp else v1.highlightKey
	v1.highlightIcon = false
	task.delay(1, function() --[[ Line: 35 | Upvalues: v1 (ref), GuiService (ref), DPadUp (ref), UserInputService (ref), Gamepad (ref), t (ref), GamepadService (ref) ]]
		local iconsDictionary = v1.iconsDictionary

		local function getIconFromSelectedObject() --[[ getIconFromSelectedObject | Line: 38 | Upvalues: GuiService (ref), iconsDictionary (copy) ]]
			local SelectedObject = GuiService.SelectedObject
			local v1 = if SelectedObject then SelectedObject:GetAttribute("CorrespondingIconUID") else SelectedObject

			return if v1 then iconsDictionary[v1] else v1
		end

		local v12 = nil
		local isNotHighlightKey = DPadUp ~= v1.highlightKey
		local v2 = if DPadUp == v1.highlightKey then false else true
		local Selection = require(script.Parent.Parent.Elements.Selection)

		local function updateSelectedObject() --[[ updateSelectedObject | Line: 50 | Upvalues: GuiService (ref), iconsDictionary (copy), UserInputService (ref), Gamepad (ref), Selection (copy), v1 (ref), v12 (ref), v2 (ref), isNotHighlightKey (ref), t (ref) ]]
			local SelectedObject = GuiService.SelectedObject
			local v13 = if SelectedObject then SelectedObject:GetAttribute("CorrespondingIconUID") else SelectedObject
			local v22 = if v13 then iconsDictionary[v13] else v13
			local isPreferredInput = UserInputService.PreferredInput == Gamepad

			if v22 then
				local v3

				if isPreferredInput then
					local v4 = v22:getInstance("ClickRegion")
					local selection = v22.selection

					if selection then
						v3 = v22
					else
						local v5 = v22.janitor:add(Selection(v1))

						v5:SetAttribute("IgnoreVisibilityUpdater", true)
						v5.Parent = v22.widget
						v22.selection = v5
						v22:refreshAppearance(v5)
						selection = v5
						v3 = v22
					end

					v4.SelectionImageObject = selection.Selection
				else
					v3 = v22
				end

				if v12 and v12 ~= v3 then
					v12:setIndicator()
				end

				local v6 = if isPreferredInput and not (v2 or v3.parentIconUID) then Enum.KeyCode.ButtonB else nil

				v12 = v3
				v1.lastHighlightedIcon = v3
				v3:setIndicator(v6)
			else
				local v7 = if isPreferredInput and not isNotHighlightKey then v1.highlightKey else nil

				if not v12 then
					v12 = t.getIconToHighlight()
				end

				if v7 == v1.highlightKey then
					isNotHighlightKey = true
				end

				if not v12 then
					return
				end

				v12:setIndicator(v7)
			end
		end

		GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(updateSelectedObject)

		local function preferredInputChanged() --[[ preferredInputChanged | Line: 93 | Upvalues: UserInputService (ref), Gamepad (ref), isNotHighlightKey (ref), v2 (ref), updateSelectedObject (copy) ]]
			if UserInputService.PreferredInput == Gamepad then
				updateSelectedObject()

				return
			end

			isNotHighlightKey = false
			v2 = false
			updateSelectedObject()
		end

		UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(preferredInputChanged)

		local isPreferredInput = UserInputService.PreferredInput == Gamepad

		if not isPreferredInput then
			isNotHighlightKey = false
			v2 = false
		end

		updateSelectedObject()
		UserInputService.InputBegan:Connect(function(p1, p2) --[[ Line: 109 | Upvalues: GuiService (ref), iconsDictionary (copy), v1 (ref), t (ref), GamepadService (ref) ]]
			if p1.UserInputType == Enum.UserInputType.MouseButton1 then
				local SelectedObject = GuiService.SelectedObject
				local v12 = if SelectedObject then SelectedObject:GetAttribute("CorrespondingIconUID") else SelectedObject

				if not (if v12 then iconsDictionary[v12] else v12) then
					return
				end

				GuiService.SelectedObject = nil
			else
				if p1.KeyCode ~= v1.highlightKey then
					return
				end

				local v3 = t.getIconToHighlight()

				if not v3 then
					return
				end

				if GamepadService.GamepadCursorEnabled then
					task.wait(0.2)
					GamepadService:DisableGamepadCursor()
				end

				GuiService.SelectedObject = v3:getInstance("ClickRegion")
			end
		end)
	end)
end
function t.getIconToHighlight() --[[ getIconToHighlight | Line: 136 | Upvalues: v1 (ref) ]]
	local iconsDictionary = v1.iconsDictionary
	local v12 = v1.highlightIcon or v1.lastHighlightedIcon

	if not v12 then
		local v2 = nil

		for k, v in pairs(iconsDictionary) do
			if not v.parentIconUID and (not v2 or v.widget.AbsolutePosition.X < v2) then
				v2 = v.widget.AbsolutePosition.X
				v12 = v
			end
		end
	end

	return v12
end
function t.registerButton(p1) --[[ registerButton | Line: 158 | Upvalues: UserInputService (copy), GamepadService (copy), GuiService (copy) ]]
	local v1 = false

	p1.InputBegan:Connect(function(p1) --[[ Line: 164 | Upvalues: v1 (ref) ]]
		v1 = true
		task.wait()
		task.wait()
		v1 = false
	end)

	local v2 = UserInputService.InputBegan:Connect(function(p12) --[[ Line: 173 | Upvalues: v1 (ref), GamepadService (ref), GuiService (ref), p1 (copy) ]]
		task.wait()

		if p12.KeyCode == Enum.KeyCode.ButtonA and v1 then
			task.wait(0.2)
			GamepadService:DisableGamepadCursor()
			GuiService.SelectedObject = p1

			return
		end

		local v12 = if GuiService.SelectedObject == p1 then true else false
		local v2 = p12.KeyCode.Name

		if not table.find({ "ButtonB", "ButtonSelect" }, v2) or (not v12 or v2 == "ButtonSelect" and not GamepadService.GamepadCursorEnabled) then
			return
		end

		GuiService.SelectedObject = nil
	end)

	p1.Destroying:Once(function() --[[ Line: 194 | Upvalues: v2 (copy) ]]
		v2:Disconnect()
	end)
end

return t