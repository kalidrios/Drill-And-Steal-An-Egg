-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    Notes = {
        {
            Name = "data",
            Title = "Saved data (profiles)",
            Summary = "ProfileStore-backed profile per player, store \"PlayerData_v11\", keyed by UserId. Cash is the ONLY currency. Nothing outside DataService should write the profile directly: the setters also refresh the leaderstats and the replicated player attributes that every HUD reads, so a raw field write shows stale numbers until the next real change.",
            Commands = { "stats", "setcash", "cash", "reset" },
            Files = { "src/server/Services/DataService.luau" }
        },
        {
            Name = "cash",
            Title = "Cash / economy",
            Summary = "Cash comes from placed animals earning per second and from banking stolen ones. AddCash/SpendCash are the only writers that resync the leaderstat, so an exact amount is set as a delta (that's what `setcash` does). Cash is allowed to go negative if you subtract past zero.",
            Commands = { "cash", "setcash" },
            Files = { "src/server/Services/DataService.luau", "src/server/Services/AnimalPlacementService.luau" }
        },
        {
            Name = "speed",
            Title = "Speed power / treadmill training",
            Summary = "SpeedPower is the core stat: WalkSpeed is always DERIVED from it (never set directly) and every zone gates on it. Standing on a treadmill grants the equipped trail's Multiplier x the machine's SpeedMultiplier per step. The award loop re-reads both every tick, so changing either applies mid-session.",
            Commands = { "speed", "setspeed", "maxspeed", "trail", "treadmill", "unlocktreadmill" },
            Files = { "src/server/Services/SpeedService.luau", "src/shared/SpeedConfig.luau" }
        },
        {
            Name = "trails",
            Title = "Trails Shop booth (per-step gain + trail visual)",
            Summary = "The booth sells trails: the equipped trail's Multiplier is how much speed one treadmill step is worth before the machine multiplier (x1 with none), and the trail's ribbons follow the character (aura emitters stripped on purpose). `trail <id>` grants + equips one, `alltrails` grants the whole ladder.",
            Commands = { "trail", "alltrails" },
            Files = { "src/server/Services/TrailService.luau", "src/shared/TrailsConfig.luau" }
        },
        {
            Name = "pickaxe",
            Title = "Pickaxes",
            Summary = "10 tiers, each doing more damage to eggs. The saved tier plus the owned list mirror onto PLAYER ATTRIBUTES (PickaxeTier, OwnedPickaxes) that the shop UI reads \226\128\148 granting a tier without stamping those leaves the shop showing it as unowned, which is why `pickaxe` goes through AdminActions.",
            Commands = { "pickaxe", "allpickaxes" },
            Files = { "src/server/Services/PickaxeService.luau", "src/server/Services/PickaxeShopService.luau", "src/shared/PickaxeConfig.luau" }
        },
        {
            Name = "satchel",
            Title = "Satchel (carry capacity)",
            Summary = "6 tiers, from Bare Hands (1 animal) to Titanic (6). Bought at tagged world stations. Capacity is read from the SatchelCapacity player attribute, so the tier and the attribute have to move together \226\128\148 SatchelService.Sync does that.",
            Commands = { "satchel", "maxsatchel" },
            Files = { "src/server/Services/SatchelService.luau", "src/shared/SatchelConfig.luau" }
        },
        {
            Name = "plot",
            Title = "Plot / base upgrades",
            Summary = "9 levels. Each level swaps the plot's Build folder for a bigger authored model and stretches the Hitbox to match, which is what placement, wander bounds and the billboard all key off. Setting the saved level without PlotUpgradeService.Sync leaves the old base standing.",
            Commands = { "plot", "maxplot", "plotof" },
            Files = { "src/server/Services/PlotUpgradeService.luau", "src/server/Services/PlotService.luau", "src/shared/PlotUpgradeConfig.luau" }
        },
        {
            Name = "treadmill",
            Title = "Treadmill unlock + levels",
            Summary = "Two separate things. The UNLOCK is a one-off flag: while locked, the machine and its board are stashed in ServerStorage, and the level Sync is a no-op. The LEVEL (1-9) swaps in a bigger machine with a higher SpeedMultiplier. Always unlock before levelling \226\128\148 `treadmill` does that for you.",
            Commands = { "unlocktreadmill", "treadmill", "maxtreadmill" },
            Files = { "src/server/Services/TreadmillUnlockService.luau", "src/server/Services/TreadmillUpgradeService.luau" }
        },
        {
            Name = "index",
            Title = "Index (collection book)",
            Summary = "Every animal name you have ever banked goes to \"Ready\"; claiming it in the Index UI pays a deterministic cash + speed reward and flips it to \"Claimed\". `index` discovers everything but deliberately does NOT auto-claim, so you can still test the claim flow and its rewards.",
            Commands = { "index", "resetindex" },
            Files = { "src/server/Services/IndexService.luau", "src/shared/IndexConfig.luau" }
        },
        {
            Name = "animals",
            Title = "Animals: hatching, carrying, placing",
            Summary = "An egg rolls a species plus a weight roll (kg, size multiplier, BIG/HUGE/TITANIC bracket, mutation, gender). Carried animals are backpack Tools; placed ones stand on your plot and earn cash per second. `giveanimal` rolls a real weight for the size you ask for, so the tag and the earnings stay consistent with a genuine hatch. `givescale` instead takes the exact VISUAL scale (x1/x5/x20) and skips the 10x size cap \226\128\148 the size-preview command.",
            Commands = { "giveanimal", "givescale", "clearanimals", "animals" },
            Files = { "src/server/Services/EggRewardService.luau", "src/server/Services/AnimalPlacementService.luau", "src/server/Services/PickupService.luau" }
        },
        {
            Name = "zones",
            Title = "Zones, eggs and guards",
            Summary = "7 zones of rising rarity, each with a SpeedPower requirement and a guard that chases you while you carry stolen animals. Eggs respawn on a timer per zone. `respawneggs` forces a full restock, `eggs` shows the live counts.",
            Commands = { "zone", "zones", "eggs", "respawneggs", "uncharge" },
            Files = { "src/server/Services/ZoneService.luau", "src/server/Services/EggSpawnService.luau", "src/server/Services/GuardService.luau", "src/shared/ZonesConfig.luau" }
        },
        {
            Name = "tutorial",
            Title = "Tutorial",
            Summary = "A staged onboarding that BLOCKS every cash purchase until it finishes, and reserves pickups for the new player. The saved \"done\" flag is not enough on its own: the live session also holds TutorialActive/TutorialStage attributes, so only TutorialService.Complete (what `skiptutorial` calls) really ends it without a rejoin.",
            Commands = { "skiptutorial", "replaytutorial" },
            Files = { "src/server/Services/TutorialService.luau", "src/shared/TutorialConfig.luau" }
        },
        {
            Name = "playtime",
            Title = "Playtime and leaderboards",
            Summary = "Lifetime seconds, banked periodically, feeding the playtime leaderboard and the 30-minute group-reward window. AddPlaytime refuses anything <= 0, so an exact value has to be written to the profile \226\128\148 that's what `playtime` does, then it banks.",
            Commands = { "playtime", "stats" },
            Files = { "src/server/Services/PlaytimeService.luau", "src/server/Services/LeaderboardService.luau", "src/server/Services/GroupRewardService.luau" }
        },
        {
            Name = "admin",
            Title = "Admin console (this system)",
            Summary = "Conch console, opened with F2, gated twice: the server only gives the Conch role to users in AdminConfig, and the client only mounts the console for them. Every command is declared once in AdminApi and shows up in the console, in chat (prefix /), in `cmds` and in ADMIN_COMMANDS.md. Every run is printed to the server log.",
            Commands = { "cmds", "notes", "admins" },
            Files = { "src/shared/AdminConfig.luau", "src/server/Services/AdminService.luau", "src/server/Modules/AdminApi.luau", "src/server/Modules/AdminActions.luau", "src/client/Controllers/AdminController.luau" }
        }
    }
}

function v1.Find(v2) -- line 128 | captures: v1
    local v3 = string.lower(v2)
    for v4, v5 in v1.Notes do
        if string.lower(v5.Name) == v3 then
            return v5
        end
    end
    for v6, v7 in v1.Notes do
        if string.find(string.lower((("%* %*"):format(v7.Name, v7.Title))), v3, 1, true) then
            return v7
        end
    end
    return nil
end

return v1
