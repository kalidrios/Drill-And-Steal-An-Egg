-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local function defaultGuard(p1) --[[ defaultGuard | Line: 22 ]]
	return true
end

return function(p1, p2, p3, p4) --[[ observeAttribute | Line: 63 | Upvalues: defaultGuard (copy) ]]
	local v1 = nil
	local v2 = nil
	local v3 = 0
	local v4 = if p4 == nil then defaultGuard else p4

	local function OnAttributeChanged() --[[ OnAttributeChanged | Line: 76 | Upvalues: v1 (ref), v3 (ref), p1 (copy), p2 (copy), v4 (copy), p3 (copy), v2 (ref) ]]
		if v1 ~= nil then
			task.spawn(v1)
			v1 = nil
		end

		v3 = v3 + 1

		local v12 = v3
		local v22 = p1:GetAttribute(p2)

		if v22 == nil or not v4(v22) then
			return
		end

		task.spawn(function() --[[ Line: 88 | Upvalues: p3 (ref), v22 (copy), v12 (copy), v3 (ref), v2 (ref), v1 (ref) ]]
			local v13 = p3(v22)

			if typeof(v13) ~= "function" then
				return
			end

			if v12 == v3 and v2.Connected then
				v1 = v13

				return
			end

			task.spawn(v13)
		end)
	end

	local v5 = p1:GetAttributeChangedSignal(p2):Connect(OnAttributeChanged)

	task.defer(function() --[[ Line: 105 | Upvalues: v5 (ref), OnAttributeChanged (copy) ]]
		if v5.Connected then
			OnAttributeChanged()
		end
	end)

	return function() --[[ Line: 114 | Upvalues: v5 (ref), v1 (ref) ]]
		v5:Disconnect()

		if v1 == nil then
			return
		end

		task.spawn(v1)
		v1 = nil
	end
end