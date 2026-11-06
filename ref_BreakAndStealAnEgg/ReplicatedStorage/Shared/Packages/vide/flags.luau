-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local function inline_test() -- line 1
    return debug.info(1, "n")
end

return {
    batch = false,
    strict = debug.info(1, "n") == "inline_test"
}
