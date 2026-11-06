-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local TweenService = game:GetService("TweenService")
local StrokePulse = require(script.Parent.Parent.Modules.StrokePulse)
local v1 = {}
local v2 = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

function v1.Attach(v4, v5) -- line 51 | captures: TweenService, StrokePulse, v2, v3
    local function v6(...)
        assert(...)
    end

    local Amount
    if v4 and v4:IsA("GuiObject") then
        Amount = v4:FindFirstChild("Amount")
        if Amount then
            if not Amount:IsA("TextLabel") then
                Amount = nil
            end
        else
            Amount = nil
        end
    else
        return nil
    end
    local HudBadgeScale = v4:FindFirstChild("HudBadgeScale")
    local HudBadgeScale_2 = HudBadgeScale
    if not (HudBadgeScale and HudBadgeScale:IsA("UIScale")) then
        HudBadgeScale = Instance.new("UIScale")
        HudBadgeScale.Name = "HudBadgeScale"
        HudBadgeScale.Parent = v4
        HudBadgeScale_2 = HudBadgeScale
    end
    v6(HudBadgeScale:IsA("UIScale"))
    v4.Visible = false
    local v7 = 0
    if not v4:GetAttribute("HudBadgeReminderLoop") then
        v4:SetAttribute("HudBadgeReminderLoop", true)
        task.spawn(function() -- line 80 | captures: v4, v5, StrokePulse, v3
            while true do
                if v4:IsDescendantOf(game) then
                    task.wait(15)
                    if v4:IsDescendantOf(game) then
                        if v4.Visible then
                            for v8 = 1, 2 do
                                local Spawn = StrokePulse.Spawn
                                local v9 = {
                                    Thickness = 2,
                                    EndScale = 2
                                }
                                v9.Color = v5 and v5.RingColor or v4.BackgroundColor3
                                v9.Tween = v3
                                Spawn(v4, v9)
                                if v8 < 2 then
                                    task.wait(0.45)
                                end
                            end
                        end
                        continue
                    end
                end
                break
            end
        end)
    end
    local Amount_2 = Amount
    return {
        SetCount = function(v10) -- setCount | line 103 | captures: HudBadgeScale_2, v7, v4, Amount_2, TweenService, v2
            local v11 = math.floor(v10)
            local v12 = math.max(v11, 0)
            if v12 == v7 then
                return
            end
            local v13 = v7 < v12
            v7 = v12
            if v12 <= 0 then
                v4.Visible = false
            else
                if Amount_2 then
                    Amount_2.Text = tostring(v12)
                end
                local v14 = not v4.Visible
                v4.Visible = true
                if v13 or v14 then
                    HudBadgeScale_2.Scale = 0
                    TweenService:Create(HudBadgeScale_2, v2, { Scale = 1 }):Play()
                end
            end
        end
    }
end

return v1
