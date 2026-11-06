-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SurfacePrompt = require(ReplicatedStorage.Shared.SurfacePrompt)
local v1 = {}
local v2 = {}

local function setupPrompt(v3) -- line 20 | captures: SurfacePrompt, v2
    local Parent, v4
    if v3:IsA("ProximityPrompt") then
        if v2[v3] then
            v4 = true
        else
            Parent = v3.Parent
            if Parent and Parent:IsA("BasePart") and Parent.Parent and Parent.Parent:IsA("Model") then
                Parent = Parent.Parent
            end
            v4 = false
        end
    else
        v4 = true
    end
    if v4 then
        return
    end
    if not Parent or not Parent:IsA("Model") and not Parent:IsA("BasePart") then
        return
    end
    local PromptRange = v3:GetAttribute("PromptRange")
    local Attach = SurfacePrompt.Attach
    local v5 = {
        SurfaceOffset = 1,
        FollowSpeed = 16
    }
    if typeof(PromptRange) ~= "number" then
        PromptRange = nil
    end
    v5.MaxActivationDistance = PromptRange
    v2[v3] = Attach(v3, Parent, v5)
end

function v1.Start() -- line 47 | captures: CollectionService, v2, setupPrompt
    for v6, v7 in CollectionService:GetTagged("SmartPrompt") do
        setupPrompt(v7)
    end
    CollectionService:GetInstanceAddedSignal("SmartPrompt"):Connect(setupPrompt)
    CollectionService:GetInstanceRemovedSignal("SmartPrompt"):Connect(function(v8) -- line 52 | captures: v2
        local v9 = v2[v8]
        if v9 then
            v2[v8] = nil
            v9()
        end
    end)
end

return v1
