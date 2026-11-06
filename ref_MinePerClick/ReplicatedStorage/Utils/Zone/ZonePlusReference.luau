-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")

return {
	addToReplicatedStorage = function() --[[ addToReplicatedStorage | Line: 9 | Upvalues: ReplicatedStorage (copy) ]]
		if ReplicatedStorage:FindFirstChild(script.Name) then
			return false
		end

		local v1 = Instance.new("ObjectValue")

		v1.Name = script.Name
		v1.Value = script.Parent
		v1.Parent = ReplicatedStorage

		local v2 = Instance.new("BoolValue")

		v2.Name = if game:GetService("RunService"):IsClient() then "Client" else "Server"
		v2.Value = true
		v2.Parent = v1

		return v1
	end,
	getObject = function() --[[ getObject | Line: 25 | Upvalues: ReplicatedStorage (copy) ]]
		local v1 = ReplicatedStorage:FindFirstChild(script.Name)

		if v1 then
			return v1
		end

		return false
	end
}