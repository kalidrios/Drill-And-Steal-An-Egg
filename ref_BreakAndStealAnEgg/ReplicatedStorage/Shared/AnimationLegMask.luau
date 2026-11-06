-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local AnimationClipProvider = game:GetService("AnimationClipProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local KeyframeRegistrar = require(ReplicatedStorage.Shared.KeyframeRegistrar)
local v1 = { StrippedAttribute = "NoLegs" }
local v2 = {
    LeftUpperLeg = true,
    RightUpperLeg = true,
    ["Left Leg"] = true,
    ["Right Leg"] = true
}

local function isJointNode(v3) -- line 55
    return v3:IsA("Pose") or v3:IsA("Folder")
end

function v1.StripSequence(v4) -- line 62 | captures: v2
    local v5 = 0
    for v6, v7 in v4:GetDescendants() do
        if (v7:IsA("Pose") or v7:IsA("Folder")) and v2[v7.Name] and v7.Parent then
            for v8, v9 in v7:GetDescendants() do
                if v9:IsA("Pose") or v9:IsA("Folder") then
                    v5 += 1
                end
            end
            v5 += 1
            v7:Destroy()
        end
    end
    return v5
end

v1.UpperBodyAttribute = "UpperBodyOnly"

local v10 = {
    HumanoidRootPart = true,
    Head = true,
    LowerTorso = true,
    Torso = true
}

function v1.MaskUpperBodySequence(v11) -- line 113 | captures: v1, v10
    local v12 = v1.StripSequence(v11)
    for v13, v14 in v11:GetDescendants() do
        if v10[v14.Name] then
            if v14:IsA("Pose") then
                v14.Weight = 0
            elseif v14:IsA("Folder") then
                for v15, v16 in v14:GetChildren() do
                    if not v16:IsA("Folder") then
                        v16:Destroy()
                    end
                end
            end
        end
    end
    return v12
end

local v17 = {}
local v18 = {}
local v19 = {}
local v20 = {}

local function buildMasked(v21, v22, v23, v24, v25, v26) -- line 142 | captures: AnimationClipProvider, KeyframeRegistrar
    local AnimationId = v21.AnimationId
    if AnimationId ~= "" then
        local v27 = v24[AnimationId]
        if v27 then
            return v27
        end
        if not v25[AnimationId] then
            if KeyframeRegistrar.IsBlocked() then
                v25[AnimationId] = true
            else
                local v28, v29 = pcall(function() -- line 171 | captures: v26, AnimationId, AnimationClipProvider
                    local v30 = AnimationClipProvider:GetAnimationClipAsync(AnimationId)
                    v26(v30)
                    return v30
                end)
                if v28 then
                    local v31 = KeyframeRegistrar.Register(v29)
                    if v31 == nil then
                        v25[AnimationId] = true
                        if not KeyframeRegistrar.IsBlocked() then
                            warn((("AnimationLegMask: could not register masked %* (%*), playing it as-is"):format(v21.Name, AnimationId)))
                        end
                        return v21
                    end
                    local Animation = Instance.new("Animation")
                    Animation.Name = v22 or v21.Name .. v23
                    Animation.AnimationId = v31
                    v24[AnimationId] = Animation
                    return Animation
                end
                v25[AnimationId] = true
                warn((("AnimationLegMask: could not fetch/mask %* (%*), playing it as-is: %*"):format(v21.Name, AnimationId, v29)))
            end
        end
    end
    return v21
end

function v1.Get(v32, v33) -- line 208 | captures: v1, v17, v18, buildMasked
    if v32:GetAttribute(v1.StrippedAttribute) == true then
        return v32
    end
    return (buildMasked(v32, v33, "_NoLegs", v17, v18, v1.StripSequence))
end

function v1.GetUpperBody(v34, v35) -- line 223 | captures: v1, v19, v20, buildMasked
    if v34:GetAttribute(v1.UpperBodyAttribute) == true then
        return v34
    end
    return (buildMasked(v34, v35, "_UpperBody", v19, v20, v1.MaskUpperBodySequence))
end

return v1
