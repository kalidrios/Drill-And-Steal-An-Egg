-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local v1 = {
    UserIds = {
        [9679848455] = true,
        [1247492319] = true
    },
    OwnerUserIds = { [9679848455] = true },
    Usernames = {
        realrran = true,
        monkisrok = true
    },
    DevPlaceId = 123834297139486,
    DevConsoleUserIds = { [1199429781] = true },
    StudioAlwaysAdmin = true,
    Role = "super-user",
    Permission = "admin",
    Keybind = Enum.KeyCode.F2,
    Attribute = "IsAdmin",
    PanelAttribute = "IsPanelAdmin",
    PanelButtonName = "AdminPanel(ADMINS ONLY!)",
    PanelFrameName = "AdminPanel",
    PanelStorage = "AdminUI",
    PanelScopes = { "Client", "Server", "Global" },
    PanelDefaultScope = "Client",
    PanelHoverScale = 0.95,
    PanelPressScale = 0.88,
    PanelCards = {
        Announce = "Announcements",
        Gift = "Gifting",
        Poll = "CreatePoll",
        BossSpawn = "BossSpawning",
        Treadmill = "AdminTreadmillSpawn",
        Hell = "HellEvent",
        AdminAbuse = "AdminAbuse",
        GlobalBoost = "GlobalBoosts",
        TitanicEgg = "TitanicEggSpawn",
        EventRsvp = "EventRsvpPrompt"
    },
    PollCreateFrame = "GlobalPollCreate",
    AdminOnlyFrames = { "GlobalPollCreate" },
    Gift = {
        DefaultType = "Animals",
        GlobalToggleName = "GlobalEdit",
        DefaultGlobal = false,
        GlobalOnStyle = "Green",
        GlobalOffStyle = "Red",
        GlobalOnText = "[ON]",
        GlobalOffText = "[OFF]",
        MaxAnimalAmount = 25,
        KgSuffix = "KG",
        AmountSuffix = "x",
        MinutesSuffix = "m",
        MaxKg = 1000000000000000,
        MaxPotionSeconds = 86400,
        Sections = {
            Potions = "PotionGifting",
            Animals = "AnimalGifting"
        },
        EveryoneWords = {
            all = true,
            everyone = true,
            ["@a"] = true
        },
        GlobalTypes = { Potions = true },
        StyleSources = {
            Red = { "Announcements", "Client" },
            Green = { "Announcements", "Server" },
            Blue = { "Announcements", "Global" }
        },
        PotionStyles = {
            WalkSpeed = "Blue",
            Cash = "Green",
            Treadmill = "Red"
        },
        AnimalColor = Color3.fromRGB(255, 210, 60)
    },
    PanelRemotes = {
        Announce = "AdminPanelAnnounce",
        Gift = "AdminPanelGift",
        Poll = "AdminPanelPoll",
        BossSpawn = "AdminPanelBossSpawn",
        Treadmill = "AdminPanelTreadmill",
        Hell = "AdminPanelHell",
        HellHourly = "AdminPanelHellHourly",
        AdminAbuse = "AdminPanelAdminAbuse",
        GlobalBoost = "AdminPanelGlobalBoost",
        TitanicEgg = "AdminPanelTitanicEgg",
        EventRsvp = "AdminPanelEventRsvp"
    },
    GlobalBoost = {
        DefaultScope = "Global",
        AllName = "All Boosts",
        AllColor = "#FFD23C",
        MaxMultiplier = 100,
        MaxSeconds = 86400,
        MinutesSuffix = "m",
        MultiplierPrefix = "x",
        Scopes = {
            Server = true,
            Global = true
        },
        Choices = { "Cash", "WalkSpeed", "Treadmill", "EggGrowth", "Swing", "EggLuck", "all" }
    },
    TitanicEgg = {
        ToggleName = "ZoneEdit",
        ListName = "ZoneList",
        RandomOption = "Random"
    },
    ChatPrefix = "/",
    RawTextCommands = { "announce" },
    LogPrefix = "[admin]"
}

function v1.IsAdmin(v2) -- line 252 | captures: RunService, v1
    if v1.UserIds[v2.UserId] then
        return true
    end
    if v1.Usernames[string.lower(v2.Name)] then
        return true
    end
    return v1.StudioAlwaysAdmin and RunService:IsStudio()
end

function v1.IsOwner(v3) -- line 269 | captures: v1
    if v3 == nil then
        return false
    end
    return v1.OwnerUserIds[v3.UserId] == true
end

function v1.HasConsole(v4) -- line 273 | captures: v1
    if v1.IsAdmin(v4) then
        return true
    end
    if game.PlaceId == v1.DevPlaceId then
        return v1.DevConsoleUserIds[v4.UserId] == true
    end
    return false
end

function v1.IsListedAdmin(v5) -- line 283 | captures: v1
    if v1.UserIds[v5.UserId] == true then
        return true
    end
    return v1.Usernames[string.lower(v5.Name)] == true
end

function v1.IsAdminUserId(v6) -- line 291 | captures: v1
    return v1.UserIds[v6] == true
end

function v1.CurrentAdmins() -- line 296 | captures: Players, v1
    local v7 = {}
    for v8, v9 in Players:GetPlayers() do
        if v1.HasConsole(v9) then
            table.insert(v7, v9)
        end
    end
    return v7
end

return v1
