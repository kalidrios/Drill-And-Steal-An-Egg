-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local HatchChatConfig = require(ReplicatedStorage.Shared.HatchChatConfig)
local v1 = {}

local function escape(v2) -- line 17
    return (v2:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;"):gsub("'", "&apos;"))
end

local function colored(v3, v4, v5) -- line 21
    local v6
    if v5 then
        v6 = ("<b>%*</b>"):format(v3)
    else
        v6 = v3
    end
    return (("<font color=\"%*\">%*</font>"):format(v4, v6))
end

local function rarityColor(v7) -- line 26 | captures: EggRewards, HatchChatConfig
    local v8 = EggRewards.RarityColors[v7]
    if v8 then
        return "#" .. v8:ToHex()
    end
    return HatchChatConfig.PetColor
end

local function article(v9) -- line 32
    if v9:sub(1, 1):lower():match("[aeiou]") then
        return "an"
    end
    return "a"
end

local function format(v10) -- line 36 | captures: EggRewards, HatchChatConfig, escape
    local v11 = escape(v10.Rarity)
    local v12 = {}
    local Rarity = v10.Rarity
    local v13 = EggRewards.RarityColors[Rarity]
    local v14 = if v13 then "#" .. v13:ToHex() else HatchChatConfig.PetColor
    v12[1] = ("<font color=\"%*\">%*</font>"):format(v14, (("<b>%*</b>"):format(v11)))
    if v10.Variant then
        local v15 = ("<font color=\"%*\">%*</font>"):format(HatchChatConfig.VariantColors[v10.Variant] or HatchChatConfig.PetColor, (("<b>%*</b>"):format((escape(v10.Variant)))))
        table.insert(v12, v15)
    end
    if v10.Mutation then
        local v16 = escape(v10.Mutation)
        local v17 = ("<font color=\"%*\">%*</font>"):format(v10.MutationColor or HatchChatConfig.PetColor, (("<b>%*</b>"):format(v16)))
        table.insert(v12, v17)
    end
    local v18 = escape(v10.Pet)
    local v19 = ("<font color=\"%*\">%*</font>"):format(HatchChatConfig.PetColor, (("<b>%*</b>"):format(v18)))
    table.insert(v12, v19)
    local v20
    if HatchChatConfig.Prefix == "" then
        v20 = ""
    else
        local v21 = escape(HatchChatConfig.Prefix)
        v20 = ("<font color=\"%*\">%*</font>"):format(HatchChatConfig.PrefixColor, (("<b>%*</b>"):format(v21))) .. " "
    end
    local v22 = "@" .. escape(v10.Name)
    local v23 = ("<font color=\"%*\">%*</font>"):format(HatchChatConfig.NameColor, (("<b>%*</b>"):format(v22)))
    local v24 = if v10.Rarity:sub(1, 1):lower():match("[aeiou]") then "an" else "a"
    local v25 = (" has hatched %* "):format(v24)
    return (("%*%*%*%*%*"):format(v20, v23, ("<font color=\"%*\">%*</font>"):format(HatchChatConfig.TextColor, v25), table.concat(v12, " "), (("<font color=\"%*\">!</font>"):format(HatchChatConfig.TextColor))))
end

local function isPayload(v26) -- line 56
    if type(v26) == "table" then
        local Name = v26.Name
        if type(Name) == "string" then
            local Pet = v26.Pet
            if type(Pet) == "string" then
                local Rarity = v26.Rarity
                return type(Rarity) == "string"
            end
        end
    end
    return false
end

function v1.Start() -- line 63 | captures: ReplicatedStorage, TextChatService, HatchChatConfig, format
    local v27 = ReplicatedStorage:WaitForChild(HatchChatConfig.RemoteName)
    local TextChannels = TextChatService:WaitForChild("TextChannels")
    v27.OnClientEvent:Connect(function(v28) -- line 66 | captures: TextChannels, HatchChatConfig, format
        local v29
        if type(v28) == "table" then
            local Name = v28.Name
            if type(Name) == "string" then
                local Pet = v28.Pet
                if type(Pet) == "string" then
                    local Rarity = v28.Rarity
                    v29 = type(Rarity) == "string"
                else
                    v29 = false
                end
            else
                v29 = false
            end
        else
            v29 = false
        end
        if v29 then
            local v30 = TextChannels:FindFirstChild(HatchChatConfig.ChannelName)
            if v30 and v30:IsA("TextChannel") then
                v30:DisplaySystemMessage((format(v28)))
            end
        end
    end)
end

return v1
