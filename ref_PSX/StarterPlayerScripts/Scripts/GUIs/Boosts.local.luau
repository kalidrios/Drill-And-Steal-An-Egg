local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do  game:GetService("RunService").Heartbeat:Wait()  end


_L.Network.Fired("Boost Activated"):Connect(function(boost, _) 
	_L.Signal.Fire("Notification", boost .. " Boost activated!", {
		color = Color3.fromRGB(105, 255, 168),
		sound = "rbxassetid://7047600380"
	})
end)

_L.Network.Fired("Boost Ended"):Connect(function(boost)  
	local ask = _L.Message.New("Your " .. boost .. " Boost has expired. Would you like to renew?", true)
	if ask then
		_L.Signal.Fire("Exlusive Shop Tab", "Boosts")
	end
end)
