-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DemonEventConfig = require(ReplicatedStorage.Shared.DemonEventConfig)
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local AffordabilityFX = require(script.Parent.Parent.Parent.Controllers.AffordabilityFX)
local v1 = {}

local function find(v2, v3) -- line 25
    local v4 = v2
    for v5, v6 in v3 do
        v4 = v4 and v4:FindFirstChild(v6)
    end
    return v4
end

function v1.bind(v7) -- line 34 | captures: Players, ReplicatedStorage, DemonEventConfig, FormatNumber, AffordabilityFX
    local function v8(v9, ...)
        table.insert(v9, ...)
    end

    local function v10(v11, ...)
        table.insert(v11, ...)
    end

    local LocalPlayer = Players.LocalPlayer
    local Main = v7:WaitForChild("Main")
    local v12 = {}
    local v13 = Main
    for v14, v15 in { "CurrencyHolder", "QuantityLabel" } do
        v13 = v13 and v13:FindFirstChild(v15)
    end
    if v13 and v13:IsA("TextLabel") then
        local v16 = v13

        local function showBalance() -- line 42 | captures: LocalPlayer, v16, DemonEventConfig, FormatNumber
            local v17 = LocalPlayer:GetAttribute(DemonEventConfig.BalanceAttribute)
            local Commas = FormatNumber.Commas
            if typeof(v17) ~= "number" then
                v17 = 0
            end
            v16.Text = Commas(v17)
        end

        local v18 = LocalPlayer:GetAttribute(DemonEventConfig.BalanceAttribute)
        local Commas = FormatNumber.Commas
        if typeof(v18) ~= "number" then
            v18 = 0
        end
        v13.Text = Commas(v18)
        v8(v12, LocalPlayer:GetAttributeChangedSignal(DemonEventConfig.BalanceAttribute):Connect(showBalance))
    end
    local EggTabOffer = DemonEventConfig.EggTabOffer
    local v19 = DemonEventConfig.Eggs[EggTabOffer]
    for v20, v21 in { "EggTab", "Buy" } do
        Main = Main and Main:FindFirstChild(v21)
    end
    if v19 and Main and Main:IsA("GuiButton") then
        local v22 = Main
        for v23, v24 in { "PriceHolder", "Price" } do
            v22 = v22 and v22:FindFirstChild(v24)
        end
        if v22 and v22:IsA("TextLabel") then
            v22.Text = FormatNumber.Commas(v19.Price)
        end
        AffordabilityFX.Bind(Main, function() -- line 60 | captures: v19
            return v19.Price
        end, DemonEventConfig.BalanceAttribute)
        local Activated = Main.Activated
        v10(v12, Activated:Connect(function() -- line 63 | captures: EggTabOffer, ReplicatedStorage, DemonEventConfig
            local v25 = ReplicatedStorage:FindFirstChild(DemonEventConfig.RemoteName)
            if v25 and v25:IsA("RemoteEvent") then
                v25:FireServer("BuyEgg", EggTabOffer)
            end
        end))
    end
    return function() -- line 71 | captures: v12
        for v26, v27 in v12 do
            v27:Disconnect()
        end
        table.clear(v12)
    end
end

return v1
