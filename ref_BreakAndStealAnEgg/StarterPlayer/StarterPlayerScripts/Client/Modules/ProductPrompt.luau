-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestPlacePurchaseConfig = require(ReplicatedStorage.Shared.TestPlacePurchaseConfig)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local BindableEvent = Instance.new("BindableEvent")

v1.Finished = BindableEvent.Event
MarketplaceService.PromptProductPurchaseFinished:Connect(function(v2, v3, v4) -- line 38 | captures: BindableEvent
    BindableEvent:Fire(v2, v3, v4)
end)

function v1.Prompt(v5) -- line 45 | captures: MarketplaceService, ReplicatedStorage, TestPlacePurchaseConfig, LocalPlayer, BindableEvent
    if TestPlacePurchaseConfig.IsTestPlace() then
        task.spawn(function() -- line 51 | captures: v5, ReplicatedStorage, TestPlacePurchaseConfig, LocalPlayer, BindableEvent
            local v6 = ReplicatedStorage:WaitForChild(TestPlacePurchaseConfig.RemoteName, 5)
            local v7
            if v6 and v6:IsA("RemoteFunction") then
                local v8, v9 = pcall(v6.InvokeServer, v6, v5)
                v7 = v8 and v9 == true
                if not v8 then
                    warn((("[ProductPrompt] test place free purchase of %* failed: %*"):format(v5, v9)))
                end
            else
                warn("[ProductPrompt] test place free-purchase remote missing \226\128\148 is ReceiptService running?")
                v7 = false
            end
            BindableEvent:Fire(LocalPlayer.UserId, v5, v7)
        end)
    else
        MarketplaceService:PromptProductPurchase(LocalPlayer, v5)
    end
end

return v1
