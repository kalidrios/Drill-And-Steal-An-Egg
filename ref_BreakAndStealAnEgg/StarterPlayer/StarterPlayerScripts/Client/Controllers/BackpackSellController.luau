-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BackpackSellConfig = require(ReplicatedStorage.Shared.BackpackSellConfig)
local BackpackUiConfig = require(ReplicatedStorage.Shared.BackpackUiConfig)
local CountingNumber = require(ReplicatedStorage.Shared.CountingNumber)
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local BackpackController = require(script.Parent.BackpackController)
local BackpackSlotVisuals = require(script.Parent.Parent.Modules.BackpackSlotVisuals)
local v1 = {}
local v2 = false
local v3 = false
local v4 = {}
local Title, SellEnabled, Cancel, CashSellValue, v5
local v6 = CountingNumber.new(function(v7) -- line 51 | captures: v5, FormatNumber
    if not v5 then
        return
    end
    local v8 = v5
    local Short = FormatNumber.Short
    local v9 = v7 + 0.5
    v8.Text = ("$%*"):format((Short((math.floor(v9)))))
end)

local function totalValue() -- line 57 | captures: BackpackSellConfig, v4
    local v10 = 0
    for v11 in v4 do
        v10 += BackpackSellConfig.ToolValue(v11)
    end
    return v10
end

local function refreshChrome() -- line 65 | captures: v2, Title, SellEnabled, Cancel, CashSellValue, BackpackSellConfig, v4, v6
    if Cancel then
        Cancel.Visible = v2
    end
    if CashSellValue then
        CashSellValue.Visible = v2
    end
    if SellEnabled then
        SellEnabled.Enabled = v2
    end
    if Title then
        local Title_2 = Title
        if v2 then
            Title_2.Text = BackpackSellConfig.ConfirmText
        else
            Title_2.Text = BackpackSellConfig.SellText
        end
    end
    local v12 = 0
    for v13 in v4 do
        v12 += BackpackSellConfig.ToolValue(v13)
    end
    v6:Set(v12)
end

local function decorate(v14, v15) -- line 82 | captures: v2, BackpackSlotVisuals, v4
    local SetSellSelected = BackpackSlotVisuals.SetSellSelected
    local v16 = v2
    if v16 then
        if v14 == nil then
            v16 = false
        else
            v16 = v4[v14] == true
        end
    end
    SetSellSelected(v15, v16)
end

local function onClick(v17) -- line 88 | captures: v2, v3, Title, SellEnabled, Cancel, CashSellValue, BackpackSellConfig, BackpackController, v4, v6
    if not v3 and BackpackSellConfig.IsSellable(v17) then
        local v18
        if v4[v17] then
        else
            v18 = true
        end
        v4[v17] = v18
        if v4[v17] then
            BackpackController.UnequipIfHeld(v17)
        end
        BackpackController.RefreshDecorations()
        if Cancel then
            Cancel.Visible = v2
        end
        if CashSellValue then
            CashSellValue.Visible = v2
        end
        if SellEnabled then
            SellEnabled.Enabled = v2
        end
        if Title then
            local Title_2 = Title
            if v2 then
                Title_2.Text = BackpackSellConfig.ConfirmText
            else
                Title_2.Text = BackpackSellConfig.SellText
            end
        end
        local v19 = 0
        for v20 in v4 do
            v19 += BackpackSellConfig.ToolValue(v20)
        end
        v6:Set(v19)
    end
    return true
end

local function setSelling(v21) -- line 104 | captures: v2, Title, SellEnabled, Cancel, CashSellValue, BackpackSellConfig, BackpackController, v4, v6, onClick
    if v2 == v21 then
        return
    end
    v2 = v21
    table.clear(v4)
    v6:Snap(0)
    local SetClickInterceptor = BackpackController.SetClickInterceptor
    local v22 = if v21 then onClick else nil
    SetClickInterceptor(v22)
    BackpackController.RefreshDecorations()
    if Cancel then
        Cancel.Visible = v2
    end
    if CashSellValue then
        CashSellValue.Visible = v2
    end
    if SellEnabled then
        SellEnabled.Enabled = v2
    end
    if Title then
        local Title_2 = Title
        if v2 then
            Title_2.Text = BackpackSellConfig.ConfirmText
        else
            Title_2.Text = BackpackSellConfig.SellText
        end
    end
    local v23 = 0
    for v24 in v4 do
        v23 += BackpackSellConfig.ToolValue(v24)
    end
    v6:Set(v23)
end

