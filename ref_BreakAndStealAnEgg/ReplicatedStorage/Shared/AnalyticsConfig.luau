-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local PickaxeConfig = require(ReplicatedStorage.Shared.PickaxeConfig)
local TrailsConfig = require(ReplicatedStorage.Shared.TrailsConfig)
local ZonesConfig = require(ReplicatedStorage.Shared.ZonesConfig)
local v1 = {
    DebugPrint = true,
    TutorialSteps = {
        {
            Name = "Equip Pickaxe",
            DoneAtStage = "BreakEgg"
        },
        {
            Name = "Break Egg",
            DoneAtStage = "Hatching"
        },
        {
            Name = "Get Animal",
            DoneAtStage = "Escape"
        },
        {
            Name = "Save Animal",
            DoneAtStage = "GoToPen"
        },
        {
            Name = "Put Animal In Pen",
            DoneAtStage = "EarnCash"
        },
        {
            Name = "Upgrade Base",
            DoneAtStage = "UseTreadmill"
        },
        {
            Name = "Use Treadmill",
            DoneAtStage = "EarnPickaxeCash"
        },
        {
            Name = "Buy Better Pickaxe",
            DoneAtStage = "EquipNewPickaxe"
        },
        {
            Name = "Break Better Egg",
            DoneAtStage = "CollectStrongerAnimal"
        },
        {
            Name = "Buy Trail",
            DoneAtStage = "Done"
        }
    },
    JoinStep = "Join the Game",
    Funnels = {
        Zones = { Name = "Zones" },
        Eggs = { Name = "Eggs" },
        Pickaxes = { Name = "Pickaxes" },
        Trails = { Name = "Trails" }
    },
    Events = {
        EggBroken = "Egg Broken",
        AnimalCollected = "Animal Collected",
        TrailBought = "Trail Bought",
        ShopOpened = "Shop Opened",
        ShopItemBought = "Shop Item Bought",
        ShopRobuxSpent = "Shop Robux Spent"
    },
    ShopOpenedRemoteName = "AnalyticsShopOpened"
}

local function zoneLabel(v2, v3) -- line 132 | captures: EggRewards
    local v4 = EggRewards.ZoneEggs[v3]
    local v5 = v4 and v4.Theme
    if v5 then
        return (("Zone %* (%*)"):format(v2, v5))
    end
    return (("Zone %*"):format(v2))
end

function v1.ZoneLabel(v6) -- line 139 | captures: EggRewards, ZonesConfig
    local v7 = ZonesConfig.IndexOf(v6)
    if v7 then
        local v8 = EggRewards.ZoneEggs[v6]
        local v9 = v8 and v8.Theme
        if v9 then
            return (("Zone %* (%*)"):format(v7, v9))
        end
        return (("Zone %*"):format(v7))
    end
    return nil
end

local v10 = {}

function v10.Zones() -- line 145 | captures: EggRewards, ZonesConfig, v1
    local v11 = { v1.JoinStep }
    for v12, v13 in ZonesConfig.Zones do
        local Id = v13.Id
        local v14 = EggRewards.ZoneEggs[Id]
        local v15 = v14 and v14.Theme
        local v16
        if v15 then
            v16 = ("Zone %* (%*)"):format(v12, v15)
        else
            v16 = ("Zone %*"):format(v12)
        end
        table.insert(v11, v16)
    end
    return v11
end

function v10.Eggs() -- line 153 | captures: EggRewards, ZonesConfig, v1
    local v17 = { v1.JoinStep }
    for v18, v19 in ZonesConfig.Zones do
        local v20 = EggRewards.ZoneEggs[v19.Id]
        if v20 then
            for v21, v22 in v20.Eggs do
                table.insert(v17, v22)
            end
        end
    end
    return v17
end

function v10.Pickaxes() -- line 166 | captures: PickaxeConfig, v1
    local v23 = { v1.JoinStep }
    for v24, v25 in PickaxeConfig.Tiers do
        local Name = v25.Name
        table.insert(v23, Name)
    end
    return v23
end

function v10.Trails() -- line 174 | captures: TrailsConfig, v1
    local v26 = { v1.JoinStep }
    for v27, v28 in TrailsConfig.Trails do
        local Name = v28.Name
        table.insert(v26, Name)
    end
    return v26
end

local v29 = {}

function v1.GetSteps(v30) -- line 186 | captures: v10, v29
    local v31 = v29[v30]
    if v31 then
        return v31
    end
    local v32 = v10[v30]
    local v33
    if v32 then
        v33 = v32()
    else
        v33 = {}
    end
    v29[v30] = v33
    return v33
end

function v1.FindStep(v34, v35) -- line 197 | captures: v1
    if v35 then
        return table.find(v1.GetSteps(v34), v35)
    end
    return nil
end

return v1
