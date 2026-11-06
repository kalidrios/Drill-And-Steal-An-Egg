-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = {
    Carry = "rbxassetid://101172392454133",
    TreadmillRunFallback = "rbxassetid://913376220"
}

v1.Character = {
    {
        Key = "Carry",
        Looped = true,
        Id = v1.Carry,
        Priority = Enum.AnimationPriority.Action
    },
    {
        Key = "TreadmillRunFallback",
        Looped = true,
        Id = v1.TreadmillRunFallback,
        Priority = Enum.AnimationPriority.Action
    }
}

local v2 = { "Assets", "Animations" }
local v3 = {}

function v1.Get(v4, v5) -- line 62 | captures: v3
    local v6 = v3[v4]
    if v6 then
        if v5 then
            v6.Name = v5
        end
        return v6
    end
    local Animation = Instance.new("Animation")
    Animation.Name = v5 or "Animation"
    Animation.AnimationId = v4
    v3[v4] = Animation
    return Animation
end

function v1.AuthoredFolder() -- line 80 | captures: ReplicatedStorage, v2
    local v7 = ReplicatedStorage
    for v8, v9 in v2 do
        v7 = v7:WaitForChild(v9, 20)
        if not v7 then
            return nil
        end
    end
    return v7
end

function v1.PreloadList() -- line 94 | captures: v1
    local function v10(v11, ...)
        table.insert(v11, ...)
    end

    local v12 = {}
    for v13, v14 in v1.Character do
        v10(v12, v1.Get(v14.Id, v14.Key))
    end
    local v15 = v1.AuthoredFolder()
    if v15 then
        for v16, v17 in v15:GetChildren() do
            if v17:IsA("Animation") and v17.AnimationId ~= "" then
                table.insert(v12, v17)
            end
        end
    end
    return v12
end

return v1
