-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    UseEnvironment = false,
    VFXFolderName = "EnvironmentVFXAdminAbuse1",
    LightingFolderName = "Lighting",
    SwapClasses = { "Sky" },
    LightingOverrides = {},
    Topic = "AdminAbuse",
    StateMap = "AdminAbuse",
    StateKey = "Active",
    MaxSeconds = 21600,
    EndedKey = "EndedAt",
    EndedMemorySeconds = 7200,
    StartedAtAttribute = "AdminAbuseStartedAt",
    MusicName = "AdminAbuseBackground",
    MusicFadeTime = 2,
    Color = "#FF3B3B"
}

v1.StartAnnouncement = ("started <font color=\"%*\">ADMIN ABUSE</font>!"):format(v1.Color)
v1.StartSubline = "The admins are unleashing chaos from above!"
v1.EndAnnouncement = ("ended <font color=\"%*\">ADMIN ABUSE</font>!"):format(v1.Color)
v1.EndSubline = "The skies are calm again."
v1.StartBannerHold = 15
v1.EndBannerHold = 8
v1.SublineDelay = 0.4
v1.Transition = {
    SkiesFolderName = "Skies",
    SkyName = "AdminAbuse",
    HideSun = true,
    VFXFolderName = "VFX",
    VFXName = "AdminAbuseVfx",
    PlayOnEnd = true,
    BlurSize = 24,
    FovIncrease = 25,
    EffectInTime = 2,
    EffectOutTime = 2,
    OverlayScale = 2,
    FadeInTime = 2,
    HoldTime = 1,
    FadeOutTime = 2,
    DisplayOrder = 110,
    EffectEasingStyle = Enum.EasingStyle.Sine,
    OverlayColor = Color3.fromRGB(255, 255, 255),
    FadeInEasingStyle = Enum.EasingStyle.Sine,
    FadeInEasingDirection = Enum.EasingDirection.In,
    FadeOutEasingStyle = Enum.EasingStyle.Sine,
    FadeOutEasingDirection = Enum.EasingDirection.Out
}
return v1
