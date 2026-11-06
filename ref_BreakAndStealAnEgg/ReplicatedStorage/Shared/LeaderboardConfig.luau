-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local FormatNumber = require(script.Parent.FormatNumber)
local v1 = {
    FolderName = "Leaderboards",
    RemoteName = "LeaderboardRemote",
    RefreshSeconds = 300,
    MaxEntries = 100,
    PlaytimeBankSeconds = 30,
    ThumbnailTemplate = "rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150",
    Boards = {
        {
            Key = "Money",
            Model = "TopMoney",
            Stat = "Income",
            Store = "TopMoney_v13e",
            LegacyStore = "TopMoney_v12",
            Format = "MoneyRate"
        },
        {
            Key = "Speed",
            Model = "TopSpeed",
            Stat = "SpeedPower",
            Store = "TopSpeed_v12e",
            LegacyStore = "TopSpeed_v11",
            Format = "Speed"
        },
        {
            Key = "Playtime",
            Model = "TopPlaytime",
            Stat = "Playtime",
            Store = "TopPlaytime_v12e",
            LegacyStore = "TopPlaytime_v11",
            Format = "Time"
        }
    }
}

function v1.GetBoard(v2) -- line 81 | captures: v1
    for v3, v4 in v1.Boards do
        if v4.Key == v2 then
            return v4
        end
    end
    return nil
end

local v5 = {}

v5[1] = Color3.fromRGB(255, 200, 0)
v5[2] = Color3.fromRGB(205, 214, 226)
v5[3] = Color3.fromRGB(205, 118, 45)
v1.RankTextColors = v5

function v1.RankTextColor(v6) -- line 106 | captures: v1
    return v1.RankTextColors[v6]
end

local function formatDuration(v7) -- line 116
    local v8 = math.floor(v7)
    local v9 = math.max(0, v8)
    local v10 = v9 // 86400
    local v11 = v9 % 86400 // 3600
    local v12 = v9 % 3600 // 60
    if v10 > 0 then
        return (("%*d %*h"):format(v10, v11))
    end
    if v11 > 0 then
        return (("%*h %*m"):format(v11, v12))
    end
    if v12 > 0 then
        return (("%*m"):format(v12))
    end
    return (("%*s"):format(v9))
end

function v1.FormatValue(v13, v14) -- line 134 | captures: FormatNumber, v1
    local v15 = v1.GetBoard(v13)
    local v16 = v15 and v15.Format
    if v16 == "Money" then
        return (("$%*"):format((FormatNumber.Short(v14))))
    end
    if v16 == "MoneyRate" then
        return (("$%*/s"):format((FormatNumber.Short(v14))))
    end
    if v16 == "Time" then
        local v17 = math.floor(v14)
        local v18 = math.max(0, v17)
        local v19 = v18 // 86400
        local v20 = v18 % 86400 // 3600
        local v21 = v18 % 3600 // 60
        if v19 > 0 then
            return (("%*d %*h"):format(v19, v20))
        end
        if v20 > 0 then
            return (("%*h %*m"):format(v20, v21))
        end
        if v21 > 0 then
            return (("%*m"):format(v21))
        end
        return (("%*s"):format(v18))
    end
    return FormatNumber.Short(v14)
end

return v1
