-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    PlaceReach = 20,
    PlaceEdgeInset = 4,
    AutoSelectOnOpen = true,
    UseVirtualCursor = true,
    BackButton = Enum.KeyCode.ButtonB,
    SwingButton = Enum.KeyCode.ButtonR2,
    HotbarPreviousButton = Enum.KeyCode.ButtonL1,
    HotbarNextButton = Enum.KeyCode.ButtonR1,
    PlaceButtons = {
        Enum.KeyCode.ButtonX,
        Enum.KeyCode.ButtonY,
        Enum.KeyCode.ButtonB,
        Enum.KeyCode.ButtonL1,
        Enum.KeyCode.ButtonR1,
        Enum.KeyCode.ButtonL2,
        Enum.KeyCode.ButtonR2,
        Enum.KeyCode.DPadUp,
        Enum.KeyCode.DPadDown,
        Enum.KeyCode.DPadLeft,
        Enum.KeyCode.DPadRight
    },
    AutoSelectSkipNames = { Close = true },
    CursorToggleButton = Enum.KeyCode.ButtonR3
}
local v2 = {}

v2[Enum.UserInputType.Gamepad1] = true
v2[Enum.UserInputType.Gamepad2] = true
v2[Enum.UserInputType.Gamepad3] = true
v2[Enum.UserInputType.Gamepad4] = true
v2[Enum.UserInputType.Gamepad5] = true
v2[Enum.UserInputType.Gamepad6] = true
v2[Enum.UserInputType.Gamepad7] = true
v2[Enum.UserInputType.Gamepad8] = true

function v1.IsGamepadInput(v3) -- line 78 | captures: v2
    return v2[v3] == true
end

return v1
