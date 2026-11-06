-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local AdminConfig = require(ReplicatedStorage.Shared.AdminConfig)
local EggRarity = require(ReplicatedStorage.Shared.EggRarity)
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local PotionConfig = require(ReplicatedStorage.Shared.PotionConfig)
local CountingNumber = require(ReplicatedStorage.Shared.CountingNumber)
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local AdminEditDropdown = require(script.Parent.AdminEditDropdown)
local RichWordTyper = require(script.Parent.RichWordTyper)
local UnitTextBox = require(script.Parent.UnitTextBox)
local AnimalTileStyle = require(script.Parent.AnimalTileStyle)
local NotificationController = require(script.Parent.Parent.Controllers.NotificationController)
local v1 = {}
local Gift = AdminConfig.Gift
local v2 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local function child(v3, v4) -- line 86
    if v3 then
        return (v3:FindFirstChild(v4))
    end
    return nil
end

local function textBoxIn(v5, v6) -- line 90
    local v7
    if v5 then
        v7 = v5:FindFirstChild(v6)
    end
    local v8
    if v7 then
        v8 = v7:FindFirstChild("TextBox")
    end
    if not (v8 and v8:IsA("TextBox")) then
        return nil
    end
    v8.ClearTextOnFocus = false
    return v8
end

local function stripUnit(v9, v10) -- line 103
    local v11 = string.lower(v10)
    local v12 = string.gsub(string.gsub(v9, "^%s+", ""), "%s+$", "")
    local lower = string.lower
    local v13 = -#v10
    if lower((string.sub(v12, v13))) == v11 then
        local v14 = #v12 - #v10
        v12 = string.sub(v12, 1, v14)
    end
    local lower_2 = string.lower
    local v15 = #v10
    if lower_2((string.sub(v12, 1, v15))) == v11 then
        local v16 = #v10 + 1
        v12 = string.sub(v12, v16)
    end
    return (string.gsub(string.gsub(v12, "^%s+", ""), "%s+$", ""))
end

local function unitBox(v17, v18) -- line 116 | captures: stripUnit
    if not v17 then
        return
    end
    v17.Focused:Connect(function() -- line 121 | captures: v17, v18, stripUnit
        v17.Text = stripUnit(v17.Text, v18)
    end)
    v17.FocusLost:Connect(function() -- line 124 | captures: v17, v18, stripUnit
        local v19 = stripUnit(v17.Text, v18)
        local v20 = if tonumber(v19) == nil then string.match(v19, "^%-?%d*%.?%d+%a%a?$") ~= nil else true
        if v19 ~= "" and v20 then
            v19 ..= v18
        end
        v17.Text = v19
    end)
end

local function setTitle(v21, v22) -- line 131
    local v23
    if v21 then
        v23 = v21:FindFirstChild("Title")
    end
    if v23 and v23:IsA("TextLabel") then
        v23.Text = v22
    end
end

local function shrinkOnHover(v24) -- line 138 | captures: AdminConfig
    if v24 and v24:IsA("GuiButton") then
        v24:SetAttribute("HoverScale", AdminConfig.PanelHoverScale)
        v24:SetAttribute("PressScale", AdminConfig.PanelPressScale)
    end
end

local function pop(v25) -- line 147 | captures: TweenService, v2
    local GiftPopScale = v25:FindFirstChild("GiftPopScale")
    if not (GiftPopScale and GiftPopScale:IsA("UIScale")) then
        GiftPopScale = Instance.new("UIScale")
        GiftPopScale.Name = "GiftPopScale"
        GiftPopScale.Parent = v25
    end
    GiftPopScale.Scale = 0.94
    TweenService:Create(GiftPopScale, v2, { Scale = 1 }):Play()
end

local v26 = {
    k = 1000,
    m = 1000000,
    b = 1000000000,
    t = 1000000000000
}
local v27 = Color3.new(1, 1, 1)
local v28 = Color3.new(0, 0, 0)

local function potionColor(v29) -- line 166 | captures: PotionConfig
    if v29 == "all" then
        return Color3.fromHex(PotionConfig.AllPotionsColor)
    end
    local v30 = PotionConfig.ById(v29)
    local fromHex = Color3.fromHex
    local v31 = if v30 then v30.Color else PotionConfig.HoverMultiplierColor
    return fromHex(v31)
end

local function potionParts(v32) -- line 175 | captures: PotionConfig
    if v32 == "all" then
        return "All", "Potions"
    end
    local v33 = PotionConfig.ById(v32)
    if v33 then
        return v33.HoverMultiplier, v33.HoverName
    end
    return "", v32
end

