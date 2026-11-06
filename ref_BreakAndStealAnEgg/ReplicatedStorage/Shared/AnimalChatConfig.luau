-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    TextLabelName = "TextLabel",
    BubbleRootName = "BubbleRoot",
    BubbleTailName = "BubbleTail",
    AttachmentName = "ChatBubbleAttachment",
    HeightAboveHead = 1,
    HeightAboveTop = 0.5,
    OverheadClearance = 0.4,
    StackedTolerance = 0.1,
    HeadAnchoredAttribute = "BubbleHeadAnchored",
    TemplateNames = { "ChatBubble", "Chat Bubble" },
    Bubble = {
        MinScale = 0.85,
        MaxScale = 2.2,
        AppearDelay = 1,
        PopTime = 0.3,
        DisplayTime = 5,
        FadeTime = 0.4,
        Size = {
            MinWidthScale = 0.2,
            MaxWidthScale = 1,
            MaxWidthMult = 2.5,
            TextHeightFraction = 0.55,
            SidePadding = 0.6
        }
    },
    Lines = {
        "Hi! \240\159\146\150",
        "Hi hi hi! \240\159\145\139",
        "You found me! \240\159\165\176",
        "Yay! \240\159\142\137",
        "Best day ever! \240\159\140\159",
        "I like you! \240\159\146\149",
        "Take me home? \240\159\165\186",
        "Can I stay? \240\159\165\186",
        "Hug? \240\159\164\151",
        "Pet me! \226\156\139",
        "Boop! \240\159\145\137",
        "Snack time? \240\159\152\139",
        "I'm hungry \240\159\141\170",
        "Food? Please? \240\159\141\142",
        "Let's play! \240\159\142\190",
        "Chase me! \240\159\146\168",
        "Wheee! \240\159\142\162",
        "Zoomies! \240\159\146\168",
        "Sleepy... \240\159\146\164",
        "Nap time \240\159\152\180",
        "Five more minutes \240\159\155\143\239\184\143",
        "I'm so soft \240\159\167\184",
        "Look how cute I am! \226\156\168",
        "Am I cute? Say yes \240\159\152\140",
        "I'm the cutest \240\159\145\145",
        "Sparkle sparkle \226\156\168",
        "Wanna be friends? \240\159\164\157",
        "We're besties now \240\159\146\171",
        "You're my favorite \240\159\146\155",
        "Don't leave me \240\159\165\186",
        "Missed you already \240\159\146\151",
        "Good job today! \240\159\143\134",
        "You're doing great \240\159\140\136",
        "Smile! \240\159\152\138",
        "Happy happy happy! \240\159\152\132",
        "Life is good \240\159\140\187",
        "So many eggs! \240\159\165\154",
        "That egg was comfy \240\159\165\154",
        "Fresh out the egg! \240\159\144\163",
        "I made it! \240\159\142\138",
        "Woo! Free at last \240\159\153\140",
        "Hello world! \240\159\140\141",
        "What's your name? \240\159\164\148",
        "Tell me a secret \240\159\164\171",
        "Shhh... I'm hiding \240\159\153\136",
        "Warm hugs only \240\159\148\165",
        "Heart go boom \240\159\146\147",
        "Love you lots \240\159\146\157",
        "Pocket sized joy \240\159\142\129",
        "Good vibes only \226\156\140\239\184\143"
    }
}

v1.Phrases = {}

function v1.PhraseFor(v2, v3) -- line 128 | captures: v1
    local v4 = v1.Phrases[v2]
    if not v4 or #v4 == 0 then
        v4 = v1.Lines
    end
    local v5
    if v3 then
        v5 = v3:NextInteger(1, #v4)
    else
        v5 = math.random(1, #v4)
    end
    return v4[v5]
end

return v1
