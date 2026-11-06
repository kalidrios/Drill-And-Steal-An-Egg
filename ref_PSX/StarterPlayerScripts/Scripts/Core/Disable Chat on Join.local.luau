-- https://github.com/kalidrios
-- TextChatService compatibility: SetCore("ChatActive") não funciona mais

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end

-- Tenta usar o método novo (TextChatService) e o antigo como fallback
local TextChatService = game:GetService("TextChatService")
local chatWindowConfig = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")
if chatWindowConfig then
	chatWindowConfig.Enabled = false
else
	-- Fallback para LegacyChatService (se ainda estiver usando)
	pcall(function()
		game:GetService("StarterGui"):SetCore("ChatActive", false)
	end)
end
