-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
local LocalPlayer = game:GetService("Players").LocalPlayer

function t.createStagger(p1, p2, p3) --[[ createStagger | Line: 13 ]]
	local v1 = false
	local v2 = false

	if not p1 or p1 == 0 then
		p1 = 0.01
	end

	local function v3(...) --[[ staggeredCallback | Line: 29 | Upvalues: v1 (ref), v2 (ref), p3 (copy), p1 (ref), p2 (copy), v3 (copy) ]]
		if v1 then
			v2 = true
		else
			local v12 = table.pack(...)

			v1 = true
			v2 = false
			task.spawn(function() --[[ Line: 37 | Upvalues: p3 (ref), p1 (ref), p2 (ref), v12 (copy) ]]
				if p3 then
					task.wait(p1)
				end

				p2(table.unpack(v12))
			end)
			task.delay(p1, function() --[[ Line: 43 | Upvalues: v1 (ref), v2 (ref), v3 (ref), v12 (copy) ]]
				v1 = false

				if not v2 then
					return
				end

				v3(table.unpack(v12))
			end)
		end
	end

	return v3
end
function t.round(p1) --[[ round | Line: 55 ]]
	return math.floor(p1 + 0.5)
end
function t.reverseTable(p1) --[[ reverseTable | Line: 60 ]]
	for i = 1, math.floor(#p1 / 2) do
		local v1 = #p1 - i + 1
		local v3 = p1[i]

		p1[i] = p1[v1]
		p1[v1] = v3
	end
end
function t.copyTable(p1) --[[ copyTable | Line: 67 | Upvalues: t (copy) ]]
	assert(type(p1) == "table", "First argument must be a table")

	local v2 = table.create(#p1)

	for k, v in pairs(p1) do
		if type(v) == "table" then
			v2[k] = t.copyTable(v)

			continue
		end

		v2[k] = v
	end

	return v2
end

local t2 = {
	"a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
	"l",
	"m",
	"n",
	"o",
	"p",
	"q",
	"r",
	"s",
	"t",
	"u",
	"v",
	"w",
	"x",
	"y",
	"z",
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"H",
	"I",
	"J",
	"K",
	"L",
	"M",
	"N",
	"O",
	"P",
	"Q",
	"R",
	"S",
	"T",
	"U",
	"V",
	"W",
	"X",
	"Y",
	"Z",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"0",
	"<",
	">",
	"?",
	"@",
	"{",
	"}",
	"[",
	"]",
	"!",
	"(",
	")",
	"=",
	"+",
	"~",
	"#"
}

function t.generateUID(p1) --[[ generateUID | Line: 82 | Upvalues: t2 (copy) ]]
	local v1 = t2
	local v2 = #v1
	local v3 = ""

	for i = 1, p1 or 8 do
		v3 = v3 .. v1[math.random(1, v2)]
	end

	return v3
end

local t3 = {}

function t.setVisible(p1, p2, p3) --[[ setVisible | Line: 95 | Upvalues: t3 (copy) ]]
	local v1 = t3[p1]

	if not v1 then
		v1 = {}
		t3[p1] = v1
		p1.Destroying:Once(function() --[[ Line: 104 | Upvalues: t3 (ref), p1 (copy) ]]
			t3[p1] = nil
		end)
	end

	if p2 then
		v1[p3] = nil
	else
		v1[p3] = true
	end

	local v2

	if p2 then
		for k, v in pairs(v1) do
			v2 = false

			break
		end
	end

	p1.Visible = v2
end
function t.formatStateName(p1) --[[ formatStateName | Line: 123 ]]
	return string.upper((string.sub(p1, 1, 1))) .. string.lower((string.sub(p1, 2)))
end
function t.localPlayerRespawned(p1) --[[ localPlayerRespawned | Line: 127 | Upvalues: LocalPlayer (copy) ]]
	LocalPlayer.CharacterRemoving:Connect(p1)
end
function t.getClippedContainer(p1) --[[ getClippedContainer | Line: 137 ]]
	local ClippedContainer = p1:FindFirstChild("ClippedContainer")

	if not ClippedContainer then
		local ClippedContainer2 = Instance.new("Folder")

		ClippedContainer2.Name = "ClippedContainer"
		ClippedContainer2.Parent = p1
		ClippedContainer = ClippedContainer2
	end

	return ClippedContainer
end

local Janitor = require(script.Parent.Packages.Janitor)
local GuiService = game:GetService("GuiService")

function t.clipOutside(p1, p2) --[[ clipOutside | Line: 151 | Upvalues: Janitor (copy), t (copy), GuiService (copy) ]]
	local v1 = p1.janitor:add(Janitor.new())

	p2.Destroying:Once(function() --[[ Line: 153 | Upvalues: v1 (copy) ]]
		v1:Destroy()
	end)
	p1.janitor:add(p2)

	local v2 = p2.Parent
	local v3 = v1:add(Instance.new("Frame"))

	v3:SetAttribute("IsAClippedClone", true)
	v3.Name = p2.Name
	v3.AnchorPoint = p2.AnchorPoint
	v3.Size = p2.Size
	v3.Position = p2.Position
	v3.BackgroundTransparency = 1
	v3.LayoutOrder = p2.LayoutOrder
	v3.Parent = v2

	local OriginalInstance = Instance.new("ObjectValue")

	OriginalInstance.Name = "OriginalInstance"
	OriginalInstance.Value = p2
	OriginalInstance.Parent = v3

	local ClippedClone = OriginalInstance:Clone()

	p2:SetAttribute("HasAClippedClone", true)
	ClippedClone.Name = "ClippedClone"
	ClippedClone.Value = v3
	ClippedClone.Parent = p2

	local v4 = nil
	local iconModule = require(p1.iconModule)
	local container = iconModule.container

	local function updateScreenGui() --[[ updateScreenGui | Line: 183 | Upvalues: v2 (copy), v4 (ref), container (copy), p2 (copy), t (ref) ]]
		local v1 = v2:FindFirstAncestorWhichIsA("ScreenGui")

		v4 = if string.match(v1.Name, "Clipped") then v1 else container[v1.Name .. "Clipped"]
		p2.AnchorPoint = Vector2.new(0, 0)
		p2.Parent = t.getClippedContainer(v4)
	end

	v1:add(p1.alignmentChanged:Connect(updateScreenGui))
	updateScreenGui()

	for k, v in pairs(p2:GetChildren()) do
		if v:IsA("UIAspectRatioConstraint") then
			v:Clone().Parent = v3
		end
	end

	local widget = p1.widget
	local v5 = false
	local v6 = p2:GetAttribute("IgnoreVisibilityUpdater")

	local function updateVisibility() --[[ updateVisibility | Line: 205 | Upvalues: v6 (copy), widget (copy), v5 (ref), t (ref), p2 (copy) ]]
		if v6 then
			return
		end

		local Visible = widget.Visible

		if v5 then
			Visible = false
		end

		t.setVisible(p2, Visible, "ClipHandler")
	end

	v1:add(widget:GetPropertyChangedSignal("Visible"):Connect(updateVisibility))

	local v7 = nil

	local function v8() --[[ checkIfOutsideParentXBounds | Line: 218 | Upvalues: p1 (copy), p2 (copy), iconModule (copy), v5 (ref), v6 (copy), widget (copy), t (ref), v7 (ref), v8 (copy), v1 (copy) ]]
		task.defer(function() --[[ Line: 220 | Upvalues: p1 (ref), p2 (ref), iconModule (ref), v5 (ref), v6 (ref), widget (ref), t (ref), v7 (ref), v8 (ref), v1 (ref) ]]
			local v12 = nil
			local UID = p1.UID

			if p2:GetAttribute("ClipToJoinedParent") then
				local v2 = UID

				for i = 1, 10 do
					local v3 = iconModule.getIconByUID(v2)

					if not v3 then
						break
					end

					local joinedFrame = v3.joinedFrame

					v2 = v3.parentIconUID

					if not joinedFrame then
						break
					end

					if joinedFrame and joinedFrame.Name == "DropdownScroller" then
						v12 = joinedFrame

						break
					end

					v12 = joinedFrame
				end
			end

			if v12 then
				local AbsolutePosition2 = v12.AbsolutePosition
				local AbsoluteSize = v12.AbsoluteSize
				local v52 = p2.AbsolutePosition + p2.AbsoluteSize / 2
				local v62 = if v52.X < AbsolutePosition2.X then true else false
				local v72 = if v52.X > AbsolutePosition2.X + AbsoluteSize.X then true else false
				local v82 = if v52.Y < AbsolutePosition2.Y then true else false
				local v10 = if v62 then v62 elseif v72 then v72 elseif v82 then v82 elseif v52.Y > AbsolutePosition2.Y + AbsoluteSize.Y then true else false

				if v10 ~= v5 then
					v5 = v10

					if not v6 then
						local Visible = widget.Visible

						if v10 then
							Visible = false
						end

						t.setVisible(p2, Visible, "ClipHandler")
					end
				end

				if not v12:IsA("ScrollingFrame") or v7 == v12 then
					return
				end

				v7 = v12
				v1:add(v12:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() --[[ Line: 265 | Upvalues: v8 (ref) ]]
					v8()
				end), "Disconnect", "TrackUtilityScroller-" .. UID)
			else
				v5 = false

				if v6 then
					return
				end

				local Visible = widget.Visible

				if v5 then
					Visible = false
				end

				t.setVisible(p2, Visible, "ClipHandler")
			end
		end)
	end

	local CurrentCamera = workspace.CurrentCamera
	local v9 = p2:GetAttribute("AdditionalOffsetX") or 0

	local function trackProperty(p12) --[[ trackProperty | Line: 275 | Upvalues: v3 (copy), CurrentCamera (copy), p2 (copy), GuiService (ref), v4 (ref), iconModule (copy), v9 (copy), p1 (copy), v5 (ref), v6 (copy), widget (copy), t (ref), v7 (ref), v8 (copy), v1 (copy) ]]
		local v12 = "Absolute" .. p12

		local function updateProperty() --[[ updateProperty | Line: 277 | Upvalues: v3 (ref), v12 (copy), p12 (copy), CurrentCamera (ref), p2 (ref), GuiService (ref), v4 (ref), iconModule (ref), v9 (ref), p1 (ref), v5 (ref), v6 (ref), widget (ref), t (ref), v7 (ref), v8 (ref), v1 (ref) ]]
			local v13 = v3[v12]
			local v2 = UDim2.fromOffset(v13.X, v13.Y)

			if p12 == "Position" then
				local v32 = CurrentCamera.ViewportSize.X - p2.AbsoluteSize.X - 4
				local Offset = v2.X.Offset

				if Offset < 4 then
					Offset = 4
				elseif v32 < Offset then
					Offset = v32
				end

				local v42 = UDim2.fromOffset(Offset, v2.Y.Offset)
				local v52 = if iconModule.isOldTopbar then v4.AbsolutePosition.X else workspace.CurrentCamera.ViewportSize.X - v4.AbsoluteSize.X - 0

				v2 = v42 + UDim2.fromOffset(-(v52 - v9), GuiService.TopbarInset.Height)
				task.defer(function() --[[ Line: 220 | Upvalues: p1 (ref), p2 (ref), iconModule (ref), v5 (ref), v6 (ref), widget (ref), t (ref), v7 (ref), v8 (ref), v1 (ref) ]]
					local v12 = nil
					local UID = p1.UID

					if p2:GetAttribute("ClipToJoinedParent") then
						local v2 = UID

						for i = 1, 10 do
							local v3 = iconModule.getIconByUID(v2)

							if not v3 then
								break
							end

							local joinedFrame = v3.joinedFrame

							v2 = v3.parentIconUID

							if not joinedFrame then
								break
							end

							if joinedFrame and joinedFrame.Name == "DropdownScroller" then
								v12 = joinedFrame

								break
							end

							v12 = joinedFrame
						end
					end

					if v12 then
						local AbsolutePosition2 = v12.AbsolutePosition
						local AbsoluteSize = v12.AbsoluteSize
						local v52 = p2.AbsolutePosition + p2.AbsoluteSize / 2
						local v62 = if v52.X < AbsolutePosition2.X then true else false
						local v72 = if v52.X > AbsolutePosition2.X + AbsoluteSize.X then true else false
						local v82 = if v52.Y < AbsolutePosition2.Y then true else false
						local v10 = if v62 then v62 elseif v72 then v72 elseif v82 then v82 elseif v52.Y > AbsolutePosition2.Y + AbsoluteSize.Y then true else false

						if v10 ~= v5 then
							v5 = v10

							if not v6 then
								local Visible = widget.Visible

								if v10 then
									Visible = false
								end

								t.setVisible(p2, Visible, "ClipHandler")
							end
						end

						if not v12:IsA("ScrollingFrame") or v7 == v12 then
							return
						end

						v7 = v12
						v1:add(v12:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() --[[ Line: 265 | Upvalues: v8 (ref) ]]
							v8()
						end), "Disconnect", "TrackUtilityScroller-" .. UID)
					else
						v5 = false

						if v6 then
							return
						end

						local Visible = widget.Visible

						if v5 then
							Visible = false
						end

						t.setVisible(p2, Visible, "ClipHandler")
					end
				end)
			end

			p2[p12] = v2
		end

		local v2 = t.createStagger(0.01, updateProperty)

		v1:add(v3:GetPropertyChangedSignal(v12):Connect(v2))
		v1:add(v3:GetAttributeChangedSignal("ForceUpdate"):Connect(function() --[[ Line: 317 | Upvalues: v2 (copy) ]]
			v2()
		end))

		local v32 = t.createStagger(0.5, updateProperty, true)

		v1:add(v3:GetPropertyChangedSignal(v12):Connect(v32))

		if p12 ~= "Position" then
			return
		end

		v1:add(v4:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() --[[ Line: 336 | Upvalues: v2 (copy) ]]
			v2()
		end))
	end

	task.delay(0.1, v8)
	task.defer(function() --[[ Line: 220 | Upvalues: p1 (copy), p2 (copy), iconModule (copy), v5 (ref), v6 (copy), widget (copy), t (ref), v7 (ref), v8 (copy), v1 (copy) ]]
		local v12 = nil
		local UID = p1.UID

		if p2:GetAttribute("ClipToJoinedParent") then
			local v2 = UID

			for i = 1, 10 do
				local v3 = iconModule.getIconByUID(v2)

				if not v3 then
					break
				end

				local joinedFrame = v3.joinedFrame

				v2 = v3.parentIconUID

				if not joinedFrame then
					break
				end

				if joinedFrame and joinedFrame.Name == "DropdownScroller" then
					v12 = joinedFrame

					break
				end

				v12 = joinedFrame
			end
		end

		if v12 then
			local AbsolutePosition2 = v12.AbsolutePosition
			local AbsoluteSize = v12.AbsoluteSize
			local v52 = p2.AbsolutePosition + p2.AbsoluteSize / 2
			local v62 = if v52.X < AbsolutePosition2.X then true else false
			local v72 = if v52.X > AbsolutePosition2.X + AbsoluteSize.X then true else false
			local v82 = if v52.Y < AbsolutePosition2.Y then true else false
			local v10 = if v62 then v62 elseif v72 then v72 elseif v82 then v82 elseif v52.Y > AbsolutePosition2.Y + AbsoluteSize.Y then true else false

			if v10 ~= v5 then
				v5 = v10

				if not v6 then
					local Visible = widget.Visible

					if v10 then
						Visible = false
					end

					t.setVisible(p2, Visible, "ClipHandler")
				end
			end

			if not v12:IsA("ScrollingFrame") or v7 == v12 then
				return
			end

			v7 = v12
			v1:add(v12:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() --[[ Line: 265 | Upvalues: v8 (ref) ]]
				v8()
			end), "Disconnect", "TrackUtilityScroller-" .. UID)
		else
			v5 = false

			if v6 then
				return
			end

			local Visible = widget.Visible

			if v5 then
				Visible = false
			end

			t.setVisible(p2, Visible, "ClipHandler")
		end
	end)

	if not v6 then
		local Visible = widget.Visible

		if v5 then
			Visible = false
		end

		t.setVisible(p2, Visible, "ClipHandler")
	end

	trackProperty("Position")
	v1:add(p2:GetPropertyChangedSignal("Visible"):Connect(function() --[[ Line: 348 ]] end))

	if p2:GetAttribute("TrackCloneSize") then
		trackProperty("Size")
	else
		v1:add(p2:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() --[[ Line: 358 | Upvalues: p2 (copy), v3 (copy) ]]
			local AbsoluteSize = p2.AbsoluteSize

			v3.Size = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y)
		end))
	end

	return v3
