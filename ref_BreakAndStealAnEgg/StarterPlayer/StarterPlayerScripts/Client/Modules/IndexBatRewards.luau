-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BatConfig = require(ReplicatedStorage.Shared.BatConfig)
local BatUnlock = require(ReplicatedStorage.Shared.BatUnlock)
local v1 = {}
local Unlock = BatConfig.Unlock
local v2 = {}
local v3 = { [BatConfig.DefaultTier] = true }
local v4 = BatConfig.DefaultTier
local v5 = {}
local v6
local v7 = false
local v8 = 0
local v9 = 0
local v10

function v10(v11, v12) -- line 77 | captures: v6, v8, v9, v10
    if not v6 then
        return
    end
    v8 += 1
    local v13 = v8
    v6:FireServer(v11, v12, v13)
    task.delay(1.5, function() -- line 84 | captures: v13, v8, v9, v10
        if v13 == v8 and v9 < v13 then
            v10("Get")
        end
    end)
end

local function setClaimFace(v14, v15) -- line 93
    local Claim = v14.Claim
    if not Claim then
        return
    end
    if v15 then
        Claim.BackgroundTransparency = v14.ClaimBackground
    else
        Claim.BackgroundTransparency = 1
    end
    for v16, v17 in v14.ClaimFace do
        v17.Visible = v15
    end
    for v18, v19 in v14.ClaimStrokes do
        v19.Enabled = v15
    end
end

local function paintRow(v20) -- line 107 | captures: v4, v5, BatConfig, BatUnlock, Unlock, v3
    local Amount = v20.Amount
    local Claim = v20.Claim
    local v21 = v3[v20.Tier] == true
    local v22 = BatUnlock.IsZoneComplete(v5, v20.Zone)
    if Amount then
        Amount.TextColor3 = v20.AmountColor
    end
    if v20.Tier == BatConfig.DefaultTier then
        if Claim then
            Claim.Visible = false
            Claim.Active = false
        end
    elseif v21 then
        local v23 = v4 == v20.Tier
        if Amount then
            if v23 then
                Amount.Text = Unlock.EquippedText
                Amount.TextColor3 = Unlock.EquippedColor
            else
                Amount.Text = Unlock.EquipText
            end
        end
        if Claim then
            local Claim_2 = v20.Claim
            if Claim_2 then
                Claim_2.BackgroundTransparency = 1
                for v24, v25 in v20.ClaimFace do
                    v25.Visible = false
                end
                for v26, v27 in v20.ClaimStrokes do
                    v27.Enabled = false
                end
            end
            Claim.Visible = true
            Claim.Active = true
        end
    elseif v22 then
        if Amount then
            Amount.Text = Unlock.ClaimText
        end
        if Claim then
            local Claim_2 = v20.Claim
            if Claim_2 then
                Claim_2.BackgroundTransparency = v20.ClaimBackground
                for v28, v29 in v20.ClaimFace do
                    v29.Visible = true
                end
                for v30, v31 in v20.ClaimStrokes do
                    v31.Enabled = true
                end
            end
            Claim.Visible = true
            Claim.Active = true
        end
    elseif Claim then
        Claim.Visible = false
        Claim.Active = false
    end
end

local function repaintAll() -- line 155 | captures: v2, paintRow
    for v32, v33 in v2 do
        paintRow(v33)
    end
end

local function onClick(v34) -- line 164 | captures: v4, v5, v10, BatConfig, BatUnlock, v2, v3, paintRow
    if v34.Tier ~= BatConfig.DefaultTier then
        if v3[v34.Tier] then
            if v4 == v34.Tier then
                if v34.Tier == BatConfig.DefaultTier then
                    return
                end
                v4 = BatConfig.DefaultTier
                v10("Unequip")
            else
                v4 = v34.Tier
                v10("Equip", v34.Tier)
            end
        elseif BatUnlock.IsZoneComplete(v5, v34.Zone) then
            v3[v34.Tier] = true
            v4 = v34.Tier
            v10("Claim", v34.Zone)
        else
            return
        end
        for v35, v36 in v2 do
            paintRow(v36)
        end
    end
end

local function ensureRemote() -- line 189 | captures: v4, v6, v7, v8, v9, v10, ReplicatedStorage, BatConfig, Unlock, v2, v3, paintRow
    if not v7 then
        v7 = true
        task.spawn(function() -- line 194 | captures: v4, v6, v8, v9, v10, ReplicatedStorage, BatConfig, Unlock, v2, v3, paintRow
            local v37 = ReplicatedStorage:WaitForChild(Unlock.RemoteName, 30)
            if not (v37 and v37:IsA("RemoteEvent")) then
                warn((("[IndexBatRewards] ReplicatedStorage.%* not found"):format(Unlock.RemoteName)))
            else
                v6 = v37
                v37.OnClientEvent:Connect(function(v38, v39) -- line 201 | captures: v4, v8, v9, BatConfig, v2, v3, paintRow
                    if not (v38 == "State" and typeof(v39) == "table") then
                        return
                    end
                    local Ack = v39.Ack
                    local v40 = typeof(Ack) == "number"
                    local v41
                    if v40 then
                        local v42 = v9
                        v9 = math.max(v42, Ack)
                        v41 = Ack < v8
                    end
                    if v40 and v41 then
                        return
                    end
                    table.clear(v3)
                    v3[BatConfig.DefaultTier] = true
                    local Owned = v39.Owned
                    if typeof(Owned) == "table" then
                        for v43, v44 in v39.Owned do
                            if typeof(v44) == "number" then
                                v3[v44] = true
                            end
                        end
                    end
                    v4 = BatConfig.ClampTier(v39.Equipped)
                    for v45, v46 in v2 do
                        paintRow(v46)
                    end
                end)
                v10("Get")
            end
        end)
    end
