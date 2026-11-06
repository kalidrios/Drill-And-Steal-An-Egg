--------|     Setting     |--------
local resetReason = ""

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Library")) _L.Load()

--------|    Reference    |--------

--------|    Variables    |--------
local db = _L.DataStoreService:GetDataStore("Saves")

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if resetReason == "" then
	resetReason= "Unknown."
end

function getCurrentStatsVersion()
	return _L.Settings.StatsVersion
end

function update(plr)
	if not pcall(function()
			local v = getCurrentStatsVersion()
			db:SetAsync(tostring(plr.UserId), v)
		end) then
		return nil
	end
end

function get(plr)
	local s, r = pcall(function()
		return db:GetAsync(tostring(plr.UserId))
	end)
	
	if not s then
		return nil
	end
	
	if r == nil then
		pcall(function()
			update(plr)
		end)
		return getCurrentStatsVersion()
	end
	
	return r
end

_L.Signal.Fired("Player Added"):Connect(function(plr)
	local v = get(plr)
	if v then
		local stats = getCurrentStatsVersion()
		if v ~= stats then
			update(plr)
			coroutine.wrap(function()
				pcall(function()
					_L.Signal.Fire("Check Products", plr)
					_G.HasLoaded(plr) _L.Network.Fire("Notification", plr, "Global data has been reset.. :(", {time = 10, color = Color3.fromRGB(255, 0, 0), force = true})
					_L.Network.Fire("Notification", plr, "Reason: "..resetReason, {time = 10, color = Color3.fromRGB(255, 0, 0), force = true})
				end)
			end)()
		end
	end
end)
--[[ Last synced 9/21/2025 04:57                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--