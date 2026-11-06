-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BillboardAssets = require(ReplicatedStorage.Shared.BillboardAssets)
local StrokeColors = require(ReplicatedStorage.Shared.StrokeColors)
local v1 = {}
local v2 = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.4999, 0),
    NumberSequenceKeypoint.new(0.5, 1),
    NumberSequenceKeypoint.new(1, 1)
})
local v3 = {
    C = "Frame",
    N = "ProgressBar",
    P = {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, -14, 1, -14)
    },
    K = {
        {
            C = "Frame",
            N = "LeftGradient",
            P = {
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                Size = UDim2.new(0.5, 0, 1, 0)
            },
            K = {
                {
                    C = "ImageLabel",
                    N = "ProgressBarImage",
                    P = {
                        BackgroundTransparency = 1,
                        Image = "rbxasset://textures/ui/Controls/RadialFill.png",
                        Size = UDim2.new(2, 0, 1, 0)
                    },
                    K = {
                        {
                            C = "UIGradient",
                            N = "UIGradient",
                            P = {
                                Rotation = 180,
                                Transparency = v2
                            }
                        }
                    }
                }
            }
        },
        {
            C = "Frame",
            N = "RightGradient",
            P = {
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                Position = UDim2.new(0.5, 0, 0, 0),
                Size = UDim2.new(0.5, 0, 1, 0)
            },
            K = {
                {
                    C = "ImageLabel",
                    N = "ProgressBarImage",
                    P = {
                        BackgroundTransparency = 1,
                        Image = "rbxasset://textures/ui/Controls/RadialFill.png",
                        Position = UDim2.new(-1, 0, 0, 0),
                        Size = UDim2.new(2, 0, 1, 0)
                    },
                    K = {
                        {
                            C = "UIGradient",
                            N = "UIGradient",
                            P = { Transparency = v2 }
                        }
                    }
                }
            }
        },
        {
            C = "NumberValue",
            N = "Progress",
            P = {}
        }
    }
}
local v4 = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Medium)
local v5 = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Bold)

local function inputFrame(v6) -- line 105 | captures: v3
    return {
        C = "Frame",
        N = "InputFrame",
        P = {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            SizeConstraint = Enum.SizeConstraint.RelativeYY
        },
        K = {
            {
                C = "Frame",
                N = "Frame",
                P = {
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(1, 0, 1, 0)
                },
                K = {
                    {
                        C = "UIScale",
                        N = "UIScale",
                        P = {}
                    },
                    v3,
                    {
                        C = "ImageLabel",
                        N = "ButtonFrame",
                        P = {
                            BackgroundTransparency = 0.5,
                            Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
                            ImageTransparency = 1,
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            Size = UDim2.new(1, -24, 1, -24)
                        },
                        K = {
                            {
                                C = "UICorner",
                                N = "UICorner",
                                P = { CornerRadius = UDim.new(0.5, 0) }
                            }
                        }
                    },
                    {
                        C = "ImageLabel",
                        N = "ButtonImage",
                        P = {
                            BackgroundTransparency = 1,
                            Image = "rbxasset://textures/ui/Controls/key_single.png",
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            Size = UDim2.new(1, -44, 1, -42)
                        }
                    },
                    {
                        C = "ImageLabel",
                        N = "ButtonTextImage",
                        P = {
                            BackgroundTransparency = 1,
                            Image = "rbxasset://textures/ui/Controls/shift.png",
                            Visible = false,
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            Size = UDim2.new(1, -48, 1, -48)
                        }
                    },
                    {
                        C = "TextLabel",
                        N = "ButtonText",
                        P = v6
                    }
                }
            }
        }
    }
end

local function buttonText(v7, v8) -- line 167
    return {
        BackgroundTransparency = 1,
        Text = "E",
        FontFace = v7,
        Position = UDim2.new(0, 0, 0, -1),
        Size = UDim2.new(1, 0, 1, 0),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = v8
    }
end

