-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShopRendersConfig = require(ReplicatedStorage.Shared.ShopRendersConfig)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {}

local function resolve(v2, v3) -- line 21
    local v4 = v2
    for v5, v6 in v3 do
        v4 = v4 and v4:FindFirstChild(v6)
    end
    return v4
end

local function setRender(v7, v8) -- line 29
    v7.ScaleType = Enum.ScaleType.Fit
    v7.Image = v8
end

local function bind(v9) -- line 34 | captures: ShopRendersConfig
    for v10, v11 in ShopRendersConfig.Targets do
        local v12 = v9
        for v13, v14 in v11.Path do
            v12 = v12 and v12:FindFirstChild(v14)
        end
        if v12 and v12:IsA("ImageLabel") then
            if v11.Image then
                local v15 = ("rbxassetid://%*"):format(v11.Image)
                v12.ScaleType = Enum.ScaleType.Fit
                v12.Image = v15
                for v16, v17 in v12:GetDescendants() do
                    if v17:IsA("ImageLabel") then
                        v17.ScaleType = Enum.ScaleType.Fit
                        v17.Image = v15
                    end
                end
            end
        else
            warn((("[ShopRendersController] missing ImageLabel MainGUI.%*"):format((table.concat(v11.Path, ".")))))
        end
    end
end

function v1.Start() -- line 54 | captures: MainGui, bind
    MainGui.Observe(bind)
end

return v1
