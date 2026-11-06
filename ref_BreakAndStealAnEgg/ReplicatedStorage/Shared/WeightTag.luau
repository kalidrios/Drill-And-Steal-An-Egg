-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local FormatNumber = require(script.Parent.FormatNumber)
local v1 = {}
local v2 = {
    {
        1,
        Color3.fromRGB(255, 255, 255)
    },
    {
        2,
        Color3.fromRGB(133, 255, 122)
    },
    {
        3,
        Color3.fromRGB(79, 232, 210)
    },
    {
        4,
        Color3.fromRGB(79, 168, 255)
    },
    {
        5,
        Color3.fromRGB(138, 112, 255)
    },
    {
        6,
        Color3.fromRGB(192, 92, 255)
    },
    {
        7,
        Color3.fromRGB(244, 92, 255)
    },
    {
        8,
        Color3.fromRGB(255, 92, 171)
    },
    {
        9,
        Color3.fromRGB(255, 78, 78)
    },
    {
        10,
        Color3.fromRGB(255, 138, 43)
    },
    {
        12,
        Color3.fromRGB(255, 201, 60)
    },
    {
        15,
        Color3.fromRGB(255, 240, 110)
    },
    {
        20,
        Color3.fromRGB(166, 255, 77)
    },
    {
        25,
        Color3.fromRGB(77, 255, 219)
    },
    {
        30,
        Color3.fromRGB(77, 166, 255)
    },
    {
        35,
        Color3.fromRGB(184, 77, 255)
    },
    {
        40,
        Color3.fromRGB(255, 77, 210)
    }
}

local function Figures(v3) -- line 48
    if v3 ~= v3 or v3 < 10 then
        return 1
    end
    local v4 = math.log10(v3)
    local v5 = math.floor(v4) + 1
    return (math.clamp(v5, 1, 40))
end

v1.Figures = Figures

function v1.Color(v6) -- line 56 | captures: v1, v2
    local v7 = v1.Figures(v6)
    local v8 = #v2 - 1
    for v9 = 1, v8 do
        local v10 = v2[v9][1]
        local v11 = v2[v9][2]
        local v12 = v2[v9 + 1][1]
        local v13 = v2[v9 + 1][2]
        if v7 <= v12 then
            return v11:Lerp(v13, (v7 - v10) / (v12 - v10))
        end
    end
    return v2[#v2][2]
end

function v1.FormatKg(v14) -- line 72 | captures: FormatNumber
    local Commas = FormatNumber.Commas
    local v15 = if v14 < 100 then 1 else 0
    return Commas(v14, v15)
end

function v1.Tag(v16) -- line 77 | captures: v1
    local v17 = v1.Color(v16)
    return (("<font color=\"%*\"><b>[%*Kg]</b></font>"):format(string.format("#%02X%02X%02X", v17.R * 255 + 0.5, v17.G * 255 + 0.5, v17.B * 255 + 0.5), (v1.FormatKg(v16))))
end

function v1.Label(v18, v19) -- line 84 | captures: v1
    return (("%* %*"):format(v1.Tag(v18), v19))
end

return v1
