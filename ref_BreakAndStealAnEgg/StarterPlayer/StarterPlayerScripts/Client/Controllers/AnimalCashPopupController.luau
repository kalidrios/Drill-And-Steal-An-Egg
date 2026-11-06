-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local AnimalCashPopup = require(ReplicatedStorage.Shared.AnimalCashPopup)
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local SafeZoneQuery = require(ReplicatedStorage.Shared.SafeZoneQuery)
local LocalCharacter = require(script.Parent.Parent.Modules.LocalCharacter)
local LocalModelHider = require(script.Parent.Parent.Modules.LocalModelHider)
local v1 = {}
local v2 = Random.new()
local LocalPlayer = Players.LocalPlayer
local v3 = {}

local function resolveHitbox(v4) -- line 93
    local Parent = v4.Parent
    local v5
    if Parent and Parent.Name == "PlacedAnimals" then
        local Parent_2 = Parent.Parent
        v5 = Parent_2 and Parent_2:FindFirstChild("Hitbox")
    else
        return nil
    end
    if not (v5 and v5:IsA("BasePart")) then
        return nil
    end
    return v5
end

local function resolveOwn(v6) -- line 107 | captures: LocalPlayer
    local OwnerUserId = v6:GetAttribute("OwnerUserId")
    if typeof(OwnerUserId) == "number" then
        return OwnerUserId == LocalPlayer.UserId
    end
    return nil
end

local function track(v7) -- line 115 | captures: v2, LocalPlayer, v3
    local v8, Parent, v9
    if v7:IsA("Model") then
        if v3[v7] then
            v9 = true
        else
            v8 = {
                Accum = 0,
                Cps = nil,
                CpsConn = nil,
                Scale = nil,
                HeadHeight = nil,
                SideReach = nil,
                HeadAt = 0,
                Model = v7
            }
            local Parent_2 = v7.Parent
            if Parent_2 and Parent_2.Name == "PlacedAnimals" then
                Parent = Parent_2.Parent
                if Parent then
                    Parent = Parent:FindFirstChild("Hitbox")
                    if Parent then
                        if not Parent:IsA("BasePart") then
                            Parent = nil
                        end
                    else
                        Parent = nil
                    end
                else
                    Parent = nil
                end
            end
            v9 = false
        end
    else
        v9 = true
    end
    if v9 then
        return
    end
    v8.Hitbox = Parent
    local OwnerUserId = v7:GetAttribute("OwnerUserId")
    if typeof(OwnerUserId) == "number" then
        v8.Own = OwnerUserId == LocalPlayer.UserId
    else
        v8.Own = nil
    end
    v8.NextAt = os.clock() + v2:NextNumber(0, 1)
    local CashPerSecond = v7:GetAttribute("CashPerSecond")
    if typeof(CashPerSecond) ~= "number" then
        CashPerSecond = nil
    end
    v8.Cps = CashPerSecond
    local CashPerSecond_2 = v7:GetAttributeChangedSignal("CashPerSecond")
    local v10 = v8
    v8.CpsConn = CashPerSecond_2:Connect(function() -- line 140 | captures: v7, v10
        local CashPerSecond = v7:GetAttribute("CashPerSecond")
        if typeof(CashPerSecond) ~= "number" then
            CashPerSecond = nil
        end
        v10.Cps = CashPerSecond
    end)
    v3[v7] = v8
end

local function untrack(v11) -- line 147 | captures: v3
    local v12
    if v11:IsA("Model") then
        local v13 = v3[v11]
        if v13 then
            if v13.CpsConn then
                v13.CpsConn:Disconnect()
            end
            v12 = false
        else
            v12 = true
        end
    else
        v12 = true
    end
    if not v12 then
        v3[v11] = nil
    end
end

local function cashPerSecond(v14) -- line 159
    local CashPerSecond = v14:GetAttribute("CashPerSecond")
    if typeof(CashPerSecond) == "number" then
        return CashPerSecond
    end
    return 0
end

local function popupScale(v15) -- line 171 | captures: EggRewards
    local AnimalName = v15:GetAttribute("AnimalName")
    local WeightKg = v15:GetAttribute("WeightKg")
    local SizeMult = v15:GetAttribute("SizeMult")
    local SizeCap = v15:GetAttribute("SizeCap")
    local ScaleForWeight = EggRewards.ScaleForWeight
    if typeof(AnimalName) ~= "string" then
        AnimalName = nil
    end
    if typeof(WeightKg) ~= "number" then
        WeightKg = nil
    end
    if typeof(SizeMult) ~= "number" then
        SizeMult = 1
    end
    if typeof(SizeCap) ~= "number" then
        SizeCap = nil
    end
    local v16 = ScaleForWeight(AnimalName, WeightKg, SizeMult, nil, SizeCap)
    local v17 = math.max(v16, 0)
    return (math.sqrt(v17))
end

