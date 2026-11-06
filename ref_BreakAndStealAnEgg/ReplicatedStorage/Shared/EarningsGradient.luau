-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local PrettyGradient = require(script.Parent.PrettyGradient)
local v1 = {}
local v2 = {
    {
        0,
        Color3.fromRGB(206, 240, 206)
    },
    {
        1,
        Color3.fromRGB(88, 214, 96)
    },
    {
        2,
        Color3.fromRGB(54, 214, 172)
    },
    {
        3,
        Color3.fromRGB(64, 170, 255)
    },
    {
        4,
        Color3.fromRGB(142, 120, 255)
    },
    {
        5,
        Color3.fromRGB(198, 96, 255)
    },
    {
        6,
        Color3.fromRGB(255, 92, 196)
    },
    {
        7,
        Color3.fromRGB(255, 84, 84)
    },
    {
        8,
        Color3.fromRGB(255, 140, 44)
    },
    {
        9,
        Color3.fromRGB(255, 198, 60)
    },
    {
        10,
        Color3.fromRGB(255, 240, 110)
    },
    {
        12,
        Color3.fromRGB(166, 255, 77)
    }
}
local v3 = v2[1][1]
local v4 = v2[#v2][1]

function v1.Decade(v5) -- line 52 | captures: v3, v4
    if v5 ~= v5 or v5 <= 1 then
        return v3
    end
    local v6 = math.log10(v5)
    return (math.clamp(v6, v3, v4))
end

function v1.Color(v7) -- line 60 | captures: v1, v2
    local v8 = v1.Decade(v7)
    local v9 = #v2 - 1
    for v10 = 1, v9 do
        local v11 = v2[v10][1]
        local v12 = v2[v10][2]
        local v13 = v2[v10 + 1][1]
        local v14 = v2[v10 + 1][2]
        if v8 <= v13 then
            local v15 = (v8 - v11) / (v13 - v11)
            return v12:Lerp(v14, (math.clamp(v15, 0, 1)))
        end
    end
    return v2[#v2][2]
end

function v1.ApplyToLabel(v16, v17) -- line 77 | captures: PrettyGradient, v1
    return PrettyGradient.ApplyToLabel(v16, v1.Color(v17))
end

return v1
