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
local v2 = nil

function t.start(p1) --[[ start | Line: 23 | Upvalues: v2 (ref), v1 (ref), t2 (copy), Utility (copy), t (copy), CurrentCamera (copy) ]]
	v2 = p1
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
	local v3 = Utility.createStagger(0.1, function(p1) --[[ Line: 41 | Upvalues: v22 (ref), t (ref) ]]
		if not v22 then
			return
		end

		if not p1 then
			t.updateAvailableIcons("Center")
		end

		t.updateBoundary("Left")
		t.updateBoundary("Right")
	end)

	task.delay(1, function() --[[ Line: 51 | Upvalues: v22 (ref), v3 (copy) ]]
		v22 = true
		v3()
	end)
	p1.iconAdded:Connect(v3)
	p1.iconRemoved:Connect(v3)
	p1.iconChanged:Connect(v3)
	CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() --[[ Line: 61 | Upvalues: v3 (copy) ]]
		v3(true)
	end)
	v12:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() --[[ Line: 64 | Upvalues: v3 (copy) ]]
		v3(true)
	end)
end
function t.getWidth(p1, p2) --[[ getWidth | Line: 69 ]]
	local widget = p1.widget

	return widget:GetAttribute("TargetWidth") or widget.AbsoluteSize.X
end
function t.getAvailableIcons(p1) --[[ getAvailableIcons | Line: 74 | Upvalues: t3 (copy), t (copy) ]]
	local v1 = t3[p1]

	if not v1 then
		v1 = t.updateAvailableIcons(p1)
	end

	return v1
end
function t.updateAvailableIcons(p1) --[[ updateAvailableIcons | Line: 82 | Upvalues: t2 (copy), v1 (ref), t5 (copy), t3 (copy) ]]
	local UIListLayout = t2[p1].UIListLayout
	local t = {}
	local count = 0

	for k, v in pairs(v1) do
		local parentIconUID = v.parentIconUID

		if (not parentIconUID or t5[parentIconUID]) and (v.alignment == p1 and not t5[v.UID]) then
			table.insert(t, v)
			count = count + 1
		end
	end

	if count <= 0 then
		return {}
	end

	table.sort(t, function(p1, p2) --[[ Line: 106 ]]
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
	end)
	t3[p1] = t

	return t
end
function t.getRealXPositions(p1, p2) --[[ getRealXPositions | Line: 132 | Upvalues: t2 (copy), Utility (copy), t (copy) ]]
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
function t.updateBoundary(p1) --[[ updateBoundary | Line: 162 | Upvalues: t2 (copy), t (copy), t4 (copy), v2 (ref), t5 (copy), Utility (copy) ]]
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

	local v4 = if p1 == "Left" then true else false
	local v5 = not v4
	local v6 = t4[p1]

	if not v6 and (not (if p1 == "Central" then true else false) and #v22 > 0) then
		local v8 = v2.new()

		v8:setImage(6069276526, "Deselected")
		v8:setName("Overflow" .. p1)
		v8:setOrder(if v4 then -9999999 else 9999999)
		v8:setAlignment(p1)
		v8:autoDeselect(false)
		v8.isAnOverflow = true
		v8:select("OverflowStart", v8)
		v8:setEnabled(false)
		t4[p1] = v8
		t5[v8.UID] = true
		v6 = v8
	end

	local v9 = if p1 == "Left" then "Right" else "Left"
	local v10 = t.updateAvailableIcons(v9)
	local v11 = v4 and v10[1] or (if v5 then v10[#v10] else v5)
	local v12 = t4[v9]
	local v13 = v4 and X + X2 or X

	if v11 then
		local widget = v11.widget
		local v14 = t.getRealXPositions(v9, v10)[v11.UID]

		v13 = v4 and v14 - Offset or v14 + t.getWidth(v11) + Offset
	end

	local v17 = t.getAvailableIcons("Center")
	local v19 = v17[if v4 then 1 else #v17]

	if v19 and not v19.hasRelocatedInOverflow then
		local v20 = v4 and v22[#v22] or (if v5 then v22[1] else v5)
		local X3 = v19.widget.AbsolutePosition.X
		local X4 = v20.widget.AbsolutePosition.X
		local v21 = t.getWidth(v20)
		local v222 = v4 and X3 - Offset or X3 + t.getWidth(v19) + Offset
		local v23 = v4 and X4 + v21 or X4

		if v4 then
			if v222 < v23 then
				v19:align("Left")
				v19.hasRelocatedInOverflow = true
			end
		elseif v5 and v23 < v222 then
			v19:align("Right")
			v19.hasRelocatedInOverflow = true
		end
	end

	if v6 then
		local v24 = v6:getInstance("Menu")
		local v25 = X + X2
		local v26

		if v24 and v12 then
			local X3 = v12.widget.AbsolutePosition.X
			local v28 = v4 and X3 - Offset or X3 + t.getWidth(v12) + Offset
			local v31 = X + X2 / 2
			local v33 = if if v24.AbsoluteCanvasSize.X >= v12:getInstance("Menu").AbsoluteCanvasSize.X then true else false then v28 else v4 and v31 - Offset / 2 or v31 + Offset / 2

			v26 = v4 and v33 - X or v25 - v33
		else
			v26 = X2
		end

		local v35 = if v24 then v24:GetAttribute("MaxWidth") else v24
		local v36 = Utility.round(v26)

		if v24 and v35 ~= v36 then
			v24:SetAttribute("MaxWidth", v36)
		end
	end

	local v37 = t.getRealXPositions(p1, v22)
	local v38 = false

	for i = #v22, 1, -1 do
		local v39 = v22[i]
		local v40 = t.getWidth(v39)
		local v41 = v37[v39.UID]

		if v4 and v13 <= v41 + v40 or v5 and v41 <= v13 then
			v38 = true
		end
	end

	for j = #v22, 1, -1 do
		local v42 = v22[j]

		if not t5[v42.UID] then
			if v38 and not v42.parentIconUID then
				v42:joinMenu(v6)

				continue
			end

			if not v38 and v42.parentIconUID then
				v42:leave()
			end
		end
	end

	if v6.isEnabled ~= v38 then
		v6:setEnabled(v38)
	end

	if not v6.isEnabled or v6.overflowAlreadyOpened then
		return
	end

	v6.overflowAlreadyOpened = true
	v6:select()
end

return t