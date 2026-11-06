-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    RemoteName = "Notify",
    ShowTime = 0.2,
    HoldTime = 2,
    FadeTime = 0.3,
    MaxVisible = 3,
    SoundFolderName = "rransCustomSFX",
    TemplateNames = { "Message(New)", "Message" },
    Styles = {
        Success = {
            Text = Color3.fromRGB(255, 255, 255),
            KeyWords = Color3.fromRGB(114, 255, 114)
        },
        Info = {
            Text = Color3.fromRGB(255, 255, 255),
            KeyWords = Color3.fromRGB(255, 210, 60)
        },
        Error = {
            KeyWords = nil,
            Text = Color3.fromRGB(255, 75, 75)
        }
    },
    StrokeColor = Color3.fromRGB(0, 0, 0),
    NamedColors = { gold = Color3.fromRGB(255, 210, 60) },
    Sounds = {
        Success = "Success",
        Error = "Error2",
        Info = "Alert Notification"
    },
    MessageSounds = { ["Purchased!"] = "Purchase" },
    SoundPitchVariance = {
        Purchase = 0.05,
        Error2 = 0.05
    },
    Waypoint = {
        TemplateName = "NotificationImage",
        EdgeMargin = 70,
        HoverHeight = 5,
        Gap = 6,
        BobDistance = 10,
        BobTime = 0.9
    },
    PickaxeAffordAlert = { JoinGraceSeconds = 12 },
    TrailAffordAlert = { JoinGraceSeconds = 12 },
    Messages = {
        Stole = {
            Text = "You stole an {gold:ANIMAL}!",
            Kind = "Success",
            Time = 2.5,
            Sound = false
        },
        Placed = {
            Text = "Successfully placed {gold:%s}!",
            Kind = "Success",
            Sound = false
        },
        NotInBase = {
            Text = "You cannot place your pet here!",
            Kind = "Error"
        },
        TooFar = {
            Text = "Get closer to your Pen to place pets!",
            Kind = "Error"
        },
        BaseFullUpgrade = {
            Text = "Base Full - Upgrade Your Plot",
            Kind = "Error"
        },
        BaseFull = {
            Text = "Base Full",
            Kind = "Error"
        },
        PenRestoring = {
            Text = "Your pets are still loading - try again in a moment!",
            Kind = "Error"
        },
        PlaceFailed = {
            Text = "Couldn't place that pet - try again!",
            Kind = "Error"
        },
        PetsFull = {
            Text = "Maximum pets reached! (%s)",
            Kind = "Error"
        },
        EquipBestCooldown = {
            Text = "Please wait a bit before equipping bests again!",
            Kind = "Error"
        },
        BatSafeZone = {
            Text = "You can't use the Bat in a Safe Zone!",
            Kind = "Error"
        },
        BatVictimInTutorial = {
            Text = "%s is still in the tutorial!",
            Kind = "Error"
        },
        BatClaimed = {
            Text = "Unlocked the %s!",
            Kind = "Success",
            Sound = "Unlock"
        },
        BatEquipped = {
            Text = "Successfully equipped %s!",
            Kind = "Success",
            Sound = false
        },
        PickaxePurchased = {
            Text = "Successfully equipped %s!",
            Kind = "Success",
            Sound = "Purchase"
        },
        PickaxeEquipped = {
            Text = "Successfully equipped %s!",
            Kind = "Success",
            Sound = false
        },
        PickaxeAffordable = {
            Text = "You can now afford the %s!",
            Kind = "Info",
            Time = 3
        },
        NotEnoughMoney = {
            Text = "Not enough money",
            Kind = "Error"
        },
        BaseUpgraded = {
            Text = "Successfully upgraded your {base}!",
            Kind = "Success",
            Time = 0.7,
            Sound = "Purchase"
        },
        MaxBase = {
            Text = "{Max} base upgrade reached",
            Kind = "Info"
        },
        TreadmillUpgraded = {
            Text = "Successfully upgraded your {treadmill}!",
            Kind = "Success",
            Time = 0.7,
            Sound = "Purchase"
        },
        MaxTreadmill = {
            Text = "{Max} treadmill upgrade reached",
            Kind = "Info"
        },
        TreadmillUpgradeFailed = {
            Text = "Treadmill upgrade failed",
            Kind = "Error"
        },
        SatchelUpgraded = {
            Text = "Successfully upgraded your {satchel}!",
            Kind = "Success",
            Time = 0.7,
            Sound = "Purchase"
        },
        MaxSatchel = {
            Text = "{Max} satchel upgrade reached",
            Kind = "Info"
        },
        ItemsSold = {
            Text = "Sold %s for {$%s}!",
            Kind = "Success",
            Sound = "Purchase"
        },
        SellNothing = {
            Text = "Nothing was sold - try again!",
            Kind = "Error"
        },
        SellTutorial = {
            Text = "Finish the tutorial before selling!",
            Kind = "Error"
        },
        TrailPurchased = {
            Text = "Successfully equipped the %s!",
            Kind = "Success",
            Sound = "Purchase"
        },
        TrailEquipped = {
            Text = "Successfully equipped the %s!",
            Kind = "Success",
            Sound = false
        },
        TrailAffordable = {
            Text = "You can now afford the %s!",
            Kind = "Info",
            Time = 3
        },
        NoEggsGrowing = {
            Text = "You have no eggs growing!",
            Kind = "Error"
        },
        StolenEggBanked = {
            Text = "You got a %s Egg! Plant it on your plot to hatch it.",
            Kind = "Success"
        },
        EggTooClose = {
            Text = "Can't place here - too close to another egg!",
            Kind = "Error"
        },
        DemonEggPurchased = {
            Text = "You got a %s! Plant it on your plot to hatch it.",
            Kind = "Success",
            Sound = "Purchase"
        },
        NotEnoughDemonTokens = {
            Text = "Not enough Fallen Tokens",
            Kind = "Error"
        },
        DemonEggFailed = {
            Text = "Couldn't give the egg - you weren't charged",
            Kind = "Error"
        },
        DemonPotionPurchased = {
            Text = "You got a %s! %s left",
            Kind = "Success",
            Sound = "Purchase"
        },
        DemonPotionFailed = {
            Text = "Couldn't give the potion - you weren't charged",
            Kind = "Error"
        },
        EggTypeDisabled = {
            Text = "We had to remove %s for now - they'll be back shortly! Yours are saved.",
            Kind = "Info",
            Time = 6
        },
        EggTypeUnavailable = {
            Text = "%s are unavailable right now - back shortly!",
            Kind = "Error"
        },
        FuseDeposited = {
            Text = "Added %s to the Fuse Machine!",
            Kind = "Success",
            Sound = false
        },
        FuseReturned = {
            Text = "%s went back to your backpack",
            Kind = "Info",
            Sound = false
        },
        FuseMissingAnimal = {
            Text = "You don't have a %s! Find one in the %s",
            Kind = "Error",
            Time = 3
        },
        FuseNotReady = {
            Text = "The Fuse Machine still needs %s more!",
            Kind = "Error"
        },
        FuseActionFailed = {
            Text = "Couldn't do that - try again",
            Kind = "Error"
        },
        FuseEggGranted = {
            Text = "You got a %s! Plant it on your plot to hatch it.",
            Kind = "Success",
            Sound = "Purchase"
        },
        FuseFailed = {
            Text = "Couldn't fuse - your pets are still in the machine",
            Kind = "Error"
        },
        PaidRandomItemsRestricted = {
            Text = "Random eggs can't be bought in your region",
            Kind = "Error",
            Time = 3
        },
        PaidRandomGiftRestricted = {
            Text = "%s can't receive random eggs in their region",
            Kind = "Error",
            Time = 3
        },
        PaidRandomGiftToBuyer = {
            Text = "%s can't receive random eggs, so the eggs went to {you} instead!",
            Kind = "Info",
            Time = 4
        },
        CheaterModeOn = {
            Text = "Cheater mode ON - click to teleport, %s = fly, %s = speed",
            Kind = "Info",
            Time = 4
        },
        CheaterModeOff = {
            Text = "Cheater mode OFF",
            Kind = "Info"
        },
        CheatFlyOn = {
            Text = "Fly {ON}",
            Kind = "Success",
            Time = 1
        },
        CheatFlyOff = {
            Text = "Fly {OFF}",
            Kind = "Info",
            Time = 1
        },
        CheatSpeedOn = {
            Text = "Speed hack {ON} (x%s)",
            Kind = "Success",
            Time = 1
        },
        CheatSpeedOff = {
            Text = "Speed hack {OFF}",
            Kind = "Info",
            Time = 1
        },
        AntiCheatForgivenSpeed = {
            Text = "Anti-cheat: speed strike {forgiven} as lag",
            Kind = "Info",
            Time = 1
        },
        AntiCheatForgivenTeleport = {
            Text = "Anti-cheat: short teleport {forgiven} as lag",
            Kind = "Info",
            Time = 1
        },
        AntiCheatSpeed = {
            Text = "Anti-cheat caught SPEED - pulled back!",
            Kind = "Error"
        },
        AntiCheatTeleport = {
            Text = "Anti-cheat caught TELEPORT - pulled back!",
            Kind = "Error"
        },
        AntiCheatFlyWarned = {
            Text = "Anti-cheat caught FLY - warning (no ground to return you to)",
            Kind = "Error"
        },
        AntiCheatFlyPulledBack = {
            Text = "Anti-cheat caught FLY - put back on the ground!",
            Kind = "Error",
            Time = 2.5
        },
        AntiCheatFlyExploded = {
            Text = "Anti-cheat caught FLY again - exploded!",
            Kind = "Error",
            Time = 3
        },
        AntiCheatRepeatExploded = {
            Text = "Anti-cheat: kept cheating after pull-backs - exploded!",
            Kind = "Error",
            Time = 3
        },
        AntiCheatBankTeleport = {
            Text = "Anti-cheat blocked banking - you teleported!",
            Kind = "Error"
        },
        AntiCheatStealRush = {
            Text = "Anti-cheat: stolen too fast - animals sent back, exploded!",
            Kind = "Error",
            Time = 3
        },
        AntiCheatDropReturned = {
            Text = "Anti-cheat: dropped after cheating - animals sent back!",
            Kind = "Error",
            Time = 3
        }
    }
}

