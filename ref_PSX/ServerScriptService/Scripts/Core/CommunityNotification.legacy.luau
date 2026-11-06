--------|     Setting     |--------

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do game:GetService("RunService").Heartbeat:Wait() end

--------|    Reference    |--------

--------|    Variables    |--------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

_L.Signal.Fired("Player Added"):Connect(function(plr)
	_G.HasLoaded(plr) _L.Network.Fire("Notification", plr, "Remember to join our Velvet community!", {time = 10, color = Color3.fromRGB(161, 98, 255), force = true})
end)


--[[ Last synced 9/21/2025 04:59                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--