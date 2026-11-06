-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

if not game then
    script = nil
end

local function read(v1) -- line 3
    if type(v1) == "function" then
        return (v1())
    end
    return v1
end

return read
