--[[
	                                                                
	
	-+-+-+- SPECIFICS -+-+-+-
	_L.Admins
	===========
	Admins of the game, as dictated by the Velvet Grup's group rankings. Use this module to easily distinguish if a player is an admin or not.
	Automatically updates and caches as necessary.
	===========
		\\\ Returns true if player is admin
		Admins.IsAdmin(
			player,					<--	|REQ|	Player instance 
		)
--]]
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--------|       Top       |--------
local Admins = {}

--------|     Setting     |--------

--------|     Library     |--------

--------|    Reference    |--------

--------|    Variables    |--------
local adminsCache = {}


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Admins.NewEntry = function(player)
    --- Create new (local) cache
    local cacheEntry = {}

    --- Check player's rank in Velvet Group's group
	local isInGroup = player:IsInGroup(1072042)
	if isInGroup then
		local Ranks = {1}
	end
	
	--- Player has admin capabilities?
	cacheEntry[1] = isInGroup
	cacheEntry[2] = tick()

	--- Update cache
	adminsCache[player.Name] = cacheEntry

	--
	return cacheEntry
end


Admins.IsAdmin = function(player)
	--- Sanity check
	if not player then
		return false
	end

	--- Haven't checked for this player before?
	if adminsCache[player.Name] == nil then
		local cacheEntry = Admins.NewEntry(player)
		return cacheEntry[1]
	end

	--- Been over 3 minutes since last update?
	local lastTick = adminsCache[player.Name][2]
	if tick() - lastTick >= 180 then
		--- It's been over 3 minutes! Update pls.
		local cacheEntry = Admins.NewEntry(player)
		return cacheEntry[1]
	end

	--- Return most updated result
	return adminsCache[player.Name][1]
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--- Clear admins cache of any useless info
local function ClearGarbage()
	for playerName, playerData in pairs(adminsCache) do
		local playerIsAdmin = playerData[1]
		local playerTick = playerData[2]
		local playerIsInServer = (game.Players:FindFirstChild(playerName))
		if not playerIsInServer and playerIsAdmin and (tick() - playerData[2]) >= 300 then
			adminsCache[playerName] = nil
		end
	end
end


--- Routinely check player cache for garbage
coroutine.wrap(function()
	while wait(180) do
		ClearGarbage()
	end
end)


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return Admins