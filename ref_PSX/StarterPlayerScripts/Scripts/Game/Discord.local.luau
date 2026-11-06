--[[

	By: @pggondim
		
--]]

-- set discord link
_G.DiscordLink = 'Velvet'

--------|     Library     |--------
local _L = require(game:GetService("ReplicatedStorage"):WaitForChild("Library"))
while (not _L.Loaded) do  game:GetService("RunService").Heartbeat:Wait()  end

local save = _L.Save.Get()
repeat task.wait()
until save.PickedStarter == true 

task.delay(5, function()
	_L.Message.New("Remember to join our community! " .. _G.DiscordLink .. " :)")
end)