-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local v1 = game:GetService("RunService"):IsClient()

return function(p1) --[[ observeLocalCharacter | Line: 29 | Upvalues: v1 (copy), Players (copy) ]]
	assert(v1, "observeLocalCharacter can only be called from the client")

	local v2 = nil
	local v3 = true

	local function onCharacterAdded(p12) --[[ onCharacterAdded | Line: 35 | Upvalues: v3 (ref), v2 (ref), p1 (copy) ]]
		local v1 = nil
		local v22 = nil

		v22 = p12.AncestryChanged:Connect(function(p1, p2) --[[ Line: 39 | Upvalues: v22 (ref), v1 (ref), v3 (ref), v2 (ref) ]]
			if p2 ~= nil or not v22.Connected then
				return
			end

			v22:Disconnect()

			if typeof(v1) ~= "function" or not v3 then
				return
			end

			task.spawn(v1)

			if v2 ~= v1 then
				return
			end

			v2 = nil
		end)
		v1 = p1(p12)

		local v32 = v1

		if typeof(v32) == "function" then
			if v22.Connected then
				v2 = v1
			else
				task.spawn(v1)
			end
		end
	end

	local v4 = Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

	if Players.LocalPlayer.Character == nil then
		return function() --[[ Line: 66 | Upvalues: v3 (ref), v4 (copy), v2 (ref) ]]
			v3 = false
			v4:Disconnect()

			if typeof(v2) ~= "function" then
				return
			end

			task.spawn(v2)
			v2 = nil
		end
	end

	task.spawn(onCharacterAdded, Players.LocalPlayer.Character)

	return function() --[[ Line: 66 | Upvalues: v3 (ref), v4 (copy), v2 (ref) ]]
		v3 = false
		v4:Disconnect()

		if typeof(v2) ~= "function" then
			return
		end

		task.spawn(v2)
		v2 = nil
	end
end