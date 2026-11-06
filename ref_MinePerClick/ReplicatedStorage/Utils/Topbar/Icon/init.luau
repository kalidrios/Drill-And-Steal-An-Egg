-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local UserInputService = game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

require(script.Types)

local v1 = script
local Reference = require(v1.Reference)
local v2 = Reference.getObject()
local v3 = if v2 then v2.Value else v2

if v3 and v3 ~= v1 then
	return require(v3)
end

local v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16

if v2 then
	v4 = require(v1.Packages.GoodSignal)
	v5 = require(v1.Packages.Janitor)
	v6 = require(v1.Utility)
	v7 = require(v1.Features.Themes)
	v8 = require(v1.Features.Gamepad)
	v9 = require(v1.Features.Overflow)
	v10 = {}
	v10.__index = v10
	v11 = Players.LocalPlayer
	v12 = v1.Features.Themes
	v13 = {}
	v14 = v4.new()
	v15 = v1.Elements
	v16 = 0
	v10.baseDisplayOrderChanged = v4.new()
	v10.baseDisplayOrder = 10
	v10.baseTheme = require(v12.Default)
	v10.isOldTopbar = false
	v10.iconsDictionary = v13
	v10.insetHeightChanged = v4.new()
	v10.container = require(v15.Container)(v10)
	v10.topbarEnabled = true
	v10.iconAdded = v4.new()
	v10.iconRemoved = v4.new()
	v10.iconChanged = v4.new()
	function v10.getIcons() --[[ getIcons | Line: 105 | Upvalues: v10 (copy) ]]
		return v10.iconsDictionary
	end
	function v10.getIconByUID(p13) --[[ getIconByUID | Line: 109 | Upvalues: v10 (copy) ]]
		local v1 = v10.iconsDictionary[p13]

		if v1 then
			return v1
		end

		return nil
	end
	function v10.getIcon(p13) --[[ getIcon | Line: 117 | Upvalues: v10 (copy), v13 (copy) ]]
		local v1 = v10.getIconByUID(p13)

		if v1 then
			return v1
		end

		for k2, v in pairs(v13) do
			if v.name == p13 then
				return v
			end
		end

		return nil
	end
	function v10.setTopbarEnabled(p13, p23) --[[ setTopbarEnabled | Line: 130 | Upvalues: v10 (copy) ]]
		if typeof(p13) ~= "boolean" then
			p13 = v10.topbarEnabled
		end

		if not p23 then
			v10.topbarEnabled = p13
		end

		for k2, v in pairs(v10.container) do
			v.Enabled = p13
		end
	end
	function v10.modifyBaseTheme(p13) --[[ modifyBaseTheme | Line: 142 | Upvalues: v7 (copy), v10 (copy), v13 (copy) ]]
		for k2, v in pairs((v7.getModifications(p13))) do
			for k22, v3 in pairs(v10.baseTheme) do
				v7.merge(v3, v)
			end
		end

		for k2, v in pairs(v13) do
			v:setTheme(v10.baseTheme)
		end
	end
	function v10.setDisplayOrder(p13) --[[ setDisplayOrder | Line: 154 | Upvalues: v10 (copy) ]]
		v10.baseDisplayOrder = p13
		v10.baseDisplayOrderChanged:Fire(p13)
	end
	task.defer(v8.start, v10)
	task.defer(v9.start, v10)
	task.defer(function() --[[ Line: 164 | Upvalues: v11 (copy), v10 (copy), v1 (copy) ]]
		local PlayerGui = v11:WaitForChild("PlayerGui")

		for k2, v in pairs(v10.container) do
			v.Parent = PlayerGui
		end

		require(v1.Attribute)
	end)
	function v10.new() --[[ new | Line: 175 | Upvalues: v10 (copy), v5 (copy), v6 (copy), v13 (copy), v4 (copy), v1 (copy), v15 (copy), v16 (ref), UserInputService (copy), v14 (copy), StarterGui (copy) ]]
		local t2 = {}
		local v12 = v10

		setmetatable(t2, v12)

		local v2 = v5.new()

		t2.janitor = v2
		t2.themesJanitor = v2:add(v5.new())
		t2.singleClickJanitor = v2:add(v5.new())
		t2.captionJanitor = v2:add(v5.new())
		t2.joinJanitor = v2:add(v5.new())
		t2.menuJanitor = v2:add(v5.new())
		t2.dropdownJanitor = v2:add(v5.new())

		local v3 = v6.generateUID()

		v13[v3] = t2
		v2:add(function() --[[ Line: 192 | Upvalues: v13 (ref), v3 (copy) ]]
			v13[v3] = nil
		end)
		t2.selected = v2:add(v4.new())
		t2.deselected = v2:add(v4.new())
		t2.toggled = v2:add(v4.new())
		t2.viewingStarted = v2:add(v4.new())
		t2.viewingEnded = v2:add(v4.new())
		t2.stateChanged = v2:add(v4.new())
		t2.notified = v2:add(v4.new())
		t2.noticeStarted = v2:add(v4.new())
		t2.noticeChanged = v2:add(v4.new())
		t2.endNotices = v2:add(v4.new())
		t2.toggleKeyAdded = v2:add(v4.new())
		t2.fakeToggleKeyChanged = v2:add(v4.new())
		t2.alignmentChanged = v2:add(v4.new())
		t2.updateSize = v2:add(v4.new())
		t2.resizingComplete = v2:add(v4.new())
		t2.joinedParent = v2:add(v4.new())
		t2.menuSet = v2:add(v4.new())
		t2.dropdownSet = v2:add(v4.new())
		t2.updateMenu = v2:add(v4.new())
		t2.startMenuUpdate = v2:add(v4.new())
		t2.childThemeModified = v2:add(v4.new())
		t2.indicatorSet = v2:add(v4.new())
		t2.dropdownChildAdded = v2:add(v4.new())
		t2.menuChildAdded = v2:add(v4.new())
		t2.iconModule = v1
		t2.UID = v3
		t2.isEnabled = true
		t2.enabled = t2.isEnabled
		t2.isSelected = false
		t2.isViewing = false
		t2.joinedFrame = false
		t2.parentIconUID = false
		t2.deselectWhenOtherIconSelected = true
		t2.totalNotices = 0
		t2.activeState = "Deselected"
		t2.alignment = ""
		t2.originalAlignment = ""
		t2.appliedTheme = {}
		t2.appearance = {}
		t2.cachedInstances = {}
		t2.cachedNamesToInstances = {}
		t2.cachedCollectives = {}
		t2.bindedToggleKeys = {}
		t2.customBehaviours = {}
		t2.toggleItems = {}
		t2.bindedEvents = {}
		t2.notices = {}
		t2.menuIcons = {}
		t2.dropdownIcons = {}
		t2.childIconsDict = {}
		t2.creationTime = os.clock()
		t2.widget = v2:add(require(v15.Widget)(t2, v10))
		t2:setAlignment()
		v16 = v16 + 1

		local v42 = v16 * 0.01 + 1

		t2:setOrder(v42, "deselected")
		t2:setOrder(v42, "selected")
		t2:setTheme(v10.baseTheme)

		local v52 = t2:getInstance("ClickRegion")

		local function handleToggle() --[[ handleToggle | Line: 268 | Upvalues: t2 (copy) ]]
			if t2.locked then
				return
			end

			if t2.isSelected then
				t2:deselect("User", t2)
			else
				t2:select("User", t2)
			end
		end

		local v62 = false
		local v7 = false

		v52.MouseButton1Click:Connect(function() --[[ Line: 280 | Upvalues: v62 (ref), v7 (ref), t2 (copy) ]]
			if v62 then
				return
			end

			v7 = true
			task.delay(0.01, function() --[[ Line: 285 | Upvalues: v7 (ref) ]]
				v7 = false
			end)

			if t2.locked then
				return
			end

			if t2.isSelected then
				t2:deselect("User", t2)
			else
				t2:select("User", t2)
			end
		end)
		v52.TouchTap:Connect(function() --[[ Line: 290 | Upvalues: v7 (ref), v62 (ref), t2 (copy) ]]
			if v7 then
				return
			end

			v62 = true
			task.delay(0.01, function() --[[ Line: 297 | Upvalues: v62 (ref) ]]
				v62 = false
			end)

			if t2.locked then
				return
			end

			if t2.isSelected then
				t2:deselect("User", t2)
			else
				t2:select("User", t2)
			end
		end)
		v2:add(UserInputService.InputBegan:Connect(function(p13, p23) --[[ Line: 304 | Upvalues: t2 (copy) ]]
			if t2.locked then
				return
			end

			if not t2.bindedToggleKeys[p13.KeyCode] or p23 then
				return
			end

			if t2.locked then
				return
			end

			if t2.isSelected then
				t2:deselect("User", t2)

				return
			end

			t2:select("User", t2)
		end))

		local function viewingStarted(p13) --[[ viewingStarted | Line: 316 | Upvalues: t2 (copy) ]]
			if t2.locked then
				return
			end

			t2.isViewing = true
			t2.viewingStarted:Fire(true)

			if p13 then
				return
			end

			t2:setState("Viewing", "User", t2)
		end

		local function viewingEnded() --[[ viewingEnded | Line: 326 | Upvalues: t2 (copy) ]]
			if not t2.locked then
				t2.isViewing = false
				t2.viewingEnded:Fire(true)
				t2:setState(nil, "User", t2)
			end
		end

		t2.joinedParent:Connect(function() --[[ Line: 334 | Upvalues: t2 (copy) ]]
			if not t2.isViewing then
				return
			end

			if t2.locked then
				return
			end

			t2.isViewing = false
			t2.viewingEnded:Fire(true)
			t2:setState(nil, "User", t2)
		end)
		v52.MouseEnter:Connect(function() --[[ Line: 339 | Upvalues: UserInputService (ref), t2 (copy) ]]
			if t2.locked then
				return
			end

			t2.isViewing = true
			t2.viewingStarted:Fire(true)

			if not UserInputService.KeyboardEnabled then
				return
			end

			t2:setState("Viewing", "User", t2)
		end)

		local v8 = 0

		v2:add(UserInputService.TouchEnded:Connect(viewingEnded))
		v52.MouseLeave:Connect(viewingEnded)
		v52.SelectionGained:Connect(viewingStarted)
		v52.SelectionLost:Connect(viewingEnded)
		v52.MouseButton1Down:Connect(function() --[[ Line: 348 | Upvalues: t2 (copy), UserInputService (ref), v8 (ref) ]]
			if t2.locked or not UserInputService.TouchEnabled then
				return
			end

			v8 = v8 + 1

			local v1 = v8

			task.delay(0.2, function() --[[ Line: 352 | Upvalues: v1 (copy), v8 (ref), t2 (ref) ]]
				if v1 ~= v8 then
					return
				end

				if t2.locked then
					return
				end

				t2.isViewing = true
				t2.viewingStarted:Fire(true)
				t2:setState("Viewing", "User", t2)
			end)
		end)
		v52.MouseButton1Up:Connect(function() --[[ Line: 359 | Upvalues: v8 (ref) ]]
			v8 = v8 + 1
		end)

		local v9 = t2:getInstance("IconOverlay")

		t2.viewingStarted:Connect(function() --[[ Line: 365 | Upvalues: v9 (copy), t2 (copy) ]]
			v9.Visible = not t2.overlayDisabled
		end)
		t2.viewingEnded:Connect(function() --[[ Line: 368 | Upvalues: v9 (copy) ]]
			v9.Visible = false
		end)
		v2:add(v14:Connect(function(p13) --[[ Line: 373 | Upvalues: t2 (copy) ]]
			if p13 == t2 or not (t2.deselectWhenOtherIconSelected and p13.deselectWhenOtherIconSelected) then
				return
			end

			t2:deselect("AutoDeselect", p13)
		end))

		local v11 = string.split(debug.info(2, "s"), ".")
		local v122 = game
		local v132 = nil

		for k2, v in pairs(v11) do
			local v142 = v122:FindFirstChild(v)

			v122 = v142

			if v142 then
				if v142:IsA("ScreenGui") then
					v122 = v142
					v132 = v142

					continue
				end
			else
				break
			end
		end

		if v122 and (v132 and v132.ResetOnSpawn == true) then
			t2.originsScreenGui = v132
			v6.localPlayerRespawned(function() --[[ Line: 399 | Upvalues: t2 (copy) ]]
				t2:destroy()
			end)
		end

		t2.toggled:Connect(function(p13) --[[ Line: 405 | Upvalues: t2 (copy), v10 (ref) ]]
			t2.noticeChanged:Fire(t2.totalNotices)

			for k2, v in pairs(t2.childIconsDict) do
				local v1 = v10.getIconByUID(k2)

				v1.noticeChanged:Fire(v1.totalNotices)

				if not p13 and v1.isSelected then
					for k22, v3 in pairs(v1.childIconsDict) do
						v1:deselect("HideParentFeature", t2)
					end
				end
			end
		end)
		t2.selected:Connect(function() --[[ Line: 428 | Upvalues: t2 (copy), StarterGui (ref) ]]
			if not (#t2.dropdownIcons > 0) then
				return
			end

			if StarterGui:GetCore("ChatActive") and t2.alignment ~= "Right" then
				t2.chatWasPreviouslyActive = true
				StarterGui:SetCore("ChatActive", false)
			end

			if not StarterGui:GetCoreGuiEnabled("PlayerList") or t2.alignment == "Left" then
				return
			end

			t2.playerlistWasPreviouslyActive = true
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
		end)
		t2.deselected:Connect(function() --[[ Line: 441 | Upvalues: t2 (copy), StarterGui (ref) ]]
			if t2.chatWasPreviouslyActive then
				t2.chatWasPreviouslyActive = nil
				StarterGui:SetCore("ChatActive", true)
			end

			if not t2.playerlistWasPreviouslyActive then
				return
			end

			t2.playerlistWasPreviouslyActive = nil
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
		end)
		task.delay(0.1, function() --[[ Line: 455 | Upvalues: t2 (copy) ]]
			if t2.activeState ~= "Deselected" then
				return
			end

			t2.stateChanged:Fire("Deselected")
			t2:refresh()
		end)
		v10.iconAdded:Fire(t2)

		return t2
	end
	function v10.setName(p13, p23) --[[ setName | Line: 471 ]]
		p13.widget.Name = p23
		p13.name = p23

		return p13
	end
	function v10.setState(p13, p23, p33, p43) --[[ setState | Line: 477 | Upvalues: v6 (copy), v14 (copy) ]]
		if not p23 then
			p23 = if p13.isSelected then "Selected" else "Deselected"
		end

		local v2 = v6.formatStateName(p23)

		if p13.activeState == v2 then
			return
		end

		local isSelected = p13.isSelected

		p13.activeState = v2

		if v2 == "Deselected" then
			p13.isSelected = false

			if isSelected then
				p13.toggled:Fire(false, p33, p43)
				p13.deselected:Fire(p33, p43)
			end

			p13:_setToggleItemsVisible(false, p33, p43)
		elseif v2 == "Selected" then
			p13.isSelected = true

			if not isSelected then
				p13.toggled:Fire(true, p33, p43)
				p13.selected:Fire(p33, p43)
				v14:Fire(p13, p33, p43)
			end

			p13:_setToggleItemsVisible(true, p33, p43)
		end

		p13.stateChanged:Fire(v2, p33, p43)
	end
	function v10.getInstance(p13, p23) --[[ getInstance | Line: 510 | Upvalues: v7 (copy) ]]
		local v1 = p13.cachedNamesToInstances[p23]

		if v1 then
			return v1
		end

		local function cacheInstance(p1, p23) --[[ cacheInstance | Line: 518 | Upvalues: p13 (copy) ]]
			if p13.cachedInstances[p23] then
				return
			end

			local v1 = p23:GetAttribute("Collective")
			local v2 = if v1 then p13.cachedCollectives[v1] else v1

			if v2 then
				table.insert(v2, p23)
			end

			p13.cachedNamesToInstances[p1] = p23
			p13.cachedInstances[p23] = true
			p23.Destroying:Once(function() --[[ Line: 528 | Upvalues: p13 (ref), p1 (copy), p23 (copy) ]]
				p13.cachedNamesToInstances[p1] = nil
				p13.cachedInstances[p23] = nil
			end)
		end

		local widget = p13.widget

		cacheInstance("Widget", widget)

		if p23 == "Widget" then
			return widget
		end

		local v2 = nil

		local function v3(p1) --[[ scanChildren | Line: 541 | Upvalues: p13 (copy), v7 (ref), v3 (copy), cacheInstance (copy), p23 (copy), v2 (ref) ]]
			for k2, v in pairs(p1:GetChildren()) do
				local v1 = v:GetAttribute("WidgetUID")

				if not v1 or v1 == p13.UID then
					local v22 = v7.getRealInstance(v)

					if v22 then
						v = v22
					end

					v3(v)

					if v:IsA("GuiBase") or (v:IsA("UIBase") or v:IsA("ValueBase")) then
						local v32 = v.Name

						cacheInstance(v32, v)

						if v32 == p23 then
							v2 = v
						end
					end
				end
			end
		end

		v3(widget)

		return v2
	end
	function v10.getCollective(p13, p23) --[[ getCollective | Line: 570 ]]
		local v1 = p13.cachedCollectives[p23]

		if v1 then
			return v1
		end

		local t2 = {}

		for k2, v in pairs(p13.cachedInstances) do
			if k2:GetAttribute("Collective") == p23 then
				table.insert(t2, k2)
			end
		end

		p13.cachedCollectives[p23] = t2

		return t2
	end
	function v10.getInstanceOrCollective(p13, p23) --[[ getInstanceOrCollective | Line: 591 ]]
		local t2 = {}
		local v1 = p13:getInstance(p23)

		if v1 then
			table.insert(t2, v1)
		end

		if #t2 == 0 then
			t2 = p13:getCollective(p23)
		end

		return t2
	end
	function v10.getStateGroup(p13, p23) --[[ getStateGroup | Line: 605 ]]
		local v1 = if p23 then p23 else p13.activeState
		local v2 = p13.appearance[v1]

		if not v2 then
			v2 = {}
			p13.appearance[v1] = v2
		end

		return v2
	end
	function v10.refreshAppearance(p13, p23, p33) --[[ refreshAppearance | Line: 615 | Upvalues: v7 (copy) ]]
		v7.refresh(p13, p23, p33)

		return p13
	end
	function v10.refresh(p13) --[[ refresh | Line: 620 ]]
		p13:refreshAppearance(p13.widget)
		p13.updateSize:Fire()

		return p13
	end
	function v10.updateParent(p13) --[[ updateParent | Line: 626 | Upvalues: v10 (copy) ]]
		local v1 = v10.getIconByUID(p13.parentIconUID)

		if not v1 then
			return
		end

		v1.updateSize:Fire()
	end
	function v10.setBehaviour(p13, p23, p33, p43, p53) --[[ setBehaviour | Line: 633 ]]
		p13.customBehaviours[p23 .. "-" .. p33] = p43

		if not p53 then
			return
		end

		for k2, v in pairs((p13:getInstanceOrCollective(p23))) do
			p13:refreshAppearance(v, p33)
		end
	end
	function v10.modifyTheme(p13, p23, p33) --[[ modifyTheme | Line: 646 | Upvalues: v7 (copy) ]]
		return p13, v7.modify(p13, p23, p33)
	end
	function v10.modifyChildTheme(p13, p23, p33) --[[ modifyChildTheme | Line: 651 | Upvalues: v10 (copy) ]]
		p13.childModifications = p23
		p13.childModificationsUID = p33

		for k2, v in pairs(p13.childIconsDict) do
			v10.getIconByUID(k2):modifyTheme(p23, p33)
		end

		p13.childThemeModified:Fire()

		return p13
	end
	function v10.removeModification(p13, p23) --[[ removeModification | Line: 664 | Upvalues: v7 (copy) ]]
		v7.remove(p13, p23)

		return p13
	end
	function v10.removeModificationWith(p13, p23, p33, p43) --[[ removeModificationWith | Line: 669 | Upvalues: v7 (copy) ]]
		v7.removeWith(p13, p23, p33, p43)

		return p13
	end
	function v10.setTheme(p13, p23) --[[ setTheme | Line: 674 | Upvalues: v7 (copy) ]]
		v7.set(p13, p23)

		return p13
	end
	function v10.setEnabled(p13, p23) --[[ setEnabled | Line: 679 ]]
		p13.isEnabled = p23
		p13.enabled = p13.isEnabled
		p13.widget.Visible = p23
		p13:updateParent()

		return p13
	end
	function v10.select(p13, p23, p33) --[[ select | Line: 687 ]]
		p13:setState("Selected", p23, p33)

		return p13
	end
	function v10.deselect(p13, p23, p33) --[[ deselect | Line: 692 ]]
		p13:setState("Deselected", p23, p33)

		return p13
	end
	function v10.notify(p13, p23, p33) --[[ notify | Line: 697 | Upvalues: v15 (copy), v10 (copy) ]]
		if not p13.notice then
			p13.notice = require(v15.Notice)(p13, v10)
		end

		p13.noticeStarted:Fire(p23, p33)

		return p13
	end
	function v10.clearNotices(p13) --[[ clearNotices | Line: 711 ]]
		p13.endNotices:Fire()

		return p13
	end
	function v10.disableOverlay(p13, p23) --[[ disableOverlay | Line: 716 ]]
		p13.overlayDisabled = p23

		return p13
	end
	v10.disableStateOverlay = v10.disableOverlay
	function v10.setImage(p13, p23, p33) --[[ setImage | Line: 722 | Upvalues: ContentProvider (copy) ]]
		p13:modifyTheme({ "IconImage", "Image", p23, p33 })
		task.spawn(function() --[[ Line: 726 | Upvalues: p23 (copy), ContentProvider (ref) ]]
			local v2 = if tonumber(p23) then ("rbxassetid://%*"):format(p23) else p23

			if ContentProvider:GetAssetFetchStatus(v2) == Enum.AssetFetchStatus.Success then
				return
			end

			pcall(ContentProvider.PreloadAsync, ContentProvider, { v2 })
		end)

		return p13
	end
	function v10.setLabel(p13, p23, p33) --[[ setLabel | Line: 738 ]]
		p13:modifyTheme({ "IconLabel", "Text", p23, p33 })

		return p13
	end
	function v10.setOrder(p13, p23, p33) --[[ setOrder | Line: 743 ]]
		local v1 = p23 * 100

		p13:modifyTheme({ "IconSpot", "LayoutOrder", v1, p33 })
		p13:modifyTheme({ "Widget", "LayoutOrder", v1, p33 })

		return p13
	end
	function v10.setCornerRadius(p13, p23, p33) --[[ setCornerRadius | Line: 752 ]]
		p13:modifyTheme({ "IconCorners", "CornerRadius", p23, p33 })

		return p13
	end
	function v10.align(p13, p23, p33) --[[ align | Line: 757 | Upvalues: v10 (copy) ]]
		local v1 = tostring(p23):lower()

		if v1 == "mid" or v1 == "centre" then
			v1 = "center"
		end

		if v1 ~= "left" and (v1 ~= "center" and v1 ~= "right") then
			v1 = "left"
		end

		local v2 = v1 == "center" and v10.container.TopbarCentered or v10.container.TopbarStandard
		local v3 = string.upper((string.sub(v1, 1, 1))) .. string.sub(v1, 2)

		if not p33 then
			p13.originalAlignment = v3
		end

		local joinedFrame = p13.joinedFrame
		local v4 = v2.Holders[v3]

		p13.screenGui = v2
		p13.alignmentHolder = v4

		if not p13.isDestroyed then
			p13.widget.Parent = joinedFrame or v4
		end

		p13.alignment = v3
		p13.alignmentChanged:Fire(v3)
		v10.iconChanged:Fire(p13)

		return p13
	end
	v10.setAlignment = v10.align
	function v10.setLeft(p13) --[[ setLeft | Line: 786 ]]
		p13:setAlignment("Left")

		return p13
	end
	function v10.setMid(p13) --[[ setMid | Line: 791 ]]
		p13:setAlignment("Center")

		return p13
	end
	function v10.setRight(p13) --[[ setRight | Line: 796 ]]
		p13:setAlignment("Right")

		return p13
	end
	function v10.setWidth(p13, p23, p33) --[[ setWidth | Line: 801 ]]
		p13:modifyTheme({ "Widget", "DesiredWidth", p23, p33 })

		return p13
	end
	function v10.setImageScale(p13, p23, p33) --[[ setImageScale | Line: 809 ]]
		p13:modifyTheme({ "IconImageScale", "Value", p23, p33 })

		return p13
	end
	function v10.setImageRatio(p13, p23, p33) --[[ setImageRatio | Line: 814 ]]
		p13:modifyTheme({ "IconImageRatio", "AspectRatio", p23, p33 })

		return p13
	end
	function v10.setTextSize(p13, p23, p33) --[[ setTextSize | Line: 819 ]]
		p13:modifyTheme({ "IconLabel", "TextSize", p23, p33 })

		return p13
	end
	function v10.setTextFont(p13, p23, p33, p43, p53) --[[ setTextFont | Line: 824 ]]
		local v1 = if p33 then p33 else Enum.FontWeight.Regular
		local v2 = if p43 then p43 else Enum.FontStyle.Normal
		local v3 = nil
		local v4 = typeof(p23)
		local v5, v6

		if v4 == "number" then
			v3, v5, v6 = Font.fromId(p23, v1, v2), v1, v2
		elseif v4 == "EnumItem" then
			v3, v5, v6 = Font.fromEnum(p23), v1, v2
		elseif v4 == "string" and not p23:match("rbxasset") then
			v3, v5, v6 = Font.fromName(p23, v1, v2), v1, v2
		else
			v5 = v1
			v6 = v2
		end

		if not v3 then
			v3 = Font.new(p23, v5, v6)
		end

		p13:modifyTheme({ "IconLabel", "FontFace", v3, p53 })

		return p13
	end
	function v10.bindToggleItem(p13, p23) --[[ bindToggleItem | Line: 845 ]]
		if not (p23:IsA("GuiObject") or p23:IsA("LayerCollector")) then
			error("Toggle item must be a GuiObject or LayerCollector!")
		end

		p13.toggleItems[p23] = true
		p13:_updateSelectionInstances()

		return p13
	end
	function v10.unbindToggleItem(p13, p23) --[[ unbindToggleItem | Line: 854 ]]
		p13.toggleItems[p23] = nil
		p13:_updateSelectionInstances()

		return p13
	end
	function v10._updateSelectionInstances(p13) --[[ _updateSelectionInstances | Line: 860 ]]
		for k2, v in pairs(p13.toggleItems) do
			local t2 = {}

			for k22, v3 in pairs(k2:GetDescendants()) do
				if (v3:IsA("TextButton") or v3:IsA("ImageButton")) and v3.Active then
					table.insert(t2, v3)
				end
			end

			p13.toggleItems[k2] = t2
		end
	end
	function v10._setToggleItemsVisible(p13, p23, p33, p43) --[[ _setToggleItemsVisible | Line: 874 ]]
		for k2, v in pairs(p13.toggleItems) do
			if not p43 or (p43 == p13 or p43.toggleItems[k2] == nil) then
				k2[if k2:IsA("LayerCollector") then "Enabled" else "Visible"] = p23
			end
		end
	end
	function v10.bindEvent(p13, p23, p33) --[[ bindEvent | Line: 886 ]]
		local v1 = p13[p23]

		assert(if v1 then if typeof(v1) == "table" then v1.Connect else false else v1, "argument[1] must be a valid topbarplus icon event name!")
		assert(if typeof(p33) == "function" then true else false, "argument[2] must be a function!")
		p13.bindedEvents[p23] = v1:Connect(function(...) --[[ Line: 890 | Upvalues: p33 (copy), p13 (copy) ]]
			p33(p13, ...)
		end)

		return p13
	end
	function v10.unbindEvent(p13, p23) --[[ unbindEvent | Line: 896 ]]
		local v1 = p13.bindedEvents[p23]

		if v1 then
			v1:Disconnect()
			p13.bindedEvents[p23] = nil
		end

		return p13
	end
	function v10.bindToggleKey(p13, p23) --[[ bindToggleKey | Line: 905 ]]
		assert(if typeof(p23) == "EnumItem" then true else false, "argument[1] must be a KeyCode EnumItem!")
		p13.bindedToggleKeys[p23] = true
		p13.toggleKeyAdded:Fire(p23)
		p13:setCaption("_hotkey_")

		return p13
	end
	function v10.unbindToggleKey(p13, p23) --[[ unbindToggleKey | Line: 913 ]]
		assert(if typeof(p23) == "EnumItem" then true else false, "argument[1] must be a KeyCode EnumItem!")
		p13.bindedToggleKeys[p23] = nil

		return p13
	end
	function v10.call(p13, p23, ...) --[[ call | Line: 919 ]]
		local v1 = table.pack(...)

		task.spawn(function() --[[ Line: 921 | Upvalues: p23 (copy), p13 (copy), v1 (copy) ]]
			p23(p13, table.unpack(v1))
		end)

		return p13
	end
	function v10.addToJanitor(p13, p23, p33, p43) --[[ addToJanitor | Line: 927 ]]
		p13.janitor:add(p23, p33, p43)

		return p13
	end
	function v10.lock(p13) --[[ lock | Line: 932 ]]
		p13:getInstance("ClickRegion").Visible = false
		p13.locked = true

		return p13
	end
	function v10.unlock(p13) --[[ unlock | Line: 940 ]]
		p13:getInstance("ClickRegion").Visible = true
		p13.locked = false

		return p13
	end
	function v10.debounce(p13, p23) --[[ debounce | Line: 947 ]]
		p13:lock()
		task.wait(p23)
		p13:unlock()

		return p13
	end
	function v10.autoDeselect(p13, p23) --[[ autoDeselect | Line: 954 ]]
		if p23 == nil then
			p23 = true
		end

		p13.deselectWhenOtherIconSelected = p23

		return p13
	end
	function v10.oneClick(p13, p23) --[[ oneClick | Line: 964 ]]
		local singleClickJanitor = p13.singleClickJanitor

		singleClickJanitor:clean()

		if p23 or p23 == nil then
			singleClickJanitor:add(p13.selected:Connect(function() --[[ Line: 970 | Upvalues: p13 (copy) ]]
				p13:deselect("OneClick", p13)
			end))
		end

		p13.oneClickEnabled = true

		return p13
	end
	function v10.setCaption(p13, p23) --[[ setCaption | Line: 978 | Upvalues: v15 (copy) ]]
		if p23 == "_hotkey_" and p13.captionText then
			return p13
		end

		local captionJanitor = p13.captionJanitor

		p13.captionJanitor:clean()

		if p23 and p23 ~= "" then
			local v1 = captionJanitor:add(require(v15.Caption)(p13))

			v1:SetAttribute("CaptionText", p23)
			p13.caption = v1
			p13.captionText = p23
		else
			p13.caption = nil
			p13.captionText = nil
		end

		return p13
	end
	function v10.setCaptionHint(p13, p23) --[[ setCaptionHint | Line: 996 ]]
		assert(if typeof(p23) == "EnumItem" then true else false, "argument[1] must be a KeyCode EnumItem!")
		p13.fakeToggleKey = p23
		p13.fakeToggleKeyChanged:Fire(p23)
		p13:setCaption("_hotkey_")

		return p13
	end
	function v10.leave(p13) --[[ leave | Line: 1004 ]]
		p13.joinJanitor:clean()

		return p13
	end
	function v10.joinMenu(p13, p23) --[[ joinMenu | Line: 1010 | Upvalues: v6 (copy) ]]
		v6.joinFeature(p13, p23, p23.menuIcons, p23:getInstance("Menu"))
		p23.menuChildAdded:Fire(p13)

		return p13
	end
	function v10.setMenu(p13, p23) --[[ setMenu | Line: 1016 ]]
		p13.menuSet:Fire(p23)

		return p13
	end
	function v10.setFrozenMenu(p13, p23) --[[ setFrozenMenu | Line: 1021 ]]
		p13:freezeMenu(p23)
		p13:setMenu(p23)
	end
	function v10.freezeMenu(p13) --[[ freezeMenu | Line: 1026 ]]
		p13:select("FrozenMenu", p13)
		p13:bindEvent("deselected", function(p1) --[[ Line: 1030 | Upvalues: p13 (copy) ]]
			p1:select("FrozenMenu", p13)
		end)
		p13:modifyTheme({ "IconSpot", "Visible", false })
	end
	function v10.joinDropdown(p13, p23) --[[ joinDropdown | Line: 1036 | Upvalues: v6 (copy) ]]
		p23:getDropdown()
		v6.joinFeature(p13, p23, p23.dropdownIcons, p23:getInstance("DropdownScroller"))
		p23.dropdownChildAdded:Fire(p13)

		return p13
	end
	function v10.getDropdown(p13) --[[ getDropdown | Line: 1043 | Upvalues: v15 (copy) ]]
		local dropdown = p13.dropdown

		if not dropdown then
			local v1 = require(v15.Dropdown)(p13)

			p13.dropdown = v1
			p13:clipOutside(v1)
			dropdown = v1
		end

		return dropdown
	end
	function v10.setDropdown(p13, p23) --[[ setDropdown | Line: 1053 ]]
		p13:getDropdown()
		p13.dropdownSet:Fire(p23)

		return p13
	end
	function v10.clipOutside(p13, p23) --[[ clipOutside | Line: 1059 | Upvalues: v6 (copy) ]]
		local v1 = v6.clipOutside(p13, p23)

		p13:refreshAppearance(p23)

		return p13, v1
	end
	function v10.setIndicator(p13, p23) --[[ setIndicator | Line: 1070 | Upvalues: v15 (copy), v10 (copy) ]]
		if not p13.indicator then
			p13.indicator = p13.janitor:add(require(v15.Indicator)(p13, v10))
		end

		p13.indicatorSet:Fire(p23)
	end
	function v10.convertLabelToNumberSpinner(p13, p23, p33) --[[ convertLabelToNumberSpinner | Line: 1082 ]]
		task.defer(function() --[[ Line: 1083 | Upvalues: p13 (copy), p23 (copy), p33 (copy) ]]
			local v1 = p13:getInstance("IconLabel")

			v1.Transparency = 1
			p23.Parent = v1.Parent
			p23.Size = UDim2.fromScale(1, 1)
			p23.AnchorPoint = Vector2.new(0.5, 0.5)
			p23.Position = UDim2.new(0.5, 0, 0.5, 0)
			p23.TextXAlignment = Enum.TextXAlignment.Center
			p23.ClipsDescendants = false

			for i2, v in ipairs({ "FontFace", "BorderSizePixel", "BorderColor3", "Rotation", "TextStrokeTransparency", "TextStrokeColor3", "TextStrokeTransparency", "TextColor3" }) do
				p23[v] = v1[v]
				p13:addToJanitor(v1:GetPropertyChangedSignal(v):Connect(function() --[[ Line: 1106 | Upvalues: p23 (ref), v (copy), v1 (copy) ]]
					p23[v] = v1[v]
				end))
			end

			local function getSpinnerSizeAndDigitCount() --[[ getSpinnerSizeAndDigitCount | Line: 1113 | Upvalues: p23 (ref) ]]
				local sum2 = 0
				local count2 = 0

				for v1, v2 in p23.Frame:GetChildren() do
					local v3 = string.lower(v2.Name)

					if v3 == "digit" then
						sum2 = sum2 + v2.AbsoluteSize.X
						count2 = count2 + 1

						continue
					end

					if (v3 == "prefix" or (v3 == "suffix" or v3 == "comma")) and v2.Text ~= "" then
						sum2 = sum2 + v2.AbsoluteSize.X
						count2 = count2 + 1
					end
				end

				return sum2, count2
			end

			local function getLabelParentContainerXSize() --[[ getLabelParentContainerXSize | Line: 1131 | Upvalues: v1 (copy), p23 (ref) ]]
				local v12 = v1.Parent
				local v2 = if v12 then v12.Parent else v12

				if v2 == nil then
					return 0
				end

				if v2.IconImage.Visible == true then
					return p23.Frame.AbsoluteSize.X + v1.Parent.Parent.IconImage.AbsoluteSize.X
				end

				return v2.AbsoluteSize.X
			end

			local function getNumberSpinnerXSize() --[[ getNumberSpinnerXSize | Line: 1143 | Upvalues: p23 (ref) ]]
				return p23.Frame.AbsoluteSize.X
			end

			local function adjustSize() --[[ adjustSize | Line: 1147 | Upvalues: getSpinnerSizeAndDigitCount (copy), p13 (ref), p23 (ref), v1 (copy) ]]
				local v12, v2 = getSpinnerSizeAndDigitCount()

				if v2 < 18 then
					p13:setLabel(p23.Value)
				end

				local X = p23.Frame.AbsoluteSize.X

				while v12 < X and p13.isDestroyed ~= true do
					task.wait(0.05)

					if v2 > 0 and v2 < 8 then
						p23.TextSize = v1.TextSize

						break
					end

					local v3 = p23

					v3.TextSize = v3.TextSize + 1
					X = p23.Frame.AbsoluteSize.X

					local v4, v5 = getSpinnerSizeAndDigitCount()

					v12 = v4
					v2 = v5
				end

				local v6 = v1.Parent
				local v7 = if v6 then v6.Parent else v6
				local v8 = if v7 == nil then 0 elseif v7.IconImage.Visible == true then p23.Frame.AbsoluteSize.X + v1.Parent.Parent.IconImage.AbsoluteSize.X else v7.AbsoluteSize.X

				while v8 < v12 and p13.isDestroyed ~= true do
					task.wait(0.05)

					if v2 < 8 and v2 > 0 then
						p23.TextSize = v1.TextSize

						return
					end

					local v9 = p23

					v9.TextSize = v9.TextSize - 1

					local v10 = v1.Parent
					local v11 = if v10 then v10.Parent else v10

					v8 = if v11 == nil then 0 elseif v11.IconImage.Visible == true then p23.Frame.AbsoluteSize.X + v1.Parent.Parent.IconImage.AbsoluteSize.X else v11.AbsoluteSize.X

					local v122, v132 = getSpinnerSizeAndDigitCount()

					v12, v2 = v122, v132
				end
			end

			p13:addToJanitor(p23.Frame.ChildAdded:Connect(adjustSize))
			p13:addToJanitor(p23.Frame.ChildRemoved:Connect(adjustSize))
			p13:addToJanitor(p13.iconAdded:Connect(function() --[[ Line: 1185 | Upvalues: adjustSize (copy) ]]
				task.wait(1)
				adjustSize()
			end))
			p13:updateParent()
			p23.Name = "LabelSpinner"
			p23.Prefix = "$"
			p23.Commas = true
			p23.Decimals = 0
			p23.Duration = 0.25
			p23.Value = 10
			task.wait(0.2)

			if typeof(p33) ~= "function" then
				return
			end

			p33()
		end)

		return p13
	end
	function v10.destroy(p13) --[[ destroy | Line: 1212 | Upvalues: v10 (copy) ]]
		if p13.isDestroyed then
			return
		end

		p13:clearNotices()

		if p13.parentIconUID then
			p13:leave()
		end

		p13.isDestroyed = true
		p13.janitor:clean()
		v10.iconRemoved:Fire(p13)
	end
	v10.Destroy = v10.destroy

	return v10
end

Reference.addToReplicatedStorage()
v4 = require(v1.Packages.GoodSignal)
v5 = require(v1.Packages.Janitor)
v6 = require(v1.Utility)
v7 = require(v1.Features.Themes)
v8 = require(v1.Features.Gamepad)
v9 = require(v1.Features.Overflow)
v10 = {}
v10.__index = v10
v11 = Players.LocalPlayer
v12 = v1.Features.Themes
v13 = {}
v14 = v4.new()
v15 = v1.Elements
v16 = 0
v10.baseDisplayOrderChanged = v4.new()
v10.baseDisplayOrder = 10
v10.baseTheme = require(v12.Default)
v10.isOldTopbar = false
v10.iconsDictionary = v13
v10.insetHeightChanged = v4.new()
v10.container = require(v15.Container)(v10)
v10.topbarEnabled = true
v10.iconAdded = v4.new()
v10.iconRemoved = v4.new()
v10.iconChanged = v4.new()
function v10.getIcons() --[[ getIcons | Line: 105 | Upvalues: v10 (copy) ]]
	return v10.iconsDictionary
end
function v10.getIconByUID(p13) --[[ getIconByUID | Line: 109 | Upvalues: v10 (copy) ]]
	local v1 = v10.iconsDictionary[p13]

	if v1 then
		return v1
	end

	return nil
end
function v10.getIcon(p13) --[[ getIcon | Line: 117 | Upvalues: v10 (copy), v13 (copy) ]]
	local v1 = v10.getIconByUID(p13)

	if v1 then
		return v1
	end

	for k2, v in pairs(v13) do
		if v.name == p13 then
			return v
		end
	end

	return nil
end
function v10.setTopbarEnabled(p13, p23) --[[ setTopbarEnabled | Line: 130 | Upvalues: v10 (copy) ]]
	if typeof(p13) ~= "boolean" then
		p13 = v10.topbarEnabled
	end

	if not p23 then
		v10.topbarEnabled = p13
	end

	for k2, v in pairs(v10.container) do
		v.Enabled = p13
	end
end
function v10.modifyBaseTheme(p13) --[[ modifyBaseTheme | Line: 142 | Upvalues: v7 (copy), v10 (copy), v13 (copy) ]]
	for k2, v in pairs((v7.getModifications(p13))) do
		for k22, v3 in pairs(v10.baseTheme) do
			v7.merge(v3, v)
		end
	end

	for k2, v in pairs(v13) do
		v:setTheme(v10.baseTheme)
	end
end
function v10.setDisplayOrder(p13) --[[ setDisplayOrder | Line: 154 | Upvalues: v10 (copy) ]]
	v10.baseDisplayOrder = p13
	v10.baseDisplayOrderChanged:Fire(p13)
end
task.defer(v8.start, v10)
task.defer(v9.start, v10)
task.defer(function() --[[ Line: 164 | Upvalues: v11 (copy), v10 (copy), v1 (copy) ]]
	local PlayerGui = v11:WaitForChild("PlayerGui")

	for k2, v in pairs(v10.container) do
		v.Parent = PlayerGui
	end

	require(v1.Attribute)
end)
function v10.new() --[[ new | Line: 175 | Upvalues: v10 (copy), v5 (copy), v6 (copy), v13 (copy), v4 (copy), v1 (copy), v15 (copy), v16 (ref), UserInputService (copy), v14 (copy), StarterGui (copy) ]]
	local t2 = {}
	local v12 = v10

	setmetatable(t2, v12)

	local v2 = v5.new()

	t2.janitor = v2
	t2.themesJanitor = v2:add(v5.new())
	t2.singleClickJanitor = v2:add(v5.new())
	t2.captionJanitor = v2:add(v5.new())
	t2.joinJanitor = v2:add(v5.new())
	t2.menuJanitor = v2:add(v5.new())
	t2.dropdownJanitor = v2:add(v5.new())

	local v3 = v6.generateUID()

	v13[v3] = t2
	v2:add(function() --[[ Line: 192 | Upvalues: v13 (ref), v3 (copy) ]]
		v13[v3] = nil
	end)
	t2.selected = v2:add(v4.new())
	t2.deselected = v2:add(v4.new())
	t2.toggled = v2:add(v4.new())
	t2.viewingStarted = v2:add(v4.new())
	t2.viewingEnded = v2:add(v4.new())
	t2.stateChanged = v2:add(v4.new())
	t2.notified = v2:add(v4.new())
	t2.noticeStarted = v2:add(v4.new())
	t2.noticeChanged = v2:add(v4.new())
	t2.endNotices = v2:add(v4.new())
	t2.toggleKeyAdded = v2:add(v4.new())
	t2.fakeToggleKeyChanged = v2:add(v4.new())
	t2.alignmentChanged = v2:add(v4.new())
	t2.updateSize = v2:add(v4.new())
	t2.resizingComplete = v2:add(v4.new())
	t2.joinedParent = v2:add(v4.new())
	t2.menuSet = v2:add(v4.new())
	t2.dropdownSet = v2:add(v4.new())
	t2.updateMenu = v2:add(v4.new())
	t2.startMenuUpdate = v2:add(v4.new())
	t2.childThemeModified = v2:add(v4.new())
	t2.indicatorSet = v2:add(v4.new())
	t2.dropdownChildAdded = v2:add(v4.new())
	t2.menuChildAdded = v2:add(v4.new())
	t2.iconModule = v1
	t2.UID = v3
	t2.isEnabled = true
	t2.enabled = t2.isEnabled
	t2.isSelected = false
	t2.isViewing = false
	t2.joinedFrame = false
	t2.parentIconUID = false
	t2.deselectWhenOtherIconSelected = true
	t2.totalNotices = 0
	t2.activeState = "Deselected"
	t2.alignment = ""
	t2.originalAlignment = ""
	t2.appliedTheme = {}
	t2.appearance = {}
	t2.cachedInstances = {}
	t2.cachedNamesToInstances = {}
	t2.cachedCollectives = {}
	t2.bindedToggleKeys = {}
	t2.customBehaviours = {}
	t2.toggleItems = {}
	t2.bindedEvents = {}
	t2.notices = {}
	t2.menuIcons = {}
	t2.dropdownIcons = {}
	t2.childIconsDict = {}
	t2.creationTime = os.clock()
	t2.widget = v2:add(require(v15.Widget)(t2, v10))
	t2:setAlignment()
	v16 = v16 + 1

	local v42 = v16 * 0.01 + 1

	t2:setOrder(v42, "deselected")
	t2:setOrder(v42, "selected")
	t2:setTheme(v10.baseTheme)

	local v52 = t2:getInstance("ClickRegion")

	local function handleToggle() --[[ handleToggle | Line: 268 | Upvalues: t2 (copy) ]]
		if t2.locked then
			return
		end

		if t2.isSelected then
			t2:deselect("User", t2)
		else
			t2:select("User", t2)
		end
	end

	local v62 = false
	local v7 = false

	v52.MouseButton1Click:Connect(function() --[[ Line: 280 | Upvalues: v62 (ref), v7 (ref), t2 (copy) ]]
		if v62 then
			return
		end

		v7 = true
		task.delay(0.01, function() --[[ Line: 285 | Upvalues: v7 (ref) ]]
			v7 = false
		end)

		if t2.locked then
			return
		end

		if t2.isSelected then
			t2:deselect("User", t2)
		else
			t2:select("User", t2)
		end
	end)
	v52.TouchTap:Connect(function() --[[ Line: 290 | Upvalues: v7 (ref), v62 (ref), t2 (copy) ]]
		if v7 then
			return
		end

		v62 = true
		task.delay(0.01, function() --[[ Line: 297 | Upvalues: v62 (ref) ]]
			v62 = false
		end)

		if t2.locked then
			return
		end

		if t2.isSelected then
			t2:deselect("User", t2)
		else
			t2:select("User", t2)
		end
	end)
	v2:add(UserInputService.InputBegan:Connect(function(p13, p23) --[[ Line: 304 | Upvalues: t2 (copy) ]]
		if t2.locked then
			return
		end

		if not t2.bindedToggleKeys[p13.KeyCode] or p23 then
			return
		end

		if t2.locked then
			return
		end

		if t2.isSelected then
			t2:deselect("User", t2)

			return
		end

		t2:select("User", t2)
	end))

	local function viewingStarted(p13) --[[ viewingStarted | Line: 316 | Upvalues: t2 (copy) ]]
		if t2.locked then
			return
		end

		t2.isViewing = true
		t2.viewingStarted:Fire(true)

		if p13 then
			return
		end

		t2:setState("Viewing", "User", t2)
	end

	local function viewingEnded() --[[ viewingEnded | Line: 326 | Upvalues: t2 (copy) ]]
		if not t2.locked then
			t2.isViewing = false
			t2.viewingEnded:Fire(true)
			t2:setState(nil, "User", t2)
		end
	end

	t2.joinedParent:Connect(function() --[[ Line: 334 | Upvalues: t2 (copy) ]]
		if not t2.isViewing then
			return
		end

		if t2.locked then
			return
		end

		t2.isViewing = false
		t2.viewingEnded:Fire(true)
		t2:setState(nil, "User", t2)
	end)
	v52.MouseEnter:Connect(function() --[[ Line: 339 | Upvalues: UserInputService (ref), t2 (copy) ]]
		if t2.locked then
			return
		end

		t2.isViewing = true
		t2.viewingStarted:Fire(true)

		if not UserInputService.KeyboardEnabled then
			return
		end

		t2:setState("Viewing", "User", t2)
	end)

	local v8 = 0

	v2:add(UserInputService.TouchEnded:Connect(viewingEnded))
	v52.MouseLeave:Connect(viewingEnded)
	v52.SelectionGained:Connect(viewingStarted)
	v52.SelectionLost:Connect(viewingEnded)
	v52.MouseButton1Down:Connect(function() --[[ Line: 348 | Upvalues: t2 (copy), UserInputService (ref), v8 (ref) ]]
		if t2.locked or not UserInputService.TouchEnabled then
			return
		end

		v8 = v8 + 1

		local v1 = v8

		task.delay(0.2, function() --[[ Line: 352 | Upvalues: v1 (copy), v8 (ref), t2 (ref) ]]
			if v1 ~= v8 then
				return
			end

			if t2.locked then
				return
			end

			t2.isViewing = true
			t2.viewingStarted:Fire(true)
			t2:setState("Viewing", "User", t2)
		end)
	end)
	v52.MouseButton1Up:Connect(function() --[[ Line: 359 | Upvalues: v8 (ref) ]]
		v8 = v8 + 1
	end)

	local v9 = t2:getInstance("IconOverlay")

	t2.viewingStarted:Connect(function() --[[ Line: 365 | Upvalues: v9 (copy), t2 (copy) ]]
		v9.Visible = not t2.overlayDisabled
	end)
	t2.viewingEnded:Connect(function() --[[ Line: 368 | Upvalues: v9 (copy) ]]
		v9.Visible = false
	end)
	v2:add(v14:Connect(function(p13) --[[ Line: 373 | Upvalues: t2 (copy) ]]
		if p13 == t2 or not (t2.deselectWhenOtherIconSelected and p13.deselectWhenOtherIconSelected) then
			return
		end

		t2:deselect("AutoDeselect", p13)
	end))

	local v11 = string.split(debug.info(2, "s"), ".")
	local v122 = game
	local v132 = nil

	for k2, v in pairs(v11) do
		local v142 = v122:FindFirstChild(v)

		v122 = v142

		if v142 then
			if v142:IsA("ScreenGui") then
				v122 = v142
				v132 = v142

				continue
			end
		else
			break
		end
	end

	if v122 and (v132 and v132.ResetOnSpawn == true) then
		t2.originsScreenGui = v132
		v6.localPlayerRespawned(function() --[[ Line: 399 | Upvalues: t2 (copy) ]]
			t2:destroy()
		end)
	end

	t2.toggled:Connect(function(p13) --[[ Line: 405 | Upvalues: t2 (copy), v10 (ref) ]]
		t2.noticeChanged:Fire(t2.totalNotices)

		for k2, v in pairs(t2.childIconsDict) do
			local v1 = v10.getIconByUID(k2)

			v1.noticeChanged:Fire(v1.totalNotices)

			if not p13 and v1.isSelected then
				for k22, v3 in pairs(v1.childIconsDict) do
					v1:deselect("HideParentFeature", t2)
				end
			end
		end
	end)
	t2.selected:Connect(function() --[[ Line: 428 | Upvalues: t2 (copy), StarterGui (ref) ]]
		if not (#t2.dropdownIcons > 0) then
			return
		end

		if StarterGui:GetCore("ChatActive") and t2.alignment ~= "Right" then
			t2.chatWasPreviouslyActive = true
			StarterGui:SetCore("ChatActive", false)
		end

		if not StarterGui:GetCoreGuiEnabled("PlayerList") or t2.alignment == "Left" then
			return
		end

		t2.playerlistWasPreviouslyActive = true
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
	end)
	t2.deselected:Connect(function() --[[ Line: 441 | Upvalues: t2 (copy), StarterGui (ref) ]]
		if t2.chatWasPreviouslyActive then
			t2.chatWasPreviouslyActive = nil
			StarterGui:SetCore("ChatActive", true)
		end

		if not t2.playerlistWasPreviouslyActive then
			return
		end

		t2.playerlistWasPreviouslyActive = nil
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
	end)
	task.delay(0.1, function() --[[ Line: 455 | Upvalues: t2 (copy) ]]
		if t2.activeState ~= "Deselected" then
			return
		end

		t2.stateChanged:Fire("Deselected")
		t2:refresh()
	end)
	v10.iconAdded:Fire(t2)

	return t2
end
function v10.setName(p13, p23) --[[ setName | Line: 471 ]]
	p13.widget.Name = p23
	p13.name = p23

	return p13
end
function v10.setState(p13, p23, p33, p43) --[[ setState | Line: 477 | Upvalues: v6 (copy), v14 (copy) ]]
	if not p23 then
		p23 = if p13.isSelected then "Selected" else "Deselected"
	end

	local v2 = v6.formatStateName(p23)

	if p13.activeState == v2 then
		return
	end

	local isSelected = p13.isSelected

	p13.activeState = v2

	if v2 == "Deselected" then
		p13.isSelected = false

		if isSelected then
			p13.toggled:Fire(false, p33, p43)
			p13.deselected:Fire(p33, p43)
		end

		p13:_setToggleItemsVisible(false, p33, p43)
	elseif v2 == "Selected" then
		p13.isSelected = true

		if not isSelected then
			p13.toggled:Fire(true, p33, p43)
			p13.selected:Fire(p33, p43)
			v14:Fire(p13, p33, p43)
		end

		p13:_setToggleItemsVisible(true, p33, p43)
	end

	p13.stateChanged:Fire(v2, p33, p43)
end
function v10.getInstance(p13, p23) --[[ getInstance | Line: 510 | Upvalues: v7 (copy) ]]
	local v1 = p13.cachedNamesToInstances[p23]

	if v1 then
		return v1
	end

	local function cacheInstance(p1, p23) --[[ cacheInstance | Line: 518 | Upvalues: p13 (copy) ]]
		if p13.cachedInstances[p23] then
			return
		end

		local v1 = p23:GetAttribute("Collective")
		local v2 = if v1 then p13.cachedCollectives[v1] else v1

		if v2 then
			table.insert(v2, p23)
		end

		p13.cachedNamesToInstances[p1] = p23
		p13.cachedInstances[p23] = true
		p23.Destroying:Once(function() --[[ Line: 528 | Upvalues: p13 (ref), p1 (copy), p23 (copy) ]]
			p13.cachedNamesToInstances[p1] = nil
			p13.cachedInstances[p23] = nil
		end)
	end

	local widget = p13.widget

	cacheInstance("Widget", widget)

	if p23 == "Widget" then
		return widget
	end

	local v2 = nil

	local function v3(p1) --[[ scanChildren | Line: 541 | Upvalues: p13 (copy), v7 (ref), v3 (copy), cacheInstance (copy), p23 (copy), v2 (ref) ]]
		for k2, v in pairs(p1:GetChildren()) do
			local v1 = v:GetAttribute("WidgetUID")

			if not v1 or v1 == p13.UID then
				local v22 = v7.getRealInstance(v)

				if v22 then
					v = v22
				end

				v3(v)

				if v:IsA("GuiBase") or (v:IsA("UIBase") or v:IsA("ValueBase")) then
					local v32 = v.Name

					cacheInstance(v32, v)

					if v32 == p23 then
						v2 = v
					end
				end
			end
		end
	end

	v3(widget)

	return v2
end
function v10.getCollective(p13, p23) --[[ getCollective | Line: 570 ]]
	local v1 = p13.cachedCollectives[p23]

	if v1 then
		return v1
	end

	local t2 = {}

	for k2, v in pairs(p13.cachedInstances) do
		if k2:GetAttribute("Collective") == p23 then
			table.insert(t2, k2)
		end
	end

	p13.cachedCollectives[p23] = t2

	return t2
end
function v10.getInstanceOrCollective(p13, p23) --[[ getInstanceOrCollective | Line: 591 ]]
	local t2 = {}
	local v1 = p13:getInstance(p23)

	if v1 then
		table.insert(t2, v1)
	end

	if #t2 == 0 then
		t2 = p13:getCollective(p23)
	end

	return t2
end
function v10.getStateGroup(p13, p23) --[[ getStateGroup | Line: 605 ]]
	local v1 = if p23 then p23 else p13.activeState
	local v2 = p13.appearance[v1]

	if not v2 then
		v2 = {}
		p13.appearance[v1] = v2
	end

	return v2
end
function v10.refreshAppearance(p13, p23, p33) --[[ refreshAppearance | Line: 615 | Upvalues: v7 (copy) ]]
	v7.refresh(p13, p23, p33)

	return p13
end
function v10.refresh(p13) --[[ refresh | Line: 620 ]]
	p13:refreshAppearance(p13.widget)
	p13.updateSize:Fire()

	return p13
end
function v10.updateParent(p13) --[[ updateParent | Line: 626 | Upvalues: v10 (copy) ]]
	local v1 = v10.getIconByUID(p13.parentIconUID)

	if not v1 then
		return
	end

	v1.updateSize:Fire()
end
function v10.setBehaviour(p13, p23, p33, p43, p53) --[[ setBehaviour | Line: 633 ]]
	p13.customBehaviours[p23 .. "-" .. p33] = p43

	if not p53 then
		return
	end

	for k2, v in pairs((p13:getInstanceOrCollective(p23))) do
		p13:refreshAppearance(v, p33)
	end
end
function v10.modifyTheme(p13, p23, p33) --[[ modifyTheme | Line: 646 | Upvalues: v7 (copy) ]]
	return p13, v7.modify(p13, p23, p33)
end
function v10.modifyChildTheme(p13, p23, p33) --[[ modifyChildTheme | Line: 651 | Upvalues: v10 (copy) ]]
	p13.childModifications = p23
	p13.childModificationsUID = p33

	for k2, v in pairs(p13.childIconsDict) do
		v10.getIconByUID(k2):modifyTheme(p23, p33)
	end

	p13.childThemeModified:Fire()

	return p13
end
function v10.removeModification(p13, p23) --[[ removeModification | Line: 664 | Upvalues: v7 (copy) ]]
	v7.remove(p13, p23)

	return p13
end
function v10.removeModificationWith(p13, p23, p33, p43) --[[ removeModificationWith | Line: 669 | Upvalues: v7 (copy) ]]
	v7.removeWith(p13, p23, p33, p43)

	return p13
end
function v10.setTheme(p13, p23) --[[ setTheme | Line: 674 | Upvalues: v7 (copy) ]]
	v7.set(p13, p23)

	return p13
end
function v10.setEnabled(p13, p23) --[[ setEnabled | Line: 679 ]]
	p13.isEnabled = p23
	p13.enabled = p13.isEnabled
	p13.widget.Visible = p23
	p13:updateParent()

	return p13
end
function v10.select(p13, p23, p33) --[[ select | Line: 687 ]]
	p13:setState("Selected", p23, p33)

	return p13
end
function v10.deselect(p13, p23, p33) --[[ deselect | Line: 692 ]]
	p13:setState("Deselected", p23, p33)

	return p13
end
function v10.notify(p13, p23, p33) --[[ notify | Line: 697 | Upvalues: v15 (copy), v10 (copy) ]]
	if not p13.notice then
		p13.notice = require(v15.Notice)(p13, v10)
	end

	p13.noticeStarted:Fire(p23, p33)

	return p13
end
function v10.clearNotices(p13) --[[ clearNotices | Line: 711 ]]
	p13.endNotices:Fire()

	return p13
end
function v10.disableOverlay(p13, p23) --[[ disableOverlay | Line: 716 ]]
	p13.overlayDisabled = p23

	return p13
end
v10.disableStateOverlay = v10.disableOverlay
function v10.setImage(p13, p23, p33) --[[ setImage | Line: 722 | Upvalues: ContentProvider (copy) ]]
	p13:modifyTheme({ "IconImage", "Image", p23, p33 })
	task.spawn(function() --[[ Line: 726 | Upvalues: p23 (copy), ContentProvider (ref) ]]
		local v2 = if tonumber(p23) then ("rbxassetid://%*"):format(p23) else p23

		if ContentProvider:GetAssetFetchStatus(v2) == Enum.AssetFetchStatus.Success then
			return
		end

		pcall(ContentProvider.PreloadAsync, ContentProvider, { v2 })
	end)

	return p13
end
function v10.setLabel(p13, p23, p33) --[[ setLabel | Line: 738 ]]
	p13:modifyTheme({ "IconLabel", "Text", p23, p33 })

	return p13
end
function v10.setOrder(p13, p23, p33) --[[ setOrder | Line: 743 ]]
	local v1 = p23 * 100

	p13:modifyTheme({ "IconSpot", "LayoutOrder", v1, p33 })
	p13:modifyTheme({ "Widget", "LayoutOrder", v1, p33 })

	return p13
end
function v10.setCornerRadius(p13, p23, p33) --[[ setCornerRadius | Line: 752 ]]
	p13:modifyTheme({ "IconCorners", "CornerRadius", p23, p33 })

	return p13
end
function v10.align(p13, p23, p33) --[[ align | Line: 757 | Upvalues: v10 (copy) ]]
	local v1 = tostring(p23):lower()

	if v1 == "mid" or v1 == "centre" then
		v1 = "center"
	end

	if v1 ~= "left" and (v1 ~= "center" and v1 ~= "right") then
		v1 = "left"
	end

	local v2 = v1 == "center" and v10.container.TopbarCentered or v10.container.TopbarStandard
	local v3 = string.upper((string.sub(v1, 1, 1))) .. string.sub(v1, 2)

	if not p33 then
		p13.originalAlignment = v3
	end

	local joinedFrame = p13.joinedFrame
	local v4 = v2.Holders[v3]

	p13.screenGui = v2
	p13.alignmentHolder = v4

	if not p13.isDestroyed then
		p13.widget.Parent = joinedFrame or v4
	end

	p13.alignment = v3
	p13.alignmentChanged:Fire(v3)
	v10.iconChanged:Fire(p13)

	return p13
end
v10.setAlignment = v10.align
function v10.setLeft(p13) --[[ setLeft | Line: 786 ]]
	p13:setAlignment("Left")

	return p13
end
function v10.setMid(p13) --[[ setMid | Line: 791 ]]
	p13:setAlignment("Center")

	return p13
end
function v10.setRight(p13) --[[ setRight | Line: 796 ]]
	p13:setAlignment("Right")

	return p13
end
function v10.setWidth(p13, p23, p33) --[[ setWidth | Line: 801 ]]
	p13:modifyTheme({ "Widget", "DesiredWidth", p23, p33 })

	return p13
end
function v10.setImageScale(p13, p23, p33) --[[ setImageScale | Line: 809 ]]
	p13:modifyTheme({ "IconImageScale", "Value", p23, p33 })

	return p13
end
function v10.setImageRatio(p13, p23, p33) --[[ setImageRatio | Line: 814 ]]
	p13:modifyTheme({ "IconImageRatio", "AspectRatio", p23, p33 })

	return p13
end
function v10.setTextSize(p13, p23, p33) --[[ setTextSize | Line: 819 ]]
	p13:modifyTheme({ "IconLabel", "TextSize", p23, p33 })

	return p13
end
function v10.setTextFont(p13, p23, p33, p43, p53) --[[ setTextFont | Line: 824 ]]
	local v1 = if p33 then p33 else Enum.FontWeight.Regular
	local v2 = if p43 then p43 else Enum.FontStyle.Normal
	local v3 = nil
	local v4 = typeof(p23)
	local v5, v6

	if v4 == "number" then
		v3, v5, v6 = Font.fromId(p23, v1, v2), v1, v2
	elseif v4 == "EnumItem" then
		v3, v5, v6 = Font.fromEnum(p23), v1, v2
	elseif v4 == "string" and not p23:match("rbxasset") then
		v3, v5, v6 = Font.fromName(p23, v1, v2), v1, v2
	else
		v5 = v1
		v6 = v2
	end

	if not v3 then
		v3 = Font.new(p23, v5, v6)
	end

	p13:modifyTheme({ "IconLabel", "FontFace", v3, p53 })

	return p13
end
function v10.bindToggleItem(p13, p23) --[[ bindToggleItem | Line: 845 ]]
	if not (p23:IsA("GuiObject") or p23:IsA("LayerCollector")) then
		error("Toggle item must be a GuiObject or LayerCollector!")
	end

	p13.toggleItems[p23] = true
	p13:_updateSelectionInstances()

	return p13
end
function v10.unbindToggleItem(p13, p23) --[[ unbindToggleItem | Line: 854 ]]
	p13.toggleItems[p23] = nil
	p13:_updateSelectionInstances()

	return p13
end
function v10._updateSelectionInstances(p13) --[[ _updateSelectionInstances | Line: 860 ]]
	for k2, v in pairs(p13.toggleItems) do
		local t2 = {}

		for k22, v3 in pairs(k2:GetDescendants()) do
			if (v3:IsA("TextButton") or v3:IsA("ImageButton")) and v3.Active then
				table.insert(t2, v3)
			end
		end

		p13.toggleItems[k2] = t2
	end
end
function v10._setToggleItemsVisible(p13, p23, p33, p43) --[[ _setToggleItemsVisible | Line: 874 ]]
	for k2, v in pairs(p13.toggleItems) do
		if not p43 or (p43 == p13 or p43.toggleItems[k2] == nil) then
			k2[if k2:IsA("LayerCollector") then "Enabled" else "Visible"] = p23
		end
	end
end
function v10.bindEvent(p13, p23, p33) --[[ bindEvent | Line: 886 ]]
	local v1 = p13[p23]

	assert(if v1 then if typeof(v1) == "table" then v1.Connect else false else v1, "argument[1] must be a valid topbarplus icon event name!")
	assert(if typeof(p33) == "function" then true else false, "argument[2] must be a function!")
	p13.bindedEvents[p23] = v1:Connect(function(...) --[[ Line: 890 | Upvalues: p33 (copy), p13 (copy) ]]
		p33(p13, ...)
	end)

	return p13
end
function v10.unbindEvent(p13, p23) --[[ unbindEvent | Line: 896 ]]
	local v1 = p13.bindedEvents[p23]

	if v1 then
		v1:Disconnect()
		p13.bindedEvents[p23] = nil
	end

	return p13
end
function v10.bindToggleKey(p13, p23) --[[ bindToggleKey | Line: 905 ]]
	assert(if typeof(p23) == "EnumItem" then true else false, "argument[1] must be a KeyCode EnumItem!")
	p13.bindedToggleKeys[p23] = true
	p13.toggleKeyAdded:Fire(p23)
	p13:setCaption("_hotkey_")

	return p13
end
function v10.unbindToggleKey(p13, p23) --[[ unbindToggleKey | Line: 913 ]]
	assert(if typeof(p23) == "EnumItem" then true else false, "argument[1] must be a KeyCode EnumItem!")
	p13.bindedToggleKeys[p23] = nil

	return p13
end
function v10.call(p13, p23, ...) --[[ call | Line: 919 ]]
	local v1 = table.pack(...)

	task.spawn(function() --[[ Line: 921 | Upvalues: p23 (copy), p13 (copy), v1 (copy) ]]
		p23(p13, table.unpack(v1))
	end)

	return p13
end
function v10.addToJanitor(p13, p23, p33, p43) --[[ addToJanitor | Line: 927 ]]
	p13.janitor:add(p23, p33, p43)

	return p13
end
function v10.lock(p13) --[[ lock | Line: 932 ]]
	p13:getInstance("ClickRegion").Visible = false
	p13.locked = true

	return p13
end
function v10.unlock(p13) --[[ unlock | Line: 940 ]]
	p13:getInstance("ClickRegion").Visible = true
	p13.locked = false

	return p13
end
function v10.debounce(p13, p23) --[[ debounce | Line: 947 ]]
	p13:lock()
	task.wait(p23)
	p13:unlock()

	return p13
end
function v10.autoDeselect(p13, p23) --[[ autoDeselect | Line: 954 ]]
	if p23 == nil then
		p23 = true
	end

	p13.deselectWhenOtherIconSelected = p23

	return p13
end
function v10.oneClick(p13, p23) --[[ oneClick | Line: 964 ]]
	local singleClickJanitor = p13.singleClickJanitor

	singleClickJanitor:clean()

	if p23 or p23 == nil then
		singleClickJanitor:add(p13.selected:Connect(function() --[[ Line: 970 | Upvalues: p13 (copy) ]]
			p13:deselect("OneClick", p13)
		end))
	end

	p13.oneClickEnabled = true

	return p13
end
function v10.setCaption(p13, p23) --[[ setCaption | Line: 978 | Upvalues: v15 (copy) ]]
	if p23 == "_hotkey_" and p13.captionText then
		return p13
	end

	local captionJanitor = p13.captionJanitor

	p13.captionJanitor:clean()

	if p23 and p23 ~= "" then
		local v1 = captionJanitor:add(require(v15.Caption)(p13))

		v1:SetAttribute("CaptionText", p23)
		p13.caption = v1
		p13.captionText = p23
	else
		p13.caption = nil
		p13.captionText = nil
	end

	return p13
end
function v10.setCaptionHint(p13, p23) --[[ setCaptionHint | Line: 996 ]]
	assert(if typeof(p23) == "EnumItem" then true else false, "argument[1] must be a KeyCode EnumItem!")
	p13.fakeToggleKey = p23
	p13.fakeToggleKeyChanged:Fire(p23)
	p13:setCaption("_hotkey_")

	return p13
end
function v10.leave(p13) --[[ leave | Line: 1004 ]]
	p13.joinJanitor:clean()

	return p13
end
function v10.joinMenu(p13, p23) --[[ joinMenu | Line: 1010 | Upvalues: v6 (copy) ]]
	v6.joinFeature(p13, p23, p23.menuIcons, p23:getInstance("Menu"))
	p23.menuChildAdded:Fire(p13)

	return p13
end
function v10.setMenu(p13, p23) --[[ setMenu | Line: 1016 ]]
	p13.menuSet:Fire(p23)

	return p13
end
function v10.setFrozenMenu(p13, p23) --[[ setFrozenMenu | Line: 1021 ]]
	p13:freezeMenu(p23)
	p13:setMenu(p23)
end
function v10.freezeMenu(p13) --[[ freezeMenu | Line: 1026 ]]
	p13:select("FrozenMenu", p13)
	p13:bindEvent("deselected", function(p1) --[[ Line: 1030 | Upvalues: p13 (copy) ]]
		p1:select("FrozenMenu", p13)
	end)
	p13:modifyTheme({ "IconSpot", "Visible", false })
end
function v10.joinDropdown(p13, p23) --[[ joinDropdown | Line: 1036 | Upvalues: v6 (copy) ]]
	p23:getDropdown()
	v6.joinFeature(p13, p23, p23.dropdownIcons, p23:getInstance("DropdownScroller"))
	p23.dropdownChildAdded:Fire(p13)

	return p13
end
function v10.getDropdown(p13) --[[ getDropdown | Line: 1043 | Upvalues: v15 (copy) ]]
	local dropdown = p13.dropdown

	if not dropdown then
		local v1 = require(v15.Dropdown)(p13)

		p13.dropdown = v1
		p13:clipOutside(v1)
		dropdown = v1
	end

	return dropdown
end
function v10.setDropdown(p13, p23) --[[ setDropdown | Line: 1053 ]]
	p13:getDropdown()
	p13.dropdownSet:Fire(p23)

	return p13
end
function v10.clipOutside(p13, p23) --[[ clipOutside | Line: 1059 | Upvalues: v6 (copy) ]]
	local v1 = v6.clipOutside(p13, p23)

	p13:refreshAppearance(p23)

	return p13, v1
end
function v10.setIndicator(p13, p23) --[[ setIndicator | Line: 1070 | Upvalues: v15 (copy), v10 (copy) ]]
	if not p13.indicator then
		p13.indicator = p13.janitor:add(require(v15.Indicator)(p13, v10))
	end

	p13.indicatorSet:Fire(p23)
end
function v10.convertLabelToNumberSpinner(p13, p23, p33) --[[ convertLabelToNumberSpinner | Line: 1082 ]]
	task.defer(function() --[[ Line: 1083 | Upvalues: p13 (copy), p23 (copy), p33 (copy) ]]
		local v1 = p13:getInstance("IconLabel")

		v1.Transparency = 1
		p23.Parent = v1.Parent
		p23.Size = UDim2.fromScale(1, 1)
		p23.AnchorPoint = Vector2.new(0.5, 0.5)
		p23.Position = UDim2.new(0.5, 0, 0.5, 0)
		p23.TextXAlignment = Enum.TextXAlignment.Center
		p23.ClipsDescendants = false

		for i2, v in ipairs({ "FontFace", "BorderSizePixel", "BorderColor3", "Rotation", "TextStrokeTransparency", "TextStrokeColor3", "TextStrokeTransparency", "TextColor3" }) do
			p23[v] = v1[v]
			p13:addToJanitor(v1:GetPropertyChangedSignal(v):Connect(function() --[[ Line: 1106 | Upvalues: p23 (ref), v (copy), v1 (copy) ]]
				p23[v] = v1[v]
			end))
		end

		local function getSpinnerSizeAndDigitCount() --[[ getSpinnerSizeAndDigitCount | Line: 1113 | Upvalues: p23 (ref) ]]
			local sum2 = 0
			local count2 = 0

			for v1, v2 in p23.Frame:GetChildren() do
				local v3 = string.lower(v2.Name)

				if v3 == "digit" then
					sum2 = sum2 + v2.AbsoluteSize.X
					count2 = count2 + 1

					continue
				end

				if (v3 == "prefix" or (v3 == "suffix" or v3 == "comma")) and v2.Text ~= "" then
					sum2 = sum2 + v2.AbsoluteSize.X
					count2 = count2 + 1
				end
			end

			return sum2, count2
		end

		local function getLabelParentContainerXSize() --[[ getLabelParentContainerXSize | Line: 1131 | Upvalues: v1 (copy), p23 (ref) ]]
			local v12 = v1.Parent
			local v2 = if v12 then v12.Parent else v12

			if v2 == nil then
				return 0
			end

			if v2.IconImage.Visible == true then
				return p23.Frame.AbsoluteSize.X + v1.Parent.Parent.IconImage.AbsoluteSize.X
			end

			return v2.AbsoluteSize.X
		end

		local function getNumberSpinnerXSize() --[[ getNumberSpinnerXSize | Line: 1143 | Upvalues: p23 (ref) ]]
			return p23.Frame.AbsoluteSize.X
		end

		local function adjustSize() --[[ adjustSize | Line: 1147 | Upvalues: getSpinnerSizeAndDigitCount (copy), p13 (ref), p23 (ref), v1 (copy) ]]
			local v12, v2 = getSpinnerSizeAndDigitCount()

			if v2 < 18 then
				p13:setLabel(p23.Value)
			end

			local X = p23.Frame.AbsoluteSize.X

			while v12 < X and p13.isDestroyed ~= true do
				task.wait(0.05)

				if v2 > 0 and v2 < 8 then
					p23.TextSize = v1.TextSize

					break
				end

				local v3 = p23

				v3.TextSize = v3.TextSize + 1
				X = p23.Frame.AbsoluteSize.X

				local v4, v5 = getSpinnerSizeAndDigitCount()

				v12 = v4
				v2 = v5
			end

			local v6 = v1.Parent
			local v7 = if v6 then v6.Parent else v6
			local v8 = if v7 == nil then 0 elseif v7.IconImage.Visible == true then p23.Frame.AbsoluteSize.X + v1.Parent.Parent.IconImage.AbsoluteSize.X else v7.AbsoluteSize.X

			while v8 < v12 and p13.isDestroyed ~= true do
				task.wait(0.05)

				if v2 < 8 and v2 > 0 then
					p23.TextSize = v1.TextSize

					return
				end

				local v9 = p23

				v9.TextSize = v9.TextSize - 1

				local v10 = v1.Parent
				local v11 = if v10 then v10.Parent else v10

				v8 = if v11 == nil then 0 elseif v11.IconImage.Visible == true then p23.Frame.AbsoluteSize.X + v1.Parent.Parent.IconImage.AbsoluteSize.X else v11.AbsoluteSize.X

				local v122, v132 = getSpinnerSizeAndDigitCount()

				v12, v2 = v122, v132
			end
		end

		p13:addToJanitor(p23.Frame.ChildAdded:Connect(adjustSize))
		p13:addToJanitor(p23.Frame.ChildRemoved:Connect(adjustSize))
		p13:addToJanitor(p13.iconAdded:Connect(function() --[[ Line: 1185 | Upvalues: adjustSize (copy) ]]
			task.wait(1)
			adjustSize()
		end))
		p13:updateParent()
		p23.Name = "LabelSpinner"
		p23.Prefix = "$"
		p23.Commas = true
		p23.Decimals = 0
		p23.Duration = 0.25
		p23.Value = 10
		task.wait(0.2)

		if typeof(p33) ~= "function" then
			return
		end

		p33()
	end)

	return p13
end
function v10.destroy(p13) --[[ destroy | Line: 1212 | Upvalues: v10 (copy) ]]
	if p13.isDestroyed then
		return
	end

	p13:clearNotices()

	if p13.parentIconUID then
		p13:leave()
	end

	p13.isDestroyed = true
	p13.janitor:clean()
	v10.iconRemoved:Fire(p13)
end
v10.Destroy = v10.destroy

return v10