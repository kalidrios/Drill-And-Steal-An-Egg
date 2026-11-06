-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
local t2 = {}

t.enums = t2
function t.createEnum(p1, p2) --[[ createEnum | Line: 20 | Upvalues: t2 (copy) ]]
	assert(if typeof(p1) == "string" then true else false, "bad argument #1 - enums must be created using a string name!")
	assert(if typeof(p2) == "table" then true else false, "bad argument #2 - enums must be created using a table!")
	assert(not t2[p1], ("enum \'%s\' already exists!"):format(p1))

	local t = {}
	local t3 = {}
	local t4 = {}
	local t5 = {
		getName = function(p1) --[[ getName | Line: 30 | Upvalues: t3 (copy), t4 (copy), p2 (copy) ]]
			local v1 = tostring(p1)
			local v2 = t3[v1] or t4[v1]

			if v2 then
				return p2[v2][1]
			end
		end,
		getValue = function(p1) --[[ getValue | Line: 40 | Upvalues: t (copy), t4 (copy), p2 (copy) ]]
			local v1 = tostring(p1)
			local v2 = t[v1] or t4[v1]

			if v2 then
				return p2[v2][2]
			end
		end,
		getProperty = function(p1) --[[ getProperty | Line: 50 | Upvalues: t (copy), t3 (copy), p2 (copy) ]]
			local v1 = tostring(p1)
			local v2 = t[v1] or t3[v1]

			if v2 then
				return p2[v2][3]
			end
		end
	}
	local t6 = {}

	for k, v in pairs(p2) do
		assert(if typeof(v) == "table" then true else false, ("bad argument #2.%s - details must only be comprised of tables!"):format(k))

		local v5 = v[1]

		assert(if typeof(v5) == "string" then true else false, ("bad argument #2.%s.1 - detail name must be a string!"):format(k))
		assert(typeof(not t[v5]), ("bad argument #2.%s.1 - the detail name \'%s\' already exists!"):format(k, v5))
		assert(typeof(not t5[v5]), ("bad argument #2.%s.1 - that name is reserved."):format(k, v5))
		t[tostring(v5)] = k

		local v11 = v[2]
		local v12 = tostring(v11)

		assert(typeof(not t3[v12]), ("bad argument #2.%s.2 - the detail value \'%s\' already exists!"):format(k, v12))
		t3[v12] = k

		local v15 = v[3]

		if v15 then
			local v17 = typeof(not t4[v15])

			assert(v17, ("bad argument #2.%s.3 - the detail property \'%s\' already exists!"):format(k, (tostring(v15))))
			t4[tostring(v15)] = k
		end

		t6[v5] = v11
		setmetatable(t6, {
			__index = function(p1, p2) --[[ __index | Line: 80 | Upvalues: t5 (copy) ]]
				return t5[p2]
			end
		})
	end

	t2[p1] = t6

	return t6
end
function t.getEnums() --[[ getEnums | Line: 90 | Upvalues: t2 (copy) ]]
	return t2
end

local createEnum = t.createEnum

for k, v in pairs(script:GetChildren()) do
	if v:IsA("ModuleScript") then
		createEnum(v.Name, (require(v)))
	end
end

return t