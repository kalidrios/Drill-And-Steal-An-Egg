-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}
local v2 = Color3.new(1, 1, 1)
local v3 = Color3.new(0, 0, 0)

function v1.Apply(v4) -- line 42 | captures: v2, v3
    v4.Ambient = v2
    v4.LightColor = v3
    v4.LightDirection = Vector3.new(0, -1, 0)
end

function v1.Unshadow(v5) -- line 50
    if v5:IsA("BasePart") then
        v5.CastShadow = false
    end
    for v6, v7 in v5:GetDescendants() do
        if v7:IsA("BasePart") then
            v7.CastShadow = false
        end
    end
end

return v1
