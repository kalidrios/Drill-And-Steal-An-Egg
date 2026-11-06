-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1
for v2, v3 in script:WaitForChild("Controllers"):GetChildren() do
    if v3:IsA("ModuleScript") then
        local v4
        v4, v1 = pcall(require, v3)
        if v4 then
            if type(v1) == "table" then
                local Start = v1.Start
                if type(Start) == "function" then
                    local spawn = task.spawn
                    local v5 = v3
                    spawn(function() -- line 17 | captures: v1, v5
                        local v6, v7 = pcall(v1.Start)
                        if not v6 then
                            warn((("[client] %*.Start errored: %*"):format(v5.Name, v7)))
                        end
                    end)
                end
            end
        else
            warn((("[client] failed to REQUIRE %*: %*"):format(v3.Name, v1)))
        end
    end
end
