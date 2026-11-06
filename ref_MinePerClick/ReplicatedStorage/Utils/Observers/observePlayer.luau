-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")

return function(p1) --[[ observePlayer | Line: 23 | Upvalues: Players (copy) ]]
	local v1 = nil
	local t = {}
	local t2 = {}

	local function OnPlayerAdded(p12) --[[ OnPlayerAdded | Line: 30 | Upvalues: v1 (ref), t2 (copy), p1 (copy), t (copy) ]]
		if v1.Connected then
			task.spawn(function() --[[ Line: 35 | Upvalues: t2 (ref), p12 (copy), p1 (ref), v1 (ref), t (ref) ]]
				t2[p12] = Enum.PlayerExitReason.Unknown

				local v12 = p1(p12)

				if typeof(v12) == "function" then
					if v1.Connected and p12.Parent then
						t[p12] = v12
					else
						task.spawn(v12, t2[p12])
					end
				end

				t2[p12] = nil
			end)
		end
	end

	local function OnPlayerRemoving(p1, p2) --[[ OnPlayerRemoving | Line: 49 | Upvalues: t2 (copy), t (copy) ]]
		if t2[p1] then
			t2[p1] = p2
		end

		local v1 = t[p1]

		t[p1] = nil

		if typeof(v1) ~= "function" then
			return
		end

		task.spawn(v1, p2)
	end

	v1 = Players.PlayerAdded:Connect(OnPlayerAdded)

	local v2 = Players.PlayerRemoving:Connect(OnPlayerRemoving)

	task.defer(function() --[[ Line: 66 | Upvalues: v1 (ref), Players (ref), OnPlayerAdded (copy) ]]
		if not v1.Connected then
			return
		end

		for v12, v2 in Players:GetPlayers() do
			task.spawn(OnPlayerAdded, v2)
		end
	end)

	return function() --[[ Line: 77 | Upvalues: v1 (ref), v2 (ref), t (copy), t2 (copy) ]]
		v1:Disconnect()
		v2:Disconnect()

		local v12 = next(t)

		while v12 do
			local v22 = t2[v12]

			if t2[v12] then
				t2[v12] = v22
			end

			local v3 = v12
			local v4 = t[v3]

			t[v3] = nil

			if typeof(v4) == "function" then
				task.spawn(v4, v22)
			end

			v12 = next(t)
		end
	end
end