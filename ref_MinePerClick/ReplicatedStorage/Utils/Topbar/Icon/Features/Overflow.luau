-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
local t2 = {}
local t3 = {}
local v1 = nil
local CurrentCamera = workspace.CurrentCamera
local t4 = {}
local t5 = {}
local Utility = require(script.Parent.Parent.Utility)
local v2 = false
local v3 = false
local v4 = nil

function t.start(p1) --[[ start | Line: 25 | Upvalues: v4 (ref), v1 (ref), t2 (copy), Utility (copy), t (copy), v2 (ref), CurrentCamera (copy) ]]
	v4 = p1
	v1 = p1.iconsDictionary

	local v12 = nil

	for k, v in pairs(p1.container) do
		if v12 == nil and v.ScreenInsets == Enum.ScreenInsets.TopbarSafeInsets then
			v12 = v
		end

		for k2, v3 in pairs(v.Holders:GetChildren()) do
			if v3:GetAttribute("IsAHolder") then
				t2[v3.Name] = v3
			end
		end
	end

	local v22 = false
	local v3 = Utility.createStagger(0.1, function(p1) --[[ Line: 43 | Upvalues: v22 (ref), t (ref) ]]
		if not v22 then
			return
		end

		if not p1 then
			t.updateAvailableIcons("Center")
		end

		t.updateBoundary("Left")
		t.updateBoundary("Right")
	end)

	task.delay(0.5, function() --[[ Line: 53 | Upvalues: v22 (ref), v3 (copy) ]]
		v22 = true
		v3()
	end)
	task.delay(2, function() --[[ Line: 57 | Upvalues: v2 (ref), v3 (copy) ]]
		v2 = true
		v3()
	end)
	p1.iconAdded:Connect(v3)
	p1.iconRemoved:Connect(v3)
	p1.iconChanged:Connect(v3)
	CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() --[[ Line: 67 | Upvalues: v3 (copy) ]]
		v3(true)
	end)
	v12:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() --[[ Line: 70 | Upvalues: v3 (copy) ]]
		v3(true)
	end)
end
function t.getWidth(p1, p2) --[[ getWidth | Line: 75 ]]
	local widget = p1.widget

	return widget:GetAttribute("TargetWidth") or widget.AbsoluteSize.X
end
function t.getAvailableIcons(p1) --[[ getAvailableIcons | Line: 80 | Upvalues: t3 (copy), t (copy) ]]
	local v1 = t3[p1]

	if not v1 then
		v1 = t.updateAvailableIcons(p1)
	end

	return v1
end
function t.updateAvailableIcons(p1) --[[ updateAvailableIcons | Line: 88 | Upvalues: v1 (ref), t5 (copy), t3 (copy) ]]
	local t = {}
	local count = 0

	for k, v in pairs(v1) do
		local parentIconUID = v.parentIconUID

		if (not parentIconUID or t5[parentIconUID]) and (v.alignment == p1 and (not t5[v.UID] and v.isEnabled)) then
			table.insert(t, v)
			count = count + 1
		end
	end

	if count <= 0 then
		return {}
	end

	table.sort(t, function(p1, p2) --[[ Line: 110 ]]
		local LayoutOrder = p1.widget.LayoutOrder
		local LayoutOrder2 = p2.widget.LayoutOrder
		local parentIconUID = p1.parentIconUID
		local parentIconUID2 = p2.parentIconUID

		if parentIconUID == parentIconUID2 then
			if LayoutOrder < LayoutOrder2 then
				return true
			end

			if LayoutOrder2 < LayoutOrder then
				return false
			end

			return p1.widget.AbsolutePosition.X < p2.widget.AbsolutePosition.X
		end

		if parentIconUID2 then
			return false
		end

		if parentIconUID then
			return true
		end

		return nil
	end)
	t3[p1] = t

	return t
end
function t.getRealXPositions(p1, p2) --[[ getRealXPositions | Line: 137 | Upvalues: t2 (copy), Utility (copy), t (copy) ]]
	local v1 = if p1 == "Left" then true else false
	local v2 = t2[p1]
	local X = v2.AbsolutePosition.X
	local Offset = v2.UIListLayout.Padding.Offset
	local sum = if v1 and X then X else X + v2.AbsoluteSize.X
	local t3 = {}

	if v1 then
		Utility.reverseTable(p2)
	end

	for i = #p2, 1, -1 do
		local v3
		local v4 = p2[i]
		local v5 = t.getWidth(v4)

		if not v1 then
			sum = sum - v5
		end

		t3[v4.UID] = sum

		if v1 then
			sum = sum + v5
		end

		v3 = if v1 and Offset then Offset else -Offset
		sum = sum + v3
	end

	return t3