function v1.Build(v2, ...) -- line 266 | captures: v1
    local v3 = v1.Messages[v2]
    if v3 then
        local Text = v3.Text
        if select("#", ...) > 0 then
            local v4 = table.pack(...)
            local n = v4.n
            for v5 = 1, n do
                local gsub = string.gsub
                local v6 = v4[v5]
                v4[v5] = gsub(tostring(v6), "[{}]", "")
            end
            local v7 = {}
            local v8 = 0
            local v9 = 1
            while true do
                local v10, v11
                if v9 <= #Text then
                    v10 = string.sub(Text, v9, v9)
                    if v10 == "{" then
                        v11 = v8 + 1
                    elseif v10 == "}" then
                        local v12 = v8 - 1
                        v11 = math.max(v12, 0)
                    else
                        v11 = v8
                    end
                else
                    break
                end
                local v13
                if v10 == "%" then
                    local v14 = v9 + 1
                    local v15 = v9 + 1
                    if string.sub(Text, v14, v15) == "s" then
                        v13 = v11 == 0
                    else
                        v13 = false
                    end
                else
                    v13 = false
                end
                if v13 then
                    table.insert(v7, "{%s}")
                    v9 += 2
                else
                    table.insert(v7, v10)
                    v9 += 1
                end
                v8 = v11
            end
            local format = string.format
            local v16 = table.concat(v7)
            local n_2 = v4.n
            Text = format(v16, table.unpack(v4, 1, n_2))
        end
        return Text,
            v3.Kind,
            {
                Time = v3.Time,
                Sound = v3.Sound
            }
    end
    warn((("[NotificationConfig] Unknown notification preset \"%*\""):format(v2)))
    return v2, "Info", {}
end

return v1