local function potionRowText(v34) -- line 187 | captures: PotionConfig, v27
    local v35, v36
    if v34 == "all" then
        v35 = "All"
        v36 = "Potions"
    else
        local v37 = PotionConfig.ById(v34)
        if v37 then
            v35, v36 = v37.HoverMultiplier, v37.HoverName
        else
            v35 = ""
            v36 = v34
        end
    end
    local v38
    if v34 == "all" then
        v38 = Color3.fromHex(PotionConfig.AllPotionsColor)
    else
        local v39 = PotionConfig.ById(v34)
        local fromHex = Color3.fromHex
        local v40 = if v39 then v39.Color else PotionConfig.HoverMultiplierColor
        v38 = fromHex(v40)
    end
    return (("<font color=\"#%*\">%*</font> %*"):format(v38:Lerp(v27, 0.6):ToHex(), v35, v36))
end

local function luminance(v41) -- line 193
    return 0.299 * v41.R + 0.587 * v41.G + 0.114 * v41.B
end

local function reshade(v42, v43, v44) -- line 200 | captures: v27, v28
    local function v45(v46, ...)
        table.insert(v46, ...)
    end

    local Keypoints = v42.Keypoints
    local v47 = 0
    for v48, v49 in Keypoints do
        local Value = v49.Value
        v47 += 0.299 * Value.R + 0.587 * Value.G + 0.114 * Value.B
    end
    local v50 = v47 / #Keypoints
    local v51 = table.create(#Keypoints)
    for v52, v53 in Keypoints do
        local Value = v53.Value
        local v54 = (0.299 * Value.R + 0.587 * Value.G + 0.114 * Value.B - v50) * v44
        local v55
        if v54 >= 0 then
            v55 = v43:Lerp(v27, (math.clamp(v54, 0, 0.6)))
        else
            local v56 = -v54
            v55 = v43:Lerp(v28, (math.clamp(v56, 0, 0.6)))
        end
        v45(v51, ColorSequenceKeypoint.new(v53.Time, v55))
    end
    return ColorSequence.new(v51)
end

local function copyStyle(v57, v58) -- line 222
    v58.BackgroundColor3 = v57.BackgroundColor3
    for v59, v60 in v57:GetChildren() do
        local v61 = v58:FindFirstChild(v60.Name)
        if v60:IsA("UIGradient") then
            if v61 then
                if v61:IsA("UIGradient") then
                    v61.Color = v60.Color
                elseif v60:IsA("UIStroke") and v61:IsA("UIStroke") then
                    v61.Color = v60.Color
                    local UIGradient = v60:FindFirstChildWhichIsA("UIGradient")
                    local UIGradient_2 = v61:FindFirstChildWhichIsA("UIGradient")
                    if UIGradient and UIGradient_2 then
                        UIGradient_2.Color = UIGradient.Color
                    end
                end
            else
                v60:IsA("UIStroke")
            end
        elseif v60:IsA("UIStroke") and v61 and v61:IsA("UIStroke") then
            v61.Color = v60.Color
            local UIGradient = v60:FindFirstChildWhichIsA("UIGradient")
            local UIGradient_2 = v61:FindFirstChildWhichIsA("UIGradient")
            if UIGradient and UIGradient_2 then
                UIGradient_2.Color = UIGradient.Color
            end
        end
    end
    local Title = v57:FindFirstChild("Title")
    local Title_2 = v58:FindFirstChild("Title")
    local v62 = Title and Title:FindFirstChildWhichIsA("UIStroke")
    local v63 = Title_2 and Title_2:FindFirstChildWhichIsA("UIStroke")
    if v62 and v63 then
        v63.Color = v62.Color
    end
end

local function paintButton(v64, v65) -- line 249 | captures: v27, v28, reshade
    v64.BackgroundColor3 = v27
    for v66, v67 in v64:GetChildren() do
        if v67:IsA("UIGradient") then
            v67.Color = reshade(v67.Color, v65, 1.6)
        elseif v67:IsA("UIStroke") then
            local v68
            if v67.Name == "Inner" then
                v68 = v65:Lerp(v27, 0.45)
            else
                v68 = v65:Lerp(v28, 0.6)
            end
            v67.Color = v68
            local UIGradient = v67:FindFirstChildWhichIsA("UIGradient")
            if UIGradient then
                UIGradient.Color = reshade(UIGradient.Color, v68, 1.2)
            end
        end
    end
    local Title = v64:FindFirstChild("Title")
    if not (Title and Title:IsA("TextLabel")) then
        return
    end
    Title.RichText = true
    local UIStroke = Title:FindFirstChildWhichIsA("UIStroke")
    if UIStroke then
        UIStroke.Color = v65:Lerp(v28, 0.7)
    end
end

local function sortedPool() -- line 273 | captures: EggRarity, EggRewards
    local v69 = table.clone(EggRewards.Pool)
    table.sort(v69, function(v70, v71) -- line 275 | captures: EggRarity
        local v72 = EggRarity.IndexOf(v70.Rarity) or 0
        local v73 = EggRarity.IndexOf(v71.Rarity) or 0
        if v72 == v73 then
            return v70.Name < v71.Name
        end
        return v72 < v73
    end)
    return v69
end

function v1.Bind(v74, v75, v76) -- line 286 | captures: ReplicatedStorage, AdminConfig, EggRarity, EggRewards, PotionConfig, CountingNumber, FormatNumber, AdminEditDropdown, RichWordTyper, UnitTextBox, AnimalTileStyle, NotificationController, Gift, stripUnit, unitBox, pop, v26, v27, potionColor, copyStyle, paintButton
    local v77 = {
        Dropdowns = {},
        Reset = function() -- Reset | line 287
        end
    }

    local function styleSource(v78) -- line 290 | captures: v76, Gift
        local v79 = Gift.StyleSources[v78]
        if v79 then
            local v80
            if v76 then
                v80 = v76:FindFirstChild("CommandsList")
            end
            local v81 = v79[1]
            local v82
            if v80 then
                v82 = v80:FindFirstChild(v81)
            end
            local v83
            if v82 then
                v83 = v82:FindFirstChild("Container")
            end
            local v84
            if v83 then
                v84 = v83:FindFirstChild("EditList")
            end
            local v85 = v79[2]
            local v86
            if v84 then
                v86 = v84:FindFirstChild(v85)
            end
            local v87
            if v86 then
                v87 = v86:FindFirstChild("Button")
            end
            if not (v87 and v87:IsA("GuiObject")) then
                return nil
            end
            return v87
        end
        return nil
    end

    local function applyStyle(v88, v89) -- line 300 | captures: styleSource, copyStyle
        local v90 = styleSource(v89)
        if v90 then
            copyStyle(v90, v88)
            return true
        end
        return false
    end

    local v91 = Gift.Sections.Potions
    local v92
    if v75 then
        v92 = v75:FindFirstChild(v91)
    end
    local v93 = Gift.Sections.Animals
    if v75 then
        v91 = v75:FindFirstChild(v93)
        v93 = v75:FindFirstChild("GiftType")
    else
        v91 = nil
        v93 = nil
    end
    local v94
    if v92 then
        v94 = v92:FindFirstChild("Edit")
    end
    local v95
    if v75 then
        v95 = v75:FindFirstChild("PotionEdit")
    end
    local v96
    if v91 then
        v96 = v91:FindFirstChild("AnimalSelect")
    end
    local v97, v98
    if v76 then
        v98 = v76:FindFirstChild("CommandsList")
        v97 = v76:FindFirstChild("AnimalSelectionList")
    end
    local v99 = {}
    local Template
    if v92 then
        Template = v92:FindFirstChild("Send")
    end
    local v100
    if v91 then
        v100 = v91:FindFirstChild("Send")
    end
    v99[1] = v93
    v99[2] = v94
    v99[3] = v96
    v99[4] = Template
    v99[5] = v100
    for v101, v102 in v99 do
        if v102 and v102:IsA("GuiButton") then
            v102:SetAttribute("HoverScale", AdminConfig.PanelHoverScale)
            v102:SetAttribute("PressScale", AdminConfig.PanelPressScale)
        end
    end
    local v103 = {}
    for v104, v105 in Gift.Sections do
        if v75 then
            Template = v75:FindFirstChild(v105)
        else
            Template = nil
        end
        if Template and Template:IsA("GuiObject") then
            v103[v104] = Template
        end
    end
    local v106 = Gift.DefaultType

    local function v107() -- line 331
    end

    local function v108() -- line 332
    end

    local function showSection(v109, v110) -- line 333 | captures: v106, v107, v108, v74, v103, pop
        v106 = v109
        v74:SetAttribute("GiftType", v109)
        v107()
        v108(v110)
        for v111, v112 in v103 do
            v112.Visible = v111 == v109
            if v111 == v109 and v110 then
                pop(v112)
            end
        end
    end

    showSection(v106, false)
    local v113
    if v93 and v93:IsA("GuiButton") then
        local v114
        if v75 then
            v114 = v75:FindFirstChild("EditList")
        end
        Template = AdminEditDropdown.Bind
        local v115 = v106

        function v113(v116) -- line 349 | captures: v106, v103, showSection
            if v103[v116] and v116 ~= v106 then
                showSection(v116, true)
            end
        end

        local v117 = { Toggle = v93 }
        if not (v114 and v114:IsA("GuiObject")) then
            v114 = nil
        end
        v117.List = v114
        Template = Template(v75, v115, v113, v117)
        if Template then
            local PanelHoverScale = v77.Dropdowns
            table.insert(PanelHoverScale, Template)
        end
    end
    local v118, v119, v120, fromHex, v121, v122, v123
    if v95 and v94 and v94:IsA("GuiButton") and v95:IsA("GuiObject") then
        Template = v95:FindFirstChild("Template")
        if Template and Template:IsA("GuiObject") then
            Template.Visible = false
            v100 = {}
            for v124, v125 in PotionConfig.Potions do
                v122 = v125.Id
                table.insert(v100, v122)
            end
            table.insert(v100, "all")
            for v126, v127 in v100 do
                if not v95:FindFirstChild(v127) then
                    v119 = Template:Clone()
                    v119.Name = v127
                    v119.LayoutOrder = Template.LayoutOrder + v126
                    v119.Visible = true
                    local Button = v119:FindFirstChild("Button")
                    local v128
                    if Button and Button:IsA("GuiObject") then
                        v122 = Gift.PotionStyles[v127]
                        if v122 then
                            v123 = styleSource(v122)
                            if v123 then
                                copyStyle(v123, Button)
                            else
                                v128 = styleSource("Green")
                                if v128 then
                                    copyStyle(v128, Button)
                                end
                                paintButton(Button, potionColor(v127))
                            end
                        else
                            v128 = styleSource("Green")
                            if v128 then
                                copyStyle(v128, Button)
                            end
                            paintButton(Button, potionColor(v127))
                        end
                        v128 = Button:FindFirstChild("Title")
                        if v128 and v128:IsA("TextLabel") then
                            v128.RichText = true
                        end
                    end
                    if v127 == "all" then
                        v128 = "All"
                        v123 = "Potions"
                    else
                        v120 = PotionConfig.ById(v127)
                        if v120 then
                            v128, v123 = v120.HoverMultiplier, v120.HoverName
                        else
                            v128 = ""
                            v123 = v127
                        end
                    end
                    local v129
                    if v127 == "all" then
                        v120 = Color3.fromHex(PotionConfig.AllPotionsColor)
                    else
                        v129 = PotionConfig.ById(v127)
                        fromHex = Color3.fromHex
                        if v129 then
                            v121 = v129.Color
                        else
                            v121 = PotionConfig.HoverMultiplierColor
                        end
                        v120 = fromHex(v121)
                    end
                    v129 = ("<font color=\"#%*\">%*</font> %*"):format(v120:Lerp(v27, 0.6):ToHex(), v128, v123)
                    if Button then
                        v128 = Button:FindFirstChild("Title")
                    else
                        v128 = nil
                    end
                    if v128 and v128:IsA("TextLabel") then
                        v128.Text = v129
                    end
                    v119.Parent = v95
                end
            end
        end
        v100 = AdminEditDropdown.Bind(v75, "", function(v130) -- line 401 | captures: v108, v118
            v118 = v130
            v108(true)
        end, {
            Setting = false,
            Direction = "Up",
            Toggle = v94,
            List = v95
        })
        if v100 then
            v113 = v77.Dropdowns
            table.insert(v113, v100)
        end
    end
    local v131
    local v132 = false
    local v133 = v97
    local v134 = v98

    local function showCommands(v135) -- line 414 | captures: v133, v134, pop
        if v133 and v133:IsA("GuiObject") then
            v133.Visible = false
        end
        if v134 and v134:IsA("GuiObject") then
            v134.Visible = true
            if v135 then
                pop(v134)
            end
        end
    end

    local function v136() -- line 426
    end

    local function pickAnimal(v137) -- line 427 | captures: v108, v131, v136, v133, v134, pop
        v131 = v137
        if v133 and v133:IsA("GuiObject") then
            v133.Visible = false
        end
        if v134 and v134:IsA("GuiObject") then
            v134.Visible = true
            pop(v134)
        end
        v136(true)
        v108(true)
    end

    local function buildTiles() -- line 434 | captures: v108, v131, v132, v136, v133, v134, EggRarity, EggRewards, AnimalTileStyle, pop
        if v132 or not v133 then
            return
        end
        v132 = true
        local Template = v133:FindFirstChild("Template")
        if Template and Template:IsA("GuiObject") then
            Template.Visible = false
            if v133:IsA("ScrollingFrame") then
                AnimalTileStyle.SetupGrid(v133)
            end
        else
            return
        end
        local v138 = table.clone(EggRewards.Pool)
        table.sort(v138, function(v139, v140) -- line 275 | captures: EggRarity
            local v141 = EggRarity.IndexOf(v139.Rarity) or 0
            local v142 = EggRarity.IndexOf(v140.Rarity) or 0
            if v141 == v142 then
                return v139.Name < v140.Name
            end
            return v141 < v142
        end)
        for v143, v144 in v138 do
            local v145 = Template:Clone()
            v145.Name = v144.Name
            v145.LayoutOrder = v143
            v145.Visible = true
            local Inner = v145:FindFirstChild("Inner")
            local v146
            if Inner then
                v146 = Inner:FindFirstChild("Name")
            end
            if v146 and v146:IsA("TextLabel") then
                v146.Text = EggRewards.DisplayName(v144.Name)
            end
            local v147
            if Inner then
                v147 = Inner:FindFirstChild("AnimalDisplay")
            end
            AnimalTileStyle.SetRender(v147, v144.Name)
            if Inner then
                if Inner:IsA("GuiObject") then
                    AnimalTileStyle.PaintBackground(Inner, v144.Rarity)
                    AnimalTileStyle.Prepare(Inner, v147)
                end
                if Inner:IsA("GuiButton") then
                    local Activated = Inner.Activated
                    local v148 = v144
                    Activated:Connect(function() -- line 466 | captures: v148, v108, v131, v136, v133, v134, pop
                        v131 = v148.Name
                        if v133 and v133:IsA("GuiObject") then
                            v133.Visible = false
                        end
                        if v134 and v134:IsA("GuiObject") then
                            v134.Visible = true
                            pop(v134)
                        end
                        v136(true)
                        v108(true)
                    end)
                end
            end
            v145.Parent = v133
        end
    end

    if v96 and v96:IsA("GuiButton") and v97 and v97:IsA("GuiObject") then
        local Activated = v96.Activated
        local v149 = v98
        local v150 = v97
        Activated:Connect(function() -- line 476 | captures: buildTiles, v149, v150, pop
            buildTiles()
            if v149 and v149:IsA("GuiObject") then
                v149.Visible = false
            end
            if v150:IsA("ScrollingFrame") then
                v150.CanvasPosition = Vector2.zero
            end
            v150.Visible = true
            pop(v150)
        end)
    end
    local v151 = Gift.DefaultGlobal
    v119 = v75:FindFirstChild(Gift.GlobalToggleName, true)
    if not (v119 and v119:IsA("GuiButton")) then
        v119 = nil
    end
    if v119 then
        v122 = v119:FindFirstChild("State")
    else
        v122 = nil
    end
    local v152 = v119
    local v153 = v122

    local function paintToggle() -- line 496 | captures: v151, styleSource, v152, v153, Gift, copyStyle
        if v152 then
            local v154 = if v151 then Gift.GlobalOnStyle else Gift.GlobalOffStyle
            local v155 = styleSource(v154)
            if v155 then
                copyStyle(v155, v152)
            end
        end
        if v153 and v153:IsA("TextLabel") then
            local v156 = if v151 then Gift.GlobalOnText else Gift.GlobalOffText
            v153.Text = v156
        end
    end

    if v119 then
        if v119:IsA("GuiButton") then
            v119:SetAttribute("HoverScale", AdminConfig.PanelHoverScale)
            v119:SetAttribute("PressScale", AdminConfig.PanelPressScale)
        end
        v123 = v119:FindFirstChild("Title")
        if v123 and v123:IsA("TextLabel") then
            v123.Text = "Global"
        end
        if v151 then
            v123 = Gift.GlobalOnStyle
        else
            v123 = Gift.GlobalOffStyle
        end
        v120 = styleSource(v123)
        if v120 then
            copyStyle(v120, v119)
        end
        if v122 and v122:IsA("TextLabel") then
            if v151 then
                v122.Text = Gift.GlobalOnText
            else
                v122.Text = Gift.GlobalOffText
            end
        end
        local Activated = v119.Activated
        local v157 = v119
        local v158 = v122
        Activated:Connect(function() -- line 508 | captures: v151, v74, styleSource, v157, v158, Gift, copyStyle
            v151 = not v151
            v74:SetAttribute("GiftGlobal", v151)
            if v157 then
                local v159 = if v151 then Gift.GlobalOnStyle else Gift.GlobalOffStyle
                local v160 = styleSource(v159)
                if v160 then
                    copyStyle(v160, v157)
                end
            end
            if v158 and v158:IsA("TextLabel") then
                local v161 = if v151 then Gift.GlobalOnText else Gift.GlobalOffText
                v158.Text = v161
            end
        end)
    end
    v74:SetAttribute("GiftGlobal", v151)

    function v107() -- line 516 | captures: v106, v152, Gift
        if v152 then
            local v162 = Gift.GlobalTypes[v106] == true
            v152.Visible = v162
        end
    end

    v107()
    local v163 = false

    local function send(v164) -- line 525 | captures: v106, v151, v163, ReplicatedStorage, AdminConfig, NotificationController, Gift
        if v163 then
            return
        end
        local v165 = ReplicatedStorage:FindFirstChild(AdminConfig.PanelRemotes.Gift)
        if v165 and v165:IsA("RemoteFunction") then
            local v166 = v151 and Gift.GlobalTypes[v106] == true
            v164.Global = v166
            v163 = true
            local v167, v168, v169 = pcall(function() -- line 537 | captures: v164, v165
                return v165:InvokeServer(v164)
            end)
            v163 = false
            if v167 and v168 == true then
                local Show = NotificationController.Show
                local v170 = if type(v169) == "string" then v169 else "{Gift} sent!"
                Show(v170, "Success")
            else
                if not (v167 and type(v169) == "string") then
                    v169 = "couldn't send the gift"
                end
                NotificationController.Show(("Gift failed: %*"):format(v169), "Error")
            end
        else
            NotificationController.Show("Gifting isn't ready yet", "Error")
        end
    end

    if v92 then
        v121 = v92:FindFirstChild("Username")
    else
        v121 = nil
    end
    if v121 then
        fromHex = v121:FindFirstChild("TextBox")
    else
        fromHex = nil
    end
    if not (fromHex and fromHex:IsA("TextBox")) then
        fromHex = nil
    else
        fromHex.ClearTextOnFocus = false
    end
    local Activated
    if v92 then
        Activated = v92:FindFirstChild("Duration")
    end
    if Activated then
        v121 = Activated:FindFirstChild("TextBox")
    else
        v121 = nil
    end
    if not (v121 and v121:IsA("TextBox")) then
        v121 = nil
    else
        v121.ClearTextOnFocus = false
    end
    UnitTextBox.Bind(v121, Gift.MinutesSuffix)
    local v171
    if v92 then
        v171 = v92:FindFirstChild("Send")
    end
    if v171 and v171:IsA("GuiButton") then
        Activated = v171.Activated
        local fromHex_2 = fromHex
        local v172 = v121
        Activated:Connect(function() -- line 554 | captures: v118, send, fromHex_2, v172, NotificationController
            if v118 then
                local spawn = task.spawn
                local v173 = { Kind = "Potion" }
                if fromHex_2 then
                    v173.Target = fromHex_2.Text
                else
                    v173.Target = ""
                end
                if v172 then
                    v173.Duration = v172.Text
                else
                    v173.Duration = ""
                end
                v173.Potion = v118
                spawn(send, v173)
            else
                NotificationController.Show("Pick a potion first (Edit)", "Error")
            end
        end)
    end
    local v174
    if v91 then
        v174 = v91:FindFirstChild("PlayerName")
    end
    local v175
    if v174 then
        v175 = v174:FindFirstChild("TextBox")
    end
    if not (v175 and v175:IsA("TextBox")) then
        v175 = nil
    else
        v175.ClearTextOnFocus = false
    end
    local v176
    if v91 then
        v176 = v91:FindFirstChild("AnimalWeight")
    end
    if v176 then
        v174 = v176:FindFirstChild("TextBox")
    else
        v174 = nil
    end
    if not (v174 and v174:IsA("TextBox")) then
        v174 = nil
    else
        v174.ClearTextOnFocus = false
    end
    local v177
    if v91 then
        v177 = v91:FindFirstChild("Amount")
    end
    if v177 then
        v176 = v177:FindFirstChild("TextBox")
    else
        v176 = nil
    end
    if not (v176 and v176:IsA("TextBox")) then
        v176 = nil
    else
        v176.ClearTextOnFocus = false
    end
    unitBox(v174, Gift.KgSuffix)
    unitBox(v176, Gift.AmountSuffix)
    local v178
    if v91 then
        v178 = v91:FindFirstChild("Template")
    end
    if v178 then
        v177 = v178:FindFirstChild("Inner")
    else
        v177 = nil
    end
    local v179, v180
    if v177 then
        v180 = v177:FindFirstChild("AnimalDisplay")
        v179 = v177:FindFirstChild("AnimalEarnings")
    end
    if not (v179 and v179:IsA("TextLabel")) then
        v179 = nil
    end
    if v177 and v177:IsA("GuiObject") then
        AnimalTileStyle.Prepare(v177, v180)
    end
    local new = CountingNumber.new
    local v181 = v179
    local v182 = new(function(v183) -- line 586 | captures: v181, FormatNumber
        if not v181 then
            return
        end
        local Short = FormatNumber.Short
        local v184 = v183 + 0.5
        v181.Text = ("$%*/s"):format((Short((math.floor(v184)))))
    end)
    v182:Snap(0)
    local v185 = v174

    local function previewKg(v186) -- line 595 | captures: v185, EggRewards, Gift, stripUnit, v26
        local v187
        if v185 then
            v187 = stripUnit(v185.Text, Gift.KgSuffix)
        else
            v187 = ""
        end
        local v188 = tonumber(v187)
        if not v188 then
            local v189, v190 = string.match(string.lower(v187), "^(%d*%.?%d+)(%a+)$")
            local v191 = v26[v190 or ""]
            if not v189 or not v191 then
                v188 = nil
            else
                v188 = tonumber(v189) * v191
            end
        end
        if v188 and v188 > 0 then
            return v188
        end
        local v192 = v186.Zone and EggRewards.ZoneEggs[("Zone%*"):format(v186.Zone)]
        local v193 = v192 and v192.Eggs[1]
        return EggRewards.KgForSize(EggRewards.EggBaseKgFor(v193, v186.Rarity), 1)
    end

    local v194 = v176

    local function previewAmount() -- line 612 | captures: v194, Gift, stripUnit
        local v195
        if v194 then
            v195 = stripUnit(v194.Text, Gift.AmountSuffix)
        else
            v195 = ""
        end
        local v196 = tonumber(v195)
        if not (v196 and v196 >= 1) then
            return 1
        end
        local v197 = math.floor(v196)
        local MaxAnimalAmount = Gift.MaxAnimalAmount
        return (math.min(v197, MaxAnimalAmount))
    end

    local function findEntry(v198) -- line 621 | captures: EggRewards
        for v199, v200 in EggRewards.Pool do
            if v200.Name == v198 then
                return v200
            end
        end
        return nil
    end

    local Name
    local v201 = v178
    local v202 = v180
    local v203 = v177

    function v136(v204) -- line 631 | captures: v131, Name, v182, previewKg, v194, v201, v202, v203, EggRewards, AnimalTileStyle, Gift, stripUnit, pop
        local v205
        if v131 then
            local v206 = v131
            local v207 = false
            for v208, v209 in EggRewards.Pool do
                if v209.Name == v206 then
                    v205 = v209
                    v207 = true
                    break
                end
            end
            if not v207 then
                v205 = nil
            end
        end
        if v201 and v201:IsA("GuiObject") then
            local v210 = v205 ~= nil
            v201.Visible = v210
        end
        if v205 then
            if v205.Name ~= Name then
                Name = v205.Name
                AnimalTileStyle.SetRender(v202, v205.Name)
                if v203 and v203:IsA("GuiObject") then
                    AnimalTileStyle.PaintBackground(v203, v205.Rarity)
                end
                if v204 and v201 and v201:IsA("GuiObject") then
                    pop(v201)
                end
            end
            local v211 = EggRewards.PlacedCashPerSecond(v205.Name, nil, nil, previewKg(v205))
            local v212
            if v194 then
                v212 = stripUnit(v194.Text, Gift.AmountSuffix)
            else
                v212 = ""
            end
            local v213 = tonumber(v212)
            local v214
            if not (v213 and v213 >= 1) then
                v214 = 1
            else
                local v215 = math.floor(v213)
                local MaxAnimalAmount = Gift.MaxAnimalAmount
                v214 = math.min(v215, MaxAnimalAmount)
            end
            v182:Set(v211 * v214)
        else
            v182:Snap(0)
        end
    end

    for v216, v217 in { v174, v176 } do
        if v217 then
            v217:GetPropertyChangedSignal("Text"):Connect(function() -- line 655 | captures: v136
                v136(false)
            end)
        end
    end
    v136(false)
    local v218
    if v75 then
        v218 = v75:FindFirstChild("ItemSelected")
    end
    local v219
    if not (v218 and v218:IsA("TextLabel")) then
    else
        v219 = RichWordTyper.new(v218)
    end
    local AnimalColor = Gift.AnimalColor
    local v220 = v218
    local v221 = v219

    function v108(v222) -- line 666 | captures: v106, v118, v131, AnimalColor, v220, v221, EggRewards, PotionConfig, pop, v27
        local v223 = false
        local v224 = false
        local v225 = false
        local v226 = false
        local v227 = false
        local v228 = false
        if v220 then
            v223 = true
        else
            v228 = true
        end
        if v223 then
            if v220:IsA("TextLabel") then
                v224 = true
            else
                v228 = true
            end
        end
        v223 = false
        if v224 then
            if v221 then
                v223 = true
            else
                v228 = true
            end
        end
        v224 = false
        local AnimalColor_2
        if v223 then
            AnimalColor_2 = AnimalColor
            if v106 == "Animals" then
                v224 = true
            else
                v225 = true
            end
        end
        v223 = false
        if v224 then
            if v131 then
                v223 = true
            else
                v225 = true
            end
        end
        v224 = false
        local v229, v230
        if v225 then
            if v106 == "Potions" then
                v224 = true
            else
                v230 = AnimalColor_2
                v228 = false
            end
        end
        v225 = false
        if v224 then
            if v118 then
                v225 = true
            else
                v230 = AnimalColor_2
                v228 = false
            end
        end
        v224 = false
        local v231
        if v225 then
            v231 = v118
            if v231 == "all" then
                v226 = true
            else
                v224 = true
            end
        end
        v225 = false
        local v232
        if v224 then
            v232 = PotionConfig.ById(v231)
            if v232 then
                v227 = true
            else
                v225 = true
            end
        end
        v224 = false
        local v233, v234
        if v225 then
            v233 = ""
            v234 = v231
            v224 = true
        end
        v225 = false
        if v227 then
            v233, v234 = v232.HoverMultiplier, v232.HoverName
            v224 = true
        end
        v227 = false
        if v226 then
            v233 = "All"
            v234 = "Potions"
            v224 = true
        end
        v226 = false
        if v224 then
            if v233 == "" then
                v225 = true
            else
                v227 = true
            end
        end
        v224 = false
        local v235
        if v227 then
            v235 = ("%* %*"):format(v233, v234)
            v224 = true
        end
        v227 = false
        if v225 then
            v235 = v234
            v224 = true
        end
        v225 = false
        local v236
        if v224 then
            v236 = v118
            if v236 == "all" then
                v227 = true
            else
                v225 = true
            end
        end
        v224 = false
        local v237, fromHex
        if v225 then
            v237 = PotionConfig.ById(v236)
            fromHex = Color3.fromHex
            if v237 then
                v226 = true
            else
                v224 = true
            end
        end
        v225 = false
        local v238
        if v224 then
            v238 = PotionConfig.HoverMultiplierColor
            v225 = true
        end
        if v226 then
            v238 = v237.Color
            v225 = true
        end
        v226 = false
        local v239
        if v225 then
            v239 = fromHex(v238)
            v226 = true
        end
        if v227 then
            v239 = Color3.fromHex(PotionConfig.AllPotionsColor)
            v226 = true
        end
        if v226 then
            v229, v230 = v235, v239:Lerp(v27, 0.15)
            v228 = false
        end
        if v223 then
            v229 = EggRewards.DisplayName(v131)
            v230 = AnimalColor_2
            v228 = false
        end
        if v228 then
            return
        end
        if v229 then
            local Visible = v220.Visible
            if Visible then
                v221:Set(v229, v230, not v222)
            else
                v221:Set(v229, v230, true)
                v220.Visible = true
            end
            if (Visible or v222) and not Visible then
                pop(v220)
            end
        else
            v220.Visible = false
        end
    end

    v108(false)
    local v240
    if v91 then
        v240 = v91:FindFirstChild("Send")
    end
    if v240 and v240:IsA("GuiButton") then
        local Activated = v240.Activated
        local v241 = v175
        local v242 = v174
        local v243 = v176
        Activated:Connect(function() -- line 697 | captures: v131, send, v241, v242, v243, NotificationController, Gift, stripUnit
            if v131 then
                local spawn = task.spawn
                local v244 = { Kind = "Animal" }
                if v241 then
                    v244.Target = v241.Text
                else
                    v244.Target = ""
                end
                v244.Animal = v131
                if v242 then
                    v244.Kg = stripUnit(v242.Text, Gift.KgSuffix)
                else
                    v244.Kg = ""
                end
                if v243 then
                    v244.Amount = stripUnit(v243.Text, Gift.AmountSuffix)
                else
                    v244.Amount = ""
                end
                spawn(send, v244)
            else
                NotificationController.Show("Select an animal first", "Error")
            end
        end)
    end

    function v77.Reset() -- line 712 | captures: v133, v134
        if v133 and v133:IsA("GuiObject") then
            v133.Visible = false
        end
        if v134 and v134:IsA("GuiObject") then
            v134.Visible = true
        end
    end

    return v77
end

return v1