end
function t.updateBoundary(p1) --[[ updateBoundary | Line: 166 | Upvalues: t2 (copy), t (copy), t4 (copy), v4 (ref), t5 (copy), v3 (ref), v2 (ref), Utility (copy) ]]
	local v1 = t2[p1]
	local UIListLayout = v1.UIListLayout
	local X = v1.AbsolutePosition.X
	local X2 = v1.AbsoluteSize.X
	local Offset = UIListLayout.Padding.Offset
	local Offset2 = UIListLayout.Padding.Offset
	local v22 = t.updateAvailableIcons(p1)
	local sum = 0
	local count = 0

	for k, v in pairs(v22) do
		sum = sum + (t.getWidth(v) + Offset2)
		count = count + 1
	end

	if count <= 0 then
		return
	end

	local v42 = if p1 == "Left" then true else false
	local v5 = not v42
	local v6 = t4[p1]

	if not v6 and (not (if p1 == "Center" then true else false) and #v22 > 0) then
		local v8 = v4.new()

		v8:setImage(6069276526, "Deselected")
		v8:setName("Overflow" .. p1)
		v8:setOrder(if v42 then -9999999 else 9999999)
		v8:setAlignment(p1)
		v8:autoDeselect(false)
		v8.isAnOverflow = true
		v8:select("OverflowStart", v8)
		v8:setEnabled(false)
		t4[p1] = v8
		t5[v8.UID] = true

		if not v4.closeableOverflowMenus then
			v8:getInstance("IconSpot").Visible = false
		end

		v6 = v8
	end

	local v9 = if p1 == "Left" then "Right" else "Left"
	local v10 = t.updateAvailableIcons(v9)
	local v11 = v42 and v10[1] or (if v5 then v10[#v10] else v5)
	local v12 = t4[v9]
	local v13 = v42 and X + X2 or X

	if v11 then
		local v14 = t.getRealXPositions(v9, v10)[v11.UID]

		v13 = v42 and v14 - Offset or v14 + t.getWidth(v11) + Offset
	end

	local v17 = 0

	local function v18() --[[ checkToShiftCentralIcon | Line: 233 | Upvalues: t (ref), v42 (copy), v3 (ref), p1 (copy), v22 (copy), v5 (copy), Offset (copy), v2 (ref), v17 (ref), v18 (copy) ]]
		local v1 = t.getAvailableIcons("Center")
		local v32 = v1[if v42 then 1 else #v1]

		local function secondaryCheck() --[[ secondaryCheck | Line: 237 | Upvalues: v3 (ref), t (ref), p1 (ref) ]]
			if v3 then
				return
			end

			v3 = true
			task.delay(3, t.updateBoundary, p1)
		end

		if not v32 or v32.hasRelocatedInOverflow then
			return
		end

		local v4 = v42 and v22[#v22] or v5 and v22[1]
		local X = v32.widget.AbsolutePosition.X
		local X2 = v4.widget.AbsolutePosition.X
		local v52 = t.getWidth(v4)
		local v6 = v42 and X - Offset or X + t.getWidth(v32) + Offset
		local v7 = v42 and X2 + v52 or X2
		local v8 = false

		if v42 then
			if v6 < v7 and v2 then
				v32:align("Left")
				v32.hasRelocatedInOverflow = true
				v8 = true
			elseif v6 < v7 then
				if v3 then
					return
				end

				v3 = true
				task.delay(3, t.updateBoundary, p1)

				return
			end
		elseif v5 and v7 < v6 and (v2 and not (v7 < 0)) then
			v32:align("Right")
			v32.hasRelocatedInOverflow = true
			v8 = true
		elseif v5 and v7 < v6 then
			if v3 then
				return
			end

			v3 = true
			task.delay(3, t.updateBoundary, p1)

			return
		end

		if not v8 then
			return
		end

		v17 = v17 + 1

		if not (v17 <= 4) then
			return
		end

		t.updateAvailableIcons("Center")
		v18()
	end

	v18()

	if v6 then
		local v19 = v6:getInstance("Menu")
		local v20 = X + X2
		local v21

		if v19 and v12 then
			local X3 = v12.widget.AbsolutePosition.X
			local v23 = v42 and X3 - Offset or X3 + t.getWidth(v12) + Offset
			local v26 = X + X2 / 2
			local v28 = if if v19.AbsoluteCanvasSize.X >= v12:getInstance("Menu").AbsoluteCanvasSize.X then true else false then v23 else v42 and v26 - Offset / 2 or v26 + Offset / 2

			v21 = v42 and v28 - X or v20 - v28
		else
			v21 = X2
		end

		local v30 = if v19 then v19:GetAttribute("MaxWidth") else v19
		local v31 = Utility.round(v21)

		if v19 and v30 ~= v31 then
			v19:SetAttribute("MaxWidth", v31)
		end
	end

	local v322 = t.getRealXPositions(p1, v22)
	local v33 = false

	for i = #v22, 1, -1 do
		local v34 = v22[i]
		local v35 = t.getWidth(v34)
		local v36 = v322[v34.UID]

		if v42 and v13 <= v36 + v35 or v5 and v36 <= v13 then
			v33 = true
		end
	end

	for j = #v22, 1, -1 do
		local v37 = v22[j]

		if not t5[v37.UID] then
			if v33 and not v37.parentIconUID then
				v37:joinMenu(v6)

				continue
			end

			if not v33 and v37.parentIconUID then
				v37:leave()
			end
		end
	end

	if v6.isEnabled ~= v33 then
		v6:setEnabled(v33)
	end

	if not v6.isEnabled or v6.overflowAlreadyOpened then
		return
	end

	v6.overflowAlreadyOpened = true
	v6:select()
end

return t