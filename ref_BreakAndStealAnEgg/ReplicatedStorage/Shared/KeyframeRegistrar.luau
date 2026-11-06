-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local AnimationClipProvider = game:GetService("AnimationClipProvider")
local RunService = game:GetService("RunService")
local v1 = {}
local v2 = not RunService:IsStudio()
local v3 = false
local v4 = 0

function v1.IsBlocked() -- line 54 | captures: v2
    return v2
end

local function latchBlocked() -- line 58 | captures: v2, v3
    v2 = true
    if not v3 then
        v3 = true
        warn("[KeyframeRegistrar] RegisterKeyframeSequence is unavailable in this session (engine restriction). Runtime keyframe animations are off; anything that needs to animate must use an uploaded Animation asset. Silencing further reports.")
    end
end

function v1.Register(v5) -- line 76 | captures: v2, v3, v4, AnimationClipProvider
    if not v2 then
        for v6 = 1, 4 do
            local v7 = os.clock()
            local v8 = v4 + 0.08
            local v9 = math.max(v8, v7)
            v4 = v9
            if v7 < v9 then
                task.wait(v9 - v7)
            end
            local v10, v11 = pcall(function() -- line 94 | captures: v5, AnimationClipProvider
                return AnimationClipProvider:RegisterAnimationClip(v5)
            end)
            local v12
            if v10 then
                if type(v11) == "string" and v11 ~= "" then
                    return v11
                end
                v12 = true
            elseif type(v11) == "string" and string.find(v11, "can only be called in Studio", 1, true) then
                v2 = true
                if not v3 then
                    v3 = true
                    warn("[KeyframeRegistrar] RegisterKeyframeSequence is unavailable in this session (engine restriction). Runtime keyframe animations are off; anything that needs to animate must use an uploaded Animation asset. Silencing further reports.")
                end
                v12 = false
            else
                v12 = true
            end
            if not v12 then
                return nil
            end
            if v6 < 4 then
                task.wait(v6 * 0.08)
            end
        end
    end
    return nil
end

return v1
