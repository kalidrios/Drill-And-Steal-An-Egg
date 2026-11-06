--------|     Setting     |--------

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Library")) _L.Load()

--------|    Reference    |--------

--------|    Variables    |--------
_G.MoveCache = {}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Move(plr)
	_G.MoveCache[plr] = 0
	_L.Network.Fire("Move Time Change", plr, 0)
end

_L.Network.Fired("Move Server"):Connect(Move)
_L.Signal.Fired("Player Added"):Connect(function(plr)
	if not _G.MoveCache[plr] then
		_G.MoveCache[plr] = 0
	end
	coroutine.wrap(function()
		while _L.Heartbeat() do
			_G.MoveCache[plr] += 1
			_L.Network.Fire("Move Time Change", plr, _G.MoveCache[plr])
		end
	end)()
end)
--[[ Last synced 9/21/2025 04:58                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--