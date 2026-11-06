-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local MarketplaceService = game:GetService("MarketplaceService")
local ProductPrompt = require(script.Parent.Parent.Modules.ProductPrompt)
local PurchaseOverlay = require(script.Parent.PurchaseOverlay)
local PurchaseOverlayConfig = require(game:GetService("ReplicatedStorage").Shared.PurchaseOverlayConfig)
local v1 = {}
local v2 = ("<font face=\"BuilderSans\">%*</font>"):format((utf8.char(57346)))
local v3 = {}
local v4 = {}
local v5 = {}
local v6 = {}
local v7 = { __mode = "k" }
local v8 = setmetatable(v6, v7)
local v9 = {}
local v10 = { __mode = "k" }
local v11 = setmetatable(v9, v10)

local function stamp(v12, v13) -- line 60 | captures: v2, v11
    v12.RichText = true
    v12.Text = (v11[v12] or "") .. v2 .. tostring(v13)
end

local function fetchPrice(v14) -- line 67 | captures: MarketplaceService, v2, v3, v4, v8, v11
    local v15, v16 = pcall(function() -- line 68 | captures: v14, MarketplaceService
        return MarketplaceService:GetProductInfo(v14, Enum.InfoType.Product)
    end)
    local v17, v18
    if v15 and typeof(v16) == "table" then
        local PriceInRobux = v16.PriceInRobux
        local v19 = tonumber(PriceInRobux)
        if v19 then
            v17 = v19
            v18 = true
        else
            v18 = false
        end
    else
        v18 = false
    end
    if not v18 then
        v17 = nil
    end
    v3[v14] = v17 or false
    if not v17 then
        warn((("[RobuxPurchase] couldn't read the price of product %* \226\128\148 keeping the authored text"):format(v14)))
    end
    local v20 = v4[v14]
    v4[v14] = nil
    if v17 and v20 then
        for v21, v22 in v20 do
            if v22.Parent and v8[v22] == v14 then
                v22.RichText = true
                v22.Text = (v11[v22] or "") .. v2 .. tostring(v17)
            end
        end
    end
end

local function bindPriceLabel(v23, v24) -- line 90 | captures: v2, v3, v4, v8, v11, fetchPrice
    v8[v23] = v24
    if not (v24 <= 0) then
        local v25 = v3[v24]
        if v25 then
            v23.RichText = true
            v23.Text = (v11[v23] or "") .. v2 .. tostring(v25)
        else
            if v25 == false then
                v3[v24] = nil
            end
            local v26 = v4[v24]
            if v26 then
                table.insert(v26, v23)
            else
                v4[v24] = { v23 }
                task.spawn(fetchPrice, v24)
            end
        end
    end
end

function v1.Bind(v27, v28, v29) -- line 126 | captures: v1, bindPriceLabel
    if typeof(v28) ~= "number" then
        return
    end
    local v30 = v27:FindFirstChild(v29 or "Price")
    if v30 and v30:IsA("TextLabel") then
        bindPriceLabel(v30, v28)
    end
    v27.Activated:Connect(function() -- line 136 | captures: v28, v1
        v1.Prompt(v28)
    end)
end

function v1.StampPrice(v31, v32, v33) -- line 144 | captures: v11, bindPriceLabel
    v11[v31] = v33
    bindPriceLabel(v31, v32)
end

function v1.Unbind(v34) -- line 155 | captures: v8, v11
    v8[v34] = nil
    v11[v34] = nil
end

function v1.Prompt(v35) -- line 164 | captures: PurchaseOverlay, PurchaseOverlayConfig, v5
    local v36 = v5[v35]
    if v36 and os.clock() - v36 < PurchaseOverlayConfig.MaxVisibleSeconds then
        return true
    end
    v5[v35] = os.clock()
    if PurchaseOverlay.PromptProduct(v35) then
        return true
    end
    v5[v35] = nil
    return false
end

function v1.GetPrice(v37) -- line 183 | captures: v3
    local v38 = if typeof(v37) == "number" then v3[v37] else false
    if typeof(v38) == "number" then
        return v38
    end
    return nil
end

function v1.Start() -- line 188 | captures: ProductPrompt, v5
    ProductPrompt.Finished:Connect(function(v39, v40) -- line 193 | captures: v5
        v5[v40] = nil
    end)
end

return v1
