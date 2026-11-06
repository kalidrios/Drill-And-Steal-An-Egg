-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local t = {
	{
		Attribute = "Rank_Strength",
		Emoji = "\240\159\146\170",
		Color = "#FFAA33"
	},
	{
		Attribute = "Rank_Cash",
		Emoji = "\240\159\146\181",
		Color = "#4CD964"
	}
}

local function BuildPrefix(p1) --[[ BuildPrefix | Line: 14 | Upvalues: t (copy) ]]
	local v1 = ""

	for i, v in ipairs(t) do
		local v2 = tonumber(p1:GetAttribute(v.Attribute))

		if v2 and (v2 >= 1 and v2 <= 100) then
			v1 = v1 .. string.format("<font color=\"%s\">[%s #%d]</font> ", v.Color, v.Emoji, v2)
		end
	end

	return v1
end

function TextChatService.OnIncomingMessage(p1) --[[ Line: 28 | Upvalues: Players (copy), BuildPrefix (copy) ]]
	local TextChatMessageProperties = Instance.new("TextChatMessageProperties")
	local TextSource = p1.TextSource

	if not TextSource then
		return TextChatMessageProperties
	end

	local v1 = Players:GetPlayerByUserId(TextSource.UserId)

	if not v1 then
		return TextChatMessageProperties
	end

	local v2 = BuildPrefix(v1)

	if v2 ~= "" then
		TextChatMessageProperties.PrefixText = v2 .. p1.PrefixText
	end

	return TextChatMessageProperties
end