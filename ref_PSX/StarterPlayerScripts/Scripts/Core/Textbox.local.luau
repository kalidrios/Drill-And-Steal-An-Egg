-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
m_Library.UserInputService.TextBoxFocused:Connect(function(textbox) -- Line: 19
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.Variables.Typing = true;
	if textbox:IsDescendantOf(m_Library.Player.Chat) then
		m_Library.Variables.Chatting = true;
	end
end);
m_Library.UserInputService.TextBoxFocusReleased:Connect(function(textbox2) -- Line: 27
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.Variables.Typing = false;
	if textbox2:IsDescendantOf(m_Library.Player.Chat) then
		m_Library.Variables.Chatting = false;
	end
end);