function v1.Start() -- line 186 | captures: CollectionService, RunService, AnimalCashPopup, SafeZoneQuery, LocalCharacter, LocalModelHider, LocalPlayer, v3, track, untrack, popupScale
    for v18, v19 in CollectionService:GetTagged("PlacedAnimal") do
        track(v19)
    end
    CollectionService:GetInstanceAddedSignal("PlacedAnimal"):Connect(track)
    CollectionService:GetInstanceRemovedSignal("PlacedAnimal"):Connect(untrack)
    local v20 = {}
    local v21 = 0
    local v22 = 0
    RunService.Heartbeat:Connect(function(v23) -- line 210 | captures: v21, v22, v20, AnimalCashPopup, SafeZoneQuery, LocalCharacter, LocalModelHider, LocalPlayer, v3, popupScale
        local function v24(...)
            return (typeof(...))
        end

        v22 += v23
        if v22 < 0.1 then
            return
        end
        local v25 = v22
        v22 = 0
        local v26 = LocalCharacter.GetPosition()
        table.clear(v20)
        local v27 = os.clock()
        local v28 = v21 / 10
        local v29 = math.max(1, v28)
        local v30 = 0
        for v31, v32 in v3 do
            if v31.Parent then
                if LocalModelHider.IsHidden(v31) then
                    v32.Accum = 0
                    v32.NextAt = v27 + v29
                else
                    local Own = v32.Own
                    if Own == nil then
                        local OwnerUserId = v31:GetAttribute("OwnerUserId")
                        if typeof(OwnerUserId) == "number" then
                            Own = OwnerUserId == LocalPlayer.UserId
                        else
                            Own = nil
                        end
                        v32.Own = Own
                    end
                    if Own == true then
                        v30 += 1
                        local Cps = v32.Cps
                        if Cps == nil then
                            Cps = v31:GetAttribute("CashPerSecond")
                            if typeof(Cps) ~= "number" then
                                Cps = 0
                            end
                        end
                        v32.Accum += Cps * v25
                        if not (v27 < v32.NextAt) then
                            v32.NextAt = v27 + v29
                            if v32.Accum >= 1 then
                                local Accum = v32.Accum
                                v32.Accum = 0
                                local Scale = v32.Scale
                                if Scale == nil then
                                    Scale = popupScale(v31)
                                    if v24(v31:GetAttribute("AnimalName")) == "string" then
                                        v32.Scale = Scale
                                    end
                                end
                                local HeadHeight = v32.HeadHeight
                                if HeadHeight == nil or v32.HeadAt <= v27 then
                                    HeadHeight = AnimalCashPopup.HeadHeight(v31)
                                    v32.HeadHeight = HeadHeight
                                    v32.SideReach = AnimalCashPopup.SideReach(v31)
                                    v32.HeadAt = v27 + 3
                                end
                                local Play = AnimalCashPopup.Play
                                local v33 = {
                                    SizeMult = Scale,
                                    HeadHeight = HeadHeight
                                }
                                v33.SideReach = v32.SideReach
                                Play(v31, Accum, v33)
                            end
                        end
                    else
                        local Hitbox = v32.Hitbox
                        if not (Hitbox and Hitbox.Parent) then
                            local Parent = v31.Parent
                            if Parent and Parent.Name == "PlacedAnimals" then
                                Hitbox = Parent.Parent
                                Hitbox = Hitbox and Hitbox:FindFirstChild("Hitbox")
                                if Hitbox then
                                    if not Hitbox:IsA("BasePart") then
                                        Hitbox = nil
                                    end
                                else
                                    Hitbox = nil
                                end
                            else
                                Hitbox = nil
                            end
                            v32.Hitbox = Hitbox
                        end
                        if Hitbox then
                            local v34 = v20[Hitbox]
                            if v34 == nil then
                                if v26 == nil then
                                    v34 = false
                                else
                                    v34 = SafeZoneQuery.IsPositionInPart(Hitbox, v26)
                                end
                                v20[Hitbox] = v34
                            end
                            if v34 then
                                v30 += 1
                                local Cps = v32.Cps
                                if Cps == nil then
                                    Cps = v31:GetAttribute("CashPerSecond")
                                    if typeof(Cps) ~= "number" then
                                        Cps = 0
                                    end
                                end
                                v32.Accum += Cps * v25
                                if not (v27 < v32.NextAt) then
                                    v32.NextAt = v27 + v29
                                    if v32.Accum >= 1 then
                                        local Accum = v32.Accum
                                        v32.Accum = 0
                                        local Scale = v32.Scale
                                        if Scale == nil then
                                            Scale = popupScale(v31)
                                            if v24(v31:GetAttribute("AnimalName")) == "string" then
                                                v32.Scale = Scale
                                            end
                                        end
                                        local HeadHeight = v32.HeadHeight
                                        if HeadHeight == nil or v32.HeadAt <= v27 then
                                            HeadHeight = AnimalCashPopup.HeadHeight(v31)
                                            v32.HeadHeight = HeadHeight
                                            v32.SideReach = AnimalCashPopup.SideReach(v31)
                                            v32.HeadAt = v27 + 3
                                        end
                                        local Play = AnimalCashPopup.Play
                                        local v35 = {
                                            SizeMult = Scale,
                                            HeadHeight = HeadHeight
                                        }
                                        v35.SideReach = v32.SideReach
                                        Play(v31, Accum, v35)
                                    end
                                end
                            else
                                v32.Accum = 0
                                v32.NextAt = v27 + v29
                            end
                        end
                    end
                end
            elseif v31:IsA("Model") then
                local v36 = v3[v31]
                if v36 then
                    if v36.CpsConn then
                        v36.CpsConn:Disconnect()
                    end
                    v3[v31] = nil
                end
            end
        end
        v21 = v30
    end)
end

return v1
