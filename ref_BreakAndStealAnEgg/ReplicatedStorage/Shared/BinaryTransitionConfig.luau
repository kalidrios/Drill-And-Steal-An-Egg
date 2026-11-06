-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

return {
    COLUMNS = 20,
    SMALL_SCREEN_HEIGHT = 600,
    SMALL_SCREEN_COLUMNS = 30,
    EDGE_BLEED_COLUMNS = 2,
    TILE_GAP = -1,
    CORNER_RADIUS = 0,
    SHOW_DIGITS = false,
    TEXT_SIZE_RATIO = 0.45,
    FONT = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold),
    TILE_COLOR = Color3.fromRGB(8, 0, 0),
    DISPLAY_ORDER = 10000,
    EDGE_TEXT_COLOR = Color3.fromRGB(255, 240, 190),
    EDGE_STROKE_COLOR = Color3.fromRGB(255, 90, 20),
    EDGE_STROKE_THICKNESS = 1,
    EDGE_STROKE_TRANSPARENCY = 0.35,
    EDGE_GLOW_HEAT = 0.5,
    SETTLED_COLOR = Color3.fromRGB(255, 42, 26),
    SETTLED_COLOR_ALT = Color3.fromRGB(179, 0, 27),
    SETTLED_BRIGHTNESS_MIN = 0.7,
    SETTLED_TEXT_TRANSPARENCY = 0.1,
    SETTLE_TIME = 0.12,
    COVER_TIME = 1.4,
    DELAY_MAX = 0.35,
    SPEED_MIN = 0.06,
    SPEED_MAX = 0.12,
    POP_TIME = 0.08,
    POP_OVERSHOOT = 1.2,
    SPARK_CHANCE = 0.35,
    SPARK_ROWS_MIN = 2,
    SPARK_ROWS_MAX = 3,
    HOLD_TIME = 1.2,
    RESPAWN_HOLD_TIME = 0.2,
    SCENE_READY_TIMEOUT = 22,
    FLICKER_INTERVAL = 0.05,
    FLICKER_FRACTION = 0.08,
    FLICKER_FLASH_TIME = 0.03333333333333333,
    DEVIL_DIGIT = "6",
    DEVIL_DIGIT_CHANCE = 0.15,
    FIRE_STEP = 0.03333333333333333,
    FIRE_DECAY_MAX = 0.17,
    FIRE_WIND = 0,
    FIRE_IGNITE_TIME = 0.35,
    FIRE_DIE_TIME = 0.35,
    FIRE_FUEL_MIN = 0.85,
    FIRE_PALETTE = {
        {
            0,
            Color3.fromRGB(8, 0, 0)
        },
        {
            0.15,
            Color3.fromRGB(58, 0, 0)
        },
        {
            0.35,
            Color3.fromRGB(140, 0, 0)
        },
        {
            0.55,
            Color3.fromRGB(215, 30, 0)
        },
        {
            0.72,
            Color3.fromRGB(255, 95, 0)
        },
        {
            0.87,
            Color3.fromRGB(255, 175, 20)
        },
        {
            1,
            Color3.fromRGB(255, 240, 170)
        }
    },
    FIRE_DIGIT_COLOR = Color3.fromRGB(40, 0, 0),
    FIRE_DIGIT_CHAR = 1.6,
    IGNITE_SOUND_ID = "rbxassetid://103911273184692",
    IGNITE_VOLUME = 0.6,
    IGNITE_PITCH = 0.8,
    REVEAL_TIME = 1.4,
    REVEAL_DELAY_MAX = 0.3,
    REVEAL_SPEED_MIN = 0.05,
    REVEAL_SPEED_MAX = 0.1,
    SHRINK_TIME = 0.09,
    EMBER_HEAT = 0.75,
    REVEAL_EDGE_LEAD = 0.06,
    STRAGGLER_ROWS = 3,
    STRAGGLER_JITTER = 0.18,
    SFX_FOLDER = "SFX",
    TICK_SOUND = "TickSound",
    TICK_VOLUME = 0.12,
    TICK_MAX_PER_SECOND = 15,
    TICK_PITCH_MIN = 0.75,
    TICK_PITCH_MAX = 1.05,
    TICK_POOL = 4,
    WHOOSH_SOUND = "Swoosh",
    WHOOSH_VOLUME = 0.4,
    WHOOSH_PITCH = 0.55,
    BLUR_MAX = 40,
    BLUR_IN_TIME = 0.5,
    CAMERA_FOV_TARGET = 0,
    FOV_IN_TIME = 1.4,
    FOV_OUT_TIME = 2.4,
    FOV_IN_STYLE = Enum.EasingStyle.Quad,
    FOV_OUT_STYLE = Enum.EasingStyle.Quart,
    PREVIEW_KEY = Enum.KeyCode.T,
    REMOTE_NAME = "BinaryTransitionRemote",
    SERVER_COVER_GRACE = 1.5
}
