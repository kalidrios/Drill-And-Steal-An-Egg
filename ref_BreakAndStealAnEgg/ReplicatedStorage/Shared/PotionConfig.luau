-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Workspace = game:GetService("Workspace")
local v1 = {
    DurationSeconds = 900,
    AttributePrefix = "PotionEndsAt_",
    HudTemplateName = "Potion",
    SunrayDegreesPerSecond = 60,
    HoverInfoName = "PotionInfo",
    HoverCursorGap = 28,
    HoverMultiplierColor = "#00FF00",
    AllPotionsColor = "#FFD23C",
    HudPath = { "Currencies", "Potions" },
    IconTween = {
        HoverScale = 1.08,
        PressScale = 0.94,
        TweenDuration = 0.18,
        TweenEasingStyle = "Quad",
        TweenEasingDirection = "Out"
    },
    Potions = {
        {
            Id = "WalkSpeed",
            ProductId = 3714597365,
            CardName = "WalkSpeedPotion",
            DisplayName = "x1.25 WalkSpeed Potion",
            Multiplier = 1.25,
            Icon = "rbxassetid://101174195616077",
            Color = "#3CC8FF",
            HoverMultiplier = "x1.25",
            HoverName = "WalkSpeed",
            HoverInfo = "Makes you run faster!"
        },
        {
            Id = "Cash",
            ProductId = 3714597383,
            CardName = "MoneyPotion",
            DisplayName = "x2 Cash Potion",
            Multiplier = 2,
            Icon = "rbxassetid://84523919158954",
            Color = "#3CE650",
            HoverMultiplier = "x2",
            HoverName = "Cash",
            HoverInfo = "Your animals earn double cash!"
        },
        {
            Id = "Treadmill",
            ProductId = 3714597430,
            CardName = "TreadmillPotion",
            DisplayName = "x2 Treadmill Speed Potion",
            Multiplier = 2,
            Icon = "rbxassetid://106125833835658",
            Color = "#FF3C3C",
            HoverMultiplier = "x2",
            HoverName = "Treadmill Speed",
            HoverInfo = "Treadmills give double speed!"
        },
        {
            Id = "EggGrowth",
            ProductId = nil,
            CardName = nil,
            DisplayName = "x2 Egg Growth Potion",
            Multiplier = 2,
            Icon = "rbxassetid://126102273280587",
            Color = "#FFB43C",
            HoverMultiplier = "x2",
            HoverName = "Egg Growth",
            HoverInfo = "Your eggs grow twice as fast!"
        },
        {
            Id = "Swing",
            ProductId = nil,
            CardName = nil,
            DisplayName = "x1.25 Pickaxe Swing Potion",
            Multiplier = 1.25,
            Icon = "rbxassetid://86375569596395",
            Color = "#B45AFF",
            HoverMultiplier = "x1.25",
            HoverName = "Pickaxe Swing",
            HoverInfo = "Swing your pickaxe faster!"
        },
        {
            Id = "EggLuck",
            ProductId = nil,
            CardName = nil,
            DisplayName = "x2 Egg Luck Potion",
            Multiplier = 2,
            Icon = "rbxassetid://78076234808211",
            Color = "#FF6EC7",
            HoverMultiplier = "x2",
            HoverName = "Egg Luck",
            HoverInfo = "Hatch better pets more often!"
        }
    },
    EggLuck = {
        PotionId = "EggLuck",
        RareBelow = 0.1,
        MaxMultiplier = 10,
        MaxRareShare = 0.6
    }
}
local v2 = {}
for v3, v4 in v1.Potions do
    v2[v4.Id] = v4
end

function v1.ById(v5) -- line 205 | captures: v2
    if typeof(v5) == "string" then
        return v2[v5]
    end
    return nil
end

function v1.Find(v6) -- line 211 | captures: v1
    local v7 = string.lower(v6)
    for v8, v9 in v1.Potions do
        if string.lower(v9.Id) == v7 then
            return v9
        end
    end
    for v10, v11 in v1.Potions do
        if string.find(string.lower((("%* %*"):format(v11.Id, v11.DisplayName))), v7, 1, true) then
            return v11
        end
    end
    return nil
