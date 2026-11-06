-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
if not m_Library.Shared.IsVoiceTradingPlaza or m_Library.RunService:IsStudio() then return end
function sendToFallbackServer() -- Line: 10
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local success, pcall_ret2 = pcall(m_Library.TeleportService.Teleport, m_Library.TeleportService, 6284583030, game.Players.LocalPlayer);
	if not success then
		task.spawn(error, pcall_ret2);
	end
end
task.spawn(function() -- Line: 17
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local IsVoiceEnabledForUserIdAsync_ret = nil;
	pcall(function() -- Line: 19
		--[[
			Upvalues:
				[1] = IsVoiceEnabledForUserIdAsync_ret
				[2] = m_Library
		--]]
		IsVoiceEnabledForUserIdAsync_ret = m_Library.VoiceChatService:IsVoiceEnabledForUserIdAsync(m_Library.LocalPlayer.UserId);
	end);
	if IsVoiceEnabledForUserIdAsync_ret == false then
		local success2, _ = pcall(function() -- Line: 24
			--[[
				Upvalues:
					[1] = m_Library
			--]]
			return m_Library.TeleportService:Teleport(m_Library.Shared.RealTradingId, game.Players.LocalPlayer);
		end);
		if not success2 then
			sendToFallbackServer();
		end
	end
end);
