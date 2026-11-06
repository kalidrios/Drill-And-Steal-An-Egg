--[[

	By: @pggondim
		
--]]

game.StarterPlayer.EnableMouseLockOption = false  
--------|     Library     |--------
local _L = require(game:GetService("ReplicatedStorage"):WaitForChild("Library"))
while (not _L.Loaded) do  game:GetService("RunService").Heartbeat:Wait()  end

_L.Network.Fired("Client Loading"):Connect(function(...)
    _L.GUIFX.Loading(...)
end)

_L.Network.Invoked("Auto Delete Enabled").OnInvoke = function()
    return _L.Variables.AutoDeleteEnabled
end
--game.Workspace["StreamingEnabled"] = false