end

local v12 = {}

function v1.EndsAtAttribute(v13) -- line 230 | captures: v1, v12
    local v14 = v12[v13]
    if not v14 then
        v14 = v1.AttributePrefix .. v13
        v12[v13] = v14
    end
    return v14
end

function v1.RemainingFor(v15, v16) -- line 241 | captures: Workspace, v1
    local v17 = v15:GetAttribute(v1.EndsAtAttribute(v16))
    if typeof(v17) == "number" then
        local v18 = v17 - Workspace:GetServerTimeNow()
        return (math.max(v18, 0))
    end
    return 0
end

v1.GlobalMultiplierPrefix = "GlobalBoostMult_"
v1.GlobalEndsAtPrefix = "GlobalBoostEndsAt_"
v1.GlobalHoverName = "(Global)"
v1.GlobalHoverInfo = "A global boost for everyone!"

local v19 = {}
local v20 = {}

function v1.GlobalMultiplierAttribute(v21) -- line 268 | captures: v1, v20
    local v22 = v20[v21]
    if not v22 then
        v22 = v1.GlobalMultiplierPrefix .. v21
        v20[v21] = v22
    end
    return v22
end

function v1.GlobalEndsAtAttribute(v23) -- line 277 | captures: v1, v19
    local v24 = v19[v23]
    if not v24 then
        v24 = v1.GlobalEndsAtPrefix .. v23
        v19[v23] = v24
    end
    return v24
end

function v1.GlobalRemaining(v25) -- line 287 | captures: Workspace, v1
    local v26 = Workspace:GetAttribute(v1.GlobalEndsAtAttribute(v25))
    if typeof(v26) == "number" then
        local v27 = v26 - Workspace:GetServerTimeNow()
        return (math.max(v27, 0))
    end
    return 0
end

function v1.GlobalEndsAt(v28) -- line 296 | captures: Workspace, v1
    if v1.GlobalRemaining(v28) <= 0 then
        return nil
    end
    return (Workspace:GetAttribute(v1.GlobalEndsAtAttribute(v28)))
end

function v1.GlobalMultiplier(v29) -- line 304 | captures: Workspace, v1
    if v1.GlobalRemaining(v29) <= 0 then
        return 1
    end
    local v30 = Workspace:GetAttribute(v1.GlobalMultiplierAttribute(v29))
    if not (typeof(v30) == "number" and v30 > 0) then
        return 1
    end
    return v30
end

function v1.MultiplierFor(v31, v32) -- line 314 | captures: v1, v2
    local v33 = v2[v32]
    local v34 = if not (v33 and v1.RemainingFor(v31, v32) > 0) then 1 else v33.Multiplier
    return v34 * v1.GlobalMultiplier(v32)
end

local function SpeedStatFor(v35, v36) -- line 325
    return v36
end

v1.SpeedStatFor = SpeedStatFor

function v1.WalkSpeedMultiplierFor(v37) -- line 332 | captures: v1
    return v1.MultiplierFor(v37, "WalkSpeed")
end

function v1.EggLuckMultiplierFor(v38) -- line 339 | captures: v1
    local EggLuck = v1.EggLuck
    local v39 = v1.MultiplierFor(v38, EggLuck.PotionId)
    local MaxMultiplier = EggLuck.MaxMultiplier
    return (math.clamp(v39, 1, MaxMultiplier))
end

function v1.HoverTitle(v40) -- line 345 | captures: v1
    return (("<font color=\"%*\">%*</font> %*"):format(v1.HoverMultiplierColor, v40.HoverMultiplier, v40.HoverName))
end

local function FormatTime(v41) -- line 351
    local v42 = math.ceil(v41)
    local v43 = math.max(v42, 0)
    if v43 >= 60 then
        return (("%*:%*"):format(v43 // 60, (string.format("%02d", v43 % 60))))
    end
    return (("%*s"):format(v43))
end

v1.FormatTime = FormatTime
return v1
