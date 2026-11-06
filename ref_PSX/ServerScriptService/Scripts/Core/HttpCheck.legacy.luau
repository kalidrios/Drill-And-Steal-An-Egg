--------|     Setting     |--------

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Library")) _L.Load()

--------|    Reference    |--------

--------|    Variables    |--------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Send a test http request to test if HttpService is enabled
if httpEnabled == nil then 
	httpEnabled = pcall(function()  game:GetService("HttpService"):GetAsync("https://google.com")  end)
end

--  HttpService is disabled!
if not httpEnabled then
	_L.Print("HTTP ISNT ENABLED SOMETHINGS WONT WORK", true)
end
--[[ Last synced 9/21/2025 04:59                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--