-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    Topic = "GlobalAnnouncement",
    RemoteName = "GlobalAnnouncement",
    MaxLength = 120,
    TemplateName = "GlobalAnnouncement",
    HoldTime = 6,
    MinHoldTime = 1,
    MaxHoldTime = 60
}

function v1.ClampHold(v2) -- line 31 | captures: v1
    if not (type(v2) == "number" and v2 == v2) then
        return v1.HoldTime
    end
    local MinHoldTime = v1.MinHoldTime
    local MaxHoldTime = v1.MaxHoldTime
    return (math.clamp(v2, MinHoldTime, MaxHoldTime))
end

v1.MaxOnScreen = 3
v1.ShowTween = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
v1.HideTween = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
v1.VerifiedBadge = utf8.char(57344)
v1.NameColors = {
    [9679848455] = BrickColor.new("Bright yellow").Color,
    [1247492319] = Color3.fromRGB(1, 162, 255)
}

local function HeadshotUrl(v3) -- line 60
    return (("rbxthumb://type=AvatarHeadShot&id=%*&w=150&h=150"):format(v3))
end

v1.HeadshotUrl = HeadshotUrl
v1.DropBelow = {
    {
        Path = { "BossHP" },
        Parts = { "BossHpBar", "Hp", "Shields" }
    }
}
v1.AvoidBelow = {
    {
        Gui = "HellBossDialogue",
        Path = { "BossDialogue" },
        Parts = {}
    }
}
v1.AvoidGap = 6
v1.GapBelow = { TitanicSpawn = 0.15 }
return v1
