--------|     Setting     |--------

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do  game:GetService("RunService").Heartbeat:Wait()  end

--------|    Reference    |--------
-- Boosts é acessado via _L.Boosts (já carregado na Library do servidor)

--------|    Variables    |--------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Dar poção Super Lucky quando tutorial começa
_L.Network.Fired("GiveTutorialBoost"):Connect(function(player)
	local save = _L.Saving.Get(player)
	if not save then
		repeat task.wait(); save = _L.Saving.Get(player) until save
	end
	
	-- Só dá boost se ainda não completou o tutorial
	if save.HasCompletedTutorial then
		return
	end
	
	-- Dá uma poção Super Lucky para o player
	_L.Boosts.Give(player, "Super Lucky", 1)
	_L.Print("[Tutorial] Gave Super Lucky boost to: " .. player.Name)
	
	-- Notifica o cliente
	_L.Network.Fire("Notification", player, "You received a Super Lucky Potion!", {
		color = Color3.fromRGB(100, 255, 100)
	})
end)

_L.Network.Fired("FinishedTutorial"):Connect(function(player)
	
	local save = _L.Saving.Get(player)
	if not save then
		repeat task.wait(); save = _L.Saving.Get(player) until save
	end
	
	if save.HasCompletedTutorial then
		return
	end
	
	save.HasCompletedTutorial = true
	
	-- SIMULATOR: Tutorial completion handling
	_L.Print("Tutorial completed for player: " .. player.Name)
	
	-- Legacy Tycoon signal - kept for compatibility but may be unused
	_L.Signal.Fire("CancelCustomerYieldTime", player)
end)