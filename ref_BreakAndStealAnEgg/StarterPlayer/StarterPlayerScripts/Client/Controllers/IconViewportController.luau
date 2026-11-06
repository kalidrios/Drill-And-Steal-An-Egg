-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local IconViewportConfig = require(ReplicatedStorage.Shared.IconViewportConfig)
local IconViewport = require(script.Parent.Parent.Modules.IconViewport)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {}

local function resolve(v2, v3, v4) -- line 24
    local v5 = v2
    for v6, v7 in v3 do
        if v5 then
            if v4 then
                v5 = v5:WaitForChild(v7, v4)
            else
                v5 = v5:FindFirstChild(v7)
            end
        else
            return nil
        end
    end
    return v5
end

local function bind(v8) -- line 35 | captures: ReplicatedStorage, IconViewportConfig, IconViewport, resolve
    for v9, v10 in IconViewportConfig.Targets do
        local v11 = ("MainGUI.%*"):format((table.concat(v10.Path, ".")))
        local v12 = resolve(v8, v10.Path)
        if v12 and v12:IsA("ViewportFrame") then
            local v13 = resolve(ReplicatedStorage, v10.Model, 30)
            if v13 and v13:IsA("Model") then
                if v12:IsDescendantOf(game) then
                    IconViewport.Mount(v12, v13, v10)
                end
            else
                warn((("[IconViewportController] missing model ReplicatedStorage.%* for %*"):format(table.concat(v10.Model, "."), v11)))
            end
        else
            warn((("[IconViewportController] missing ViewportFrame %*"):format(v11)))
        end
    end
end

function v1.Start() -- line 55 | captures: MainGui, bind
    MainGui.Observe(bind)
end

return v1
