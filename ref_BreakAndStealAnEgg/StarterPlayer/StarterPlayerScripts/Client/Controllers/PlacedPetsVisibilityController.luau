-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local LocalModelHider = require(script.Parent.Parent.Modules.LocalModelHider)
local SettingsState = require(script.Parent.Parent.Modules.SettingsState)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = {}
local v3

local function baseOf(v4) -- line 45
    local Parent = v4.Parent
    return Parent and Parent.Parent
end

local function isMine(v5) -- line 50 | captures: LocalPlayer
    local Parent = v5.Parent
    local v6 = Parent and Parent.Parent
    if v6 == nil then
        return false
    end
    return v6:GetAttribute("OwnerUserId") == LocalPlayer.UserId
end

local function watchBase(v7) -- line 56 | captures: v3, v2
    local Parent = v7.Parent
    local v8 = Parent and Parent.Parent
    if not (v8 ~= nil) or v2[v8] then
        return
    end
    v2[v8] = true
    v8:GetAttributeChangedSignal("OwnerUserId"):Connect(function() -- line 62 | captures: v3
        v3()
    end)
    v8.Destroying:Connect(function() -- line 65 | captures: v8, v2
        v2[v8] = nil
    end)
end

local function evaluate(v9) -- line 70 | captures: LocalModelHider, SettingsState, LocalPlayer
    local Parent = v9.Parent
    local v10 = Parent and Parent.Parent
    local v11 = if v10 ~= nil and v10:GetAttribute("OwnerUserId") == LocalPlayer.UserId then "ViewMyPets" else "ViewOthersPets"
    if SettingsState.Get(v11) == true then
        LocalModelHider.Show(v9)
    else
        LocalModelHider.Hide(v9)
    end
end

function v3() -- line 79 | captures: CollectionService, LocalModelHider, SettingsState, LocalPlayer
    for v12, v13 in CollectionService:GetTagged("PlacedAnimal") do
        if v13:IsA("Model") then
            local Parent = v13.Parent
            local v14 = Parent and Parent.Parent
            local v15 = if v14 ~= nil and v14:GetAttribute("OwnerUserId") == LocalPlayer.UserId then "ViewMyPets" else "ViewOthersPets"
            if SettingsState.Get(v15) == true then
                LocalModelHider.Show(v13)
            else
                LocalModelHider.Hide(v13)
            end
        end
    end
end

function v1.Start() -- line 87 | captures: v3, CollectionService, LocalModelHider, SettingsState, LocalPlayer, watchBase
    CollectionService:GetInstanceAddedSignal("PlacedAnimal"):Connect(function(v16) -- line 88 | captures: LocalModelHider, SettingsState, LocalPlayer, watchBase
        if not v16:IsA("Model") then
            return
        end
        watchBase(v16)
        local Parent = v16.Parent
        local v17 = Parent and Parent.Parent
        local v18 = if v17 ~= nil and v17:GetAttribute("OwnerUserId") == LocalPlayer.UserId then "ViewMyPets" else "ViewOthersPets"
        if SettingsState.Get(v18) == true then
            LocalModelHider.Show(v16)
        else
            LocalModelHider.Hide(v16)
        end
    end)
    CollectionService:GetInstanceRemovedSignal("PlacedAnimal"):Connect(function(v19) -- line 94 | captures: LocalModelHider
        if v19:IsA("Model") then
            LocalModelHider.Show(v19)
        end
    end)
    for v20, v21 in CollectionService:GetTagged("PlacedAnimal") do
        if v21:IsA("Model") then
            watchBase(v21)
        end
    end
    SettingsState.Observe("ViewOthersPets", function() -- line 108 | captures: v3
        v3()
    end)
    SettingsState.Observe("ViewMyPets", function() -- line 111 | captures: v3
        v3()
    end)
end

return v1
