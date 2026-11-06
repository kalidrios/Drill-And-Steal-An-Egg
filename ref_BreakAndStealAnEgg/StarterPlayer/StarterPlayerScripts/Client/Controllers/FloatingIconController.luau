-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FloatingIconConfig = require(ReplicatedStorage.Shared.FloatingIconConfig)
local FloatingIconFX = require(script.Parent.Parent.Modules.FloatingIconFX)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {}

local function resolve(v2, v3) -- line 27
    local v4 = v2
    for v5, v6 in v3 do
        v4 = v4 and v4:FindFirstChild(v6)
        if not v4 then
            return nil
        end
    end
    if not (v4 and v4:IsA("GuiButton")) then
        return nil
    end
    return v4
end

local function bind(v7) -- line 41 | captures: FloatingIconConfig, FloatingIconFX, resolve
    for v8, v9 in FloatingIconConfig.Targets do
        local v10 = resolve(v7, v9.Path)
        if v10 then
            FloatingIconFX.Attach(v10, v9.Style)
        else
            warn((("[FloatingIconController] missing MainGUI.%*"):format((table.concat(v9.Path, ".")))))
        end
    end
end

function v1.Start() -- line 52 | captures: MainGui, bind
    MainGui.Observe(bind)
end

return v1
