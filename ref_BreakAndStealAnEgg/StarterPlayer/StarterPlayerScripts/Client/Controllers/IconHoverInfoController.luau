-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local IconHoverInfoConfig = require(ReplicatedStorage.Shared.IconHoverInfoConfig)
local PotionInfoController = require(script.Parent.PotionInfoController)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {}

local function resolve(v2, v3) -- line 25
    local v4 = v2
    for v5, v6 in v3 do
        v4 = v4 and v4:FindFirstChild(v6)
        if not v4 then
            return nil
        end
    end
    if not (v4 and v4:IsA("GuiObject")) then
        return nil
    end
    return v4
end

local function bind(v7) -- line 39 | captures: EggRewards, IconHoverInfoConfig, PotionInfoController, resolve
    for v8, v9 in IconHoverInfoConfig.Targets do
        local v10 = resolve(v7, v9.Path)
        if v10 then
            local v11 = v9.Animal and EggRewards.RarityOf(v9.Animal) or v9.Rarity
            PotionInfoController.BindInfo(v10, {
                Title = v9.Title,
                Info = v11 or "",
                Rarity = v11
            })
        else
            warn((("[IconHoverInfoController] missing MainGUI.%*"):format((table.concat(v9.Path, ".")))))
        end
    end
end

function v1.Start() -- line 55 | captures: MainGui, bind
    MainGui.Observe(bind)
end

return v1
