-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("LocalizationService")

local UserInputService = game:GetService("UserInputService")

game:GetService("RunService")
game:GetService("TextService")

local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local v1 = script
local Reference = require(v1.Reference)
local v2 = Reference.getObject()
local v3 = if v2 then v2.Value else v2

if v3 and v3 ~= v1 then
	return require(v3)
end

if not v2 then
	Reference.addToReplicatedStorage()
end

local GoodSignal = require(v1.Packages.GoodSignal)
local Janitor = require(v1.Packages.Janitor)
local Utility = require(v1.Utility)

require(v1.Attribute)

local Themes = require(v1.Features.Themes)
local Gamepad = require(v1.Features.Gamepad)
local Overflow = require(v1.Features.Overflow)
local t = {}

t.__index = t

local Themes2 = v1.Features.Themes
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local t2 = {}
local v4 = GoodSignal.new()
local Elements = v1.Elements
local v5 = 0

if GuiService.TopbarInset.Height == 0 then
	GuiService:GetPropertyChangedSignal("TopbarInset"):Wait()
end

t.baseDisplayOrderChanged = GoodSignal.new()
t.baseDisplayOrder = 10
t.baseTheme = require(Themes2.Default)
t.isOldTopbar = if GuiService.TopbarInset.Height == 36 then true else false
t.iconsDictionary = t2
t.container = require(Elements.Container)(t)
t.topbarEnabled = true
t.iconAdded = GoodSignal.new()
t.iconRemoved = GoodSignal.new()
t.iconChanged = GoodSignal.new()
function t.getIcons() --[[ getIcons | Line: 112 | Upvalues: t (copy) ]]
	return t.iconsDictionary
end
function t.getIconByUID(p1) --[[ getIconByUID | Line: 116 | Upvalues: t (copy) ]]
	local v1 = t.iconsDictionary[p1]

	if v1 then
		return v1
	end
end
function t.getIcon(p1) --[[ getIcon | Line: 123 | Upvalues: t (copy), t2 (copy) ]]
	local v1 = t.getIconByUID(p1)

	if v1 then
		return v1
	end

	for k, v in pairs(t2) do
		if v.name == p1 then
			return v
		end
	end
end
function t.setTopbarEnabled(p1, p2) --[[ setTopbarEnabled | Line: 135 | Upvalues: t (copy) ]]
	if typeof(p1) ~= "boolean" then
		p1 = t.topbarEnabled
	end

	if not p2 then
		t.topbarEnabled = p1
	end

	for k, v in pairs(t.container) do
		v.Enabled = p1
	end
end
function t.modifyBaseTheme(p1) --[[ modifyBaseTheme | Line: 147 | Upvalues: Themes (copy), t (copy), t2 (copy) ]]
	for k, v in pairs((Themes.getModifications(p1))) do
		for k2, v2 in pairs(t.baseTheme) do
			Themes.merge(v2, v)
		end
	end

	for k, v in pairs(t2) do
		v:setTheme(t.baseTheme)
	end
end
function t.setDisplayOrder(p1) --[[ setDisplayOrder | Line: 159 | Upvalues: t (copy) ]]
	t.baseDisplayOrder = p1
	t.baseDisplayOrderChanged:Fire(p1)
end
task.defer(Gamepad.start, t)
task.defer(Overflow.start, t)

for k, v in pairs(t.container) do
	v.Parent = PlayerGui
end

if t.isOldTopbar then
	t.modifyBaseTheme(require(Themes2.Classic))
end

