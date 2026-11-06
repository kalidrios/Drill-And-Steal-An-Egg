-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local MutationConfig = require(script.Parent.MutationConfig)
local v1 = { RowName = "Mutation" }
local v2 = Color3.new(1, 1, 1)

function v1.Fill(v3, v4, v5) -- line 24 | captures: MutationConfig, v1, v2
    local v6 = v3:FindFirstChild(v1.RowName, true)
    if v6 and v6:IsA("TextLabel") then
        for v7, v8 in v6:GetChildren() do
            if v8:IsA("UIGradient") then
                v8.Enabled = v8.Name == v4
            end
        end
        if v4 then
            v6.Text = v4
            v6.TextColor3 = v2
            v6.Visible = true
        else
            local v9, v10
            if v5 then
                local v11 = MutationConfig.Get(v5)
                if v11 then
                    v6.Text = v5
                    v9 = v11.Color or v2
                    v10 = false
                else
                    v10 = true
                end
            else
                v10 = true
            end
            if not v10 then
                v6.TextColor3 = v9
                v6.Visible = true
            else
                v6.Visible = false
            end
        end
    end
end

return v1
