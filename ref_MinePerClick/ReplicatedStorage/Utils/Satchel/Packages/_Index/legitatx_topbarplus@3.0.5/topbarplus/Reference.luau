-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = {
	objectName = "TopbarPlusReference"
}

function t.addToReplicatedStorage() --[[ addToReplicatedStorage | Line: 10 | Upvalues: ReplicatedStorage (copy), t (copy) ]]
	if ReplicatedStorage:FindFirstChild(t.objectName) then
		return false
	end

	local v1 = Instance.new("ObjectValue")

	v1.Name = t.objectName
	v1.Value = script.Parent
	v1.Parent = ReplicatedStorage

	return v1
end
function t.getObject() --[[ getObject | Line: 22 | Upvalues: ReplicatedStorage (copy), t (copy) ]]
	local v1 = ReplicatedStorage:FindFirstChild(t.objectName)

	if v1 then
		return v1
	end

	return false
end

return t