-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
local Utility = require(script.Parent.Parent.Utility)
local Default = require(script.Default)

function t.getThemeValue(p1, p2, p3, p4) --[[ getThemeValue | Line: 16 ]]
	if not p1 then
		return
	end

	for k, v in pairs(p1) do
		local v1, v2, v3 = unpack(v)

		if p2 == v1 and p3 == v2 then
			return v3
		end
	end
end
function t.getInstanceValue(p1, p2) --[[ getInstanceValue | Line: 27 ]]
	local ok, result = pcall(function() --[[ Line: 28 | Upvalues: p1 (copy), p2 (copy) ]]
		return p1[p2]
	end)

	if not ok then
		result = p1:GetAttribute(p2)
	end

	return result
end
function t.getRealInstance(p1) --[[ getRealInstance | Line: 37 ]]
	if not p1:GetAttribute("IsAClippedClone") then
		return
	end

	local OriginalInstance = p1:FindFirstChild("OriginalInstance")

	if OriginalInstance then
		return OriginalInstance.Value
	end
end
function t.getClippedClone(p1) --[[ getClippedClone | Line: 48 ]]
	if not p1:GetAttribute("HasAClippedClone") then
		return
	end

	local ClippedClone = p1:FindFirstChild("ClippedClone")

	if ClippedClone then
		return ClippedClone.Value
	end
end
function t.refresh(p1, p2, p3) --[[ refresh | Line: 59 | Upvalues: t (copy) ]]
	if p3 then
		local v1 = p1:getStateGroup()

		t.apply(p1, p2, p3, t.getThemeValue(v1, p2.Name, p3) or t.getInstanceValue(p2, p3), true)
	else
		local v3 = p1:getStateGroup()

		if not v3 then
			return
		end

		local t2 = {
			[p2.Name] = p2
		}

		for k, v in pairs(p2:GetDescendants()) do
			local v4 = v:GetAttribute("Collective")

			if v4 then
				t2[v4] = v
			end

			t2[v.Name] = v
		end

		for k, v in pairs(v3) do
			local v5, v6, v7 = unpack(v)
			local v8 = t2[v5]

			if v8 then
				t.apply(p1, v8.Name, v6, v7, true)
			end
		end
	end
end
function t.apply(p1, p2, p3, p4, p5) --[[ apply | Line: 92 | Upvalues: t (copy) ]]
	if not p1.isDestroyed then
		local v1, v2

		if typeof(p2) == "Instance" then
			v1 = p2.Name
			v2 = { p2 }
		else
			v1, v2 = p2, p1:getInstanceOrCollective(p2)
		end

		local v4 = p1.customBehaviours[v1 .. "-" .. p3]

		for k, v in pairs(v2) do
			local v5 = t.getClippedClone(v)

			if v5 then
				table.insert(v2, v5)
			end
		end

		for k, v in pairs(v2) do
			if (p3 ~= "Position" or not t.getClippedClone(v)) and ((p3 ~= "Size" or not t.getRealInstance(v)) and (p5 or p4 ~= t.getInstanceValue(v, p3))) then
				if v4 then
					local v6 = v4(p4, v, p3)

					if v6 ~= nil then
						p4 = v6
					end
				end

				if not pcall(function() --[[ Line: 138 | Upvalues: v (copy), p3 (copy), p4 (ref) ]]
					v[p3] = p4
				end) then
					v:SetAttribute(p3, p4)
				end
			end
		end
	end
end
function t.getModifications(p1) --[[ getModifications | Line: 152 ]]
	if typeof(p1[1]) ~= "table" then
		p1 = { p1 }
	end

	return p1
end
function t.merge(p1, p2, p3) --[[ merge | Line: 161 | Upvalues: t (copy) ]]
	local v1, v2, v3, v4 = table.unpack(p2)
	local v5, v6, _, v7 = table.unpack(p1)

	if v1 ~= v5 or (v2 ~= v6 or not t.statesMatch(v4, v7)) then
		return false
	end

	p1[3] = v3

	if not p3 then
		return true
	end

	p3(p1)

	return true