local function pruneSelection() -- line 118 | captures: v2, Title, SellEnabled, Cancel, CashSellValue, BackpackSellConfig, BackpackController, v4, v6
    local v25 = false
    for v26 in v4 do
        if not BackpackController.HasTool(v26) then
            v4[v26] = nil
            v25 = true
        end
    end
    if not v25 then
        return
    end
    if Cancel then
        Cancel.Visible = v2
    end
    if CashSellValue then
        CashSellValue.Visible = v2
    end
    if SellEnabled then
        SellEnabled.Enabled = v2
    end
    if Title then
        local Title_2 = Title
        if v2 then
            Title_2.Text = BackpackSellConfig.ConfirmText
        else
            Title_2.Text = BackpackSellConfig.SellText
        end
    end
    local v27 = 0
    for v28 in v4 do
        v27 += BackpackSellConfig.ToolValue(v28)
    end
    v6:Set(v27)
end

local function getRemote() -- line 131 | captures: ReplicatedStorage, BackpackSellConfig
    local v29 = ReplicatedStorage:FindFirstChild(BackpackSellConfig.RemoteName)
    if not (v29 and v29:IsA("RemoteFunction")) then
        return nil
    end
    return v29
end

local function confirmSell() -- line 139 | captures: v2, v3, Title, SellEnabled, Cancel, CashSellValue, ReplicatedStorage, BackpackSellConfig, BackpackController, v4, v6
    local v30 = {}
    for v31 in v4 do
        table.insert(v30, v31)
    end
    if #v30 == 0 then
        if v2 ~= false then
            v2 = false
            table.clear(v4)
            v6:Snap(0)
            BackpackController.SetClickInterceptor(nil)
            BackpackController.RefreshDecorations()
            if Cancel then
                Cancel.Visible = v2
            end
            if CashSellValue then
                CashSellValue.Visible = v2
            end
            if SellEnabled then
                SellEnabled.Enabled = v2
            end
            if Title then
                local Title_2 = Title
                if v2 then
                    Title_2.Text = BackpackSellConfig.ConfirmText
                else
                    Title_2.Text = BackpackSellConfig.SellText
                end
            end
            local v32 = 0
            for v33 in v4 do
                v32 += BackpackSellConfig.ToolValue(v33)
            end
            v6:Set(v32)
        end
    else
        local v34 = ReplicatedStorage:FindFirstChild(BackpackSellConfig.RemoteName)
        if not (v34 and v34:IsA("RemoteFunction")) then
            v34 = nil
        end
        if v34 then
            v3 = true
            local v35, v36 = pcall(v34.InvokeServer, v34, v30)
            v3 = false
            if not v35 then
                warn((("[BackpackSellController] sell failed: %*"):format(v36)))
            end
            if v2 ~= false then
                v2 = false
                table.clear(v4)
                v6:Snap(0)
                BackpackController.SetClickInterceptor(nil)
                BackpackController.RefreshDecorations()
                if Cancel then
                    Cancel.Visible = v2
                end
                if CashSellValue then
                    CashSellValue.Visible = v2
                end
                if SellEnabled then
                    SellEnabled.Enabled = v2
                end
                if Title then
                    local Title_2 = Title
                    if v2 then
                        Title_2.Text = BackpackSellConfig.ConfirmText
                    else
                        Title_2.Text = BackpackSellConfig.SellText
                    end
                end
                local v37 = 0
                for v38 in v4 do
                    v37 += BackpackSellConfig.ToolValue(v38)
                end
                v6:Set(v37)
            end
        else
            warn("[BackpackSellController] sell remote missing")
        end
    end
end

local function calmHover(v39) -- line 166 | captures: BackpackUiConfig
    v39.AutoButtonColor = false
    v39:SetAttribute("HoverScale", BackpackUiConfig.HoverScale)
    v39:SetAttribute("PressScale", BackpackUiConfig.PressScale)
end

local function onSellPressed() -- line 172 | captures: v2, v3, Title, SellEnabled, Cancel, CashSellValue, BackpackSellConfig, BackpackController, v4, v6, onClick, confirmSell
    if not v3 then
        if v2 then
            confirmSell()
        elseif v2 ~= true then
            v2 = true
            table.clear(v4)
            v6:Snap(0)
            BackpackController.SetClickInterceptor(onClick)
            BackpackController.RefreshDecorations()
            if Cancel then
                Cancel.Visible = v2
            end
            if CashSellValue then
                CashSellValue.Visible = v2
            end
            if SellEnabled then
                SellEnabled.Enabled = v2
            end
            if Title then
                local Title_2 = Title
                if v2 then
                    Title_2.Text = BackpackSellConfig.ConfirmText
                else
                    Title_2.Text = BackpackSellConfig.SellText
                end
            end
            local v40 = 0
            for v41 in v4 do
                v40 += BackpackSellConfig.ToolValue(v41)
            end
            v6:Set(v40)
        end
    end
end

function v1.IsSelling() -- line 183 | captures: v2
    return v2
end

