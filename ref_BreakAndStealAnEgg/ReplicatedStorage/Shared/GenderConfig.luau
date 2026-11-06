-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    Attribute = "Gender",
    Genders = {
        Male = { Icon = "rbxassetid://82617224186977" },
        Female = { Icon = "rbxassetid://84436140548396" }
    }
}

function v1.Icon(v2) -- line 27 | captures: v1
    local v3 = v2 and v1.Genders[v2]
    return v3 and v3.Icon
end

local function Roll(v4) -- line 33
    local v5 = if v4 then v4:NextInteger(0, 1) == 1 else math.random(0, 1) == 1
    if v5 then
        return "Male"
    end
    return "Female"
end

v1.Roll = Roll

function v1.Ensure(v6, v7) -- line 41 | captures: v1
    local Gender = v6.Gender
    if not v1.Genders[Gender] then
        Gender = v1.Roll(v7)
        v6.Gender = Gender
    end
    return Gender
end

return v1
