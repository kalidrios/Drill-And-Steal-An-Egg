-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

return {
    Set = function(v1, v2) -- Set | line 18
        v1.Text = v2
        for v3, v4 in v1:GetDescendants() do
            if v4:IsA("TextLabel") then
                v4.Text = v2
            end
        end
    end
}