end
function t.modify(p1, p2, p3) --[[ modify | Line: 174 | Upvalues: Utility (copy), t (copy) ]]
	task.spawn(function() --[[ Line: 182 | Upvalues: p3 (ref), Utility (ref), p2 (ref), t (ref), p1 (copy) ]]
		p3 = p3 or Utility.generateUID()
		p2 = t.getModifications(p2)

		for k, v in pairs(p2) do
			local v2, v3, v4, v5 = table.unpack(v)

			if v5 == nil then
				t.modify(p1, { v2, v3, v4, "Selected" }, p3)
				t.modify(p1, { v2, v3, v4, "Viewing" }, p3)
			end

			local v6 = Utility.formatStateName(v5 or "Deselected")
			local v7 = p1:getStateGroup(v6)

			local function nowSetIt() --[[ nowSetIt | Line: 194 | Upvalues: v6 (copy), p1 (ref), t (ref), v2 (copy), v3 (copy), v4 (copy) ]]
				if v6 ~= p1.activeState then
					return
				end

				t.apply(p1, v2, v3, v4)
			end

			(function() --[[ updateRecord | Line: 199 | Upvalues: v7 (copy), t (ref), v (copy), p3 (ref), v6 (copy), p1 (ref), v2 (copy), v3 (copy), v4 (copy) ]]
				for k, v5 in pairs(v7) do
					if t.merge(v5, v, function(p12) --[[ Line: 201 | Upvalues: p3 (ref), v6 (ref), p1 (ref), t (ref), v2 (ref), v3 (ref), v4 (ref) ]]
						p12[5] = p3

						if v6 ~= p1.activeState then
							return
						end

						t.apply(p1, v2, v3, v4)
					end) then
						return
					end
				end

				local t2 = { v2, v3, v4, v6, p3 }

				table.insert(v7, t2)

				if v6 ~= p1.activeState then
					return
				end

				t.apply(p1, v2, v3, v4)
			end)()
		end
	end)

	return p3
end
function t.remove(p1, p2) --[[ remove | Line: 219 | Upvalues: t (copy) ]]
	for k, v in pairs(p1.appearance) do
		for i = #v, 1, -1 do
			if v[i][5] == p2 then
				table.remove(v, i)
			end
		end
	end

	t.rebuild(p1)
end
function t.removeWith(p1, p2, p3, p4) --[[ removeWith | Line: 232 | Upvalues: t (copy) ]]
	for k, v in pairs(p1.appearance) do
		if p4 == k or not p4 then
			for i = #v, 1, -1 do
				local v1 = v[i]

				if v1[1] == p2 and v1[2] == p3 then
					table.remove(v, i)
				end
			end
		end
	end

	t.rebuild(p1)
end
function t.change(p1) --[[ change | Line: 248 | Upvalues: t (copy) ]]
	for k, v in pairs((p1:getStateGroup())) do
		local v2, v3, v4 = unpack(v)

		t.apply(p1, v2, v3, v4)
	end
end
function t.set(p1, p2) --[[ set | Line: 258 | Upvalues: t (copy) ]]
	local themesJanitor = p1.themesJanitor

	themesJanitor:clean()
	themesJanitor:add(p1.stateChanged:Connect(function() --[[ Line: 264 | Upvalues: t (ref), p1 (copy) ]]
		t.change(p1)
	end))

	if typeof(p2) == "Instance" and p2:IsA("ModuleScript") then
		p2 = require(p2)
	end

	p1.appliedTheme = p2
	t.rebuild(p1)
end
function t.statesMatch(p1, p2) --[[ statesMatch | Line: 274 ]]
	local v1 = if p1 then string.lower(p1) else p1

	return if v1 == (if p2 then string.lower(p2) else p2) then true else not p1 or not p2
end
function t.rebuild(p1) --[[ rebuild | Line: 281 | Upvalues: t (copy), Utility (copy), Default (copy) ]]
	local appliedTheme = p1.appliedTheme
	local t2 = { "Deselected", "Selected", "Viewing" }

	(function() --[[ generateTheme | Line: 288 | Upvalues: t2 (copy), t (ref), Utility (ref), Default (ref), appliedTheme (copy), p1 (copy) ]]
		for k, v in pairs(t2) do
			local tbl = {}

			local function updateDetails(p1, p2) --[[ updateDetails | Line: 294 | Upvalues: t (ref), Utility (ref), tbl (copy) ]]
				if not p1 then
					return
				end

				for k, v in pairs(p1) do
					local v1 = v[5]

					if t.statesMatch(p2, v[4]) then
						local v4 = Utility.copyTable(v)

						v4[5] = v1
						tbl[v[1] .. "-" .. v[2]] = v4
					end
				end
			end

			if v == "Selected" then
				updateDetails(Default, "Deselected")
			end

			updateDetails(Default, "Empty")
			updateDetails(Default, v)

			if appliedTheme ~= Default then
				if v == "Selected" then
					updateDetails(appliedTheme, "Deselected")
				end

				updateDetails(Default, "Empty")
				updateDetails(appliedTheme, v)
			end

			local t3 = {}
			local v1 = p1.appearance[v]

			if v1 then
				for k2, v2 in pairs(v1) do
					local v22 = v2[5]

					if v22 ~= nil then
						table.insert(t3, {
							v2[1],
							v2[2],
							v2[3],
							v,
							v22
						})
					end
				end
			end

			updateDetails(t3, v)

			local t4 = {}

			for k2, v2 in pairs(tbl) do
				table.insert(t4, v2)
			end

			p1.appearance[v] = t4
		end

		t.change(p1)
	end)()
end

return t