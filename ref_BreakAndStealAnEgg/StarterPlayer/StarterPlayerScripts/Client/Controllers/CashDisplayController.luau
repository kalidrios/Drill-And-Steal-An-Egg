-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CountingNumber = require(ReplicatedStorage.Shared.CountingNumber)
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local Amount, Gain

function v1.Start() -- line 30 | captures: Amount, Gain, CountingNumber, FormatNumber, MainGui, LocalPlayer
    local v2 = CountingNumber.new(function(v3) -- line 33 | captures: Amount, FormatNumber
        if not (Amount and Amount.Parent) then
            return
        end
        local Short = FormatNumber.Short
        local v4 = v3 + 0.5
        local v5 = ("$%*"):format((Short((math.floor(v4)))))
        if Amount.Text ~= v5 then
            Amount.Text = v5
        end
    end)
    local v6 = CountingNumber.new(function(v7) -- line 41 | captures: Gain, FormatNumber
        if not (Gain and Gain.Parent) then
            return
        end
        local Short = FormatNumber.Short
        local v8 = v7 + 0.5
        local v9 = ("+$%*/s"):format((Short((math.floor(v8)))))
        if Gain.Text ~= v9 then
            Gain.Text = v9
        end
    end)

    local function readCash() -- line 50 | captures: LocalPlayer
        return LocalPlayer:GetAttribute("Cash") or 0
    end

    local function readIncome() -- line 53 | captures: LocalPlayer
        return LocalPlayer:GetAttribute("CashPerSecond") or 0
    end

    LocalPlayer:GetAttributeChangedSignal("Cash"):Connect(function() -- line 58 | captures: v2, LocalPlayer
        v2:Set(LocalPlayer:GetAttribute("Cash") or 0)
    end)
    LocalPlayer:GetAttributeChangedSignal("CashPerSecond"):Connect(function() -- line 61 | captures: v6, LocalPlayer
        v6:Set(LocalPlayer:GetAttribute("CashPerSecond") or 0)
    end)
    MainGui.Observe(function(v10) -- line 65 | captures: v2, v6, Amount, Gain, LocalPlayer
        local Currencies = v10:FindFirstChild("Currencies")
        local v11 = Currencies and Currencies:FindFirstChild("Cash")
        if v11 then
            local Amount_2 = v11:FindFirstChild("Amount")
            local Gain_2 = v11:FindFirstChild("Gain")
            if not (Amount_2 and Amount_2:IsA("TextLabel")) then
                Amount_2 = nil
            end
            Amount = Amount_2
            if not (Gain_2 and Gain_2:IsA("TextLabel")) then
                Gain_2 = nil
            end
            Gain = Gain_2
            v2:Snap(LocalPlayer:GetAttribute("Cash") or 0)
            v6:Snap(LocalPlayer:GetAttribute("CashPerSecond") or 0)
        else
            Amount = nil
            Gain = nil
        end
    end)
end

return v1
