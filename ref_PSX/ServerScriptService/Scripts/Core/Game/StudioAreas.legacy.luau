-- | library | --
local _L = require(game.ReplicatedStorage.Library) _L.Load()

_L.Signal.Fired("Player Added"):Connect(function(player)
	if _L.RunService:IsStudio() then
		for area in pairs(_L.Directory.Areas) do
			_L.Worlds.GiveArea(player, area)
		end
		local save = _L.Saving.Get(player)
		
		if save then
			save.HackerPortalUnlocked = true
			save.Hardcore.HackerPortalUnlocked = true
		end
	end
end)
--[[ Last synced 9/21/2025 05:00                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--