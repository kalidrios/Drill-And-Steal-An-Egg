-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = { "Frames", "Shop", "ScrollingFrame", "EggsPack", "Inner" }

local function at(...) -- line 30 | captures: v1
    local v2 = table.clone(v1)
    for v3, v4 in { ... } do
        table.insert(v2, v4)
    end
    return v2
end

return {
    Targets = {
        {
            Image = nil,
            Path = at("Icon")
        },
        {
            Image = 103117463424248,
            Path = at("AnimalsDisplay", "Animal2", "AnimalDisplay")
        },
        {
            Image = 103117463424248,
            Path = at("AnimalsDisplay", "Animal3", "AnimalDisplay")
        },
        {
            Image = 118019174054397,
            Path = at("AnimalsDisplay", "Animal4", "AnimalDisplay")
        },
        {
            Image = 126326375098060,
            Path = at("AnimalsDisplay", "Animal5", "AnimalDisplay")
        },
        {
            Image = 85126398493114,
            Path = at("AnimalsDisplay", "Animal6", "AnimalDisplay")
        },
        {
            Image = 83672558694047,
            Path = at("AnimalsDisplay", "Animal7", "AnimalDisplay")
        },
        {
            Image = 135398584511952,
            Path = at("AnimalsDisplay", "Animal8", "AnimalDisplay")
        }
    }
}
