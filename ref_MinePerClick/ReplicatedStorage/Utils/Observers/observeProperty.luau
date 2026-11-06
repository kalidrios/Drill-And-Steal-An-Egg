-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2, p3) --[[ observeProperty | Line: 21 ]]
	local v1 = nil
	local v2 = nil
	local v3 = 0

	local function OnPropertyChanged() --[[ OnPropertyChanged | Line: 27 | Upvalues: v1 (ref), v3 (ref), p1 (copy), p2 (copy), p3 (copy), v2 (ref) ]]
		local v12, v22

		if v1 == nil then
			v3 = v3 + 1
			v12 = v3
			v22 = p1[p2]
			task.spawn(function() --[[ Line: 38 | Upvalues: p3 (ref), v22 (copy), v12 (copy), v3 (ref), v2 (ref), v1 (ref) ]]
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

			return
		end

		task.spawn(v1)
		v1 = nil
		v3 = v3 + 1
		v12 = v3
		v22 = p1[p2]
		task.spawn(function() --[[ Line: 38 | Upvalues: p3 (ref), v22 (copy), v12 (copy), v3 (ref), v2 (ref), v1 (ref) ]]
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

	v2 = p1:GetPropertyChangedSignal(p2):Connect(OnPropertyChanged)
	task.defer(function() --[[ Line: 54 | Upvalues: v2 (ref), v1 (ref), v3 (ref), p1 (copy), p2 (copy), p3 (copy) ]]
		if not v2.Connected then
			return
		end

		local v12, v22

		if v1 ~= nil then
			task.spawn(v1)
			v1 = nil
		end

		v3 = v3 + 1
		v12 = v3
		v22 = p1[p2]
		task.spawn(function() --[[ Line: 38 | Upvalues: p3 (ref), v22 (copy), v12 (copy), v3 (ref), v2 (ref), v1 (ref) ]]
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
	end)

	return function() --[[ Line: 62 | Upvalues: v2 (ref), v1 (ref) ]]
		v2:Disconnect()

		if v1 == nil then
			return
		end

		task.spawn(v1)
		v1 = nil
	end
end