local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
m_Library.Network.Invoked("Huge Pegasus Notification").OnInvoke = function() -- Line: 5
	local WaitForChild_ret = game.Players.LocalPlayer.PlayerGui:WaitForChild("Huge Pegasus Notification", 9999);
	WaitForChild_ret.Enabled = true;
	WaitForChild_ret.Frame.Ok.Activated:Connect(function() -- Line: 8
		--[[
			Upvalues:
				[1] = WaitForChild_ret
		--]]
		WaitForChild_ret:Destroy();
	end);
end
