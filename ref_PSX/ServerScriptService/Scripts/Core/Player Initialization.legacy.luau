--------|     Setting     |--------

--------|     Library     |--------

local Bans = require(game.ServerScriptService.Library.Bans)
local Functions = require(game.ReplicatedStorage.Library.Functions)

--------|    Reference    |--------
local remote = workspace:WaitForChild("__THINGS"):WaitForChild("__REMOTES"):WaitForChild("intro")

--------|    Variables    |--------

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

function remote.OnServerInvoke(player)
	local isBanned = Bans.IsBanned(player)
	local isWarned, warnTimer = Bans.IsWarned(player)

	if (not player) then
		return false
	end

	if isBanned or isWarned then
		return true, true, warnTimer
	end

	if player:FindFirstChild("__LOADED") then
		return true
	end

	if player.Character then
		local UpperTorso = player.Character:WaitForChild("UpperTorso", 9999)  
		if UpperTorso then
			UpperTorso.Anchored = false
		end
	end

	local loadedVar = Functions.QuickValue(true,player)
	loadedVar.Name = "__LOADED"
	loadedVar.Parent = player

	return true
end
--[[ Last synced 9/21/2025 04:58                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--