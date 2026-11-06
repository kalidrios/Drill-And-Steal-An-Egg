-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")

function observeTag(p1, p2, p3) --[[ observeTag | Line: 58 | Upvalues: CollectionService (copy) ]]
	local t = {}
	local t2 = {}
	local v1 = nil

	local function IsGoodAncestor(p1) --[[ IsGoodAncestor | Line: 65 | Upvalues: p3 (copy) ]]
		if p3 == nil then
			return true
		end

		for v1, v2 in p3 do
			if p1:IsDescendantOf(v2) then
				return true
			end
		end

		return false
	end

	local function AttemptStartup(p12) --[[ AttemptStartup | Line: 79 | Upvalues: t (copy), p2 (copy), p1 (copy) ]]
		t[p12] = "__inflight__"
		task.defer(function() --[[ Line: 84 | Upvalues: t (ref), p12 (copy), p2 (ref), p1 (ref) ]]
			if t[p12] ~= "__inflight__" then
				return
			end

			local ok, result = xpcall(function(p13) --[[ Line: 90 | Upvalues: p2 (ref) ]]
				local v1 = p2(p13)

				if v1 ~= nil then
					assert(typeof(v1) == "function", "callback must return a function or nil")
				end

				return v1
			end, debug.traceback, p12)

			if ok then
				if t[p12] == "__inflight__" then
					t[p12] = result
				elseif result ~= nil then
					task.spawn(result)
				end
			else
				local v12 = string.split(result, "\n")[1]
				local v2 = string.find(v12, ": ")

				warn((("error while calling observeTag(\"%*\") callback:%*\n%*"):format(p1, if v2 then v12:sub(v2 + 1) else "", result)))
			end
		end)
	end

	local function AttemptCleanup(p1) --[[ AttemptCleanup | Line: 122 | Upvalues: t (copy) ]]
		local v1 = t[p1]

		t[p1] = "__dead__"

		if typeof(v1) ~= "function" then
			return
		end

		task.spawn(v1)
	end

	local function OnAncestryChanged(p12) --[[ OnAncestryChanged | Line: 131 | Upvalues: p3 (copy), t (copy), p2 (copy), p1 (copy) ]]
		local v1

		if p3 == nil then
			v1 = true
		else
			v1 = false

			for v2, v3 in p3 do
				if p12:IsDescendantOf(v3) then
					v1 = true

					break
				end
			end
		end

		if v1 then
			if t[p12] == "__dead__" then
				t[p12] = "__inflight__"
				task.defer(function() --[[ Line: 84 | Upvalues: t (ref), p12 (copy), p2 (ref), p1 (ref) ]]
					if t[p12] ~= "__inflight__" then
						return
					end

					local ok, result = xpcall(function(p13) --[[ Line: 90 | Upvalues: p2 (ref) ]]
						local v1 = p2(p13)

						if v1 ~= nil then
							assert(typeof(v1) == "function", "callback must return a function or nil")
						end

						return v1
					end, debug.traceback, p12)

					if ok then
						if t[p12] == "__inflight__" then
							t[p12] = result
						elseif result ~= nil then
							task.spawn(result)
						end
					else
						local v12 = string.split(result, "\n")[1]
						local v2 = string.find(v12, ": ")

						warn((("error while calling observeTag(\"%*\") callback:%*\n%*"):format(p1, if v2 then v12:sub(v2 + 1) else "", result)))
					end
				end)
			end
		else
			local v4 = t[p12]

			t[p12] = "__dead__"

			if typeof(v4) ~= "function" then
				return
			end

			task.spawn(v4)
		end
	end

	local function OnInstanceAdded(p12) --[[ OnInstanceAdded | Line: 141 | Upvalues: v1 (ref), t (copy), t2 (copy), p3 (copy), p2 (copy), p1 (copy) ]]
		if not v1.Connected then
			return
		end

		if t[p12] ~= nil then
			return
		end

		t[p12] = "__dead__"
		t2[p12] = p12.AncestryChanged:Connect(function() --[[ Line: 151 | Upvalues: p12 (copy), p3 (ref), t (ref), p2 (ref), p1 (ref) ]]
			local v1 = p12
			local v2

			if p3 == nil then
				v2 = true
			else
				v2 = false

				for v3, v4 in p3 do
					if v1:IsDescendantOf(v4) then
						v2 = true

						break
					end
				end
			end

			if v2 then
				if t[v1] == "__dead__" then
					t[v1] = "__inflight__"
					task.defer(function() --[[ Line: 84 | Upvalues: t (ref), v1 (copy), p2 (ref), p1 (ref) ]]
						if t[v1] ~= "__inflight__" then
							return
						end

						local ok, result = xpcall(function(p13) --[[ Line: 90 | Upvalues: p2 (ref) ]]
							local v1 = p2(p13)

							if v1 ~= nil then
								assert(typeof(v1) == "function", "callback must return a function or nil")
							end

							return v1
						end, debug.traceback, v1)

						if ok then
							if t[v1] == "__inflight__" then
								t[v1] = result
							elseif result ~= nil then
								task.spawn(result)
							end
						else
							local v12 = string.split(result, "\n")[1]
							local v2 = string.find(v12, ": ")

							warn((("error while calling observeTag(\"%*\") callback:%*\n%*"):format(p1, if v2 then v12:sub(v2 + 1) else "", result)))
						end
					end)
				end
			else
				local v5 = t[v1]

				t[v1] = "__dead__"

				if typeof(v5) ~= "function" then
					return
				end

				task.spawn(v5)
			end
		end)

		local v12

		if p3 == nil then
			v12 = true
		else
			v12 = false

			for v2, v3 in p3 do
				if p12:IsDescendantOf(v3) then
					v12 = true

					break
				end
			end
		end

		if v12 then
			if t[p12] == "__dead__" then
				t[p12] = "__inflight__"
				task.defer(function() --[[ Line: 84 | Upvalues: t (ref), p12 (copy), p2 (ref), p1 (ref) ]]
					if t[p12] ~= "__inflight__" then
						return
					end

					local ok, result = xpcall(function(p13) --[[ Line: 90 | Upvalues: p2 (ref) ]]
						local v1 = p2(p13)

						if v1 ~= nil then
							assert(typeof(v1) == "function", "callback must return a function or nil")
						end

						return v1
					end, debug.traceback, p12)

					if ok then
						if t[p12] == "__inflight__" then
							t[p12] = result
						elseif result ~= nil then
							task.spawn(result)
						end
					else
						local v12 = string.split(result, "\n")[1]
						local v2 = string.find(v12, ": ")

						warn((("error while calling observeTag(\"%*\") callback:%*\n%*"):format(p1, if v2 then v12:sub(v2 + 1) else "", result)))
					end
				end)
			end
		else
			local v4 = t[p12]

			t[p12] = "__dead__"

			if typeof(v4) ~= "function" then
				return
			end

			task.spawn(v4)
		end
	end

	local function OnInstanceRemoved(p1) --[[ OnInstanceRemoved | Line: 157 | Upvalues: t (copy), t2 (copy) ]]
		local v1 = t[p1]

		t[p1] = "__dead__"

		if typeof(v1) == "function" then
			task.spawn(v1)
		end

		local v2 = t2[p1]

		if v2 then
			v2:Disconnect()
			t2[p1] = nil
		end

		t[p1] = nil
	end

	v1 = CollectionService:GetInstanceAddedSignal(p1):Connect(OnInstanceAdded)

	local v2 = CollectionService:GetInstanceRemovedSignal(p1):Connect(OnInstanceRemoved)

	task.defer(function() --[[ Line: 174 | Upvalues: v1 (ref), CollectionService (ref), p1 (copy), OnInstanceAdded (copy) ]]
		if not v1.Connected then
			return
		end

		for v12, v2 in CollectionService:GetTagged(p1) do
			task.spawn(OnInstanceAdded, v2)
		end
	end)

	return function() --[[ Line: 185 | Upvalues: v1 (ref), v2 (ref), t (copy), t2 (copy) ]]
		v1:Disconnect()
		v2:Disconnect()

		local v12 = next(t)

		while v12 do
			local v22 = t[v12]

			t[v12] = "__dead__"

			if typeof(v22) == "function" then
				task.spawn(v22)
			end

			local v3 = t2[v12]

			if v3 then
				v3:Disconnect()
				t2[v12] = nil
			end

			t[v12] = nil
			v12 = next(t)
		end
	end
end

return observeTag