-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuardSfx = require(ReplicatedStorage.Shared.GuardSfx)
local GuardSfxConfig = require(ReplicatedStorage.Shared.GuardSfxConfig)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = Random.new()
local v3 = {}

local function zoneOf(v4) -- line 79
    return (v4:GetAttribute("ZoneId"))
end

local function takeCooldown(v5, v6) -- line 95 | captures: GuardSfxConfig
    local v7 = os.clock()
    if v7 - (v5.LastCueAt[v6] or 0) < GuardSfxConfig.Cooldown then
        return false
    end
    v5.LastCueAt[v6] = v7
    return true
end

local function scheduleChaseRoar(v8) -- line 104 | captures: GuardSfxConfig, v2
    v8.NextChaseRoarAt = os.clock() + v2:NextNumber(GuardSfxConfig.ChaseRoarMin, GuardSfxConfig.ChaseRoarMax)
end

local function onStateChanged(v9) -- line 109 | captures: GuardSfx, GuardSfxConfig, v2, v3
    local v10 = v3[v9]
    if v10 then
        local ChaseState = v9:GetAttribute("ChaseState")
        if ChaseState == "WindUp" then
            v10.Chasing = false
            local v11 = os.clock()
            if not (v11 - (v10.LastCueAt.Lock or 0) < GuardSfxConfig.Cooldown) then
                v10.LastCueAt.Lock = v11
                GuardSfx.PlayLock(v10.Voice)
            end
            v10.NextChaseRoarAt = os.clock() + v2:NextNumber(GuardSfxConfig.ChaseRoarMin, GuardSfxConfig.ChaseRoarMax)
        elseif ChaseState == "Chasing" then
            if not v10.Chasing then
                v10.Chasing = true
                if v10.NextChaseRoarAt == 0 then
                    v10.NextChaseRoarAt = os.clock() + v2:NextNumber(GuardSfxConfig.ChaseRoarMin, GuardSfxConfig.ChaseRoarMax)
                end
            end
        else
            v10.Chasing = false
            v10.NextChaseRoarAt = 0
        end
    end
end

local function onCatchPulse(v12) -- line 143 | captures: GuardSfx, GuardSfxConfig, LocalPlayer, v3
    local v13 = v3[v12]
    if v13 then
        local v14 = v12:GetAttribute("CatchPulse") or 0
        if v14 ~= v13.LastCatchPulse then
            v13.LastCatchPulse = v14
            v13.Chasing = false
            v13.NextChaseRoarAt = 0
            GuardSfx.Stop(v13.Voice)
            local v15 = os.clock()
            if not (v15 - (v13.LastCueAt.Catch or 0) < GuardSfxConfig.Cooldown) then
                v13.LastCueAt.Catch = v15
                if v12:GetAttribute("CaughtUserId") == LocalPlayer.UserId then
                    GuardSfx.PlayCatch2D((v12:GetAttribute("ZoneId")))
                else
                    GuardSfx.PlayCatch(v13.Voice)
                end
            end
        end
    end
end

local function attachVoice(v16) -- line 193 | captures: GuardSfx
    for v17 = 1, 10 do
        if v16.Parent then
            local v18 = GuardSfx.Attach(v16, (v16:GetAttribute("ZoneId")))
            if v18 then
                return v18
            end
            if v17 < 10 then
                task.wait(0.5)
            end
        else
            return nil
        end
    end
    warn((("[GuardRoarController] %* has no part to roar from \226\128\148 no voice attached"):format(v16.Name)))
    return nil
end

local function trackGuard(v19) -- line 210 | captures: CollectionService, GuardSfx, GuardSfxConfig, v2, v3, onStateChanged, onCatchPulse, attachVoice
    local function v20(v21, ...)
        table.insert(v21, ...)
    end

    local function v22(v23, ...)
        table.insert(v23, ...)
    end

    if v19:IsA("Model") and not v3[v19] then
        local v24 = attachVoice(v19)
        if v24 then
            local v25
            if v19.Parent then
                if v3[v19] then
                    v25 = true
                elseif CollectionService:HasTag(v19, "ZoneGuard") then
                    local v26 = {
                        NextChaseRoarAt = 0,
                        Chasing = false,
                        Voice = v24,
                        Connections = {},
                        LastCueAt = {},
                        LastCatchPulse = v19:GetAttribute("CatchPulse") or 0
                    }
                    v3[v19] = v26
                    v20(v26.Connections, v19:GetAttributeChangedSignal("ChaseState"):Connect(function() -- line 241 | captures: v19, onStateChanged
                        onStateChanged(v19)
                    end))
                    v22(v26.Connections, v19:GetAttributeChangedSignal("CatchPulse"):Connect(function() -- line 247 | captures: v19, onCatchPulse
                        onCatchPulse(v19)
                    end))
                    local ChaseState = v19:GetAttribute("ChaseState")
                    if ChaseState == "Chasing" or ChaseState == "WindUp" then
                        v26.Chasing = ChaseState == "Chasing"
                        v26.NextChaseRoarAt = os.clock() + v2:NextNumber(GuardSfxConfig.ChaseRoarMin, GuardSfxConfig.ChaseRoarMax)
                    end
                    v25 = false
                else
                    v25 = true
                end
            else
                v25 = true
            end
            if not v25 then
                return
            end
            GuardSfx.Detach(v24)
        end
    end
end

local function untrackGuard(v27) -- line 262 | captures: GuardSfx, v3
    local v28 = v3[v27]
    if not v28 then
        return
    end
    v3[v27] = nil
    for v29, v30 in v28.Connections do
        v30:Disconnect()
    end
    table.clear(v28.Connections)
    GuardSfx.Detach(v28.Voice)
end

function v1.Start() -- line 275 | captures: CollectionService, RunService, GuardSfx, GuardSfxConfig, v2, v3, trackGuard, untrackGuard
    for v31, v32 in CollectionService:GetTagged("ZoneGuard") do
        task.spawn(trackGuard, v32)
    end
    CollectionService:GetInstanceAddedSignal("ZoneGuard"):Connect(function(v33) -- line 282 | captures: trackGuard
        task.spawn(trackGuard, v33)
    end)
    CollectionService:GetInstanceRemovedSignal("ZoneGuard"):Connect(untrackGuard)
    local v34 = 0
    RunService.Heartbeat:Connect(function(v35) -- line 291 | captures: v34, GuardSfx, GuardSfxConfig, v2, v3
        v34 += v35
        if v34 < 0.25 then
            return
        end
        v34 = 0
        local v36 = os.clock()
        for v37, v38 in v3 do
            if v38.Chasing and v38.NextChaseRoarAt ~= 0 and not (v36 < v38.NextChaseRoarAt) then
                v38.NextChaseRoarAt = os.clock() + v2:NextNumber(GuardSfxConfig.ChaseRoarMin, GuardSfxConfig.ChaseRoarMax)
                if v37.Parent then
                    local v39 = os.clock()
                    if not (v39 - (v38.LastCueAt.Chase or 0) < GuardSfxConfig.Cooldown) then
                        v38.LastCueAt.Chase = v39
                        GuardSfx.PlayChase(v38.Voice)
                    end
                end
            end
        end
    end)
end

return v1