end

function v1.Reset() -- line 231 | captures: v4, v6, v7, v8, v9, v10, ReplicatedStorage, BatConfig, Unlock, v2, v3, paintRow
    table.clear(v2)
    if not v7 then
        v7 = true
        task.spawn(function() -- line 194 | captures: v4, v6, v8, v9, v10, ReplicatedStorage, BatConfig, Unlock, v2, v3, paintRow
            local v47 = ReplicatedStorage:WaitForChild(Unlock.RemoteName, 30)
            if not (v47 and v47:IsA("RemoteEvent")) then
                warn((("[IndexBatRewards] ReplicatedStorage.%* not found"):format(Unlock.RemoteName)))
            else
                v6 = v47
                v47.OnClientEvent:Connect(function(v48, v49) -- line 201 | captures: v4, v8, v9, BatConfig, v2, v3, paintRow
                    if not (v48 == "State" and typeof(v49) == "table") then
                        return
                    end
                    local Ack = v49.Ack
                    local v50 = typeof(Ack) == "number"
                    local v51
                    if v50 then
                        local v52 = v9
                        v9 = math.max(v52, Ack)
                        v51 = Ack < v8
                    end
                    if v50 and v51 then
                        return
                    end
                    table.clear(v3)
                    v3[BatConfig.DefaultTier] = true
                    local Owned = v49.Owned
                    if typeof(Owned) == "table" then
                        for v53, v54 in v49.Owned do
                            if typeof(v54) == "number" then
                                v3[v54] = true
                            end
                        end
                    end
                    v4 = BatConfig.ClampTier(v49.Equipped)
                    for v55, v56 in v2 do
                        paintRow(v56)
                    end
                end)
                v10("Get")
            end
        end)
    end
end

function v1.AttachSection(v57, v58) -- line 238 | captures: BatConfig, BatUnlock, v2, paintRow, onClick
    local function v59(...)
        return table.unpack(...)
    end

    local CompletionBar = v57:FindFirstChild("CompletionBar")
    if not CompletionBar then
        return
    end
    local BatDisplay = CompletionBar:FindFirstChild("BatDisplay")
    local Claim = CompletionBar:FindFirstChild("Claim")
    local Amount = CompletionBar:FindFirstChild("Amount")
    local v60 = BatUnlock.TierForZone(v58)
    local v61 = v60 and BatUnlock.TemplateFor(v60)
    local v62 = if v61 then v61.TextureId else ""
    if BatDisplay and BatDisplay:IsA("GuiObject") then
        if v60 == nil then
            BatDisplay.Visible = false
        else
            BatDisplay.Visible = v62 ~= ""
        end
        if v60 and v62 ~= "" then
            for v63, v64 in {
                    BatDisplay,
                    v59(BatDisplay:GetDescendants())
                } do
                if v64:IsA("ImageLabel") or v64:IsA("ImageButton") then
                    v64.Image = v62
                end
            end
            BatDisplay.Rotation = BatConfig.ImageRotationFor(v60)
        end
    end
    if v60 then
        local v65 = {}
        local v66 = {}
        if Claim then
            for v67, v68 in Claim:GetChildren() do
                if v68:IsA("GuiObject") then
                    table.insert(v65, v68)
                elseif v68:IsA("UIStroke") then
                    table.insert(v66, v68)
                end
            end
        end
        local v69 = {
            Zone = v58,
            Tier = v60
        }
        local Amount_2
        if not (Amount and Amount:IsA("TextLabel")) then
        else
            Amount_2 = Amount
        end
        v69.Amount = Amount_2
        local v70
        if not (Amount and Amount:IsA("TextLabel")) then
            v70 = Color3.new(1, 1, 1)
        else
            v70 = Amount.TextColor3
        end
        v69.AmountColor = v70
        local Claim_2
        if not (Claim and Claim:IsA("GuiButton")) then
        else
            Claim_2 = Claim
        end
        v69.Claim = Claim_2
        local v71 = if not (Claim and Claim:IsA("GuiObject")) then 0 else Claim.BackgroundTransparency
        v69.ClaimBackground = v71
        v69.ClaimFace = v65
        v69.ClaimStrokes = v66
        if v69.Claim then
            v69.Claim.Activated:Connect(function() -- line 297 | captures: v69, onClick
                onClick(v69)
            end)
        end
        table.insert(v2, v69)
        paintRow(v69)
    elseif Claim and Claim:IsA("GuiButton") then
        Claim.Visible = false
        Claim.Active = false
    end
end

function v1.Refresh(v72) -- line 307 | captures: v5, v2, paintRow
    v5 = v72
    for v73, v74 in v2 do
        paintRow(v74)
    end
end

return v1
