--------|     Setting     |--------

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Library")) _L.Load()

--------|    Reference    |--------

--------|    Variables    |--------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

_L.Network.Invoked("FFlags Commit").OnInvoke = function(plr, data)
	if not _L.FFlags.CanBypass(plr) then
		return false
	end
	
	for i, v in pairs(data) do
		pcall(function()
			_L.FFlags.Set(i, v)
		end)
	end
	
	return _L.FFlags.Commit(plr)
end

_L.Signal.Fired("FFlags Changed"):Connect(function(new)
	--pcall(function()
	--	_L.Network.FireAll("FFlags Changed", new)
	--end)
end) 
--[[ Last synced 9/21/2025 04:59                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--