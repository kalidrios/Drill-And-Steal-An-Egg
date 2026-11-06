--------|     Setting     |--------
--local enabled = _L.Settings.PawTokensEvent
local waitTime = 60

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Library")) _L.Load()

--------|    Reference    |--------

--------|    Variables    |--------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

_L.Signal.Fired("Player Added"):Connect(function(plr: instance)
	local save = _L.Saving.Get(plr)
	assert(save)

	coroutine.wrap(function()
		while task.wait(waitTime) do
			assert(plr and plr.Parent)
			local character = plr.Character
			if character then
				_L.Orbs.Add(plr, character.HumanoidRootPart.Position, "Paw Tokens", 1, math.huge)
			end	
		end
	end)()
end)

--[[ Last synced 9/21/2025 04:58                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--