function t.new() --[[ new | Line: 179 | Upvalues: t (copy), Janitor (copy), Utility (copy), t2 (copy), GoodSignal (copy), v1 (copy), Elements (copy), v5 (ref), UserInputService (copy), v4 (copy), StarterGui (copy) ]]
	local t3 = {}
	local v12 = t

	setmetatable(t3, v12)

	local v2 = Janitor.new()

	t3.janitor = v2
	t3.themesJanitor = v2:add(Janitor.new())
	t3.singleClickJanitor = v2:add(Janitor.new())
	t3.captionJanitor = v2:add(Janitor.new())
	t3.joinJanitor = v2:add(Janitor.new())
	t3.menuJanitor = v2:add(Janitor.new())
	t3.dropdownJanitor = v2:add(Janitor.new())

	local v3 = Utility.generateUID()

	t2[v3] = t3
	v2:add(function() --[[ Line: 196 | Upvalues: t2 (ref), v3 (copy) ]]
		t2[v3] = nil
	end)
	t3.selected = v2:add(GoodSignal.new())
	t3.deselected = v2:add(GoodSignal.new())
	t3.toggled = v2:add(GoodSignal.new())
	t3.viewingStarted = v2:add(GoodSignal.new())
	t3.viewingEnded = v2:add(GoodSignal.new())
	t3.stateChanged = v2:add(GoodSignal.new())
	t3.notified = v2:add(GoodSignal.new())
	t3.noticeStarted = v2:add(GoodSignal.new())
	t3.noticeChanged = v2:add(GoodSignal.new())
	t3.endNotices = v2:add(GoodSignal.new())
	t3.toggleKeyAdded = v2:add(GoodSignal.new())
	t3.fakeToggleKeyChanged = v2:add(GoodSignal.new())
	t3.alignmentChanged = v2:add(GoodSignal.new())
	t3.updateSize = v2:add(GoodSignal.new())
	t3.resizingComplete = v2:add(GoodSignal.new())
	t3.joinedParent = v2:add(GoodSignal.new())
	t3.menuSet = v2:add(GoodSignal.new())
	t3.dropdownSet = v2:add(GoodSignal.new())
	t3.updateMenu = v2:add(GoodSignal.new())
	t3.startMenuUpdate = v2:add(GoodSignal.new())
	t3.childThemeModified = v2:add(GoodSignal.new())
	t3.indicatorSet = v2:add(GoodSignal.new())
	t3.dropdownChildAdded = v2:add(GoodSignal.new())
	t3.menuChildAdded = v2:add(GoodSignal.new())
	t3.iconModule = v1
	t3.UID = v3
	t3.isEnabled = true
	t3.isSelected = false
	t3.isViewing = false
	t3.joinedFrame = false
	t3.parentIconUID = false
	t3.deselectWhenOtherIconSelected = true
	t3.totalNotices = 0
	t3.activeState = "Deselected"
	t3.alignment = ""
	t3.originalAlignment = ""
	t3.appliedTheme = {}
	t3.appearance = {}
	t3.cachedInstances = {}
	t3.cachedNamesToInstances = {}
	t3.cachedCollectives = {}
	t3.bindedToggleKeys = {}
	t3.customBehaviours = {}
	t3.toggleItems = {}
	t3.bindedEvents = {}
	t3.notices = {}
	t3.menuIcons = {}
	t3.dropdownIcons = {}
	t3.childIconsDict = {}
	t3.isOldTopbar = t.isOldTopbar
	t3.creationTime = os.clock()
	t3.widget = v2:add(require(Elements.Widget)(t3, t))
	t3:setAlignment()
	v5 = v5 + 1
	t3:setOrder(v5)
	t3:setTheme(t.baseTheme)

	local v42 = t3:getInstance("ClickRegion")

	local function handleToggle() --[[ handleToggle | Line: 271 | Upvalues: t3 (copy) ]]
		if t3.locked then
			return
		end

		if t3.isSelected then
			t3:deselect("User", t3)
		else
			t3:select("User", t3)
		end
	end

	local v52 = false
	local v6 = false

	v42.MouseButton1Click:Connect(function() --[[ Line: 283 | Upvalues: v52 (ref), v6 (ref), t3 (copy) ]]
		if v52 then
			return
		end

		v6 = true
		task.delay(0.01, function() --[[ Line: 288 | Upvalues: v6 (ref) ]]
			v6 = false
		end)

		if t3.locked then
			return
		end

		if t3.isSelected then
			t3:deselect("User", t3)
		else
			t3:select("User", t3)
		end
	end)
	v42.TouchTap:Connect(function() --[[ Line: 293 | Upvalues: v6 (ref), v52 (ref), t3 (copy) ]]
		if v6 then
			return
		end

		v52 = true
		task.delay(0.01, function() --[[ Line: 300 | Upvalues: v52 (ref) ]]
			v52 = false
		end)

		if t3.locked then
			return
		end

		if t3.isSelected then
			t3:deselect("User", t3)
		else
			t3:select("User", t3)
		end
	end)
	v2:add(UserInputService.InputBegan:Connect(function(p1, p2) --[[ Line: 307 | Upvalues: t3 (copy) ]]
		if t3.locked then
			return
		end

		if not t3.bindedToggleKeys[p1.KeyCode] or p2 then
			return
		end

		if t3.locked then
			return
		end

		if t3.isSelected then
			t3:deselect("User", t3)

			return
		end

		t3:select("User", t3)
	end))

	local function viewingStarted(p1) --[[ viewingStarted | Line: 319 | Upvalues: t3 (copy) ]]
		if t3.locked then
			return
		end

		t3.isViewing = true
		t3.viewingStarted:Fire(true)

		if p1 then
			return
		end

		t3:setState("Viewing", "User", t3)
	end

	local function viewingEnded() --[[ viewingEnded | Line: 329 | Upvalues: t3 (copy) ]]
		if not t3.locked then
			t3.isViewing = false
			t3.viewingEnded:Fire(true)
			t3:setState(nil, "User", t3)
		end
	end

	t3.joinedParent:Connect(function() --[[ Line: 337 | Upvalues: t3 (copy) ]]
		if not t3.isViewing then
			return
		end

		if t3.locked then
			return
		end

		t3.isViewing = false
		t3.viewingEnded:Fire(true)
		t3:setState(nil, "User", t3)
	end)
	v42.MouseEnter:Connect(function() --[[ Line: 342 | Upvalues: UserInputService (ref), t3 (copy) ]]
		if t3.locked then
			return
		end

		t3.isViewing = true
		t3.viewingStarted:Fire(true)

		if not UserInputService.KeyboardEnabled then
			return
		end

		t3:setState("Viewing", "User", t3)
	end)

	local v7 = 0

	v2:add(UserInputService.TouchEnded:Connect(viewingEnded))
	v42.MouseLeave:Connect(viewingEnded)
	v42.SelectionGained:Connect(viewingStarted)
	v42.SelectionLost:Connect(viewingEnded)
	v42.MouseButton1Down:Connect(function() --[[ Line: 351 | Upvalues: t3 (copy), UserInputService (ref), v7 (ref) ]]
		if t3.locked or not UserInputService.TouchEnabled then
			return
		end

		v7 = v7 + 1

		local v1 = v7

		task.delay(0.2, function() --[[ Line: 355 | Upvalues: v1 (copy), v7 (ref), t3 (ref) ]]
			if v1 ~= v7 then
				return
			end

			if t3.locked then
				return
			end

			t3.isViewing = true
			t3.viewingStarted:Fire(true)
			t3:setState("Viewing", "User", t3)
		end)
	end)
	v42.MouseButton1Up:Connect(function() --[[ Line: 362 | Upvalues: v7 (ref) ]]
		v7 = v7 + 1
	end)

	local v8 = t3:getInstance("IconOverlay")

	t3.viewingStarted:Connect(function() --[[ Line: 368 | Upvalues: v8 (copy), t3 (copy) ]]
		v8.Visible = not t3.overlayDisabled
	end)
	t3.viewingEnded:Connect(function() --[[ Line: 371 | Upvalues: v8 (copy) ]]
		v8.Visible = false
	end)
	v2:add(v4:Connect(function(p1) --[[ Line: 376 | Upvalues: t3 (copy) ]]
		if p1 == t3 or not (t3.deselectWhenOtherIconSelected and p1.deselectWhenOtherIconSelected) then
			return
		end

		t3:deselect("AutoDeselect", p1)
	end))

	local v10 = string.split(debug.info(2, "s"), ".")
	local v11 = game
	local v122 = nil

	for k, v in pairs(v10) do
		local v13 = v11:FindFirstChild(v)

		v11 = v13

		if v13 then
			if v13:IsA("ScreenGui") then
				v11 = v13
				v122 = v13

				continue
			end
		else
			break
		end
	end

	if v11 and (v122 and v122.ResetOnSpawn == true) then
		Utility.localPlayerRespawned(function() --[[ Line: 401 | Upvalues: t3 (copy) ]]
			t3:destroy()
		end)
	end

	t3:getInstance("NoticeLabel")
	t3.toggled:Connect(function(p1) --[[ Line: 408 | Upvalues: t3 (copy), t (ref) ]]
		t3.noticeChanged:Fire(t3.totalNotices)

		for k, v in pairs(t3.childIconsDict) do
			local v1 = t.getIconByUID(k)

			v1.noticeChanged:Fire(v1.totalNotices)

			if not p1 and v1.isSelected then
				for k2, v2 in pairs(v1.childIconsDict) do
					v1:deselect("HideParentFeature", t3)
				end
			end
		end
	end)
	t3.selected:Connect(function() --[[ Line: 431 | Upvalues: t3 (copy), StarterGui (ref) ]]
		if not (#t3.dropdownIcons > 0) then
			return
		end

		if StarterGui:GetCore("ChatActive") and t3.alignment ~= "Right" then
			t3.chatWasPreviouslyActive = true
			StarterGui:SetCore("ChatActive", false)
		end

		if not StarterGui:GetCoreGuiEnabled("PlayerList") or t3.alignment == "Left" then
			return
		end

		t3.playerlistWasPreviouslyActive = true
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
	end)
	t3.deselected:Connect(function() --[[ Line: 444 | Upvalues: t3 (copy), StarterGui (ref) ]]
		if t3.chatWasPreviouslyActive then
			t3.chatWasPreviouslyActive = nil
			StarterGui:SetCore("ChatActive", true)
		end

		if not t3.playerlistWasPreviouslyActive then
			return
		end

		t3.playerlistWasPreviouslyActive = nil
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
	end)
	task.delay(0.1, function() --[[ Line: 459 | Upvalues: t3 (copy) ]]
		if t3.activeState ~= "Deselected" then
			return
		end

		t3.stateChanged:Fire("Deselected")
		t3:refresh()
	end)
	t.iconAdded:Fire(t3)

	return t3
end
function t.setName(p1, p2) --[[ setName | Line: 475 ]]
	p1.widget.Name = p2
	p1.name = p2

	return p1
end
function t.setState(p1, p2, p3, p4) --[[ setState | Line: 481 | Upvalues: Utility (copy), v4 (copy) ]]
	if not p2 then
		p2 = if p1.isSelected then "Selected" else "Deselected"
	end

	local v2 = Utility.formatStateName(p2)

	if p1.activeState == v2 then
		return
	end

	local isSelected = p1.isSelected

	p1.activeState = v2

	if v2 == "Deselected" then
		p1.isSelected = false

		if isSelected then
			p1.toggled:Fire(false, p3, p4)
			p1.deselected:Fire(p3, p4)
		end

		p1:_setToggleItemsVisible(false, p3, p4)
	elseif v2 == "Selected" then
		p1.isSelected = true

		if not isSelected then
			p1.toggled:Fire(true, p3, p4)
			p1.selected:Fire(p3, p4)
			v4:Fire(p1, p3, p4)
		end

		p1:_setToggleItemsVisible(true, p3, p4)
	end

	p1.stateChanged:Fire(v2, p3, p4)
end
function t.getInstance(p1, p2) --[[ getInstance | Line: 514 | Upvalues: Themes (copy) ]]
	local v1 = p1.cachedNamesToInstances[p2]

	if v1 then
		return v1
	end

	local function cacheInstance(p12, p2) --[[ cacheInstance | Line: 522 | Upvalues: p1 (copy) ]]
		if p1.cachedInstances[p2] then
			return
		end

		local v1 = p2:GetAttribute("Collective")
		local v2 = if v1 then p1.cachedCollectives[v1] else v1

		if v2 then
			table.insert(v2, p2)
		end

		p1.cachedNamesToInstances[p12] = p2
		p1.cachedInstances[p2] = true
		p2.Destroying:Once(function() --[[ Line: 532 | Upvalues: p1 (ref), p12 (copy), p2 (copy) ]]
			p1.cachedNamesToInstances[p12] = nil
			p1.cachedInstances[p2] = nil
		end)
	end

	local widget = p1.widget

	cacheInstance("Widget", widget)

	if p2 == "Widget" then
		return widget
	end

	local v2 = nil

	local function v3(p12) --[[ scanChildren | Line: 545 | Upvalues: p1 (copy), Themes (ref), v3 (copy), cacheInstance (copy), p2 (copy), v2 (ref) ]]
		for k, v in pairs(p12:GetChildren()) do
			local v1 = v:GetAttribute("WidgetUID")

			if not v1 or v1 == p1.UID then
				local v22 = Themes.getRealInstance(v)

				if v22 then
					v = v22
				end

				v3(v)

				if v:IsA("GuiBase") or (v:IsA("UIBase") or v:IsA("ValueBase")) then
					local v32 = v.Name

					cacheInstance(v32, v)

					if v32 == p2 then
						v2 = v
					end
				end
			end
		end
	end

	v3(widget)

	return v2
end
function t.getCollective(p1, p2) --[[ getCollective | Line: 575 ]]
	local v1 = p1.cachedCollectives[p2]

	if v1 then
		return v1
	end

	local t = {}

	for k, v in pairs(p1.cachedInstances) do
		if k:GetAttribute("Collective") == p2 then
			table.insert(t, k)
		end
	end

	p1.cachedCollectives[p2] = t

	return t
end
function t.getInstanceOrCollective(p1, p2) --[[ getInstanceOrCollective | Line: 596 ]]
	local t = {}
	local v1 = p1:getInstance(p2)

	if v1 then
		table.insert(t, v1)
	end

	if #t == 0 then
		t = p1:getCollective(p2)
	end

	return t
end
function t.getStateGroup(p1, p2) --[[ getStateGroup | Line: 610 ]]
	local v1 = if p2 then p2 else p1.activeState
	local v2 = p1.appearance[v1]

	if not v2 then
		v2 = {}
		p1.appearance[v1] = v2
	end

	return v2
end
function t.refreshAppearance(p1, p2, p3) --[[ refreshAppearance | Line: 620 | Upvalues: Themes (copy) ]]
	Themes.refresh(p1, p2, p3)

	return p1
end
function t.refresh(p1) --[[ refresh | Line: 625 ]]
	p1:refreshAppearance(p1.widget)
	p1.updateSize:Fire()

	return p1
end
function t.updateParent(p1) --[[ updateParent | Line: 631 | Upvalues: t (copy) ]]
	local v1 = t.getIconByUID(p1.parentIconUID)

	if not v1 then
		return
	end

	v1.updateSize:Fire()
end
function t.setBehaviour(p1, p2, p3, p4, p5) --[[ setBehaviour | Line: 638 ]]
	p1.customBehaviours[p2 .. "-" .. p3] = p4

	if not p5 then
		return
	end

	for k, v in pairs((p1:getInstanceOrCollective(p2))) do
		p1:refreshAppearance(v, p3)
	end
end
function t.modifyTheme(p1, p2, p3) --[[ modifyTheme | Line: 651 | Upvalues: Themes (copy) ]]
	return p1, Themes.modify(p1, p2, p3)
end
function t.modifyChildTheme(p1, p2, p3) --[[ modifyChildTheme | Line: 656 | Upvalues: t (copy) ]]
	p1.childModifications = p2
	p1.childModificationsUID = p3

	for k, v in pairs(p1.childIconsDict) do
		t.getIconByUID(k):modifyTheme(p2, p3)
	end

	p1.childThemeModified:Fire()

	return p1
end
function t.removeModification(p1, p2) --[[ removeModification | Line: 669 | Upvalues: Themes (copy) ]]
	Themes.remove(p1, p2)

	return p1
end
function t.removeModificationWith(p1, p2, p3, p4) --[[ removeModificationWith | Line: 674 | Upvalues: Themes (copy) ]]
	Themes.removeWith(p1, p2, p3, p4)

	return p1
end
function t.setTheme(p1, p2) --[[ setTheme | Line: 679 | Upvalues: Themes (copy) ]]
	Themes.set(p1, p2)

	return p1
end
function t.setEnabled(p1, p2) --[[ setEnabled | Line: 684 ]]
	p1.isEnabled = p2
	p1.widget.Visible = p2
	p1:updateParent()

	return p1
end
function t.select(p1, p2, p3) --[[ select | Line: 691 ]]
	p1:setState("Selected", p2, p3)

	return p1
end
function t.deselect(p1, p2, p3) --[[ deselect | Line: 696 ]]
	p1:setState("Deselected", p2, p3)

	return p1
end
function t.notify(p1, p2, p3) --[[ notify | Line: 701 | Upvalues: Elements (copy), t (copy) ]]
	if not p1.notice then
		p1.notice = require(Elements.Notice)(p1, t)
	end

	p1.noticeStarted:Fire(p2, p3)

	return p1
end
function t.clearNotices(p1) --[[ clearNotices | Line: 715 ]]
	p1.endNotices:Fire()

	return p1
end
function t.disableOverlay(p1, p2) --[[ disableOverlay | Line: 720 ]]
	p1.overlayDisabled = p2

	return p1
end
t.disableStateOverlay = t.disableOverlay
function t.setImage(p1, p2, p3) --[[ setImage | Line: 726 ]]
	p1:modifyTheme({ "IconImage", "Image", p2, p3 })

	return p1
end
function t.setLabel(p1, p2, p3) --[[ setLabel | Line: 731 ]]
	p1:modifyTheme({ "IconLabel", "Text", p2, p3 })

	return p1
end
function t.setOrder(p1, p2, p3) --[[ setOrder | Line: 736 ]]
	p1:modifyTheme({ "Widget", "LayoutOrder", p2, p3 })

	return p1
end
function t.setCornerRadius(p1, p2, p3) --[[ setCornerRadius | Line: 741 ]]
	p1:modifyTheme({ "IconCorners", "CornerRadius", p2, p3 })

	return p1
end
function t.align(p1, p2, p3) --[[ align | Line: 746 | Upvalues: t (copy) ]]
	local v1 = tostring(p2):lower()

	if v1 == "mid" or v1 == "centre" then
		v1 = "center"
	end

	if v1 ~= "left" and (v1 ~= "center" and v1 ~= "right") then
		v1 = "left"
	end

	local v2 = v1 == "center" and t.container.TopbarCentered or t.container.TopbarStandard
	local v3 = string.upper((string.sub(v1, 1, 1))) .. string.sub(v1, 2)

	if not p3 then
		p1.originalAlignment = v3
	end

	local joinedFrame = p1.joinedFrame
	local v4 = v2.Holders[v3]

	p1.screenGui = v2
	p1.alignmentHolder = v4

	if not p1.isDestroyed then
		p1.widget.Parent = joinedFrame or v4
	end

	p1.alignment = v3
	p1.alignmentChanged:Fire(v3)
	t.iconChanged:Fire(p1)

	return p1
end
t.setAlignment = t.align
function t.setLeft(p1) --[[ setLeft | Line: 775 ]]
	p1:setAlignment("Left")

	return p1
end
function t.setMid(p1) --[[ setMid | Line: 780 ]]
	p1:setAlignment("Center")

	return p1
end
function t.setRight(p1) --[[ setRight | Line: 785 ]]
	p1:setAlignment("Right")

	return p1
end
function t.setWidth(p1, p2, p3) --[[ setWidth | Line: 790 ]]
	p1:modifyTheme({
		"Widget",
		"Size",
		UDim2.fromOffset(p2, p1.widget.Size.Y.Offset),
		p3
	})
	p1:modifyTheme({ "Widget", "DesiredWidth", p2, p3 })

	return p1
end
function t.setImageScale(p1, p2, p3) --[[ setImageScale | Line: 800 ]]
	p1:modifyTheme({ "IconImageScale", "Value", p2, p3 })

	return p1
end
function t.setImageRatio(p1, p2, p3) --[[ setImageRatio | Line: 805 ]]
	p1:modifyTheme({ "IconImageRatio", "AspectRatio", p2, p3 })

	return p1
end
function t.setTextSize(p1, p2, p3) --[[ setTextSize | Line: 810 ]]
	p1:modifyTheme({ "IconLabel", "TextSize", p2, p3 })

	return p1
end
function t.setTextFont(p1, p2, p3, p4, p5) --[[ setTextFont | Line: 815 ]]
	local v1 = if p3 then p3 else Enum.FontWeight.Regular
	local v2 = if p4 then p4 else Enum.FontStyle.Normal
	local v3 = nil
	local v4 = typeof(p2)
	local v5, v6

	if v4 == "number" then
		v3, v5, v6 = Font.fromId(p2, v1, v2), v1, v2
	elseif v4 == "EnumItem" then
		v3, v5, v6 = Font.fromEnum(p2), v1, v2
	elseif v4 == "string" and not p2:match("rbxasset") then
		v3, v5, v6 = Font.fromName(p2, v1, v2), v1, v2
	else
		v5 = v1
		v6 = v2
	end

	if not v3 then
		v3 = Font.new(p2, v5, v6)
	end

	p1:modifyTheme({ "IconLabel", "FontFace", v3, p5 })

	return p1
end
function t.bindToggleItem(p1, p2) --[[ bindToggleItem | Line: 836 ]]
	if not (p2:IsA("GuiObject") or p2:IsA("LayerCollector")) then
		error("Toggle item must be a GuiObject or LayerCollector!")
	end

	p1.toggleItems[p2] = true
	p1:_updateSelectionInstances()

	return p1
end
function t.unbindToggleItem(p1, p2) --[[ unbindToggleItem | Line: 845 ]]
	p1.toggleItems[p2] = nil
	p1:_updateSelectionInstances()

	return p1
end
function t._updateSelectionInstances(p1) --[[ _updateSelectionInstances | Line: 851 ]]
	for k, v in pairs(p1.toggleItems) do
		local t = {}

		for k2, v2 in pairs(k:GetDescendants()) do
			if (v2:IsA("TextButton") or v2:IsA("ImageButton")) and v2.Active then
				table.insert(t, v2)
			end
		end

		p1.toggleItems[k] = t
	end
end
function t._setToggleItemsVisible(p1, p2, p3, p4) --[[ _setToggleItemsVisible | Line: 865 ]]
	for k, v in pairs(p1.toggleItems) do
		if not p4 or (p4 == p1 or p4.toggleItems[k] == nil) then
			k[if k:IsA("LayerCollector") then "Enabled" else "Visible"] = p2
		end
	end
end
function t.bindEvent(p1, p2, p3) --[[ bindEvent | Line: 877 ]]
	local v1 = p1[p2]

	assert(if v1 then if typeof(v1) == "table" then v1.Connect else false else v1, "argument[1] must be a valid topbarplus icon event name!")
	assert(if typeof(p3) == "function" then true else false, "argument[2] must be a function!")
	p1.bindedEvents[p2] = v1:Connect(function(...) --[[ Line: 881 | Upvalues: p3 (copy), p1 (copy) ]]
		p3(p1, ...)
	end)

	return p1
end
function t.unbindEvent(p1, p2) --[[ unbindEvent | Line: 887 ]]
	local v1 = p1.bindedEvents[p2]

	if v1 then
		v1:Disconnect()
		p1.bindedEvents[p2] = nil
	end

	return p1
end
function t.bindToggleKey(p1, p2) --[[ bindToggleKey | Line: 896 ]]
	assert(if typeof(p2) == "EnumItem" then true else false, "argument[1] must be a KeyCode EnumItem!")
	p1.bindedToggleKeys[p2] = true
	p1.toggleKeyAdded:Fire(p2)
	p1:setCaption("_hotkey_")

	return p1
end
function t.unbindToggleKey(p1, p2) --[[ unbindToggleKey | Line: 904 ]]
	assert(if typeof(p2) == "EnumItem" then true else false, "argument[1] must be a KeyCode EnumItem!")
	p1.bindedToggleKeys[p2] = nil

	return p1
end
function t.call(p1, p2, ...) --[[ call | Line: 910 ]]
	local v1 = table.pack(...)

	task.spawn(function() --[[ Line: 912 | Upvalues: p2 (copy), p1 (copy), v1 (copy) ]]
		p2(p1, table.unpack(v1))
	end)

	return p1
end
function t.addToJanitor(p1, p2, p3, p4) --[[ addToJanitor | Line: 918 ]]
	p1.janitor:add(p2, p3, p4)

	return p1
end
function t.lock(p1) --[[ lock | Line: 923 ]]
	p1:getInstance("ClickRegion").Visible = false
	p1.locked = true

	return p1
end
function t.unlock(p1) --[[ unlock | Line: 931 ]]
	p1:getInstance("ClickRegion").Visible = true
	p1.locked = false

	return p1
end
function t.debounce(p1, p2) --[[ debounce | Line: 938 ]]
	p1:lock()
	task.wait(p2)
	p1:unlock()

	return p1
end
function t.autoDeselect(p1, p2) --[[ autoDeselect | Line: 945 ]]
	if p2 == nil then
		p2 = true
	end

	p1.deselectWhenOtherIconSelected = p2

	return p1
end
function t.oneClick(p1, p2) --[[ oneClick | Line: 955 ]]
	local singleClickJanitor = p1.singleClickJanitor

	singleClickJanitor:clean()

	if p2 or p2 == nil then
		singleClickJanitor:add(p1.selected:Connect(function() --[[ Line: 961 | Upvalues: p1 (copy) ]]
			p1:deselect("OneClick", p1)
		end))
	end

	p1.oneClickEnabled = true

	return p1
end
function t.setCaption(p1, p2) --[[ setCaption | Line: 969 | Upvalues: Elements (copy) ]]
	if p2 == "_hotkey_" and p1.captionText then
		return p1
	end

	local captionJanitor = p1.captionJanitor

	p1.captionJanitor:clean()

	if p2 and p2 ~= "" then
		local v1 = captionJanitor:add(require(Elements.Caption)(p1))

		v1:SetAttribute("CaptionText", p2)
		p1.caption = v1
		p1.captionText = p2
	else
		p1.caption = nil
		p1.captionText = nil
	end

	return p1
end
function t.setCaptionHint(p1, p2) --[[ setCaptionHint | Line: 987 ]]
	assert(if typeof(p2) == "EnumItem" then true else false, "argument[1] must be a KeyCode EnumItem!")
	p1.fakeToggleKey = p2
	p1.fakeToggleKeyChanged:Fire(p2)
	p1:setCaption("_hotkey_")

	return p1
end
function t.leave(p1) --[[ leave | Line: 995 ]]
	p1.joinJanitor:clean()

	return p1
end
function t.joinMenu(p1, p2) --[[ joinMenu | Line: 1001 | Upvalues: Utility (copy) ]]
	Utility.joinFeature(p1, p2, p2.menuIcons, p2:getInstance("Menu"))
	p2.menuChildAdded:Fire(p1)

	return p1
end
function t.setMenu(p1, p2) --[[ setMenu | Line: 1007 ]]
	p1.menuSet:Fire(p2)

	return p1
end
function t.setFrozenMenu(p1, p2) --[[ setFrozenMenu | Line: 1012 ]]
	p1:freezeMenu(p2)
	p1:setMenu(p2)
end
function t.freezeMenu(p1) --[[ freezeMenu | Line: 1017 ]]
	p1:select("FrozenMenu", p1)
	p1:bindEvent("deselected", function(p12) --[[ Line: 1021 | Upvalues: p1 (copy) ]]
		p12:select("FrozenMenu", p1)
	end)
	p1:modifyTheme({ "IconSpot", "Visible", false })
end
function t.joinDropdown(p1, p2) --[[ joinDropdown | Line: 1027 | Upvalues: Utility (copy) ]]
	p2:getDropdown()
	Utility.joinFeature(p1, p2, p2.dropdownIcons, p2:getInstance("DropdownScroller"))
	p2.dropdownChildAdded:Fire(p1)

	return p1
end
function t.getDropdown(p1) --[[ getDropdown | Line: 1034 | Upvalues: Elements (copy) ]]
	local dropdown = p1.dropdown

	if not dropdown then
		local v1 = require(Elements.Dropdown)(p1)

		p1.dropdown = v1
		p1:clipOutside(v1)
		dropdown = v1
	end

	return dropdown
end
function t.setDropdown(p1, p2) --[[ setDropdown | Line: 1044 ]]
	p1:getDropdown()
	p1.dropdownSet:Fire(p2)

	return p1
end
function t.clipOutside(p1, p2) --[[ clipOutside | Line: 1050 | Upvalues: Utility (copy) ]]
	local v1 = Utility.clipOutside(p1, p2)

	p1:refreshAppearance(p2)

	return p1, v1
end
function t.setIndicator(p1, p2) --[[ setIndicator | Line: 1061 | Upvalues: Elements (copy), t (copy) ]]
	if not p1.indicator then
		p1.indicator = p1.janitor:add(require(Elements.Indicator)(p1, t))
	end

	p1.indicatorSet:Fire(p2)
end
function t.destroy(p1) --[[ destroy | Line: 1076 | Upvalues: t (copy) ]]
	if p1.isDestroyed then
		return
	end

	p1:clearNotices()

	if p1.parentIconUID then
		p1:leave()
	end

	p1.isDestroyed = true
	p1.janitor:clean()
	t.iconRemoved:Fire(p1)
end
t.Destroy = t.destroy

return t