end
function t.joinFeature(p1, p2, p3, p4) --[[ joinFeature | Line: 367 ]]
	local joinJanitor = p1.joinJanitor

	joinJanitor:clean()

	if not p4 then
		p1:leave()

		return
	end

	p1.parentIconUID = p2.UID
	p1.joinedFrame = p4

	local function updateAlignent() --[[ updateAlignent | Line: 378 | Upvalues: p2 (copy), p1 (copy) ]]
		local alignment = p2.alignment

		if alignment == "Center" then
			alignment = "Left"
		end

		p1:setAlignment(alignment, true)
	end

	joinJanitor:add(p2.alignmentChanged:Connect(updateAlignent))

	local alignment = p2.alignment

	if alignment == "Center" then
		alignment = "Left"
	end

	p1:setAlignment(alignment, true)
	p1:modifyTheme({ "IconButton", "BackgroundTransparency", 1 }, "JoinModification")
	p1:modifyTheme({ "ClickRegion", "Active", false }, "JoinModification")

	if p2.childModifications then
		task.defer(function() --[[ Line: 393 | Upvalues: p1 (copy), p2 (copy) ]]
			p1:modifyTheme(p2.childModifications, p2.childModificationsUID)
		end)
	end

	local v1 = p1:getInstance("ClickRegion")

	local function makeSelectable() --[[ makeSelectable | Line: 399 | Upvalues: v1 (copy), p2 (copy) ]]
		v1.Selectable = p2.isSelected
	end

	joinJanitor:add(p2.toggled:Connect(makeSelectable))
	task.defer(makeSelectable)
	joinJanitor:add(function() --[[ Line: 404 | Upvalues: v1 (copy) ]]
		v1.Selectable = true
	end)

	local UID = p1.UID

	table.insert(p3, UID)
	p2:autoDeselect(false)
	p2.childIconsDict[UID] = true

	if not p2.isEnabled then
		p2:setEnabled(true)
	end

	p1.joinedParent:Fire(p2)
	joinJanitor:add(function() --[[ Line: 422 | Upvalues: p1 (copy), p3 (copy), UID (copy), p2 (copy) ]]
		if not p1.joinedFrame then
			return
		end

		for k, v in pairs(p3) do
			if v == UID then
				table.remove(p3, k)

				break
			end
		end

		local v1 = require(p1.iconModule).getIconByUID(p1.parentIconUID)

		if not v1 then
			return
		end

		p1:setAlignment(p1.originalAlignment)
		p1.parentIconUID = false
		p1.joinedFrame = false
		p1:removeModification("JoinModification")

		local v2 = true
		local childIconsDict = v1.childIconsDict

		childIconsDict[UID] = nil

		for k, v in pairs(childIconsDict) do
			v2 = false

			break
		end

		if v2 and not v1.isAnOverflow then
			v1:setEnabled(false)
		end

		local alignment = p2.alignment

		if alignment == "Center" then
			alignment = "Left"
		end

		p1:setAlignment(alignment, true)
	end)
end

return t