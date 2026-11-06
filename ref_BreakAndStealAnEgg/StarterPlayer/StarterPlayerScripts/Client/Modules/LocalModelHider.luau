-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = {}

local function isEffect(v3) -- line 61
    return v3:IsA("ParticleEmitter") or v3:IsA("Beam") or v3:IsA("Trail") or v3:IsA("Light") or v3:IsA("Fire") or v3:IsA("Smoke") or v3:IsA("Sparkles")
end

local function hideEffect(v4, v5) -- line 71
    local function v6(v7, ...)
        table.insert(v7, ...)
    end

    if v4.effectSaved[v5] ~= nil then
        return
    end
    v4.effectSaved[v5] = v5.Enabled
    v5.Enabled = false
    if v5:IsA("ParticleEmitter") then
        v5:Clear()
    end
    v6(v4.effectConns, v5:GetPropertyChangedSignal("Enabled"):Connect(function() -- line 84 | captures: v4, v5
        if v5.Enabled then
            v4.effectSaved[v5] = true
            v5.Enabled = false
        end
    end))
end

local function hideDescendant(v8, v9) -- line 92 | captures: LocalPlayer, isEffect, hideEffect
    if isEffect(v9) then
        hideEffect(v8, v9)
    elseif v9:IsA("BasePart") or v9:IsA("Decal") then
        v9.LocalTransparencyModifier = 1
    elseif v9:IsA("BillboardGui") then
        if v8.billboardSaved[v9] == nil then
            v8.billboardSaved[v9] = v9.PlayerToHideFrom or false
        end
        v9.PlayerToHideFrom = LocalPlayer
    elseif v9:IsA("SurfaceGui") or v9:IsA("Highlight") then
        if v8.enabledSaved[v9] == nil then
            v8.enabledSaved[v9] = v9.Enabled
        end
        v9.Enabled = false
    end
end

local function disconnectEffects(v10) -- line 112
    for v11, v12 in v10.effectConns do
        v12:Disconnect()
    end
    table.clear(v10.effectConns)
end

function v1.IsHidden(v13, v14) -- line 120 | captures: v2
    local v15 = v2[v13]
    if v15 == nil then
        return false
    end
    if v14 == nil then
        return true
    end
    return v15.reasons[v14] == true
end

function v1.Hide(v16, v17) -- line 128 | captures: v1, v2, hideDescendant
    local v18 = v17 or "Settings"
    local v19 = v2[v16]
    if v19 then
        v19.reasons[v18] = true
    else
        local v20 = {
            reasons = { [v18] = true },
            billboardSaved = {},
            enabledSaved = {},
            effectSaved = {},
            effectConns = {}
        }
        v2[v16] = v20
        for v21, v22 in v16:GetDescendants() do
            hideDescendant(v20, v22)
        end
        local DescendantAdded = v16.DescendantAdded
        v20.conn = DescendantAdded:Connect(function(v23) -- line 146 | captures: v20, hideDescendant
            hideDescendant(v20, v23)
        end)
        local Destroying = v16.Destroying
        v20.destroyConn = Destroying:Once(function() -- line 152 | captures: v16, v1
            v1.Forget(v16)
        end)
    end
end

function v1.Show(v24, v25) -- line 157 | captures: LocalPlayer, v2
    local v26 = v2[v24]
    if v26 ~= nil then
        v26.reasons[v25 or "Settings"] = nil
        if next(v26.reasons) == nil then
            v2[v24] = nil
            v26.conn:Disconnect()
            v26.destroyConn:Disconnect()
            for v27, v28 in v24:GetDescendants() do
                if v28:IsA("BasePart") or v28:IsA("Decal") then
                    v28.LocalTransparencyModifier = 0
                end
            end
            for v29, v30 in v26.billboardSaved do
                if v29.Parent and v29.PlayerToHideFrom == LocalPlayer then
                    if v30 == false then
                        v29.PlayerToHideFrom = nil
                    else
                        v29.PlayerToHideFrom = v30
                    end
                end
            end
            for v31, v32 in v26.enabledSaved do
                if v31.Parent then
                    v31.Enabled = v32
                end
            end
            for v33, v34 in v26.effectConns do
                v34:Disconnect()
            end
            table.clear(v26.effectConns)
            for v35, v36 in v26.effectSaved do
                if v35.Parent then
                    v35.Enabled = v36
                end
            end
        end
    end
end

function v1.Forget(v37) -- line 196 | captures: v2
    local v38 = v2[v37]
    if not v38 then
        return
    end
    v2[v37] = nil
    v38.conn:Disconnect()
    v38.destroyConn:Disconnect()
    for v39, v40 in v38.effectConns do
        v40:Disconnect()
    end
    table.clear(v38.effectConns)
end

return v1
