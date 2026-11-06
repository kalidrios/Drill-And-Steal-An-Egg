-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

return {
    RemoteName = "SettingsRemote",
    SaveFlushInterval = 0.5,
    ToggleOnText = "ON",
    ToggleOffText = "OFF",
    ToggleTweenDuration = 0.18,
    SfxRouteGroupName = "SfxRuntime",
    HellMutedSfxVolume = 1,
    Defaults = {
        MusicVolume = 1,
        SfxVolume = 1,
        ViewOthersPets = true,
        ViewMyPets = true,
        ViewMyEggs = true,
        ScreenFFX = true
    },
    SliderRows = { "MusicVolume", "SfxVolume" },
    ToggleRows = { "ViewOthersPets", "ViewMyPets", "ViewMyEggs", "ScreenFFX" },
    ToggleOffGradient = {
        Color3.fromRGB(213, 51, 51),
        Color3.fromRGB(255, 96, 63)
    },
    ToggleOffColor = Color3.fromRGB(230, 55, 55),
    ToggleTweenEasingStyle = Enum.EasingStyle.Back,
    ToggleTweenEasingDirection = Enum.EasingDirection.Out,
    SfxGroupNames = { "SFX", "UiSounds", "rransCustomSFX" }
}
