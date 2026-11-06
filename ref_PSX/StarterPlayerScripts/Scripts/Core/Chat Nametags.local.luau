-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
if m_Library.TextChatService.ChatVersion ~= Enum.ChatVersion.TextChatService then return end
function m_Library.TextChatService.OnIncomingMessage(p1) -- Anonymous function at line 10
	local TextChatMessageProperties = Instance.new("TextChatMessageProperties");
	if p1.TextSource then
		local PlayerByUserId = game.Players:GetPlayerByUserId(p1.TextSource.UserId);
		if PlayerByUserId then
			local v1 = p1.PrefixText;
			local Attribute = PlayerByUserId:GetAttribute("ChatNameColor");
			if Attribute then
				v1 = string.format("<font color='#%s'>%s</font>", Attribute:ToHex(), v1);
			end
			local Attribute2 = PlayerByUserId:GetAttribute("ChatTag");
			if Attribute2 then
				local string_format_ret = string.format("[%s] ", Attribute2);
				local Attribute4 = PlayerByUserId:GetAttribute("ChatTagColor");
				if Attribute4 then
					string_format_ret = string.format("<font color='#%s'>%s</font>", Attribute4:ToHex(), string_format_ret);
				end
				v1 = string_format_ret .. v1;
			end
			TextChatMessageProperties.PrefixText = v1;
			local Attribute3 = PlayerByUserId:GetAttribute("ChatColor");
			if Attribute3 then
				TextChatMessageProperties.Text = string.format("<font color='#%s'>%s</font>", Attribute3:ToHex(), p1.Text);
			end
		end
	end
	return TextChatMessageProperties;
end