function v1.Start() -- line 187 | captures: v2, v3, Title, SellEnabled, Cancel, CashSellValue, v5, BackpackSellConfig, BackpackUiConfig, BackpackController, v4, v6, decorate, pruneSelection, onSellPressed
    local v42 = os.clock() + 60
    while true do
        if BackpackController.IsReady() then
            break
        end
        if v42 < os.clock() then
            warn("[BackpackSellController] backpack UI never came up \226\128\148 sell mode disabled")
            return
        end
        task.wait(0.1)
    end
    local v43 = BackpackController.GetInventoryFrame()
    if not v43 then
        return
    end
    local Sell = v43:FindFirstChild("Sell")
    if Sell and Sell:IsA("GuiButton") then
        local Title_2 = Sell:FindFirstChild("Title")
        if Title_2 then
            if not Title_2:IsA("TextLabel") then
                Title_2 = nil
            end
        else
            Title_2 = nil
        end
        Title = Title_2
        local SellEnabled_2 = Sell:FindFirstChild("SellEnabled")
        if not (SellEnabled_2 and SellEnabled_2:IsA("UIStroke")) then
            SellEnabled_2 = nil
        end
        SellEnabled = SellEnabled_2
        Sell.AutoButtonColor = false
        Sell:SetAttribute("HoverScale", BackpackUiConfig.HoverScale)
        Sell:SetAttribute("PressScale", BackpackUiConfig.PressScale)
        Sell.Activated:Connect(onSellPressed)
    else
        warn("[BackpackSellController] Inventory.Sell button not found")
    end
    local Cancel_2 = v43:FindFirstChild("Cancel")
    if Cancel_2 and Cancel_2:IsA("GuiButton") then
        Cancel = Cancel_2
        Cancel_2.AutoButtonColor = false
        Cancel_2:SetAttribute("HoverScale", BackpackUiConfig.HoverScale)
        Cancel_2:SetAttribute("PressScale", BackpackUiConfig.PressScale)
        Cancel_2.Activated:Connect(function() -- line 218 | captures: v2, v3, Title, SellEnabled, Cancel, CashSellValue, BackpackSellConfig, BackpackController, v4, v6
            if v3 then
                return
            end
            if v2 == false then
                return
            end
            v2 = false
            table.clear(v4)
            v6:Snap(0)
            BackpackController.SetClickInterceptor(nil)
            BackpackController.RefreshDecorations()
            if Cancel then
                Cancel.Visible = v2
            end
            if CashSellValue then
                CashSellValue.Visible = v2
            end
            if SellEnabled then
                SellEnabled.Enabled = v2
            end
            if Title then
                local Title_2 = Title
                if v2 then
                    Title_2.Text = BackpackSellConfig.ConfirmText
                else
                    Title_2.Text = BackpackSellConfig.SellText
                end
            end
            local v44 = 0
            for v45 in v4 do
                v44 += BackpackSellConfig.ToolValue(v45)
            end
            v6:Set(v44)
        end)
    end
    local CashSellValue_2 = v43:FindFirstChild("CashSellValue")
    if CashSellValue_2 and CashSellValue_2:IsA("GuiObject") then
        CashSellValue = CashSellValue_2
        local List = CashSellValue_2:FindFirstChild("List")
        local v46 = List and List:FindFirstChild("Amount")
        if not (v46 and v46:IsA("TextLabel")) then
            v46 = nil
        end
        v5 = v46
    end
    BackpackController.SetSlotDecorator(decorate)
    BackpackController.ObserveChanged(pruneSelection)
    v6:Snap(0)
    BackpackController.ObserveOpen(function(v47) -- line 236 | captures: v2, Title, SellEnabled, Cancel, CashSellValue, BackpackSellConfig, BackpackController, v4, v6
        if v47 then
            return
        end
        if v2 == false then
            return
        end
        v2 = false
        table.clear(v4)
        v6:Snap(0)
        BackpackController.SetClickInterceptor(nil)
        BackpackController.RefreshDecorations()
        if Cancel then
            Cancel.Visible = v2
        end
        if CashSellValue then
            CashSellValue.Visible = v2
        end
        if SellEnabled then
            SellEnabled.Enabled = v2
        end
        if Title then
            local Title_2 = Title
            if v2 then
                Title_2.Text = BackpackSellConfig.ConfirmText
            else
                Title_2.Text = BackpackSellConfig.SellText
            end
        end
        local v48 = 0
        for v49 in v4 do
            v48 += BackpackSellConfig.ToolValue(v49)
        end
        v6:Set(v48)
    end)
    if Cancel then
        Cancel.Visible = v2
    end
    if CashSellValue then
        CashSellValue.Visible = v2
    end
    if SellEnabled then
        SellEnabled.Enabled = v2
    end
    if Title then
        local Title_2 = Title
        if v2 then
            Title_2.Text = BackpackSellConfig.ConfirmText
        else
            Title_2.Text = BackpackSellConfig.SellText
        end
    end
    local v50 = 0
    for v51 in v4 do
        v50 += BackpackSellConfig.ToolValue(v51)
    end
    v6:Set(v50)
end

return v1