local v9 = {
    C = "TextButton",
    N = "TextButton",
    P = {
        BackgroundTransparency = 1,
        TextTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0)
    }
}
local v10 = {
    Default = {
        C = "BillboardGui",
        N = "Default",
        P = {
            Active = true,
            AlwaysOnTop = true,
            Size = UDim2.new(0, 193, 0, 72)
        },
        K = {
            v9,
            {
                C = "ImageLabel",
                N = "PromptFrame",
                P = {
                    BackgroundTransparency = 0.3,
                    Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
                    ImageTransparency = 1,
                    BackgroundColor3 = Color3.fromRGB(20, 20, 22),
                    Size = UDim2.new(1, 0, 1, 0)
                },
                K = {
                    inputFrame((buttonText(v4, 14))),
                    {
                        C = "UICorner",
                        N = "UICorner",
                        P = { CornerRadius = UDim.new(0, 12) }
                    },
                    {
                        C = "TextLabel",
                        N = "ActionText",
                        P = {
                            BackgroundTransparency = 1,
                            RichText = true,
                            Text = "Action Text",
                            TextSize = 19,
                            FontFace = v5,
                            Position = UDim2.new(0.5, -24, 0, 9),
                            Size = UDim2.new(1, 0, 1, 0),
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            TextXAlignment = Enum.TextXAlignment.Left
                        },
                        K = {
                            {
                                C = "UIStroke",
                                N = "UIStroke",
                                P = { Color = StrokeColors.Neutral }
                            }
                        }
                    },
                    {
                        C = "TextLabel",
                        N = "ObjectText",
                        P = {
                            BackgroundTransparency = 1,
                            RichText = true,
                            Text = "Object Text",
                            TextSize = 14,
                            FontFace = v4,
                            Position = UDim2.new(0.5, -24, 0, -10),
                            Size = UDim2.new(1, 0, 1, 0),
                            TextColor3 = Color3.fromRGB(178, 178, 178),
                            TextXAlignment = Enum.TextXAlignment.Left
                        },
                        K = {
                            {
                                C = "UIStroke",
                                N = "UIStroke",
                                P = { Color = Color3.fromRGB(40, 40, 40) }
                            }
                        }
                    }
                }
            }
        }
    },
    Steal = {
        C = "BillboardGui",
        N = "Steal",
        P = {
            Active = true,
            AlwaysOnTop = true,
            Size = UDim2.new(0, 250, 0, 93)
        },
        K = {
            v9,
            {
                C = "ImageLabel",
                N = "PromptFrame",
                P = {
                    BackgroundTransparency = 0.35,
                    Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
                    ImageTransparency = 1,
                    BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0)
                },
                K = {
                    inputFrame((buttonText(v5, 24))),
                    {
                        C = "UICorner",
                        N = "UICorner",
                        P = { CornerRadius = UDim.new(0, 12) }
                    },
                    {
                        C = "TextLabel",
                        N = "ActionText",
                        P = {
                            BackgroundTransparency = 1,
                            RichText = true,
                            Text = "Action Text",
                            TextSize = 28,
                            FontFace = v5,
                            Position = UDim2.new(0.5, -24, 0, 9),
                            Size = UDim2.new(1, 0, 1, 0),
                            TextColor3 = Color3.fromRGB(255, 0, 0),
                            TextXAlignment = Enum.TextXAlignment.Left
                        },
                        K = {
                            {
                                C = "UIStroke",
                                N = "UIStroke",
                                P = {
                                    Thickness = 2,
                                    Color = StrokeColors.Neutral
                                }
                            }
                        }
                    },
                    {
                        C = "TextLabel",
                        N = "ObjectText",
                        P = {
                            BackgroundTransparency = 1,
                            RichText = true,
                            Text = "Object Text",
                            TextSize = 13,
                            FontFace = v5,
                            Position = UDim2.new(0.5, -24, 0, -10),
                            Size = UDim2.new(1, 0, 1, 0),
                            TextColor3 = Color3.fromRGB(178, 178, 178),
                            TextXAlignment = Enum.TextXAlignment.Left
                        },
                        K = {
                            {
                                C = "UIStroke",
                                N = "UIStroke",
                                P = {
                                    Thickness = 1.5,
                                    Color = StrokeColors.Neutral
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

local function build(v11) -- line 299 | captures: build
    local v12 = Instance.new(v11.C)
    v12.Name = v11.N
    for v13, v14 in pairs(v11.P) do
        v12[v13] = v14
    end
    if v11.K then
        for v15, v16 in ipairs(v11.K) do
            build(v16).Parent = v12
        end
    end
    return v12
end

local v17 = {
    "TextButton",
    "PromptFrame",
    "PromptFrame.ActionText",
    "PromptFrame.ObjectText",
    "PromptFrame.InputFrame.Frame.UIScale",
    "PromptFrame.InputFrame.Frame.ButtonFrame",
    "PromptFrame.InputFrame.Frame.ButtonImage",
    "PromptFrame.InputFrame.Frame.ButtonTextImage",
    "PromptFrame.InputFrame.Frame.ButtonText",
    "PromptFrame.InputFrame.Frame.ProgressBar.Progress",
    "PromptFrame.InputFrame.Frame.ProgressBar.LeftGradient.ProgressBarImage.UIGradient",
    "PromptFrame.InputFrame.Frame.ProgressBar.RightGradient.ProgressBarImage.UIGradient"
}
local v18 = false

local function resolvePath(v19, v20) -- line 342
    local v21 = v19
    for v22 in string.gmatch(v20, "[^%.]+") do
        if v21 == nil then
            return nil
        end
        v21 = v21:FindFirstChild(v22)
    end
    return v21
end

local ProximityPrompt

local function authoredTemplate() -- line 359 | captures: v18, ProximityPrompt, BillboardAssets, v17, resolvePath
    if not (ProximityPrompt and ProximityPrompt.Parent) then
        ProximityPrompt = nil
        local ProximityPrompt_2 = BillboardAssets.Find("ProximityPrompt")
        if ProximityPrompt_2 == nil then
            return nil
        end
        for v23, v24 in ipairs(v17) do
            if resolvePath(ProximityPrompt_2, v24) == nil then
                if not v18 then
                    v18 = true
                    warn((("[PromptThemes] ReplicatedStorage.Assets.BillboardGui.ProximityPrompt is missing \"%*\" - using built-in themes instead"):format(v24)))
                end
                return nil
            end
        end
        ProximityPrompt = ProximityPrompt_2
    end
    return ProximityPrompt
end

function v1.Create(v25) -- line 386 | captures: v10, build, authoredTemplate
    local v26 = authoredTemplate()
    if v26 == nil then
        local v27
        if v25 == nil then
        else
            v27 = v10[v25]
        end
        return (build(v27 or v10.Default))
    end
    return v26:Clone()
end

return v1
