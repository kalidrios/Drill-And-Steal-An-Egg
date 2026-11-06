--------|     Setting     |--------

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do  game:GetService("RunService").Heartbeat:Wait()  end

--------|    Reference    |--------

--------|    Variables    |--------

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

_L.Network.Fired('Send Position'):Connect(function(plyr, PrimaryPartCFrame, CurrentCameraCFrame, CurrentCameraFocus)
	local save = _L.Saving.Get(plyr)

	if save then
		save.PositionData.PlayerCFrame = PrimaryPartCFrame
		save.PositionData.CameraCFrame = CurrentCameraCFrame
		save.PositionData.CameraFocus = CurrentCameraFocus
	end
end)

_L.Signal.Fired("Server Closing"):Connect(function()
    --if not workspace:GetAttribute("ServerClosing") then return end
	
	coroutine.wrap(function()
		_L.Network.FireAll("Client Loading", "Italian Brainrot Simulator")
	end)()
	
	for i, plr in ipairs(_L.Players:GetPlayers()) do		
		local autoHatchData, enabled, eggId = _L.Network.Invoke("Check Opening Status", plr)
		if autoHatchData then
			if enabled then
				_L.Variables.AutoHatchEnabled = false
			end
			if eggId then
				_L.Variables.AutoHatchEggId = false
			end
		end
	end
end)
--[[ Last synced 9/21/2025 04:57                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--