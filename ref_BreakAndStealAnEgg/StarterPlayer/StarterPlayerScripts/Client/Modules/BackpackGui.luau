-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local BackpackUiConfig = require(ReplicatedStorage.Shared.BackpackUiConfig)
local v1 = {}

function v1.IsMobile() -- line 26 | captures: UserInputService
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

function v1.Name() -- line 31 | captures: BackpackUiConfig, v1
    if v1.IsMobile() then
        return BackpackUiConfig.MobileGuiName
    end
    return BackpackUiConfig.GuiName
end

function v1.UnusedName() -- line 36 | captures: BackpackUiConfig, v1
    if v1.IsMobile() then
        return BackpackUiConfig.GuiName
    end
    return BackpackUiConfig.MobileGuiName
end

function v1.IsBackpackName(v2) -- line 41 | captures: BackpackUiConfig
    if v2 == BackpackUiConfig.GuiName then
        return true
    end
    return v2 == BackpackUiConfig.MobileGuiName
end

return v1
