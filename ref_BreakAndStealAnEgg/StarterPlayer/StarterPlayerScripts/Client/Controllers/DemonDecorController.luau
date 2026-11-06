-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DemonEventUIConfig = require(ReplicatedStorage.Shared.DemonEventUIConfig)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local DecorLoop = require(script.Parent.Parent.Modules.DemonEventUI.DecorLoop)
local v1 = {}

local function resolve(v2, v3) -- line 22
    local v4 = v2
    for v5, v6 in v3 do
        v4 = v4 and v4:FindFirstChild(v6)
    end
    return v4
end

local function bind(v7) -- line 30 | captures: DemonEventUIConfig, DecorLoop
    for v8, v9 in DemonEventUIConfig.DECOR_LOOPS or {} do
        local v10 = v7
        for v11, v12 in v9.Path do
            v10 = v10 and v10:FindFirstChild(v12)
        end
        if v10 and v10:IsA("GuiObject") then
            local v13, v14 = pcall(DecorLoop.new, v10, v9)
            if not v13 then
                warn((("[DemonDecorController] MainGUI.%*: %*"):format(table.concat(v9.Path, "."), v14)))
            end
        else
            warn((("[DemonDecorController] missing MainGUI.%*"):format((table.concat(v9.Path, ".")))))
        end
    end
end

function v1.Start() -- line 44 | captures: MainGui, bind
    MainGui.Observe(bind)
end

return v1
