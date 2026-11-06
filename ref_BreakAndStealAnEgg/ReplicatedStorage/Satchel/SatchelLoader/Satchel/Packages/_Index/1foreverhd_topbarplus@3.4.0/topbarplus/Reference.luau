-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = { objectName = "TopbarPlusReference" }

function v1.addToReplicatedStorage() -- line 10 | captures: ReplicatedStorage, v1
    if ReplicatedStorage:FindFirstChild(v1.objectName) then
        return false
    end
    local ObjectValue = Instance.new("ObjectValue")
    ObjectValue.Name = v1.objectName
    ObjectValue.Value = script.Parent
    ObjectValue.Parent = ReplicatedStorage
    return ObjectValue
end

function v1.getObject() -- line 22 | captures: ReplicatedStorage, v1
    return ReplicatedStorage:FindFirstChild(v1.objectName) or false
end

return v1
