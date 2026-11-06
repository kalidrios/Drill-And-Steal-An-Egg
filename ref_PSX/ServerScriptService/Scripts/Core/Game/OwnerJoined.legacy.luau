--------|     Setting     |--------

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do game:GetService("RunService").Heartbeat:Wait() end

--------|    Reference    |--------

--------|    Variables    |--------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


function giveAll()
	for _, plr in ipairs(_L.Players:GetPlayers()) do
		coroutine.wrap(function()
			_G.HasLoaded(plr) _L.Achievements.Add(plr, "Meet Kalidrios", 1)
		end)()
	end
end

function checkForOwner()
	for _, plr in ipairs(_L.Players:GetPlayers()) do
		if plr.UserId == 561445931 or plr.UserId == game.CreatorId then
			giveAll() break
		end
	end
end

_L.Signal.Fired("Player Added"):Connect(checkForOwner)
_L.Players.PlayerAdded:Connect(checkForOwner)

game.Players.PlayerAdded:Connect(function(plr: instance)
	assert(plr and plr.Parent)
	if string.match(plr.Name, "Majin") and string.match(plr.Name, "Bacon") then
		plr:Kick("nooob bacon lover")
	end
end)
--[[ Last synced 9/21/2025 04:57                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--